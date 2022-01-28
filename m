Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223A3C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344651AbiA1WU7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:20:59 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:44853 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344739AbiA1WU6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:20:58 -0500
Received: by mail-pj1-f51.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so7725947pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:20:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rxcic9Uld3j4WolnYuknQow85E0oSDDIB01CVwMdTEo=;
        b=15RqeR9mUIZk5ozPr+9Uxbe87oDhqLKkWRXNW3P9BBgpkStN1XXIlxJ8IBingIKVym
         GrFPSc0J8AxyvrBc6GCx/LWAokQDngyGuwYf0OKugMCunPwmWfkWBJmf/g6ZN78aPoK+
         h8BsMpYwl0aesut7kPHjUdRCUGgmSraOj56G7KfEWrMhfKvLfG8i9vdqwDBlH0XeeWqs
         /695QjxeYCkk7a8AMIxUNMOG7O9T8CrRycKsFPL/LXRsRNBTcQF70UPEdd+ZstdZYZ+b
         E2iNIACpyrL++YM5djy4c7oxN91ngMKjGAXQ8kYszyueO2/b7/1sUZ8mIqqJUKSXslTS
         g+lg==
X-Gm-Message-State: AOAM530FliFC0zmoPF4gh//QVlOXwNm8F6Zr9z5GbRHJtafl3XcROh08
        tl4GDS8JCizUhGB2eNoviLs=
X-Google-Smtp-Source: ABdhPJzSB+tLQK0Y1PTT3Moe4Nwb9Qc08ZGtExSGCLvgArIXFwVsi4e1RzWAqx+5t9nHOfiXLt8RUA==
X-Received: by 2002:a17:902:e88b:: with SMTP id w11mr10078013plg.153.1643408457488;
        Fri, 28 Jan 2022 14:20:57 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:20:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 11/44] aha1542: Remove a set-but-not-used array
Date:   Fri, 28 Jan 2022 14:18:36 -0800
Message-Id: <20220128221909.8141-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following W=1 warning:

drivers/scsi/aha1542.c:209:12: warning: variable ‘inquiry_result’ set but not used [-Wunused-but-set-variable]
  209 |         u8 inquiry_result[4];

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha1542.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index f0e8ae9f5e40..c7a735e581c8 100644
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
+		inb(DATA(sh->io_port));
 	}
 
 	/* Reading port should reset DF */
