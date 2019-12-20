Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D74AC2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2B4624679
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PVdcKQWu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfLTKcx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 05:32:53 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38554 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfLTKcw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 05:32:52 -0500
Received: by mail-pg1-f194.google.com with SMTP id a33so4732337pgm.5
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 02:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PwKBr6f/K9e61XRoUk2UfrIS6i6mMZyzMcHouQjQAWM=;
        b=PVdcKQWuM4ijNcEYj+ShrVa02Aju07J++BpjQW+t8jhbLX9rXQ8Fr7gky8lDkhB3Tc
         kEVpj2eRXt72CwGsZ1aqdmwUyhDirxipy6rp/u/l9pqRO5LC+8xfnX/i7+FWLMWDwQnp
         3PZOTYGWALXX+7HT5J4b11X1YaoTw4yL21zbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PwKBr6f/K9e61XRoUk2UfrIS6i6mMZyzMcHouQjQAWM=;
        b=B1SAE5Ha9nVNrjmxBH+Fd0MiK8szEpIVmy8bxJVGSX10isNQJZDqhefY/1aXC7u+wZ
         YFFJBgArn6ytUP147neHP+WQe0sbXRjZ7YJKTm8g2aX++KFpD8rAyZ3FTAz3g5QPPvTT
         Ka9P9KfYBDzoPxWvQn7hrWUnQJTHhwogx6+HATe9MKwyhbVAhki43Y4qz82oa9oaw2ph
         1HA2pIecrYLPMvBehsQSiHKTYMyBm08u2wdvo24X3dV/9dNRCcRDJNZWO7WIZS9CBdF5
         NoVaOhOnBMR/h26E91wQMaCvMqazuADkip4nI3+Hbpkd7Fo3JF+7L1+TZg7zjcRxxOjs
         A1Zg==
X-Gm-Message-State: APjAAAWnkxOOwXzG5hXWYsYlTDUk7LDXl//Cxq/6DO48BFa2yt5zP8oT
        9yUOaG0BkPrQNliB5+9e2+MkpZ2QgDtQJfxhIDeU0FwitoHAPVFmU6l35Is6togvC6jKUUcM1XF
        l4n//yhdd61XwYCHNhZxQ7lBdDCj//t8bG+x7K0m8fKqHytRjpzApsONo4uN177KNBLbioIoeCA
        bJLNGI7pB+IGmdXiyUVQ==
X-Google-Smtp-Source: APXvYqzNT9+JiK8jvKKPa3Nkro8hnfjMywTLJfbv9Swf5Fi3J/pNcIOByw1YyY8bvFs9dsjeFwsbYw==
X-Received: by 2002:a63:1f5c:: with SMTP id q28mr13240661pgm.404.1576837971212;
        Fri, 20 Dec 2019 02:32:51 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 200sm12185364pfz.121.2019.12.20.02.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:32:50 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 09/10] mpt3sas: Remove usage of device_busy counter
Date:   Fri, 20 Dec 2019 05:32:09 -0500
Message-Id: <20191220103210.43631-10-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
References: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove usage of device_busy counter from driver. Instead of
device_busy counter now driver uses 'nr_active' counter of
request_queue to get the number of inflight request for a
LUN.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
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

