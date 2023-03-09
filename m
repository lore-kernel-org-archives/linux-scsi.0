Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3EAC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjCIT2V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCIT2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:06 -0500
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4F81ABE5
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:03 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id c4so2234627pfl.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c47+d0pz7DNihHgR0GI5I+QfVkFleIpC/pj+/6FjG7w=;
        b=BqDoyDeB4r/Ut57NZrdTAjSolo4DsBi/hLjVhIYR/NMO7XDdn013Cx/fggJuGvAy0y
         w6PI2OraDJKZNYlTDYsuTOtNeBxLvt1EF55hi/jLjt9PIE9RTo1UY8XBCtLPvW0KKtxc
         kVh2N39sNL3bFbnapatvBnPefUBsKu/7ETWCHhCK3FRc4hOx6uQCwxJ69a6zpO+Iv5MM
         yPCe6rrSR79MlcFwuUwCxwh1CzaczuxwO7lUfsX3zpuLKYwNHeGcIVMmAgGckhux5AR9
         bVK8JQeZFPQ4f3rU1fGtWaeoPvghXjNeikgHsCIXqFbTM2PtZ4b/L84XdaKRzM0WykuM
         UMuQ==
X-Gm-Message-State: AO0yUKWPRsWiK23KQDNaLjcZtmgJMuAjgyMImIf7RM2fw5uao5imY1a8
        6HQmx5n1QYwOWOPJ+e7VRoc=
X-Google-Smtp-Source: AK7set+PAIBlIkPrNLMSRv+KazQWlgooZ08W+wkRPwx448GZQhoOB3t6+kgImBMylp1kHUjgz0f8Zg==
X-Received: by 2002:a05:6a00:a81:b0:5a8:aa5e:4bc3 with SMTP id b1-20020a056a000a8100b005a8aa5e4bc3mr29620006pfl.1.1678390082667;
        Thu, 09 Mar 2023 11:28:02 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 25/82] scsi: cumana: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:17 -0800
Message-Id: <20230309192614.2240602-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
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
