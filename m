From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 07/12] be2iscsi: decide which requests need completion
Date: Tue, 5 Jan 2010 05:09:19 +0530
Message-ID: <20100104233906.GA16815@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:14659 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753853Ab0ADXi5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 18:38:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patch decides whether ack based completion is required or not

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0fae264..26d7016 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3546,6 +3546,11 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		else
 			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_RD_CMD);
+		if (task->hdr->ttt == ISCSI_RESERVED_TAG)
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+		else
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 1);
+
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_TEXT:
@@ -3554,6 +3559,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		else
 			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_WR_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
 		break;
-- 
1.6.4

