Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC90BC61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCDAfO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjCDAei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:38 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E4A6A420
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:11 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id kb15so4379409pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8ne1LFtZC0aI46uW+Rpyylv80/ucvjDGf+JX18Z6oo=;
        b=uoqcI/okswmBjVPGDmkYkMSYvMHJ6RQrtBhENzGqZh694Ei+0qyJNjG1f+1S0B6/oj
         /1ZqwGTHJUBtr5sitb0lKPwqjT+cgQ1JLQElfGmGpIDEt+9G4V3rJZ9h02R+5gARriZX
         o1Ize7Gok1PtB3dSA/iDYWXHCayj7VwCqjsklabFmr2KzG9CocJziC1PRM4qgQtUnC4D
         Hv+wddOHc+g+F9uXhaqW+EUK9DEprxBPkUaNari+xBf86kECnXMEpl3YJrVdo3GKYMGK
         OerJhec1dJbpE4SgU8Lu7mbLntGUw2RxTYEoHksacVIv+WHQ8NKzCFOGFm89r7EDxMaV
         spEQ==
X-Gm-Message-State: AO0yUKWxfDO43fg3f8bAF1Y2JilRugDJvUXBx9z6gx1eVoORiLyG6RNe
        SCZEf17R2I9uAbePTesNOH6shY3z07p+Lw==
X-Google-Smtp-Source: AK7set9/P04TKJTTYzQ4CbzsjyiRfT+eWZD1QUef1fNfcsl/4B3pISDQJ0Z8pe5z4d0sD8itCEu4Vw==
X-Received: by 2002:a17:903:124a:b0:19c:d457:ff21 with SMTP id u10-20020a170903124a00b0019cd457ff21mr4780792plh.54.1677890044166;
        Fri, 03 Mar 2023 16:34:04 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:03 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        GOTO Masanori <gotom@debian.or.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 60/81] scsi: nsp32: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:42 -0800
Message-Id: <20230304003103.2572793-61-bvanassche@acm.org>
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
 drivers/scsi/nsp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 75bb0028ed74..b7987019686e 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -259,7 +259,7 @@ static void nsp32_dmessage(const char *, int, int,    char *, ...);
 /*
  * max_sectors is currently limited up to 128.
  */
-static struct scsi_host_template nsp32_template = {
+static const struct scsi_host_template nsp32_template = {
 	.proc_name			= "nsp32",
 	.name				= "Workbit NinjaSCSI-32Bi/UDE",
 	.show_info			= nsp32_show_info,
