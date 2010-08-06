From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: RE: [PATCH 9/42] drivers/scsi: Adjust confusing if indentation
Date: Fri, 6 Aug 2010 17:42:37 +0800
Message-ID: <125A3006922D4D419060126ED7EE2E56@areca4e4f859d4>
References: <Pine.LNX.4.64.1008052219190.31692@ask.diku.dk> <20100806074920.GR9031@bicker>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100806074920.GR9031@bicker>
Sender: linux-kernel-owner@vger.kernel.org
To: 'Dan Carpenter' <error27@gmail.com>, 'Julia Lawall' <julia@diku.dk>
Cc: "'James E.J. Bottomley'" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I agree.
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
-----Original Message-----
From: Dan Carpenter [mailto:error27@gmail.com] 
Sent: Friday, August 06, 2010 3:50 PM
To: Julia Lawall
Cc: James E.J. Bottomley; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org;
nick.cheng@areca.com.tw
Subject: Re: [PATCH 9/42] drivers/scsi: Adjust confusing if indentation


This should go to Nick Cheng.  He would know about the arcmsr driver.

regards,
dan carpenter

On Thu, Aug 05, 2010 at 10:19:36PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Outdent the code following the if.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r disable braces4@
> position p1,p2;
> statement S1,S2;
> @@
> 
> (
> if (...) { ... }
> |
> if (...) S1@p1 S2@p2
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> if (p1[0].column == p2[0].column):
>   cocci.print_main("branch",p1)
>   cocci.print_secs("after",p2)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> This might be the wrong fix, however it doesn't change the current
semantics.
> 
>  drivers/scsi/arcmsr/arcmsr_hba.c    |    4 ++--
>  drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 95a895d..c4e5cdc 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -877,8 +877,8 @@ static void arcmsr_report_ccb_state(struct
AdapterControlBlock *acb,
>  	if (!error) {
>  		if (acb->devstate[id][lun] == ARECA_RAID_GONE)
>  			acb->devstate[id][lun] = ARECA_RAID_GOOD;
> -			ccb->pcmd->result = DID_OK << 16;
> -			arcmsr_ccb_complete(ccb);
> +		ccb->pcmd->result = DID_OK << 16;
> +		arcmsr_ccb_complete(ccb);
>  	}else{
>  		switch (ccb->arcmsr_cdb.DeviceStatus) {
>  		case ARCMSR_DEV_SELECT_TIMEOUT: {
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 57bcd5c..12faf64 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -534,7 +534,7 @@ _base_display_event_data(struct MPT2SAS_ADAPTER *ioc,
>  		if (event_data->DiscoveryStatus)
>  			printk("discovery_status(0x%08x)",
>  			    le32_to_cpu(event_data->DiscoveryStatus));
> -			printk("\n");
> +		printk("\n");
>  		return;
>  	}
>  	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
