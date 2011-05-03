From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 03/16] hpsa: remove unused parameter from
	hpsa_complete_scsi_command()
Date: Tue, 03 May 2011 14:59:00 -0500
Message-ID: <20110503195900.5478.91691.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 415ad4f..8266850 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1006,8 +1006,7 @@ static void hpsa_unmap_sg_chain_block(struct ctlr_info *h,
 	pci_unmap_single(h->pdev, temp64.val, chain_sg->Len, PCI_DMA_TODEVICE);
 }
 
-static void complete_scsi_command(struct CommandList *cp,
-	int timeout, u32 tag)
+static void complete_scsi_command(struct CommandList *cp)
 {
 	struct scsi_cmnd *cmd;
 	struct ctlr_info *h;
@@ -2936,7 +2935,7 @@ static inline void finish_cmd(struct CommandList *c, u32 raw_tag)
 {
 	removeQ(c);
 	if (likely(c->cmd_type == CMD_SCSI))
-		complete_scsi_command(c, 0, raw_tag);
+		complete_scsi_command(c);
 	else if (c->cmd_type == CMD_IOCTL_PEND)
 		complete(c->waiting);
 }
