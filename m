Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43311C6FA86
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiIKWPn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiIKWP1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:27 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D271175AE
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:22 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id h28so4923461qka.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/AldBaIVmZrPq9UZGjjsOMh1JFtEnUb495F4Y9aBiDs=;
        b=RjlNciK5EoOkQjGnN/3a7EXyv0JPWXWVdy11kCR4vF+L8JMQ9qab1PzFrq5AKHCf6Y
         rQo/mPnUdpQvqMI01aXAKyx3zrXBdTenLV7BIM8UtDhVCXgkluSsRSnG0jE7SXmHZioc
         Aii3EVCSAFvvSWQQFf4Zcc8WUU/ZtR7uAA1z0LVz5EzORdMiwUdjdaAeHarLAoXHklIC
         86NFyIN8EgBIoNfXkpFNwHmnP3Ga7gSBBPq/b5tLSzHNrbvY7p1ZfkcSfJYYklbKq7dV
         cDIQaCHBQiHmuaIiJAo+BQg5GW7ZJERuHe09wDWwpVVAj1lvdKFQDwev+6Pe344o19lr
         czpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/AldBaIVmZrPq9UZGjjsOMh1JFtEnUb495F4Y9aBiDs=;
        b=ix76Beq0s3u4rh5hdcXWjxk/Glklb1QDLD29qlD9i5d1Rq7IJ9KNku8m5RoMjbMUaM
         QuXQrrUVjc5kdmz1OT8V5i3n+0iAG1Sio2sMnlQedb3Bgk+nYGu/BmgSVB8Vks1/0bnY
         BPsUlohFBsG6JxCxhRciRRbWBWv/QIK0MyCNkHaKAlli/GEcQTTZo81HMcCDwN/3sl8S
         ZdDM6unfu4AGyChGn6mGNWKgkaAVnj5P43KJezgOt5q0QpW+3Oho2chn285TEm7DKiOz
         UU/TKlasrj0TnLBLkdVvyBIvyW+1MQJ5O7/EnBYUzih053tQmhi/3fDkS/jaD/x7JRHP
         Opxw==
X-Gm-Message-State: ACgBeo3dwt9S8fobNf6c5enF0uUAAsNgV17xb/4yyvko2/5O/B522f81
        iES8d4q40YZnTPckXj1OFD09NPQ53cY=
X-Google-Smtp-Source: AA6agR53klQAxZGNop0GlBtwwxCcZvsPmlsJC6q+zOyAPNISu1jo6PZ0g9Owhr5ifqarOa1ZsWD9yw==
X-Received: by 2002:a05:620a:2f5:b0:6cd:fe69:959d with SMTP id a21-20020a05620a02f500b006cdfe69959dmr5143170qko.432.1662934521528;
        Sun, 11 Sep 2022 15:15:21 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:21 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 12/13] lpfc: Fix various issues reported by tools
Date:   Sun, 11 Sep 2022 15:15:04 -0700
Message-Id: <20220911221505.117655-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes below Smatch reported issues:
1. lpfc_hbadisc.c:3020 lpfc_mbx_cmpl_fcf_rr_read_fcf_rec()
   error: uninitialized symbol 'vlan_id'.
2. lpfc_hbadisc.c:3121 lpfc_mbx_cmpl_read_fcf_rec()
   error: uninitialized symbol 'vlan_id'.
3. lpfc_init.c:335 lpfc_dump_wakeup_param_cmpl()
   warn: always true condition '(prg->dist < 4) => (0-3 < 4)'
4. lpfc_init.c:2419 lpfc_parse_vpd()
   warn: inconsistent indenting.
5. lpfc_init.c:13248 lpfc_sli4_enable_msi()
   warn: 'phba->pcidev->irq' 2147483648 can't fit into 65535
   'eqhdl->irq'
6. lpfc_debugfs.c:5300 lpfc_idiag_extacc_avail_get()
   error: uninitialized symbol 'ext_cnt'
7. lpfc_debugfs.c:5300 lpfc_idiag_extacc_avail_get()
   error: uninitialized symbol 'ext_size'
8. lpfc_vmid.c:248 lpfc_vmid_get_appid()
   warn: sleeping in atomic context.
