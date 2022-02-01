Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E11C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbiBAVtP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:49:15 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:19460 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbiBAVtO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:49:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752154; x=1675288154;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wAsYC5QOH2kOeg0M1oYXITgCcIFF0gm0jvXfnkEhXbE=;
  b=czjry+bQq4ZUCgttSetAp5YkOtZwopuNdgNPKiJKmGi+qs+luzo48Jy6
   OMXgdvCaOp0S72Q0EAnQn1fl17pYr5gln9bZfto+goGvS2aX2U3078HAi
   P0/qlAg/RF7UnEhQQVneKD0S15SY3InvS94hA60PkvvUiK42OYDp3H9Dk
   ILYh5lw+bqg2VBHHqvWsS/3MTfOEDFQIihrcT7UnXxN0Xrdgss6O2zf+k
   ukZvXaWKIlAdgcNrB2lz9R2Zgv2Gap6Z0si3FG664HAWFSLp3SWQ1jeId
   7caCcFFmPle4AJfmc52ffJsuEar/iwqzyHLcTQvkJetkiRp228GC2ZoF3
   g==;
IronPort-SDR: j65+Q+sbeywziUFDCAT7y1VZX0zGp9smm9s6M6JhzxJ/Su5LjXiYYMrlJjx4TmePERNEP5jW9N
 qN1rhaJfdm/4iECTDFyHkCYb2w7Oi+P2paxiI95DZSirMgmTvP2yRMhYIcMx6yRuBN0So5JDnE
 2GiRFw12uyfAokCsJ92cftqqe4+3cJxNQxNCPpG5y6oA14lqzcvGGH0GJwNWq+GSgP1Ll82hiR
 7EctZG7EiQ05nzIEpULpJW4GEy/Lypc5IXQRa+WXmajeu4oPHe+2vx+80vQl/vPDRs1zekv/0C
 4KdFzm/KflUp23NCv8QmcCrj
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="84365841"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:49:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:49:13 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:49:13 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id A3F7570236E;
        Tue,  1 Feb 2022 15:49:13 -0600 (CST)
Subject: [PATCH 17/18] smartpqi: fix lsscsi-t SAS addresses
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:49:13 -0600
Message-ID: <164375215363.440833.7298523719813806902.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Correct lsscsi -t output for newer controllers that support
16-byte WWID in the SAS address field.

lsscsi -t was displaying all zeros for SAS addresses.

When we added support to smartpqi for 16-byte WWIDs in the RPL data for
newer controllers, we were copying the wrong part of the 16-byte WWID
to the SAS address field.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3c3749fcb78c..be4e91aaaa52 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1182,8 +1182,8 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 
 	for (i = 0; i < num_physicals; i++) {
 		memcpy(&rpl_16byte_wwid_list->lun_entries[i].lunid, &rpl_8byte_wwid_list->lun_entries[i].lunid, sizeof(rpl_8byte_wwid_list->lun_entries[i].lunid));
-		memset(&rpl_16byte_wwid_list->lun_entries[i].wwid, 0, 8);
-		memcpy(&rpl_16byte_wwid_list->lun_entries[i].wwid[8], &rpl_8byte_wwid_list->lun_entries[i].wwid, sizeof(rpl_8byte_wwid_list->lun_entries[i].wwid));
+		memcpy(&rpl_16byte_wwid_list->lun_entries[i].wwid[0], &rpl_8byte_wwid_list->lun_entries[i].wwid, sizeof(rpl_8byte_wwid_list->lun_entries[i].wwid));
+		memset(&rpl_16byte_wwid_list->lun_entries[i].wwid[8], 0, 8);
 		rpl_16byte_wwid_list->lun_entries[i].device_type = rpl_8byte_wwid_list->lun_entries[i].device_type;
 		rpl_16byte_wwid_list->lun_entries[i].device_flags = rpl_8byte_wwid_list->lun_entries[i].device_flags;
 		rpl_16byte_wwid_list->lun_entries[i].lun_count = rpl_8byte_wwid_list->lun_entries[i].lun_count;
@@ -2472,7 +2472,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 				sizeof(device->volume_id));
 		}
 
-		device->sas_address = get_unaligned_be64(&device->wwid[8]);
+		device->sas_address = get_unaligned_be64(&device->wwid[0]);
 
 		new_device_list[num_valid_devices++] = device;
 	}


