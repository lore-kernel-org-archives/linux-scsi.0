From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 1 02/25] hpsa: remove unused hpsa_tag_discard_error_bits
Date: Wed, 28 Oct 2015 17:04:41 -0500
Message-ID: <20151028220441.5323.9715.stgit@brunhilda>
References: <20151028215206.5323.84194.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:48749 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbbJ1WI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Oct 2015 18:08:27 -0400
In-Reply-To: <20151028215206.5323.84194.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

This function is no longer used.

Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e60c652..864fb03 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -230,6 +230,8 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 	int cmd_type);
 static void hpsa_free_cmd_pool(struct ctlr_info *h);
 #define VPD_PAGE (1 << 8)
+#define HPSA_PERF_ERROR_BITS ((1 << DIRECT_LOOKUP_SHIFT) - 1)
+#define HPSA_SIMPLE_ERROR_BITS 0x03
 
 static int hpsa_scsi_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static void hpsa_scan_start(struct Scsi_Host *);
@@ -6438,16 +6440,6 @@ static inline void finish_cmd(struct CommandList *c)
 		complete(c->waiting);
 }
 
-
-static inline u32 hpsa_tag_discard_error_bits(struct ctlr_info *h, u32 tag)
-{
-#define HPSA_PERF_ERROR_BITS ((1 << DIRECT_LOOKUP_SHIFT) - 1)
-#define HPSA_SIMPLE_ERROR_BITS 0x03
-	if (unlikely(!(h->transMethod & CFGTBL_Trans_Performant)))
-		return tag & ~HPSA_SIMPLE_ERROR_BITS;
-	return tag & ~HPSA_PERF_ERROR_BITS;
-}
-
 /* process completion of an indexed ("direct lookup") command */
 static inline void process_indexed_cmd(struct ctlr_info *h,
 	u32 raw_tag)