9. lpfc_init.c:8342 lpfc_sli4_driver_resource_setup()
   warn: missing error code 'rc'.
10. lpfc_init.c:13573 lpfc_sli4_hba_unset()
    warn: variable dereferenced before check 'phba->pport' (see
    line 13546)
11. lpfc_auth.c:1923 lpfc_auth_handle_dhchap_reply()
    error: double free of 'hash_value'

Fixes:
 1. Initialize vlan_id to LPFC_FCOE_NULL_VID.  2. Initialize
    vlan_id to LPFC_FCOE_NULL_VID.  3. prg->dist is a 2 bit field.
    Its value can only be between 0-3.
    Remove redundent check 'if (prg->dist < 4)'.
 4. Fix inconsistent indenting.  Moved logic into helper function
    lpfc_fill_vpd().
 5. Define 'eqhdl->irq' as int value as pci_irq_vector() returns int.
    Also, check for return value of pci_irq_vector() and log message
    in case of failure.
 6. Initialize 'ext_cnt' to 0.  7. Initialize 'ext_size' to 0.
 8. Use alloc_percpu_gfp() with GFP_ATOMIC flag.  9. 'rc' was not
    updated when dma_pool_create() fails.
    Update 'rc = -ENOMEM' when dma_pool_create() fails before
    calling goto statement.
 10. Add check for 'phba->pport' in lpfc_cpuhp_remove().
 11. Initialize 'hash_value' to NULL, same like 'aug_chal' variable.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |   2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c |   4 +-
 drivers/scsi/lpfc/lpfc_init.c    | 249 +++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_sli.c     |   3 +
 drivers/scsi/lpfc/lpfc_sli4.h    |   4 +-
 drivers/scsi/lpfc/lpfc_vmid.c    |   4 +-
 6 files changed, 148 insertions(+), 118 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index e37b028eae5f..f5252e45a48a 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5156,7 +5156,7 @@ lpfc_idiag_mbxacc_write(struct file *file, const char __user *buf,
 static int
 lpfc_idiag_extacc_avail_get(struct lpfc_hba *phba, char *pbuffer, int len)
 {
-	uint16_t ext_cnt, ext_size;
+	uint16_t ext_cnt = 0, ext_size = 0;
 
 	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\nAvailable Extents Information:\n");
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2b79351dfd11..c7f834ba8edb 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2970,7 +2970,7 @@ lpfc_mbx_cmpl_fcf_rr_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	uint32_t boot_flag, addr_mode;
 	uint16_t next_fcf_index, fcf_index;
 	uint16_t current_fcf_index;
-	uint16_t vlan_id;
+	uint16_t vlan_id = LPFC_FCOE_NULL_VID;
 	int rc;
 
 	/* If link state is not up, stop the roundrobin failover process */
@@ -3075,7 +3075,7 @@ lpfc_mbx_cmpl_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	struct fcf_record *new_fcf_record;
 	uint32_t boot_flag, addr_mode;
 	uint16_t fcf_index, next_fcf_index;
-	uint16_t vlan_id;
+	uint16_t vlan_id =  LPFC_FCOE_NULL_VID;
 	int rc;
 
 	/* If link state is not up, no need to proceed */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 511220aa43f5..844dc8a75907 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -325,8 +325,7 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	prog_id_word = pmboxq->u.mb.un.varWords[7];
 
 	/* Decode the Option rom version word to a readable string */
-	if (prg->dist < 4)
-		dist = dist_char[prg->dist];
+	dist = dist_char[prg->dist];
 
 	if ((prg->dist == 3) && (prg->num == 0))
 		snprintf(phba->OptionROMVersion, 32, "%d.%d%d",
@@ -2258,6 +2257,101 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	return;
 }
 
+static void
+lpfc_fill_vpd(struct lpfc_hba *phba, uint8_t *vpd, int length, int *pindex)
+{
+	int i, j;
+
+	while (length > 0) {
+		/* Look for Serial Number */
+		if ((vpd[*pindex] == 'S') && (vpd[*pindex + 1] == 'N')) {
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			j = 0;
+			length -= (3+i);
+			while (i--) {
+				phba->SerialNumber[j++] = vpd[(*pindex)++];
+				if (j == 31)
+					break;
+			}
+			phba->SerialNumber[j] = 0;
+			continue;
+		} else if ((vpd[*pindex] == 'V') && (vpd[*pindex + 1] == '1')) {
+			phba->vpd_flag |= VPD_MODEL_DESC;
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			j = 0;
+			length -= (3+i);
+			while (i--) {
+				phba->ModelDesc[j++] = vpd[(*pindex)++];
+				if (j == 255)
+					break;
+			}
+			phba->ModelDesc[j] = 0;
+			continue;
+		} else if ((vpd[*pindex] == 'V') && (vpd[*pindex + 1] == '2')) {
+			phba->vpd_flag |= VPD_MODEL_NAME;
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			j = 0;
+			length -= (3+i);
+			while (i--) {
+				phba->ModelName[j++] = vpd[(*pindex)++];
+				if (j == 79)
+					break;
+			}
+			phba->ModelName[j] = 0;
+			continue;
+		} else if ((vpd[*pindex] == 'V') && (vpd[*pindex + 1] == '3')) {
+			phba->vpd_flag |= VPD_PROGRAM_TYPE;
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			j = 0;
+			length -= (3+i);
+			while (i--) {
+				phba->ProgramType[j++] = vpd[(*pindex)++];
+				if (j == 255)
+					break;
+			}
+			phba->ProgramType[j] = 0;
+			continue;
+		} else if ((vpd[*pindex] == 'V') && (vpd[*pindex + 1] == '4')) {
+			phba->vpd_flag |= VPD_PORT;
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			j = 0;
+			length -= (3 + i);
+			while (i--) {
+				if ((phba->sli_rev == LPFC_SLI_REV4) &&
+				    (phba->sli4_hba.pport_name_sta ==
+				     LPFC_SLI4_PPNAME_GET)) {
+					j++;
+					(*pindex)++;
+				} else
+					phba->Port[j++] = vpd[(*pindex)++];
+				if (j == 19)
+					break;
+			}
+			if ((phba->sli_rev != LPFC_SLI_REV4) ||
+			    (phba->sli4_hba.pport_name_sta ==
+			     LPFC_SLI4_PPNAME_NON))
+				phba->Port[j] = 0;
+			continue;
+		} else {
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			*pindex += i;
+			length -= (3 + i);
+		}
+	}
+}
+
 /**
  * lpfc_parse_vpd - Parse VPD (Vital Product Data)
  * @phba: pointer to lpfc hba data structure.
@@ -2277,7 +2371,7 @@ lpfc_parse_vpd(struct lpfc_hba *phba, uint8_t *vpd, int len)
 {
 	uint8_t lenlo, lenhi;
 	int Length;
-	int i, j;
+	int i;
 	int finished = 0;
 	int index = 0;
 
@@ -2310,101 +2404,10 @@ lpfc_parse_vpd(struct lpfc_hba *phba, uint8_t *vpd, int len)
 			Length = ((((unsigned short)lenhi) << 8) + lenlo);
 			if (Length > len - index)
 				Length = len - index;
-			while (Length > 0) {
-			/* Look for Serial Number */
-			if ((vpd[index] == 'S') && (vpd[index+1] == 'N')) {
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				j = 0;
-				Length -= (3+i);
-				while(i--) {
-					phba->SerialNumber[j++] = vpd[index++];
-					if (j == 31)
-						break;
-				}
-				phba->SerialNumber[j] = 0;
-				continue;
-			}
-			else if ((vpd[index] == 'V') && (vpd[index+1] == '1')) {
-				phba->vpd_flag |= VPD_MODEL_DESC;
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				j = 0;
-				Length -= (3+i);
-				while(i--) {
-					phba->ModelDesc[j++] = vpd[index++];
-					if (j == 255)
-						break;
-				}
-				phba->ModelDesc[j] = 0;
-				continue;
-			}
-			else if ((vpd[index] == 'V') && (vpd[index+1] == '2')) {
-				phba->vpd_flag |= VPD_MODEL_NAME;
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				j = 0;
-				Length -= (3+i);
-				while(i--) {
-					phba->ModelName[j++] = vpd[index++];
-					if (j == 79)
-						break;
-				}
-				phba->ModelName[j] = 0;
-				continue;
-			}
-			else if ((vpd[index] == 'V') && (vpd[index+1] == '3')) {
-				phba->vpd_flag |= VPD_PROGRAM_TYPE;
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				j = 0;
-				Length -= (3+i);
-				while(i--) {
-					phba->ProgramType[j++] = vpd[index++];
-					if (j == 255)
-						break;
-				}
-				phba->ProgramType[j] = 0;
-				continue;
-			}
-			else if ((vpd[index] == 'V') && (vpd[index+1] == '4')) {
-				phba->vpd_flag |= VPD_PORT;
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				j = 0;
-				Length -= (3+i);
-				while(i--) {
-					if ((phba->sli_rev == LPFC_SLI_REV4) &&
-					    (phba->sli4_hba.pport_name_sta ==
-					     LPFC_SLI4_PPNAME_GET)) {
-						j++;
-						index++;
-					} else
-						phba->Port[j++] = vpd[index++];
-					if (j == 19)
-						break;
-				}
-				if ((phba->sli_rev != LPFC_SLI_REV4) ||
-				    (phba->sli4_hba.pport_name_sta ==
-				     LPFC_SLI4_PPNAME_NON))
-					phba->Port[j] = 0;
-				continue;
-			}
-			else {
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				index += i;
-				Length -= (3 + i);
-			}
-		}
-		finished = 0;
-		break;
+
+			lpfc_fill_vpd(phba, vpd, Length, &index);
+			finished = 0;
+			break;
 		case 0x78:
 			finished = 1;
 			break;
@@ -8304,8 +8307,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 					&phba->pcidev->dev,
 					phba->cfg_sg_dma_buf_size,
 					i, 0);
