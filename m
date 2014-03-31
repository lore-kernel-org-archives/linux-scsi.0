From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] scsi: reintroduce scsi_driver.init_command
Date: Mon, 31 Mar 2014 01:09:09 -0700
Message-ID: <20140331080909.GA5270@infradead.org>
References: <1395936862-6938-1-git-send-email-hch@lst.de>
 <1395936862-6938-4-git-send-email-hch@lst.de>
 <5339118D.4060406@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbaCaIJt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 04:09:49 -0400
Content-Disposition: inline
In-Reply-To: <5339118D.4060406@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Mon, Mar 31, 2014 at 01:56:13AM -0500, Mike Christie wrote:
> The above call would free the cmnd->cmnd and set it to null. If then
> scsi_io_completion was going to do some error processing it looks like
> it could try to access the scsi_cmnd->cmnd field.
> 
> With the current code that would not be a problem because the blk unprep
> callback is not called until the block layer does its request cleanup in
> blk_finish_request which as you know is after
> scsi_io_completion/scsi_end_request is done with the cmnd.

Right, we should probabl call ->uninit_command at that place as well
instead of calling it internall in ->done.
