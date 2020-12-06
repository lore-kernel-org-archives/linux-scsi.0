Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A96C1B0E3
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 16:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE1EC2310E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 16:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgLFQnZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 11:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgLFQnY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 11:43:24 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BA5C0613D1;
        Sun,  6 Dec 2020 08:42:44 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id c7so11125702edv.6;
        Sun, 06 Dec 2020 08:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fv94yoCjxFMyCGDFrOP0JP4fAzP6SX6Q5aROorrzmI4=;
        b=GQgG2/43YsN3y3crytPcgsnYCX4/d6xwY86yz7zklXbRfqRRFlsf6E/5n2jySE/0Rb
         ME1SyFzkn+KOT1nsGKiEXLso20VMUf7m3ZfzXC2OfKuB5f5Hrs5qXAP6E2Y/g4Hlm59e
         DdIGzM4wLLU5uhwpI3UQgyKFGVFZIHH/HoLKY0Btlrodimkw5Exrqgl/pxyMigv8QY5o
         RypZBlJDHWOd7D3TtfZzCmK8R1vNF2Sic1eh/pDxBM6fVGn4SEPNmewTWGFSi3AZem/f
         CYMhOb0BDOqrsSqvUYAUhQQfQ3vHGEtUttTtnwmmVBEXLRFpowgXZrHQPlVr5n17+Epg
         l0+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fv94yoCjxFMyCGDFrOP0JP4fAzP6SX6Q5aROorrzmI4=;
        b=nMxej7lu7QRQI3JJfFgD3TbzOtZXNXaaHlpw10FI+2zEO/mrZKf98sC+AonWnvguQw
         WTaReGVSjJKi9B9GLwnWf3P5RG6LPwUCClbw0db4x6Rn95PivybxSX0VjzC+Njsuw1HH
         X7+QHiLdiachA/Q/EdI7irnQnq9kvey17sguhbPbDPV0iGQlwvMhXVrRPt9/5wt2bQKd
         kcTrURfGK23dkYdZwHFlErmshrbbXdC1fZVaLoWf8DafrUu0KrIPd/jtpkQeC6hsgefS
         D19ubBeKeaIqwFtvc4ntrl/+5MFyykyOBA5ag3PE08zOaL62u64u/pmg3dS7sxTpo/Ay
         Cl0Q==
X-Gm-Message-State: AOAM5309cGS1EsM5whlifCKaXYhtHc6uM/UpUglevOwwoIz/FZdyXRZd
        OJ9m5R4ZbHJQ6Yr3xXCkBSg=
X-Google-Smtp-Source: ABdhPJzQfLNqPOIJZOFJ1eClTxLxyhskNyUmskXv+EavJq+/Glb+Sbq9wQ6DquW+e6ZZOVCq/B09Ig==
X-Received: by 2002:a50:fd88:: with SMTP id o8mr16699498edt.386.1607272962793;
        Sun, 06 Dec 2020 08:42:42 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e19sm9157524edr.61.2020.12.06.08.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 08:42:42 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: [PATCH v1 1/3] scsi: ufs: Distinguish between query REQ and query RSP in query trace
Date:   Sun,  6 Dec 2020 17:42:24 +0100
Message-Id: <20201206164226.6595-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201206164226.6595-1-huobean@gmail.com>
References: <20201206164226.6595-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Currently, in the query completion trace print,  since we use
hba->lrb[tag].ucd_req_ptr and didn't differentiate UPIU between
request and response, thus header and transaction-specific field
in UPIU printed by query trace are identical. This is not very
practical. As below:

query_send: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 00 00 00 00 00
query_complete: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 00 00 00 00 00

For the failure analysis, we want to understand the real response
reported by the UFS device, however, the current query trace tells
us nothing. After this patch, the query trace on the query_send, and
the above a pair of query_send and query_complete will be:

query_send: HDR:16 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 00 00 00 00 00
ufshcd_upiu: HDR:36 00 00 0e 00 81 00 00 00 00 00 00, CDB:06 0e 03 00 00 00 00 00 00 00 00 01 00 00 00 00

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ceb562accc39..e10de94adb3f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -321,9 +321,15 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		const char *str)
 {
-	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
+	struct utp_upiu_req *rq_rsp;
+
+	if (!strcmp("query_send", str))
+		rq_rsp = hba->lrb[tag].ucd_req_ptr;
+	else
+		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->qr);
+	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq_rsp->header,
+			  &rq_rsp->qr);
 }
 
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
-- 
2.17.1

