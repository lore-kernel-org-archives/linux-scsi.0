From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 05/22] libata-sff: kill unused prototype and make ata_dev_select()
 static
Date: Fri, 07 May 2010 17:47:12 +0400
Message-ID: <4BE419E0.9080802@ru.mvista.com>
References: <1224580680-13698-1-git-send-email-tj@kernel.org> <1224580680-13698-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-6-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

Tejun Heo wrote:

> ata_irq_on() was renamed to ata_sff_irq_on() and exported a while ago
> but prototype for the original function lingered in
> drivers/ata/libata.h.  Kill it.  Also, ata_dev_select() is only used
> inside drivers/ata/libata-sff.c.  Make it static.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/ata/libata-sff.c |    2 +-
>  drivers/ata/libata.h     |    3 ---
>  2 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index b9fb068..edcd72c 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -468,7 +468,7 @@ void ata_sff_dev_select(struct ata_port *ap, unsigned int device)
>   *	LOCKING:
>   *	caller.
>   */
> -void ata_dev_select(struct ata_port *ap, unsigned int device,
> +static void ata_dev_select(struct ata_port *ap, unsigned int device,
>  			   unsigned int wait, unsigned int can_sleep)
>  {
>  	if (ata_msg_probe(ap))
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index fe2839e..1f626b5 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -201,9 +201,6 @@ static inline int sata_pmp_attach(struct ata_device *dev)
>  
>  /* libata-sff.c */
>  #ifdef CONFIG_ATA_SFF
> -extern void ata_dev_select(struct ata_port *ap, unsigned int device,
> -                           unsigned int wait, unsigned int can_sleep);
> -extern u8 ata_irq_on(struct ata_port *ap);
>  extern void ata_pio_task(struct work_struct *work);
>  #endif /* CONFIG_ATA_SFF */
>   

   Hey, why this Tejun's patch ended up ignored? I've just submitted the 
patch killing that orphan proto and am pondering what to do with 
ata_dev_select() and now it turns out that Tejun has taken care of both 
back in 2008... :-/

WBR, Sergei

