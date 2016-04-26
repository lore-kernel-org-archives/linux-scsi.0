From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 07/10] aacraid: Log firmware AIF messages
Date: Mon, 25 Apr 2016 23:32:09 -0700
Message-ID: <20160426063209.28402.28263.stgit@pmcuser-System-Product-Name>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0071.outbound.protection.outlook.com ([65.55.169.71]:20671
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752293AbcDZGgz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:36:55 -0400
In-Reply-To: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

Firmware AIF messages about cache loss and data recovery are being missed
by the driver since currently they are not captured but rather let go.
This patch to capture those messages and log them for the user.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h |    4 ++++
 drivers/scsi/aacraid/commsup.c |   27 +++++++++++++++++++++++++++
 drivers/scsi/aacraid/linit.c   |    2 ++
 drivers/scsi/aacraid/src.c     |    3 ++-
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 1936e08..b70f3eb 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2065,6 +2065,10 @@ extern struct aac_common aac_config;
 #define			AifEnAddJBOD		30	/* JBOD created */
 #define			AifEnDeleteJBOD		31	/* JBOD deleted */
 
+#define			AifBuManagerEvent		42 /* Bu management*/
+#define			AifBuCacheDataLoss		10
+#define			AifBuCacheDataRecover	11
+
 #define		AifCmdJobProgress	2	/* Progress report */
 #define			AifJobCtrZero	101	/* Array Zero progress */
 #define			AifJobStsSuccess 1	/* Job completes */
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index bb7988d..0aeecec 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -901,6 +901,31 @@ void aac_printf(struct aac_dev *dev, u32 val)
 	memset(cp, 0, 256);
 }
 
+static inline int aac_aif_data(struct aac_aifcmd *aifcmd, uint32_t index)
+{
+	return le32_to_cpu(((__le32 *)aifcmd->data)[index]);
+}
+
+
+static void aac_handle_aif_bu(struct aac_dev *dev, struct aac_aifcmd *aifcmd)
+{
+	switch (aac_aif_data(aifcmd, 1)) {
+	case AifBuCacheDataLoss:
+		if (aac_aif_data(aifcmd, 2))
+			dev_info(&dev->pdev->dev, "Backup unit had cache data loss - [%d]\n",
+			aac_aif_data(aifcmd, 2));
+		else
+			dev_info(&dev->pdev->dev, "Backup Unit had cache data loss\n");
+		break;
+	case AifBuCacheDataRecover:
+		if (aac_aif_data(aifcmd, 2))
+			dev_info(&dev->pdev->dev, "DDR cache data recovered successfully - [%d]\n",
+			aac_aif_data(aifcmd, 2));
+		else
+			dev_info(&dev->pdev->dev, "DDR cache data recovered successfully\n");
+		break;
+	}
+}
 
 /**
  *	aac_handle_aif		-	Handle a message from the firmware
@@ -1154,6 +1179,8 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 				  ADD : DELETE;
 				break;
 			}
+			case AifBuManagerEvent:
+				aac_handle_aif_bu(dev, aifcmd);
 			break;
 		}
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 79a1cec..a943bd2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1299,6 +1299,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		shost->this_id = shost->max_id;
 
+	aac_intr_normal(aac, 0, 2, 0, NULL);
+
 	/*
 	 * dmb - we may need to move the setting of these parms somewhere else once
 	 * we get a fib that can report the actual numbers
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index bc0203f..28f8b8a 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -135,7 +135,8 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 
 	if (mode & AAC_INT_MODE_AIF) {
 		/* handle AIF */
-		aac_intr_normal(dev, 0, 2, 0, NULL);
+		if (dev->aif_thread && dev->fsa_dev)
+			aac_intr_normal(dev, 0, 2, 0, NULL);
 		if (dev->msi_enabled)
 			aac_src_access_devreg(dev, AAC_CLEAR_AIF_BIT);
 		mode = 0;

