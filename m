Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049ABC4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 14:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99F542085B
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 14:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DPEHuD+w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgJEOqU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 10:46:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726848AbgJEOqT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 10:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601909178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=ptyKuh8WxjRCHezLemPMrH21hGCsiTIELZD7s9BSjQE=;
        b=DPEHuD+womOA2lb1nwiAWYUp/aOvKZI7+QWIeQ8GJ107XzXcb2UJd9zmErhMapak6uSZ1R
        wmTHdt5ZdqXZTmlcwQ9oVB4eWFGSHto5fNSYW9Z/sb0Krjt8NCPB0xbkQIvVqDc51QHmt3
        8tAiaUte4s1Pvag06iBiMAY1on2B+M4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-keanUG4kNoeZxecFTZheWg-1; Mon, 05 Oct 2020 10:46:17 -0400
X-MC-Unique: keanUG4kNoeZxecFTZheWg-1
Received: by mail-qt1-f197.google.com with SMTP id 7so6604477qtp.18
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2020 07:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ptyKuh8WxjRCHezLemPMrH21hGCsiTIELZD7s9BSjQE=;
        b=mElLmfcA/YVO9oVgih69UOnh032jZKdbhauRtmSUP7pHZiLEBC/nSDD2kAc/c2LhRT
         z9C3Ojv4nXbMc5ijHl2cxQUE3PjyMpcesUr7Q/qAhzIYRx+Y6+Fnl3BqwwZKeHOhtoNh
         IbEoBkzmE3vkRCStl2/y+5LPLMqevJag/qjZzpaOJVjfO9Sh5Q013WV2wVlcnCuUEINk
         +6qy1pXH8WRh+Lg3Om4NL6UAjofKldMLu5w7+1hK3YL1yPOLFZTp9RgnL3vsrnoyrjHu
         4kYCgZosCDMkgnjGo/6EI2rkWyVSZ6AFqSmtoqouK1w2m6K/23NGDlHaFTxMgXxuIFuh
         U3AQ==
X-Gm-Message-State: AOAM530KHPa26zI8OtavPQmgY/JU/TfeW2F2COSrebBH3taijGTgKboF
        noMkxZRaH/NCc8d/b5fWowQhrfohPnktXwSKV4+nYwj8n7YGHGCt9a9xYYelvB4XByPQ3Qek5C6
        owG2ouCI742cQ/Y0+35W3Mw==
X-Received: by 2002:a37:62d6:: with SMTP id w205mr289255qkb.229.1601909176266;
        Mon, 05 Oct 2020 07:46:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRfTKS3+jTPIJZ4QlireY6tUWjq/ctyLnV1eg1G0RryjdqD9T03AY8QFV8BktptD3/3u4pFw==
X-Received: by 2002:a37:62d6:: with SMTP id w205mr289222qkb.229.1601909175969;
        Mon, 05 Oct 2020 07:46:15 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id i90sm303450qtd.92.2020.10.05.07.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 07:46:15 -0700 (PDT)
From:   trix@redhat.com
To:     njavali@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, natechancellor@gmail.com,
        ndesaulniers@google.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: qla2xxx: initialize value
Date:   Mon,  5 Oct 2020 07:45:44 -0700
Message-Id: <20201005144544.25335-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis reports this problem:

qla_nx2.c:694:3: warning: 6th function call argument is
  an uninitialized value
        ql_log(ql_log_fatal, vha, 0xb090,
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In qla8044_poll_reg(), when reading the reg fails, the
error is reported by reusing the timeout error reporter.
Because the value is unset, a garbage value will be
reported.  So initialize the value.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 3a415b12dcec..01ccd4526707 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -659,7 +659,7 @@ static int
 qla8044_poll_reg(struct scsi_qla_host *vha, uint32_t addr,
 	int duration, uint32_t test_mask, uint32_t test_result)
 {
-	uint32_t value;
+	uint32_t value = 0;
 	int timeout_error;
 	uint8_t retries;
 	int ret_val = QLA_SUCCESS;
-- 
2.18.1

