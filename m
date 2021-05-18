Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E52C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BE06611EE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351318AbhERRrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:01 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:40522 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351284AbhERRqz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:55 -0400
Received: by mail-pg1-f173.google.com with SMTP id j12so7532950pgh.7
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8ZrZxpFyLWC/b8TX2g9suyIzirLulmQYWjh1aPwWLg=;
        b=nfSzuXuEZD8B181RXFLHDk5eepnAQJaD5YTHT+hWI4YcJKD95lRgs9MCnPvBvRy74k
         M8oZ7YYLtxU/BlunkNYmH5auOqeBG8643fIwYguWggil8SPjjsCxYNZz/wZTYDsvmsuB
         uUaKRiZXNeYeBILt4g9z4sGB7W05weqYVivegJJPtuaLhXjZeZFcgQI6E/QWxyRhF98G
         UwKVPFMXHcXKtXMMv3zDQFCsSHw1bX6eryQg1OygzBeStNJp6aH1UeZ2iPTy/K2X8zh7
         FIiXMw0LnXk/uNEt7TFVAf8ZnDvfvlcf0vU9o4JwQeHwx29IhsuoiI8D2Q4Qu/PbOUbI
         mWdQ==
X-Gm-Message-State: AOAM531Vbhla6LUM0S/aaYkIt5s1VaSbxoZYfZ8Ajzg0rsuI9T6nKiPe
        WilG7bP+QduFgsWnQ4PNE9k=
X-Google-Smtp-Source: ABdhPJw/TkNZbQVHY9sniGkkZ5MKXCPxBaUa7vdAv3xmsgMZ1c9eqspqsJyGaV08uyCzHXc9p64I9w==
X-Received: by 2002:a63:416:: with SMTP id 22mr6280558pge.363.1621359937140;
        Tue, 18 May 2021 10:45:37 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 32/50] ncr53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:32 -0700
Message-Id: <20210518174450.20664-33-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ncr53c8xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index c76e9f05d042..09958f78b70f 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4164,8 +4164,8 @@ static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 	**
 	**----------------------------------------------------
 	*/
-	if (np->settle_time && cmd->request->timeout >= HZ) {
-		u_long tlimit = jiffies + cmd->request->timeout - HZ;
+	if (np->settle_time && scsi_cmd_to_rq(cmd)->timeout >= HZ) {
+		u_long tlimit = jiffies + scsi_cmd_to_rq(cmd)->timeout - HZ;
 		if (time_after(np->settle_time, tlimit))
 			np->settle_time = tlimit;
 	}
