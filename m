From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 13/13] Do not queue new I/O after scsi_remove_host()
 started
Date: Sun, 2 Dec 2012 05:58:47 -0800
Message-ID: <20121202135847.GN15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B60966.40900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57145 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2LBN6w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:58:52 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1334672pad.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:58:51 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B60966.40900@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Hello,

On Wed, Nov 28, 2012 at 01:53:58PM +0100, Bart Van Assche wrote:
> The function scsi_remove_host() may get invoked concurrently with
> scsi_request_fn(). Kill those I/O requests for which processing
> starts after scsi_remove_host() has been invoked. This makes
> device removal a little quicker by avoiding that such SCSI
> commands time out.
...
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f3d6e0d..5fe25b3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1549,7 +1549,8 @@ static void scsi_request_fn(struct request_queue *q)
>  		if (!req || !scsi_dev_queue_ready(q, sdev))
>  			break;
>  
> -		if (unlikely(!scsi_device_online(sdev))) {
> +		if (unlikely(!scsi_device_online(sdev) ||
> +			     !scsi_host_scan_allowed(shost))) {
>  			sdev_printk(KERN_ERR, sdev,
>  				    "rejecting I/O to offline device\n");
>  			scsi_kill_request(req, q);

I don't know.  This feels a bit weird to me.  Shouldn't we instead
make sure that scsi_device_onilne() test fails once host removal is
initiated?

Thanks.

-- 
tejun
