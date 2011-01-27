From: Bandan Das <bandan.das@stratus.com>
Subject: Re: [PATCH] qla2xxx: Fix possible race that could hang kthread_stop()
Date: Thu, 27 Jan 2011 16:32:55 -0500
Message-ID: <20110127213255.GG31955@stratus.com>
References: <20110127205922.GF31955@stratus.com>
 <1296162757.3050.69.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1296162757.3050.69.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> That's not really the accepted way to fix these race conditions because
> of the double check of kthread_should_stop(); this is 
> James
> 
> ---
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c194c23..15ce69e 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3282,10 +3282,10 @@ qla2x00_do_dpc(void *data)
>  
>  	set_user_nice(current, -20);
>  
> +	set_current_state(TASK_INTERRUPTIBLE);
>  	while (!kthread_should_stop()) {
>  		DEBUG3(printk("qla2x00: DPC handler sleeping\n"));
>  
> -		set_current_state(TASK_INTERRUPTIBLE);
>  		schedule();
>  		__set_current_state(TASK_RUNNING);
>  
> @@ -3454,7 +3454,9 @@ qla2x00_do_dpc(void *data)
>  		qla2x00_do_dpc_all_vps(base_vha);
>  
>  		ha->dpc_active = 0;
> +		set_current_state(TASK_INTERRUPTIBLE);
>  	} /* End of while(1) */
> +	__set_current_state(TASK_RUNNING);
>  
>  	DEBUG(printk("scsi(%ld): DPC handler exiting\n", base_vha->host_no));
>  
Yes, this looks more clean and will take care of the problem I am hitting.


Bandan
