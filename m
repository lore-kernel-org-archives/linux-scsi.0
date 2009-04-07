From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/15] qla2xxx: Perform an implicit login to the Management Server.
Date: Mon,  6 Apr 2009 22:33:46 -0700
Message-ID: <1239082431-19496-11-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZDGFeA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:34:00 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Set the conditional plogi option bit whenever logging in the
fabric management server (if it is already logged in, it does not
need an explicit login; an implicit login suffices).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 557f58d..3dbb9e7 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1107,7 +1107,7 @@ qla2x00_mgmt_svr_login(scsi_qla_host_t *vha)
 		return ret;
 
 	ha->isp_ops->fabric_login(vha, vha->mgmt_svr_loop_id, 0xff, 0xff, 0xfa,
-	    mb, BIT_1);
+	    mb, BIT_1|BIT_0);
 	if (mb[0] != MBS_COMMAND_COMPLETE) {
 		DEBUG2_13(printk("%s(%ld): Failed MANAGEMENT_SERVER login: "
 		    "loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x mb[6]=%x mb[7]=%x\n",
-- 
1.6.2.2.404.ge96f3

