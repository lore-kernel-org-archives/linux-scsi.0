From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH] scsi: ses: fix some risks of out of bound access
Date: Mon, 25 Mar 2019 15:40:02 +0800
Message-ID: <1553499602-27810-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We have some places with risk of accessing out of bound of the
buffer allocated from slab, even it could corrupt the memory.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 drivers/scsi/ses.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0fc3922..42e6a1f 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -520,6 +520,7 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 	struct ses_device *ses_dev = edev->scratch;
 	int types = ses_dev->page1_num_types;
 	unsigned char *hdr_buf = kzalloc(INIT_ALLOC_SIZE, GFP_KERNEL);
+	unsigned char *page1_end = ses_dev->page1 + ses_dev->page1_len;
 
 	if (!hdr_buf)
 		goto simple_populate;
@@ -556,6 +557,11 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 	type_ptr = ses_dev->page1_types;
 	components = 0;
 	for (i = 0; i < types; i++, type_ptr += 4) {
+		if (type_ptr > page1_end - 2) {
+			sdev_printk(KERN_ERR, sdev, "Access out of bound of page1"
+					"%p page1_end %p\n", page1_end, type_ptr);
+			break;
+		}
 		for (j = 0; j < type_ptr[1]; j++) {
 			char *name = NULL;
 			struct enclosure_component *ecomp;
@@ -566,10 +572,15 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 				} else {
 					len = (desc_ptr[2] << 8) + desc_ptr[3];
 					desc_ptr += 4;
-					/* Add trailing zero - pushes into
-					 * reserved space */
-					desc_ptr[len] = '\0';
-					name = desc_ptr;
+					if (desc_ptr + len >= buf + page7_len) {
+						desc_ptr = NULL;
+					} else {
+
+						/* Add trailing zero - pushes into
+						 * reserved space */
+						desc_ptr[len] = '\0';
+						name = desc_ptr;
+					}
 				}
 			}
 			if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
@@ -693,7 +704,13 @@ static int ses_intf_add(struct device *cdev,
 	/* begin at the enclosure descriptor */
 	type_ptr = buf + 8;
 	/* skip all the enclosure descriptors */
-	for (i = 0; i < num_enclosures && type_ptr < buf + len; i++) {
+	for (i = 0; i < num_enclosures; i++) {
+		if (type_ptr >= buf + len) {
+			sdev_printk(KERN_ERR, sdev, "Overflow the buf len = %d\n", len);
+			err = -EINVAL;
+			goto err_free;
+		}
+
 		types += type_ptr[2];
 		type_ptr += type_ptr[3] + 4;
 	}
-- 
2.7.4
