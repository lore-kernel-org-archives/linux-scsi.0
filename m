Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BF6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbiBPVDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbiBPVDd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:33 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1CA21489F
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:16 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id w1so2960574plb.6
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwYKhyFHil4fSG2RLAlZPEkTLtDpBryjbZMFKiNxE5M=;
        b=52aRrX4jSImz5z8ztYLA5pY/cwgLAYH9kvENjT18EsT/Ky1AzoWP6TMASpZmyJtF1S
         4UAV73BFCxf0b6obTGNROKIB3CZuavtDe/21mc9BWYwbraQsiyffQpPgFGZbFhqL9eSs
         8Xs7Ygfjsoia1JMQ3QMftw+SX0ermqCZPrWqLRS+UYYzfhAl523vxFY+JUmKv3EJSOwN
         xvpij66JD9nBHtjBrCjvD+Ef9lcZdamEQq+68ckMuoMamKBXu7FIfE18RGy8De7K04se
         oWbfJhpK3ZmHp0Xr/e7pVU8m8RPV9wic20zhe6wJu9xl/bllv5+Cn6mVQfrRcUu37iXU
         jMQg==
X-Gm-Message-State: AOAM532INVgNYqWx7kEZBidaga+YRFe+QnZqBTTDN9ejpbjJbwiFcS7C
        q/POsryy25lE89pAxqaDz6k=
X-Google-Smtp-Source: ABdhPJzfBkduG8GWorq5vqXudEeeqqY7DDIHV/GgblEfhwXjkDvoly9uBeT0TZ8vEn/nUOjSvFMZkA==
X-Received: by 2002:a17:90b:3698:b0:1b9:e011:b942 with SMTP id mj24-20020a17090b369800b001b9e011b942mr3811243pjb.189.1645045395416;
        Wed, 16 Feb 2022 13:03:15 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 15/50] scsi: aha1542: Remove a set-but-not-used array
Date:   Wed, 16 Feb 2022 13:01:58 -0800
Message-Id: <20220216210233.28774-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
