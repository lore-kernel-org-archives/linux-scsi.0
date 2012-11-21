From: Hannes Reinecke <hare@suse.de>
Subject: Re: SCSI LLDs, the SCSI error handler and host resource lifetime
Date: Wed, 21 Nov 2012 08:19:41 +0100
Message-ID: <50AC808D.1060700@suse.de>
References: <50AB9286.8040403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2KUHTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:19:42 -0500
In-Reply-To: <50AB9286.8040403@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 11/20/2012 03:24 PM, Bart Van Assche wrote:
> Hello,
>
> If I interpret the SCSI error handler source code correctly then
> scsi_unjam_host() may proceed concurrently with scsi_remove_host().
> This means that the LLD eh_abort_handler callback may get invoked aft=
er
> scsi_remove_host() finished. At least the SRP initiator (ib_srp) clea=
ns
> up resources necessary for aborting commands as soon as
> scsi_remove_host() returns. That looks like a race condition to me. A=
s
> far as I can see it is only safe to clean up such resources after the
> EH thread has been stopped. Any opinions about adding an additional
> callback for this purpose in struct scsi_host_template ?
>
> Note: it doesn't look like a good idea to me to let scsi_remove_host(=
)
> wait until error recovery has finished since scsi_remove_host() may g=
et
> invoked from the context of a workqueue. If any work gets queued on t=
he
> same workqueue related to SCSI error handling letting scsi_remove_hos=
t()
> wait for the error handler to finish might result in a deadlock.
>
> The patch below is a request for comments patch that does not only ad=
d a
> callback to struct scsi_host_template but also fixes a (hard to trigg=
er)
> race condition in ib_srp: avoid that ib_destroy_cm_id() frees the IB =
RC
> connection while srp_send_tsk_mgmt() is using it.
>
Hmm.
This would still mean that the eh thread will run until finished.
Which can take _A LOT_ of time (we're speaking hours here).
I would rather have an additional return code in the various=20
scsi_try_XXX functions to terminate the loop quickly.

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
