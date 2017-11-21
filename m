From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: Re: [PATCH] scsi_error: ensure EH wakes up on error to prevent host
 getting stuck
Date: Tue, 21 Nov 2017 11:06:23 +0300
Message-ID: <fb2f367f-f281-2d2c-5a3b-bed43e90c0eb@virtuozzo.com>
References: <f771349c-e391-3d67-4b22-86674fcc7647@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f771349c-e391-3d67-4b22-86674fcc7647@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stuart Hayes <stuart.w.hayes@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joshua_Giles@Dell.com
List-Id: linux-scsi@vger.kernel.org

On 11/20/2017 10:11 PM, Stuart Hayes wrote:
> When a command is added to the host's error handler command queue, there is a chance that the error handler will not be woken up.  This can happen when one CPU is running scsi_eh_scmd_add() at the same time as another CPU is running scsi_device_unbusy() for a different command on the same host.  Each function changes one value, and then looks at the value of a variable that the other function has just changed, but if they both see stale data, neither will actually wake up the error handle >
> In scsi_eh_scmd_add, host_failed is incremented, then scsi_eh_wakeup() is called, which sees that host_busy is still 2, so it doesn't actually wake up the handler.  Meanwhile, in scsi_device_unbusy(), host_busy is decremented, and then it sees that host_failed is 0, so it doesn't even call scsi_eh_wakeup().

If in scsi_eh_scmd_add() we call scsi_eh_wakeup() it is done under 
spinlock, so we have implied memory barrier here. All stores which we've 
done before we had released the lock will be seen by any other thread in 
same critical section if the thread took spinlock after us. So later 
scsi_device_unbusy() in it's scsi_eh_wakeup() also sees host_failed==1.

Actually the problem is that in scsi_device_unbusy() the check below:

         if (unlikely(scsi_host_in_recovery(shost) &&
                      (shost->host_failed || shost->host_eh_scheduled))

is not under same spinlock, so that host_failed can be actually be 0 at 
these point and we never get to scsi_eh_wakeup, which my patch "scsi/eh: 
fix hang adding ehandler wakeups after decrementing host_busy" also 
fixes by putting these check under proper lock and thus the implied 
barrier is added and we don't need actual barrier here.

Please see "LOCK ACQUISITION FUNCTIONS" 
Documentation/memory-barriers.txt for further information about implied 
memory barriers.

> 
> Signed-off-by: Stuart Hyaes <stuart.w.hayes@gmail.com>
> 
> ---
> diff -pur linux-4.14/drivers/scsi/scsi_error.c linux-4.14-stu/drivers/scsi/scsi_error.c
> --- linux-4.14/drivers/scsi/scsi_error.c	2017-11-12 12:46:13.000000000 -0600
> +++ linux-4.14-stu/drivers/scsi/scsi_error.c	2017-11-17 14:22:19.230867923 -0600
> @@ -243,6 +243,10 @@ void scsi_eh_scmd_add(struct scsi_cmnd *
>   	scsi_eh_reset(scmd);
>   	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
>   	shost->host_failed++;
> +	/*
> +	 * See scsi_device_unbusy() for explanation of smp_mb().
> +	 */
> +	smp_mb();
>   	scsi_eh_wakeup(shost);
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   }
> diff -pur linux-4.14/drivers/scsi/scsi_lib.c linux-4.14-stu/drivers/scsi/scsi_lib.c
> --- linux-4.14/drivers/scsi/scsi_lib.c	2017-11-12 12:46:13.000000000 -0600
> +++ linux-4.14-stu/drivers/scsi/scsi_lib.c	2017-11-17 14:22:15.814867833 -0600
> @@ -325,6 +325,15 @@ void scsi_device_unbusy(struct scsi_devi
>   	unsigned long flags;
>   
>   	atomic_dec(&shost->host_busy);
> +	
> +	/* This function changes host_busy and looks at host_failed, while
> +	 * scsi_eh_scmd_add() updates host_failed and looks at host_busy (in
> +	 * scsi_eh_wakeup())... if these happen simultaneously without the smp
> +	 * memory barrier, each can see the old value, such that neither will
> +	 * wake up the error handler, which can cause the host controller to
> +	 * be hung forever.
> +	 */
> +	smp_mb();
>   	if (starget->can_queue > 0)
>   		atomic_dec(&starget->target_busy);
>   
> 
> 
> ---
> This email has been checked for viruses by Avast antivirus software.
> https://www.avast.com/antivirus
> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
