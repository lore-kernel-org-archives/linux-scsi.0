From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 01/10] hpsa: fix per device memory leak on driver unload
Date: Thu, 19 Jan 2012 14:00:42 -0600
Message-ID: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3ecb703..e9b1aa8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4480,6 +4480,14 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 #endif				/* CONFIG_PCI_MSI */
 }
 
+static void __devexit hpsa_free_device_info(struct ctlr_info *h)
+{
+	int i;
+
+	for (i = 0; i < h->ndevices; i++)
+		kfree(h->dev[i]);
+}
+
 static void __devexit hpsa_remove_one(struct pci_dev *pdev)
 {
 	struct ctlr_info *h;
@@ -4495,6 +4503,7 @@ static void __devexit hpsa_remove_one(struct pci_dev *pdev)
 	iounmap(h->vaddr);
 	iounmap(h->transtable);
 	iounmap(h->cfgtable);
+	hpsa_free_device_info(h);
 	hpsa_free_sg_chain_blocks(h);
 	pci_free_consistent(h->pdev,
 		h->nr_cmds * sizeof(struct CommandList),
