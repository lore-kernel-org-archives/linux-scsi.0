Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E31EC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 16:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiJQQfw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 12:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiJQQft (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 12:35:49 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0027A6E2D1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:35:47 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id i9so7766006qvo.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/JEMZmB8xu7y8UA8xYb5uojCLoWGBJGrgr2TehQ90M=;
        b=pag4SqbM3h2O4wlveVcpNs1SqSfkkqash9BvmaC2PX/z0BRiGqHcywbFB9JJWTdr/1
         vkSTTQDTEGSL6DPF/1+IofpLb5EXw0DMFw032Bmn4SJ5VwwxqaUowcWCgho4tnjo2GtF
         SJh8T+wvR0OsI5PVEFu8RWhRsCmdovuO0QkoucRr+ntq0mAH+1OGVfqRPOga8wCIZQhw
         GvhU7I+2TvRaEaJkZGOweOf95vJd17J49wFBCPj+CAJzK55RvuF2G4urtUII2VDQookK
         l1rbicBvRHzat73yuxgq7fhunEKIJfhKnwUVCLcBONahleGmEnmos9pELE089h6/ZEjO
         HYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v/JEMZmB8xu7y8UA8xYb5uojCLoWGBJGrgr2TehQ90M=;
        b=b4oo3d1AzAt5ZkLr0c+n7U9/Wg3D5pXimSpinb/JKXi2Qa1Vfx0JndqUOJwdS1Jv0I
         IJjaO4Tug+NIMYQi2mmrNEmsYACyrSXj1cxXqwYhlqE1fvs9bdSZCr4XA69BzkLi8/9J
         OXPlTaCeVTmnTpvyXigN3iH3h7OPdQ8Q8FZ0INKP4G00TfRbGzFCDB6cYjyYIuCSgkCE
         OGonsjrN9yF7L/lX1rDPH44gDxu2i0rQRbGndfmHptoGP6LvnNDs+dUD3d2lN66qMu1M
         SMVyjxp/9O50E1sg6cl+0/bEl6k7IDxAUggo96UvZ2g+IizZA0Xm3St/J/tI4BFZdVk7
         cGSw==
X-Gm-Message-State: ACrzQf3kwxfJFpZWRYRpjUrPLrfDhQ/yi52AvKdntT2ZDZkyilMDdfsS
        BEi+A354FNZutp0Hq6l7iGxtJpLXqo0=
X-Google-Smtp-Source: AMsMyM7APb3rpeABFLsxuMpwuHes44u7oCN2896TRiKEaOxLXc73/aPM7vCSwMRsBv4s0yR0eVO+6w==
X-Received: by 2002:a05:6214:1c85:b0:4af:7393:3d91 with SMTP id ib5-20020a0562141c8500b004af73933d91mr9115127qvb.74.1666024546873;
        Mon, 17 Oct 2022 09:35:46 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r2-20020ae9d602000000b006ceb933a9fesm152235qkk.81.2022.10.17.09.35.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Oct 2022 09:35:46 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 4/5] lpfc: Create a sysfs entry called lpfc_xcvr_data for transceiver info
Date:   Mon, 17 Oct 2022 09:43:22 -0700
Message-Id: <20221017164323.14536-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda057
In-Reply-To: <20221017164323.14536-1-justintee8345@gmail.com>
References: <20221017164323.14536-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The DUMP_MEMORY mailbox command is implemented for page A0 and A2 to
retrieve transceiver information from firmware.

The mailbox command output is then formatted to print raw data values for
userspace to parse via sysfs.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 118 +++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_crtn.h |   3 +
 drivers/scsi/lpfc/lpfc_els.c  | 128 ++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hw4.h  |   5 +-
 4 files changed, 252 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index ef1481326fd7..030ad1d59cbd 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1877,6 +1877,122 @@ lpfc_set_trunking(struct lpfc_hba *phba, char *buff_out)
 	return 0;
 }
 
