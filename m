From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/13] cciss: limit commands allocated on reset_devices
Date: Fri, 08 Oct 2010 15:06:42 -0500
Message-ID: <20101008200642.24279.43191.stgit@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is to conserve memory in a memory-limited kdump scenario

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 7741e3b..08cbee8 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4059,6 +4059,11 @@ static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
 static void __devinit cciss_get_max_perf_mode_cmds(struct ctlr_info *h)
 {
 	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+
+	/* Limit commands in memory limited kdump scenario. */
+	if (reset_devices && h->max_commands > 32)
+		h->max_commands = 32;
+
 	if (h->max_commands < 16) {
 		dev_warn(&h->pdev->dev, "Controller reports "
 			"max supported commands of %d, an obvious lie. "
