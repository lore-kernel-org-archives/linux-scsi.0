From: michaelc@cs.wisc.edu
Subject: [PATCH 2/5] be2iscsi: Fix for wrong dmsg setting in wrb
Date: Fri,  7 Oct 2011 19:31:09 -0500
Message-ID: <1318033872-5900-3-git-send-email-michaelc@cs.wisc.edu>
References: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab1JHAZ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 20:25:57 -0400
In-Reply-To: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

   This patch fixes wrong dmsg setting when we send out wrb.

If the ttt is not ISCSI_RESERVED_TAG then we should be setting
dmsg=1 so that the completion is done without waiting for a
iscsi level response from the target

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 804c46e..e166d54 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4044,11 +4044,11 @@ static int beiscsi_mtask(struct iscsi_task *task)
 				      TGT_DM_CMD);
 			AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt,
 				      pwrb, 0);
-			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 1);
 		} else {
 			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_RD_CMD);
-			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 1);
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		}
 		hwi_write_buffer(pwrb, task);
 		break;
-- 
1.7.6

