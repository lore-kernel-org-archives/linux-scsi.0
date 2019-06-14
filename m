From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.2-rc4
Date: Fri, 14 Jun 2019 15:24:03 -0700
Message-ID: <1560551043.27102.99.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

A single bug fix for hpsa.  The user visible consequences aren't clear,
but the ioaccel2 raid acceleration may misfire on the malformed request
assuming the payload is big enough to require chaining (more than 31 sg
entries).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Don Brace (1):
      scsi: hpsa: correct ioaccel2 chaining

And the diffstat:

 drivers/scsi/hpsa.c     | 7 ++++++-
 drivers/scsi/hpsa_cmd.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

With full diff below.

James

---

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1bef1da273c2..8068520cf89e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4940,7 +4940,7 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 			curr_sg->reserved[0] = 0;
 			curr_sg->reserved[1] = 0;
 			curr_sg->reserved[2] = 0;
-			curr_sg->chain_indicator = 0x80;
+			curr_sg->chain_indicator = IOACCEL2_CHAIN;
 
 			curr_sg = h->ioaccel2_cmd_sg_list[c->cmdindex];
 		}
@@ -4957,6 +4957,11 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 			curr_sg++;
 		}
 
+		/*
+		 * Set the last s/g element bit
+		 */
+		(curr_sg - 1)->chain_indicator = IOACCEL2_LAST_SG;
+
 		switch (cmd->sc_data_direction) {
 		case DMA_TO_DEVICE:
 			cp->direction &= ~IOACCEL2_DIRECTION_MASK;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 21a726e2eec6..f6afca4b2319 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -517,6 +517,7 @@ struct ioaccel2_sg_element {
 	u8 reserved[3];
 	u8 chain_indicator;
 #define IOACCEL2_CHAIN 0x80
+#define IOACCEL2_LAST_SG 0x40
 };
 
 /*
