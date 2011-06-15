From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Make se_dev_check_online() locking IRQ-safe
Date: Wed, 15 Jun 2011 10:08:24 -0700
Message-ID: <1308157704.20109.29.camel@haakon2.linux-iscsi.org>
References: <1308023706-7255-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60301 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1FORRI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 13:17:08 -0400
In-Reply-To: <1308023706-7255-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Mon, 2011-06-13 at 20:55 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> se_dev_check_online() is called from transport_lookup_cmd_lun(), which
> as discussed before may be called from interrupt context.  So it needs
> to use spin_lock_irqsave() instead of spin_lock_irq() to avoid
> enabling interrupts at the wrong time.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>

Committed as 91e8524637

Thanks Roland!

--nab

> ---
>  drivers/target/target_core_device.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index fcb8161..f2a4bf2 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -815,12 +815,13 @@ static void se_dev_stop(struct se_device *dev)
>  
>  int se_dev_check_online(struct se_device *dev)
>  {
> +	unsigned long flags;
>  	int ret;
>  
> -	spin_lock_irq(&dev->dev_status_lock);
> +	spin_lock_irqsave(&dev->dev_status_lock, flags);
>  	ret = ((dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) ||
>  	       (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED)) ? 0 : 1;
> -	spin_unlock_irq(&dev->dev_status_lock);
> +	spin_unlock_irqrestore(&dev->dev_status_lock, flags);
>  
>  	return ret;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

