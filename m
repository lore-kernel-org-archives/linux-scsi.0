From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/6] libosd: Better printout of OSD target system information
Date: Thu, 07 May 2009 18:25:08 +0300
Message-ID: <4A02FD54.2010906@panasas.com>
References: <4A02FBE1.4000406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:2325 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbZEGPZM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2009 11:25:12 -0400
In-Reply-To: <4A02FBE1.4000406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>


Shorten out the Attributes names.
Align all results on column 24.
Print system ID in a new line.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 1ce6b24..15f0bbc 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -118,39 +118,39 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
 		_osd_ver_desc(or));
 
 	pFirst = get_attrs[a++].val_ptr;
-	OSD_INFO("OSD_ATTR_RI_VENDOR_IDENTIFICATION [%s]\n",
+	OSD_INFO("VENDOR_IDENTIFICATION  [%s]\n",
 		(char *)pFirst);
 
 	pFirst = get_attrs[a++].val_ptr;
-	OSD_INFO("OSD_ATTR_RI_PRODUCT_IDENTIFICATION [%s]\n",
+	OSD_INFO("PRODUCT_IDENTIFICATION [%s]\n",
 		(char *)pFirst);
 
 	pFirst = get_attrs[a++].val_ptr;
-	OSD_INFO("OSD_ATTR_RI_PRODUCT_MODEL [%s]\n",
+	OSD_INFO("PRODUCT_MODEL          [%s]\n",
 		(char *)pFirst);
 
 	pFirst = get_attrs[a++].val_ptr;
-	OSD_INFO("OSD_ATTR_RI_PRODUCT_REVISION_LEVEL [%u]\n",
+	OSD_INFO("PRODUCT_REVISION_LEVEL [%u]\n",
 		pFirst ? get_unaligned_be32(pFirst) : ~0U);
 
 	pFirst = get_attrs[a++].val_ptr;
-	OSD_INFO("OSD_ATTR_RI_PRODUCT_SERIAL_NUMBER [%s]\n",
+	OSD_INFO("PRODUCT_SERIAL_NUMBER  [%s]\n",
 		(char *)pFirst);
 
 	pFirst = get_attrs[a].val_ptr;
-	OSD_INFO("OSD_ATTR_RI_OSD_NAME [%s]\n", (char *)pFirst);
+	OSD_INFO("OSD_NAME               [%s]\n", (char *)pFirst);
 	a++;
 
 	pFirst = get_attrs[a++].val_ptr;
-	OSD_INFO("OSD_ATTR_RI_TOTAL_CAPACITY [0x%llx]\n",
+	OSD_INFO("TOTAL_CAPACITY         [0x%llx]\n",
 		pFirst ? _LLU(get_unaligned_be64(pFirst)) : ~0ULL);
 
 	pFirst = get_attrs[a++].val_ptr;
-	OSD_INFO("OSD_ATTR_RI_USED_CAPACITY [0x%llx]\n",
+	OSD_INFO("USED_CAPACITY          [0x%llx]\n",
 		pFirst ? _LLU(get_unaligned_be64(pFirst)) : ~0ULL);
 
 	pFirst = get_attrs[a++].val_ptr;
-	OSD_INFO("OSD_ATTR_RI_NUMBER_OF_PARTITIONS [%llu]\n",
+	OSD_INFO("NUMBER_OF_PARTITIONS   [%llu]\n",
 		pFirst ? _LLU(get_unaligned_be64(pFirst)) : ~0ULL);
 
 	if (a >= nelem)
@@ -158,7 +158,7 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
 
 	/* FIXME: Where are the time utilities */
 	pFirst = get_attrs[a++].val_ptr;
-	OSD_INFO("OSD_ATTR_RI_CLOCK [0x%02x%02x%02x%02x%02x%02x]\n",
+	OSD_INFO("CLOCK                  [0x%02x%02x%02x%02x%02x%02x]\n",
 		((char *)pFirst)[0], ((char *)pFirst)[1],
 		((char *)pFirst)[2], ((char *)pFirst)[3],
 		((char *)pFirst)[4], ((char *)pFirst)[5]);
@@ -169,7 +169,8 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
 
 		hex_dump_to_buffer(get_attrs[a].val_ptr, len, 32, 1,
 				   sid_dump, sizeof(sid_dump), true);
-		OSD_INFO("OSD_ATTR_RI_OSD_SYSTEM_ID(%d) [%s]\n", len, sid_dump);
+		OSD_INFO("OSD_SYSTEM_ID(%d)\n"
+			 "        [%s]\n", len, sid_dump);
 		a++;
 	}
 out:
-- 
1.6.2.1


