Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A48CC77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 19:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjERTcI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 15:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjERTcH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 15:32:07 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB13B5
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 12:32:06 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-643465067d1so1923127b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 12:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684438326; x=1687030326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E4BivBkDVwb9wkvJmHlC3sRkvVJuZrmosM6xqXvfVxc=;
        b=lobsCq1nQ6o/lRsZm3yjwwYn1XhRuJkFgoqDmGjBjLtnEPjij86QM3kAqpMYjYJDHR
         m3XOLR/Hqc54kmj7GOWSOhs8gFEAWvpCk0HZGqlV0dzERHeQ4Zcteo8wAHbLIWoQdz2e
         kJNzZThKIt902c340RcEpdKTk1IxFFsB6R2wmZGfbYz3pS6wBrlv0ztFTIT5xRVouzmy
         Md9XwEOSNs3hK52EcDmwqjOxWY79Oj3KZqsLpcjzNSOsucOO1G8GF72COsNPGp5XC6sx
         osc2BPfI/oRNzasltmdRxVseTjUawFr6QSrd3sGZQ/f7QWWgLipvoblIW2EoEU5Ddus6
         LtFg==
X-Gm-Message-State: AC+VfDzOwLfspmoEoG1R/kjLFTc0bDX3FUox1GnsAbm4uizcrUnRskvA
        DGP2aiDDHAC282ioAcKDibY=
X-Google-Smtp-Source: ACHHUZ4iW3Dx0wm4G+kXRYcb0qLz+w9cJ0JfeprKV+HaB5Qy7HNBeYMENPDZlk4HzlH2QJFDXm4sHg==
X-Received: by 2002:a05:6a20:244d:b0:ff:a017:2b07 with SMTP id t13-20020a056a20244d00b000ffa0172b07mr1032299pzc.20.1684438325440;
        Thu, 18 May 2023 12:32:05 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 11-20020a63050b000000b0051afa49e07asm1619047pgf.50.2023.05.18.12.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 12:32:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v4 1/3] scsi: core: Use min() instead of open-coding it
Date:   Thu, 18 May 2023 12:31:57 -0700
Message-ID: <20230518193159.1166304-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230518193159.1166304-1-bvanassche@acm.org>
References: <20230518193159.1166304-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use min() instead of open-coding it in scsi_normalize_sense().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 6e50e81a8216..24dec80a6253 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -176,8 +176,7 @@ bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		if (sb_len > 2)
 			sshdr->sense_key = (sense_buffer[2] & 0xf);
 		if (sb_len > 7) {
-			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
-					 sb_len : (sense_buffer[7] + 8);
+			sb_len = min(sb_len, sense_buffer[7] + 8);
 			if (sb_len > 12)
 				sshdr->asc = sense_buffer[12];
 			if (sb_len > 13)
