From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 2/3] iscsi iser: increase max_sectors
Date: Tue, 12 Feb 2008 15:54:20 -0500
Message-ID: <20080212205420.GD13643@osc.edu>
References: <20080212205252.GB13643@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:39885 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbYBLUy3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 15:54:29 -0500
Content-Disposition: inline
In-Reply-To: <20080212205252.GB13643@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

iser has no limit on max sectors.  This lets iscsi iser support
large pass through commands just like iscsi TCP.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 1b272a6..78f3242 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -557,7 +557,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.change_queue_depth	= iscsi_change_queue_depth,
 	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
 	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
-	.max_sectors		= 1024,
+	.max_sectors		= 0xffff,
 	.cmd_per_lun            = ISCSI_MAX_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
-- 
1.5.3.8

