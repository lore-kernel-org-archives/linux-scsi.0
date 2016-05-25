From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/5] block: add queue reset support
Date: Wed, 25 May 2016 09:13:14 -0700
Message-ID: <f30ef794-b7ed-36d3-a268-b3bd6249ae50@sandisk.com>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
 <1464162903-14735-3-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0053.outbound.protection.outlook.com ([65.55.169.53]:58400
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755734AbcEYQN0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 12:13:26 -0400
In-Reply-To: <1464162903-14735-3-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mchristi@redhat.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org

On 05/25/2016 12:55 AM, mchristi@redhat.com wrote:
> +	spin_lock_irq(q->queue_lock);
> +	wait_event_lock_irq(q->reset_wq,
> +			    !queue_flag_test_and_set(QUEUE_FLAG_RESETTING, q),
> +			    *q->queue_lock);
> +	if (blk_queue_dead(q)) {
> +		rc = -ENODEV;
> +		spin_unlock_irq(q->queue_lock);
> +		goto done;
> +	}
> +	spin_unlock_irq(q->queue_lock);

Is the flag QUEUE_FLAG_RESETTING used to serialize blk_reset_queue() 
calls? If so, please consider using a mutex instead. Lockdep can detect 
lock inversion for mutexes and spinlocks but not for serialization that 
is based on wait_event_lock_irq() loops.

> +	if (q->mq_ops) {
> +		blk_mq_stop_hw_queues(q);
> +		blk_mq_freeze_queue(q);
> +
> +		eh_rc = q->mq_ops->reset(q);
> +
> +		blk_mq_unfreeze_queue(q);
> +		blk_mq_start_stopped_hw_queues(q, true);
> +	} else if (q->reset_fn) {
> +		spin_lock_irq(q->queue_lock);
> +		blk_stop_queue(q);
> +		spin_unlock_irq(q->queue_lock);
> +
> +		while (q->request_fn_active)
> +			msleep(10);
> +
> +		eh_rc = q->reset_fn(q);
> +
> +		spin_lock_irq(q->queue_lock);
> +		blk_start_queue(q);
> +		spin_unlock_irq(q->queue_lock);
> +	}

Some of the above code is similar to some of the code in 
scsi_internal_device_block() and scsi_internal_device_unblock(). Have 
you considered to avoid this duplication by introducing helpers in the 
block layer for blocking and unblocking queues?

Thanks,

Bart.
