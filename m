From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 02/35] hpsa: mark last scatter gather element as the last
Date: Tue, 18 Feb 2014 13:55:12 -0600
Message-ID: <20140218195512.15787.4452.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43485 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaBRT4j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:56:39 -0500
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 453D7613FF
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:56:39 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Matt Gates <matt.gates@hp.com>

This is normally optional, but for SSD Smart Path support (in
subsequent patches) it is required.

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |    8 ++++----
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index efaad6a..d858f8c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1438,6 +1438,7 @@ static int hpsa_map_one(struct pci_dev *pdev,
 	cp->SG[0].Addr.upper =
 	  (u32) ((addr64 >> 32) & (u64) 0x00000000FFFFFFFF);
 	cp->SG[0].Len = buflen;
+	cp->SG[0].Ext = HPSA_SG_LAST; /* we are not chaining */
 	cp->Header.SGList = (u8) 1;   /* no. SGs contig in this cmd */
 	cp->Header.SGTotal = (u16) 1; /* total sgs in this cmd list */
 	return 0;
@@ -2139,7 +2140,7 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 		curr_sg->Addr.lower = (u32) (addr64 & 0x0FFFFFFFFULL);
 		curr_sg->Addr.upper = (u32) ((addr64 >> 32) & 0x0FFFFFFFFULL);
 		curr_sg->Len = len;
-		curr_sg->Ext = 0;  /* we are not chaining */
+		curr_sg->Ext = (i < scsi_sg_count(cmd) - 1) ? 0 : HPSA_SG_LAST;
 		curr_sg++;
 	}
 
@@ -3041,7 +3042,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		c->SG[0].Addr.lower = temp64.val32.lower;
 		c->SG[0].Addr.upper = temp64.val32.upper;
 		c->SG[0].Len = iocommand.buf_size;
-		c->SG[0].Ext = 0; /* we are not chaining*/
+		c->SG[0].Ext = HPSA_SG_LAST; /* we are not chaining*/
 	}
 	hpsa_scsi_do_simple_cmd_core_if_no_lockup(h, c);
 	if (iocommand.buf_size > 0)
@@ -3171,8 +3172,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 			c->SG[i].Addr.lower = temp64.val32.lower;
 			c->SG[i].Addr.upper = temp64.val32.upper;
 			c->SG[i].Len = buff_size[i];
-			/* we are not chaining */
-			c->SG[i].Ext = 0;
+			c->SG[i].Ext = i < sg_used - 1 ? 0 : HPSA_SG_LAST;
 		}
 	}
 	hpsa_scsi_do_simple_cmd_core_if_no_lockup(h, c);
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 3f96b66..22cf799 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -25,6 +25,7 @@
 #define SENSEINFOBYTES          32 /* may vary between hbas */
 #define SG_ENTRIES_IN_CMD	32 /* Max SG entries excluding chain blocks */
 #define HPSA_SG_CHAIN		0x80000000
+#define HPSA_SG_LAST		0x40000000
 #define MAXREPLYQS              256
 
 /* Command Status value */

