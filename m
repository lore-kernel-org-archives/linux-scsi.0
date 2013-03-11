From: Vijay Mohan Guvva <vmohan@Brocade.com>
Subject: RE: [patch] [SCSI] bfa: Use GFP_ATOMIC under spin_lock
Date: Mon, 11 Mar 2013 12:21:46 -0600
Message-ID: <51BD2AE8016AE441B63F5661159C990203A17E0D0C@BRM-EXCH-3.corp.brocade.com>
References: <20130308120115.GA18712@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130308120115.GA18712@longonot.mountain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Anil Gurumurthy <agurumur@Brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Friday, March 08, 2013 4:01 AM
> To: Anil Gurumurthy
> Cc: Vijay Mohan Guvva; James E.J. Bottomley; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch] [SCSI] bfa: Use GFP_ATOMIC under spin_lock
> 
> This is always called with spinlocks held so it should use GFP_ATOMIC.  The
> call tree is:
> 
> -> bfad_drv_start()
>    Takes spin_lock_irqsave(&bfad->bfad_lock, flags);
>    -> bfa_fcs_pbc_vport_init()
>       -> bfa_fcb_pbc_vport_create()
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index
> a5f7690..d144a06 100644
> --- a/drivers/scsi/bfa/bfad.c
> +++ b/drivers/scsi/bfa/bfad.c
> @@ -491,7 +491,7 @@ bfa_fcb_pbc_vport_create(struct bfad_s *bfad,
> struct bfi_pbc_vport_s pbc_vport)
>  	struct bfad_vport_s   *vport;
>  	int rc;
> 
> -	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
> +	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_ATOMIC);
>  	if (!vport) {
>  		bfa_trc(bfad, 0);
>  		return;

Changes looks good. Thanks for the patch.
Acked-by: Vijay Mohan Guvva <vmohan@Brocade.com>
