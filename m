Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3CDC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A41E423E26
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404612AbgLJUgf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:36:35 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46625 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393822AbgLJUgW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:36:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632582; x=1639168582;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hn+dKyyB9WnHItsf/ZzKQLlpGgNTxL+w6jK5Pb1FOG0=;
  b=G8hhFeKoTaEGNekjHkryuAaUgKVBFFh58965f3ZAxynLf7ZqkwOkrPm9
   oNVlGPwx4KV84JvwZ/obmWeE5Y8fJtwfVQfZpEC43yA8lWA3XbV8bTUzW
   hjtB5eZ4mAHxSHaQzjECzktEz2OmZrv+F3gXJZpWoQZphgvQ7lZCMk9ia
   F3ENBEXYBA17mntW7oUGH6sjhryj+dhuDMwztZb3ByBLof9gquBD/BLWe
   6X/WARjQ1gNBjNPMaD01r6sawDrS5guZyeCRad1HyiLCNn7Kby3p3yIHC
   s3yEC0wCqYEW/6S3jm1Sx3/IgAclMaDREykU8MXDJjq3KbsCG/og9MM/O
   Q==;
IronPort-SDR: HNgeJ1ncQmDTyvRAEjxYA8O2j5jCWRKRCrW25jq1V03xj6G5Q/EQzgSJF695Pewk3DK0JniZol
 m+RxHJIbZDYuq/dH6iC/75xsVxMVfmfSOw/EfoQa3hjDz1uyWLN7+HtDZwcw+nAMOMHiUIjX04
 6CIAJmokg+ytP14I1FUPtUih979hasbQJNYhEQopyvGTk/KRkK5uSOoD6nRvAWRsXcs6V3I/xl
 MvIaF/Rgo2jnc/SwTqitkURlPo0Flib9U1Uf1n/m1C8QuOE2lzZRKX4a2VF3y/Dn0jfKGcFr4F
 GcM=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="99412701"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:35:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:35:01 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:35:01 -0700
Subject: [PATCH V3 07/25] smartpqi: update AIO Sub Page 0x02 support
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:35:01 -0600
Message-ID: <160763250110.26927.1557519699967861731.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

