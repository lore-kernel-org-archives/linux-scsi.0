From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 15/35] hpsa: get physical device handles for io accel mode 2
	as well as mode 1
Date: Tue, 18 Feb 2014 13:56:20 -0600
Message-ID: <20140218195620.15787.71728.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57072 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaBRT6Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:58:16 -0500
Received: from g2t2354.austin.hp.com (g2t2354.austin.hp.com [15.217.128.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 882031011
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:58:08 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Mike MIller <mikem@beardog.cce.hp.com>

Signed-off-by: Mike MIller <michael.miller@canonical.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 80acb23..5da13f0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2126,7 +2126,8 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 	*physical_mode = 0;
 
 	/* For I/O accelerator mode we need to read physical device handles */
-	if (h->transMethod & CFGTBL_Trans_io_accel1) {
+	if (h->transMethod & CFGTBL_Trans_io_accel1 ||
+		h->transMethod & CFGTBL_Trans_io_accel2) {
 		*physical_mode = HPSA_REPORT_PHYS_EXTENDED;
 		physical_entry_size = 24;
 	}

