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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E40C2BB40
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C14322C7D
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501939AbgLNQQQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501923AbgLNQQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 11:16:15 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AA0C06179C;
        Mon, 14 Dec 2020 08:15:34 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id 6so8648514ejz.5;
        Mon, 14 Dec 2020 08:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nStPlk3v0MLXP7RXdY6QnLtmvCeBKrxs5Fg0Su+wWr8=;
        b=og6fUfQdjW7/vaDvM6r6VP7xzv8RKZrQibdHu19xs3+sBG1BR6jbXeWHMhGgrQf2kU
         WBxUEAdPLT3xBhTpmKALhdL/cGyGYDRbkjRckW3iDZokvugXJHPZVLUshcoZ1c1cobiW
         1dlagH4+IUtVGG7XMy4RCV/SuvalqAt7+kutra03AZBaOMgGHFTITfLZ98A8WhVnekLd
         4OATW5T0TrUNjb06lhrGEgy9urKcwjn3Ag5lqtc+8+k2DaNxTAdr0B+ocAoL/D82+V8p
         W6GeADaLcZFU9kEYWQviOh4HExwchH9WAu1m3wWZGcDXTuFowk403AEMNo9gsUiWVDJM
         xOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nStPlk3v0MLXP7RXdY6QnLtmvCeBKrxs5Fg0Su+wWr8=;
        b=Fgb4dJlriNIh649ckJo6Tr4NPFkkjfStrbuzxuTTZwoz9+BrbZUSOP92w2/DODKj7t
         tASMat9NtpsF7MHUfGISPqDgSLeL/ZZxdvlx14zZ0nce3ReS4YLOMHkmONPjN0JMlrwI
         pXglhPfFzzLmUTU5tz59S+QoGuM5/UtQoK4ffdWxgytA93rKeab2Ho/k8ZWC9PAzUVV5
         Rnki3mgSyS7WJl6itugsohukxkOt35la9ebJA5ttaWAvNmpVbI24f1OVtTC6Ii560mID
         BK3lZKj5yQu+7kXpJZ8of1XBQF4NQ5w6HK4bGibrM2vb7IpanjDauiQ/syDJpFDldC1h
         BYwA==
X-Gm-Message-State: AOAM5339qjf0UdtkM2dWJSKOIj2eUtD4TLcZGcLoCQWTgBgZHrbdrzuY
        Ko82thkuPNBziLQ+FaA3Krs=
X-Google-Smtp-Source: ABdhPJy2qsoNAxZBn1e8WNBFJ+0FgvmsF4RqfeOxY0JuuM9/y3JENqG+VI1LL2+70aARNUk/ATHnNw==
X-Received: by 2002:a17:906:edca:: with SMTP id sb10mr23067325ejb.284.1607962533674;
        Mon, 14 Dec 2020 08:15:33 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id i13sm6646056edu.22.2020.12.14.08.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 08:15:32 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] scsi: ufs: Distinguish between query REQ and query RSP in query trace
Date:   Mon, 14 Dec 2020 17:15:00 +0100
Message-Id: <20201214161502.13440-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214161502.13440-1-huobean@gmail.com>
References: <20201214161502.13440-1-huobean@gmail.com>
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
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index da677147755d..93d820b69617 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -321,12 +321,18 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
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

