From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 03/10] hpsa: combine hpsa_scsi_detect and hpsa_register_scsi
Date: Thu, 19 Jan 2012 14:00:53 -0600
Message-ID: <20120119200053.17835.45127.stgit@beardog.cce.hp.com>
References: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:32541 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab2ASULx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2012 15:11:53 -0500
In-Reply-To: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org, stable@kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa_register_scsi just calls hpsa_scsi_detect.  Move
the guts of hpsa_scsi_detect into hpsa_register_scsi and
get rid of hpsa_scsi_detect.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   81 ++++++++++++++++++++++-----------------------------
 1 files changed, 35 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d70d59c..d191e3f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1255,46 +1255,6 @@ static void complete_scsi_command(struct CommandList *cp)
 	cmd_free(h, cp);
 }
 
-static int hpsa_scsi_detect(struct ctlr_info *h)
-{
-	struct Scsi_Host *sh;
-	int error;
-
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
-	if (sh == NULL)
-		goto fail;
-
-	sh->io_port = 0;
-	sh->n_io_port = 0;
-	sh->this_id = -1;
-	sh->max_channel = 3;
-	sh->max_cmd_len = MAX_COMMAND_SIZE;
-	sh->max_lun = HPSA_MAX_LUN;
-	sh->max_id = HPSA_MAX_LUN;
-	sh->can_queue = h->nr_cmds;
-	sh->cmd_per_lun = h->nr_cmds;
-	sh->sg_tablesize = h->maxsgentries;
-	h->scsi_host = sh;
-	sh->hostdata[0] = (unsigned long) h;
-	sh->irq = h->intr[h->intr_mode];
-	sh->unique_id = sh->irq;
-	error = scsi_add_host(sh, &h->pdev->dev);
-	if (error)
-		goto fail_host_put;
-	scsi_scan_host(sh);
-	return 0;
-
- fail_host_put:
-	dev_err(&h->pdev->dev, "hpsa_scsi_detect: scsi_add_host"
-		" failed for controller %d\n", h->ctlr);
-	scsi_host_put(sh);
-	return error;
- fail:
-	dev_err(&h->pdev->dev, "hpsa_scsi_detect: scsi_host_alloc"
-		" failed for controller %d\n", h->ctlr);
-	return -ENOMEM;
-}
-
 static void hpsa_pci_unmap(struct pci_dev *pdev,
 	struct CommandList *c, int sg_used, int data_direction)
 {
@@ -2226,13 +2186,42 @@ static void hpsa_unregister_scsi(struct ctlr_info *h)
 
 static int hpsa_register_scsi(struct ctlr_info *h)
 {
-	int rc;
+	struct Scsi_Host *sh;
+	int error;
 
-	rc = hpsa_scsi_detect(h);
-	if (rc != 0)
-		dev_err(&h->pdev->dev, "hpsa_register_scsi: failed"
-			" hpsa_scsi_detect(), rc is %d\n", rc);
-	return rc;
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
+	if (sh == NULL)
+		goto fail;
+
+	sh->io_port = 0;
+	sh->n_io_port = 0;
+	sh->this_id = -1;
+	sh->max_channel = 3;
+	sh->max_cmd_len = MAX_COMMAND_SIZE;
+	sh->max_lun = HPSA_MAX_LUN;
+	sh->max_id = HPSA_MAX_LUN;
+	sh->can_queue = h->nr_cmds;
+	sh->cmd_per_lun = h->nr_cmds;
+	sh->sg_tablesize = h->maxsgentries;
+	h->scsi_host = sh;
+	sh->hostdata[0] = (unsigned long) h;
+	sh->irq = h->intr[h->intr_mode];
+	sh->unique_id = sh->irq;
+	error = scsi_add_host(sh, &h->pdev->dev);
+	if (error)
+		goto fail_host_put;
+	scsi_scan_host(sh);
+	return 0;
+
+ fail_host_put:
+	dev_err(&h->pdev->dev, "%s: scsi_add_host"
+		" failed for controller %d\n", __func__, h->ctlr);
+	scsi_host_put(sh);
+	return error;
+ fail:
+	dev_err(&h->pdev->dev, "%s: scsi_host_alloc"
+		" failed for controller %d\n", __func__, h->ctlr);
+	return -ENOMEM;
 }
 
 static int wait_for_device_to_become_ready(struct ctlr_info *h,

