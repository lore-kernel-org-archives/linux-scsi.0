Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D157C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E3036112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242897AbhHETTo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:44 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:51137 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242929AbhHETTj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:39 -0400
Received: by mail-pj1-f53.google.com with SMTP id l19so11381284pjz.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KAGONwU2Ix3aXwytjxc1FfNzoxkRboKLNCgioIOWq0o=;
        b=fvHkCOyoMArhOXMnf8y1GlYUFsh0gq4Tqzo+7M+eqcq4iqQ/1jU9RLCg/A46eK3NWZ
         qKB1mIjg0hTFix8w8wHtMRURQumBIosnJP898tQFqMIh7C41QeCepft8e3jvvQFm5yqG
         tqR0LUR9l5ATS0fDiFSxRSVVVVTbSrcZYrv5NWKDrmveeakGF+x9O0V82z0cxQ3LJMP4
         F4gb9uuSCU6UOEXVSS5h6Q6McflLVt4KKtiibvA7KSLwDbdx0ulX6pDsAovWV0blrkoh
         tfLAIX2nISIWX7+qKmfZ9vyTloxBPtSx0EUxY7OEMd4pdz5l4sI/wjzIWMW+AUwwbxx2
         l6HA==
X-Gm-Message-State: AOAM530VDN7B8ZV8nvUNg2JdZZUee0aQVM9+80hGomezmtAjiuS+TaFt
        n5RknLtT8On1kY6Ctr3UwO8=
X-Google-Smtp-Source: ABdhPJxOIBClH4bz/+UUrvubrUG8EHrh0jdGOhTzf0np6vjS0OHtS0d9vkKPKS9Mxcwufjh0c8PllA==
X-Received: by 2002:a17:90b:1018:: with SMTP id gm24mr6370281pjb.86.1628191163861;
        Thu, 05 Aug 2021 12:19:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 25/52] ips: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:01 -0700
Message-Id: <20210805191828.3559897-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 8b33c9871484..cdd94fb2aab7 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3735,7 +3735,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 		scb->cmd.dcdb.segment_4G = 0;
 		scb->cmd.dcdb.enhanced_sg = 0;
 
-		TimeOut = scb->scsi_cmd->request->timeout;
+		TimeOut = scsi_cmd_to_rq(scb->scsi_cmd)->timeout;
 
 		if (ha->subsys->param[4] & 0x00100000) {	/* If NEW Tape DCDB is Supported */
 			if (!scb->sg_len) {
