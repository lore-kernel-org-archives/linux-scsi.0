From: Christoph Hellwig <hch@lst.de>
Subject: fix command completion races in the 3ware drivers
Date: Thu, 23 Apr 2015 09:48:48 +0200
Message-ID: <1429775331-1017-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37393 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbbDWHtx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 03:49:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Torsten Luettgert <ml-lkml@enda.eu>, Bernd Kardatzki <Bernd.Kardatzki@med.uni-tuebingen.de>

All three 3ware drivers complete the scsi command before calling
scsi_dma_unmap.  This is racy as the command can get torn down
once ->scsi_done has been called, but until 3.17 we papered
over this by taking the host lock in the completion pass, which
masked out this race for all common workloads.

