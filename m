From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/3] libosd: osd_sense: OSD_CFO_PERMISSIONS
Date: Mon,  7 Sep 2009 14:27:20 +0300
Message-ID: <1252322840-19440-1-git-send-email-bharrosh@panasas.com>
References: <4AA4ED94.2050805@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:7478 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753113AbZIGL1U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2009 07:27:20 -0400
In-Reply-To: <4AA4ED94.2050805@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

Add one more important cdb_field_offset that can be returned with
scsi_invalid_field_in_cdb. It is the offset of the permissions_bit_mask
field in the capabilities structure.

Interestingly, the offset is the same for V1/V2

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 include/scsi/osd_sense.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/scsi/osd_sense.h b/include/scsi/osd_sense.h
index ff9b33c..91db543 100644
--- a/include/scsi/osd_sense.h
+++ b/include/scsi/osd_sense.h
@@ -255,6 +255,9 @@ enum osdv2_cdb_field_offset {
 	OSD_CFO_STARTING_BYTE	= OSD_CDB_OFFSET(v2.start_address),
 	OSD_CFO_PARTITION_ID	= OSD_CDB_OFFSET(partition),
 	OSD_CFO_OBJECT_ID	= OSD_CDB_OFFSET(object),
+	OSD_CFO_PERMISSIONS	= sizeof(struct osd_cdb_head) +
+					offsetof(struct osd_capability_head,
+						 permissions_bit_mask),
 };
 
 #endif /* ndef __OSD_SENSE_H__ */
-- 
1.6.2.1

