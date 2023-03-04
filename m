Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB23C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjCDAci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCDAce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:34 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977296A400
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:32 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so3352626pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wc8ynnG/AUp5Bu6EUuP/BB+ayz5OX1mJgbC2WVbd21o=;
        b=KyiooqxJfMrCbtys8bBTD1QvOVkMMLOdby806F5WtwdMJcZlWJ+fIzy7JK2Tlvj8aN
         X2+UIO/ScetxiVs/tX0aUdOFbd6e9lc+DhWc7yvaIxkwLSnd1TK/+yRrfuXdJCVOF29g
         FA39HA38KFqsChwYc1fb08Pfnt51y4Dc0MsF7COL7O4DRD9/TJX6arWFhdBUrebOzvxv
         rrK0KJVKeFFjslKwbOXzqgN2RsFe5bdf6ZoMkf+gChk2SAy/UjS4mXfeEcqp/OeHvG4k
         iSr2VGVLuYGpeRdZqD0MfoOI92ooYW2dI7KwSvbRzT3nJ+Gx1+3Bj0yI+zHnqKwgXJSi
         67Zg==
X-Gm-Message-State: AO0yUKWonwNmuD4u5/1MHfRSxBLjPs0eTzmVhFXM7WVLx060wYUigerL
        BTN58J01K6pTecHx80OPF3Y=
X-Google-Smtp-Source: AK7set9bOhnj6/Uy3f0gQlHsAh+UBNxXPpe1GJungzxC6zC8s8get+nJ/gDg9Wtnh/bgjlS1Ppi6fQ==
X-Received: by 2002:a17:903:187:b0:19e:6d83:8277 with SMTP id z7-20020a170903018700b0019e6d838277mr4449617plg.51.1677889952089;
        Fri, 03 Mar 2023 16:32:32 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:31 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 23/81] scsi: arxescsi: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:05 -0800
Message-Id: <20230304003103.2572793-24-bvanassche@acm.org>
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
 drivers/scsi/arm/arxescsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 2527b542bcdd..925d0bd68aa5 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -238,7 +238,7 @@ arxescsi_show_info(struct seq_file *m, struct Scsi_Host *host)
 	return 0;
 }
 
-static struct scsi_host_template arxescsi_template = {
+static const struct scsi_host_template arxescsi_template = {
 	.show_info			= arxescsi_show_info,
 	.name				= "ARXE SCSI card",
 	.info				= arxescsi_info,
