From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi error handling thread and REQUEST SENSE
Date: Mon, 19 May 2014 10:32:50 +0200
Message-ID: <5379C1B2.2040600@suse.de>
References: <94D0CD8314A33A4D9D801C0FE68B402956F17E1F@G4W3202.americas.hpqcorp.net> <1400270713.3813.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030904020808050603020609"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbaESIcx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2014 04:32:53 -0400
In-Reply-To: <1400270713.3813.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030904020808050603020609
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/16/2014 10:05 PM, Ewan Milne wrote:
> On Fri, 2014-05-16 at 19:02 +0000, Elliott, Robert (Server Storage)
> wrote:
>> There is an issue with a command timeout followed by a failed
>> abort in the linux SCSI stack.
>
> This might explain some  odd crashes I've seen, where it looks like
> a command might have completed *long* after it should have timed out.
> I have a few questions, see below:
>
>>
>> After triggering a timeout on a command like:
>> [ 5454.196861] sd 2:0:0:1: [sds] Done: TIMEOUT
>> [ 5454.196863] sd 2:0:0:1: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
>> [ 5454.196866] sd 2:0:0:1: [sds] CDB: Mode Sense(10): 5a 00 03 00 00 00 00 00 04 00
>>
>> scsi_times_out() invokes scsi_abort_command():
>> [ 5454.196880] sd 2:0:0:1: [sds] scmd ffff880428963a70 abort scheduled
>>
>> and scmd_eh_abort_handler() tries to abort the command:
>> [ 5454.206828] sd 2:0:0:1: [sds] aborting command ffff880428963a70
>>
>> If the abort fails (with return value FAILED (0x2003 == 8195)):
>> [ 5454.206832] sd 2:0:0:1: [sds] scmd ffff880428963a70 abort failed, rtn 8195
>>
>> then scmd_eh_abort_handler() just gives up and expects the error
>> handler thread to deal with the problem.
>>
>> When that thread (scsi_error_handler()) wakes up later on, it finds
>> this command (and others) outstanding:
>> [ 5454.373581] scsi_eh_2: waking up 0/3/3
>> [ 5454.375037] sd 2:0:0:1: scsi_eh_prt_fail_stats: cmds failed: 1, cancel: 0
>> [ 5454.377332] sd 2:0:0:11: scsi_eh_prt_fail_stats: cmds failed: 2, cancel: 0
>> [ 5454.379779] Total of 3 commands on 2 devices require eh work
>>
>> For each command, it starts with this check:
>>
>> #define SCSI_SENSE_VALID(scmd) \
>>          (((scmd)->sense_buffer[0] & 0x70) == 0x70)
>>
>>                  if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
>>                      SCSI_SENSE_VALID(scmd))
>>                          continue;
>>
>> In this case, that if statement fails.  The eflags bit is not
>> set, and the sense data buffer still contains zeros or garbage -
>> the command is still outstanding, so the buffer might be written
>> at any time.
>>
>> (the sense buffer shouldn't be read unless a valid bit says
>> it's filled in, and this lacks support for descriptor format
>> sense data (type 0x72), but those are side issues)
>
> Doesn't the check for:   (byte[0] & 0x70) == 0x70   cover 0x70 - 0x73?
>
>>
>> Strangely, the error handler code (scsi_unjam_host()) proceeds
>> to send a REQUEST SENSE command and sees the resulting sense
>> key of NO SENSE:
>>
>> [ 5454.381659] sd 2:0:0:1: [sds] scsi_eh_2: requesting sense
>> [ 5454.383597] scsi_eh_done scmd: ffff880428963a70 result: 0
>> [ 5454.385457] sd 2:0:0:1: [sds] Done: UNKNOWN
>> [ 5454.387430] sd 2:0:0:1: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
>> [ 5454.390450] sd 2:0:0:1: [sds] CDB: Request Sense: 03 00 00 00 60 00
>> [ 5454.393497] scsi_send_eh_cmnd: scmd: ffff880428963a70, timeleft: 9998
>> [ 5454.395667] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
>> [ 5454.397842] sense requested for ffff880428963a70 result 0
>> [ 5454.399675] sd 2:0:0:1: [sds] Sense Key : No Sense [current]
>> [ 5454.402570] sd 2:0:0:1: [sds] Add. Sense: No additional sense information
>
> So, a command timed out, the abort didn't succeed, but a
> REQUEST SENSE completed normally?
>
> What kernel was this?  Did it have the change to issue the abort
> in the timeout handler rather than the EH thread?  It seems like
> it does, based on your description above.  However, I'm wondering
> because I have seen crashes on kernels both with and without that
> change.
>
>>
>> The bogus "UNKNOWN" print is being fixed by Hannes' logging
>> patch. It just means the REQUEST SENSE command was submitted
>> successfully.
>>
>> This device uses autosense, so REQUEST SENSE is not a valid way
>> to find out any information for the timed out command. There is
>> no contingent allegiance condition stalling the queue until
>> REQUEST SENSE comes along to collect the sense data - that
>> parallel SCSI concept went obsolete in SAM-3 revision 5 in
>> January 2003.
>>
>> The command is still outstanding; data transfers might still occur,
>> and a completion using its tag could still appear at any time.
>> However, the error handler declares that the command is done,
>> so all the buffers are freed and the tag is reused.
>>
>> The SCSI error handler needs to escalate this to a reset that
>> ensures that the command is no longer outstanding: ABORT
>> TASK (which already didn't work), ABORT TASK SET, LOGICAL
>> UNIT RESET, I_T NEXUS RESET, or hard reset.
>
> What is supposed to happen is that the EH will escalate and
> eventually reset the HBA if all else fails.  It definitely
> should not be returning the scmd if the LLD is still using it.
>
Well, problem here is that the 'REQUEST SENSE' command has two problems:
a) Most modern HBA (ie all non-SPI HBAs) use autosense, ie the sense 
code is returned with the command. So issuing 'REQUEST SENSE' here 
is pointless.
b) The sense code (when retrieved via 'REQUEST SENSE') relates to 
the most recently processed command (from the target perspective).
Which is a bit hard to make out, as by the time SCSI EH starts
several other commands might have been processed already, so any
sense we'd be retrieving most likely does not relate to the failed 
command.

