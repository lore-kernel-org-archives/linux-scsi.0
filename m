From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 1/3] iscsi iser: remove DMA restrictions
Date: Tue, 12 Feb 2008 15:54:03 -0500
Message-ID: <20080212205403.GC13643@osc.edu>
References: <20080212205252.GB13643@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:39877 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbYBLUyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 15:54:07 -0500
Content-Disposition: inline
In-Reply-To: <20080212205252.GB13643@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

iscsi_iser does not have any hardware DMA restrictions.  Add a
slave_configure function to remove any DMA alignment restriction,
allowing the use of direct IO from arbitrary offsets within a page.
Also disable page bouncing; iser has no restrictions on which pages it
can address.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index be1b9fb..1b272a6 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -543,6 +543,13 @@ iscsi_iser_ep_disconnect(__u64 ep_handle)
 	iser_conn_terminate(ib_conn);
 }
 
+static int iscsi_iser_slave_configure(struct scsi_device *sdev)
+{
+	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
+	blk_queue_dma_alignment(sdev->request_queue, 0);
+	return 0;
+}
+
 static struct scsi_host_template iscsi_iser_sht = {
 	.module                 = THIS_MODULE,
 	.name                   = "iSCSI Initiator over iSER, v." DRV_VER,
@@ -556,6 +563,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.slave_configure	= iscsi_iser_slave_configure,
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
 };
-- 
1.5.3.8

