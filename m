Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD05C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjCDAcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCDAcK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:10 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0237B6A1C4
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:10 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id p20so4493570plw.13
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0DwKfQtFgIgqVRLk7CJqp+SWpc3PgTs6DS8lVIZ4b8Q=;
        b=ZBi3M94456H6L14ym2+GAdb7kpjkcQvpIErnsmQYbOyKj3VsGxeX0CmXTNWXqeqVG8
         wVcd7EOoPootyE2geJaSCje50wR9k7bIAIBetjMg1XCoC2iSYH0AwaTY1TMxfAGzcJGN
         mHH1P2CivtUfjqKIzdahhtd6y/l8zR1TZsJaP/IsDX5+QA6ln1gzJ/aCtlBuTW5u2qNq
         uaA9JFLw2coHMm74wUBVuJtnezc5TLHVgPsqhV0bHEJa7qaDpQCTxfgg2HcOw2taGvID
         Vh5AM4makliFo0T8ASG3okYjdBCOYhAIsXMTsS/tNVO3n7i1UoM4585Zwg0Gy2t3jw/p
         BAaA==
X-Gm-Message-State: AO0yUKX1lB3waQD5um+WQPXfagESRm5ThRBpV28AhNagUinsRgiXJQLU
        yd6QXxSMecT7oO933CwGR08=
X-Google-Smtp-Source: AK7set+deCXkerOKTgGpXfzIKDcpM0Ml1cTVxEZwV7aivp0QPZhZZHUsUKc8USUEKVRf7hN/ez3qDw==
X-Received: by 2002:a17:903:2344:b0:19e:6e29:2a8c with SMTP id c4-20020a170903234400b0019e6e292a8cmr4372240plh.5.1677889929485;
        Fri, 03 Mar 2023 16:32:09 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 17/81] scsi: advansys: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:59 -0800
Message-Id: <20230304003103.2572793-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/advansys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index f301aec044bb..ab066bb27a57 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -10602,7 +10602,7 @@ static int AdvInitGetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 }
 #endif
 
-static struct scsi_host_template advansys_template = {
+static const struct scsi_host_template advansys_template = {
 	.proc_name = DRV_NAME,
 #ifdef CONFIG_PROC_FS
 	.show_info = advansys_show_info,
