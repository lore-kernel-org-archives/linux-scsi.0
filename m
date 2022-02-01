Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B72BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiBAVsP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:15 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39807 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiBAVsN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752093; x=1675288093;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aqtJqpMWVGv5tB5DS5LDnw+CBwpRS41P24HWh48M/7g=;
  b=Dhcp9eStj/pyOX97tPqjM8YdnQH93FT7/68EypUC37tmKAhEk8Ls/baX
   W9VOsf2CWooryHcziEFBTxcatOhZmnavOERGYGfetggD8B3kQRYxqAEdu
   XD8H46u9I8ShqeFqTtoKn3BHgP1rx3wTxDGPy3GO2hYvKNG/gSnzphVkx
   RX80l83Us0MYdxHoNZMKoVGGDlbp1zaZnrQ4bM6F40AYP/rs5ZzdtuD/n
   cWpLG5+bfbYNHW35S3vek963RFlDK2ecrRdlvjCv6s70x2VPMhBtAQysA
   dKGFgAE/DW9+miEuklZgavJukttWJp6HWLv0GaeX11Fl3/kWL5FMadd50
   w==;
IronPort-SDR: qJZkNDPXuk5vajnhsKUpJN8GWyPnwIHet1sy65UqxjT6y/xV7z8i7b1c7JohQhrWlFBJYVkMSS
 bzB09ZRpLiv9Jxznb1txRO6e3443Mnvh9NndEm5zkRtbR/LNeFGPYNZzFo+RDlWMooAkxe2e3v
 wCxPW9sZljmO0ZZ8h16UT0O/hiW1SX2AfUy+VpO3KVcbpXu8uU4U05AU5LV3Cfhj6fRcZEB+bS
 A+4OIBaHtWogPSy+FGapRc+SfHyVEv6Rt0o/RG4Mm9bBuS+XXCJ06h31Y8KmHRg+cMoZfmAJZd
 SjwufRvm+e2kOHoGQU9RcYO4
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="160764664"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:13 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:13 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 2A07D70236E;
        Tue,  1 Feb 2022 15:48:13 -0600 (CST)
Subject: [PATCH 05/18] smartpqi: propagate path failures to SML quickly
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:13 -0600
Message-ID: <164375209313.440833.9992416628621839233.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Return DID_NO_CONNECT when a path failure is detected.
  When a path fails during IO and AIO path gets disabled for a
  multipath device, the IO was retried in the RAID path slowing
  down path fail detection. Returning DID_NO_CONNECT allows multipath
  to switch paths more quickly.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Sagar Biradar <sagar.biradar@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f51605cd098c..9bc2987e280f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2291,6 +2291,14 @@ static inline bool pqi_is_device_with_sas_address(struct pqi_scsi_dev *device)
 	return false;
 }
 
+static inline bool pqi_is_multipath_device(struct pqi_scsi_dev *device)
+{
+	if (pqi_is_logical_device(device))
+		return false;
+
+	return (device->path_map & (device->path_map - 1)) != 0;
+}
+
 static inline bool pqi_expose_device(struct pqi_scsi_dev *device)
 {
 	return !device->is_physical_device || !pqi_skip_device(device->scsi3addr);
@@ -3216,12 +3224,14 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 	int residual_count;
 	int xfer_count;
 	bool device_offline;
+	struct pqi_scsi_dev *device;
 
 	scmd = io_request->scmd;
 	error_info = io_request->error_info;
 	host_byte = DID_OK;
 	sense_data_length = 0;
 	device_offline = false;
+	device = scmd->device->hostdata;
 
 	switch (error_info->service_response) {
 	case PQI_AIO_SERV_RESPONSE_COMPLETE:
@@ -3246,8 +3256,14 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 			break;
 		case PQI_AIO_STATUS_AIO_PATH_DISABLED:
 			pqi_aio_path_disabled(io_request);
-			scsi_status = SAM_STAT_GOOD;
-			io_request->status = -EAGAIN;
+			if (pqi_is_multipath_device(device)) {
+				pqi_device_remove_start(device);
+				host_byte = DID_NO_CONNECT;
+				scsi_status = SAM_STAT_CHECK_CONDITION;
+			} else {
+				scsi_status = SAM_STAT_GOOD;
+				io_request->status = -EAGAIN;
+			}
 			break;
 		case PQI_AIO_STATUS_NO_PATH_TO_DEVICE:
 		case PQI_AIO_STATUS_INVALID_DEVICE:


