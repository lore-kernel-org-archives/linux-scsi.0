From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 01/13] scsi: don't use
	blk_insert_request() for requeueing
Date: Thu, 31 Mar 2005 11:53:20 -0600
Message-ID: <1112291600.5619.19.camel@mulgrave>
References: <20050331090647.FEDC3964@htj.dyndns.org>
	 <20050331090647.BA0001D5@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62366 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261594AbVCaRxf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 12:53:35 -0500
In-Reply-To: <20050331090647.BA0001D5@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Thu, 2005-03-31 at 18:07 +0900, Tejun Heo wrote:
> 01_scsi_no_REQ_SPECIAL_on_requeue.patch
> 
> 	blk_insert_request() has 'reinsert' argument, which, when set,
> 	turns on REQ_SPECIAL and REQ_SOFTBARRIER and requeues the
> 	request.  SCSI midlayer was the only user of this feature and
> 	all requeued requests become special requests defeating
> 	quiesce state.  This patch makes scsi midlayer use
> 	blk_requeue_request() for requeueing and removes 'reinsert'
> 	feature from blk_insert_request().

Well, REQ_SPECIAL is the signal to the mid-layer that we've allocated
the resources necessary to process the command, so in practice it will
be turned on for every requeue request (because we set it when the
command is prepared), so this patch would have no effect on your stated
quiesce problem.  However, if you think about how requests work with
head insertion and one command following another, there's really not a
huge problem here either.

The other reason I don't like this is that we've been trying hard to
sweep excess block knowledge out of the mid-layer.  I don't think
REQ_SOFTBARRIER is anything we really have to know about.

James


