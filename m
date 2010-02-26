From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/9] cciss: factor out scatter gather chain block allocation
	and freeing
Date: Fri, 26 Feb 2010 16:01:22 -0600
Message-ID: <20100226220122.11979.60399.stgit@beardog.cce.hp.com>
References: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, james.bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: factor out scatter gather chain block allocation and freeing
Rationale is that I want to use this code from the scsi half of the
driver.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |  108 ++++++++++++++++++++++++++-----------------------
 1 files changed, 58 insertions(+), 50 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index cd8c7c2..eddb916 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -257,6 +257,59 @@ static inline void removeQ(CommandList_struct *c)
 	hlist_del_init(&c->list);
 }
 
+static void cciss_free_sg_chain_blocks(struct Cmd_sg_list **cmd_sg_list,
+	int nr_cmds)
+{
+	int i;
+
+	if (!cmd_sg_list)
+		return;
+	for (i = 0; i < nr_cmds; i++) {
+		if (cmd_sg_list[i]) {
+			kfree(cmd_sg_list[i]->sgchain);
+			kfree(cmd_sg_list[i]);
+			cmd_sg_list[i] = NULL;
+		}
+	}
+	kfree(cmd_sg_list);
+}
+
+static struct Cmd_sg_list **cciss_allocate_sg_chain_blocks(ctlr_info_t *h,
+	int chainsize, int nr_cmds)
+{
+	int j;
+	struct Cmd_sg_list **cmd_sg_list;
+
+	if (chainsize <= 0)
+		return NULL;
+
+	cmd_sg_list = kmalloc(sizeof(*cmd_sg_list) * nr_cmds, GFP_KERNEL);
+	if (!cmd_sg_list)
+		return NULL;
+
+	/* Build up chain blocks for each command */
+	for (j = 0; j < nr_cmds; j++) {
+		cmd_sg_list[j] = kmalloc(sizeof(*cmd_sg_list[j]), GFP_KERNEL);
+		if (!cmd_sg_list[j]) {
+			dev_err(&h->pdev->dev, "Cannot get memory "
+				"for chain block.\n");
+			goto clean;
+		}
+		/* Need a block of chainsized s/g elements. */
+		cmd_sg_list[j]->sgchain = kmalloc((chainsize *
+			sizeof(SGDescriptor_struct)), GFP_KERNEL);
+		if (!cmd_sg_list[j]->sgchain) {
+			dev_err(&h->pdev->dev, "Cannot get memory "
+				"for s/g chains.\n");
+			goto clean;
+		}
+	}
+	return cmd_sg_list;
+clean:
+	cciss_free_sg_chain_blocks(cmd_sg_list, nr_cmds);
+	return NULL;
+}
+
 #include "cciss_scsi.c"		/* For SCSI tape support */
 
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
@@ -4238,37 +4291,10 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 			goto clean4;
 		}
 	}
-	hba[i]->cmd_sg_list = kmalloc(sizeof(struct Cmd_sg_list *) *
-						hba[i]->nr_cmds,
-						GFP_KERNEL);
-	if (!hba[i]->cmd_sg_list) {
-		printk(KERN_ERR "cciss%d: Cannot get memory for "
-			"s/g chaining.\n", i);
+	hba[i]->cmd_sg_list = cciss_allocate_sg_chain_blocks(hba[i],
+		hba[i]->chainsize, hba[i]->nr_cmds);
+	if (!hba[i]->cmd_sg_list && hba[i]->chainsize > 0)
 		goto clean4;
-	}
-	/* Build up chain blocks for each command */
-	if (hba[i]->chainsize > 0) {
-		for (j = 0; j < hba[i]->nr_cmds; j++) {
-			hba[i]->cmd_sg_list[j] =
-					kmalloc(sizeof(struct Cmd_sg_list),
-							GFP_KERNEL);
-			if (!hba[i]->cmd_sg_list[j]) {
-				printk(KERN_ERR "cciss%d: Cannot get memory "
-					"for chain block.\n", i);
-				goto clean4;
-			}
-			/* Need a block of chainsized s/g elements. */
-			hba[i]->cmd_sg_list[j]->sgchain =
-					kmalloc((hba[i]->chainsize *
-						sizeof(SGDescriptor_struct)),
-						GFP_KERNEL);
-			if (!hba[i]->cmd_sg_list[j]->sgchain) {
-				printk(KERN_ERR "cciss%d: Cannot get memory "
-					"for s/g chains\n", i);
-				goto clean4;
-			}
-		}
-	}
 
 	spin_lock_init(&hba[i]->lock);
 
@@ -4327,16 +4353,7 @@ clean4:
 	for (k = 0; k < hba[i]->nr_cmds; k++)
 		kfree(hba[i]->scatter_list[k]);
 	kfree(hba[i]->scatter_list);
-	/* Only free up extra s/g lists if controller supports them */
-	if (hba[i]->chainsize > 0) {
-		for (j = 0; j < hba[i]->nr_cmds; j++) {
-			if (hba[i]->cmd_sg_list[j]) {
-				kfree(hba[i]->cmd_sg_list[j]->sgchain);
-				kfree(hba[i]->cmd_sg_list[j]);
-			}
-		}
-		kfree(hba[i]->cmd_sg_list);
-	}
+	cciss_free_sg_chain_blocks(hba[i]->cmd_sg_list, hba[i]->nr_cmds);
 	if (hba[i]->cmd_pool)
 		pci_free_consistent(hba[i]->pdev,
 				    hba[i]->nr_cmds * sizeof(CommandList_struct),
@@ -4454,16 +4471,7 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 	for (j = 0; j < hba[i]->nr_cmds; j++)
 		kfree(hba[i]->scatter_list[j]);
 	kfree(hba[i]->scatter_list);
-	/* Only free up extra s/g lists if controller supports them */
-	if (hba[i]->chainsize > 0) {
-		for (j = 0; j < hba[i]->nr_cmds; j++) {
-			if (hba[i]->cmd_sg_list[j]) {
-				kfree(hba[i]->cmd_sg_list[j]->sgchain);
-				kfree(hba[i]->cmd_sg_list[j]);
-			}
-		}
-		kfree(hba[i]->cmd_sg_list);
-	}
+	cciss_free_sg_chain_blocks(hba[i]->cmd_sg_list, hba[i]->nr_cmds);
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
