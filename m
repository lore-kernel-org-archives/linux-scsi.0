Return-Path: <SRS0=RKta=WM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5BDC3A589
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Aug 2019 02:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6DDE2089E
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Aug 2019 02:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EX38cmZm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfHPCg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Aug 2019 22:36:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33724 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfHPCg5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Aug 2019 22:36:57 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so2196076pgn.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Aug 2019 19:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0/8gCYjNTfeRf1fctovecP6Shrofe1jaKUhqQAZ0TBs=;
        b=EX38cmZmtGZkitE8pn8KjjEeC0aH2oCjzJqiMH7fbIyFTxAf1t8iz0+13t0l3G2ZRC
         mU4OyxdovHLnyn+lUeRPsdWCzLslqRdrpBDO/kM0Ewi7f4AjfS7gN9MhZ5cHOS6s0quA
         St6T90hOPvupt8GT/5hstLjXd8oATWPofxV5m3narcLgUSNyCrB6/XNthHF6MtKF/sMd
         vll6+c4k4nrbi+Ib4j/RF5SmnDPv6aayqGFAWbsUgjihPUkLnW/TqfTplraSo86iJESS
         gG2SOnOAjKyOcF9MmJhO10Qsq1sCpLm5GaaXV6O8lxa0B21L80/CqYZbNZDno0qdj9vh
         VxZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0/8gCYjNTfeRf1fctovecP6Shrofe1jaKUhqQAZ0TBs=;
        b=Ctc5RXGvu7wYbaSeJW7xoeqcrPlAGCN+7RqntHU31q3x2KqK9luYTnxQViS4ikCEm/
         yax75nZbHKGbRrzJfXaaVkezcj+Bcl5yRpOv6Bx1Y2TPvn7tAGgvqxI16yXXyonXIoWS
         nCGGbPEoBznpCdRIkTgheYWD3jybxqYqJxAfdB76MXvVO4r4CF8vZprQ2bNunCBCJNpx
         RwL4+jjV1IZAElTHJGfy64///zbf2beuV3IjjFuekbWAyp4i4eGLNrJzxKOZLHHhwfrR
         WJa40eIeIngZIT1m4BPFH+4V8LjPzm9w/PREEZg43s7G1YU5gWsS7RtVisQWd8ZsIh/l
         sjLQ==
X-Gm-Message-State: APjAAAUOwv4tFVOI5HHeEeNUCcu2udTA42NBBIRsRl+LqX1SQYWo/xmD
        lTTsUH57oJrDGXhYb4XwEVZjEuPV
X-Google-Smtp-Source: APXvYqxy5bpytb/i3ghNf9rd0/NyyRLB2sQCvXZexmhUlWQBRcDZpPZ6rckDbAyUgIu6QY9x6mBxpw==
X-Received: by 2002:aa7:8392:: with SMTP id u18mr8610672pfm.72.1565923016812;
        Thu, 15 Aug 2019 19:36:56 -0700 (PDT)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 16sm6616935pfc.66.2019.08.15.19.36.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 15 Aug 2019 19:36:56 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v3] lpfc: Mitigate high memory pre-allocation by SCSI-MQ
Date:   Thu, 15 Aug 2019 19:36:49 -0700
Message-Id: <20190816023649.16682-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When SCSI-MQ is enabled, the SCSI-MQ layers will do pre-allocation of
MQ resources based on shost values set by the driver. In newer cases
of the driver, which attempts to set nr_hw_queues to the cpu count,
the multipliers become excessive, with a single shost having SCSI-MQ
pre-allocation reaching into the multiple GBytes range.  NPIV, which
creates additional shosts, only multiply this overhead. On lower-memory
systems, this can exhaust system memory very quickly, resulting in a
system crash or failures in the driver or elsewhere due to low memory
conditions.

After testing several scenarios, the situation can be mitigated by
limiting the value set in shost->nr_hw_queues to 4. Although the shost
values were changed, the driver still had per-cpu hardware queues of
its own that allowed parallelization per-cpu.  Testing revealed that
even with the smallish number for nr_hw_queues for SCSI-MQ, performance
levels remained near maximum with the within-driver affiinitization.

A module parameter was created to allow the value set for the
nr_hw_queues to be tunable.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>

