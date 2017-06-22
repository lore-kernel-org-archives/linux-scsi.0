From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 15/17] cxlflash: Support WS16 unmap
Date: Wed, 21 Jun 2017 21:16:33 -0500
Message-ID: <1498097793-9224-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33877 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751998AbdFVCQm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:16:42 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M2EYRq001476
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:16:42 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b7p1m37qd-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:16:42 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 22:16:41 -0400
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The cxlflash driver supports performing a write-same16 to scrub virtual
luns when they are released by a user. To date, AFUs for adapters that
are supported by cxlflash do not have the capability to unmap as part of
the WS operation. This can lead to fragmented flash devices which results
in performance degradation.

Future AFUs can optionally support unmap write-same commands and reflects
this support via the context control register. This provides userspace
applications with direct visibility such that they need not depend on a
host API.

Detect unmap support during cxlflash initialization by reading the context
control register associated with the primary hardware queue. Update the
existing write_same16() routine to set the unmap bit in the CDB when unmap
is supported by the host.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h  |  1 +
 drivers/scsi/cxlflash/main.c    | 12 ++++++++++++
 drivers/scsi/cxlflash/sislite.h |  1 +
 drivers/scsi/cxlflash/vlun.c    |  1 +
 4 files changed, 15 insertions(+)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index a91151c..e95e5a5 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -147,6 +147,7 @@ struct cxlflash_cfg {
 	wait_queue_head_t tmf_waitq;
 	spinlock_t tmf_slock;
 	bool tmf_active;
+	bool ws_unmap;		/* Write-same unmap supported */
 	wait_queue_head_t reset_waitq;
 	enum cxlflash_state state;
 	async_cookie_t async_reset_cookie;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index d3ad52e..0cce442 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1812,6 +1812,18 @@ static int init_global(struct cxlflash_cfg *cfg)
 			SISL_CTX_CAP_AFU_CMD | SISL_CTX_CAP_GSCSI_CMD),
 			&hwq->ctrl_map->ctx_cap);
 	}
+
+	/*
+	 * Determine write-same unmap support for host by evaluating the unmap
+	 * sector support bit of the context control register associated with
+	 * the primary hardware queue. Note that while this status is reflected
+	 * in a context register, the outcome can be assumed to be host-wide.
+	 */
+	hwq = get_hwq(afu, PRIMARY_HWQ);
+	reg = readq_be(&hwq->host_map->ctx_ctrl);
+	if (reg & SISL_CTX_CTRL_UNMAP_SECTOR)
+		cfg->ws_unmap = true;
+
 	/* Initialize heartbeat */
 	afu->hb = readq_be(&afu->afu_map->global.regs.afu_hb);
 out:
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index d671fae..09daa86 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -283,6 +283,7 @@ struct sisl_host_map {
 	__be64 rrq_end;		/* write sequence: start followed by end */
 	__be64 cmd_room;
 	__be64 ctx_ctrl;	/* least significant byte or b56:63 is LISN# */
+#define SISL_CTX_CTRL_UNMAP_SECTOR	0x8000000000000000ULL /* b0 */
 	__be64 mbox_w;		/* restricted use */
 	__be64 sq_start;	/* Submission Queue (R/W): write sequence and */
 	__be64 sq_end;		/* inclusion semantics are the same as RRQ    */
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 0800bcb..bdfb930 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -446,6 +446,7 @@ static int write_same16(struct scsi_device *sdev,
 	while (left > 0) {
 
 		scsi_cmd[0] = WRITE_SAME_16;
+		scsi_cmd[1] = cfg->ws_unmap ? 0x8 : 0;
 		put_unaligned_be64(offset, &scsi_cmd[2]);
 		put_unaligned_be32(ws_limit < left ? ws_limit : left,
 				   &scsi_cmd[10]);
-- 
2.1.0
