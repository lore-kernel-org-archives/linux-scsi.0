Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4350C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354120AbiBKWdn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354097AbiBKWdi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:38 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AECD52
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:37 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id i6so16758302pfc.9
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwYKhyFHil4fSG2RLAlZPEkTLtDpBryjbZMFKiNxE5M=;
        b=cI/GUIoJuygXL8HkX9GkdchyR0MLFej3P9slUY3ulFVVKYZ5fYAAfCQo6i6RU4H+SK
         3L0W2d4ws4wdEvtHcYkKxyn8IkOiw9+BbfPg4u/i6iaHqH8GBvVic5EvPCeg2IFDjGXn
         HbqGzo69ZuNy0z6CRnDAe+0qo/Tt8XUqgBurg+MDI1+JlYKtltQn/Jc4srVItmxSoJD+
         GGKCBr6+Dca4jlpKEdlFqOEFt/hLYQlLg5wk3iyP01+htdsekLFS1N6rOSIQEo8XZ3PV
         JSKgsq7P4espeo5Us8y3aPZZCPJy60nUf4hvtSD+lSwoZ1+9RTKGxgBmQB6MiIZI6Id5
         NNkg==
X-Gm-Message-State: AOAM530uRjViBtX0mrF6Op7BhZ4CP62XQ6tx4DiCUvg0zIJD3DlMfgeh
        2oRMDjlpEuz52hmpk9KmcDw=
X-Google-Smtp-Source: ABdhPJwJ+GdE2sCH8D+YLKqQwvuZ4Ewvtxu53Psmq6LdtPiVCoarq2Z0Bdf7ytiCZ1B01OVR01OmIw==
X-Received: by 2002:a63:8648:: with SMTP id x69mr3033801pgd.295.1644618816700;
        Fri, 11 Feb 2022 14:33:36 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:36 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 15/48] scsi: aha1542: Remove a set-but-not-used array
Date:   Fri, 11 Feb 2022 14:32:14 -0800
Message-Id: <20220211223247.14369-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following W=1 warning:

drivers/scsi/aha1542.c:209:12: warning: variable ‘inquiry_result’ set but not used [-Wunused-but-set-variable]
  209 |         u8 inquiry_result[4];

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha1542.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index f0e8ae9f5e40..cf7bba2ca68d 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -206,7 +206,6 @@ static int makecode(unsigned hosterr, unsigned scsierr)
 
 static int aha1542_test_port(struct Scsi_Host *sh)
 {
-	u8 inquiry_result[4];
 	int i;
 
 	/* Quick and dirty test for presence of the card. */
@@ -240,7 +239,7 @@ static int aha1542_test_port(struct Scsi_Host *sh)
 	for (i = 0; i < 4; i++) {
 		if (!wait_mask(STATUS(sh->io_port), DF, DF, 0, 0))
 			return 0;
-		inquiry_result[i] = inb(DATA(sh->io_port));
+		(void)inb(DATA(sh->io_port));
 	}
 
 	/* Reading port should reset DF */
