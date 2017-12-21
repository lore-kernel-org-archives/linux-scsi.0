From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] ses: make initial allocation size configurable
Date: Thu, 21 Dec 2017 12:22:32 +0100
Message-ID: <1513855354-86603-2-git-send-email-hare@suse.de>
References: <1513855354-86603-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752107AbdLULWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 06:22:38 -0500
In-Reply-To: <1513855354-86603-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Some storage arrays have an incorrect SES implementation which will
always return the allocation length of the CDB instead of the true
length of the requested page.
With this patch one can modify the initial allocation size to
get the full output of those arrays.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ses.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 11826c5..e8ffee1 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -51,6 +51,13 @@ struct ses_component {
 	u64 addr;
 };
 
+#define INIT_ALLOC_SIZE 32
+
+static unsigned long ses_alloc_size = INIT_ALLOC_SIZE;
+
+module_param_named(alloc_size, ses_alloc_size, ulong, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(alloc_size, "initial allocation length");
+
 static bool ses_page2_supported(struct enclosure_device *edev)
 {
 	struct ses_device *ses_dev = edev->scratch;
@@ -508,8 +515,6 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
 	return 0;
 }
 
-#define INIT_ALLOC_SIZE 32
-
 static void ses_enclosure_data_process(struct enclosure_device *edev,
 				       struct scsi_device *sdev,
 				       int create)
@@ -519,7 +524,7 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 	int i, j, page7_len, len, components;
 	struct ses_device *ses_dev = edev->scratch;
 	int types = ses_dev->page1_num_types;
-	unsigned char *hdr_buf = kzalloc(INIT_ALLOC_SIZE, GFP_KERNEL);
+	unsigned char *hdr_buf = kzalloc(ses_alloc_size, GFP_KERNEL);
 
 	if (!hdr_buf)
 		goto simple_populate;
@@ -528,7 +533,7 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 	if (ses_dev->page10)
 		ses_recv_diag(sdev, 10, ses_dev->page10, ses_dev->page10_len);
 	/* Page 7 for the descriptors is optional */
-	result = ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
+	result = ses_recv_diag(sdev, 7, hdr_buf, ses_alloc_size);
 	if (result)
 		goto simple_populate;
 
@@ -663,12 +668,12 @@ static int ses_intf_add(struct device *cdev,
 		sdev_printk(KERN_NOTICE, sdev, "Embedded Enclosure Device\n");
 
 	ses_dev = kzalloc(sizeof(*ses_dev), GFP_KERNEL);
-	hdr_buf = kzalloc(INIT_ALLOC_SIZE, GFP_KERNEL);
+	hdr_buf = kzalloc(ses_alloc_size, GFP_KERNEL);
 	if (!hdr_buf || !ses_dev)
 		goto err_init_free;
 
 	page = 1;
-	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
+	result = ses_recv_diag(sdev, page, hdr_buf, ses_alloc_size);
 	if (result)
 		goto recv_failed;
 
@@ -708,7 +713,7 @@ static int ses_intf_add(struct device *cdev,
 	buf = NULL;
 
 	page = 2;
-	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
+	result = ses_recv_diag(sdev, page, hdr_buf, ses_alloc_size);
 	if (result)
 		goto page2_not_supported;
 
@@ -728,7 +733,7 @@ static int ses_intf_add(struct device *cdev,
 	/* The additional information page --- allows us
 	 * to match up the devices */
 	page = 10;
-	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
+	result = ses_recv_diag(sdev, page, hdr_buf, ses_alloc_size);
 	if (!result) {
 
 		len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
-- 
1.8.5.6
