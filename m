From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] scsi: ensure that a request is valid when
	returning it from scsi_find_tag()
Date: Mon, 13 Apr 2015 11:47:19 +0200
Message-ID: <20150413094719.GC5259@lst.de>
References: <1428427120-20971-1-git-send-email-axboe@fb.com> <1428427120-20971-3-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60213 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbbDMJrV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2015 05:47:21 -0400
Content-Disposition: inline
In-Reply-To: <1428427120-20971-3-git-send-email-axboe@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de

On Tue, Apr 07, 2015 at 11:18:36AM -0600, Jens Axboe wrote:
> For the scsi-mq case, ensure that the request has been started before
> returning it from scsi_find_tag(). This is akin to the ->special
> check for the non-mq case, it ensures that the request has been setup
> and issued.
> 
> Signed-off-by: Jens Axboe <axboe@fb.com>

Shouldn't this be done in blk_mq_tag_to_rq?  In general when a driver
looks for an active tag it wants an active tag, so working around
this in the driver seems like a bad idea.
