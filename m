From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 12/22] qla2xxx: Fix undefined behavior in call to snprintf().
Date: Wed, 30 Oct 2013 03:38:19 -0400
Message-ID: <1383118709-5569-13-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.156.153] ([67.231.156.153]:22962 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752924Ab3J3ILY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:24 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3464782..2a14df8 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -917,8 +917,8 @@ qla2x00_serial_num_show(struct device *dev, struct device_attribute *attr,
 		return snprintf(buf, PAGE_SIZE, "%s\n",
 		    vha->hw->mr.serial_num);
 	} else if (IS_FWI2_CAPABLE(ha)) {
-		qla2xxx_get_vpd_field(vha, "SN", buf, PAGE_SIZE);
-		return snprintf(buf, PAGE_SIZE, "%s\n", buf);
+		qla2xxx_get_vpd_field(vha, "SN", buf, PAGE_SIZE - 1);
+		return strlen(strcat(buf, "\n"));
 	}
 
 	sn = ((ha->serial0 & 0x1f) << 16) | (ha->serial2 << 8) | ha->serial1;
-- 
1.7.7

