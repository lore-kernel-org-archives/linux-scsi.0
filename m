Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8710C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjCVT54 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCVT53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:29 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF8D64B31
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:08 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so20225958pjt.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c47+d0pz7DNihHgR0GI5I+QfVkFleIpC/pj+/6FjG7w=;
        b=VhP0g0Qh3DFd+ZGt+p4njg3/O0XYoo3Bz78L7sc1HRI6dv1Wjan+e0rq/llyv/IlNE
         7bqxLAnRGJ90w/FHim1vZrMGgfiTtCXnmkpilrQKDEwqTtQHwS/7pRs5IPIru9Nur99E
         PmJgy+pgchYgayGiBXjkQB3X8kwonjraa2EODdeE7dzO/aHDlVVSsF65Y2wuAURwFACW
         Z4nNWUTza79H4EBoGQeQlWEwht+w9IvniLxsme3Il1F3aAwLlBkWnCaihn0773zt56N2
         k6JbGfPZEO+0euvR2VcxOBkuOtU/96H+bbBsibbxxiRYEn4UMtw9CeFQ2oxO1bQE8Oyy
         FjCg==
X-Gm-Message-State: AO0yUKUYD1vm/+e7itbKXCdaKpw2sZcFj85l/nN7+OlrtcWLykQl7wbK
        2faW8AHXTR4V5wQ31ioqXMFPfcgbMyM=
X-Google-Smtp-Source: AK7set/a/e6o08nLvoXNN49hn30odYkO9jRHMdPcYslzQ5XrCswpYj4FpaxXy01rb3nVNE+i3lkF5A==
X-Received: by 2002:a17:90b:3e81:b0:237:ae7c:15be with SMTP id rj1-20020a17090b3e8100b00237ae7c15bemr4941321pjb.30.1679515027702;
        Wed, 22 Mar 2023 12:57:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 25/80] scsi: cumana: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:20 -0700
Message-Id: <20230322195515.1267197-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/cumana_1.c | 2 +-
 drivers/scsi/arm/cumana_2.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 5d4f67ba74c0..d1a2a22ffe8c 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -211,7 +211,7 @@ static void cumanascsi_write(struct NCR5380_hostdata *hostdata,
 
 #include "../NCR5380.c"
 
-static struct scsi_host_template cumanascsi_template = {
+static const struct scsi_host_template cumanascsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Cumana 16-bit SCSI",
 	.info			= cumanascsi_info,
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index d15053f02472..c5d8f4313b31 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -356,7 +356,7 @@ static int cumanascsi_2_show_info(struct seq_file *m, struct Scsi_Host *host)
 	return 0;
 }
 
-static struct scsi_host_template cumanascsi2_template = {
+static const struct scsi_host_template cumanascsi2_template = {
 	.module				= THIS_MODULE,
 	.show_info			= cumanascsi_2_show_info,
 	.write_info			= cumanascsi_2_set_proc_info,
