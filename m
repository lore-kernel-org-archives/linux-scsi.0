Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A747FC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9272461406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347096AbhI2WI2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:28 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:40851 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347088AbhI2WIW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:22 -0400
Received: by mail-pg1-f172.google.com with SMTP id h3so4141464pgb.7
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BhjZcNLCb2BcusfJGpL8i+I7xZIdyPmD/+05hmSpo1s=;
        b=v+PhBb0HVegemGSEGnLMPkw0Xszy/DX4lAzw6MkeGCL7osC8wO+mwPgzNzjIcsC0Wr
         USxNWn+u0bMyXNB4XcAIzanPCoJZ6suNrHBuwl5kcHHXy91xaD6iz7BEYyoNyzY3ZAh8
         JecY7Oie99UM2AOdeQMGa8owSSuKtq/D/QAgWIArLZD/YS6iQ0/DI8sFiIrDPemLMudZ
         KXHp5pG+eIlTBTekaTGLgScGEFb8x9WfN6Sts44DSORSJ3EU+d3+cINoEbVUHLTB6QYK
         1Gbf7IjRDdoqqXC+Qe3LWmbDBacAPP9QNiJEB5cZ9CErOfTfDHXaMYyfjWshOQOm3NeA
         VRDw==
X-Gm-Message-State: AOAM531WrXrdb3/CtmiUA6J9SfAhQoKzJ7eo0l7yjybWWqQufRmpktb1
        xXIqEYMepEx0N1gJCVGW84s=
X-Google-Smtp-Source: ABdhPJzcBHVxx9nv/4KvLEGqWoYUa6s9gHfH+WhIJGNA/UkEehGyHmISQ9F+EDJw8KsulcZuxAiaww==
X-Received: by 2002:a63:1f24:: with SMTP id f36mr1968091pgf.6.1632953200424;
        Wed, 29 Sep 2021 15:06:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 17/84] acornscsi: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:53 -0700
Message-Id: <20210929220600.3509089-18-bvanassche@acm.org>
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
