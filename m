Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5238C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8702760E94
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbhJLXjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:35 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:46811 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbhJLXjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:33 -0400
Received: by mail-pl1-f175.google.com with SMTP id 21so549354plo.13
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pv7T7AOubRmQ4NM+lOBXb57SuRh0StVaz5A6kAV5rhU=;
        b=Fw3dhpBg0pQ53r2u9Y2EjtlmDcuAXoB37Hl0da5nsCF9g2zp6fwn0cdrg/eBdw/X2z
         BZOHGrhg7zVA455AVkEzDkAAn3YKjIJqGifVsMlpuuxMzg/PbMsg7S4iOJQQ9P2bd6t4
         leBfre4YEptfPev3CWq7IXlShwYyCNI9/hAQGKtx3L9ehkTEd/H2vDtL66afnaScabaX
         RDqwfVJqafOJSTTJATV5DxzOU0+Qwhf+mIX4DC8If2wytzFDPXYbayhm6+1ICBY1uLJG
         YQNxEqhW2h5gB1ehkzm/iibOX6g2oWC5g7DRuPD4+NuGzDT1fRxmka4ppW8N2Ilr9t4P
         OJxA==
X-Gm-Message-State: AOAM5317d73tJyC0g/9unZQWqUHD5ZaYO93ksBzwRB0GyCSoZCnqRXPB
        wQMAZ2HIRDDFR/R6AwbYwL7HftHmfMDq9A==
X-Google-Smtp-Source: ABdhPJzldofzQFIy9IwPXyIgijm3M6OSv57C6sHAqWxjA41k0cpQg+adVUIQydFqSrx6tVENnRkkyQ==
X-Received: by 2002:a17:90a:ec17:: with SMTP id l23mr9434502pjy.184.1634081851136;
        Tue, 12 Oct 2021 16:37:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Song Chen <chensong_2000@189.cn>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v4 44/46] scsi: unisys: Remove the shost_attrs member
Date:   Tue, 12 Oct 2021 16:35:56 -0700
Message-Id: <20211012233558.4066756-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for removal of the shost_attrs member from struct
scsi_host_template.

Acked-by: David Kershner <david.kershner@unisys.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/staging/unisys/visorhba/visorhba_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index 41f8a72a2a95..f0c647b97354 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -584,7 +584,6 @@ static struct scsi_host_template visorhba_driver_template = {
 	.eh_device_reset_handler = visorhba_device_reset_handler,
 	.eh_bus_reset_handler = visorhba_bus_reset_handler,
 	.eh_host_reset_handler = visorhba_host_reset_handler,
-	.shost_attrs = NULL,
 #define visorhba_MAX_CMNDS 128
 	.can_queue = visorhba_MAX_CMNDS,
 	.sg_tablesize = 64,
