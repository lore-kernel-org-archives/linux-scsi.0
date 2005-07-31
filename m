From: domen@coderock.org
Subject: [patch 1/1] drivers/scsi/qlogicfc.c : Use of the time_after() macro
Date: Sun, 31 Jul 2005 13:11:57 +0200
Message-ID: <20050731111157.568752000@homer>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:54212 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261813AbVGaLL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 07:11:58 -0400
Content-Disposition: inline; filename=time_after-drivers_scsi_qlogicfc
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, Marcelo Feitoza Parisi <marcelo@feitoza.com.br>, domen@coderock.org

From: Marcelo Feitoza Parisi <marcelo@feitoza.com.br>



Use of the time_after() macro, defined at linux/jiffies.h, which deal
with wrapping correctly and are nicer to read.

Signed-off-by: Marcelo Feitoza Parisi <marcelo@feitoza.com.br>
Signed-off-by: Domen Puncer <domen@coderock.org>

---
 qlogicfc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

Index: quilt/drivers/scsi/qlogicfc.c
===================================================================
--- quilt.orig/drivers/scsi/qlogicfc.c
+++ quilt/drivers/scsi/qlogicfc.c
@@ -1326,7 +1326,8 @@ static int isp2x00_queuecommand(Scsi_Cmn
 		cmd->control_flags = cpu_to_le16(CFLAG_READ);
 
 	if (Cmnd->device->tagged_supported) {
-		if ((jiffies - hostdata->tag_ages[Cmnd->device->id]) > (2 * ISP_TIMEOUT)) {
+		if (time_after(jiffies, hostdata->tag_ages[Cmnd->device->id]
+					+ (2 * ISP_TIMEOUT))) {
 			cmd->control_flags |= cpu_to_le16(CFLAG_ORDERED_TAG);
 			hostdata->tag_ages[Cmnd->device->id] = jiffies;
 		} else

--
