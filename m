From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH 1/7] aacraid: AIF support for SES device add/remove
Date: Wed, 4 Mar 2015 03:38:27 -0500
Message-ID: <1425458313-1956-2-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:42637 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932822AbbCDJP7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 04:15:59 -0500
In-Reply-To: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Achim.Leubner@pmcs.com, Rajinikanth.Pandurangan@pmcs.com, Rich.Bono@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Add new AIF support for SES device add/remove

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |    2 ++
 drivers/scsi/aacraid/commsup.c |    8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index eaaf870..284db39 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1951,6 +1951,8 @@ extern struct aac_common aac_config;
 #define			AifEnEnclosureManagement 13	/* EM_DRIVE_* */
 #define				EM_DRIVE_INSERTION	31
 #define				EM_DRIVE_REMOVAL	32
+#define			EM_SES_DRIVE_INSERTION	33
+#define			EM_SES_DRIVE_REMOVAL	26
 #define			AifEnBatteryEvent	14	/* Change in Battery State */
 #define			AifEnAddContainer	15	/* A new array was created */
 #define			AifEnDeleteContainer	16	/* A container was deleted */
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index cab190a..090ba68 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1044,6 +1044,8 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 			switch (le32_to_cpu(((__le32 *)aifcmd->data)[3])) {
 			case EM_DRIVE_INSERTION:
 			case EM_DRIVE_REMOVAL:
+			case EM_SES_DRIVE_INSERTION:
+			case EM_SES_DRIVE_REMOVAL:
 				container = le32_to_cpu(
 					((__le32 *)aifcmd->data)[2]);
 				if ((container >> 28)) {
@@ -1069,8 +1071,10 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 				}
 				channel = aac_phys_to_logical(channel);
 				device_config_needed =
-				  (((__le32 *)aifcmd->data)[3]
-				    == cpu_to_le32(EM_DRIVE_INSERTION)) ?
+				  ((((__le32 *)aifcmd->data)[3]
+				    == cpu_to_le32(EM_DRIVE_INSERTION)) ||
+				    (((__le32 *)aifcmd->data)[3]
+				    == cpu_to_le32(EM_SES_DRIVE_INSERTION))) ?
 				  ADD : DELETE;
 				break;
 			}
-- 
1.7.7.3

