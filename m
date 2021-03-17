Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389C0C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA9CE64F2B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhCQI5Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhCQI5I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:08 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53199C06175F
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:08 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j7so962967wrd.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bCbfbKrHtTJDrvzcr+wliVfv0YCW7v3SbQO0PUWBLF8=;
        b=wss+x1ep2vqjhxs3d2Ga+RWpFoLc/bjyYAu+FA6AznshqZuy/nPTiYdkZu4QgIKOC5
         vBkAm8rposwYziRqN/fv62OqZ2nl9w0Pg0GasebAmJPIJhvHO9UXBsdoA/rEoDqVDmMi
         d/VsS1EibPkSYO6jKJoL0S4x5YHXx1hwbQJl5MjfiW8tKB85C9+DsOEXKsGoI8vyecNU
         hdv9qJIbWWH4l9HIno1dJa82tLeBqTE/L5LEM1zVp+jg+HXj03rDh21cuyap+jTHkyPX
         cqCqnjTHVF5AaaXZbA7sbwYg5LdltTFODr/xn5LtRDuJEGb4irDpbb0XQzYNw5Io9h9H
         XcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bCbfbKrHtTJDrvzcr+wliVfv0YCW7v3SbQO0PUWBLF8=;
        b=rojG9Gk5sDBvqV5yVPbBPWO8YaPJylb/DEfriADgDjl4z2SuX8W/nCBPQn+W8a2rXQ
         cjNexmRojwGwp88eohrtfe2ad/l8RpPsOAskgmUK63/xYxBNUZb+9/sfkZxsblUf3apK
         HaR///m7SRgffBVdBRB4HKYGu0it9Rw674mvQePL0JnSTb3Flp2d7+GpLaSQtld9iaOc
         YHeC3JPevSUTKM+iBczW/yE/QjWtSovCeAThrSkpAcjQeiH6FDHeVihm+mJZ6/cDPXsb
         oZ+aFeIblsR4X4oled2lKdhdQ6o/e+xAZfdoz08cOcfQJgX88zKE0GdbZuFS0jS1dwXz
         zjIA==
X-Gm-Message-State: AOAM532yTH6z/wgPxmKPQ+JcqoouBAIlYVZVi3jq1nikaQR1bxngXiUU
        goxl1DfhZQS7R2KPhuCGJy0MQawSGRWmxg==
X-Google-Smtp-Source: ABdhPJyi8UI083o4YsH06N81QSUcZ93H3JvbS5lUgVLXwbWn1KIagf2Lg5Jzry/TpeMdFFQumC7ERA==
X-Received: by 2002:adf:f908:: with SMTP id b8mr3170845wrr.184.1615971427027;
        Wed, 17 Mar 2021 01:57:07 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Chaw <david_chaw@adaptec.com>,
        Luben Tuikov <luben_tuikov@adaptec.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 01/18] scsi: aic94xx: aic94xx_dump: Remove code that has been unused for at least 13 years
Date:   Wed, 17 Mar 2021 08:56:44 +0000
Message-Id: <20210317085701.2891231-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic94xx/aic94xx_dump.c:731: warning: expecting prototype for asd_dump_ddb_site(). Prototype was for asd_dump_target_ddb() instead
 drivers/scsi/aic94xx/aic94xx_dump.c:875: warning: expecting prototype for ads_dump_seq_state(). Prototype was for asd_dump_seq_state() instead

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Chaw <david_chaw@adaptec.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic94xx/aic94xx_dump.c | 184 ----------------------------
 1 file changed, 184 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_dump.c b/drivers/scsi/aic94xx/aic94xx_dump.c
index 7c4c53a54b782..47a663a39dcce 100644
--- a/drivers/scsi/aic94xx/aic94xx_dump.c
+++ b/drivers/scsi/aic94xx/aic94xx_dump.c
@@ -720,152 +720,6 @@ static void asd_dump_lseq_state(struct asd_ha_struct *asd_ha, int lseq)
 	PRINT_LMIP_dword(asd_ha, lseq, DEV_PRES_TIMER_TERM_TS);
 }
 
