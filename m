From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/2] [RFC] block: replace BKL with global mutex
Date: Wed, 14 Apr 2010 18:48:19 -0400
Message-ID: <4BC64633.6010407@interlog.com>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1271277384-7627-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Arnd Bergmann wrote:
> The block layer is one of the remaining users
> of the Big Kernel Lock. In there, it is used
> mainly for serializing the blkdev_get and
> blkdev_put functions and some ioctl implementations
> as well as some less common open functions of
> related character devices following a previous
> pushdown and parts of the blktrace code.
> 
> The only one that seems to be a bit nasty is the
> blkdev_get function which is actually recursive
> and may try to get the BKL twice.
> 
> All users except the one in blkdev_get seem to
> be outermost locks, meaning we don't rely on
> the release-on-sleep semantics to avoid deadlocks.
> 
> The ctl_mutex (pktcdvd.ko), raw_mutex (raw.ko),
> state_mutex (dasd.ko), reconfig_mutex (md.ko),
> and jfs_log_mutex (jfs.ko) may be held when
> blkdev_get is called, but as far as I can tell,
> these mutexes are never acquired from any of the
> functions that get converted in this patch.
> 
> In order to get rid of the BKL, this introduces
> a new global mutex called blkdev_mutex, which
> replaces the BKL in all drivers that directly
> interact with the block layer. In case of blkdev_get,
> the mutex is moved outside of the function itself
> in order to avoid the recursive taking of blkdev_mutex.
> 
> Testing so far has shown no problems whatsoever
> from this patch, but the usage in blkdev_get
> may introduce extra latencies, and I may have
> missed corner cases where an block device ioctl
> function sleeps for a significant amount of time,
> which may be harmful to the performance of other
> threads.

<snip>

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index dee1c96..ec5b43e 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -229,7 +229,7 @@ sg_open(struct inode *inode, struct file *filp)
>  	int res;
>  	int retval;
>  
> -	lock_kernel();
> +	mutex_lock(&blkdev_mutex);
>  	nonseekable_open(inode, filp);
>  	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
>  	sdp = sg_get_dev(dev);
> @@ -307,7 +307,7 @@ error_out:
>  sg_put:
>  	if (sdp)
>  		sg_put_dev(sdp);
> -	unlock_kernel();
> +	mutex_unlock(&blkdev_mutex);
>  	return retval;
>  }
>  
> @@ -757,9 +757,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
>  	return 0;
>  }
>  
> -static int
> -sg_ioctl(struct inode *inode, struct file *filp,
> -	 unsigned int cmd_in, unsigned long arg)
> +static long sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>  {
>  	void __user *p = (void __user *)arg;
>  	int __user *ip = p;
> @@ -1078,6 +1076,17 @@ sg_ioctl(struct inode *inode, struct file *filp,
>  	}
>  }
>  
> +static long sg_unlocked_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
> +{
> +	int ret;
> +
> +	mutex_lock(&blkdev_mutex);
> +	ret = sg_ioctl(filp, cmd_in, arg);
> +	mutex_unlock(&blkdev_mutex);
> +
> +	return ret;
> +}
> +
>  #ifdef CONFIG_COMPAT
>  static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>  {
> @@ -1322,7 +1331,8 @@ static const struct file_operations sg_fops = {
>  	.read = sg_read,
>  	.write = sg_write,
>  	.poll = sg_poll,
> -	.ioctl = sg_ioctl,
> +	.llseek = generic_file_llseek,

The sg driver has no seek semantics on its read() and
write() calls. And sg_open() calls nonseekable_open(). So
     .llseek = no_llseek,
seems more appropriate.

> +	.unlocked_ioctl = sg_unlocked_ioctl,
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl = sg_compat_ioctl,
>  #endif

And I just checked st.c (SCSI tape driver) and it calls
lock_kernel() .


Doug Gilbert
