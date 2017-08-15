From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] ses: make page2 support optional
Date: Tue, 15 Aug 2017 10:21:43 +0200
Message-ID: <1502785303-41870-5-git-send-email-hare@suse.de>
References: <1502785303-41870-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36886 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751451AbdHOIVt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 04:21:49 -0400
In-Reply-To: <1502785303-41870-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Simple subenclosures do not need to support SES page 2, so make
it optional.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ses.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 46984cd..c52d110 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -51,6 +51,13 @@ struct ses_component {
 	u64 addr;
 };
 
+static bool ses_page2_supported(struct enclosure_device *edev)
+{
+	struct ses_device *ses_dev = edev->scratch;
+
+	return (ses_dev->page2 != NULL);
+}
+
 static int ses_probe(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -204,6 +211,10 @@ static void ses_get_fault(struct enclosure_device *edev,
 {
 	unsigned char *desc;
 
+	if (!ses_page2_supported(edev)) {
+		ecomp->fault = 0;
+		return;
+	}
 	desc = ses_get_page2_descriptor(edev, ecomp);
 	if (desc)
 		ecomp->fault = (desc[3] & 0x60) >> 4;
@@ -216,6 +227,9 @@ static int ses_set_fault(struct enclosure_device *edev,
 	unsigned char desc[4];
 	unsigned char *desc_ptr;
 
+	if (!ses_page2_supported(edev))
+		return -EINVAL;
+
 	desc_ptr = ses_get_page2_descriptor(edev, ecomp);
 
 	if (!desc_ptr)
@@ -243,6 +257,10 @@ static void ses_get_status(struct enclosure_device *edev,
 {
 	unsigned char *desc;
 
+	if (!ses_page2_supported(edev)) {
+		ecomp->status = 0;
+		return;
+	}
 	desc = ses_get_page2_descriptor(edev, ecomp);
 	if (desc)
 		ecomp->status = (desc[0] & 0x0f);
@@ -253,6 +271,10 @@ static void ses_get_locate(struct enclosure_device *edev,
 {
 	unsigned char *desc;
 
+	if (!ses_page2_supported(edev)) {
+		ecomp->locate = 0;
+		return;
+	}
 	desc = ses_get_page2_descriptor(edev, ecomp);
 	if (desc)
 		ecomp->locate = (desc[2] & 0x02) ? 1 : 0;
@@ -265,6 +287,9 @@ static int ses_set_locate(struct enclosure_device *edev,
 	unsigned char desc[4];
 	unsigned char *desc_ptr;
 
+	if (!ses_page2_supported(edev))
+		return -EINVAL;
+
 	desc_ptr = ses_get_page2_descriptor(edev, ecomp);
 
 	if (!desc_ptr)
@@ -293,6 +318,9 @@ static int ses_set_active(struct enclosure_device *edev,
 	unsigned char desc[4];
 	unsigned char *desc_ptr;
 
+	if (!ses_page2_supported(edev))
+		return -EINVAL;
+
 	desc_ptr = ses_get_page2_descriptor(edev, ecomp);
 
 	if (!desc_ptr)
@@ -329,6 +357,11 @@ static void ses_get_power_status(struct enclosure_device *edev,
 {
 	unsigned char *desc;
 
+	if (!ses_page2_supported(edev)) {
+		ecomp->power_status = 0;
+		return;
+	}
+
 	desc = ses_get_page2_descriptor(edev, ecomp);
 	if (desc)
 		ecomp->power_status = (desc[3] & 0x10) ? 0 : 1;
@@ -341,6 +374,9 @@ static int ses_set_power_status(struct enclosure_device *edev,
 	unsigned char desc[4];
 	unsigned char *desc_ptr;
 
+	if (!ses_page2_supported(edev))
+		return -EINVAL;
+
 	desc_ptr = ses_get_page2_descriptor(edev, ecomp);
 
 	if (!desc_ptr)
@@ -674,7 +710,7 @@ static int ses_intf_add(struct device *cdev,
 	page = 2;
 	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
-		goto recv_failed;
+		goto page2_not_supported;
 
 	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
 	buf = kzalloc(len, GFP_KERNEL);
@@ -707,6 +743,7 @@ static int ses_intf_add(struct device *cdev,
 		ses_dev->page10_len = len;
 		buf = NULL;
 	}
+page2_not_supported:
 	scomp = kzalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
 		goto err_free;
-- 
1.8.5.6
