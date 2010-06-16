From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 9/9] hpsa: sanitize max commands
Date: Wed, 16 Jun 2010 13:51:56 -0500
Message-ID: <20100616185156.22798.45497.stgit@beardog.cce.hp.com>
References: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26922 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab0FPSq5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:46:57 -0400
In-Reply-To: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andriusb@redhat.com, James.Bottomley@HansenPartnership.com, dab@hp.com, thenzl@redhat.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: sanitize max commands
Some controllers might try to tell us they support 0 commands
in performant mode.  This is a lie told by buggy firmware.
We have to be wary of this lest we try to allocate a negative
number of command blocks, which will be treated as unsigned,
and get an out of memory condition.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8f11325..304c908 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3505,13 +3505,25 @@ static int __devinit hpsa_find_cfgtables(struct ctlr_info *h)
 	return 0;
 }
 
+static void __devinit hpsa_get_max_perf_mode_cmds(struct ctlr_info *h)
+{
+	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+	if (h->max_commands < 16) {
+		dev_warn(&h->pdev->dev, "Controller reports "
+			"max supported commands of %d, an obvious lie. "
+			"Using 16.  Ensure that firmware is up to date.\n",
+			h->max_commands);
+		h->max_commands = 16;
+	}
+}
+
 /* Interrogate the hardware for some limits:
  * max commands, max SG elements without chaining, and with chaining,
  * SG chain block size, etc.
  */
 static void __devinit hpsa_find_board_params(struct ctlr_info *h)
 {
-	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+	hpsa_get_max_perf_mode_cmds(h);
 	h->nr_cmds = h->max_commands - 4; /* Allow room for some ioctls */
 	h->maxsgentries = readl(&(h->cfgtable->MaxScatterGatherElements));
 	/*
@@ -4056,7 +4068,7 @@ static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	if (!(trans_support & PERFORMANT_MODE))
 		return;
 
-	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+	hpsa_get_max_perf_mode_cmds(h);
 	h->max_sg_entries = 32;
 	/* Performant mode ring buffer and supporting data structures */
 	h->reply_pool_size = h->max_commands * sizeof(u64);

