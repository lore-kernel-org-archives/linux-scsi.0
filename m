Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A00C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCDAbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCDAbu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:31:50 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E6165441
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:47 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id ky4so4556502plb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QxASyLi8nqGzT795DVp8Cos4Ht8OMveiQULpG2J4on4=;
        b=S8EWpYNMERwYG9aql4ZeXIqEGokcr2G619UPt0BSR+St643yU3gADYXFiQlwtsoFaG
         t/4Pg3+6+OP6M4XkxHVj1K0BMWfgh/HFV0DKWQQWud7dhfZnvoSovmhnpOISOVORAMy1
         tNDo4dM/yvQbArCQSQa7sXioC0WR5RKG1I4rs6ShOzyjKD3HKLRktHLKJsnE5lbW1wuu
         +rSmQSTwvYZnIjbrk8hBENCZU/ymbf9zAVWJhCtCA3k3htQrjyiitIeFv1WlpOq/ZUMO
         rAP0VqcQpEX9vow/h9XSsuN7C15ujfOK9sWlhaVTNTt5jAl0MhidHhbPrBHEsi6FJRgz
         slJg==
X-Gm-Message-State: AO0yUKVP6RXIDCZ+TmGjfJBhXWKZIQmKEg16fMT5SEcV84SvHjgK8Lun
        nw4tsCD/zr2rTU1Wcq27GOg=
X-Google-Smtp-Source: AK7set92e4LTqDS5HdpKfB9HBTDYKo5Wfo+lqW+JmWRiVRCDvzWPQADhFFdFG0S26Pb6vnxBS8oCCA==
X-Received: by 2002:a17:902:c412:b0:19c:be03:d18b with SMTP id k18-20020a170902c41200b0019cbe03d18bmr5137242plk.22.1677889907219;
        Fri, 03 Mar 2023 16:31:47 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 05/81] firewire: sbp2: Declare the SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:47 -0800
Message-Id: <20230304003103.2572793-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the sbp2 host template it not modified.

Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/firewire/sbp2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 60051c0cabea..26db5b8dfc1e 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1117,7 +1117,7 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 	tgt->workarounds = w;
 }
 
-static struct scsi_host_template scsi_driver_template;
+static const struct scsi_host_template scsi_driver_template;
 static void sbp2_remove(struct fw_unit *unit);
 
 static int sbp2_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
@@ -1586,7 +1586,7 @@ static struct attribute *sbp2_scsi_sysfs_attrs[] = {
 
 ATTRIBUTE_GROUPS(sbp2_scsi_sysfs);
 
-static struct scsi_host_template scsi_driver_template = {
+static const struct scsi_host_template scsi_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "SBP-2 IEEE-1394",
 	.proc_name		= "sbp2",
