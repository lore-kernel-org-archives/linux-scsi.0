Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCCDCA9EAE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 23:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC24320862
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 23:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfJ2XHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:07:21 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35978 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJ2XHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 19:07:21 -0400
Received: by mail-pg1-f195.google.com with SMTP id j22so142658pgh.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2019 16:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LnV0hNXe1rBYMW94ufpo75neVX/K7K//wWXTb9puerY=;
        b=JDyFs5LE2IfDZ0kzq5y+Tx2iS4E4mQibsmn6S0gY05E6RO3339Cp/9eXuHgEP8XJwI
         lL/OvC3ar4b+jXBfjofZEgzeKVfOwxoHq5oBipwvHTnw20cshdS2w+BQnqCJmChxPbMS
         qVucLhrg5GDoIkM8ULg9nUB694YaMQjMnAGswXlWtEPJa8wjwLOdWG3dNNkUGgGuuYN8
         lUG+PB1fCI3AC/OnbFWVyR2bzbuTRV5IR4zzKW3sh1ByOy2N0BU0JTfJ9TBZjfScmWkB
         C/Pc237G0pqLJiuliKzy65bvg5anjdmr1gLRrJcTdgOO9PRUXwOMzfJAQbp32ZLC1w6Z
         gRdw==
X-Gm-Message-State: APjAAAUgpaOiENrRz7reIa8QSdytj4gRAfULpw2G+tlNAFznNkiQykae
        /GpvrLD3Wa2QWEOgfSBpp80=
X-Google-Smtp-Source: APXvYqxjzVbGtw0xikV1UhYW1oqZ5MM90Pf2PI+CUdchc+GSuv7vPZ4GWcjLwGz1i/5X6N3yCQo6vA==
X-Received: by 2002:a17:90a:730a:: with SMTP id m10mr10014872pjk.78.1572390439514;
        Tue, 29 Oct 2019 16:07:19 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z21sm170500pfa.119.2019.10.29.16.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 16:07:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/3] ufs: Use enum dev_cmd_type where appropriate
Date:   Tue, 29 Oct 2019 16:07:09 -0700
Message-Id: <20191029230710.211926-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191029230710.211926-1-bvanassche@acm.org>
References: <20191029230710.211926-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Declare all variables that hold dev_cmd_type values as an enum instead of
as an int.

Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7ced77c8cc4d..180033b4b515 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5784,7 +5784,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					struct utp_upiu_req *req_upiu,
 					struct utp_upiu_req *rsp_upiu,
 					u8 *desc_buff, int *buff_len,
-					int cmd_type,
+					enum dev_cmd_type cmd_type,
 					enum query_opcode desc_op)
 {
 	struct ufshcd_lrb *lrbp;
@@ -5899,7 +5899,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     enum query_opcode desc_op)
 {
 	int err;
-	int cmd_type = DEV_CMD_TYPE_QUERY;
+	enum dev_cmd_type cmd_type = DEV_CMD_TYPE_QUERY;
 	struct utp_task_req_desc treq = { { 0 }, };
 	int ocs_value;
 	u8 tm_f = be32_to_cpu(req_upiu->header.dword_1) >> 16 & MASK_TM_FUNC;
-- 
2.24.0.rc0.303.g954a862665-goog

