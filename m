Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B100BC64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjCDAfO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCDAeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:37 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E253A23C44
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:10 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so7926912pjh.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGld+nXB8xoLCjPdJf78FkMSomKl6XlXAp76vIAuqrw=;
        b=JqneM86oQzsnjjmcOxJELhcn2V0auc+SNPdxY49+RougB9oXQPi0W/yUAda7H6pD5O
         ENdOVd/+9W6A3TUI0Ti2OAT1D3Poa8O/y7h2CrMoPeKAcGUfsByHQRzYHaZChk+0bQyy
         5YpQR4zK0sVsMpQOpvxszvN/Cgj/pJAWU9mY4/MDjJ34JGaNrvS70QbmlU4qR+wztr1F
         L+joaaQ1aAqmckARBY1qM+4rAh6hI1Huubp/kL+CPXTVvCHvxUKduJd3yg5Zo6C/Irkw
         2O3k80Cm6fHaPhbhAqDvTuNCN/5CJEcRTRSFTpjKHRz9tJ3zuuYDvaVn2X0z2ZU5AJ7s
         Q8dQ==
X-Gm-Message-State: AO0yUKVFeXZ+k0nEiJWcx9zljMuHhYIt82112c2+PKcF+jF0kahNrItF
        fJCeDVZbsoDZkGbmJqB+oqg=
X-Google-Smtp-Source: AK7set8ALkjvBbwEGden3nxpnKCLieVwmDQLHksRpTju9Ewv/exnubOB2Q0GQ09pywANQN7gFTw2IQ==
X-Received: by 2002:a17:902:dac7:b0:19e:6a5f:598a with SMTP id q7-20020a170902dac700b0019e6a5f598amr3490707plx.63.1677890042435;
        Fri, 03 Mar 2023 16:34:02 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 59/81] scsi: myrs: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:41 -0800
Message-Id: <20230304003103.2572793-60-bvanassche@acm.org>
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
 drivers/scsi/myrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 7eb8c39da366..a1eec65a9713 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1915,7 +1915,7 @@ static void myrs_slave_destroy(struct scsi_device *sdev)
 	kfree(sdev->hostdata);
 }
 
-static struct scsi_host_template myrs_template = {
+static const struct scsi_host_template myrs_template = {
 	.module			= THIS_MODULE,
 	.name			= "DAC960",
 	.proc_name		= "myrs",
