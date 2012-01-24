From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 2/4] bnx2fc: Handle LOGO flooding from the target
Date: Mon, 23 Jan 2012 18:00:47 -0800
Message-ID: <1327370449-28168-3-git-send-email-bprakash@broadcom.com>
References: <1327370449-28168-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3263 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab2AXCBF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2012 21:01:05 -0500
In-Reply-To: <1327370449-28168-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, mchan@broadcom.com

Host drops sessions when flood of unsolicited LOGOs are received from the
target. Because of unsufficient PLOGI retries, upon exceeding the retry count
of 3, the target sessions are dropped. Increased the retry count to 255 to
allow sufficient retries in this scenario.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    2 ++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 049ea90..c5af098 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -114,6 +114,8 @@
 #define BNX2FC_HASH_TBL_CHUNK_SIZE	(16 * 1024)
 
 #define BNX2FC_MAX_SEQS			255
+#define BNX2FC_MAX_RETRY_CNT		3
+#define BNX2FC_MAX_RPORT_RETRY_CNT	255
 
 #define BNX2FC_READ			(1 << 1)
 #define BNX2FC_WRITE			(1 << 0)
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 10cf5d9..bd18ab5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -953,8 +953,8 @@ static int bnx2fc_lport_config(struct fc_lport *lport)
 {
 	lport->link_up = 0;
 	lport->qfull = 0;
-	lport->max_retry_count = 3;
-	lport->max_rport_retry_count = 3;
+	lport->max_retry_count = BNX2FC_MAX_RETRY_CNT;
+	lport->max_rport_retry_count = BNX2FC_MAX_RPORT_RETRY_CNT;
 	lport->e_d_tov = 2 * 1000;
 	lport->r_a_tov = 10 * 1000;
 
-- 
1.7.0.6


