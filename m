From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 06/11] hpsa: limit commands allocated on reset_devices
Date: Thu, 06 Jan 2011 14:48:13 -0600
Message-ID: <20110106204813.10753.83892.stgit@beardog.cce.hp.com>
References: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is to conserve memory in a memory-limited kdump scenario

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 82b94e2..688b243 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3470,6 +3470,11 @@ static int __devinit hpsa_find_cfgtables(struct ctlr_info *h)
 static void __devinit hpsa_get_max_perf_mode_cmds(struct ctlr_info *h)
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
