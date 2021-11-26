Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA00C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 05:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhKZFUy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbhKZFSw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 00:18:52 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A47C06173E;
        Thu, 25 Nov 2021 21:15:40 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q16so7108121pgq.10;
        Thu, 25 Nov 2021 21:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyIOSU6OK0AhgbhTy1/rHl0AeTcXT0C3LHL6fvUcevA=;
        b=KcAw4Qqum/Fq+ScwSA5YbcSTfD6fBJQu4YkgtDnFQQEYdvQcG38kpzXtACpKiUiEJf
         BDri+PAsorXvj9MT6tzDY6ljT9VnikXlMA+ddG2vwHru68/WSAXAbnVUCf/0t1Yy2HsH
         qdC7t6d4kUwk6Kj21wKbBZ4sRltY2pWHErCp5yB+jWxzb5/SRbgzbUZARFw0ExL2AybQ
         H3Zs6AwxQW30wn93py6EwV6DYj1sQJ+wB6kIKaI4TleAzhcTYNxLRqBIcB8oxqEC3pUI
         OXjKU9rKeMCHhwNNFt1Z2bq0KxtHbVXHowwUNMNDo1lWQBEo3AEJclm7UX4k74CtRpIf
         Sq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyIOSU6OK0AhgbhTy1/rHl0AeTcXT0C3LHL6fvUcevA=;
        b=MlR2Ld32BE7paEsfJXgsFG9UXcL11uZmXslbElIPw0sPN+FVfqM94mLcrwGUX6aXis
         nOSNvJVfcAiF91oIS2BLFzIqbip7+bSb8/Cl2XQ2frWCoyDzk6koysKl5Z3vboX0jmHu
         SCkKIfAIdZwsV7Xoyf6tuBOVrw8/VGazrDoyYeVM3EhilNhKkW3H+18U7xZww55aBEym
         voN+Cg0+j/iHrTFdSIv1yuF40FJYtCbxEoHMxghWWncvZ31i6dNQGHtZQ8GZz4VH84oX
         4qTX4eJTcHBevNuUtFazWW2vn1aWA2Q69ZS1Ii9wbiu+1guQbUicj9b04bzRSlcnEBzS
         0lrw==
X-Gm-Message-State: AOAM533cqh+39jOxdUgfpCPd4MUukzDiKhROgCbdAnfSekqP+/3sRBcm
        DJ+g9rhCLVptUMRfRRpeiv0URgWeAG6DMg==
X-Google-Smtp-Source: ABdhPJxVi4KhNjqj4oyNak2I+/swVvf39GFiVTDWjcFmQGMTNNvkN2dm3x6WitLxKLR58XnVqyenjA==
X-Received: by 2002:a63:e0b:: with SMTP id d11mr20079897pgl.260.1637903739750;
        Thu, 25 Nov 2021 21:15:39 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id lb4sm10326377pjb.18.2021.11.25.21.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 21:15:39 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com (supporter:QLOGIC QL41xxx ISCSI
        DRIVER), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:QLOGIC QL41xxx ISCSI DRIVER)
Subject: [PATCH 1/2] scsi: qedi: Remove set but unused 'page' variable
Date:   Thu, 25 Nov 2021 21:15:28 -0800
Message-Id: <20211126051529.5380-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126051529.5380-1-f.fainelli@gmail.com>
References: <20211126051529.5380-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The variable page is set but never used throughout qedi_alloc_bdq()
therefore remove it.

Reported-by: kernel test robot <lkp@intel.com>
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

