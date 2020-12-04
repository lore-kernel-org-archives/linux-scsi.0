Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7205C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C44AE22D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgLDXDK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:10 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1374 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLDXDJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607122989; x=1638658989;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=votB9wXp5KI1r3R9o1Wg6925asMQ2aoSjMqDU7bBlDY=;
  b=JJiuHyE88w5x0IWwf8JEAqPxCVnDg/RJ5xqZAqwXSSHDXZ8yGE+uuBo7
   Aw33TH9BMv9EaluTuiyjbdKH5Eq0GkhLCysJ/v/KtOKHLTUBbkhpVh7ex
   ieLUs8IlshbOLm/CzKjYlvMv1vus5WHkehHsS+ep8Jjg5QquHcdOYOB27
   ED8goiGfuADnjoRDo6JLlBU5TeKbhmaqNMSB19fvoCFexvjhIIfNGuZdR
   U34XTN/x+vNkOqjmtP0aBs0T+7L9ESL/f/1j3IzIOltCAQqt/vyAQH6KM
   za2PxQuH++xesUH8oZl5OHuAs9lz8zH5f2YAkWsxsuSWdFKzrxchVYghz
   g==;
IronPort-SDR: jMXEpSCEnWdDBqAbVwLBRj37BMqDDcEDiKJvOmB8AFdoTfI9xGe1j/5AccYycxgpyuO3ie96M/
 nwiC7zmis74jkDIglC4xND2hcogCeUpFt13RYfELDALCZuomPQJHdftfuy9PfvwEArkyjPu5Gp
 Sg3X8CWv1UuEOogyUd+rpmZ0rreiCyOdG3HY/PJxuplSqVwjKkFPy63ZjEtSZzYW2bYk5P2IxS
 TC4ywJllCLEeGbjWsoD7RHxgmHF/wdATN/3k2Pqc420f0lEx8/iJvNldXwVThCcSMVm3f2oggK
 mqY=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="101548508"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:01:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:01:31 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:01:31 -0700
Subject: [PATCH 07/25] smartpqi: update AIO Sub Page 0x02 support
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:01:31 -0600
Message-ID: <160712289129.21372.649253271818958012.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
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
index 25a3aa763bba..34ff1b3679f1 100644
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
@@ -8136,6 +8148,8 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 	ctrl_info->max_transfer_encrypted_nvme =
 		PQI_DEFAULT_MAX_TRANSFER_ENCRYPTED_NVME;
 	ctrl_info->max_write_raid_5_6 = PQI_DEFAULT_MAX_WRITE_RAID_5_6;
+	ctrl_info->max_write_raid_1_10_2drive = ~0;
+	ctrl_info->max_write_raid_1_10_3drive = ~0;
 
 	return ctrl_info;
 }
@@ -9565,7 +9579,7 @@ static void __attribute__((unused)) verify_structures(void)
 		page_length) != 2);
 
 	BUILD_BUG_ON(sizeof(struct bmic_sense_feature_io_page_aio_subpage)
-		!= 14);
+		!= 18);
 	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
 		header) != 0);
 	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
@@ -9582,6 +9596,10 @@ static void __attribute__((unused)) verify_structures(void)
 		max_transfer_encrypted_nvme) != 10);
 	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
 		max_write_raid_5_6) != 12);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
+		max_write_raid_1_10_2drive) != 14);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
+		max_write_raid_1_10_3drive) != 16);
 
 	BUILD_BUG_ON(PQI_ADMIN_IQ_NUM_ELEMENTS > 255);
 	BUILD_BUG_ON(PQI_ADMIN_OQ_NUM_ELEMENTS > 255);

