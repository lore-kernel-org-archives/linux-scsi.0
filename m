Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8E1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiDLXgX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiDLXcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:47 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65158CDAD
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:17 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a21so268567pfv.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fNiZViB4FtI2s2l7TxN4nH581qAP+ANAIyQ7TDuLSSE=;
        b=RWe8Eva4JB/nstMZCO04icITw2qrrdHJDYi51Fx8d1iXhNNbdL01G4mcnsEUF0AeET
         cCbVZeHCsE7dwSjpdKjI4+HTYo0VM/z+AGgp1FJuzgNCbS+eQcnu7RJSQMm7hT/ULsLQ
         5fin4I/rYWR1AcShEP2SvIIa9V5htUfgmHQSO2py9t1tmVm4bhIogQwWEarqwjvI/eOC
         wyK60Lm+4/C7bExCHo/+ZosUdPG5BJywuVMZawLNEZ6mamUSR8JSBj21rWiPAlEEWXG8
         5rcQqxdnQWmTzbjxYhdLGN1qlDH58FLFXBEcaK9JS8ZdMOySb0jboLv38hW9fxMifj9e
         WSrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fNiZViB4FtI2s2l7TxN4nH581qAP+ANAIyQ7TDuLSSE=;
        b=zHhpUmRZgozNi42p4fnHJr2NX3N3bDIhDitTNB/NMnXpMP6qqjLdDbjieKy0s2X4kT
         ggZNCexe+9BJ2A6cOHEHp2DbwBJBnE+kjH6rnzltU4Q1sFecCMJ0UWBu9BZ1DQoIAQwA
         7SQKh2Ezz7HipokE8VUEDwjW5epOn2QD4LqvXFVoXsoKAkKGAF+EUqRR5q/xTSO3qMFO
         qXVoQrNDHUqLgmj1VSDGc3Hw0jfj+9wnOblk6M4ewbCRVAZ65MIpnkM3k8cljQs1BCyc
         vPbqh2Pw/u+BEUENKrFpCTxbXtuVhnfLta4VHzPsOfbxBsU6EJjHYDqJPlH5xlrEtqYB
         WPfw==
X-Gm-Message-State: AOAM5308eruWygUp7hCEsMZgVSxoBMXQGWbgScMt2U8w7mCuoHCcuygI
        gfJjQvwLC94XS0qFhgXtHMYEb/LobT0=
X-Google-Smtp-Source: ABdhPJwuU1lsaOP2JBnbRNavoiu1zGKl0slGtTPawVLKpIFU8r/dKIiYI1xBYLc5cFP+1n2JVuaH9Q==
X-Received: by 2002:a63:de41:0:b0:398:db26:bb6 with SMTP id y1-20020a63de41000000b00398db260bb6mr32245183pgi.516.1649802017024;
        Tue, 12 Apr 2022 15:20:17 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:16 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 02/26] lpfc: Move cfg_log_verbose check before calling lpfc_dmp_dbg
Date:   Tue, 12 Apr 2022 15:19:44 -0700
Message-Id: <20220412222008.126521-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In an attempt to log message 0126 with LOG_TRACE_EVENT, the following hard
lockup call trace hangs the system.

Call Trace:
 _raw_spin_lock_irqsave+0x32/0x40
 lpfc_dmp_dbg.part.32+0x28/0x220 [lpfc]
 lpfc_cmpl_els_fdisc+0x145/0x460 [lpfc]
 lpfc_sli_cancel_jobs+0x92/0xd0 [lpfc]
 lpfc_els_flush_cmd+0x43c/0x670 [lpfc]
 lpfc_els_flush_all_cmd+0x37/0x60 [lpfc]
 lpfc_sli4_async_event_proc+0x956/0x1720 [lpfc]
 lpfc_do_work+0x1485/0x1d70 [lpfc]
 kthread+0x112/0x130
 ret_from_fork+0x1f/0x40
Kernel panic - not syncing: Hard LOCKUP

The same CPU tries to claim the phba->port_list_lock twice.

Move the cfg_log_verbose checks as part of the lpfc_printf_vlog and
lpfc_printf_log macros before calling lpfc_dmp_dbg.  There is no
need to take the phba->port_list_lock within lpfc_dmp_dbg.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c   | 29 +----------------------------
 drivers/scsi/lpfc/lpfc_logmsg.h |  6 +++---
 2 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 461d333b1b3a..f9cd4b72d949 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -15700,34 +15700,7 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 	unsigned int temp_idx;
 	int i;
 	int j = 0;
-	unsigned long rem_nsec, iflags;
-	bool log_verbose = false;
-	struct lpfc_vport *port_iterator;
-
-	/* Don't dump messages if we explicitly set log_verbose for the
-	 * physical port or any vport.
-	 */
-	if (phba->cfg_log_verbose)
-		return;
-
-	spin_lock_irqsave(&phba->port_list_lock, iflags);
-	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
-		if (port_iterator->load_flag & FC_UNLOADING)
-			continue;
-		if (scsi_host_get(lpfc_shost_from_vport(port_iterator))) {
-			if (port_iterator->cfg_log_verbose)
-				log_verbose = true;
-
-			scsi_host_put(lpfc_shost_from_vport(port_iterator));
-
-			if (log_verbose) {
-				spin_unlock_irqrestore(&phba->port_list_lock,
-						       iflags);
-				return;
-			}
-		}
-	}
-	spin_unlock_irqrestore(&phba->port_list_lock, iflags);
+	unsigned long rem_nsec;
 
 	if (atomic_cmpxchg(&phba->dbg_log_dmping, 0, 1) != 0)
 		return;
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 7d480c798794..a5aafe230c74 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -73,7 +73,7 @@ do { \
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
 do { \
 	{ if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '3')) { \
-		if ((mask) & LOG_TRACE_EVENT) \
+		if ((mask) & LOG_TRACE_EVENT && !(vport)->cfg_log_verbose) \
 			lpfc_dmp_dbg((vport)->phba); \
 		dev_printk(level, &((vport)->phba->pcidev)->dev, "%d:(%d):" \
 			   fmt, (vport)->phba->brd_no, vport->vpi, ##arg);  \
@@ -89,11 +89,11 @@ do { \
 				 (phba)->pport->cfg_log_verbose : \
 				 (phba)->cfg_log_verbose; \
 	if (((mask) & log_verbose) || (level[1] <= '3')) { \
-		if ((mask) & LOG_TRACE_EVENT) \
+		if ((mask) & LOG_TRACE_EVENT && !log_verbose) \
 			lpfc_dmp_dbg(phba); \
 		dev_printk(level, &((phba)->pcidev)->dev, "%d:" \
 			fmt, phba->brd_no, ##arg); \
-	} else  if (!(phba)->cfg_log_verbose)\
+	} else if (!log_verbose)\
 		lpfc_dbg_print(phba, "%d:" fmt, phba->brd_no, ##arg); \
 	} \
 } while (0)
-- 
2.26.2

