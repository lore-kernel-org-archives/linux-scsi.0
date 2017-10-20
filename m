From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 04/12] hpsa: add controller checkpoint
Date: Fri, 20 Oct 2017 16:51:26 -0500
Message-ID: <150853628650.28275.7433236747576438555.stgit@brunhilda>
References: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0058.outbound.protection.outlook.com ([104.47.33.58]:43149
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752816AbdJTVwN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Oct 2017 17:52:13 -0400
In-Reply-To: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

tell hpsa controller to generate a checkpoint for rare lockup
conditions.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c     |    4 ++++
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0330f17..9c491c5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8009,6 +8009,10 @@ static void controller_lockup_detected(struct ctlr_info *h)
 	spin_unlock_irqrestore(&h->lock, flags);
 	dev_warn(&h->pdev->dev, "Controller lockup detected: 0x%08x after %d\n",
 			lockup_detected, h->heartbeat_sample_interval / HZ);
+	if (lockup_detected == 0xffff0000) {
+		dev_warn(&h->pdev->dev, "Telling controller to do a CHKPT\n");
+		writel(DOORBELL_GENERATE_CHKPT, h->vaddr + SA5_DOORBELL);
+	}
 	pci_disable_device(h->pdev);
 	fail_all_outstanding_cmds(h);
 }
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 078afe4..78c3b64 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -142,6 +142,7 @@
 #define DOORBELL_CTLR_RESET	0x00000004l
 #define DOORBELL_CTLR_RESET2	0x00000020l
 #define DOORBELL_CLEAR_EVENTS	0x00000040l
+#define DOORBELL_GENERATE_CHKPT	0x00000080l
 
 #define CFGTBL_Trans_Simple     0x00000002l
 #define CFGTBL_Trans_Performant 0x00000004l
