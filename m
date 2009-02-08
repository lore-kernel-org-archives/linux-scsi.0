From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH version 2] libosd: Fix NULL dereference BUG when target is
 not OSD conformant
Date: Sun, 08 Feb 2009 18:02:22 +0200
Message-ID: <498F020E.808@panasas.com>
References: <498EE637.3030800@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:30044 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753552AbZBHQC1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 11:02:27 -0500
In-Reply-To: <498EE637.3030800@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fuerst Lars <lars.fuerst@thomson.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>


Very old OSC's Target had a BUG in the Get/Set attributes where
it was looking in the wrong places for attribute lists length.
If used with the open-osd initiator, the initiator would dereference
a NULL pointer when retrieving system_information attributes.

Checks are added that retrieval of each attribute is successful
before accessing its value.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 0bbbf27..552f58b 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -131,7 +131,7 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
 
 	pFirst = get_attrs[a++].val_ptr;
 	OSD_INFO("OSD_ATTR_RI_PRODUCT_REVISION_LEVEL [%u]\n",
-		get_unaligned_be32(pFirst));
+		pFirst ? get_unaligned_be32(pFirst) : ~0U);
 
 	pFirst = get_attrs[a++].val_ptr;
 	OSD_INFO("OSD_ATTR_RI_PRODUCT_SERIAL_NUMBER [%s]\n",
@@ -143,15 +143,18 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
 
 	pFirst = get_attrs[a++].val_ptr;
 	OSD_INFO("OSD_ATTR_RI_TOTAL_CAPACITY [0x%llx]\n",
-		_LLU(get_unaligned_be64(pFirst)));
+		pFirst ? _LLU(get_unaligned_be64(pFirst)) : ~0ULL);
 
 	pFirst = get_attrs[a++].val_ptr;
 	OSD_INFO("OSD_ATTR_RI_USED_CAPACITY [0x%llx]\n",
-		_LLU(get_unaligned_be64(pFirst)));
+		pFirst ? _LLU(get_unaligned_be64(pFirst)) : ~0ULL);
 
 	pFirst = get_attrs[a++].val_ptr;
 	OSD_INFO("OSD_ATTR_RI_NUMBER_OF_PARTITIONS [%llu]\n",
-		_LLU(get_unaligned_be64(pFirst)));
+		pFirst ? _LLU(get_unaligned_be64(pFirst)) : ~0ULL);
+
+	if (a >= nelem)
+		goto out;
 
 	/* FIXME: Where are the time utilities */
 	pFirst = get_attrs[a++].val_ptr;
-- 
1.6.0.1


