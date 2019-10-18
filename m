Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3860FCA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F38292089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMIa2Stl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503037AbfJRVTW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40863 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502466AbfJRVTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id e13so4017256pga.7
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+sLyWXhJT27YEDiChxsHss7rBbTeSrvjMFoj3ugxkYE=;
        b=XMIa2Stl/iHlAJMS3lzkDrrxRKiP8jHTIQGVSA//1S9i2Go0tvuus4SNjTxvnkNlV7
         8eS8ygndQxZPx3kleLUsA+tuLgY2db2F7bE1xQby9QDeptcuGmEnLVKUMXs3riufY6lY
         skpVtAWZQlYr6b5b6B3S06ZQIbZKqz+1Y/BeSw9Ur9n42v8VAeLvm58UfR4zqrYqirW/
         9NA9m7I4J4i2LDTxFGZdMvpAtJhtiDGjCQP/IVM2H90gw13kqUUUQShXnrYH0lUWG5U+
         Rzj/dBuRz7RRi/5yYN5Rpx+YqZj+kjMAEDUbmJnS+OxcH4Qu8Oz5yEL5q7NBXximBzwl
         ipqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+sLyWXhJT27YEDiChxsHss7rBbTeSrvjMFoj3ugxkYE=;
        b=rZYoani4Weh9Zcxtn+iTSnniAgxLbzKoLU0kuHTMBg/tPWs1vsnU2e8AtpXyWl8xVA
         4LN1BOVvAXHYduieQBQmYxV70i4glTN2Zn7yHXDlUCAeHpxf0d3z+YmNInyUIk/tDoVf
         dJJj9jsbBY/XATc1zJK+bNivRQY7gG9aEyL2wkWw8YQHcD3UDBradXE1IjnBWUHD+pZm
         iyVECan7qJo7BoJyeHPgv3OR8v1aY1Kq+h7wEOKh0/D28glRYMNoYtAcvObJpkr+zMIw
         SEfJ2pUB/uJK+XTVvaC9WApLbPDu58cCCi0/9S7WSduX3K/dgUq+ZFun8GkHapjU3A20
         Hwbg==
X-Gm-Message-State: APjAAAWujcQCqHjHbfJujmqxRw4th3UALhFxDAJkzA4pMWBsGhLm73/U
        AAF1EF+BUl1iy8fNO/8p8TgTUEYo
X-Google-Smtp-Source: APXvYqwj0FdlPgCIen0t7l2dng9ikT1QV8F+5fQ3PBvGcd0c0hlmu33JEcieENH341uZcbM/l2xLCg==
X-Received: by 2002:aa7:9f8d:: with SMTP id z13mr12236817pfr.119.1571433559867;
        Fri, 18 Oct 2019 14:19:19 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:19 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 14/16] lpfc: Add FC-AL support to lpe32000 models
Date:   Fri, 18 Oct 2019 14:18:30 -0700
Message-Id: <20191018211832.7917-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the past, the lpe32000 models, based their main support being for
32G, and as FC-AL is not supported in the FC standards past 8G, did
not support FC-AL operation.

This patch adds private-loop FC-AL support for the LPE32000 adapters
when a link is 8G or below. To avoid conditions where link rate may
change, which would cause non-connectivity to the AL device, FC-AL
mode must become a persistent setting and the link kept at a speed
supporting FC-AL.

the patch:
- adds a pls attribute indicating whether the adapter properly
  supports FC-AL.
- adds support for the adapter to indicate that topology should
  be fixed and the topology types to be configured.
