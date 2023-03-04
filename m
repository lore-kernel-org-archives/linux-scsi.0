Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B821FC64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCDAcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCDAcE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:04 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1446A1C9
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:59 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so7854965pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NNIBPT74zB8cP9y9PhKNlxYuRy1lcz2hltLytVbDwLc=;
        b=tSFg2gZl2cILyd43Epd4pNStDqNCwsJaZnu4Kogeu5nt4nEbkOksucdnw/I+i6RKWJ
         37ouxpMHzhwa2MkRXWPvrATgCAjmt1WQrrGlUhcrsGQAdeJ5fIWsPGsFyDddoQ0d9D8+
         He5Ksh7xM2t1RscUroIwD6rgF6IdPnHrSUTAXFLda3hX+wJJuSTB6EsNLdT2uvxAFBFs
         SudIb3V17QKbvo+/LvZ96PGd8sgLsh1cvROQW7HLHDVxDMmT3TvHmyrmz0Z1+5cQUP5/
         QFeXNNv5B7sbs9u/W+2ccMzkbnKnSGmSwVF2RoQE3grLnn0fz7NtRRkAFcZuqNAODwqC
         SxhA==
X-Gm-Message-State: AO0yUKXhzyxn+naEBVucdCaM2JdYIu01dNVhvh59jh/BLoi8Zr1Ce4Dy
        nDxm3GNFJn9jbIbeDU8NzeU=
X-Google-Smtp-Source: AK7set8qg8dfd+oK713dF56K0nDlcXpb5nv5we9D9B+5y/+k98tGYvSOYpwiLf5Def4vPW4VGrD04A==
X-Received: by 2002:a17:902:bc42:b0:19e:6a4c:9fa0 with SMTP id t2-20020a170902bc4200b0019e6a4c9fa0mr3087391plz.49.1677889918557;
        Fri, 03 Mar 2023 16:31:58 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:57 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 11/81] scsi: 3w-xxxx: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:53 -0800
Message-Id: <20230304003103.2572793-12-bvanassche@acm.org>
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
 drivers/scsi/3w-xxxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index ffdecb12d654..36c34ced0cc1 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2229,7 +2229,7 @@ static int tw_slave_configure(struct scsi_device *sdev)
 	return 0;
 } /* End tw_slave_configure() */
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3ware Storage Controller",
 	.queuecommand		= tw_scsi_queue,
