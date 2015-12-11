From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] ses: fix additional element traversal bug
Date: Fri, 11 Dec 2015 09:16:38 -0800
Message-ID: <1449854198.2169.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40102 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbbLKRQk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Dec 2015 12:16:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

KASAN found that our additional element processing scripts drop off
the end of the VPD page into unallocated space.  The reason is that
not every element has additional information but our traversal
routines think they do, leading to them expecting far more additional
information than is present.  Fix this by adding a gate to the
traversal routine so that it only processes elements that are expected
to have additional information (list is in SES-2 section 6.1.13.1:
Additional Element Status diagnostic page overview)

Reported-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Tested-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: stable@vger.kernel.org
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 1736935..53ef1cb 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -561,7 +561,15 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 			if (desc_ptr)
 				desc_ptr += len;
 
-			if (addl_desc_ptr)
+			if (addl_desc_ptr &&
+			    /* only find additional descriptions for specific devices */
+			    (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
+			     type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE ||
+			     type_ptr[0] == ENCLOSURE_COMPONENT_SAS_EXPANDER ||
+			     /* these elements are optional */
+			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
+			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT ||
+			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS))
 				addl_desc_ptr += addl_desc_ptr[1] + 2;
 
 		}
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index 7be22da..a4cf57c 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -29,7 +29,11 @@
 /* A few generic types ... taken from ses-2 */
 enum enclosure_component_type {
 	ENCLOSURE_COMPONENT_DEVICE = 0x01,
+	ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS = 0x07,
+	ENCLOSURE_COMPONENT_SCSI_TARGET_PORT = 0x14,
+	ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT = 0x15,
 	ENCLOSURE_COMPONENT_ARRAY_DEVICE = 0x17,
+	ENCLOSURE_COMPONENT_SAS_EXPANDER = 0x18,
 };
 
 /* ses-2 common element status */


