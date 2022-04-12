Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C71C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiDLXhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiDLXcy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:54 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2A2C6255
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:32 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w7so264293pfu.11
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/0P028o0AFqLnPCSpIuCtRq68Kk5fPAE13aH1sTHe+4=;
        b=jPtd1CyGoIxgzjPXN2NMuyYpm/ElnQVarV82nJbPZCjVwcRVdHt1zTC8bvvTlJYwzf
         LymejCs+xuwgAEi78TmSWSXg72bLMsUm9Uf+UmeaK2KiHDoa0KGoRJceQ9VXT4qofFJL
         psCXR84sN96qv+9KYV5EY6qjUJU3psIXdWfEvwhgJJ7mWe9fRM6d81DNb56HBwp8oc+n
         T131bgIUY7ozscAOL1vL0DITTCwr43y3q9vBU8Hrpe3KIULNQB+dyoyEeOzbibpFFWnn
         A1Uh7TNimNrb+MkIGDeClDSNmGxBVOeLv3Jc3iCbDLsDhRojdDmd6Q/HscVMWEEvZtEZ
         7Pig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/0P028o0AFqLnPCSpIuCtRq68Kk5fPAE13aH1sTHe+4=;
        b=u3CI+weAXY5YyBsUrMSXJcX8iQIVxQ40DWNi+L2RXiTGhM1KCXldKFjb8UtF/I1seT
         xthTgUyG48yoJxyHVCydzqZUUZHTCq2zRI/cluTMJzUyb+JcNfqeRNxi103Wc5rU28Xe
         6pnyqqoitV37A8BdOv+nOmcZ/P1Y9MFX8Q2GN87fOI8SGD/MY+wX6Kq/Ez88VYO4rG0X
         8Pu1LJsGCRTcmPOkRaXfMlswZnAybvwiaf+stg/oR3+MPg3iTRFWMqX39Nq1KumLFX+J
         uuzvALM5iUvLDfSQIeX8a3HR8osMkC9GQOuck9ecTRVM0EJxcQ7Hq287dzSTxR0RIAx5
         q2/w==
X-Gm-Message-State: AOAM533UZDDiG6ui9p8omRnPBknu79Zk+PJpp+cicTT45BmdanqjFDsY
        klM+zec/9y4yt2AovEYexswVk+Be66I=
X-Google-Smtp-Source: ABdhPJzYnaQrLWAMA2+aJO9NfZ8eHzSfmXNG03vOzRVHFSt4LoSXUM8JF2yFkcmH47+XAG56wBk5Pw==
X-Received: by 2002:a63:2b0d:0:b0:386:322:f05c with SMTP id r13-20020a632b0d000000b003860322f05cmr32845593pgr.11.1649802032013;
        Tue, 12 Apr 2022 15:20:32 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:31 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 22/26] lpfc: Change FA-PWWN detection methodology
Date:   Tue, 12 Apr 2022 15:20:04 -0700
Message-Id: <20220412222008.126521-23-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not rely on vendor version field of the CSPs to determine if we are in a
FA-PWWN environment. Instead, use the following procedure:

First, during HBA initialization, driver does a READ_CONFIG to determine
if FA-PWWN is configured on the HBA. A LPFC_FAWWPN_CONFIG hba_flag is set
accordingly.

Next, when the link comes up before the driver gets a link up event,
the firmware logs into the fabric with FA-PWWN. If the fabric port does
not support FA-PWWN, the driver will get a Misconfigured FA-WWN async
event before the link up. A LPFC_FAWWPN_FABRIC hba_flag will be set
accordingly.