---
v3: add Ming's reviewed-by tag
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_attr.c | 15 +++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c | 10 ++++++----
 drivers/scsi/lpfc/lpfc_sli4.h |  5 +++++
 4 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 2c3bb8a966e5..bade2e025ecf 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -824,6 +824,7 @@ struct lpfc_hba {
 	uint32_t cfg_cq_poll_threshold;
 	uint32_t cfg_cq_max_proc_limit;
 	uint32_t cfg_fcp_cpu_map;
+	uint32_t cfg_fcp_mq_threshold;
 	uint32_t cfg_hdw_queue;
 	uint32_t cfg_irq_chann;
 	uint32_t cfg_suppress_rsp;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index ea62322ffe2b..8d8c495b5b60 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5709,6 +5709,19 @@ LPFC_ATTR_RW(nvme_embed_cmd, 1, 0, 2,
 	     "Embed NVME Command in WQE");
 
 /*
+ * lpfc_fcp_mq_threshold: Set the maximum number of Hardware Queues
+ * the driver will advertise it supports to the SCSI layer.
+ *
+ *      0    = Set nr_hw_queues by the number of CPUs or HW queues.
+ *      1,128 = Manually specify the maximum nr_hw_queue value to be set,
+ *
+ * Value range is [0,128]. Default value is 8.
+ */
+LPFC_ATTR_R(fcp_mq_threshold, LPFC_FCP_MQ_THRESHOLD_DEF,
+	    LPFC_FCP_MQ_THRESHOLD_MIN, LPFC_FCP_MQ_THRESHOLD_MAX,
+	    "Set the number of SCSI Queues advertised");
+
+/*
  * lpfc_hdw_queue: Set the number of Hardware Queues the driver
  * will advertise it supports to the NVME and  SCSI layers. This also
  * will map to the number of CQ/WQ pairs the driver will create.
@@ -6030,6 +6043,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_cq_poll_threshold,
 	&dev_attr_lpfc_cq_max_proc_limit,
 	&dev_attr_lpfc_fcp_cpu_map,
+	&dev_attr_lpfc_fcp_mq_threshold,
 	&dev_attr_lpfc_hdw_queue,
 	&dev_attr_lpfc_irq_chann,
 	&dev_attr_lpfc_suppress_rsp,
@@ -7112,6 +7126,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	/* Initialize first burst. Target vs Initiator are different. */
 	lpfc_nvme_enable_fb_init(phba, lpfc_nvme_enable_fb);
 	lpfc_nvmet_fb_size_init(phba, lpfc_nvmet_fb_size);
+	lpfc_fcp_mq_threshold_init(phba, lpfc_fcp_mq_threshold);
 	lpfc_hdw_queue_init(phba, lpfc_hdw_queue);
 	lpfc_irq_chann_init(phba, lpfc_irq_chann);
 	lpfc_enable_bbcr_init(phba, lpfc_enable_bbcr);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index faf43b1d3dbe..03998579d6ee 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4309,10 +4309,12 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	shost->max_cmd_len = 16;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ)
-			shost->nr_hw_queues = phba->cfg_hdw_queue;
-		else
-			shost->nr_hw_queues = phba->sli4_hba.num_present_cpu;
+		if (!phba->cfg_fcp_mq_threshold ||
+		    phba->cfg_fcp_mq_threshold > phba->cfg_hdw_queue)
+			phba->cfg_fcp_mq_threshold = phba->cfg_hdw_queue;
+
+		shost->nr_hw_queues = min_t(int, 2 * num_possible_nodes(),
+					    phba->cfg_fcp_mq_threshold);
 
 		shost->dma_boundary =
 			phba->sli4_hba.pc_sli4_params.sge_supp_len-1;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 3aeca387b22a..329f7aa7e169 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -44,6 +44,11 @@
 #define LPFC_HBA_HDWQ_MAX	128
 #define LPFC_HBA_HDWQ_DEF	0
 
+/* FCP MQ queue count limiting */
+#define LPFC_FCP_MQ_THRESHOLD_MIN	0
+#define LPFC_FCP_MQ_THRESHOLD_MAX	128
+#define LPFC_FCP_MQ_THRESHOLD_DEF	8
+
 /* Common buffer size to accomidate SCSI and NVME IO buffers */
 #define LPFC_COMMON_IO_BUF_SZ	768
 
-- 
2.13.7

