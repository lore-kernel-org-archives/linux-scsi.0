From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [patch] mpt2sas: issue reset is not uninitialized
Date: Wed, 3 Dec 2014 11:36:20 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1412031135410.2373@hadrien>
References: <20141203100941.GB29583@mwanda>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20141203100941.GB29583@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, quentin.lambert@inria.fr
List-Id: linux-scsi@vger.kernel.org

On Wed, 3 Dec 2014, Dan Carpenter wrote:

> The issue_reset variables were never set to zero.  This bug was found
> with static analysis.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 58e4521..98bd546 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -3236,7 +3236,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
>  	u16 smid;
>  	u32 ioc_state;
>  	unsigned long timeleft;
> -	u8 issue_reset;
> +	bool issue_reset = 0;

Why not false if it is going to be a boolean?

julia

>  	int rc;
>  	void *request;
>  	u16 wait_state_count;
> @@ -3341,7 +3341,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
>  	u16 smid;
>  	u32 ioc_state;
>  	unsigned long timeleft;
> -	u8 issue_reset;
> +	bool issue_reset = 0;
>  	int rc;
>  	void *request;
>  	u16 wait_state_count;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
