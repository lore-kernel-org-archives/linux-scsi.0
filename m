From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 14/29] scsi: aacraid: Move function around to match existing code
Date: Thu, 21 Dec 2017 09:34:05 -0800
Message-ID: <20171221173420.8213-15-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0044.outbound.protection.outlook.com ([104.47.40.44]:24992
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753849AbdLURem (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:42 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

Move the function to get phy luns information to the top of function
to set target information

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c | 112 +++++++++++++++++++++---------------------
 1 file changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index cf02910..affa2f1 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1794,6 +1794,62 @@ static int aac_issue_safw_bmic_identify(struct aac_dev *dev,
 	return rcode;
 }
 
+static inline void aac_free_safw_ciss_luns(struct aac_dev *dev)
+{
+	kfree(dev->safw_phys_luns);
+	dev->safw_phys_luns = NULL;
+}
+
+/**
+ *	aac_get_safw_ciss_luns()	Process topology change
+ *	@dev:		aac_dev structure
+ *	@rescan		Indicates rescan
+ *
+ *	Execute a CISS REPORT PHYS LUNS and process the results into
+ *	the current hba_map.
+ */
+static int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan)
+{
+	int rcode = -ENOMEM;
+	int datasize;
+	struct aac_srb *srbcmd;
+	struct aac_srb_unit srbu;
+	struct aac_ciss_phys_luns_resp *phys_luns;
+
+	datasize = sizeof(struct aac_ciss_phys_luns_resp) +
+		(AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
+	phys_luns = kmalloc(datasize, GFP_KERNEL);
+	if (phys_luns == NULL)
+		goto out;
+
+	memset(&srbu, 0, sizeof(struct aac_srb_unit));
+
+	srbcmd = &srbu.srb;
+	srbcmd->flags	= cpu_to_le32(SRB_DataIn);
+	srbcmd->cdb[0]	= CISS_REPORT_PHYSICAL_LUNS;
+	srbcmd->cdb[1]	= 2; /* extended reporting */
+	srbcmd->cdb[8]	= (u8)(datasize >> 8);
+	srbcmd->cdb[9]	= (u8)(datasize);
+
+	rcode = aac_send_safw_bmic_cmd(dev, &srbu, phys_luns, datasize);
+	if (unlikely(rcode < 0))
+		goto mem_free_all;
+
+	if (phys_luns->resp_flag != 2) {
+		rcode = -ENOMSG;
+		goto mem_free_all;
+	}
+
+	dev->safw_phys_luns = phys_luns;
+
+out:
+	return rcode;
+mem_free_all:
+	kfree(phys_luns);
+	goto out;
+
+}
+
 /**
  *	aac_set_safw_attr_all_targets-	update current hba map with data from FW
  *	@dev:	aac_dev structure
@@ -1857,62 +1913,6 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev, int rescan)
 	}
 }
 
-static inline void aac_free_safw_ciss_luns(struct aac_dev *dev)
-{
-	kfree(dev->safw_phys_luns);
-	dev->safw_phys_luns = NULL;
-}
-
-/**
- *	aac_get_safw_ciss_luns()	Process topology change
- *	@dev:		aac_dev structure
- *	@rescan		Indicates rescan
- *
- *	Execute a CISS REPORT PHYS LUNS and process the results into
- *	the current hba_map.
- */
-static int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan)
-{
-	int rcode = -ENOMEM;
-	int datasize;
-	struct aac_srb *srbcmd;
-	struct aac_srb_unit srbu;
-	struct aac_ciss_phys_luns_resp *phys_luns;
-
-	datasize = sizeof(struct aac_ciss_phys_luns_resp) +
-		(AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
-	phys_luns = kmalloc(datasize, GFP_KERNEL);
-	if (phys_luns == NULL)
-		goto out;
-
-	memset(&srbu, 0, sizeof(struct aac_srb_unit));
-
-	srbcmd = &srbu.srb;
-	srbcmd->flags	= cpu_to_le32(SRB_DataIn);
-	srbcmd->cdb[0]	= CISS_REPORT_PHYSICAL_LUNS;
-	srbcmd->cdb[1]	= 2; /* extended reporting */
-	srbcmd->cdb[8]	= (u8)(datasize >> 8);
-	srbcmd->cdb[9]	= (u8)(datasize);
-
-	rcode = aac_send_safw_bmic_cmd(dev, &srbu, phys_luns, datasize);
-	if (unlikely(rcode < 0))
-		goto mem_free_all;
-
-	if (phys_luns->resp_flag != 2) {
-		rcode = -ENOMSG;
-		goto mem_free_all;
-	}
-
-	dev->safw_phys_luns = phys_luns;
-
-out:
-	return rcode;
-mem_free_all:
-	kfree(phys_luns);
-	goto out;
-
-}
-
 static int aac_setup_safw_targets(struct aac_dev *dev, int rescan)
 {
 	int rcode = 0;
-- 
2.9.4
