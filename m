From: Doug Maxey <dwm@enoyolf.org>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Fri, 01 Sep 2006 14:04:23 -0500
Message-ID: <20060901190423.806416@bebe.enoyolf.org>
References: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com> <1157117328.3675.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:5815 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1750887AbWIATEx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Sep 2006 15:04:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, mikec linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>


Ravi,

While working on a patch to add shared tags to qla4xxx was looking at
the shost->can_queue settings, I see the value is set pretty high:

qla4xxx_probe()
...
	host->can_queue = REQUEST_QUEUE_DEPTH + 128;

where REQUEST_QUEUE_DEPTH works out to be 1024.

My question:
what is the relationship between the can_queue and the
setting in
qla4xxx_slave_configure()
	if (sdev->tagged_supported)
		scsi_activate_tcq(sdev, 32);
	else
		scsi_deactivate_tcq(sdev, 32);

Does this imply that the firmware can ultimately track more requests
than we can possibly stuff in it?  Where do the other 1012 requests get
queued, in the block layer?

James' shared tag patch for stex has the following
+stex_slave_alloc(struct scsi_device *sdev)
+{
+	/* Cheat: usually extracted from Inquiry data */
+	sdev->tagged_supported = 1;
+
+	scsi_activate_tcq(sdev, sdev->host->can_queue);

where in this case the can_queue is set to ST_CAN_QUEUE, which works
out to 32.

Is my concern misplaced?


