Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EC3C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJRUbV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJRUbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:31:03 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDBF6111C
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:31:01 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id l1-20020a17090a72c100b0020a6949a66aso15076525pjk.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KCBxIJDy1M1NB8ALCsP+HlE38wpb59qRTkU+ZySkMwU=;
        b=QJ61q0xQPmxfF5VtwSi7/utVAyEtwuaRYlKUa6WvwJXEMzWSYbjFZQjS0nM5J0QxOr
         yCXrcXuBVc12rk4e56TGECS02rBsZhHa4QPartFAbjZjkywFDa0Px7XA1SFqtP6IKCRx
         fgRGuyc5cnLRDRRduokaDkFRGlVxi/BkkcyJfV9S/Bopmar7c2bEWr+3OnByRd10RCc7
         SYUa4dQBoNQiQiR/t56jPSMNqofLcbAVu53GNgZT9W3qUetE9nsuofU081JpGVo1tOVN
         Vb7hOrUTgywgIXTte972ngSMKOWZ4JWTnuFY9zNCc1nCH1AalQtkIul3KeaVCjYkPW4y
         iVjA==
X-Gm-Message-State: ACrzQf0pChcXW/Et3Ed9a2Vtu4Ld2ZVOFIYC9a/RDjGmnyJIYYWBHxXo
        /PRlyUVaW+r7Vst/l81PYZw=
X-Google-Smtp-Source: AMsMyM7uCtRnfuIBZ66YhbMSuDemDNjSdGliZZKXdoF33uyYO11OUIvrJWghfsArUYZYhmybSaDWRQ==
X-Received: by 2002:a17:90b:2691:b0:20c:d655:c67d with SMTP id pl17-20020a17090b269100b0020cd655c67dmr41526772pjb.36.1666125061378;
        Tue, 18 Oct 2022 13:31:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:522b:67a3:58b:5d29])
        by smtp.gmail.com with ESMTPSA id h137-20020a62838f000000b005624ce0beb5sm9643677pfe.43.2022.10.18.13.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 13:31:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v4 07/10] scsi: ufs: Try harder to change the power mode
Date:   Tue, 18 Oct 2022 13:29:55 -0700
Message-Id: <20221018202958.1902564-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org>
References: <20221018202958.1902564-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of only retrying the START STOP UNIT command if a unit attention
is reported, repeat it if any SCSI error is reported by the device or if
the command timed out.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f83a0045a129..84ca17d29898 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8776,9 +8776,11 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	for (retries = 3; retries > 0; --retries) {
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 				   HZ, 0, 0, RQF_PM, NULL);
-		if (!scsi_status_is_check_condition(ret) ||
-				!scsi_sense_valid(&sshdr) ||
-				sshdr.sense_key != UNIT_ATTENTION)
+		/*
+		 * scsi_execute() only returns a negative value if the request
+		 * queue is dying.
+		 */
+		if (ret <= 0)
 			break;
 	}
 	if (ret) {