-	if (!phba->lpfc_sg_dma_buf_pool)
+	if (!phba->lpfc_sg_dma_buf_pool) {
+		rc = -ENOMEM;
 		goto out_free_bsmbx;
+	}
 
 	phba->lpfc_cmd_rsp_buf_pool =
 			dma_pool_create("lpfc_cmd_rsp_buf_pool",
@@ -8313,8 +8318,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 					sizeof(struct fcp_cmnd) +
 					sizeof(struct fcp_rsp),
 					i, 0);
-	if (!phba->lpfc_cmd_rsp_buf_pool)
+	if (!phba->lpfc_cmd_rsp_buf_pool) {
+		rc = -ENOMEM;
 		goto out_free_sg_dma_buf;
+	}
 
 	mempool_free(mboxq, phba->mbox_mem_pool);
 
@@ -12402,7 +12409,7 @@ lpfc_hba_eq_hdl_array_init(struct lpfc_hba *phba)
 
 	for (i = 0; i < phba->cfg_irq_chann; i++) {
 		eqhdl = lpfc_get_eq_hdl(i);
-		eqhdl->irq = LPFC_VECTOR_MAP_EMPTY;
+		eqhdl->irq = LPFC_IRQ_EMPTY;
 		eqhdl->phba = phba;
 	}
 }
