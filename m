From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] sg_cmd_done - another oops
Date: Tue, 31 Aug 2004 15:16:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4134DC9C.5010100@us.ibm.com>
References: <40C0968E.4090309@us.ibm.com> <40C3D988.3090709@torque.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:4540 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S269149AbUHaUSD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 16:18:03 -0400
In-Reply-To: <40C3D988.3090709@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

James,

This patch appears to have been dropped.

-Brian

Douglas Gilbert wrote:
> Brian King wrote:
> 
>> The following patch fixes a race condition in sg 
> 
>  > of sg_cmd_done racing with sg_release. I've seen this
>  > bug hit several times on test machines and the following
>  > patch fixes it. The race is that if srp->done is set
>  > and the waiting thread gets a spurious wakeup immediately
>  > afterwards, then the waiting thread can end up executing
>  > and completing, then getting closed, freeing sfp before
>  > the wake_up_interruptible is called, which then will result
>  > in an oops. The oops is fixed by locking around the
> 
>> setting srp->done to 1 and the wake_up, and also locking 
> 
>  > around the checking of srp->done, which guarantees that
>  > the wake_up_interruptible will always occur before the
>  > sleeping thread gets a chance to run.
> 
> Brian,
> Thanks for this analysis; I'm still trying to get my head
> around it :-) These "spurious wakeups" are a worry. Does
> your testing produce them or do they occur randomly?
> 
> The critical part of your patch seems to be the write
> lock in sg_cmd_done() making sure srp->done is set _and_
> wake_up_interruptible() gets executed before the
> __wait_event_interruptible macro in sg_read() or
> sg_remove(_sfp) can proceed.
> 
> I thought about making srp->done atomic (of type atomic_t)
> but that does not seem to be sufficient. So I'm happy for
> James to apply this patch.
> 
> 
> An attempt to consolidate... Almost all of the changes to
> sg that were discussed in the "2.6.6-rc3 ia64
> smp_call_function() called with interrupts disabled" thread
> (about a month ago) are now in lk 2.6.7-rc2. The janitors
> have also been at work with "__user" type modifiers.
> Some changes that Patrick Mansfield proposed are not in
> rc2:
>   - up max number of devices to 32K
>   - revert vmalloc()s to kmalloc()s since the former are
>     problematic in big configurations
> 
> The attached patch merges Brian patches with those proposed
> by Patrick. The patch is against lk 2.6.7-rc2 (and sg hasn't
> changed between rc2 and rc2-bk5).
> 
> Doug Gilbert
> 
> 
> 
> ------------------------------------------------------------------------
> 
> --- linux/drivers/scsi/sg.c	2004-06-03 12:45:12.000000000 +1000
> +++ linux/drivers/scsi/sg.c267rc2bk1pl	2004-06-07 12:29:52.879588688 +1000
> @@ -42,7 +42,6 @@
>  #include <linux/fcntl.h>
>  #include <linux/init.h>
>  #include <linux/poll.h>
> -#include <linux/vmalloc.h>
>  #include <linux/smp_lock.h>
>  #include <linux/moduleparam.h>
>  #include <linux/devfs_fs_kernel.h>
> @@ -60,7 +59,7 @@
>  
>  #ifdef CONFIG_SCSI_PROC_FS
>  #include <linux/proc_fs.h>
> -static char *sg_version_date = "20040513";
> +static char *sg_version_date = "20040607";
>  
>  static int sg_proc_init(void);
>  static void sg_proc_cleanup(void);
> @@ -73,7 +72,7 @@
>  #define SG_ALLOW_DIO_DEF 0
>  #define SG_ALLOW_DIO_CODE /* compile out by commenting this define */
>  
> -#define SG_MAX_DEVS 8192
> +#define SG_MAX_DEVS 32768
>  
>  /*
>   * Suppose you want to calculate the formula muldiv(x,m,d)=int(x * m / d)
> @@ -723,6 +722,18 @@
>  }
>  
>  static int
> +sg_srp_done(Sg_request *srp, Sg_fd *sfp)
> +{
> +	unsigned long iflags;
> +	int done;
> +
> +	read_lock_irqsave(&sfp->rq_list_lock, iflags);
> +	done = srp->done;
> +	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> +	return done;
> +}
> +
> +static int
>  sg_ioctl(struct inode *inode, struct file *filp,
>  	 unsigned int cmd_in, unsigned long arg)
>  {
> @@ -761,7 +772,7 @@
>  			while (1) {
>  				result = 0;	/* following macro to beat race condition */
>  				__wait_event_interruptible(sfp->read_wait,
> -					(sdp->detached || sfp->closed || srp->done),
> +					(sdp->detached || sfp->closed || sg_srp_done(srp, sfp)),
>  							   result);
>  				if (sdp->detached)
>  					return -ENODEV;
> @@ -772,7 +783,9 @@
>  				srp->orphan = 1;
>  				return result;	/* -ERESTARTSYS because signal hit process */
>  			}
> +			write_lock_irqsave(&sfp->rq_list_lock, iflags);
>  			srp->done = 2;
> +			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>  			result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
>  			return (result < 0) ? result : 0;
>  		}
> @@ -1215,6 +1228,7 @@
>  	Sg_device *sdp = NULL;
>  	Sg_fd *sfp;
>  	Sg_request *srp = NULL;
> +	unsigned long iflags;
>  
>  	if (SCpnt && (SRpnt = SCpnt->sc_request))
>  		srp = (Sg_request *) SRpnt->upper_private_data;
> @@ -1303,8 +1317,10 @@
>  	if (sfp && srp) {
>  		/* Now wake up any sg_read() that is waiting for this packet. */
>  		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
> +		write_lock_irqsave(&sfp->rq_list_lock, iflags);
>  		srp->done = 1;
>  		wake_up_interruptible(&sfp->read_wait);
> +		write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>  	}
>  }
>  
> @@ -1331,17 +1347,18 @@
>  	void *old_sg_dev_arr = NULL;
>  	int k, error;
>  
> -	sdp = vmalloc(sizeof(Sg_device));
> -	if (!sdp)
> +	sdp = kmalloc(sizeof(Sg_device), GFP_KERNEL);
> +	if (!sdp) {
> +		printk(KERN_WARNING "sg_alloc: kmalloc Sg_device failure\n");
>  		return -ENOMEM;
> -
> +	}
>  	write_lock_irqsave(&sg_dev_arr_lock, iflags);
>  	if (unlikely(sg_nr_dev >= sg_dev_max)) {	/* try to resize */
>  		Sg_device **tmp_da;
>  		int tmp_dev_max = sg_nr_dev + SG_DEV_ARR_LUMP;
>  		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
>  
> -		tmp_da = vmalloc(tmp_dev_max * sizeof(Sg_device *));
> +		tmp_da = kmalloc(tmp_dev_max * sizeof(Sg_device *), GFP_KERNEL);
>  		if (unlikely(!tmp_da))
>  			goto expand_failed;
>  
> @@ -1375,8 +1392,8 @@
>  
>   out:
>  	if (error < 0)
> -		vfree(sdp);
> -	vfree(old_sg_dev_arr);
> +		kfree(sdp);
> +	kfree(old_sg_dev_arr);
>  	return error;
>  
>   expand_failed:
> @@ -1404,14 +1421,18 @@
>  	int error, k;
>  
>  	disk = alloc_disk(1);
> -	if (!disk)
> +	if (!disk) {
> +		printk(KERN_WARNING "alloc_disk failed\n");
>  		return -ENOMEM;
> +	}
>  	disk->major = SCSI_GENERIC_MAJOR;
>  
>  	error = -ENOMEM;
>  	cdev = cdev_alloc();
> -	if (!cdev)
> +	if (!cdev) {
> +		printk(KERN_WARNING "cdev_alloc failed\n");
>  		goto out;
> +	}
>  	cdev->owner = THIS_MODULE;
>  	cdev->ops = &sg_fops;
>  
> @@ -1490,7 +1511,7 @@
>  				tsfp = sfp->nextfp;
>  				for (srp = sfp->headrp; srp; srp = tsrp) {
>  					tsrp = srp->nextrp;
> -					if (sfp->closed || (0 == srp->done))
> +					if (sfp->closed || (0 == sg_srp_done(srp, sfp)))
>  						sg_finish_rem_req(srp);
>  				}
>  				if (sfp->closed) {
> @@ -1525,7 +1546,7 @@
>  		put_disk(sdp->disk);
>  		sdp->disk = NULL;
>  		if (NULL == sdp->headfp)
> -			vfree((char *) sdp);
> +			kfree((char *) sdp);
>  	}
>  
>  	if (delay)
> @@ -1590,7 +1611,7 @@
>  	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
>  				 SG_MAX_DEVS);
>  	if (sg_dev_arr != NULL) {
> -		vfree((char *) sg_dev_arr);
> +		kfree((char *) sg_dev_arr);
>  		sg_dev_arr = NULL;
>  	}
>  	sg_dev_max = 0;
> @@ -2472,7 +2493,7 @@
>  
>  	for (srp = sfp->headrp; srp; srp = tsrp) {
>  		tsrp = srp->nextrp;
> -		if (srp->done)
> +		if (sg_srp_done(srp, sfp))
>  			sg_finish_rem_req(srp);
>  		else
>  			++dirty;
> @@ -2492,7 +2513,7 @@
>  			}
>  			if (k < maxd)
>  				sg_dev_arr[k] = NULL;
> -			vfree((char *) sdp);
> +			kfree((char *) sdp);
>  			res = 1;
>  		}
>  		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

