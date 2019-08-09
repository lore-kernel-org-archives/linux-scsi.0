Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29B5C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92BC6216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405001AbfHIDDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:23 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45253 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:23 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so45214193pfq.12
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kAmSEzK1L/Io+llOkawSkizujLPqRh81CkzlWmJDPPU=;
        b=o0VgDbWFEmoRx92BW72GJNNHeinCL6yjYFyHSR8Ek6B8dav5TYU9McfUQp0VJf+2+I
         BDrk5YWzfLDROezsCt43VQ1CCHsxltX6vWMDkIAwZBLRYbUZzPdEv5buYGoV/ONs8PpU
         REmcLTnaF/i+TBSRwxTje8MkaLZdBFlGNccftcr5BPjYHyiqXRcgkMpWMxLsyacdbS20
         xHWr1ZrZ8VJRA0hn3KE/UWvuiC+sLJ8nbrYmS1PqiozAljVLQP/sB2gy9ImEZodek3/T
         oDCpPtlkciJYTl+50ToWEqwMarz0m6jeM4d+h04TRimsqn9wA3leZy/ySmixBppM7v+k
         Gx4w==
X-Gm-Message-State: APjAAAW3oLZZt6smE8QbpMVp/RWM4qK+zpgzIsB4Zmeecnxlm29zFybt
        O8LSuuyEvkmvz661wDp7Ov0=
X-Google-Smtp-Source: APXvYqyXO6nJybmapjVSjX9lIZ9k6ByBtOz7abesx+1EvaL4RuQjbohSlTUCYfnSi+onF6KcX78tow==
X-Received: by 2002:a62:be02:: with SMTP id l2mr19360419pff.63.1565319802196;
        Thu, 08 Aug 2019 20:03:22 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 34/58] qla2xxx: Check the PCI info string output buffer size
Date:   Thu,  8 Aug 2019 20:01:55 -0700
Message-Id: <20190809030219.11296-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pass the output buffer size to the code that generates a PCI info string
and check the output buffer size while generating a PCI info string.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |  3 +-
 drivers/scsi/qla2xxx/qla_def.h  |  2 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |  2 +-
 drivers/scsi/qla2xxx/qla_mr.c   |  8 ++---
 drivers/scsi/qla2xxx/qla_os.c   | 59 ++++++++++++++-------------------
 5 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e3de20918efb..e9c449ef515c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1125,7 +1125,8 @@ qla2x00_pci_info_show(struct device *dev, struct device_attribute *attr,
 	char pci_info[30];
 
 	return scnprintf(buf, PAGE_SIZE, "%s\n",
-	    vha->hw->isp_ops->pci_info_str(vha, pci_info));
+			 vha->hw->isp_ops->pci_info_str(vha, pci_info,
+							sizeof(pci_info)));
 }
 
 static ssize_t
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1c6811bd5625..8c8279ef3e32 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3112,7 +3112,7 @@ struct isp_operations {
 	void (*update_fw_options) (struct scsi_qla_host *);
 	int (*load_risc) (struct scsi_qla_host *, uint32_t *);
 
-	char * (*pci_info_str) (struct scsi_qla_host *, char *);
+	char * (*pci_info_str)(struct scsi_qla_host *, char *, size_t);
 	char * (*fw_version_str)(struct scsi_qla_host *, char *, size_t);
 
 	irq_handler_t intr_handler;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fc54e7c86463..2d9664086f15 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -732,7 +732,7 @@ extern int qlafx00_initialize_adapter(struct scsi_qla_host *);
 extern int qlafx00_soft_reset(scsi_qla_host_t *);
 extern int qlafx00_chip_diag(scsi_qla_host_t *);
 extern void qlafx00_config_rings(struct scsi_qla_host *);
-extern char *qlafx00_pci_info_str(struct scsi_qla_host *, char *);
+extern char *qlafx00_pci_info_str(struct scsi_qla_host *, char *, size_t);
 extern char *qlafx00_fw_version_str(struct scsi_qla_host *, char *, size_t);
 extern irqreturn_t qlafx00_intr_handler(int, void *);
 extern void qlafx00_enable_intrs(struct qla_hw_data *);
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 9e3f2f462a2e..759fcfecc310 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -688,14 +688,12 @@ qlafx00_config_rings(struct scsi_qla_host *vha)
 }
 
 char *
-qlafx00_pci_info_str(struct scsi_qla_host *vha, char *str)
+qlafx00_pci_info_str(struct scsi_qla_host *vha, char *str, size_t str_len)
 {
 	struct qla_hw_data *ha = vha->hw;
 
-	if (pci_is_pcie(ha->pdev)) {
-		strcpy(str, "PCIe iSA");
-		return str;
-	}
+	if (pci_is_pcie(ha->pdev))
+		strlcpy(str, "PCIe iSA", str_len);
 	return str;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e91681cbd75d..a247dce0cb95 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -536,80 +536,70 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 }
 
 static char *
