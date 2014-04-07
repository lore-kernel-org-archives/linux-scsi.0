From: Christoph Hellwig <hch@infradead.org>
Subject: SCSI_MLQUEUE_EH_RETRY?
Date: Mon, 7 Apr 2014 07:39:50 -0700
Message-ID: <20140407143950.GA11925@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaDGOju (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 10:39:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>

While the comments and code structure in scsi_io_completion suggest that
calling __scsi_queue_insert with SCSI_MLQUEUE_EH_RETRY has a different
effect from using SCSI_MLQUEUE_DEVICE_BUSY they are treated exactly the
same.

It seems like when SCSI_MLQUEUE_EH_RETRY was introduced it didn't set
device_blocked, but since commit 573e5913536a1393362265cfea9e708aa10fdf16
"[SCSI] scsi_lib: pause between error retries" they are one and the
same.

Is there any point in keeping SCSI_MLQUEUE_EH_RETRY?
