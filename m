Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33470C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0BE921D42
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503061AbgLNUVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502992AbgLNUVL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 15:21:11 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162A8C06179C;
        Mon, 14 Dec 2020 12:20:31 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id j22so6381051eja.13;
        Mon, 14 Dec 2020 12:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MDUTAHSnLQf17rDCvTDFruIhmvOHEpBhNEFUu+lMa4s=;
        b=kRJ91+DDQZ6kWB3QxvEUPEZD5Jgt7e+I7J3Fuy0W1o1pkPn/wieQhypllwEy5uvLeX
         +00+JRQlpYrfQLc1u8unP4KOiReU3Mn1ixKZCqM4brGeXCeymXwkkA5BJ7CBvA+/1Oe5
         nc8Qoz+/Gh2MZcuNHU0wrZkzQcK5u306OpEUh/vSwOkv1hDikbEBuusH2Z9YGhrrZylu
         nmYaJS11hj6mgvKqRwzyq6jcWFCSH+APaGnJ8ABJcrz5tamPtoA7J5Y4UnxIIKQSdj3M
         +NirRgndyDmMqFDdmUa09SVYemV0gkXUpbjUJ5fux5EA894kF4MuSx+sMCWNDHBfidFb
         Qkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MDUTAHSnLQf17rDCvTDFruIhmvOHEpBhNEFUu+lMa4s=;
        b=DPWgwjQ501qAWPJWuiAzaU0JlxaPuLIQVUQS5qcy44XufPZTSBMZTuM0a07WkJj1B/
         Z7KQOreexFEL3szGY7C1xBQsYqXSvWPUYEpTCXI98CHqK7mSSFsnTGfz1OrQNdy+2k1L
         8DT7RXeuBI3RfP8JZrA1AIiCWqgqK+zCSl4EJiSrrGN63CE6Gyeh29uJrM+srIIOjD5q
         8dBUnfhJylF6EQDqE6rQ1AaCpEbEZYfdf8inpfW2cLsyx1tw5PYndn9Z3fdIhPjB+gBT
         g7DetnuD/ve2h2XOP8of+DbJgLIvtrfxZRV+0jrCQy8U0O4gmHW1B646fJPvvpl570UM
         megw==
X-Gm-Message-State: AOAM533L+0tWV4SipbCgnvAvtI9XLs0Ogh3xWIGZmuzW59gzNUGCm7Jg
        t5xJ25LPbulOLo8UP7khMkU=
X-Google-Smtp-Source: ABdhPJxBf0Qqfsbbaqfe50wiiKREJ1hGKmNxQBkp1lnOon//BtJGgCIbOi1u52Kvi7keooyu1lJxtw==
X-Received: by 2002:a17:907:961b:: with SMTP id gb27mr23634089ejc.313.1607977229777;
        Mon, 14 Dec 2020 12:20:29 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id r7sm9334634edh.86.2020.12.14.12.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:20:29 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org, joe@perches.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] scsi: ufs: Distinguish between query REQ and query RSP in query trace
Date:   Mon, 14 Dec 2020 21:20:12 +0100
Message-Id: <20201214202014.13835-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214202014.13835-1-huobean@gmail.com>
References: <20201214202014.13835-1-huobean@gmail.com>
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

Acked-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f4a071d12542..d0b054aa0a3c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -318,12 +318,18 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 					enum ufs_trace_str_t str_t)
 {
-	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
+	struct utp_upiu_req *rq_rsp;
 
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->qr);
+	if (str_t == UFS_QUERY_SEND)
+		rq_rsp = hba->lrb[tag].ucd_req_ptr;
+	else
+		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;
+
+	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq_rsp->header,
+			  &rq_rsp->qr);
 }
 
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
-- 
2.17.1

