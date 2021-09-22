Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E68C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2C18611EE
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236601AbhIVQ1l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:27:41 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:33707 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbhIVQ1k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 12:27:40 -0400
Received: by mail-pg1-f178.google.com with SMTP id u18so3305413pgf.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2021 09:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w1iEouq48AVpn75b5A9apKQ3RgVM9gjJRAkhFFydADE=;
        b=l0ujfMOmZOHR7GxYt6m240wx1P+ptbZ/T6llaKDlQbZiQTCIyq679EMEdjp5VH5XgB
         0dixQke87Zckq+S4Uu6g+FQbI/XSZhIOCQo4O0TuoNaV3B6sWe+2ehGZRogbYhSwX6FA
         4+LXV51NfJNAAvEofpjSYSRGk5lz07Nk9Qy2Yz9CV1ab624HS/63KLdNnnoI1IJj22W4
         F5qi7udNHnvllPSlM9G5caDjrDdTf/Oe9KI9UlQiRiC0ZqBUPLardA5mUVNlR7ot9mOF
         Rs9sxaBYQVe+uaJu62T2MQFlchLzHmcFExEmS1Xoh/VRpBwItRp4C1oF6pXPY3aMV66x
         GDWQ==
X-Gm-Message-State: AOAM532wYsdWkAn0FnToQLpnQuhpAscATK9kW6EJberfb2lvvQ3WVl3r
        +9xa04O7+fzzAGFAHdwxQfA=
X-Google-Smtp-Source: ABdhPJzggST1nvbrfHLzzf6uhD4rV6WgvT1vX2oYIX4dfgZyHHIkxbG+v1mxCIihadPgBnZb/PRbZg==
X-Received: by 2002:aa7:9739:0:b0:449:56c4:4268 with SMTP id k25-20020aa79739000000b0044956c44268mr268654pfg.43.1632327970101;
        Wed, 22 Sep 2021 09:26:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3b9:da7d:f0c0:c71c])
        by smtp.gmail.com with ESMTPSA id p26sm2311697pfw.137.2021.09.22.09.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:26:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 79/84] xen-scsifront: Call scsi_done() directly
Date:   Wed, 22 Sep 2021 09:25:57 -0700
Message-Id: <20210922162603.476745-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 0204e314b482..12c10a5e3d93 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -276,7 +276,7 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
 	if (sense_len)
 		memcpy(sc->sense_buffer, ring_rsp->sense_buffer, sense_len);
 
-	sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 static void scsifront_sync_cmd_done(struct vscsifrnt_info *info,
@@ -558,7 +558,7 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 		if (err == -ENOMEM)
 			return SCSI_MLQUEUE_HOST_BUSY;
 		sc->result = DID_ERROR << 16;
-		sc->scsi_done(sc);
+		scsi_done(sc);
 		return 0;
 	}
 