@@ -12775,7 +12782,7 @@ static void __lpfc_cpuhp_remove(struct lpfc_hba *phba)
 
 static void lpfc_cpuhp_remove(struct lpfc_hba *phba)
 {
-	if (phba->pport->fc_flag & FC_OFFLINE_MODE)
+	if (phba->pport && (phba->pport->fc_flag & FC_OFFLINE_MODE))
 		return;
 
 	__lpfc_cpuhp_remove(phba);
@@ -13039,9 +13046,17 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 			 LPFC_DRIVER_HANDLER_NAME"%d", index);
 
 		eqhdl->idx = index;
-		rc = request_irq(pci_irq_vector(phba->pcidev, index),
-			 &lpfc_sli4_hba_intr_handler, 0,
-			 name, eqhdl);
+		rc = pci_irq_vector(phba->pcidev, index);
+		if (rc < 0) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"0489 MSI-X fast-path (%d) "
+					"pci_irq_vec failed (%d)\n", index, rc);
+			goto cfg_fail_out;
+		}
+		eqhdl->irq = rc;
+
+		rc = request_irq(eqhdl->irq, &lpfc_sli4_hba_intr_handler, 0,
+				 name, eqhdl);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0486 MSI-X fast-path (%d) "
@@ -13049,8 +13064,6 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 			goto cfg_fail_out;
 		}
 
-		eqhdl->irq = pci_irq_vector(phba->pcidev, index);
-
 		if (aff_mask) {
 			/* If found a neighboring online cpu, set affinity */
 			if (cpu_select < nr_cpu_ids)
@@ -13167,7 +13180,14 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	}
 
 	eqhdl = lpfc_get_eq_hdl(0);
-	eqhdl->irq = pci_irq_vector(phba->pcidev, 0);
+	rc = pci_irq_vector(phba->pcidev, 0);
+	if (rc < 0) {
+		pci_free_irq_vectors(phba->pcidev);
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0496 MSI pci_irq_vec failed (%d)\n", rc);
+		return rc;
+	}
+	eqhdl->irq = rc;
 
 	cpu = cpumask_first(cpu_present_mask);
 	lpfc_assign_eq_map_info(phba, 0, LPFC_CPU_FIRST_IRQ, cpu);
@@ -13194,8 +13214,8 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
  * MSI-X -> MSI -> IRQ.
  *
  * Return codes
- * 	0 - successful
- * 	other values - error
+ *	Interrupt mode (2, 1, 0) - successful
+ *	LPFC_INTR_ERROR - error
  **/
 static uint32_t
 lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
@@ -13240,7 +13260,14 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			intr_mode = 0;
 
 			eqhdl = lpfc_get_eq_hdl(0);
-			eqhdl->irq = pci_irq_vector(phba->pcidev, 0);
+			retval = pci_irq_vector(phba->pcidev, 0);
+			if (retval < 0) {
+				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"0502 INTR pci_irq_vec failed (%d)\n",
+					 retval);
+				return LPFC_INTR_ERROR;
+			}
+			eqhdl->irq = retval;
 
 			cpu = cpumask_first(cpu_present_mask);
 			lpfc_assign_eq_map_info(phba, 0, LPFC_CPU_FIRST_IRQ,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 06987d4013d5..99d06dc7ddf6 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6215,6 +6215,9 @@ lpfc_sli4_get_avail_extnt_rsrc(struct lpfc_hba *phba, uint16_t type,
 	struct lpfc_mbx_get_rsrc_extent_info *rsrc_info;
 	LPFC_MBOXQ_t *mbox;
 
+	*extnt_count = 0;
+	*extnt_size = 0;
+
 	mbox = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 1ddad5b170a6..cbb1aa1cf025 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -489,7 +489,7 @@ struct lpfc_hba;
 #define LPFC_SLI4_HANDLER_NAME_SZ	16
 struct lpfc_hba_eq_hdl {
 	uint32_t idx;
-	uint16_t irq;
+	int irq;
 	char handler_name[LPFC_SLI4_HANDLER_NAME_SZ];
 	struct lpfc_hba *phba;
 	struct lpfc_queue *eq;
@@ -611,6 +611,8 @@ struct lpfc_vector_map_info {
 };
 #define LPFC_VECTOR_MAP_EMPTY	0xffff
 
+#define LPFC_IRQ_EMPTY 0xffffffff
+
 /* Multi-XRI pool */
 #define XRI_BATCH               8
 
diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
index f64ced04b912..ed1d7f7b88a3 100644
--- a/drivers/scsi/lpfc/lpfc_vmid.c
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -245,9 +245,7 @@ int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid,
 		/* allocate the per cpu variable for holding */
 		/* the last access time stamp only if VMID is enabled */
 		if (!vmp->last_io_time)
-			vmp->last_io_time = __alloc_percpu(sizeof(u64),
-							   __alignof__(struct
-							   lpfc_vmid));
+			vmp->last_io_time = alloc_percpu_gfp(u64, GFP_ATOMIC);
 		if (!vmp->last_io_time) {
 			hash_del(&vmp->hnode);
 			vmp->flag = LPFC_VMID_SLOT_FREE;
-- 
2.35.3

