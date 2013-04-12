From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Fri, 12 Apr 2013 10:24:54 -0400
Message-ID: <alpine.WNT.2.00.1304121021250.4544@N5102REMCQXM4BS.qlogic.org>
References: <1358262138-13378-1-git-send-email-hare@suse.de> <51421272.2000706@linux.vnet.ibm.com> <51430C4A.7090308@suse.de> <5143130F.4090702@acm.org> <514315F7.4010101@redhat.com> <5143183B.1070300@acm.org> <514321FD.7090507@redhat.com> <51432503.5000703@acm.org>
 <51436DB0.8030406@cs.wisc.edu> <514372DC.40709@acm.org> <5146BDBD.3070408@suse.de> <5159F6E6.9030900@emulex.com> <515D1D2F.7050007@suse.de> <515EEA5F.3010709@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:38119 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557Ab3DLOZE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Apr 2013 10:25:04 -0400
In-Reply-To: <515EEA5F.3010709@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@emulex.com>
Cc: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>, "Bryn M. Reeves" <bmr@redhat.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <jbottomley@parallels.com>

Our testing of this patch has not shown any issues however I think we
would be more comfortable with this change if there was a callback back
into the LLDs that want to be notified of the rport state change so we
can sync up our internal fibre channel port structures.  AFAICT the
changes required to add the callback to your original patch are fairly
small...something along the lines of:

diff --git a/drivers/scsi/scsi_transport_fc.c
b/drivers/scsi/scsi_transport_fc.c
index f3bba1a..6d3bc06 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -959,6 +959,7 @@ store_fc_rport_port_state(struct device *dev,
        unsigned long flags;
        struct fc_rport *rport = transport_class_to_rport(dev);
        struct Scsi_Host *shost = rport_to_shost(rport);
+       struct fc_internal *i = to_fc_internal(shost->transportt);

        spin_lock_irqsave(shost->host_lock, flags);
        if (!strncmp(buf, "Blocked", 7)) {
@@ -968,6 +969,8 @@ store_fc_rport_port_state(struct device *dev,
                }
                spin_unlock_irqrestore(shost->host_lock, flags);
                fc_remote_port_delete(rport);
+               if (i->f->rport_state_change)
+                       i->f->rport_state_change(rport);
        } else if (!strncmp(buf, "Online", 6)) {
                if (rport->port_state != FC_PORTSTATE_BLOCKED) {
                        spin_unlock_irqrestore(shost->host_lock, flags);
@@ -999,6 +1002,8 @@ store_fc_rport_port_state(struct device *dev,
                        scsi_queue_work(shost, &rport->scan_work);
                        spin_unlock_irqrestore(shost->host_lock, flags);
                }
+               if (i->f->rport_state_change)
+                       i->f->rport_state_change(rport);
        } else
                return -EINVAL;

diff --git a/include/scsi/scsi_transport_fc.h
b/include/scsi/scsi_transport_fc.h
index b797e8f..71c3ec5 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -698,6 +698,12 @@ struct fc_function_template {
        int     (*bsg_request)(struct fc_bsg_job *);
        int     (*bsg_timeout)(struct fc_bsg_job *);

+       /*
+        * Allow low-level drivers to be notified of state change if they
want
+        * to be notified.
+        */
+       void    (*rport_state_change)(struct fc_rport *);
+
        /* allocation lengths for host-specific data */
        u32                             dd_fcrport_size;
        u32                             dd_fcvport_size;
--
1.7.6.1

On Fri, 5 Apr 2013, James Smart wrote:

> I understand your points. But you will need to contact the different LLD
> maintainers to ensure receiving a devloss_tmo_callbk() on an rport they
> had not called fc_remote_port_delete() for.  I know there's work on my
> side to validate it's ok.  First glance was ok, but..
>
> -- james s
>
>
> On 4/4/2013 2:26 AM, Hannes Reinecke wrote:
>> On 04/01/2013 11:06 PM, James Smart wrote:
>>> I think lpfc survives your rport state change as : part of the lld
>>> behavior on the callback, to clean up reference counts, is to abort
>>> all i/o that is outstanding to the rport.   So the ref checking not
>>> only protects lpfc from prematurely freeing a structure (my real
>>> concern), but also just happens to abort all i/o.  We got lucky.
>>>
>>> I still believe the I_T_nexus reset is the right way to solve this.
>>>
>> Yes, but this would be an even more intrusive patch.
>> And we would need to implement yet another callback into the LLDDs
>> which need to be implemented there, too.
>>
>> But for this to make any sense we would need to revamp the scsi
>> error handler, as the current problem is that error recovery takes
>> too long. Adding yet another callback will make the escalation chain
>> even longer.
>>
>> So yeah, in the long run I_T nexus reset is the correct way of doing
>> things, but in the short term I would opt to make port_state
>> writeable to simulate an I_T nexus reset.
>>
>> Cheers,
>>
>> Hannes
>
>
>

________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