I would propose to disable the 'REQUEST_SENSE' step as soon as the 
HBA is capable of autosensing. We requires us to add another flag
to the scsi_host field.

What about the attached patch? That should roughly do what's 
required here, right?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

--------------030904020808050603020609
Content-Type: text/x-patch;
 name="scsi-host-autosense.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi-host-autosense.patch"

>From 585c989a6534fba358de9783c8a410e10d31812b Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Mon, 19 May 2014 10:26:57 +0200
Subject: [PATCH] Add 'autosense' flag to scsi_host structure

Some HBAs support autosense, so we should skip the 'REQUEST SENSE'
step during SCSI EH.
This patch adds a 'autosense' flag to the scsi_host structure
and enables it for FC, iSCSI, and SAS HBAs.
Other HBAs should enable it once we figure out whether they
support autosense.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f17aa7a..db0abed 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1160,6 +1160,12 @@ int scsi_eh_get_sense(struct list_head *work_q,
 					     __func__));
 			break;
 		}
+		if (shost->autosense)
+			/*
+			 * don't request sense if the HBA supports autosense
+			 */
+			continue;
+
 		if (status_byte(scmd->result) != CHECK_CONDITION)
 			/*
 			 * don't request sense if there's no check condition
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index f80908f..2e7b4be 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -452,6 +452,8 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 		return -ENOMEM;
 	}
 
+	shost->autosense = true;
+
 	fc_bsg_hostadd(shost, fc_host);
 	/* ignore any bsg add error - we just can't do sgio */
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0102a2d..917f474 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1568,7 +1568,7 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 	memset(ihost, 0, sizeof(*ihost));
 	atomic_set(&ihost->nr_scans, 0);
 	mutex_init(&ihost->mutex);
-
+	shost->autosense = true;
 	iscsi_bsg_host_add(shost, ihost);
 	/* ignore any bsg add error - we just can't do sgio */
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1b68142..942f8e1 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -288,6 +288,7 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 	sas_host->next_target_id = 0;
 	sas_host->next_expander_id = 0;
 	sas_host->next_port_id = 0;
+	shost->autosense = true;
 
 	if (sas_bsg_initialize(shost, NULL))
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 94844fc..d2019e2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -485,6 +485,11 @@ struct scsi_host_template {
 	unsigned no_async_abort:1;
 
 	/*
+	 * True if the HBA support autosense
+	 */
+	unsigned autosense:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;

--------------030904020808050603020609--
