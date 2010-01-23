From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 7/8] be2iscsi: changing the chip opcode for TEXT
Date: Sat, 23 Jan 2010 05:38:56 +0530
Message-ID: <20100123000846.GA12676@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:40050 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751466Ab0AWAIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2010 19:08:52 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patch corrects the chipopcode for text and chooses
correct paramters for that command

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 85c0e80..932cb8a 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3513,9 +3513,8 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		break;
 	case ISCSI_OP_TEXT:
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
-			      INI_WR_CMD);
+			      TGT_DM_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
-		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
-- 
1.6.4

