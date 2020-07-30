Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EEBC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 15:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9121F2082E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 15:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbgG3Pfl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 11:35:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:20441 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729861AbgG3Pfk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Jul 2020 11:35:40 -0400
IronPort-SDR: NtRe7DdtQiQbVsH4J5hymtmHiLAk2XfcS/GpWSPGbIdjDP+m+e9I2gKzW7ojG/j4U1rleXGmwP
 0b0SU52/gHxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149454071"
X-IronPort-AV: E=Sophos;i="5.75,414,1589266800"; 
   d="scan'208";a="149454071"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 08:35:39 -0700
IronPort-SDR: IkXGFx8stSsDUm1kUQOOF/WOn4jgxX32ltl7N/vBBLc/py/KDpcaVbzqJ7B7rvJ/M68b/JISiQ
 zNtR9q+a/94g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,414,1589266800"; 
   d="scan'208";a="395017700"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jul 2020 08:35:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 4D851119; Thu, 30 Jul 2020 18:35:36 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>, dc395x@twibble.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] scsi: dc395x: use %*ph to print small buffer
Date:   Thu, 30 Jul 2020 18:35:35 +0300
Message-Id: <20200730153535.39691-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use %*ph format to print small buffer as hex string.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/dc395x.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 37c6cc374079..434758dde9b4 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4504,14 +4504,8 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 	/*seq_printf(m, "\n"); */
 
 	seq_printf(m, "Nr of DCBs: %i\n", list_size(&acb->dcb_list));
-	seq_printf(m, "Map of attached LUNs: %02x %02x %02x %02x %02x %02x %02x %02x\n",
-	     acb->dcb_map[0], acb->dcb_map[1], acb->dcb_map[2],
-	     acb->dcb_map[3], acb->dcb_map[4], acb->dcb_map[5],
-	     acb->dcb_map[6], acb->dcb_map[7]);
-	seq_printf(m, "                      %02x %02x %02x %02x %02x %02x %02x %02x\n",
-	     acb->dcb_map[8], acb->dcb_map[9], acb->dcb_map[10],
-	     acb->dcb_map[11], acb->dcb_map[12], acb->dcb_map[13],
-	     acb->dcb_map[14], acb->dcb_map[15]);
+	seq_printf(m, "Map of attached LUNs: %8ph\n", &acb->dcb_map[0]);
+	seq_printf(m, "                      %8ph\n", &acb->dcb_map[8]);
 
 	seq_puts(m,
 		 "Un ID LUN Prty Sync Wide DsCn SndS TagQ nego_period SyncFreq SyncOffs MaxCmd\n");
-- 
2.27.0

