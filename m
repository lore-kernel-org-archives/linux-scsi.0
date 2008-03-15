From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [BUG 1/3] bsg queue oops with iscsi logout
Date: Fri, 14 Mar 2008 20:45:23 -0400
Message-ID: <20080315004523.GA18260@osc.edu>
References: <20080309165359.GA24388@osc.edu> <47D5766C.3020206@cs.wisc.edu> <47D61A73.3000803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:53578 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbYCOApZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2008 20:45:25 -0400
Content-Disposition: inline
In-Reply-To: <47D61A73.3000803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Erez Zilber <erezz@voltaire.com>

michaelc@cs.wisc.edu wrote on Tue, 11 Mar 2008 00:36 -0500:
> Actually one of the problems looks a little different than some of the 
> problems hit with sg and are caused because we remove the bsg device too 
> soon. I think we want to wait until all the references from the 
> commands/requests are released. The attached patch (untested) moves the bsg 
> unreg call to the scsi device release fn.

> Delay bsg unregistration, because we want to wait until all the request/cmds
> have released their reference.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index ed83cdb..b9b09a7 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -294,6 +294,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  	}
>  
>  	if (sdev->request_queue) {
> +		bsg_unregister_queue(sdev->request_queue);
>  		sdev->request_queue->queuedata = NULL;
>  		/* user context needed to free queue */
>  		scsi_free_queue(sdev->request_queue);
> @@ -857,7 +858,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>  		return;
>  
> -	bsg_unregister_queue(sdev->request_queue);
>  	class_device_unregister(&sdev->sdev_classdev);
>  	transport_remove_device(dev);
>  	device_del(dev);

This definitely avoids the hang in [BUG 3/3].  Instead I get the
useful console message:

    scsi 4:0:0:1: rejecting I/O to dead device

My tested-by for that.  But it leaves a bit of a mess in sysfs.
Apparently udev did not get the message that these devs went away.

ib30$ ll /sys/class/scsi_device/
total 0
drwxr-xr-x  3 root root 0 Mar 14 20:04 ./
drwxr-xr-x 28 root root 0 Mar 14 20:02 ../
drwxr-xr-x  2 root root 0 Mar 14 20:02 2:0:0:0/

ib30$ ll /dev/bsg/
total 0
drwxr-xr-x  2 root root    100 Mar 14 20:03 ./
drwxr-xr-x 12 root root   3020 Mar 14 20:04 ../
crw-rw-rw-  1 root root 254, 0 Mar 14 20:02 2:0:0:0
crw-rw-rw-  1 root root 254, 1 Mar 14 20:03 4:0:0:0
crw-rw-rw-  1 root root 254, 2 Mar 14 20:03 4:0:0:1

I do have a special udev rule to explain why the devs look like
this:

ACTION=="add", SUBSYSTEM=="bsg", NAME="bsg/%k", MODE="0666", OPTIONS="last_rule"

but that doesn't explain why they're still in /dev.

		-- Pete
