From: Achim Leubner <Achim.Leubner@pmcs.com>
Subject: RE: [PATCH 1/7] aacraid: AIF support for SES device add/remove
Date: Tue, 17 Mar 2015 15:24:37 +0000
Message-ID: <307F48E420013C4E85C75C93E532197AB809200D@BBYEXM01.pmc-sierra.internal>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1425458313-1956-2-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:55934 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932324AbbCQPyD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2015 11:54:03 -0400
In-Reply-To: <1425458313-1956-2-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Reviewed-by: Achim Leubner <Achim.Leubner@pmcs.com>

-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Wednesday, March 4, 2015 9:38 AM
To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rajinikanth Pandurangan; Rich Bono; Mahesh Rajashekhara
Subject: [PATCH 1/7] aacraid: AIF support for SES device add/remove

Add new AIF support for SES device add/remove

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |    2 ++
 drivers/scsi/aacraid/commsup.c |    8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h index eaaf870..284db39 100644
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
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c index cab190a..090ba68 100644
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

