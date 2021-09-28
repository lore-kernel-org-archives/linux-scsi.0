Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CACC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27E3760C41
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbhI1X4t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:49 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:8293 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243340AbhI1X4Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873285; x=1664409285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zdezOWEhW3/5HdpEPOhQOJHyudmdngHpbeuI1s44LkU=;
  b=wo8YcL8zjSfuPglORJnT+FPdKtK2KvpWG+pRwn6LELD9wzcjDTWGiZ1a
   lcNN7BeUB1G/kuqx5NL7o5g4zpDTbIsT2V5ioM0C+WYcjhyLv8zH/Dr/S
   7OtjsJCjc/WvMKDmXh6d18RKWlDPuxdfALgn/IYrndsk/y3jsaosMWtSW
   3mV/wY86GHCmn/23vmtyXU2zZ+YaaMPCn/w4K93iUp79VT5Mx9wSbuobJ
   mF0yqftf8o2ctjdjjoXO7e4srrfF/IrOCrb35AvRGlJcf4JJpCh9M80js
   l9pmES/CkqQrC0rCJXYMaLSiYg+MrXSHqdbt7SGIFovxOvVVurVKJcDOv
   g==;
IronPort-SDR: 5nP//pEbyCTdZgnGZ3rslDBTxN7cInWKsdjOG5icIEtLsuMVS8OfF6ag/sBTOkT+Amz5nWSJiT
 I744TIC/sP95XWDrtQNXdpu5HTkE47gD/0IVeHGnQKJJPHb32mmOPVqni4Q+uhugWCbSi+TaDe
 2SUy/+bmMADjBTNHKupfPn12XHy1ezY9v2kV1QIiT/pRInPca2QQS3mY//hVWdZGyDNPRYlWc7
 eXxOs9fAd/YK7Ied46f0cDReR2N62RkiUi64Oqa6lt36Bd8OB9BDrJkVMhGyIFB7CKqBBSqVHA
 A82B1aPCcIU6gwO0nyFZpGw3
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="138333253"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:42 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 78042702883; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates PATCH V2 05/11] smartpqi: add tur check for sanitize operation
Date:   Tue, 28 Sep 2021 18:54:36 -0500
Message-ID: <20210928235442.201875-6-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add in a TUR to HBA disks and do not present them to the OS if
0x02/0x04/0x1b (sanitize in progress) is returned.

During boot-up, some OSes appear to hang when there are one or
more disks undergoing sanitize.

According to SCSI SBC4 specification
section 4.11.2 Commands allowed during sanitize,
some SCSI commands are permitted, but read/write operations are not.

When the OS attempts to read the disk partition table a
CHECK CONDITION ASC 0x04 ASCQ 0x1b is returned which causes the OS
to retry the read until sanitize has completed. This can take hours.

Note: According to document HPE Smart Storage Administrator User Guide
Link: https://support.hpe.com/hpesc/public/docDisplay?docLocale=en_US&docId=c03909334

During the sanitize erase operation, the drive is unusable.
I.E.
      The expected behavior for sanitize is the that disk remains
      offline even after sanitize has completed. The customer is
      expected to re-enable the disk using the management utility.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 87 +++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 01330fd67500..838274d8fadf 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -555,6 +555,10 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
 	cdb = request->cdb;
 
 	switch (cmd) {
+	case TEST_UNIT_READY:
+		request->data_direction = SOP_READ_FLAG;
+		cdb[0] = TEST_UNIT_READY;
+		break;
 	case INQUIRY:
 		request->data_direction = SOP_READ_FLAG;
 		cdb[0] = INQUIRY;
@@ -1575,6 +1579,85 @@ static int pqi_get_logical_device_info(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
+/*
+ * Prevent adding drive to OS for some corner cases such as a drive
+ * undergoing a sanitize operation. Some OSes will continue to poll
+ * the drive until the sanitize completes, which can take hours,
+ * resulting in long bootup delays. Commands such as TUR, READ_CAP
+ * are allowed, but READ/WRITE cause check condition. So the OS
+ * cannot check/read the partition table.
+ * Note: devices that have completed sanitize must be re-enabled
+ *       using the management utility.
+ */
+static bool pqi_keep_device_offline(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_scsi_dev *device)
+{
+	u8 scsi_status;
+	int rc;
+	enum dma_data_direction dir;
+	char *buffer;
+	int buffer_length = 64;
+	size_t sense_data_length;
+	struct scsi_sense_hdr sshdr;
+	struct pqi_raid_path_request request;
+	struct pqi_raid_error_info error_info;
+	bool offline = false; /* Assume keep online */
+
+	/* Do not check controllers. */
+	if (pqi_is_hba_lunid(device->scsi3addr))
+		return false;
+
+	/* Do not check LVs. */
+	if (pqi_is_logical_device(device))
+		return false;
+
+	buffer = kmalloc(buffer_length, GFP_KERNEL);
+	if (!buffer)
+		return false; /* Assume not offline */
+
+	/* Check for SANITIZE in progress using TUR */
+	rc = pqi_build_raid_path_request(ctrl_info, &request,
+		TEST_UNIT_READY, RAID_CTLR_LUNID, buffer,
+		buffer_length, 0, &dir);
+	if (rc)
+		goto out; /* Assume not offline */
+
+	memcpy(request.lun_number, device->scsi3addr, sizeof(request.lun_number));
+
+	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, &error_info);
+
+	if (rc)
+		goto out; /* Assume not offline */
+
+	scsi_status = error_info.status;
+	sense_data_length = get_unaligned_le16(&error_info.sense_data_length);
+	if (sense_data_length == 0)
+		sense_data_length =
+			get_unaligned_le16(&error_info.response_data_length);
+	if (sense_data_length) {
+		if (sense_data_length > sizeof(error_info.data))
+			sense_data_length = sizeof(error_info.data);
+
+		/*
+		 * Check for sanitize in progress: asc:0x04, ascq: 0x1b
+		 */
+		if (scsi_status == SAM_STAT_CHECK_CONDITION &&
+			scsi_normalize_sense(error_info.data,
+				sense_data_length, &sshdr) &&
+				sshdr.sense_key == NOT_READY &&
+				sshdr.asc == 0x04 &&
+				sshdr.ascq == 0x1b) {
+			device->device_offline = true;
+			offline = true;
+			goto out; /* Keep device offline */
+		}
+	}
+
+out:
+	kfree(buffer);
+	return offline;
+}
+
 static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device,
 	struct bmic_identify_physical_device *id_phys)
@@ -2296,6 +2379,10 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 		if (!pqi_is_supported_device(device))
 			continue;
 
+		/* Do not present disks that the OS cannot fully probe */
+		if (pqi_keep_device_offline(ctrl_info, device))
+			continue;
+
 		/* Gather information about the device. */
 		rc = pqi_get_device_info(ctrl_info, device, id_phys);
 		if (rc == -ENOMEM) {
-- 
2.28.0.rc1.9.ge7ae437ac1

