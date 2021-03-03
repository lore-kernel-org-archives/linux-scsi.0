Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD17C4332B
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A866F64EEC
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444445AbhCDAcq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbhCCOw2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:52:28 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C8AC0610E0
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:47 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k66so6597506wmf.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bCbfbKrHtTJDrvzcr+wliVfv0YCW7v3SbQO0PUWBLF8=;
        b=A1JLya9fwpQcKfCxmMLTX9NOLzHRWtg7dnUwdbzdTQf1I/OQEToMX74gsgs153HQvC
         3VdaBSTCIi957+WbZ839j99Y3rLxaCsaf1ohq2LvgYy8oHtdHiQ1QDqzlpaoef261Vx4
         rqN0jdq7ShbaG7A/Vw0C1wLNnn2Z5oi/9TX/45mkQn6VdGecAW8vIBTvcXL7t4HMbn/x
         3+zQB4zP/flYI7A0spQ+Zsw5mH+uMJjA4t79ztS1+I2O4tXAzaapmnPWBDU6NYxPaTTq
         xx4/dWJOjJ0g831aE+PH9e/LbR74slRAQBgjmGrgAosGteet/fm3saLd8XMZThg3NOyg
         w6rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bCbfbKrHtTJDrvzcr+wliVfv0YCW7v3SbQO0PUWBLF8=;
        b=J8kxq6ufeBD4g1hoepvGyZBqJUV8lt13g500FOOugZZceORwyiSOwYmvBaBvjhwEp/
         bJxruHtGJdCcnnZdjuYN8cwJoDlhDkscp5alv/X32mnJzKKZTH98o/bXTHZ5BUyShC0q
         C0AZficLKgHz6NDJpgZGmfDa9AWbaBXqpx8uxydXIUhiirZRVRNMlViOFhPv0t2x9fxo
         6X1bDMRXX4qUS8yaBPICpru2DGXYmahVHI3c+Fqdswm6KTU1Y11inHRrFI0CVn64B4h3
         0UhF5odDKVtevc1fydlATGdfu99dAcf21saYFSwwhNAZj3LcD/JBvLSTs27I3SenNcoW
         bVgg==
X-Gm-Message-State: AOAM5329llg9DHCxLQGo+Y1+O4SjYfE96av7mHWc3bFQjg7E7rtl33us
        RlYeShDBNPMvqqOFuZnn4IzDnmuTzgeFJA==
X-Google-Smtp-Source: ABdhPJy3POs+S8L1atahS3fz8o7+Mq3KPS2VTa9MSql5Oudk/Wi7rii+GltX79ENIfSNNpfvjdEVJQ==
X-Received: by 2002:a1c:8005:: with SMTP id b5mr9579447wmd.130.1614782848920;
        Wed, 03 Mar 2021 06:47:28 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:28 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Chaw <david_chaw@adaptec.com>,
        Luben Tuikov <luben_tuikov@adaptec.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 21/30] scsi: aic94xx: aic94xx_dump: Remove code that has been unused for at least 13 years
Date:   Wed,  3 Mar 2021 14:46:22 +0000
Message-Id: <20210303144631.3175331-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
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

