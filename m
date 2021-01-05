Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E36C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7682B229C5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbhAELfq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 06:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbhAELfo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 06:35:44 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EE7C061796;
        Tue,  5 Jan 2021 03:35:04 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ga15so8650442ejb.4;
        Tue, 05 Jan 2021 03:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2fE5gjdfDYz+cs7WJAZqEqoBwsXtjXynZxFXiEOBQng=;
        b=exdrjUl0WM65EzuVv/t2rU5KmqYkvDOTvkMiTexDDsn3gp8jvS5EaXs8S3hGyJydXm
         MVVZfsjq8aHW+uqbcKclVrkDwpvR41o5YwDYmLLcVY0XCBXIA+7iuCzwHsxG4h6lhG5X
         iiaNuL6ml1/XXMywJn8p4Rpmy7qh34w1E6qYFVtQU+MqmlghfAwIVBy7EB/VKojii6/R
         EcDF72U7BobPLY9BEUh9M44TT7uueo3CFACpfJgXOPq9YQAbMnJHjTbb8PgRrrLc+e3F
         Gah4Yx2MlFCNOtM0NTfmoArgu7gqfbVxDIqp70la9GC4b3TqhVhB1dZ68BZ9FV0oDW5q
         dKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2fE5gjdfDYz+cs7WJAZqEqoBwsXtjXynZxFXiEOBQng=;
        b=h478h39zHM5JxasR77shxUD58yqFxcDDItJarYm30qqrMA8MroqVUN6L76JgBh5r4s
         Faf/EVmCURZD7zC/wZ1e2+MnrjyofIZ1nePelWbva4/xlcxJZMyWnlytvlp9eRkU3lhZ
         Y8g6pPikZVpoIcYI5pUW3E4VzqMwek9riYMHmQq623yUxSUvHpS51O5fD4vAy415iXr5
         +9Nw3/6E5Qk88uMorlbr5rk9+ye7SHSk6P1fd934WIPWBuvzkguzUe4Uqcn1dwywWCEn
         qEctRJjVZgWXsnkNbxDQ6sphFxJQeWDgklzj1AWRREezm9gym+vdk9TrspbqAQt5GFzL
         qmGw==
X-Gm-Message-State: AOAM533eIIAHHVgODSBsyYxgnpzKCdbfw7JwpXIbAvpaIm8wisDK4ATW
        Hlb9+nJPow7y3oVucvgVb8E=
X-Google-Smtp-Source: ABdhPJy1RBIiLMoZcm/0izxiU+gmY0ptp5pk6IQ7EIzOjuRK1Mf3FZjfmpPmusNI0yCR4VOJRi2nhQ==
X-Received: by 2002:a17:907:271c:: with SMTP id w28mr70379279ejk.140.1609846503004;
        Tue, 05 Jan 2021 03:35:03 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id n17sm24640772ejh.49.2021.01.05.03.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 03:35:02 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/6] scsi: ufs: Distinguish between query REQ and query RSP in query trace
Date:   Tue,  5 Jan 2021 12:34:44 +0100
Message-Id: <20210105113446.16027-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105113446.16027-1-huobean@gmail.com>
References: <20210105113446.16027-1-huobean@gmail.com>
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
index 9c8fc46183c4..6ccf71ab3b9c 100644
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

