Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E251C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ED2020792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jHqbXmHl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbgGUQmp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730761AbgGUQmn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:43 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90072C0619DA
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:43 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z15so21825649wrl.8
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qn9xXUDZHQaT9nTTtPEVxD+FwQe9TWDeZ0uqEDuohOE=;
        b=jHqbXmHlBY0jg9OxAkf7coZvBnjoJ5+HWr9UYOwlzfzO0uTspX5+fawbUnHCncpdu7
         jBFMI1g95ZmjbUWGtOxLrhp366xIam9TCuPFypC7HRKHeZhEFT4PQXbG9Q0vyUiNOBqH
         kAv0hTgxGhIWgaB+zGYul2Z9iQ4onTT1MBoOmL86DMWCjJKLPJ5C6xFcyLgB2o66jKpQ
         7jaPjWa9h+nS3cNcKEJZTx1+JtT8bofhNj6/BY194n3tRHCt5B+rjN7rPmoH/+nx2vGb
         JpOd6d8m2rVdZtKEkmvlNhhVXx7QtJPewW0xSUCXl6aLd1mDAVR+tSDrIQrc/Q7UkLbW
         iGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qn9xXUDZHQaT9nTTtPEVxD+FwQe9TWDeZ0uqEDuohOE=;
        b=EAN95JRTk1eIUmbR95pivSyNn7Gprxz3yI/LrREiJCKzD/w0mvjsZcuHC+1jj279Xx
         xDo5s8E7wEVIgj6bcMUh0pxfAeOxMs4Xn3JXu7+Mhjs84lMCcqEGbEDbwssr98x1M9kR
         2q8jVi7tdOhZVjfuu9/emkJMyL+ABj8Gj/SRtaYfTUNICYfQivaSc15WvHJrlJkzEdw7
         26ohrc72pomMKdHG0CVXy8lTLCSwOq/c+rrLjRcfaGeDaGCv2k2vhYW4fu4u4rWSJWr5
         Pz/eAKl4wopgieFiIS9Huu84HIazRZrWQqZYsKI2vHXtWONFaU4HBxqLFJsvbR6SLDkD
         ENBQ==
X-Gm-Message-State: AOAM533bpAQAz8m3Lhjb6FtOI69PygZS7coPrb1ExmgC8LzsDWL4ZjhP
        sYQNqEVpWVrSrlKOyIo4drYH8w==
X-Google-Smtp-Source: ABdhPJyVp/cegKtF3XzYY2EmcgU0BhxEKpDgMPPwWXIWeJmhctgaqJ+it0wmwgALENMsHqgVHORClQ==
X-Received: by 2002:adf:fa8b:: with SMTP id h11mr27362168wrr.391.1595349762321;
        Tue, 21 Jul 2020 09:42:42 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:41 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 32/40] scsi: qla4xxx: ql4_nx: Remove three set but unused variables
Date:   Tue, 21 Jul 2020 17:41:40 +0100
Message-Id: <20200721164148.2617584-33-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla4xxx/ql4_nx.c: In function ‘qla4_84xx_minidump_process_rddfe’:
 drivers/scsi/qla4xxx/ql4_nx.c:2648:23: warning: variable ‘data_size’ set but not used [-Wunused-but-set-variable]
 2648 | uint32_t poll, mask, data_size, modify_mask;
 | ^~~~~~~~~
 drivers/scsi/qla4xxx/ql4_nx.c: In function ‘qla4_84xx_minidump_process_rdmdio’:
 drivers/scsi/qla4xxx/ql4_nx.c:2745:11: warning: variable ‘poll’ set but not used [-Wunused-but-set-variable]
 2745 | uint32_t poll, mask;
 | ^~~~
 drivers/scsi/qla4xxx/ql4_nx.c: In function ‘qla4_84xx_minidump_process_pollwr’:
 drivers/scsi/qla4xxx/ql4_nx.c:2816:47: warning: variable ‘mask’ set but not used [-Wunused-but-set-variable]
 2816 | uint32_t addr1, addr2, value1, value2, poll, mask, r_value;
 | ^~~~

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 5a31877c9d04f..85666fb5471b1 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2645,7 +2645,7 @@ static uint32_t qla4_84xx_minidump_process_rddfe(struct scsi_qla_host *ha,
 	uint32_t addr1, addr2, value, data, temp, wrval;
 	uint8_t stride, stride2;
 	uint16_t count;
-	uint32_t poll, mask, data_size, modify_mask;
+	uint32_t poll, mask, modify_mask;
 	uint32_t wait_count = 0;
 	uint32_t *data_ptr = *d_ptr;
 	struct qla8044_minidump_entry_rddfe *rddfe;
@@ -2661,7 +2661,6 @@ static uint32_t qla4_84xx_minidump_process_rddfe(struct scsi_qla_host *ha,
 	poll = le32_to_cpu(rddfe->poll);
 	mask = le32_to_cpu(rddfe->mask);
 	modify_mask = le32_to_cpu(rddfe->modify_mask);
-	data_size = le32_to_cpu(rddfe->data_size);
 
 	addr2 = addr1 + stride;
 
@@ -2742,7 +2741,7 @@ static uint32_t qla4_84xx_minidump_process_rdmdio(struct scsi_qla_host *ha,
 	uint8_t stride1, stride2;
 	uint32_t addr3, addr4, addr5, addr6, addr7;
 	uint16_t count, loop_cnt;
-	uint32_t poll, mask;
+	uint32_t mask;
 	uint32_t *data_ptr = *d_ptr;
 	struct qla8044_minidump_entry_rdmdio *rdmdio;
 
@@ -2754,7 +2753,6 @@ static uint32_t qla4_84xx_minidump_process_rdmdio(struct scsi_qla_host *ha,
 	stride2 = le32_to_cpu(rdmdio->stride_2);
 	count = le32_to_cpu(rdmdio->count);
 
-	poll = le32_to_cpu(rdmdio->poll);
 	mask = le32_to_cpu(rdmdio->mask);
 	value2 = le32_to_cpu(rdmdio->value_2);
 
@@ -2813,7 +2811,7 @@ static uint32_t qla4_84xx_minidump_process_pollwr(struct scsi_qla_host *ha,
 				struct qla8xxx_minidump_entry_hdr *entry_hdr,
 				uint32_t **d_ptr)
 {
-	uint32_t addr1, addr2, value1, value2, poll, mask, r_value;
+	uint32_t addr1, addr2, value1, value2, poll, r_value;
 	struct qla8044_minidump_entry_pollwr *pollwr_hdr;
 	uint32_t wait_count = 0;
 	uint32_t rval = QLA_SUCCESS;
@@ -2825,7 +2823,6 @@ static uint32_t qla4_84xx_minidump_process_pollwr(struct scsi_qla_host *ha,
 	value2 = le32_to_cpu(pollwr_hdr->value_2);
 
 	poll = le32_to_cpu(pollwr_hdr->poll);
-	mask = le32_to_cpu(pollwr_hdr->mask);
 
 	while (wait_count < poll) {
 		ha->isp_ops->rd_reg_indirect(ha, addr1, &r_value);
-- 
2.25.1

