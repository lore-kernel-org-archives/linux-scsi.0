From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Fri, 1 Sep 2006 13:21:09 -0700
Message-ID: <20060901202109.GD7941@ranandlinuxbox.qlogic.org>
References: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com> <1157117328.3675.6.camel@mulgrave.il.steeleye.com> <20060901190423.806416@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:33544 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751168AbWIAUUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2006 16:20:19 -0400
Content-Disposition: inline
In-Reply-To: <20060901190423.806416@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@enoyolf.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, mikec linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

>On Fri, 01 Sep 2006, Doug Maxey wrote:
> Ravi,
> 
> While working on a patch to add shared tags to qla4xxx was looking at
> the shost->can_queue settings, I see the value is set pretty high:
> 
> qla4xxx_probe()
> ...
> 	host->can_queue = REQUEST_QUEUE_DEPTH + 128;
> 
> where REQUEST_QUEUE_DEPTH works out to be 1024.
> 
> My question:
> what is the relationship between the can_queue and the
> setting in
> qla4xxx_slave_configure()
> 	if (sdev->tagged_supported)
> 		scsi_activate_tcq(sdev, 32);
> 	else
> 		scsi_deactivate_tcq(sdev, 32);
> 
> Does this imply that the firmware can ultimately track more requests
> than we can possibly stuff in it?  Where do the other 1012 requests get
> queued, in the block layer?

My understanding is that the "can_queue" is on a per HBA basis.
In other words maximum no of cmd's a give host adapter can
queue at any given point of time. 

While the setting the slave_configure() is on a per lun basis.
Which basically means max no of simultaneous cmd's that
can be outstanding for any given lun.

> 
> James' shared tag patch for stex has the following
> +stex_slave_alloc(struct scsi_device *sdev)
> +{
> +	/* Cheat: usually extracted from Inquiry data */
> +	sdev->tagged_supported = 1;
> +
> +	scsi_activate_tcq(sdev, sdev->host->can_queue);
> 
> where in this case the can_queue is set to ST_CAN_QUEUE, which works
> out to 32.

Dont know much about stex driver. So cant comment on it. 
James any thought ? 

Ravi






-- 
VGER BF report: H 4.75946e-10
