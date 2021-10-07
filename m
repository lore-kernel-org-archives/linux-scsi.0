Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC0EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60F4F60F4A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242588AbhJGUdn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:43 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:40797 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242333AbhJGUd2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:28 -0400
Received: by mail-pl1-f176.google.com with SMTP id j15so4695047plh.7
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w+2SlfhpRg8+GSDy9nw2Hg03jSGpHpkMonuyBSx8g5Q=;
        b=E8lmnZ/huVzMR71ag3cFI623Q1cYTNUebceJHB9rOsjGGZIhiQIZJog86cpYF5N4Os
         Yt/u4Z6N37hEZJUlKAtEqJ6NghQSzFV0z9Zv/hSFIrUQu5Gr8U43j9axhfhOOTB/54XQ
         FPBt5rbL6PR23pDlBFOotG6uNl9wm1KB7aupgx2SCvCS9nwfNWs5HTa7BU68LRE1QTrw
         eNBp1Q4guz48odgtLRSiEvBmKbKALc4xCZdAp2KyDCRb/zEE0iJjuNnnfX1/8NPtl/eA
         wWQi/P/t5WQ189DXijCzOpd5M1zrRqEPXegjB64IeJzTCIFxQHIH+JTehugywXy/7KgI
         7Jow==
X-Gm-Message-State: AOAM531zste1CB6SJgBocqWR9nrLmuHvzrGYIfMrf5h3IjkcOiTNfR/r
        h46zN3k1FKIbw7hPDaNRXHw=
X-Google-Smtp-Source: ABdhPJwDhsnLG5VYPEeh+6LOJscFCstOQm+Sxo6Igy+wuW4KkL4MVi+WPnJd+9lGJxnY3x2ML4RpYg==
X-Received: by 2002:a17:90a:d905:: with SMTP id c5mr7787073pjv.65.1633638694334;
        Thu, 07 Oct 2021 13:31:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 73/88] storvsc_drv: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:29:08 -0700
Message-Id: <20211007202923.2174984-74-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/storvsc_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ebbbc1299c62..70d0b1dd0f75 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1154,7 +1154,7 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request,
 	scsi_set_resid(scmnd,
 		cmd_request->payload->range.len - data_transfer_length);
 
-	scmnd->scsi_done(scmnd);
+	scsi_done(scmnd);
 
 	if (payload_sz >
 		sizeof(struct vmbus_channel_packet_multipage_buffer))
@@ -1753,7 +1753,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		 * future versions of the host.
 		 */
 		if (!storvsc_scsi_cmd_ok(scmnd)) {
-			scmnd->scsi_done(scmnd);
+			scsi_done(scmnd);
 			return 0;
 		}
 	}
