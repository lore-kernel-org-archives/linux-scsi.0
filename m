From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 01/11] Use msleep() rather than schedule_timeout().
Date: Wed, 08 Mar 2006 08:21:46 +0100
Message-ID: <1141802507.3050.5.camel@laptopd505.fenrus.org>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:1953 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751174AbWCHHVt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 02:21:49 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ravi.anand@qlogic.com
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

On Tue, 2006-03-07 at 16:35 -0800, ravi.anand@qlogic.com wrote:


> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
> index 8720357..6959adc 100644
> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
> @@ -95,7 +95,6 @@ qla4xxx_mailbox_command(scsi_qla_host_t 
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
>  	/* Wait for completion */
> -	set_current_state(TASK_UNINTERRUPTIBLE);
>  	add_wait_queue(&ha->mailbox_wait_queue, &wait);
>  
>  	/*
> @@ -105,7 +104,6 @@ qla4xxx_mailbox_command(scsi_qla_host_t 
>  	 */
>  	if (outCount == 0) {
>  		status = QLA_SUCCESS;
> -		set_current_state(TASK_RUNNING);
>  		remove_wait_queue(&ha->mailbox_wait_queue, &wait);
>  		goto mbox_exit;
>  	}
> @@ -130,20 +128,8 @@ qla4xxx_mailbox_command(scsi_qla_host_t 
>  		}
>  		spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
> -		/*
> -		 * Delay for 10 microseconds
> -		 * NOTE: Interrupt_handler may be called here,
> -		 *       if interrupts are enabled
> -		 */
> -#if 0
> -		udelay(10);
> -
> -#else				/*  */
> -		schedule_timeout(10);
> -
> -#endif				/*  */
> -	}			/* wait loop */
> -	set_current_state(TASK_RUNNING);
> +		mdelay(10);
> +	}
>  	remove_wait_queue(&ha->mailbox_wait_queue, &wait);
>  

this looks like a major step backwards; this orginal code was right!



