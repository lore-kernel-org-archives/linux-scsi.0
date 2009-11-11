From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 13/17] hpsa: Retry driver initiated commands on unit attention
Date: Wed, 11 Nov 2009 10:51:29 -0600
Message-ID: <20091111165129.17754.71091.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758175AbZKKQuI@vger.kernel.org>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

hpsa: Retry driver initiated commands on unit attention.
There are a some commands initiated by the driver which
are neither ioctls nor normal i/o.  If any of these commands
completes with UNIT ATTENTION, they should be retried.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6f63d45..e3b80fa 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1173,7 +1173,7 @@ static void hpsa_map_one(struct pci_dev *pdev,
 	cp->Header.SGTotal = (__u16) 1; /* total sgs in this cmd list */
 }
 
-static void hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
+static inline void hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
 	struct CommandList *c)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
@@ -1183,6 +1183,19 @@ static void hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
 	wait_for_completion(&wait);
 }
 
+static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
+	struct CommandList *c, int data_direction)
+{
+	int retry_count = 0;
+
+	do {
+		memset(c->err_info, 0, sizeof(c->err_info));
+		hpsa_scsi_do_simple_cmd_core(h, c);
+		retry_count++;
+	} while (check_for_unit_attention(h, c) && retry_count <= 3);
+	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
+}
+
 static void hpsa_scsi_interpret_error(struct CommandList *cp)
 {
 	struct ErrorInfo *ei;
@@ -1262,9 +1275,7 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 	rc = fill_cmd(c, HPSA_INQUIRY, h, buf, bufsize, page, scsi3addr,
 		TYPE_CMD);
 	if (rc == 0) {
-		hpsa_scsi_do_simple_cmd_core(h, c);
-		hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_FROMDEVICE);
-
+		hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
 		ei = c->err_info;
 		if (ei->CommandStatus != 0 &&
 		    ei->CommandStatus != CMD_DATA_UNDERRUN) {
@@ -1369,8 +1380,7 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 
 	if (extended_response)
 		c->Request.CDB[1] = extended_response;
-	hpsa_scsi_do_simple_cmd_core(h, c);
-	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_FROMDEVICE);
+	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 &&
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
