From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 01/13] scsi: don't use blk_insert_request() for requeueing
Date: Fri, 1 Apr 2005 13:18:04 +0900
Message-ID: <20050401041804.GA11318@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.BA0001D5@htj.dyndns.org> <20050331101211.GB13842@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.199]:54460 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262609AbVDAESM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 23:18:12 -0500
Received: by rproxy.gmail.com with SMTP id j1so552811rnf
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 20:18:11 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20050331101211.GB13842@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Mar 31, 2005 at 11:12:11AM +0100, Christoph Hellwig wrote:
> On Thu, Mar 31, 2005 at 06:07:55PM +0900, Tejun Heo wrote:
> > 01_scsi_no_REQ_SPECIAL_on_requeue.patch
> > 
> > 	blk_insert_request() has 'reinsert' argument, which, when set,
> > 	turns on REQ_SPECIAL and REQ_SOFTBARRIER and requeues the
> > 	request.  SCSI midlayer was the only user of this feature and
> > 	all requeued requests become special requests defeating
> > 	quiesce state.  This patch makes scsi midlayer use
> > 	blk_requeue_request() for requeueing and removes 'reinsert'
> > 	feature from blk_insert_request().
> > 
> > 	Note: In drivers/scsi/scsi_lib.c, scsi_single_lun_run() and
> > 	scsi_run_queue() are moved upward unchanged.
> 
> That lest part doesn't belong into this patch at all.

 Actually, it is, as scsi_queue_insert() is changed to call
scsi_run_queue() explicitly.  However, scsi_queue_insert() is removed
later, so the change is pretty dumb.  Maybe I'll add prototype and
remove it together later, or reorder patches.

 Thanks.

-- 
tejun

