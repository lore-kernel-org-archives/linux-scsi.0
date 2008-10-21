From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 04/22] libata-sff: clear IRQ from ata_sff_error_handler()
 only when necessary
Date: Tue, 21 Oct 2008 13:53:06 +0400
Message-ID: <48FDA682.2020301@ru.mvista.com>
References: <1224580680-13698-1-git-send-email-tj@kernel.org> <1224580680-13698-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-5-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Tejun Heo wrote:

> Clearing IRQ from ata_sff_error_handler() is necessary only when the
> port is gonna be thawed before performing EH actions and some
> controllers don't like being accessed after certain fail modes until
> they're reset.  Clear IRQ iff the port is being thawed.  Also, remove
> unnecessary ata_sff_sync() while at it.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
>   

   Sorry for the grammar nipicking but...

> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 4b47394..b9fb068 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -2119,11 +2119,13 @@ void ata_sff_error_handler(struct ata_port *ap)
>  		}
>  
>  		ap->ops->bmdma_stop(qc);
> -	}
>  
> -	ata_sff_sync(ap);		/* FIXME: We don't need this */
> -	ap->ops->sff_check_status(ap);
> -	ap->ops->sff_irq_clear(ap);
> +		/* if we're gonna thaw, make sure IRQ is clear */
>   

   IRQ cannot be clear, only cleared. :-)

MBR, Sergei


