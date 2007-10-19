From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/8] qla2xxx: Correct display of ISP serial-number.
Date: Fri, 19 Oct 2007 15:59:19 -0700
Message-ID: <1192834760-573-7-git-send-email-andrew.vasquez@qlogic.com>
References: <20071019225824.GG24197@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29152 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966634AbXJSW7k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 18:59:40 -0400
In-Reply-To: <20071019225824.GG24197@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The original serial-number calculations based on WWPN no longer
apply to newer ISPs (ISP24xx and ISP25xx).  These newer board's
serial number reside in the VPD.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2f0bd5a..fb388b8 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -538,6 +538,9 @@ qla2x00_serial_num_show(struct class_device *cdev, char *buf)
 	scsi_qla_host_t *ha = shost_priv(class_to_shost(cdev));
 	uint32_t sn;
 
+	if (IS_FWI2_CAPABLE(ha))
+		return snprintf(buf, PAGE_SIZE, "\n");
+
 	sn = ((ha->serial0 & 0x1f) << 16) | (ha->serial2 << 8) | ha->serial1;
 	return snprintf(buf, PAGE_SIZE, "%c%05d\n", 'A' + sn / 100000,
 	    sn % 100000);
-- 
1.5.3.4.206.g58ba4

