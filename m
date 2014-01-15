From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 22/41] hpsa: get physical device handles for io accel mode 2
	as well as mode 1
Date: Wed, 15 Jan 2014 16:38:11 -0600
Message-ID: <20140115223811.5061.38997.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:45512 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaAOViM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:38:12 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Mike MIller <mikem@beardog.cce.hp.com>

Signed-off-by: Mike MIller <mikem@beardog.cce.hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f0bd511..e471782 100644
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

