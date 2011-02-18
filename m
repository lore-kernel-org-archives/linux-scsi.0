From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: RE: [PATCH 1/2] arcmsr: code cleanup and some corrections
Date: Fri, 18 Feb 2011 09:26:18 +0800
Message-ID: <D9C1E110C4CD41E09D8CD394801A7588@arecaaebe11fae>
References: <4D53F4B7.2030806@redhat.com> <4D5D39C9.4000402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35892 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab1BRB16 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2011 20:27:58 -0500
Received: by vws16 with SMTP id 16so1581337vws.19
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2011 17:27:57 -0800 (PST)
In-Reply-To: <4D5D39C9.4000402@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Tomas Henzl' <thenzl@redhat.com>, linux-scsi@vger.kernel.org

Hi Tomas,
I have not yet tested this code.
Do you try that?

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Thursday, February 17, 2011 11:08 PM
To: 'linux-scsi@vger.kernel.org'
Cc: nick.cheng@areca.com.tw
Subject: Re: [PATCH 1/2] arcmsr: code cleanup and some corrections

Hi Nick,

any comments here?

tomash


> I removed outer loops in ...wait_msgint_ready
> the sleeptime and retrycount are in fact never changed so I changed them
> into defines. In arcmsr_flush_hba_cache is a loop removed, which
> printed the same printk 100 times, one line in log is enough I think.
> The arcmsr_sleep_for_bus_reset has lost a functionality with the latest
patches,
> The only thing the function does is a long sleep, so it's replaced with a
ssleep.
>
> Signed-off-by: Tomas henzl <thenzl@redhat.com>
>
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 984bd52..4cd522b 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -75,8 +75,10 @@ MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");
>  MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host Bus
Adapter");
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_VERSION(ARCMSR_DRIVER_VERSION);
> -static int sleeptime = 10;
> -static int retrycount = 12;
> +
> +#define	ARCMSR_SLEEPTIME	10
> +#define	ARCMSR_RETRYCOUNT	12
> +
>  wait_queue_head_t wait_q;
>  static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
>  					struct scsi_cmnd *cmd);
> @@ -171,24 +173,6 @@ static struct pci_driver arcmsr_pci_driver = {
>
****************************************************************************
>
****************************************************************************
>  */
> -int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)
> -{
> -		struct Scsi_Host *shost = NULL;
> -		int i, isleep;
> -		shost = cmd->device->host;
> -		isleep = sleeptime / 10;
> -		if (isleep > 0) {
> -			for (i = 0; i < isleep; i++) {
> -				msleep(10000);
> -			}
> -		}
> -
> -		isleep = sleeptime % 10;
> -		if (isleep > 0) {
> -			msleep(isleep*1000);
> -		}
> -		return 0;
> -}
>  
>  static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)
>  {
> @@ -323,66 +307,64 @@ static void arcmsr_define_adapter_type(struct
AdapterControlBlock *acb)
>  
>  	default: acb->adapter_type = ACB_ADAPTER_TYPE_A;
>  	}
> -}	
> +}
>  
>  static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock
*acb)
>  {
>  	struct MessageUnit_A __iomem *reg = acb->pmuA;
> -	uint32_t Index;
> -	uint8_t Retries = 0x00;
> -	do {
> -		for (Index = 0; Index < 100; Index++) {
> -			if (readl(&reg->outbound_intstatus) &
> -					ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
> -				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,
> -					&reg->outbound_intstatus);
> -				return true;
> -			}
> -			msleep(10);
> -		}/*max 1 seconds*/
> +	int i;
> +
> +	for (i = 0; i < 2000; i++) {
> +		if (readl(&reg->outbound_intstatus) &
> +				ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
> +			writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,
> +				&reg->outbound_intstatus);
> +			return true;
> +		}
> +		msleep(10);
> +	}/* max 20 seconds */
>  
> -	} while (Retries++ < 20);/*max 20 sec*/
>  	return false;
>  }
>  
>  static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock
*acb)
>  {
>  	struct MessageUnit_B *reg = acb->pmuB;
> -	uint32_t Index;
> -	uint8_t Retries = 0x00;
> -	do {
> -		for (Index = 0; Index < 100; Index++) {
> -			if (readl(reg->iop2drv_doorbell)
> -				& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
> -				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN
> -					, reg->iop2drv_doorbell);
> -				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
reg->drv2iop_doorbell);
> -				return true;
> -			}
> -			msleep(10);
> -		}/*max 1 seconds*/
> +	int i;
> +
> +	for (i = 0; i < 2000; i++) {
> +		if (readl(reg->iop2drv_doorbell)
> +			& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
> +			writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,
> +					reg->iop2drv_doorbell);
> +			writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
> +					reg->drv2iop_doorbell);
> +			return true;
> +		}
> +		msleep(10);
> +	}/* max 20 seconds */
>  
> -	} while (Retries++ < 20);/*max 20 sec*/
>  	return false;
>  }
>  
>  static uint8_t arcmsr_hbc_wait_msgint_ready(struct AdapterControlBlock
*pACB)
>  {
>  	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
> -	unsigned char Retries = 0x00;
> -	uint32_t Index;
> -	do {
> -		for (Index = 0; Index < 100; Index++) {
> -			if (readl(&phbcmu->outbound_doorbell) &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
> -
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&phbcmu->outbound_doorbell_clear);/*clear interrupt*/
> -				return true;
> -			}
> -			/* one us delay	*/
> -			msleep(10);
> -		} /*max 1 seconds*/
> -	} while (Retries++ < 20); /*max 20 sec*/
> +	int i;
> +
> +	for (i = 0; i < 2000; i++) {
> +		if (readl(&phbcmu->outbound_doorbell)
> +				& ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
> +
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
> +				&phbcmu->outbound_doorbell_clear); /*clear
interrupt*/
> +			return true;
> +		}
> +		msleep(10);
> +	} /* max 20 seconds */
> +
>  	return false;
>  }
> +
>  static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
>  {
>  	struct MessageUnit_A __iomem *reg = acb->pmuA;
> @@ -2602,12 +2584,8 @@ static int arcmsr_iop_confirm(struct
AdapterControlBlock *acb)
>  		if (cdb_phyaddr_hi32 != 0) {
>  			struct MessageUnit_C *reg = (struct MessageUnit_C
*)acb->pmuC;
>  
> -			if (cdb_phyaddr_hi32 != 0) {
> -				unsigned char Retries = 0x00;
> -				do {
> -					printk(KERN_NOTICE "arcmsr%d:
cdb_phyaddr_hi32=0x%x \n", acb->adapter_index, cdb_phyaddr_hi32);
> -				} while (Retries++ < 100);
> -			}
> +			printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=0x%x
\n",
> +					acb->adapter_index,
cdb_phyaddr_hi32);
>  			writel(ARCMSR_SIGNATURE_SET_CONFIG,
&reg->msgcode_rwbuffer[0]);
>  			writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);
>  			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
&reg->inbound_msgaddr0);
> @@ -2955,10 +2933,10 @@ static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
>  				arcmsr_hardware_reset(acb);
>  				acb->acb_flags &= ~ACB_F_IOP_INITED;
>  sleep_again:
> -				arcmsr_sleep_for_bus_reset(cmd);
> +				ssleep(ARCMSR_SLEEPTIME);
>  				if ((readl(&reg->outbound_msgaddr1) &
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0) {
>  					printk(KERN_ERR "arcmsr%d: waiting
for hw bus reset return, retry=%d \n", acb->host->host_no, retry_count);
> -					if (retry_count > retrycount) {
> +					if (retry_count > ARCMSR_RETRYCOUNT)
{
>  						acb->fw_flag = FW_DEADLOCK;
>  						printk(KERN_ERR "arcmsr%d:
waiting for hw bus reset return, RETRY TERMINATED!! \n",
acb->host->host_no);
>  						return FAILED;
> @@ -3025,10 +3003,10 @@ sleep_again:
>  				arcmsr_hardware_reset(acb);
>  				acb->acb_flags &= ~ACB_F_IOP_INITED;
>  sleep:
> -				arcmsr_sleep_for_bus_reset(cmd);
> +				ssleep(ARCMSR_SLEEPTIME);
>  				if ((readl(&reg->host_diagnostic) & 0x04) !=
0) {
>  					printk(KERN_ERR "arcmsr%d: waiting
for hw bus reset return, retry=%d \n", acb->host->host_no, retry_count);
> -					if (retry_count > retrycount) {
> +					if (retry_count > ARCMSR_RETRYCOUNT)
{
>  						acb->fw_flag = FW_DEADLOCK;
>  						printk(KERN_ERR "arcmsr%d:
waiting for hw bus reset return, RETRY TERMINATED!! \n",
acb->host->host_no);
>  						return FAILED;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

