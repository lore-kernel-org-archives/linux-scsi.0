From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH scsi-misc-2.6 01/13] scsi: don't use blk_insert_request() for requeueing
Date: Thu, 31 Mar 2005 11:12:11 +0100
Message-ID: <20050331101211.GB13842@infradead.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.BA0001D5@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:4067 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261227AbVCaKMN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 05:12:13 -0500
Content-Disposition: inline
In-Reply-To: <20050331090647.BA0001D5@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Mar 31, 2005 at 06:07:55PM +0900, Tejun Heo wrote:
> 01_scsi_no_REQ_SPECIAL_on_requeue.patch
> 
> 	blk_insert_request() has 'reinsert' argument, which, when set,
> 	turns on REQ_SPECIAL and REQ_SOFTBARRIER and requeues the
> 	request.  SCSI midlayer was the only user of this feature and
> 	all requeued requests become special requests defeating
> 	quiesce state.  This patch makes scsi midlayer use
> 	blk_requeue_request() for requeueing and removes 'reinsert'
> 	feature from blk_insert_request().
> 
> 	Note: In drivers/scsi/scsi_lib.c, scsi_single_lun_run() and
> 	scsi_run_queue() are moved upward unchanged.

That lest part doesn't belong into this patch at all.

