Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F388EC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 09:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C42564F46
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 09:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhBEJQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 04:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhBEJNy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 04:13:54 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D201AC0613D6;
        Fri,  5 Feb 2021 01:13:13 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id a12so6177634qkh.10;
        Fri, 05 Feb 2021 01:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PFbkaDmPxbAKpkOajTnpFDsUQrNOUBHeWcmqrZ8mcYY=;
        b=A3A5LNWGbBoqoIfWxnPY2lwqbOp3WSHkix7RKTOTeBWemlb54jaO1UA7/kf1zgZmrb
         lJnu5eUZueQOu0MqtFP4TGBpubcvcPSYAZCtK1ONyvQjpDx3MDrEo89BPQOvU/Cr+I03
         UIISQQS9+UEnKgkWmJ9BMdhWjVJQ4p1lCjPCr9+ACQTSmtCbEv6jMFyKCM0+EfM+VE1j
         BB1X4pW8SjwwnekAwWluAkmJQFxUZZtp7NU6rd09BKWamgvm+BJ/9IctwRo4N+aEAZJh
         e1WB0sm4IlPrGv7cxrmniuKW7iuuOi18bOgH0mmyxhIukkPNtX3k+ch8hpAfgo7LeyeJ
         0OpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PFbkaDmPxbAKpkOajTnpFDsUQrNOUBHeWcmqrZ8mcYY=;
        b=nHa308RcA40Xtbx5koq1yNUmcO/+NoA/PGa3LpiR8lLqLNS9M7rbeSFlY1qy+YeQrp
         Zq3zC2JQcNafL69zQZVTeLoK+TaJsduVY1oCcUucHyPsJcC7wz/uICTnIL07cF4vxPsm
         80hPac83m9bdoNxp222f9QXZxQUf6UJOmi1mTnHRVu3Hq4PiI2wreQczmlC7DUMhfDc7
         y2vMDGIFelpLVVknyM20HZDEVdmbRy2zT+V+cnCoy9z1fLPbug9jINvJ+ipvLNjd6Z+W
         CGoB55b6QT72sXjz5UGhFIfMCk7I0M7r+gvPnDuwsHSEQo8mkGXbnYGzN4pfIsVQZdxt
         Ipaw==
X-Gm-Message-State: AOAM530KEHtrGbUI7MeFXL1okRA/XL+jZ8pLfaw3189U4VgDsWkTBXxJ
        PwVZ60ZrP2CFcT6JVMLbcEg=
X-Google-Smtp-Source: ABdhPJzGv7lKE/tqQWXskWoiaSpjzL7hHjZT0sL0L0Cr6rGb/GtYUp3RXwW+ifi0IIKA7/FVtXDJpQ==
X-Received: by 2002:ae9:ed4e:: with SMTP id c75mr3376700qkg.109.1612516392662;
        Fri, 05 Feb 2021 01:13:12 -0800 (PST)
Received: from localhost.localdomain ([156.146.36.157])
        by smtp.gmail.com with ESMTPSA id l24sm206643qtr.16.2021.02.05.01.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 01:13:11 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     brking@us.ibm.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: scsi:  File ipr.c gets few spelling fixes
Date:   Fri,  5 Feb 2021 14:42:57 +0530
Message-Id: <20210205091257.484726-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



s/Enablement/Entablement/
s/specfied/specified/
s/confgurations/configurations/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/ipr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index e451102b9a29..c12c0a309c54 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -16,7 +16,7 @@
  *
  * IBM pSeries: PCI-X Dual Channel Ultra 320 SCSI RAID Adapter
  *              PCI-X Dual Channel Ultra 320 SCSI Adapter
- *              PCI-X Dual Channel Ultra 320 SCSI RAID Enablement Card
+ *              PCI-X Dual Channel Ultra 320 SCSI RAID Entablement Card
  *              Embedded SCSI adapter on p615 and p655 systems
  *
  * Supported Hardware Features:
@@ -2470,7 +2470,7 @@ static void ipr_log_sis64_device_error(struct ipr_ioa_cfg *ioa_cfg,
 }

 /**
- * ipr_get_error - Find the specfied IOASC in the ipr_error_table.
+ * ipr_get_error - Find the specified IOASC in the ipr_error_table.
  * @ioasc:	IOASC
  *
  * This function will return the index of into the ipr_error_table
@@ -7202,7 +7202,7 @@ static const u16 ipr_blocked_processors[] = {
  *
  * Adapters that use Gemstone revision < 3.1 do not work reliably on
  * certain pSeries hardware. This function determines if the given
- * adapter is in one of these confgurations or not.
+ * adapter is in one of these configurations or not.
  *
  * Return value:
  * 	1 if adapter is not supported / 0 if adapter is supported
--
2.30.0