-#if 0
-
-/**
- * asd_dump_ddb_site -- dump a CSEQ DDB site
- * @asd_ha: pointer to host adapter structure
- * @site_no: site number of interest
- */
-void asd_dump_target_ddb(struct asd_ha_struct *asd_ha, u16 site_no)
-{
-	if (site_no >= asd_ha->hw_prof.max_ddbs)
-		return;
-
-#define DDB_FIELDB(__name)                                        \
-	asd_ddbsite_read_byte(asd_ha, site_no,                    \
-			      offsetof(struct asd_ddb_ssp_smp_target_port, __name))
-#define DDB2_FIELDB(__name)                                       \
-	asd_ddbsite_read_byte(asd_ha, site_no,                    \
-			      offsetof(struct asd_ddb_stp_sata_target_port, __name))
-#define DDB_FIELDW(__name)                                        \
-	asd_ddbsite_read_word(asd_ha, site_no,                    \
-			      offsetof(struct asd_ddb_ssp_smp_target_port, __name))
-
-#define DDB_FIELDD(__name)                                         \
-	asd_ddbsite_read_dword(asd_ha, site_no,                    \
-			       offsetof(struct asd_ddb_ssp_smp_target_port, __name))
-
-	asd_printk("DDB: 0x%02x\n", site_no);
-	asd_printk("conn_type: 0x%02x\n", DDB_FIELDB(conn_type));
-	asd_printk("conn_rate: 0x%02x\n", DDB_FIELDB(conn_rate));
-	asd_printk("init_conn_tag: 0x%04x\n", be16_to_cpu(DDB_FIELDW(init_conn_tag)));
-	asd_printk("send_queue_head: 0x%04x\n", be16_to_cpu(DDB_FIELDW(send_queue_head)));
-	asd_printk("sq_suspended: 0x%02x\n", DDB_FIELDB(sq_suspended));
-	asd_printk("DDB Type: 0x%02x\n", DDB_FIELDB(ddb_type));
-	asd_printk("AWT Default: 0x%04x\n", DDB_FIELDW(awt_def));
-	asd_printk("compat_features: 0x%02x\n", DDB_FIELDB(compat_features));
-	asd_printk("Pathway Blocked Count: 0x%02x\n",
-		   DDB_FIELDB(pathway_blocked_count));
-	asd_printk("arb_wait_time: 0x%04x\n", DDB_FIELDW(arb_wait_time));
-	asd_printk("more_compat_features: 0x%08x\n",
-		   DDB_FIELDD(more_compat_features));
-	asd_printk("Conn Mask: 0x%02x\n", DDB_FIELDB(conn_mask));
-	asd_printk("flags: 0x%02x\n", DDB_FIELDB(flags));
-	asd_printk("flags2: 0x%02x\n", DDB2_FIELDB(flags2));
-	asd_printk("ExecQ Tail: 0x%04x\n",DDB_FIELDW(exec_queue_tail));
-	asd_printk("SendQ Tail: 0x%04x\n",DDB_FIELDW(send_queue_tail));
-	asd_printk("Active Task Count: 0x%04x\n",
-		   DDB_FIELDW(active_task_count));
-	asd_printk("ITNL Reason: 0x%02x\n", DDB_FIELDB(itnl_reason));
-	asd_printk("ITNL Timeout Const: 0x%04x\n", DDB_FIELDW(itnl_timeout));
-	asd_printk("ITNL timestamp: 0x%08x\n", DDB_FIELDD(itnl_timestamp));
-}
-
-void asd_dump_ddb_0(struct asd_ha_struct *asd_ha)
-{
-#define DDB0_FIELDB(__name)                                  \
-	asd_ddbsite_read_byte(asd_ha, 0,                     \
-			      offsetof(struct asd_ddb_seq_shared, __name))
-#define DDB0_FIELDW(__name)                                  \
-	asd_ddbsite_read_word(asd_ha, 0,                     \
-			      offsetof(struct asd_ddb_seq_shared, __name))
-
-#define DDB0_FIELDD(__name)                                  \
-	asd_ddbsite_read_dword(asd_ha,0 ,                    \
-			       offsetof(struct asd_ddb_seq_shared, __name))
-
-#define DDB0_FIELDA(__name, _o)                              \
-	asd_ddbsite_read_byte(asd_ha, 0,                     \
-			      offsetof(struct asd_ddb_seq_shared, __name)+_o)
-
-
-	asd_printk("DDB: 0\n");
-	asd_printk("q_free_ddb_head:%04x\n", DDB0_FIELDW(q_free_ddb_head));
-	asd_printk("q_free_ddb_tail:%04x\n", DDB0_FIELDW(q_free_ddb_tail));
-	asd_printk("q_free_ddb_cnt:%04x\n",  DDB0_FIELDW(q_free_ddb_cnt));
-	asd_printk("q_used_ddb_head:%04x\n", DDB0_FIELDW(q_used_ddb_head));
-	asd_printk("q_used_ddb_tail:%04x\n", DDB0_FIELDW(q_used_ddb_tail));
-	asd_printk("shared_mem_lock:%04x\n", DDB0_FIELDW(shared_mem_lock));
-	asd_printk("smp_conn_tag:%04x\n",    DDB0_FIELDW(smp_conn_tag));
-	asd_printk("est_nexus_buf_cnt:%04x\n", DDB0_FIELDW(est_nexus_buf_cnt));
-	asd_printk("est_nexus_buf_thresh:%04x\n",
-		   DDB0_FIELDW(est_nexus_buf_thresh));
-	asd_printk("conn_not_active:%02x\n", DDB0_FIELDB(conn_not_active));
-	asd_printk("phy_is_up:%02x\n",       DDB0_FIELDB(phy_is_up));
-	asd_printk("port_map_by_links:%02x %02x %02x %02x "
-		   "%02x %02x %02x %02x\n",
-		   DDB0_FIELDA(port_map_by_links, 0),
-		   DDB0_FIELDA(port_map_by_links, 1),
-		   DDB0_FIELDA(port_map_by_links, 2),
-		   DDB0_FIELDA(port_map_by_links, 3),
-		   DDB0_FIELDA(port_map_by_links, 4),
-		   DDB0_FIELDA(port_map_by_links, 5),
-		   DDB0_FIELDA(port_map_by_links, 6),
-		   DDB0_FIELDA(port_map_by_links, 7));
-}
-
-static void asd_dump_scb_site(struct asd_ha_struct *asd_ha, u16 site_no)
-{
-
-#define SCB_FIELDB(__name)                                                 \
-	asd_scbsite_read_byte(asd_ha, site_no, sizeof(struct scb_header)   \
-			      + offsetof(struct initiate_ssp_task, __name))
-#define SCB_FIELDW(__name)                                                 \
-	asd_scbsite_read_word(asd_ha, site_no, sizeof(struct scb_header)   \
-			      + offsetof(struct initiate_ssp_task, __name))
-#define SCB_FIELDD(__name)                                                 \
-	asd_scbsite_read_dword(asd_ha, site_no, sizeof(struct scb_header)  \
-			       + offsetof(struct initiate_ssp_task, __name))
-
-	asd_printk("Total Xfer Len: 0x%08x.\n", SCB_FIELDD(total_xfer_len));
-	asd_printk("Frame Type: 0x%02x.\n", SCB_FIELDB(ssp_frame.frame_type));
-	asd_printk("Tag: 0x%04x.\n", SCB_FIELDW(ssp_frame.tag));
-	asd_printk("Target Port Xfer Tag: 0x%04x.\n",
-		   SCB_FIELDW(ssp_frame.tptt));
-	asd_printk("Data Offset: 0x%08x.\n", SCB_FIELDW(ssp_frame.data_offs));
-	asd_printk("Retry Count: 0x%02x.\n", SCB_FIELDB(retry_count));
-}
-
-/**
- * asd_dump_scb_sites -- dump currently used CSEQ SCB sites
- * @asd_ha: pointer to host adapter struct
- */
-void asd_dump_scb_sites(struct asd_ha_struct *asd_ha)
-{
-	u16	site_no;
-
-	for (site_no = 0; site_no < asd_ha->hw_prof.max_scbs; site_no++) {
-		u8 opcode;
-
-		if (!SCB_SITE_VALID(site_no))
-			continue;
-
-		/* We are only interested in SCB sites currently used.
-		 */
-		opcode = asd_scbsite_read_byte(asd_ha, site_no,
-					       offsetof(struct scb_header,
-							opcode));
-		if (opcode == 0xFF)
-			continue;
-
-		asd_printk("\nSCB: 0x%x\n", site_no);
-		asd_dump_scb_site(asd_ha, site_no);
-	}
-}
-
-#endif  /*  0  */
-
 /**
  * ads_dump_seq_state -- dump CSEQ and LSEQ states
  * @asd_ha: pointer to host adapter structure
@@ -908,42 +762,4 @@ void asd_dump_frame_rcvd(struct asd_phy *phy,
 	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
 }
 
-#if 0
-
-static void asd_dump_scb(struct asd_ascb *ascb, int ind)
-{
-	asd_printk("scb%d: vaddr: 0x%p, dma_handle: 0x%llx, next: 0x%llx, "
-		   "index:%d, opcode:0x%02x\n",
-		   ind, ascb->dma_scb.vaddr,
-		   (unsigned long long)ascb->dma_scb.dma_handle,
-		   (unsigned long long)
-		   le64_to_cpu(ascb->scb->header.next_scb),
-		   le16_to_cpu(ascb->scb->header.index),
-		   ascb->scb->header.opcode);
-}
-
-void asd_dump_scb_list(struct asd_ascb *ascb, int num)
-{
-	int i = 0;
-
-	asd_printk("dumping %d scbs:\n", num);
-
-	asd_dump_scb(ascb, i++);
-	--num;
-
-	if (num > 0 && !list_empty(&ascb->list)) {
-		struct list_head *el;
-
-		list_for_each(el, &ascb->list) {
-			struct asd_ascb *s = list_entry(el, struct asd_ascb,
-							list);
-			asd_dump_scb(s, i++);
-			if (--num <= 0)
-				break;
-		}
-	}
-}
-
-#endif  /*  0  */
-
 #endif /* ASD_DEBUG */
-- 
2.27.0

