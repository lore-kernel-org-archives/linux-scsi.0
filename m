Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A155C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 517812075E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="e2hNRYED"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfLZLOR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:14:17 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43214 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZLOQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:14:16 -0500
Received: by mail-wr1-f68.google.com with SMTP id d16so23379030wre.10
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KlB9cNQYOTRWQ676eNU/RKDw0MpvVp0yekZVxeNTXzM=;
        b=e2hNRYEDiBT/UgZo6If/EcjqMHB57fDeK2cY6Lev79LBcB1vPbXJKzhdGo15rpRIn+
         CD1PyRVfHdHAqhEGLBFF1jf8TWR9EWF7VaTz4lHB8XW+RLfk4h+mxiHHSzab5XpA8ufJ
         R/xCbRnYy0c2SCSD8fdu3nYbscGhOPMCQBL2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KlB9cNQYOTRWQ676eNU/RKDw0MpvVp0yekZVxeNTXzM=;
        b=Jlae66FfEODCKjqxe3yVGFT8Ha4tSX06f7lEmZKCYd2qo7nj9RYECgUmZBt4QdhTy4
         NCJfzaQ39rzEz25IibTD0BgeYfwV9PkC5+g4AuNzq7X5fhdC2tBp5Vu7Hljy7cUUlgB1
         iUjxdVg/vkIS4007Ql5kDwOg4J30dLrCSYT5YRif0dx//bGjyA41XgeDPLBv1sgB+fB9
         uaDQWup3+N+7dwdAlb4xqyaJa4efPT2ELS9e/0zzyGDCZPlq3qC3XQxxkqGFOFBgNVfS
         wMOm2WTiTxiXDXHv/eRznsiyf2WDVmlBkxFPtFBC7hKSpEmiP3RJXGFSMEIEvzjqObMG
         4Htg==
X-Gm-Message-State: APjAAAUJllnxylxNhhvK/wdDu+9pvGrQMOlyKzDbJghy1ulFESrU1QRf
        FSI205eRfkLhcRaI9UHN3AIhZyELKuzujfdXs0iFytnxhvLp0rhvX0Qt0udBbZ7fVyuXaZHbADL
        0H3yJ/IyQ887JmQHFgWVgu1SgCT0DH041vuh2yY743NaP89gd1u416lW3qXBTtsV0ednYiBNz8n
        kgQ5YvrtJq
X-Google-Smtp-Source: APXvYqzc6WjvKE2ECbyY100ih/sV0IzahDnqNuWPgyD/EtZW++5oXE0UpUJuHr4vGmjWcvNcfmiwDg==
X-Received: by 2002:a05:6000:11c5:: with SMTP id i5mr44019145wrx.102.1577358855077;
        Thu, 26 Dec 2019 03:14:15 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u8sm7957966wmm.15.2019.12.26.03.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 03:14:14 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 09/10] mpt3sas: Remove usage of device_busy counter
Date:   Thu, 26 Dec 2019 06:13:32 -0500
Message-Id: <20191226111333.26131-10-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
References: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove usage of device_busy counter from driver. Instead of
device_busy counter now driver uses 'nr_active' counter of
request_queue to get the number of inflight request for a
LUN.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index aa43c66..501e9ba 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3573,6 +3573,22 @@ _base_get_msix_index(struct MPT3SAS_ADAPTER *ioc,
 	return ioc->cpu_msix_table[raw_smp_processor_id()];
 }
 
+/**
+ * _base_sdev_nr_inflight_request -get number of inflight requests
+ *				   of a request queue.
+ * @q: request_queue object
+ *
+ * returns number of inflight request of a request queue.
+ */
+inline unsigned long
+_base_sdev_nr_inflight_request(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx = q->queue_hw_ctx[0];
+
+	return atomic_read(&hctx->nr_active);
+}
+
+
 /**
  * _base_get_high_iops_msix_index - get the msix index of
  *				high iops queues
@@ -3592,7 +3608,7 @@ _base_get_high_iops_msix_index(struct MPT3SAS_ADAPTER *ioc,
 	 * reply queues in terms of batch count 16 when outstanding
 	 * IOs on the target device is >=8.
 	 */
-	if (atomic_read(&scmd->device->device_busy) >
+	if (_base_sdev_nr_inflight_request(scmd->device->request_queue) >
 	    MPT3SAS_DEVICE_HIGH_IOPS_DEPTH)
 		return base_mod64((
 		    atomic64_add_return(1, &ioc->high_iops_outstanding) /
-- 
2.18.1