- adds a pt attribute to report the persistent topology if present.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_attr.c | 38 +++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hw4.h  | 12 ++++++
 drivers/scsi/lpfc/lpfc_init.c | 90 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_mbox.c |  1 +
 drivers/scsi/lpfc/lpfc_sli4.h |  1 +
 6 files changed, 142 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 884d6076d7aa..4559f1700c6d 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -731,6 +731,7 @@ struct lpfc_hba {
 #define HBA_FCOE_MODE		0x4 /* HBA function in FCoE Mode */
 #define HBA_SP_QUEUE_EVT	0x8 /* Slow-path qevt posted to worker thread*/
 #define HBA_POST_RECEIVE_BUFFER 0x10 /* Rcv buffers need to be posted */
+#define HBA_PERSISTENT_TOPO	0x20 /* Persistent topology support in hba */
 #define ELS_XRI_ABORT_EVENT	0x40
 #define ASYNC_EVENT		0x80
 #define LINK_DISABLED		0x100 /* Link disabled by user */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index ba504cc6e8ed..e738c1529d2d 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3535,6 +3535,31 @@ LPFC_ATTR_R(enable_rrq, 2, 0, 2,
 LPFC_ATTR_R(suppress_link_up, LPFC_INITIALIZE_LINK, LPFC_INITIALIZE_LINK,
 		LPFC_DELAY_INIT_LINK_INDEFINITELY,
 		"Suppress Link Up at initialization");
+
+static ssize_t
+lpfc_pls_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_hba   *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
+			 phba->sli4_hba.pc_sli4_params.pls);
+}
+static DEVICE_ATTR(pls, 0444,
+			 lpfc_pls_show, NULL);
+
+static ssize_t
+lpfc_pt_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_hba   *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
+			 (phba->hba_flag & HBA_PERSISTENT_TOPO) ? 1 : 0);
+}
+static DEVICE_ATTR(pt, 0444,
+			 lpfc_pt_show, NULL);
+
 /*
 # lpfc_cnt: Number of IOCBs allocated for ELS, CT, and ABTS
 #       1 - (1024)
@@ -4095,7 +4120,16 @@ lpfc_topology_store(struct device *dev, struct device_attribute *attr,
 				val);
 			return -EINVAL;
 		}
-		if ((phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC ||
+		/*
+		 * The 'topology' is not a configurable parameter if :
+		 *   - persistent topology enabled
+		 *   - G7 adapters
+		 *   - G6 with no private loop support
+		 */
+
+		if (((phba->hba_flag & HBA_PERSISTENT_TOPO) ||
+		     (!phba->sli4_hba.pc_sli4_params.pls &&
+		     phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC) ||
 		     phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC) &&
 		    val == 4) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
@@ -6117,6 +6151,8 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_req_fw_upgrade,
 	&dev_attr_lpfc_suppress_link_up,
 	&dev_attr_iocb_hw,
