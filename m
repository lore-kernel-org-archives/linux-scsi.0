From: walter harms <wharms@bfs.de>
Subject: Re: [patch] mpt2sas: issue reset is not uninitialized
Date: Wed, 03 Dec 2014 15:14:08 +0100
Message-ID: <547F1AB0.30705@bfs.de>
References: <20141203100941.GB29583@mwanda>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20141203100941.GB29583@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Am 03.12.2014 11:09, schrieb Dan Carpenter:
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


hi Dan,
just a minor question:

did you forget to mention that you also changed from u8 to bool or was this unintentional ?

re,
 wh
