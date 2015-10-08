From: Christoph Hellwig <hch@lst.de>
Subject: use host wide tags by default V2
Date: Thu,  8 Oct 2015 09:28:03 +0100
Message-ID: <1444292884-8622-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbbJHIbv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2015 04:31:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk

This patches changes the SCSI layer to always provide block layer
tags, and always make them host wide by default.  We've been doing
this for the blk-mq path since blk-mq was introduces and this catches
up in the old I/O path so that drivers get a coherent execution
environment.

Since V1 a few more drivers are using block tags and have been updated,
and a spinlock for a single assignment has been changed from the
previously used spinlock to a barrier by explicit request from James.
I refuse any responsibility for mental or physical harm caused by that
barrier.

