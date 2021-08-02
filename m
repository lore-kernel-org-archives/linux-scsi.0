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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366F0C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 18:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1280C60EE3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 18:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhHBSIZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 14:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBSIY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 14:08:24 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8244BC06175F;
        Mon,  2 Aug 2021 11:08:13 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l18so22457435wrv.5;
        Mon, 02 Aug 2021 11:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D2tEo2auWlRQbPn2RDM9SgFOD2D6wuYg38MJpC/JqLs=;
        b=LIklMAl1SAtQKrTzKfjH7PBZsN64Txr+rI1UYmP44La1EG4ajOs9wGod3ZxB3masJZ
         R5eWktMc2OYxAnR227Rh5w7/ywudpY9t87l5REuU136qE2ogCZhEiYEIY/2dAKc7oQ+p
         FbS6aj9KhW34wPe8CfwvVd5gDAZr7adGYStQ20QjxQ/fpW7VJkYWhW1n1tWZ9E0a60Do
         r9V2hWzcwBLkjEPjnwWNh/dYdbz2vIPi7e6C2y8x8F1jDaJMKV9Y2i8Fhm3QHfuVMOOh
         jha/P4Z0JOC3E6hA+Eea54FFP3AWjDUwl7KyDdYK7pItXD9XnhyDdT6TgInEDZXNolfW
         p4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D2tEo2auWlRQbPn2RDM9SgFOD2D6wuYg38MJpC/JqLs=;
        b=loHNDzK0aMswltzuWZI6i9xkBMvzLBV64ymngk3Z6AW3SMq0x3TMco8RkJLpPn2OIh
         qaRmzwqs8KHThLFfuo6iyRedBWGYKwh1xxrGBqJ0NSA41HHgOO5ra36B2xaRp4XF1Vq7
         Qk1PduXbMW/bhiYW/4NZ5ohq3H2kMwbK5I3TKpfVe3XPG1r31TBhK/D4zbuuq4N1Gjuv
         oeceydynSl3boyLnHdssTAvN2lFS2El3VaplEKlzsJZWwNme64kHKJzRd2ebWO2XztIC
         YYfGC0kxOQcxexJpgCvXeWf8BTv5nRDvk/iIz4Ypq88JzoxDGWFv0aR02ZQ0XZClOF67
         alNQ==
X-Gm-Message-State: AOAM532FvMsRXqbRBHCG8kbtzHckHVXiLHnoxpj4ciu+jK+D79KOXMqH
        GSzaOcKB3ynQ1TflWQ07LLQ=
X-Google-Smtp-Source: ABdhPJwxvyHBQ/s2bgXb56U3I7egILgA4GF1CqH8mGEDeQW67z72cjn1pZYKndtvHLm6znTrP42G9g==
X-Received: by 2002:adf:82ae:: with SMTP id 43mr18840903wrc.73.1627927692206;
        Mon, 02 Aug 2021 11:08:12 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.gmail.com with ESMTPSA id w4sm54086wrm.24.2021.08.02.11.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:08:12 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: Remove useless if-state in ufshcd_add_command_trace
Date:   Mon,  2 Aug 2021 20:08:03 +0200
Message-Id: <20210802180803.100033-1-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

ufshcd_add_cmd_upiu_trace() will be called anyway, so move
if-state down, make code simpler.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 064a44e628d6..02f54153fd6d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -380,14 +380,11 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	if (!cmd)
 		return;
 
-	if (!trace_ufshcd_command_enabled()) {
-		/* trace UPIU W/O tracing command */
-		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
-		return;
-	}
-
 	/* trace UPIU also */
 	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+	if (!trace_ufshcd_command_enabled())
+		return;
+
 	opcode = cmd->cmnd[0];
 	lba = scsi_get_lba(cmd);
 
-- 
2.25.1

