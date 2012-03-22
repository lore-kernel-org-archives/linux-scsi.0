From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [libsas PATCH v12 04/11] sysfs: handle 'parent deleted before
 child added'
Date: Thu, 22 Mar 2012 07:39:59 -0700
Message-ID: <20120322143959.GF19835@kroah.com>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
 <20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47038 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2CVOkE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2012 10:40:04 -0400
Received: by ghrr11 with SMTP id r11so1791852ghr.19
        for <linux-scsi@vger.kernel.org>; Thu, 22 Mar 2012 07:40:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Wed, Mar 21, 2012 at 11:32:14PM -0700, Dan Williams wrote:
> In scsi at least two cases of the parent device being deleted before the
> child is added have been observed.
> 
> 1/ scsi is performing async scans and the device is removed prior to the
>    async can thread running.
> 
> 2/ libsas discovery event running after the parent port has been torn
>    down.
> 
> Result in crash signatures like:
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
>  IP: [<ffffffff8115e100>] sysfs_create_dir+0x32/0xb6
>  ...
>  Process scsi_scan_8 (pid: 5417, threadinfo ffff88080bd16000, task ffff880801b8a0b0)
>  Stack:
>   00000000fffffffe ffff880813470628 ffff88080bd17cd0 ffff88080614b7e8
>   ffff88080b45c108 00000000fffffffe ffff88080bd17d20 ffffffff8125e4a8
>   ffff88080bd17cf0 ffffffff81075149 ffff88080bd17d30 ffff88080614b7e8
>  Call Trace:
>   [<ffffffff8125e4a8>] kobject_add_internal+0x120/0x1e3
>   [<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
>   [<ffffffff8125e641>] kobject_add_varg+0x41/0x50
>   [<ffffffff8125e70b>] kobject_add+0x64/0x66
>   [<ffffffff8131122b>] device_add+0x12d/0x63a
> 
> These scenarios need to be cleaned up, but in the meantime the system
> need not crash if this ordering occurs.  Instead report:
> 
>  kobject_add_internal failed for target8:0:16 (error: -2 parent: end_device-8:0:24)
>  Pid: 2942, comm: scsi_scan_8 Not tainted 3.3.0-rc7-isci+ #2
>  Call Trace:
>   [<ffffffff8125e551>] kobject_add_internal+0x1c1/0x1f3
>   [<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
>   [<ffffffff8125e659>] kobject_add_varg+0x41/0x50
>   [<ffffffff8125e723>] kobject_add+0x64/0x66
>   [<ffffffff8131124b>] device_add+0x12d/0x63a
>   [<ffffffff8125e0ef>] ? kobject_put+0x4c/0x50
>   [<ffffffff8132f370>] scsi_sysfs_add_sdev+0x4e/0x28a
>   [<ffffffff8132dce3>] do_scan_async+0x9c/0x145
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/sysfs/dir.c |    3 +++
>  lib/kobject.c  |    7 ++++---
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 7fdf6a7..86521ee 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -714,6 +714,9 @@ int sysfs_create_dir(struct kobject * kobj)
>  	else
>  		parent_sd = &sysfs_root;
>  
> +	if (!parent_sd)
> +		return -ENOENT;
> +
>  	if (sysfs_ns_type(parent_sd))
>  		ns = kobj->ktype->namespace(kobj);
>  	type = sysfs_read_ns_type(kobj);

So what happens if this is true?  Does this patch fix the oops?  What
kernels should this be applied to where this problem has been seen?

> diff --git a/lib/kobject.c b/lib/kobject.c
> index c33d7a1..e5f86c0 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -192,13 +192,14 @@ static int kobject_add_internal(struct kobject *kobj)
>  
>  		/* be noisy on error issues */
>  		if (error == -EEXIST)
> -			printk(KERN_ERR "%s failed for %s with "
> +			pr_err("%s failed for %s with "
>  			       "-EEXIST, don't try to register things with "
>  			       "the same name in the same directory.\n",
>  			       __func__, kobject_name(kobj));
>  		else
> -			printk(KERN_ERR "%s failed for %s (%d)\n",
> -			       __func__, kobject_name(kobj), error);
> +			pr_err("%s failed for %s (error: %d parent: %s)\n",
> +			       __func__, kobject_name(kobj), error,
> +			       parent ? kobject_name(parent) : "'none'");
>  		dump_stack();
>  	} else
>  		kobj->state_in_sysfs = 1;

These changes have nothing to do with the above fix, so why include them
here?

And note, I hate pr_err(), what's wrong with printk() in this instance?

greg k-h
