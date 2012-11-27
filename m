From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v3,repost 07/10] megaraid_sas: use scsi_host_alloc_node
Date: Tue, 27 Nov 2012 11:46:35 -0500
Message-ID: <1354034799-8460-8-git-send-email-jmoyer@redhat.com>
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Bart Van Assche <bvanassche@acm.org>, Neela Syam Kolli <megaraidlinux@lsi.com>
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d2c5366..707a6cd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4020,8 +4020,9 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (megasas_set_dma_mask(pdev))
 		goto fail_set_dma_mask;
 
-	host = scsi_host_alloc(&megasas_template,
-			       sizeof(struct megasas_instance));
+	host = scsi_host_alloc_node(&megasas_template,
+				    sizeof(struct megasas_instance),
+				    dev_to_node(&pdev->dev));
 
 	if (!host) {
 		printk(KERN_DEBUG "megasas: scsi_host_alloc failed\n");
-- 
1.7.1
