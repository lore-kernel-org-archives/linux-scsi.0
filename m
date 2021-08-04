Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D637C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 13:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 313BF60F6F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 13:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbhHDNOA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 09:14:00 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:52892
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233389AbhHDNOA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 09:14:00 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 5D6A63F345;
        Wed,  4 Aug 2021 13:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628082826;
        bh=GU76vS3zmj8v0SxHCXRV3HKNjBU0sXuJiHmGfPWWMSI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=DF1/CnOs6uTSot8vdmfpt/+fVTAF4bkx9It3A2AwTahqesisySR3rA2bPifAjb9GC
         c3uAntwWi07cR2yqAr4hocgBzJ27yrBKX1pzAb0V0zDVlQOs2bGpB/Jt8SV8FpaAW/
         wGTYlp0KorupKXCXV7ypOhHwMhxvZhSBce6R9Fexb9pBfUqPSqvzf7jHK164iWEf0j
         Vv2o5p9Ya6bzaAxhU0uMriiYMSds8moY7szI9cvYhX/YcfA0cEQ8RBG3P7ygoqW1Zp
         0KOgfnJYiBH4w4Z/zrCeYH+BK/HzUNvFjuA/uGn6A4qM4gO4+tr8fs5h4/eIQ7t2/y
         yY2OppcnBbj2w==
From:   Colin King <colin.king@canonical.com>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next[next]] scsi: qla2xxx: Remove redundant initialization of variable num_cnt
Date:   Wed,  4 Aug 2021 14:13:44 +0100
Message-Id: <20210804131344.112635-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable num_cnt is being initialized with a value that is never
read, it is being updated later on. The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index fde410989c03..2db954a7aaf1 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -875,7 +875,7 @@ static int
 qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 {
 	int32_t			rval = 0;
-	int32_t			num_cnt = 1;
+	int32_t			num_cnt;
 	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
 	struct app_pinfo_req	app_req;
 	struct app_pinfo_reply	*app_reply;
-- 
2.31.1

