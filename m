Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717C4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 592BB61130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241708AbhJGUbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:47 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:37676 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241222AbhJGUbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:44 -0400
Received: by mail-pl1-f182.google.com with SMTP id n11so4262039plf.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cpY/lBLTe7tQQ0l8dXTUh8Aq73Wg1MJRRB+jRfiBtws=;
        b=xjNMbl4KI7jOpPyPmes/TQuIoWmv321jDCvOLsVYxVlYv9ZNLqz/br8dRB/inpzfNu
         TOD4L7T02CZYW5jLGy2PaJlT5j1g3zsjIfZqc3IwzxF6puu0m6iSx65TX8bCYX0nhWqP
         NFmY3TXrkLfY0xCEy4wHDp9ponFfBffgQ/VgZKUzD6mvpKaVzzLn2eFta7JGacO5A4u+
         VyJYbA7lOxztmNQRXXoE/L6QoJGy24y8loQiD+e/Ii3vEdJhdVsEQxTMh+4IerzMSq6f
         iUomZfSYxLA/buGbahxGmXIEPGwd2FUc7nfhTU4MUAQc1gYR+l4RwsGOpYZU1W7JY6A9
         lpXA==
X-Gm-Message-State: AOAM531NByUIfKmGbs7JU/c9Vmt5ZMY+eybiKj10aIVr1fLCSVlc03H9
        z5Wtvs6u/zIrrLIcGvs7ijSnnwqjFII=
X-Google-Smtp-Source: ABdhPJy2wytpzeE9B5WZrSFcHuDymaTE4H/sDs+vMgDXWl9cTP16LKklckVF/K8knl4O8JdWCfiGPA==
X-Received: by 2002:a17:90a:af86:: with SMTP id w6mr7346799pjq.8.1633638590320;
        Thu, 07 Oct 2021 13:29:50 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 11/88] 53c700: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:06 -0700
Message-Id: <20211007202923.2174984-12-bvanassche@acm.org>
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
 drivers/scsi/53c700.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a12e3525977d..e7ed2fd6cdec 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -634,7 +634,7 @@ NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
 
 		SCp->host_scribble = NULL;
 		SCp->result = result;
-		SCp->scsi_done(SCp);
+		scsi_done(SCp);
 	} else {
 		printk(KERN_ERR "53c700: SCSI DONE HAS NULL SCp\n");
 	}
@@ -1571,7 +1571,7 @@ NCR_700_intr(int irq, void *dev_id)
 				 * deadlock on the
 				 * hostdata->state_lock */
 				SCp->result = DID_RESET << 16;
-				SCp->scsi_done(SCp);
+				scsi_done(SCp);
 			}
 			mdelay(25);
 			NCR_700_chip_setup(host);
@@ -1792,7 +1792,6 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 
 	slot->cmnd = SCp;
 
-	SCp->scsi_done = done;
 	SCp->host_scribble = (unsigned char *)slot;
 	SCp->SCp.ptr = NULL;
 	SCp->SCp.buffer = NULL;
