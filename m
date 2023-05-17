Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2599C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 23:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjEQXJ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 19:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjEQXJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 19:09:50 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8842D76
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:09:35 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-644d9bf05b7so1079101b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684364974; x=1686956974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E4BivBkDVwb9wkvJmHlC3sRkvVJuZrmosM6xqXvfVxc=;
        b=GZk/GQDVLGs+nYZ2dJ9x/kyptDLIEsbc3nWwKDj2zxO7HlxunDR7dW4+oZaYL0ohQz
         6Nc+rTxochZCm7kNoKVuPeWfaH7W3IpfFT//PFw5H9Ae/d4EoD0m95744C3WdpUTgRBp
         gggiQFLCXwufLsMeEjPhZTNMr1qoY0ihE5yne56qCoO5+sJHB9LUsiwHfRSiYWZPE5Ng
         ksdEGz8C1AYrp3VgPac7e59yHRCcpqgmTMbIW4R6JbOn5BT54Pt7EBPppFqWA8T9Q9/P
         2qh2l/w984Qog9Q/WM9SaJ5HG2T+4v6N8Mni6okUeIGIvfV6NeWjWOk+bvNcHW2DqpW7
         FCFg==
X-Gm-Message-State: AC+VfDzB70OePrsNYaeQiH9LoPjmGJRA/NXG9Mzqt1YOvjPv6XNo1uRp
        k3zl1EghuZD49qZ5d6RlfW8=
X-Google-Smtp-Source: ACHHUZ5IvUqr1s95aU0u8T0C6YWsD4MaHnj40g2TZC9Eax3Xm4GCkTiDNDbkw61+9swwUmNbz/7XVA==
X-Received: by 2002:a05:6a20:3d87:b0:101:e680:d423 with SMTP id s7-20020a056a203d8700b00101e680d423mr35758258pzi.28.1684364974389;
        Wed, 17 May 2023 16:09:34 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e9-20020a656789000000b005286ea6190esm15080694pgr.20.2023.05.17.16.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 16:09:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v3 1/4] scsi: core: Use min() instead of open-coding it
Date:   Wed, 17 May 2023 16:09:24 -0700
Message-ID: <20230517230927.1091124-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517230927.1091124-1-bvanassche@acm.org>
References: <20230517230927.1091124-1-bvanassche@acm.org>
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
