From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 5/9] drivers/scsi: Eliminate useless code
Date: Thu, 21 Jan 2010 16:16:32 -0800
Message-ID: <04391A4E90BB2149B010D22452FA16875F0348B0@HQ-EXCH-6.corp.brocade.com>
References: <Pine.LNX.4.64.1001161658410.28745@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:21208 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab0AVAQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2010 19:16:35 -0500
In-Reply-To: <Pine.LNX.4.64.1001161658410.28745@ask.diku.dk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel>

Acked-by: Jing Huang <huangj@brocade.com>

> -----Original Message-----
> From: Julia Lawall [mailto:julia@diku.dk]
> Sent: Saturday, January 16, 2010 7:59 AM
> To: Jing Huang; James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [PATCH 5/9] drivers/scsi: Eliminate useless code
> 
> From: Julia Lawall <julia@diku.dk>
> 
> The variable bfa_itnim is initialized twice to the same (side effect-free)
> expression.  Drop one initialization.
> 
> A simplified version of the semantic match that finds this problem is:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @forall@
> idexpression *x;
> identifier f!=ERR_PTR;
> @@
> 
> x = f(...)
> ... when != x
> (
> x = f(...,<+...x...+>,...)
> |
> * x = f(...)
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/scsi/bfa/bfad_im.c          |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index f788c2a..37b0fa1 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -243,9 +243,8 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct
> scsi_cmnd *cmnd,
>  	struct bfa_itnim_s *bfa_itnim;
>  	bfa_status_t    rc = BFA_STATUS_OK;
> 
> -	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
>  	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
>  	if (!tskim) {
>  		BFA_DEV_PRINTF(bfad, BFA_ERR,