+static ssize_t
+lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	int rc;
+	int len = 0;
+	struct lpfc_rdp_context	*rdp_context;
+	u16 temperature;
+	u16 rx_power;
+	u16 tx_bias;
+	u16 tx_power;
+	u16 vcc;
+	char chbuf[128];
+	u16 wavelength = 0;
+	struct sff_trasnceiver_codes_byte7 *trasn_code_byte7;
+
+	/* Get transceiver information */
+	rdp_context = kmalloc(sizeof(*rdp_context), GFP_KERNEL);
+
+	rc = lpfc_get_sfp_info_wait(phba, rdp_context);
+	if (rc) {
+		len = scnprintf(buf, PAGE_SIZE - len, "SFP info NA:\n");
+		goto out_free_rdp;
+	}
+
+	strncpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_NAME], 16);
+	chbuf[16] = 0;
+
+	len = scnprintf(buf, PAGE_SIZE - len, "VendorName:\t%s\n", chbuf);
+	len += scnprintf(buf + len, PAGE_SIZE - len,
+			 "VendorOUI:\t%02x-%02x-%02x\n",
+			 (uint8_t)rdp_context->page_a0[SSF_VENDOR_OUI],
+			 (uint8_t)rdp_context->page_a0[SSF_VENDOR_OUI + 1],
+			 (uint8_t)rdp_context->page_a0[SSF_VENDOR_OUI + 2]);
+	strncpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_PN], 16);
+	chbuf[16] = 0;
+	len += scnprintf(buf + len, PAGE_SIZE - len, "VendorPN:\t%s\n", chbuf);
+	strncpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_SN], 16);
+	chbuf[16] = 0;
+	len += scnprintf(buf + len, PAGE_SIZE - len, "VendorSN:\t%s\n", chbuf);
+	strncpy(chbuf, &rdp_context->page_a0[SSF_VENDOR_REV], 4);
+	chbuf[4] = 0;
+	len += scnprintf(buf + len, PAGE_SIZE - len, "VendorRev:\t%s\n", chbuf);
+	strncpy(chbuf, &rdp_context->page_a0[SSF_DATE_CODE], 8);
+	chbuf[8] = 0;
+	len += scnprintf(buf + len, PAGE_SIZE - len, "DateCode:\t%s\n", chbuf);
+	len += scnprintf(buf + len, PAGE_SIZE - len, "Identifier:\t%xh\n",
+			 (uint8_t)rdp_context->page_a0[SSF_IDENTIFIER]);
+	len += scnprintf(buf + len, PAGE_SIZE - len, "ExtIdentifier:\t%xh\n",
+			 (uint8_t)rdp_context->page_a0[SSF_EXT_IDENTIFIER]);
+	len += scnprintf(buf + len, PAGE_SIZE - len, "Connector:\t%xh\n",
+			 (uint8_t)rdp_context->page_a0[SSF_CONNECTOR]);
+	wavelength = (rdp_context->page_a0[SSF_WAVELENGTH_B1] << 8) |
+		      rdp_context->page_a0[SSF_WAVELENGTH_B0];
+
+	len += scnprintf(buf + len, PAGE_SIZE - len, "Wavelength:\t%d nm\n",
+			 wavelength);
+	trasn_code_byte7 = (struct sff_trasnceiver_codes_byte7 *)
+			&rdp_context->page_a0[SSF_TRANSCEIVER_CODE_B7];
+
+	len += scnprintf(buf + len, PAGE_SIZE - len, "Speeds: \t");
+		if (*(uint8_t *)trasn_code_byte7 == 0) {
+			len += scnprintf(buf + len, PAGE_SIZE - len,
+					 "Unknown\n");
+		} else {
+			if (trasn_code_byte7->fc_sp_100MB)
+				len += scnprintf(buf + len, PAGE_SIZE - len,
+						 "1 ");
+			if (trasn_code_byte7->fc_sp_200mb)
+				len += scnprintf(buf + len, PAGE_SIZE - len,
+						 "2 ");
+			if (trasn_code_byte7->fc_sp_400MB)
+				len += scnprintf(buf + len, PAGE_SIZE - len,
+						 "4 ");
+			if (trasn_code_byte7->fc_sp_800MB)
+				len += scnprintf(buf + len, PAGE_SIZE - len,
+						 "8 ");
+			if (trasn_code_byte7->fc_sp_1600MB)
+				len += scnprintf(buf + len, PAGE_SIZE - len,
+						 "16 ");
+			if (trasn_code_byte7->fc_sp_3200MB)
+				len += scnprintf(buf + len, PAGE_SIZE - len,
+						 "32 ");
+			if (trasn_code_byte7->speed_chk_ecc)
+				len += scnprintf(buf + len, PAGE_SIZE - len,
+						 "64 ");
+			len += scnprintf(buf + len, PAGE_SIZE - len, "GB\n");
+		}
+	temperature = (rdp_context->page_a2[SFF_TEMPERATURE_B1] << 8 |
+		       rdp_context->page_a2[SFF_TEMPERATURE_B0]);
+	vcc = (rdp_context->page_a2[SFF_VCC_B1] << 8 |
+	       rdp_context->page_a2[SFF_VCC_B0]);
+	tx_power = (rdp_context->page_a2[SFF_TXPOWER_B1] << 8 |
+		    rdp_context->page_a2[SFF_TXPOWER_B0]);
+	tx_bias = (rdp_context->page_a2[SFF_TX_BIAS_CURRENT_B1] << 8 |
+		   rdp_context->page_a2[SFF_TX_BIAS_CURRENT_B0]);
+	rx_power = (rdp_context->page_a2[SFF_RXPOWER_B1] << 8 |
+		    rdp_context->page_a2[SFF_RXPOWER_B0]);
+
+	len += scnprintf(buf + len, PAGE_SIZE - len,
+			 "Temperature:\tx%04x C\n", temperature);
+	len += scnprintf(buf + len, PAGE_SIZE - len, "Vcc:\t\tx%04x V\n", vcc);
+	len += scnprintf(buf + len, PAGE_SIZE - len,
+			 "TxBiasCurrent:\tx%04x mA\n", tx_bias);
+	len += scnprintf(buf + len, PAGE_SIZE - len, "TxPower:\tx%04x mW\n",
+			 tx_power);
+	len += scnprintf(buf + len, PAGE_SIZE - len, "RxPower:\tx%04x mW\n",
+			 rx_power);
+out_free_rdp:
+	kfree(rdp_context);
+	return len;
+}
+
 /**
  * lpfc_board_mode_show - Return the state of the board
  * @dev: class device that is converted into a Scsi_host.
@@ -2810,6 +2926,7 @@ static DEVICE_ATTR_RO(lpfc_drvr_version);
 static DEVICE_ATTR_RO(lpfc_enable_fip);
 static DEVICE_ATTR(board_mode, S_IRUGO | S_IWUSR,
 		   lpfc_board_mode_show, lpfc_board_mode_store);
+static DEVICE_ATTR_RO(lpfc_xcvr_data);
 static DEVICE_ATTR(issue_reset, S_IWUSR, NULL, lpfc_issue_reset);
 static DEVICE_ATTR(max_vpi, S_IRUGO, lpfc_max_vpi_show, NULL);
 static DEVICE_ATTR(used_vpi, S_IRUGO, lpfc_used_vpi_show, NULL);
@@ -5906,6 +6023,7 @@ static struct attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_fcp_wait_abts_rsp.attr,
 	&dev_attr_nport_evt_cnt.attr,
 	&dev_attr_board_mode.attr,
+	&dev_attr_lpfc_xcvr_data.attr,
 	&dev_attr_max_vpi.attr,
 	&dev_attr_used_vpi.attr,
 	&dev_attr_max_rpi.attr,
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index d2d207791056..8928f016d09e 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -687,3 +687,6 @@ int lpfc_issue_els_qfpa(struct lpfc_vport *vport);
 
 void lpfc_sli_rpi_release(struct lpfc_vport *vport,
 			  struct lpfc_nodelist *ndlp);
+
+int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
+			   struct lpfc_rdp_context *rdp_context);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 863b2125fed6..2b03210264bb 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7190,6 +7190,134 @@ lpfc_get_rdp_info(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context)
 	return 1;
 }
 
+int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
+			   struct lpfc_rdp_context *rdp_context)
+{
+	LPFC_MBOXQ_t *mbox = NULL;
+	int rc;
+	struct lpfc_dmabuf *mp;
+	struct lpfc_dmabuf *mpsave;
+	void *virt;
+	MAILBOX_t *mb;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_ELS,
+				"7205 failed to allocate mailbox memory");
+		return 1;
+	}
+
+	if (lpfc_sli4_dump_page_a0(phba, mbox))
+		goto sfp_fail;
+	mp = mbox->ctx_buf;
+	mpsave = mp;
+	virt = mp->virt;
+	if (phba->sli_rev < LPFC_SLI_REV4) {
+		mb = &mbox->u.mb;
+		mb->un.varDmp.cv = 1;
+		mb->un.varDmp.co = 1;
+		mb->un.varWords[2] = 0;
+		mb->un.varWords[3] = DMP_SFF_PAGE_A0_SIZE / 4;
+		mb->un.varWords[4] = 0;
+		mb->un.varWords[5] = 0;
+		mb->un.varWords[6] = 0;
+		mb->un.varWords[7] = 0;
+		mb->un.varWords[8] = 0;
+		mb->un.varWords[9] = 0;
+		mb->un.varWords[10] = 0;
+		mbox->in_ext_byte_len = DMP_SFF_PAGE_A0_SIZE;
+		mbox->out_ext_byte_len = DMP_SFF_PAGE_A0_SIZE;
+		mbox->mbox_offset_word = 5;
+		mbox->ctx_buf = virt;
+	} else {
+		bf_set(lpfc_mbx_memory_dump_type3_length,
+		       &mbox->u.mqe.un.mem_dump_type3, DMP_SFF_PAGE_A0_SIZE);
+		mbox->u.mqe.un.mem_dump_type3.addr_lo = putPaddrLow(mp->phys);
+		mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
+	}
+	mbox->vport = phba->pport;
+	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
+
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	if (rc == MBX_NOT_FINISHED) {
+		rc = 1;
+		goto error;
+	}
+
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		mp = (struct lpfc_dmabuf *)(mbox->ctx_buf);
+	else
+		mp = mpsave;
+
+	if (bf_get(lpfc_mqe_status, &mbox->u.mqe)) {
+		rc = 1;
+		goto error;
+	}
+
+	lpfc_sli_bemem_bcopy(mp->virt, &rdp_context->page_a0,
+			     DMP_SFF_PAGE_A0_SIZE);
+
+	memset(mbox, 0, sizeof(*mbox));
+	memset(mp->virt, 0, DMP_SFF_PAGE_A2_SIZE);
+	INIT_LIST_HEAD(&mp->list);
+
+	/* save address for completion */
+	mbox->ctx_buf = mp;
+	mbox->vport = phba->pport;
+
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_DUMP_MEMORY);
+	bf_set(lpfc_mbx_memory_dump_type3_type,
+	       &mbox->u.mqe.un.mem_dump_type3, DMP_LMSD);
+	bf_set(lpfc_mbx_memory_dump_type3_link,
+	       &mbox->u.mqe.un.mem_dump_type3, phba->sli4_hba.physical_port);
+	bf_set(lpfc_mbx_memory_dump_type3_page_no,
+	       &mbox->u.mqe.un.mem_dump_type3, DMP_PAGE_A2);
+	if (phba->sli_rev < LPFC_SLI_REV4) {
+		mb = &mbox->u.mb;
+		mb->un.varDmp.cv = 1;
+		mb->un.varDmp.co = 1;
+		mb->un.varWords[2] = 0;
+		mb->un.varWords[3] = DMP_SFF_PAGE_A2_SIZE / 4;
+		mb->un.varWords[4] = 0;
+		mb->un.varWords[5] = 0;
+		mb->un.varWords[6] = 0;
+		mb->un.varWords[7] = 0;
+		mb->un.varWords[8] = 0;
+		mb->un.varWords[9] = 0;
+		mb->un.varWords[10] = 0;
+		mbox->in_ext_byte_len = DMP_SFF_PAGE_A2_SIZE;
+		mbox->out_ext_byte_len = DMP_SFF_PAGE_A2_SIZE;
+		mbox->mbox_offset_word = 5;
+		mbox->ctx_buf = virt;
+	} else {
+		bf_set(lpfc_mbx_memory_dump_type3_length,
+		       &mbox->u.mqe.un.mem_dump_type3, DMP_SFF_PAGE_A2_SIZE);
+		mbox->u.mqe.un.mem_dump_type3.addr_lo = putPaddrLow(mp->phys);
+		mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
+	}
+
+	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	if (bf_get(lpfc_mqe_status, &mbox->u.mqe)) {
+		rc = 1;
+		goto error;
+	}
+	rc = 0;
+
+	lpfc_sli_bemem_bcopy(mp->virt, &rdp_context->page_a2,
+			     DMP_SFF_PAGE_A2_SIZE);
+
+error:
+	mbox->ctx_buf = mpsave;
+	lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+
+	return rc;
+
+sfp_fail:
+	mempool_free(mbox, phba->mbox_mem_pool);
+	return 1;
+}
+
 /*
  * lpfc_els_rcv_rdp - Process an unsolicited RDP ELS.
  * @vport: pointer to a host virtual N_Port data structure.
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 5288fc69908a..fb3504dbb899 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3162,7 +3162,8 @@ struct lpfc_mbx_memory_dump_type3 {
 #define SFF_LENGTH_COPPER		18
 #define SSF_LENGTH_50UM_OM3		19
 #define SSF_VENDOR_NAME			20
-#define SSF_VENDOR_OUI			36
+#define SSF_TRANSCEIVER2		36
+#define SSF_VENDOR_OUI			37
 #define SSF_VENDOR_PN			40
 #define SSF_VENDOR_REV			56
 #define SSF_WAVELENGTH_B1		60
@@ -3281,7 +3282,7 @@ struct sff_trasnceiver_codes_byte6 {
 
 struct sff_trasnceiver_codes_byte7 {
 	uint8_t fc_sp_100MB:1;   /*  100 MB/sec */
-	uint8_t reserve:1;
+	uint8_t speed_chk_ecc:1;
 	uint8_t fc_sp_200mb:1;   /*  200 MB/sec */
 	uint8_t fc_sp_3200MB:1;  /* 3200 MB/sec */
 	uint8_t fc_sp_400MB:1;   /*  400 MB/sec */
-- 
2.38.0.83.gd420dda057