The specification for AIO Sub-Page (0x02) has changed slightly.
* bring the driver into conformance with the spec.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   12 ++++---
 drivers/scsi/smartpqi/smartpqi_init.c |   60 +++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 31281cddadfe..eb23c3cf59c0 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1028,13 +1028,13 @@ struct pqi_scsi_dev_raid_map_data {
 	u8	cdb_length;
 
 	/* RAID 1 specific */
-#define NUM_RAID1_MAP_ENTRIES 3
+#define NUM_RAID1_MAP_ENTRIES	3
 	u32	num_it_nexus_entries;
 	u32	it_nexus[NUM_RAID1_MAP_ENTRIES];
 
 	/* RAID 5 / RAID 6 specific */
-	u32	p_parity_it_nexus; /* aio_handle */
-	u32	q_parity_it_nexus; /* aio_handle */
+	u32	p_parity_it_nexus;	/* aio_handle */
+	u32	q_parity_it_nexus;	/* aio_handle */
 	u8	xor_mult;
 	u64	row;
 	u64	stripe_lba;
@@ -1044,6 +1044,7 @@ struct pqi_scsi_dev_raid_map_data {
 
 #define RAID_CTLR_LUNID		"\0\0\0\0\0\0\0\0"
 
+
 struct pqi_scsi_dev {
 	int	devtype;		/* as reported by INQUIRY commmand */
 	u8	device_type;		/* as reported by */
@@ -1302,7 +1303,8 @@ struct pqi_ctrl_info {
 	u32		max_transfer_encrypted_sas_sata;
 	u32		max_transfer_encrypted_nvme;
 	u32		max_write_raid_5_6;
-
+	u32		max_write_raid_1_10_2drive;
+	u32		max_write_raid_1_10_3drive;
 
 	struct list_head scsi_device_list;
 	spinlock_t	scsi_device_list_lock;
@@ -1533,6 +1535,8 @@ struct bmic_sense_feature_io_page_aio_subpage {
 	__le16	max_transfer_encrypted_sas_sata;
 	__le16	max_transfer_encrypted_nvme;
 	__le16	max_write_raid_5_6;
+	__le16	max_write_raid_1_10_2drive;
+	__le16	max_write_raid_1_10_3drive;
 };
 
 struct bmic_smp_request {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index aa21c1cd2cac..419887aa8ff3 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -696,6 +696,19 @@ static int pqi_identify_physical_device(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
+static inline u32 pqi_aio_limit_to_bytes(__le16 *limit)
+{
+	u32 bytes;
+
+	bytes = get_unaligned_le16(limit);
+	if (bytes == 0)
+		bytes = ~0;
+	else
+		bytes *= 1024;
+
+	return bytes;
+}
+
 #pragma pack(1)
 
 struct bmic_sense_feature_buffer {
@@ -707,11 +720,11 @@ struct bmic_sense_feature_buffer {
 
 #define MINIMUM_AIO_SUBPAGE_BUFFER_LENGTH	\
 	offsetofend(struct bmic_sense_feature_buffer, \
-		aio_subpage.max_write_raid_5_6)
+		aio_subpage.max_write_raid_1_10_3drive)
 
 #define MINIMUM_AIO_SUBPAGE_LENGTH	\
 	(offsetofend(struct bmic_sense_feature_io_page_aio_subpage, \
-		max_write_raid_5_6) - \
+		max_write_raid_1_10_3drive) - \
 		sizeof_field(struct bmic_sense_feature_io_page_aio_subpage, header))
 
 static int pqi_get_advanced_raid_bypass_config(struct pqi_ctrl_info *ctrl_info)
@@ -753,33 +766,28 @@ static int pqi_get_advanced_raid_bypass_config(struct pqi_ctrl_info *ctrl_info)
 			BMIC_SENSE_FEATURE_IO_PAGE_AIO_SUBPAGE ||
 		get_unaligned_le16(&buffer->aio_subpage.header.page_length) <
 			MINIMUM_AIO_SUBPAGE_LENGTH) {
-		rc = -EINVAL;
 		goto error;
 	}
 
 	ctrl_info->max_transfer_encrypted_sas_sata =
-		get_unaligned_le16(
+		pqi_aio_limit_to_bytes(
 			&buffer->aio_subpage.max_transfer_encrypted_sas_sata);
-	if (ctrl_info->max_transfer_encrypted_sas_sata)
-		ctrl_info->max_transfer_encrypted_sas_sata *= 1024;
-	else
-		ctrl_info->max_transfer_encrypted_sas_sata = ~0;
 
 	ctrl_info->max_transfer_encrypted_nvme =
-		get_unaligned_le16(
+		pqi_aio_limit_to_bytes(
 			&buffer->aio_subpage.max_transfer_encrypted_nvme);
-	if (ctrl_info->max_transfer_encrypted_nvme)
-		ctrl_info->max_transfer_encrypted_nvme *= 1024;
-	else
-		ctrl_info->max_transfer_encrypted_nvme = ~0;
 
 	ctrl_info->max_write_raid_5_6 =
-		get_unaligned_le16(
+		pqi_aio_limit_to_bytes(
 			&buffer->aio_subpage.max_write_raid_5_6);
-	if (ctrl_info->max_write_raid_5_6)
-		ctrl_info->max_write_raid_5_6 *= 1024;
-	else
-		ctrl_info->max_write_raid_5_6 = ~0;
+
+	ctrl_info->max_write_raid_1_10_2drive =
+		pqi_aio_limit_to_bytes(
+			&buffer->aio_subpage.max_write_raid_1_10_2drive);
+
+	ctrl_info->max_write_raid_1_10_3drive =
+		pqi_aio_limit_to_bytes(
+			&buffer->aio_subpage.max_write_raid_1_10_3drive);
 
 error:
 	kfree(buffer);
@@ -2387,9 +2395,13 @@ static bool pqi_aio_raid_level_supported(struct pqi_ctrl_info *ctrl_info,
 	case SA_RAID_0:
 		break;
 	case SA_RAID_1:
-		fallthrough;
+		if (rmd->is_write && (!ctrl_info->enable_r1_writes ||
+			rmd->data_length > ctrl_info->max_write_raid_1_10_2drive))
+			is_supported = false;
+		break;
 	case SA_RAID_ADM:
-		if (rmd->is_write && !ctrl_info->enable_r1_writes)
+		if (rmd->is_write && (!ctrl_info->enable_r1_writes ||
+			rmd->data_length > ctrl_info->max_write_raid_1_10_3drive))
 			is_supported = false;
 		break;
 	case SA_RAID_5:
@@ -8205,6 +8217,8 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 	ctrl_info->max_transfer_encrypted_nvme =
 		PQI_DEFAULT_MAX_TRANSFER_ENCRYPTED_NVME;
 	ctrl_info->max_write_raid_5_6 = PQI_DEFAULT_MAX_WRITE_RAID_5_6;
+	ctrl_info->max_write_raid_1_10_2drive = ~0;
+	ctrl_info->max_write_raid_1_10_3drive = ~0;
 
 	return ctrl_info;
 }
@@ -9634,7 +9648,7 @@ static void __attribute__((unused)) verify_structures(void)
 		page_length) != 2);
 
 	BUILD_BUG_ON(sizeof(struct bmic_sense_feature_io_page_aio_subpage)
-		!= 14);
+		!= 18);
 	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
 		header) != 0);
 	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
@@ -9651,6 +9665,10 @@ static void __attribute__((unused)) verify_structures(void)
 		max_transfer_encrypted_nvme) != 10);
 	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
 		max_write_raid_5_6) != 12);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
+		max_write_raid_1_10_2drive) != 14);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
+		max_write_raid_1_10_3drive) != 16);
 
 	BUILD_BUG_ON(PQI_ADMIN_IQ_NUM_ELEMENTS > 255);
 	BUILD_BUG_ON(PQI_ADMIN_OQ_NUM_ELEMENTS > 255);

