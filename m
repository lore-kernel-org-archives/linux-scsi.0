From: James Smart <james.smart@emulex.com>
Subject: Re: [RFC PATCH] scsi_transport_fc: Make sure commands are completed
 when rport is offline
Date: Wed, 10 Mar 2010 09:50:24 -0500
Message-ID: <4B97B1B0.1080802@emulex.com>
References: <1FB7DC5E34DADB499463B6EA89DF40A4638369F937@MNEXMB1.qlogic.org> <4B965E15.8040103@emulex.com> <1FB7DC5E34DADB499463B6EA89DF40A4638369F9EB@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:56023 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756664Ab0CJOur (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2010 09:50:47 -0500
In-Reply-To: <1FB7DC5E34DADB499463B6EA89DF40A4638369F9EB@MNEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarang Radke <sarang.radke@qlogic.com>
Cc: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

Acked-by:  James Smart  <james.smart@emulex.com>

-- james s


Sarang Radke wrote:
> James S./Fujita,
> 
> Thanks for the comments. The description of scenario was the one with which I noted the issue. But yes, the same would be true for any rport which is offline.
> 
> I am resending the patch with the suggested modifications.
> 
> -Thanks,
> Sarang
> 
>>From 84a1f847c71382f67f97ea956b2283cf6d737340 Mon Sep 17 00:00:00 2001
> From: Sarang Radke <sarang.radke@qlogic.com>
> Date: Tue, 9 Mar 2010 12:20:29 -0500
> Subject: [PATCH] Make sure commands are completed for offline rport
> 
> blk_end_request doesn't complete a bidi request
> successfully
> 
> The unfinished request eventually triggers a panic in
> timeout handling routine fc_bsg_job_timeout as
> req->special is NULL
> 
> Use blk_end_request_all to end the request unconditionally
> 
> Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
> ---
>  drivers/scsi/scsi_transport_fc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 79660ee..5819457 100644
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
> @@ -3862,7 +3862,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
>                 ret = fc_req_to_bsgjob(shost, rport, req);
>                 if (ret) {
>                         req->errors = ret;
> -                       blk_end_request(req, ret, blk_rq_bytes(req));
> +                       blk_end_request_all(req, ret);
>                         spin_lock_irq(q->queue_lock);
>                         continue;
>                 }
> --
> 1.5.6
