From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Wed, 12 Jun 2013 08:42:18 +0200
Message-ID: <51B8184A.6030303@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de>  <1370850058-27613-4-git-send-email-hare@suse.de>  <20130610082001.GB7816@infradead.org> <1370977067.2286.81.camel@dabdike> <51B81685.7020204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3FLGmU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jun 2013 02:42:20 -0400
In-Reply-To: <51B81685.7020204@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>

On 06/12/2013 08:34 AM, Bart Van Assche wrote:
> On 06/11/13 20:57, James Bottomley wrote:
>> Actually, I think we can dump the workqueue altogether.  The only
>> reason
>> we need it is because the current abort handlers wait for the comman=
d
>> and return the completion state.  However, all LLDs are capable of
>> emitting TMFs at interrupt level, so if we separated the emit from
>> the
>> wait, we could simply do this sequence:
>>
>> on timeout, fire the abort from interrupt and mark the command as
>> having
>> an abort issued (possibly by adding a pointer to the abort task),
>> return
>> BLK_EH_RESET_TIMER.
>>
>> Now if the timeout fires again, assume the abort was unsuccessful an=
d
>> escalate to LUN reset.
>>
>> This is fully asynchronous, fully tracked and doesn't rely on work
>> queues.
>>
>> The necessary additions for something like this are the from
>> interrupt
>> issue abort and LUN reset, which could just be additional
>> callbacks in
>> the host template.
>=20
> Do we really need a new callback in the host template for a command
> abort that does not wait ? Several LLDs already have their own
> internal data structures for keeping track of the request state and
> can use these data structures to set a flag "command has been
> aborted". If aborting a command fails and the command completes that
> flag can then be used to avoid a second invocation of scsi_done().
> At least, that's what the SRP initiator already does today in
> srp_abort().
>=20
Currently I'm playing around with this:

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4908480..498164a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -174,6 +174,9 @@ struct scsi_host_template {
        int (* eh_bus_reset_handler)(struct scsi_cmnd *);
        int (* eh_host_reset_handler)(struct scsi_cmnd *);

+       int (* eh_send_abort)(struct scsi_cmnd *);
+       void (* eh_cancel_abort)(struct scsi_cmnd *);
+
        /*

'eh_send_abort' sends the TMF asynchronously; it is the drivers
responsibility to return the command to be aborted to the SCSI
midlayer after calling this function.
The return value is 'SUCCESS' if the TMF was sent or 'FAILED' if
sending the TMF failed. It does _not_ indicate the status of the TMF
itself, as this is done implicitly by returning the command with an
appropriate status.

'eh_cancel_abort' is optional, and can be called at any time after
'eh_send_abort' to cancel the TMF. After calling 'eh_cancel_abort'
neither the TMF nor the command must be considered valid from the LLDD.
'eh_cancel_abort' is for LLDDs requiring cleanups when aborting
TMFs. LLDDs not requiring any cleanup simply can not implement this
callback.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
