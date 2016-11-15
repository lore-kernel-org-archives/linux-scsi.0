From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 03/14] cxlflash: Improve context_reset() logic
Date: Tue, 15 Nov 2016 17:14:12 -0600
Message-ID: <1479251652-22780-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1030207AbcKOXO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 18:14:26 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFNECRk000814
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:14:25 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26rbr18810-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:14:25 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Tue, 15 Nov 2016 16:14:24 -0700
In-Reply-To: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Currently, the context reset routine waits for command room to
be available before sending the reset request. Per review of the
SISLite specification and clarifications from the CXL Flash AFU
designers, this wait is unnecessary. The reset request can be
sent anytime regardless of command room, so long as only a single
reset request is active at any one point in time.

This commit simplifies the reset routine by removing the wait for
command room. Additionally it adds a debug trace to help pinpoint
hardware errors when a context reset does not complete.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 6004860..6d33d8c 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -263,8 +263,9 @@ static void context_reset(struct afu_cmd *cmd)
 {
 	int nretry = 0;
 	u64 rrin = 0x1;
-	u64 room = 0;
 	struct afu *afu = cmd->parent;
+	struct cxlflash_cfg *cfg = afu->parent;
+	struct device *dev = &cfg->dev->dev;
 	ulong lock_flags;
 
 	pr_debug("%s: cmd=%p\n", __func__, cmd);
@@ -280,23 +281,6 @@ static void context_reset(struct afu_cmd *cmd)
 	cmd->sa.host_use_b[0] |= (B_DONE | B_ERROR | B_TIMEOUT);
 	spin_unlock_irqrestore(&cmd->slock, lock_flags);
 
-	/*
-	 * We really want to send this reset at all costs, so spread
-	 * out wait time on successive retries for available room.
-	 */
-	do {
-		room = readq_be(&afu->host_map->cmd_room);
-		atomic64_set(&afu->room, room);
-		if (room)
-			goto write_rrin;
-		udelay(1 << nretry);
-	} while (nretry++ < MC_ROOM_RETRY_CNT);
-
-	pr_err("%s: no cmd_room to send reset\n", __func__);
-	return;
-
-write_rrin:
-	nretry = 0;
 	writeq_be(rrin, &afu->host_map->ioarrin);
 	do {
 		rrin = readq_be(&afu->host_map->ioarrin);
@@ -305,6 +289,9 @@ static void context_reset(struct afu_cmd *cmd)
 		/* Double delay each time */
 		udelay(1 << nretry);
 	} while (nretry++ < MC_ROOM_RETRY_CNT);
+
+	dev_dbg(dev, "%s: returning rrin=0x%016llX nretry=%d\n",
+		__func__, rrin, nretry);
 }
 
 /**
-- 
2.1.0

