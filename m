Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B44EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 19:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjG0TrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjG0TrE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 15:47:04 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732BD2D75
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:47:03 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-686fc0d3c92so641340b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:47:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690487223; x=1691092023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wOov0520Tsvv1mNyYNP1GOHpEOTOTwae66oDFZbDj3U=;
        b=HEomEZ+tuL7IlruMNW1zbyc7vEJujWOzoW2TUbFb+2GoohR1E2mlbKFM4lKrJKgiXC
         yECzEC/pYMX3SP+caBcKej7jmqvHGw7FzZYkW8XeiJ9iIYCMahvtLxqK60bdHy8wA3rW
         vc1yyVto4DmkaopchiS7F3fRY3PIOrowjnj9XaM3EUrYc7NGKulEgaQe+jRMAHIBOpdM
         cqp3MFmLbiXdy8xVmgQGuNZWaS1ADwEFeqftZ7rIxTlVV9ace7o4H5dRhZfj4bERgHIK
         QaNrvF57QKJwmItCe1ewtTlrQ9RRTu7Zs8SazJ80ZFp1cdhWCupyYORHRcoTn7VDfoLH
         raAA==
X-Gm-Message-State: ABy/qLavAwGNUdSoNwEovaX+yoN7cBQmfnLiBgc2qKTT8vriPneL7Hs4
        CqdflAmaKazjD4bxmnGr/jYgHrnOBLM=
X-Google-Smtp-Source: APBJJlHteeQ1psri80jfxwJBaZTxVJCYZgi4/U6Dg0NpffAPLdn8TPeSMH+bAH7/VSfhHMjFXuuKaw==
X-Received: by 2002:a05:6a20:914d:b0:138:64c4:34b2 with SMTP id x13-20020a056a20914d00b0013864c434b2mr47343pzc.41.1690487222785;
        Thu, 27 Jul 2023 12:47:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:607:27ba:91cb:68ee])
        by smtp.gmail.com with ESMTPSA id 35-20020a630b23000000b00551df489590sm1879203pgl.12.2023.07.27.12.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 12:47:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v2 06/12] scsi: ufs: Simplify zero-initialization
Date:   Thu, 27 Jul 2023 12:41:18 -0700
Message-ID: <20230727194457.3152309-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org>
References: <20230727194457.3152309-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use { } instead of { { 0 }, } to zero-initialize data structures on the
stack. This patch fixes two W=2 warnings.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ca520f2b1820..5e248c60f887 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7040,7 +7040,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 		u8 tm_function, u8 *tm_response)
 {
-	struct utp_task_req_desc treq = { { 0 }, };
+	struct utp_task_req_desc treq = { };
 	enum utp_ocs ocs_value;
 	int err;
 
@@ -7205,7 +7205,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 {
 	int err;
 	enum dev_cmd_type cmd_type = DEV_CMD_TYPE_QUERY;
-	struct utp_task_req_desc treq = { { 0 }, };
+	struct utp_task_req_desc treq = { };
 	enum utp_ocs ocs_value;
 	u8 tm_f = be32_to_cpu(req_upiu->header.dword_1) >> 16 & MASK_TM_FUNC;
 