Finally, if the fabric supports FA-PWWN, the firmware will replace
its CSPs WWN with the Fabric Assigned ones. Then after link up, the
driver will retrieve the Fabric Assigned WWN when it does a
READ_SPARAM mbox command.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  5 +--
 drivers/scsi/lpfc/lpfc_attr.c    | 18 ++++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c |  8 ++++
 drivers/scsi/lpfc/lpfc_hw.h      |  2 -
 drivers/scsi/lpfc/lpfc_hw4.h     |  3 ++
 drivers/scsi/lpfc/lpfc_init.c    | 72 ++++++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_sli.c     |  1 +
 drivers/scsi/lpfc/lpfc_sli4.h    |  3 ++
 8 files changed, 86 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 96602a88b8ed..6a3dccfafec0 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -738,9 +738,8 @@ struct lpfc_vport {
 	struct list_head rcv_buffer_list;
 	unsigned long rcv_buffer_time_stamp;
 	uint32_t vport_flag;
-#define STATIC_VPORT	1
-#define FAWWPN_SET	2
-#define FAWWPN_PARAM_CHG	4
+#define STATIC_VPORT		0x1
+#define FAWWPN_PARAM_CHG	0x2
 
 	uint16_t fdmi_num_disc;
 	uint32_t fdmi_hba_mask;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index ff99f7cdbefa..0d19e469386b 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1120,12 +1120,22 @@ lpfc_link_state_show(struct device *dev, struct device_attribute *attr,
 				len += scnprintf(buf + len, PAGE_SIZE-len,
 						"   Private Loop\n");
 		} else {
-			if (vport->fc_flag & FC_FABRIC)
-				len += scnprintf(buf + len, PAGE_SIZE-len,
-						"   Fabric\n");
-			else
+			if (vport->fc_flag & FC_FABRIC) {
+				if (phba->sli_rev == LPFC_SLI_REV4 &&
+				    vport->port_type == LPFC_PHYSICAL_PORT &&
+				    phba->sli4_hba.fawwpn_flag &
+					LPFC_FAWWPN_FABRIC)
+					len += scnprintf(buf + len,
+							 PAGE_SIZE - len,
+							 "   Fabric FA-PWWN\n");
+				else
+					len += scnprintf(buf + len,
+							 PAGE_SIZE - len,
+							 "   Fabric\n");
+			} else {
 				len += scnprintf(buf + len, PAGE_SIZE-len,
 						"   Point-2-Point\n");
+			}
 		}
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f2baf3bd8dd8..2d846256990c 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1183,6 +1183,7 @@ lpfc_port_link_failure(struct lpfc_vport *vport)
 void
 lpfc_linkdown_port(struct lpfc_vport *vport)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 
 	if (vport->cfg_enable_fc4_type != LPFC_ENABLE_NVME)
@@ -1200,6 +1201,13 @@ lpfc_linkdown_port(struct lpfc_vport *vport)
 	vport->fc_flag &= ~FC_DISC_DELAYED;
 	spin_unlock_irq(shost->host_lock);
 	del_timer_sync(&vport->delayed_disc_tmo);
+
+	if (phba->sli_rev == LPFC_SLI_REV4 &&
+	    vport->port_type == LPFC_PHYSICAL_PORT &&
+	    phba->sli4_hba.fawwpn_flag & LPFC_FAWWPN_CONFIG) {
+		/* Assume success on link up */
+		phba->sli4_hba.fawwpn_flag |= LPFC_FAWWPN_FABRIC;
+	}
 }
 
 int
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 2f5537f57846..70c3dd7b7105 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -511,8 +511,6 @@ struct class_parms {
 	uint8_t word3Reserved2;	/* Fc Word 3, bit  0: 7 */
 };
 
