Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CFFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiBAVst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:49 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:24300 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbiBAVst (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752129; x=1675288129;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nlM/by5K+QNRXVBGCL1PTrOaWFRVxhjKDW8gDGcHaiA=;
  b=T9SjhXslgDaJFb49mcBGzj7qufSi9SAnoSWxQJtA1dvAxlTKLFVec+05
   Wi/pYJt08hRlPWjOCkhSe5ZSC4H8CQj8G+PPFR9egIcb7BTl7LwPLkZkp
   vYKONMYTEeXZpCv1J9cm2bOlq1Bz/+gG9YFeOW7VxsTQmvtG/4JlKT1PJ
   duLYXf/4Rby+1urfY6nmNuLEMRPr7hpCf9q4FyhpKYwGwhuYAqyG7WNKE
   bE+aghyvDm7C7gBwZwGmvOZh1epaC8t+7QgeC4ATXZyFWyAOYNiSea28U
   8bhOYIegsCNH0MdFVxrSABpiSV+URdTh45EOM5W+hlFkn83KSn5rg++aj
   Q==;
IronPort-SDR: PRX+a0Qvq6NhLOnY7Cp/0TxLBIPl1w8OdzKyNn5JKDh3DOzDrSqCoine2MAwV9/bI3eBJqxk2N
 FsOk4i56xXd6lcZR8RY9l6dtjK0uXyo/4bsCe3k7a0de9w0+ECcdcqDbt5AMxDVNwHNN4LUdAw
 UMijkp/uUSdxWtO7bM/hYVZ6xd1x0/er2CBh6EA7LB5C/FPvrHCOoCxgEaMDEVNMdAAfwgkSsV
 a99t1O+oBqTGt6zbpfpJjdT24ENwwi0s8DzN493hsBvxpbIeJyO/m/G88NQzaoyUYzH/kGK3yn
 m8DNRGwOJRibHrWGL1z/xTAO
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="144582881"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:48 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:48 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 6F08570236E;
        Tue,  1 Feb 2022 15:48:48 -0600 (CST)
Subject: [PATCH 12/18] smartpqi: speed up RAID 10 sequential reads
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:48 -0600
Message-ID: <164375212842.440833.6733971458765002128.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <Mike.McGowen@microchip.com>

Use all data disks for sequential read operations.

Testing discovered inconsistent performance on RAID 10 volumes
when performing 256K sequential reads.

The driver was only using a single tracker to determine which physical
drive to send a request to for AIO requests.

Change the single tracker (next_bypass_group) to an array of trackers
based on the number of data disks in a row of the RAID map.

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    5 +++--
 drivers/scsi/smartpqi/smartpqi_init.c |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 4f6e48854c66..826c4001bac2 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -918,7 +918,8 @@ union pqi_reset_register {
 #define PQI_MAX_TRANSFER_SIZE			(1024U * 1024U)
 #define PQI_MAX_TRANSFER_SIZE_KDUMP		(512 * 1024U)
 
-#define RAID_MAP_MAX_ENTRIES		1024
+#define RAID_MAP_MAX_ENTRIES			1024
+#define RAID_MAP_MAX_DATA_DISKS_PER_ROW		128
 
 #define PQI_PHYSICAL_DEVICE_BUS		0
 #define PQI_RAID_VOLUME_BUS		1
@@ -1125,7 +1126,7 @@ struct pqi_scsi_dev {
 	u8	ncq_prio_support;
 	bool	raid_bypass_configured;	/* RAID bypass configured */
 	bool	raid_bypass_enabled;	/* RAID bypass enabled */
-	u32	next_bypass_group;
+	u32	next_bypass_group[RAID_MAP_MAX_DATA_DISKS_PER_ROW];
 	struct raid_map *raid_map;	/* RAID bypass map */
 	u32	max_transfer_encrypted;
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8bd4de6306db..18c695202c52 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2058,7 +2058,7 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 		sizeof(existing_device->box));
 	memcpy(existing_device->phys_connector, new_device->phys_connector,
 		sizeof(existing_device->phys_connector));
-	existing_device->next_bypass_group = 0;
+	memset(existing_device->next_bypass_group, 0, sizeof(existing_device->next_bypass_group));
 	kfree(existing_device->raid_map);
 	existing_device->raid_map = new_device->raid_map;
 	existing_device->raid_bypass_configured =
@@ -2963,11 +2963,11 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 		if (rmd.is_write) {
 			pqi_calc_aio_r1_nexus(raid_map, &rmd);
 		} else {
-			group = device->next_bypass_group;
+			group = device->next_bypass_group[rmd.map_index];
 			next_bypass_group = group + 1;
 			if (next_bypass_group >= rmd.layout_map_count)
 				next_bypass_group = 0;
-			device->next_bypass_group = next_bypass_group;
+			device->next_bypass_group[rmd.map_index] = next_bypass_group;
 			rmd.map_index += group * rmd.data_disks_per_row;
 		}
 	} else if ((device->raid_level == SA_RAID_5 ||


