Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A481C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83E5961108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242049AbhJGUbx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:53 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:46741 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241376AbhJGUbw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:52 -0400
Received: by mail-pg1-f170.google.com with SMTP id m21so888308pgu.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BhjZcNLCb2BcusfJGpL8i+I7xZIdyPmD/+05hmSpo1s=;
        b=OSmrbMmtgoRMt3IqaNqI4QaXKf3mWS2HqNyZZBp2Ndrnltm/ygJaB6c2t7jQCkOug+
         FSgmzJgOUK6ZGRRjan8njB4nkYC2ot0xFPJbwBMYyjBTwYbc/KKDKi3wYmcHvL4O0a/B
         vH6kLrusNveBMLQj9ECgOwt+yXFP91HUdWdZQG0rLIkTNpdp+k/A8vUCs8LXrPmnRI9y
         tWpaL3kW78NYXUynSCw3Daq9xDUXHpsz+ggVYd70NsdXCEUP8Zw49KLw8ZiVfg9Mc2HP
         wYQdULjQjKx4tOTBdKGza4TUrS37nWO5QQG8QMFQLN7ljgv3gQ+MtVXuh3C0CnrnECHV
         XxwA==
X-Gm-Message-State: AOAM531BvAxnzMpjdpobytl+GqvHwYamnUIP7HlP9sB8+FIBYI1R1lK6
        oKvgBbvxH0F12p+a5+YwI4c=
X-Google-Smtp-Source: ABdhPJyqKo9VYvmfVxNr6NGtsTGG7uIn4uX8hRXYmOTnXr7U0LRROGeZMLZzxQClfjsZ0nACSsvx0w==
X-Received: by 2002:a05:6a00:ac8:b029:320:a6bb:880d with SMTP id c8-20020a056a000ac8b0290320a6bb880dmr6383884pfl.41.1633638598476;
        Thu, 07 Oct 2021 13:29:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 17/88] acornscsi: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:12 -0700
Message-Id: <20211007202923.2174984-18-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/acornscsi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 0cc62c1b0825..dadaf5ee0ea9 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -841,13 +841,10 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 		}
 	}
 
-	if (!SCpnt->scsi_done)
-	    panic("scsi%d.H: null scsi_done function in acornscsi_done", host->host->host_no);
-
 	clear_bit(SCpnt->device->id * 8 +
 		  (u8)(SCpnt->device->lun & 0x7), host->busyluns);
 
-	SCpnt->scsi_done(SCpnt);
+	scsi_done(SCpnt);
     } else
 	printk("scsi%d: null command in acornscsi_done", host->host->host_no);
 
@@ -2428,7 +2425,6 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
     }
 #endif
 
-    SCpnt->scsi_done = done;
     SCpnt->host_scribble = NULL;
     SCpnt->result = 0;
     SCpnt->SCp.phase = (int)acornscsi_datadirection(SCpnt->cmnd[0]);
