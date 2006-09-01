From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Fri, 1 Sep 2006 13:11:44 -0700
Message-ID: <20060901201144.GA16135@us.ibm.com>
References: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com> <1157117328.3675.6.camel@mulgrave.il.steeleye.com> <20060901190423.806416@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:5341 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751859AbWIAUKC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2006 16:10:02 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k81KA0F6022740
	for <linux-scsi@vger.kernel.org>; Fri, 1 Sep 2006 16:10:00 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k81KA0ga273096
	for <linux-scsi@vger.kernel.org>; Fri, 1 Sep 2006 14:10:00 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k81K9xkn025566
	for <linux-scsi@vger.kernel.org>; Fri, 1 Sep 2006 14:10:00 -0600
Content-Disposition: inline
In-Reply-To: <20060901190423.806416@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@enoyolf.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, mikec linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

Doug Maxey <dwm@enoyolf.org> wrote:
> 
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

Maybe I misreading your question. host->can_queue is the per host instance
(adapter) limit and scsi_activate_tcq will set the per dev (lun) limit.

host->can_queue being large is a good thing (if it is backed by real
resources). In theory can_queue should be scaled to support a hosts
${max_number_of_devices} * ${max_queue_depth}.

-andmike
--
Michael Anderson
andmike@us.ibm.com
