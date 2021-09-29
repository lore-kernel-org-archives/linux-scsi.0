Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0646DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B9D6140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347205AbhI2WJ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:58 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:43856 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347208AbhI2WJv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:51 -0400
Received: by mail-pf1-f181.google.com with SMTP id b68so3142556pfb.10
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2/QRLAju1rqA872cyW9wszu4gb+YXOXA8KDXBOy4pqg=;
        b=JS0ZPovCDhdYSasyfBx7nQIxkfszQuFt5bzApfGHi1lK6rd8lfEXetqeBqq1ttBlLs
         RF0Visc+NJsElWMO4eZEJYS3AKbUqcRkgFIxmJCqqXF2wAfPINI20gCQnr7leV3rehZB
         MBlxh6VmpZVl4PAojeITLQ+MvhbgPpI8qgyvutOfTRcQpJFH6T+D3rZruInoT1PTK80q
         zG21vjd4L6r8osGxV18bu16nHcj3aIDDVnismbkkdLe8EA3eSLIfSNGCEBjVwEjM7oU2
         Y1Axn8S+teZk4BOS0kg5kDwn1zD4j2UrsvkoJYWnieeyFmpnZPvDP0FBNgN9syjfqTAp
         EdmA==
X-Gm-Message-State: AOAM533hN5F1fMhjm9646KwlDEwaRREFl+PwJFSRKrdJ8h1qAYIukz5V
        CiNPCxJWMnBC2+iVCSnbW24=
X-Google-Smtp-Source: ABdhPJwmM6w1tZqoS31BaJlntbP+Gbgt9wTnkjmq8xbVwrRYITjGNk6u1/mhWoimNSlJqtROdXYPog==
X-Received: by 2002:a63:1656:: with SMTP id 22mr1933385pgw.20.1632953290005;
        Wed, 29 Sep 2021 15:08:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 72/84] storvsc_drv: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:48 -0700
Message-Id: <20210929220600.3509089-73-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

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
