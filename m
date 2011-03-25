From: <jayamohan.kallickal@emulex.com>
Subject: [PATCH 5/5] be2iscsi: Bug Fix for proper setting of FW
Date: Fri, 25 Mar 2011 14:24:01 -0700
Message-ID: <a53af07f-91fd-4a14-8c04-9c639aa9c173@exht1.ad.emulex.com>
References: <1301088242-29477-1-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:59774 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755257Ab1CYVZO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 17:25:14 -0400
In-Reply-To: <1301088242-29477-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

           There was a bug in setting up type and dmsg for FW

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 91b354d..d834136 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4020,12 +4020,17 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_NOOP_OUT:
-		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
-			      INI_RD_CMD);
-		if (task->hdr->ttt == ISCSI_RESERVED_TAG)
+		if (task->hdr->ttt != ISCSI_RESERVED_TAG) {
+			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+				      TGT_DM_CMD);
+			AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt,
+				      pwrb, 0);
 			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
-		else
+		} else {
+			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+				      INI_RD_CMD);
 			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 1);
+		}
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_TEXT:
-- 
1.7.4.1