-#define FAPWWN_KEY_VENDOR	0x42524344 /*valid vendor version fawwpn key*/
-
 struct serv_parm {	/* Structure is in Big Endian format */
 	struct csp cmn;
 	struct lpfc_name portName;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 02e230ed6280..6d20c97762e9 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2893,6 +2893,9 @@ struct lpfc_mbx_read_config {
 #define lpfc_mbx_rd_conf_extnts_inuse_SHIFT	31
 #define lpfc_mbx_rd_conf_extnts_inuse_MASK	0x00000001
 #define lpfc_mbx_rd_conf_extnts_inuse_WORD	word1
+#define lpfc_mbx_rd_conf_fawwpn_SHIFT		30
+#define lpfc_mbx_rd_conf_fawwpn_MASK		0x00000001
+#define lpfc_mbx_rd_conf_fawwpn_WORD		word1
 #define lpfc_mbx_rd_conf_wcs_SHIFT		28	/* warning signaling */
 #define lpfc_mbx_rd_conf_wcs_MASK		0x00000001
 #define lpfc_mbx_rd_conf_wcs_WORD		word1
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ae4ea4eccac9..c20d22949e13 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -350,8 +350,7 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 void
 lpfc_update_vport_wwn(struct lpfc_vport *vport)
 {
-	uint8_t vvvl = vport->fc_sparam.cmn.valid_vendor_ver_level;
-	u32 *fawwpn_key = (u32 *)&vport->fc_sparam.un.vendorVersion[0];
+	struct lpfc_hba *phba = vport->phba;
 
 	/*
 	 * If the name is empty or there exists a soft name
@@ -370,21 +369,32 @@ lpfc_update_vport_wwn(struct lpfc_vport *vport)
 	 */
 	if (vport->fc_portname.u.wwn[0] != 0 &&
 		memcmp(&vport->fc_portname, &vport->fc_sparam.portName,
-			sizeof(struct lpfc_name)))
+		       sizeof(struct lpfc_name))) {
 		vport->vport_flag |= FAWWPN_PARAM_CHG;
 
-	if (vport->fc_portname.u.wwn[0] == 0 ||
-	    (vvvl == 1 && cpu_to_be32(*fawwpn_key) == FAPWWN_KEY_VENDOR) ||
-	    vport->vport_flag & FAWWPN_SET) {
-		memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
-			sizeof(struct lpfc_name));
-		vport->vport_flag &= ~FAWWPN_SET;
-		if (vvvl == 1 && cpu_to_be32(*fawwpn_key) == FAPWWN_KEY_VENDOR)
-			vport->vport_flag |= FAWWPN_SET;
+		if (phba->sli_rev == LPFC_SLI_REV4 &&
+		    vport->port_type == LPFC_PHYSICAL_PORT &&
+		    phba->sli4_hba.fawwpn_flag & LPFC_FAWWPN_FABRIC) {
+			lpfc_printf_log(phba, KERN_INFO,
+					LOG_SLI | LOG_DISCOVERY | LOG_ELS,
+					"2701 FA-PWWN change WWPN from %llx to "
+					"%llx: vflag x%x fawwpn_flag x%x\n",
+					wwn_to_u64(vport->fc_portname.u.wwn),
+					wwn_to_u64
+					   (vport->fc_sparam.portName.u.wwn),
+					vport->vport_flag,
+					phba->sli4_hba.fawwpn_flag);
+			memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
+			       sizeof(struct lpfc_name));
+		}
 	}
+
+	if (vport->fc_portname.u.wwn[0] == 0)
+		memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
+		       sizeof(struct lpfc_name));
 	else
 		memcpy(&vport->fc_sparam.portName, &vport->fc_portname,
-			sizeof(struct lpfc_name));
+		       sizeof(struct lpfc_name));
 }
 
 /**
@@ -6542,12 +6552,15 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 	case LPFC_SLI_EVENT_TYPE_MISCONF_FAWWN:
 		/* Misconfigured WWN. Reports that the SLI Port is configured
 		 * to use FA-WWN, but the attached device doesn’t support it.
-		 * No driver action is required.
 		 * Event Data1 - N.A, Event Data2 - N.A
+		 * This event only happens on the physical port.
 		 */
