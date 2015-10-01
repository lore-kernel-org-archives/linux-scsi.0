From: Paul Mackerras <paulus@ozlabs.org>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Thu, 1 Oct 2015 14:34:54 +1000
Message-ID: <20151001043453.GA2893@iris.ozlabs.ibm.com>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
 <20150925151802.GB20282@lst.de>
 <1443202278.2188.13.camel@HansenPartnership.com>
 <20150930151449.GC26299@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:40965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbbJAEfI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2015 00:35:08 -0400
Content-Disposition: inline
In-Reply-To: <20150930151449.GC26299@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Wed, Sep 30, 2015 at 05:14:49PM +0200, Christoph Hellwig wrote:
> 
> Paul, can you try the trivial one liner below?
> 
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index edb044a..fbc9502 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -391,7 +391,7 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
>  	if (!sdev)
>  		return -ENODEV;
>  
> -	scsi_dh = scsi_dh_lookup(name);
> +	scsi_dh = __scsi_dh_lookup(name);
>  	if (!scsi_dh) {
>  		err = -EINVAL;
>  		goto out_put_device;

I still get the warning:

WARNING: at /home/paulus/kernel/kvm/kernel/kmod.c:140
Modules linked in: radeon(+) i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
 sysimgblt fb_sys_fops ttm drm tg3(+) ptp ipr cxgb3 pps_core i2c_core mdio dm_multipath
CPU: 11 PID: 7 Comm: kworker/u321:0 Not tainted 4.3.0-rc2-kvm+ #73
Workqueue: events_unbound async_run_entry_fn
task: c000000ff0545080 ti: c000000ff0610000 task.ti: c000000ff0610000

...

NIP [c0000000000d390c] __request_module+0x21c/0x380
LR [c0000000000d38f4] __request_module+0x204/0x380
Call Trace:
[c000000ff0613920] [c0000000000d38f4] __request_module+0x204/0x380 (unreliable)
[c000000ff06139e0] [c0000000006369d4] scsi_dh_lookup+0x64/0x80
[c000000ff0613a50] [c000000000636fcc] scsi_dh_add_device+0x13c/0x170
[c000000ff0613aa0] [c000000000630ea4] scsi_sysfs_add_sdev+0x114/0x380
[c000000ff0613b30] [c00000000062e040] do_scan_async+0xf0/0x240
[c000000ff0613bc0] [c0000000000e6bc0] async_run_entry_fn+0xa0/0x200
[c000000ff0613c50] [c0000000000d9750] process_one_work+0x1a0/0x4b0
[c000000ff0613ce0] [c0000000000d9bf0] worker_thread+0x190/0x5f0
[c000000ff0613d80] [c0000000000e21b0] kthread+0x110/0x130
[c000000ff0613e30] [c0000000000095b0] ret_from_kernel_thread+0x5c/0xac

So it's the call to scsi_dh_lookup() in scsi_dh_add_device() that is
causing the warning this time.  Do you want me to add the "__" to that
one too?

Paul.
