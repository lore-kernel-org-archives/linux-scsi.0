Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A51DC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 17:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355778AbhK0Rn5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 12:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244168AbhK0Rl4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 12:41:56 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F23CC06173E;
        Sat, 27 Nov 2021 09:38:41 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id c29so200539pgl.12;
        Sat, 27 Nov 2021 09:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G1gqFj3clXWd81d+tagIDoTyLSEKgRKuTjgTMfvLzXU=;
        b=NkYTIZ/0gzM3E0FWu98BncXqLTfzHa42nEejDVPwGAXpP/HAgxrMTc4+aR0yMY5qSJ
         OVyvH90/xXXuvksqazEgkjUyua3hpGrCtCN8zt+STMmaqoxYDxe5QmKeJL9AAgC07+vi
         BDLm9knf8v1xlBM9CRaSfN6h2Aig2BJFMlIJQgkiex9R1HswYYBW8/JboTQjs6ufIyxI
         hArghoWWB+gz+Y3wB1FDEEZRJVXFRfPRArjn+TKwKKplJO9JMJ5tS34RACn42aaQIf1W
         D8+U6Qu3rxSIk13xji4qRakjKHMVDSMupXYW863GDwrCfduN8x4EFvwF4To8VFROxwz5
         HK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1gqFj3clXWd81d+tagIDoTyLSEKgRKuTjgTMfvLzXU=;
        b=E1GVo6EKo/ew0g/vSlTTwFwRKRlm/rj1K4VT5Mbceb/g7+/n0AnS2qnfAY9TAHRdbg
         QJAnXUBKVtggRJehvkkBYB0nGOtDsmxEQimkDTSsQeyEsUT1E3TOVv7gclPqLhtBpnGL
         dKDrN78joWIjmQvsWvoIVamCbaw8lxnrOUQukGQzUY7N9h7BLAxUkP0UE8lZJf/Ale1H
         5QfIhoNbhkQjoGeIGKHzIpCMG1o+etmqTB+L477NzHy893AY4uKJmI5qDBujiOo9zHgq
         k6YLA/65dStx340tiqeyhCP1uOYDeTjZ3mEwtinnzpEXCmHYht5aizyyoct/zv8jMfmY
         RwDg==
X-Gm-Message-State: AOAM531MFYQ1SEAPEmIBxzb4T+vomjTuMi2QxOHLB6HCJV/ZcdDd1Dl0
        zyf+zDRR+hz/kkKluGn/UUmAYRXaRNrQTQ==
X-Google-Smtp-Source: ABdhPJzBjLoGgoqXbfxqcwqxqaJSsG8xONXeqLp9O2K2KP3UmGTNh5MCWtFXU8DS4MY80cYcbILVGA==
X-Received: by 2002:a63:ef03:: with SMTP id u3mr15761534pgh.74.1638034720702;
        Sat, 27 Nov 2021 09:38:40 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (70-36-60-214.dyn.novuscom.net. [70.36.60.214])
        by smtp.gmail.com with ESMTPSA id t19sm8051776pgn.7.2021.11.27.09.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 09:38:40 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com (supporter:QLOGIC QL41xxx ISCSI
        DRIVER), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:QLOGIC QL41xxx ISCSI DRIVER)
Subject: [PATCH v2 1/2] scsi: qedi: Remove set but unused 'page' variable
Date:   Fri, 26 Nov 2021 12:17:07 -0800
Message-Id: <20211126201708.27140-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126201708.27140-1-f.fainelli@gmail.com>
References: <20211126201708.27140-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The variable page is set but never used throughout qedi_alloc_bdq()
therefore remove it.

Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/scsi/qedi/qedi_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 1dec814d8788..f1c933070884 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1538,7 +1538,6 @@ static int qedi_alloc_bdq(struct qedi_ctx *qedi)
 	int i;
 	struct scsi_bd *pbl;
 	u64 *list;
-	dma_addr_t page;
 
 	/* Alloc dma memory for BDQ buffers */
 	for (i = 0; i < QEDI_BDQ_NUM; i++) {
@@ -1608,11 +1607,9 @@ static int qedi_alloc_bdq(struct qedi_ctx *qedi)
 	qedi->bdq_pbl_list_num_entries = qedi->bdq_pbl_mem_size /
 					 QEDI_PAGE_SIZE;
 	list = (u64 *)qedi->bdq_pbl_list;
-	page = qedi->bdq_pbl_list_dma;
 	for (i = 0; i < qedi->bdq_pbl_list_num_entries; i++) {
 		*list = qedi->bdq_pbl_dma;
 		list++;
-		page += QEDI_PAGE_SIZE;
 	}
 
 	return 0;
-- 
2.25.1

