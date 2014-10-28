From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] scsi: split scsi_nonblockable_ioctl
Date: Tue, 28 Oct 2014 18:39:26 +0100
Message-ID: <20141028173926.GB22593@lst.de>
References: <1414432746-12888-1-git-send-email-hch@lst.de> <1414432746-12888-3-git-send-email-hch@lst.de> <544F5C5C.3090104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37845 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbaJ1Rja (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2014 13:39:30 -0400
Content-Disposition: inline
In-Reply-To: <544F5C5C.3090104@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

On Tue, Oct 28, 2014 at 10:05:32AM +0100, Bart Van Assche wrote:
> I might be missing some background information here, but it's not clear to 
> me why the function like scsi_block_when_processing_errors() was introduced 
> some time ago. What if immediately after error handling has finished a new 
> request is queued that kicks the error handler again before the caller of 
> scsi_block_when_processing_errors() has finished the actions that should 
> not occur concurrently with error handling ? Has it already been considered 
> to introduce a mutex to serialize error handling and activity that should 
> not occur concurrently with error handling ?

I've not looked into changing the conditions, but your questions are
good ones.  I'd like to go even further and ask the question of what
we try to protect here.  For SG_SCSI_RESET the answer is that we want
to enforce a single outstanding TMF, as require by old parallel SCSI HBAs,
and possible by various drivers.  I don't quite understand why we check
the EH state before executing other ioctl, though.  Even more confusing
is that some driver like st.c and sg.c only enforce this on some ioctls.

Changing the exclusion rules isn't in the scope of this series, but if
you interested in looking into this series I'd be happy if we get the
ball on it rolling.
