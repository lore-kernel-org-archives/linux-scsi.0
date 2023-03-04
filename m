Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50529C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjCDAcy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjCDAco (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:44 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C5C6A1D0
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:44 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id kb15so4377339pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ts+vWJKv0MXDJEA4JIO9+AM9uvvvxXowXRyy3KeGtYI=;
        b=tQVGf9WzWJky8SvgVi1jyU2ZO3M2oEs3NZkARy3szNFGNzcTScPkejHtUkOkVzZM1s
         yE+kzLn5JHFtWthjHZl6a019HvIQ2lsPGmnJ6CxAbfXorSEwdoIOLP1Et3c/QYjr6qAq
         khQbg9QDPMPxh82XNAihQUb8WcB17I5AnQGxjObFuPb+mhHHr4Fz3e7Vcul0/EpEbM/9
         UcoYVKdfKziDY9LU1BYWdNDf2oyYCtr9OtIPCaIsfjz6AI6Cup3HmRI0BQeqxGZv4TJS
         QYHXUDOSad3RsrWOIhaJXlcaOowokxZmw5aRtPAUbUxUdF59xcgx0D7FhTj4JKACKIz5
         NKCg==
X-Gm-Message-State: AO0yUKW2Ob5Cnu6g9EAFFFQizy3jz/fK58kfeXXM/m2VzEApRdd47muH
        V+MQHJE0pVN5HRMmGnvQ+4A=
X-Google-Smtp-Source: AK7set8gCfmC04u0HZr9qLgbyG54sPXWrkRthmGHw62M0hMR17K4o8UAG9/MHs8kx2ThwTyOZ4zlaw==
X-Received: by 2002:a17:903:124a:b0:198:adc4:22a4 with SMTP id u10-20020a170903124a00b00198adc422a4mr8053270plh.31.1677889963512;
        Fri, 03 Mar 2023 16:32:43 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:42 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 29/81] scsi: atp870u: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:11 -0800
Message-Id: <20230304003103.2572793-30-bvanassche@acm.org>
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
 drivers/scsi/atp870u.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 7143418d690f..2a748af269c2 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -40,7 +40,7 @@
 
 #include "atp870u.h"
 
-static struct scsi_host_template atp870u_template;
+static const struct scsi_host_template atp870u_template;
 static void send_s870(struct atp_unit *dev,unsigned char c);
 static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip,
 		   unsigned char lvdmode);
@@ -1726,7 +1726,7 @@ static void atp870u_remove (struct pci_dev *pdev)
 }
 MODULE_LICENSE("GPL");
 
-static struct scsi_host_template atp870u_template = {
+static const struct scsi_host_template atp870u_template = {
      .module			= THIS_MODULE,
      .name			= "atp870u"		/* name */,
      .proc_name			= "atp870u",
