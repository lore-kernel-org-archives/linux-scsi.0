From: James Smart <james.smart@emulex.com>
Subject: Re: [RFC PATCH] scsi_transport_fc: Make sure commands are completed
 when rport is offline
Date: Tue, 9 Mar 2010 09:41:25 -0500
Message-ID: <4B965E15.8040103@emulex.com>
References: <1FB7DC5E34DADB499463B6EA89DF40A4638369F937@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:29057 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753663Ab0CIOls (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2010 09:41:48 -0500
In-Reply-To: <1FB7DC5E34DADB499463B6EA89DF40A4638369F937@MNEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarang Radke <sarang.radke@qlogic.com>
Cc: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

I'm guessing your opening line describing the scenario wasn't correct. To 
match the patch, the request had to be issued when the rport is offline.
True ?

I think the change is fine, but the same change needs to be done a few lines 
lower when fc_req_to_bsgjob fails and blk_end_request() is called. Can you 
update the patch for this ?

-- james s


Sarang Radke wrote:
> A panic is seen when an ELS BSG request is send for rport which is online, but goes offline before the request is processed.
> 
> Here are the details of the issue and the fix.
> 
> . The request handler routine fc_bsg_handler checks if the rport is not online and tries to end the request by calling blk_end_request.
> . blk_end_request does not finish the request because it calls bidi_end_bidi_request with bidi_bytes = 0.
> . After 60 sec. the timeout handler, fc_bsg_job_timeout is invoked for this unfinished command.
> . A panic is seen in fc_bsg_job_timeout because req->special is NULL.
> . req->special  would have been set by function fc_req_to_bsgjob, if the rport was online.
> . The patch uses blk_end_request_all instead of blk_end_request which finishes the bidi request and timeout never happens.
> 
> 
> -Thanks,
> Sarang
> 
> Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
> ---
>  drivers/scsi/scsi_transport_fc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 79660ee..304e710 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3852,7 +3852,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
>                 if (rport && (rport->port_state != FC_PORTSTATE_ONLINE)) {
>                         req->errors = -ENXIO;
>                         spin_unlock_irq(q->queue_lock);
> -                       blk_end_request(req, -ENXIO, blk_rq_bytes(req));
> +                       blk_end_request_all(req, -ENXIO);
>                         spin_lock_irq(q->queue_lock);
>                         continue;
>                 }
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
