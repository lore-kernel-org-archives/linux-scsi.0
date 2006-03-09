From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: [PATCH 01/11] Use msleep() rather than schedule_timeout().
Date: Thu, 9 Mar 2006 04:12:00 -0800
Message-ID: <3679966B84813344B908D418BA3F6A4A06F600F0@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:36432 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932371AbWCIMMA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 07:12:00 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>, Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

>>On Tue, 2006-03-07 at 16:35 -0800, Arjan van de Van wrote:
>On Tue, 2006-03-07 at 16:35 -0800, ravi.anand@qlogic.com wrote:


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

>>this looks like a major step backwards; this orginal code was right!

Good catch. Overlooked, since msleep() does the context switching as well.
We will queue it for the next release.

Thanx
Ravi