+	&dev_attr_pls,
+	&dev_attr_pt,
 	&dev_attr_txq_hw,
 	&dev_attr_txcmplq_hw,
 	&dev_attr_lpfc_fips_level,
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 818a0f4325af..d40bfe5aa21f 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2809,6 +2809,15 @@ struct lpfc_mbx_read_config {
 #define lpfc_mbx_rd_conf_trunk_SHIFT		12
 #define lpfc_mbx_rd_conf_trunk_MASK		0x0000000F
 #define lpfc_mbx_rd_conf_trunk_WORD		word2
+#define lpfc_mbx_rd_conf_pt_SHIFT		20
+#define lpfc_mbx_rd_conf_pt_MASK		0x00000003
+#define lpfc_mbx_rd_conf_pt_WORD		word2
+#define lpfc_mbx_rd_conf_tf_SHIFT		22
+#define lpfc_mbx_rd_conf_tf_MASK		0x00000001
+#define lpfc_mbx_rd_conf_tf_WORD		word2
+#define lpfc_mbx_rd_conf_ptv_SHIFT		23
+#define lpfc_mbx_rd_conf_ptv_MASK		0x00000001
+#define lpfc_mbx_rd_conf_ptv_WORD		word2
 #define lpfc_mbx_rd_conf_topology_SHIFT		24
 #define lpfc_mbx_rd_conf_topology_MASK		0x000000FF
 #define lpfc_mbx_rd_conf_topology_WORD		word2
@@ -3479,6 +3488,9 @@ struct lpfc_sli4_parameters {
 #define cfg_bv1s_SHIFT                          10
 #define cfg_bv1s_MASK                           0x00000001
 #define cfg_bv1s_WORD                           word19
+#define cfg_pvl_SHIFT				13
+#define cfg_pvl_MASK				0x00000001
+#define cfg_pvl_WORD				word19
 
 #define cfg_nsler_SHIFT                         12
 #define cfg_nsler_MASK                          0x00000001
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d821adbb0047..686677dd52a4 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8239,6 +8239,94 @@ lpfc_destroy_bootstrap_mbox(struct lpfc_hba *phba)
 	memset(&phba->sli4_hba.bmbx, 0, sizeof(struct lpfc_bmbx));
 }
 
+static const char * const lpfc_topo_to_str[] = {
+	"Loop then P2P",
+	"Loopback",
+	"P2P Only",
+	"Unsupported",
+	"Loop Only",
+	"Unsupported",
+	"P2P then Loop",
+};
+
+/**
+ * lpfc_map_topology - Map the topology read from READ_CONFIG
+ * @phba: pointer to lpfc hba data structure.
+ * @rdconf: pointer to read config data
+ *
+ * This routine is invoked to map the topology values as read
+ * from the read config mailbox command. If the persistent
+ * topology feature is supported, the firmware will provide the
+ * saved topology information to be used in INIT_LINK
+ *
+ **/
+#define	LINK_FLAGS_DEF	0x0
+#define	LINK_FLAGS_P2P	0x1
+#define	LINK_FLAGS_LOOP	0x2
+static void
+lpfc_map_topology(struct lpfc_hba *phba, struct lpfc_mbx_read_config *rd_config)
+{
+	u8 ptv, tf, pt;
+
+	ptv = bf_get(lpfc_mbx_rd_conf_ptv, rd_config);
+	tf = bf_get(lpfc_mbx_rd_conf_tf, rd_config);
+	pt = bf_get(lpfc_mbx_rd_conf_pt, rd_config);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"2027 Read Config Data : ptv:0x%x, tf:0x%x pt:0x%x",
+			 ptv, tf, pt);
+	if (!ptv) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"2019 FW does not support persistent topology "
+				"Using driver parameter defined value [%s]",
+				lpfc_topo_to_str[phba->cfg_topology]);
+		return;
+	}
+	/* FW supports persistent topology - override module parameter value */
+	phba->hba_flag |= HBA_PERSISTENT_TOPO;
+	switch (phba->pcidev->device) {
+	case PCI_DEVICE_ID_LANCER_G7_FC:
+		if (tf || (pt == LINK_FLAGS_LOOP)) {
+			/* Invalid values from FW - use driver params */
+			phba->hba_flag &= ~HBA_PERSISTENT_TOPO;
+		} else {
+			/* Prism only supports PT2PT topology */
+			phba->cfg_topology = FLAGS_TOPOLOGY_MODE_PT_PT;
+		}
+		break;
+	case PCI_DEVICE_ID_LANCER_G6_FC:
+		if (!tf) {
+			phba->cfg_topology = ((pt == LINK_FLAGS_LOOP)
+					? FLAGS_TOPOLOGY_MODE_LOOP
+					: FLAGS_TOPOLOGY_MODE_PT_PT);
+		} else {
+			phba->hba_flag &= ~HBA_PERSISTENT_TOPO;
+		}
+		break;
+	default:	/* G5 */
+		if (tf) {
+			/* If topology failover set - pt is '0' or '1' */
+			phba->cfg_topology = (pt ? FLAGS_TOPOLOGY_MODE_PT_LOOP :
+					      FLAGS_TOPOLOGY_MODE_LOOP_PT);
+		} else {
+			phba->cfg_topology = ((pt == LINK_FLAGS_P2P)
+					? FLAGS_TOPOLOGY_MODE_PT_PT
+					: FLAGS_TOPOLOGY_MODE_LOOP);
+		}
+		break;
+	}
+	if (phba->hba_flag & HBA_PERSISTENT_TOPO) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"2020 Using persistent topology value [%s]",
+				lpfc_topo_to_str[phba->cfg_topology]);
+	} else {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"2021 Invalid topology values from FW "
+				"Using driver parameter defined value [%s]",
+				lpfc_topo_to_str[phba->cfg_topology]);
+	}
+}
+
 /**
  * lpfc_sli4_read_config - Get the config parameters.
  * @phba: pointer to lpfc hba data structure.
@@ -8350,6 +8438,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 		phba->max_vpi = (phba->sli4_hba.max_cfg_param.max_vpi > 0) ?
 				(phba->sli4_hba.max_cfg_param.max_vpi - 1) : 0;
 		phba->max_vports = phba->max_vpi;
+		lpfc_map_topology(phba, rd_config);
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 				"2003 cfg params Extents? %d "
 				"XRI(B:%d M:%d), "
@@ -11542,6 +11631,7 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	sli4_params->cqav = bf_get(cfg_cqav, mbx_sli4_parameters);
 	sli4_params->wqsize = bf_get(cfg_wqsize, mbx_sli4_parameters);
 	sli4_params->bv1s = bf_get(cfg_bv1s, mbx_sli4_parameters);
+	sli4_params->pls = bf_get(cfg_pvl, mbx_sli4_parameters);
 	sli4_params->sgl_pages_max = bf_get(cfg_sgl_page_cnt,
 					    mbx_sli4_parameters);
 	sli4_params->wqpcnt = bf_get(cfg_wqpcnt, mbx_sli4_parameters);
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 8abe933bad09..d1773c01d2b3 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -515,6 +515,7 @@ lpfc_init_link(struct lpfc_hba * phba,
 
 	if ((phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC ||
 	     phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC) &&
+	    !(phba->sli4_hba.pc_sli4_params.pls) &&
 	    mb->un.varInitLnk.link_flags & FLAGS_TOPOLOGY_MODE_LOOP) {
 		mb->un.varInitLnk.link_flags = FLAGS_TOPOLOGY_MODE_PT_PT;
 		phba->cfg_topology = FLAGS_TOPOLOGY_MODE_PT_PT;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index c9e068ca0fec..bbe24c19b1d9 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -514,6 +514,7 @@ struct lpfc_pc_sli4_params {
 	uint8_t cqav;
 	uint8_t wqsize;
 	uint8_t bv1s;
+	uint8_t pls;
 #define LPFC_WQ_SZ64_SUPPORT	1
 #define LPFC_WQ_SZ128_SUPPORT	2
 	uint8_t wqpcnt;
-- 
2.13.7

