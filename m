From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 1/3 v2] iscsi iser: remove DMA alignment restriction
Date: Thu, 14 Feb 2008 16:10:29 -0500
Message-ID: <20080214211029.GA21073@osc.edu>
References: <20080213195912.GC7372@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:47713 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765504AbYBNVKb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 16:10:31 -0500
Content-Disposition: inline
In-Reply-To: <20080213195912.GC7372@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

Thanks to James pointing out the problems with the BLK_BOUNCE_ANY
for IB devices, this revised patch contains only the DMA alignment
fix for iSER.

Mike, can you take care of this and the other two patches in the
series:

    [PATCH 2/3] iscsi iser: increase max_sectors
    [PATCH 3/3] iscsi iser: increase sg_tablesize

		-- Pete


>From 255e73b67ec1458af18395981fddebdc958e8fe9 Mon Sep 17 00:00:00 2001
From: Pete Wyckoff <pw@osc.edu>
Date: Thu, 14 Feb 2008 16:09:27 -0500
Subject: [PATCH] iscsi iser: remove DMA alignment restriction

iscsi_iser does not require any particular DMA aligement
requirement.  Add a slave_configure function to set the alignment
to zero, allowing the use of direct IO from arbitrary offsets
within a page.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index be1b9fb..313f102 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -543,6 +543,12 @@ iscsi_iser_ep_disconnect(__u64 ep_handle)
 	iser_conn_terminate(ib_conn);
 }
 
+static int iscsi_iser_slave_configure(struct scsi_device *sdev)
+{
+	blk_queue_dma_alignment(sdev->request_queue, 0);
+	return 0;
+}
+
 static struct scsi_host_template iscsi_iser_sht = {
 	.module                 = THIS_MODULE,
 	.name                   = "iSCSI Initiator over iSER, v." DRV_VER,
@@ -556,6 +562,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.slave_configure	= iscsi_iser_slave_configure,
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
 };
-- 
1.5.3.8