-		lpfc_log_msg(phba, KERN_WARNING, LOG_SLI,
-			     "2699 Misconfigured FA-WWN - Attached device does "
-			     "not support FA-WWN\n");
+		lpfc_log_msg(phba, KERN_WARNING, LOG_SLI | LOG_DISCOVERY,
+			     "2699 Misconfigured FA-PWWN - Attached device "
+			     "does not support FA-PWWN\n");
+		phba->sli4_hba.fawwpn_flag &= ~LPFC_FAWWPN_FABRIC;
+		memset(phba->pport->fc_portname.u.wwn, 0,
+		       sizeof(struct lpfc_name));
 		break;
 	case LPFC_SLI_EVENT_TYPE_EEPROM_FAILURE:
 		/* EEPROM failure. No driver action is required */
@@ -8004,6 +8017,18 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	rc = lpfc_sli4_read_config(phba);
 	if (unlikely(rc))
 		goto out_free_bsmbx;
+
+	if (phba->sli4_hba.fawwpn_flag & LPFC_FAWWPN_CONFIG) {
+		/* Right now the link is down, if FA-PWWN is configured the
+		 * firmware will try FLOGI before the driver gets a link up.
+		 * If it fails, the driver should get a MISCONFIGURED async
+		 * event which will clear this flag. The only notification
+		 * the driver gets is if it fails, if it succeeds there is no
+		 * notification given. Assume success.
+		 */
+		phba->sli4_hba.fawwpn_flag |= LPFC_FAWWPN_FABRIC;
+	}
+
 	rc = lpfc_mem_alloc_active_rrq_pool_s4(phba);
 	if (unlikely(rc))
 		goto out_free_bsmbx;
@@ -9807,7 +9832,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 	struct lpfc_rsrc_desc_fcfcoe *desc;
 	char *pdesc_0;
 	uint16_t forced_link_speed;
-	uint32_t if_type, qmin;
+	uint32_t if_type, qmin, fawwpn;
 	int length, i, rc = 0, rc2;
 
 	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -9849,10 +9874,23 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 			phba->sli4_hba.bbscn_params.word0 = rd_config->word8;
 		}
 
+		fawwpn = bf_get(lpfc_mbx_rd_conf_fawwpn, rd_config);
+
+		if (fawwpn) {
+			lpfc_printf_log(phba, KERN_INFO,
+					LOG_INIT | LOG_DISCOVERY,
+					"2702 READ_CONFIG: FA-PWWN is "
+					"configured on\n");
+			phba->sli4_hba.fawwpn_flag |= LPFC_FAWWPN_CONFIG;
+		} else {
+			phba->sli4_hba.fawwpn_flag = 0;
+		}
+
 		phba->sli4_hba.conf_trunk =
 			bf_get(lpfc_mbx_rd_conf_trunk, rd_config);
 		phba->sli4_hba.extents_in_use =
 			bf_get(lpfc_mbx_rd_conf_extnts_inuse, rd_config);
+
 		phba->sli4_hba.max_cfg_param.max_xri =
 			bf_get(lpfc_mbx_rd_conf_xri_count, rd_config);
 		/* Reduce resource usage in kdump environment */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c4b00e188f0f..22fe7de63fb6 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5265,6 +5265,7 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 	phba->pport->stopped = 0;
 	phba->link_state = LPFC_INIT_START;
 	phba->hba_flag = 0;
+	phba->sli4_hba.fawwpn_flag = 0;
 	spin_unlock_irq(&phba->hbalock);
 
 	memset(&psli->lnk_stat_offsets, 0, sizeof(psli->lnk_stat_offsets));
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index e0c25699f4b8..1ddad5b170a6 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -981,6 +981,9 @@ struct lpfc_sli4_hba {
 #define lpfc_conf_trunk_port3_nd_MASK	0x1
 	uint8_t flash_id;
 	uint8_t asic_rev;
+	uint16_t fawwpn_flag;	/* FA-WWPN support state */
+#define LPFC_FAWWPN_CONFIG	0x1 /* FA-PWWN is configured */
+#define LPFC_FAWWPN_FABRIC	0x2 /* FA-PWWN success with Fabric */
 };
 
 enum lpfc_sge_type {
-- 
2.26.2

