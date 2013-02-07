From: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] scsi: qla2xxx/qla_attr.c: fix undefined behavior in using snprintf
Date: Thu,  7 Feb 2013 16:50:22 +0100
Message-ID: <1360252222-30877-1-git-send-email-dinggnu@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:53352 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3BGPuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2013 10:50:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>

The original code
	snprintf(buf, PAGE_SIZE, "%s\n", buf);
uses buf as both source and destination string, which is undefined behavior
based on C11:
	If copying takes place between objects
	that overlap, the behavior is undefined.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 83d7984..ded7383 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -887,10 +887,16 @@ qla2x00_serial_num_show(struct device *dev, struct device_attribute *attr,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t sn;
+	ssize_t bn;
 
 	if (IS_FWI2_CAPABLE(ha)) {
 		qla2xxx_get_vpd_field(vha, "SN", buf, PAGE_SIZE);
-		return snprintf(buf, PAGE_SIZE, "%s\n", buf);
+		bn = strlen(buf);
+		if (bn < PAGE_SIZE - 1) {
+			buf[bn] = '\n';
+			buf[bn + 1] = '\0';
+		}
+		return bn + 1;
 	}
 
 	sn = ((ha->serial0 & 0x1f) << 16) | (ha->serial2 << 8) | ha->serial1;
-- 
1.7.9.5

