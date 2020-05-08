Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06464C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 09:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D54AA208DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 09:19:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KP0eStUj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgEHJTN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 05:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgEHJTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 05:19:13 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF6FC05BD43
        for <linux-scsi@vger.kernel.org>; Fri,  8 May 2020 02:19:12 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j5so1022046wrq.2
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 02:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dLM3aaZFjTo6AVK2W1obBjRTchEjF5uUlbZ0dyrxQSk=;
        b=KP0eStUjLLIO9rx1qEgE+/q4QlR9p4S5SYJYt9TnMdhOv+kn4spmVMYqbJEKsoxpLj
         pcFFYrWV5Z3spIepSnILjealIq+2sqnyya+DPaORykw4TZlZwbxZLaxqy+zX6ZprJkVk
         +l/1c7VL1x8BavJUA8bAl2h1eFWYQ9hTKUiwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dLM3aaZFjTo6AVK2W1obBjRTchEjF5uUlbZ0dyrxQSk=;
        b=M71sVNygOufZavNnhZY1ccNiRNdzP/6Y/cgY+esUvR6UBid2XulqpzB1Uegtk+tJnV
         sRpoMI4/EvP3ZVFHGXSgVKac2uFsVb8KU+3pIEBciEMUFf+gek8EOuiV6aAfmNC8ucmV
         zKcbdTB8T+BtvAydn/1sqFjS0jEkq2pX5EJUp0KFzhdi7EX6GMsrp6J1CEE3qDiPXgHG
         TVWjOyQg7FfIZKvMz/Yjl9MjeJdoU49AiOIroAXCD4ozonmWwOWn6sUiNKNxZ7wMQ6U9
         jGxQMoOHT96vc6RluRpvE9rGpB+eemTvkicsK0txNfG4OY4u4nRKW106r10LsrTBJbnV
         gJ3w==
X-Gm-Message-State: AGi0PubkOlkFY3w12YD4/M+bAfcbOHW7a1PtXpGeW3Pnwp4CSNSjTFIm
        6aXqEow/TK+ii2QPyUmTZEO5wbbgSFMovM41yVhwDYZBm4YL+l7MNeaPfs8MYl9TvHoRDK4hAWH
        tmvQaK3Clet3PPER+AUUbsGCBTiDVbwnfZ/BUa2O3jcqpMYxLG9PHsYbt+RPRO6vQ0VpYWvFPFT
        qWXBEUSD9NWLCI+R+G5AJk
X-Google-Smtp-Source: APiQypIAVo8FFTLTiTOG7vm3m6SHmb5GJ99niMh+mowwmAlZgVaVg9vRwqH7Sb47o1WA1JBObX4lnA==
X-Received: by 2002:adf:e9cf:: with SMTP id l15mr1936168wrn.166.1588929551139;
        Fri, 08 May 2020 02:19:11 -0700 (PDT)
Received: from dhcp-10-123-20-28.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id q2sm1975751wrm.42.2020.05.08.02.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 02:19:10 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     dan.carpenter@oracle.com, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt3sas: Fix double free warnings
Date:   Fri,  8 May 2020 05:18:54 -0400
Message-Id: <20200508091854.32748-1-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix below warnings from Smatch static analyser:
drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
warn: 'ioc->hpr_lookup' double freed

drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
warn: 'ioc->internal_lookup' double freed

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7fa3bdb..a6dbc73 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4898,8 +4898,14 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		    ioc->config_page, ioc->config_page_dma);
 	}
 
-	kfree(ioc->hpr_lookup);
-	kfree(ioc->internal_lookup);
+	if (ioc->hpr_lookup) {
+		kfree(ioc->hpr_lookup);
+		ioc->hpr_lookup = NULL;
+	}
+	if (ioc->internal_lookup) {
+		kfree(ioc->internal_lookup);
+		ioc->internal_lookup = NULL;
+	}
 	if (ioc->chain_lookup) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
 			for (j = ioc->chains_per_prp_buffer;
-- 
2.18.4

