From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/39] [WIP] scsi multiqueue
Date: Mon, 17 Mar 2014 06:27:33 -0700
Message-ID: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbaCQNbb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2014 09:31:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I'd like to repost the current state of the scsi multiqueue work.  This
version has shown stable under various loads and is getting close to
feature complete.  So far we see it improving the IOPS over the old code
up to 30% and maxing out the current test hardware, so we will have to
test on bigger hardware for more numbers.  More impressive is the CPU
usage reduction of over 200% on multi-lun tests where we can now mostly
avoid the host lock contention.

The big remaining TODO item is to look into the queue limit and tag
allocation in blk-mq to make it work for all existing SCSI drivers.

Feel free to test it with the existing drivers that set use_blk_mq as well
as with any other driver that doesn't use scsi_init_shared_tag_map.