-qla2x00_pci_info_str(struct scsi_qla_host *vha, char *str)
+qla2x00_pci_info_str(struct scsi_qla_host *vha, char *str, size_t str_len)
 {
 	struct qla_hw_data *ha = vha->hw;
-	static char *pci_bus_modes[] = {
+	static const char *const pci_bus_modes[] = {
 		"33", "66", "100", "133",
 	};
 	uint16_t pci_bus;
 
-	strcpy(str, "PCI");
 	pci_bus = (ha->pci_attr & (BIT_9 | BIT_10)) >> 9;
 	if (pci_bus) {
-		strcat(str, "-X (");
-		strcat(str, pci_bus_modes[pci_bus]);
+		snprintf(str, str_len, "PCI-X (%s MHz)",
+			 pci_bus_modes[pci_bus]);
 	} else {
 		pci_bus = (ha->pci_attr & BIT_8) >> 8;
-		strcat(str, " (");
-		strcat(str, pci_bus_modes[pci_bus]);
+		snprintf(str, str_len, "PCI (%s MHz)", pci_bus_modes[pci_bus]);
 	}
-	strcat(str, " MHz)");
 
-	return (str);
+	return str;
 }
 
 static char *
-qla24xx_pci_info_str(struct scsi_qla_host *vha, char *str)
+qla24xx_pci_info_str(struct scsi_qla_host *vha, char *str, size_t str_len)
 {
-	static char *pci_bus_modes[] = { "33", "66", "100", "133", };
+	static const char *const pci_bus_modes[] = {
+		"33", "66", "100", "133",
+	};
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t pci_bus;
 
 	if (pci_is_pcie(ha->pdev)) {
-		char lwstr[6];
 		uint32_t lstat, lspeed, lwidth;
+		const char *speed_str;
 
 		pcie_capability_read_dword(ha->pdev, PCI_EXP_LNKCAP, &lstat);
 		lspeed = lstat & PCI_EXP_LNKCAP_SLS;
 		lwidth = (lstat & PCI_EXP_LNKCAP_MLW) >> 4;
 
-		strcpy(str, "PCIe (");
 		switch (lspeed) {
 		case 1:
-			strcat(str, "2.5GT/s ");
+			speed_str = "2.5GT/s";
 			break;
 		case 2:
-			strcat(str, "5.0GT/s ");
+			speed_str = "5.0GT/s";
 			break;
 		case 3:
-			strcat(str, "8.0GT/s ");
+			speed_str = "8.0GT/s";
 			break;
 		default:
-			strcat(str, "<unknown> ");
+			speed_str = "<unknown>";
 			break;
 		}
-		snprintf(lwstr, sizeof(lwstr), "x%d)", lwidth);
-		strcat(str, lwstr);
+		snprintf(str, str_len, "PCIe (%s x%d)", speed_str, lwidth);
 
 		return str;
 	}
 
-	strcpy(str, "PCI");
 	pci_bus = (ha->pci_attr & CSRX_PCIX_BUS_MODE_MASK) >> 8;
-	if (pci_bus == 0 || pci_bus == 8) {
-		strcat(str, " (");
-		strcat(str, pci_bus_modes[pci_bus >> 3]);
-	} else {
-		strcat(str, "-X ");
-		if (pci_bus & BIT_2)
-			strcat(str, "Mode 2");
-		else
-			strcat(str, "Mode 1");
-		strcat(str, " (");
-		strcat(str, pci_bus_modes[pci_bus & ~BIT_2]);
-	}
-	strcat(str, " MHz)");
+	if (pci_bus == 0 || pci_bus == 8)
+		snprintf(str, str_len, "PCI (%s MHz)",
+			 pci_bus_modes[pci_bus >> 3]);
+	else
+		snprintf(str, str_len, "PCI-X Mode %d (%s MHz)",
+			 pci_bus & 4 ? 2 : 1,
+			 pci_bus_modes[pci_bus & 3]);
 
 	return str;
 }
@@ -3460,7 +3450,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    "QLogic %s - %s.\n", ha->model_number, ha->model_desc);
 	ql_log(ql_log_info, base_vha, 0x00fc,
 	    "ISP%04X: %s @ %s hdma%c host#=%ld fw=%s.\n",
-	    pdev->device, ha->isp_ops->pci_info_str(base_vha, pci_info),
+	    pdev->device, ha->isp_ops->pci_info_str(base_vha, pci_info,
+						       sizeof(pci_info)),
 	    pci_name(pdev), ha->flags.enable_64bit_addressing ? '+' : '-',
 	    base_vha->host_no,
 	    ha->isp_ops->fw_version_str(base_vha, fw_str, sizeof(fw_str)));
-- 
2.22.0

