Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1A5C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCDAeJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjCDAdo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:44 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3378DB75C
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:13 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id u5so4524544plq.7
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iIIFRGbiH4biuLQ8Ka3oAwiIlc3Ew6o8lJOxme8R1Gw=;
        b=vXpZxxc53SpUjJRAS2hNY/sl7JegdF7ZEH9wNvKa/jJCJrxnD3Gg/6Pef20kgq81jq
         +MZSPGhw/2tlFtEcDAc2K82iP93OzCidwVeTs+q57XVDJUleqkrWfqyDfK2dtLHeX9ol
         A7aB/URQdIyXoeIQF05LodxFs/6dEyQ4pl1nSk6z2FR/fz9uAxLYwFwSMRKrcVb/A7LH
         hL6RUW5YrCLlRdncJ52JtwInQS2dOomKHoB5ndjgBGn5jQxWht/aUBzzJ4mFKv/1cCWq
         zF/v/L40aHl6hljRoPEbMwwJvaIc7QcIDn9H7K1QV412+oyS6vcVVcTPu5+T0hqn1D5w
         UeRg==
X-Gm-Message-State: AO0yUKXvfgn2o89w9aXUtF/6+bDH5T62FQoIlocLTLAHEz3OIxdZYV6K
        +4MZvymQxbOWsCj4iL1DgUg=
X-Google-Smtp-Source: AK7set/K0i473MzWy6Qbponc9xhbTlNJazsCRYkGw2mMrfwwVQPMbm+LBF+IHjmuAmPbBmFcIjxEMQ==
X-Received: by 2002:a17:902:ecc1:b0:19e:23c1:4c2e with SMTP id a1-20020a170902ecc100b0019e23c14c2emr4331067plh.59.1677889992440;
        Fri, 03 Mar 2023 16:33:12 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 42/81] scsi: hpsa: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:24 -0800
Message-Id: <20230304003103.2572793-43-bvanassche@acm.org>
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
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f6da34850af9..ff8436fe6dd1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -967,7 +967,7 @@ ATTRIBUTE_GROUPS(hpsa_shost);
 #define HPSA_NRESERVED_CMDS	(HPSA_CMDS_RESERVED_FOR_DRIVER +\
 				 HPSA_MAX_CONCURRENT_PASSTHRUS)
 
-static struct scsi_host_template hpsa_driver_template = {
+static const struct scsi_host_template hpsa_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= HPSA,
 	.proc_name		= HPSA,
