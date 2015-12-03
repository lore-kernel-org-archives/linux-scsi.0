From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] scsi: make scsi_eh_scmd_add() always succeed
Date: Thu, 3 Dec 2015 17:51:58 +0100
Message-ID: <20151203165158.GB14775@lst.de>
References: <1449127063-94512-1-git-send-email-hare@suse.de> <1449127063-94512-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35673 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbbLCQwA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 11:52:00 -0500
Content-Disposition: inline
In-Reply-To: <1449127063-94512-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org

On Thu, Dec 03, 2015 at 08:17:40AM +0100, Hannes Reinecke wrote:
> scsi_eh_scmd_add() currently only will fail if no
> error handler thread is started (which will never be the
> case) or if the state machine encounters an illegal transition.
> 
> But if we're encountering an invalid state transition
> chances is we cannot fixup things with the error handler.
> So better add a WARN_ON for illegal host states and
> make scsi_dh_scmd_add() a void function.

The ehandler parts looks trivially correct, but I'm a little worried
about the state transition.  The states that we can't transition from
are: SHOST_CREATED, SHOST_DEL and SHOST_DEL_RECOVERY.

We initialize the state to SHOST_CREATED in scsi_host_alloc and
transition away from it in scsi_add_host_with_dma, so that's a true
"should be impossible" condition.

We transition to SHOST_DEL or SHOST_DEL_RECOVERY in scsi_remove_host
and the host remains in it until the final reference is dropped. Given
that we wait for all pending I/O in blk_cleanup_queue called from
__scsi_remove_device this should be fine as well.

So:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But preferably with an updated changelog that explains things better.
