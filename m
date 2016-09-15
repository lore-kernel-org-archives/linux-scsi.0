From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [patch] arcmsr: buffer overflow in arcmsr_iop_message_xfer()
Date: Thu, 15 Sep 2016 15:19:12 +0200
Message-ID: <ff1f18b9-8e5b-93d8-1292-c74529676066@redhat.com>
References: <20160915120142.GA2349@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751063AbcIONTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Sep 2016 09:19:16 -0400
In-Reply-To: <20160915120142.GA2349@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Marco Grassi <marco.gra@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinicke <hare@suse.de>, linux-scsi@vger.kernel.org, security@kernel.org

On 15.9.2016 14:01, Dan Carpenter wrote:
> We need to put an upper bound on "user_len" so the memcpy() doesn't
> overflow.
>
> Reported-by: Marco Grassi <marco.gra@gmail.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 7640498..73ddd45 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -2388,7 +2388,8 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
>  	}
>  	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
>  		unsigned char *ver_addr;
> -		int32_t user_len, cnt2end;
> +		uint32_t user_len;
> +		int32_t cnt2end;
>  		uint8_t *pQbuffer, *ptmpuserbuffer;
>  		ver_addr = kmalloc(ARCMSR_API_DATA_BUFLEN, GFP_ATOMIC);
>  		if (!ver_addr) {
> @@ -2397,6 +2398,10 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
>  		}
>  		ptmpuserbuffer = ver_addr;
>  		user_len = pcmdmessagefld->cmdmessage.Length;
> +		if (user_len > ARCMSR_API_DATA_BUFLEN) {
> +			retvalue = ARCMSR_MESSAGE_FAIL;

Hi,
I think that a 'kfree(ver_addr);' should be added here.
With that you may add my reviewed-by.
Tomas

> +			goto message_out;
> +		}
>  		memcpy(ptmpuserbuffer,
>  			pcmdmessagefld->messagedatabuffer, user_len);
>  		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


