Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92279C678D5
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCDAfu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjCDAfM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:12 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0D36A9F7
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:32 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id bo22so4350356pjb.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xpoH3ZmMyEfzGffayIrMYkM/us+uEKnG/TchdnkTiAk=;
        b=lpYhGqDluKCx5PE+c5rS0RPt1GE6vcbD0VabBPibYSJw7LEioUyQrMmIr2w7yfMO92
         GVeiiKJuhMoYBbefs1kAacE1gDFuNWiwp3GpeT5j5nJ3O8MCJLCgrzHFeg0TesoqpALw
         MPBBs/7aV3ovDhEBpamApEmsxe+mJCZTjeM5vWOCM4nQ8fenmKm4+WTZDXaExsd/y01I
         OKRUWhrTrTbKLvHSSBLbFVZ/9KslH8jaZVkYBsMrBvKWShd2XFo2nFlcSjitLmLheEeb
         dR52i0gr6eUxMOwnlBkwagBi2aQRRJKqVWAHFlvBBYXN53OIRiZ358SUu2tzYEohmuJh
         xK+g==
X-Gm-Message-State: AO0yUKW3E/08RoCAWEb/zEOAbqMjO65bDdbbkUs+6thOicysNjwlaUDn
        uXTdbQIwKlp4FFoMRpMn2zk=
X-Google-Smtp-Source: AK7set9WjQVuBbQ7aNBII9FGUwuNAXt8ZEz/T5Wd5TubiUjXpbJnglWNnjx5aUW25M/XKZ/6DjTJ6w==
X-Received: by 2002:a17:902:d2c9:b0:19a:c4a0:5b1b with SMTP id n9-20020a170902d2c900b0019ac4a05b1bmr8149978plc.1.1677890071483;
        Fri, 03 Mar 2023 16:34:31 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:30 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 72/81] scsi: stex: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:54 -0800
Message-Id: <20230304003103.2572793-73-bvanassche@acm.org>
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
 drivers/scsi/stex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 8def242675ef..5b230e149c3d 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1472,7 +1472,7 @@ static int stex_biosparam(struct scsi_device *sdev,
 	return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module				= THIS_MODULE,
 	.name				= DRV_NAME,
 	.proc_name			= DRV_NAME,
