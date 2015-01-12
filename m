From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH] [SCSI] mpt2sas, mpt3sas: fix sparse warings restricted __le16 degrades to integer
Date: Mon, 12 Jan 2015 18:22:29 +0530
Message-ID: <1421067149-12066-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:49361 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbbALMw7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2015 07:52:59 -0500
Received: by mail-pa0-f53.google.com with SMTP id kq14so31827726pab.12
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2015 04:52:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Fixed sparse warings 'restricted __le16 degrades to integer' generated
from below titled patch

[PATCH v2 02/22] [SCSI] mpt2sas, mpt3sas: Added support to log message
 when Temperature Threshold exceeds for any Sensor

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 12 ++++++------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5950731..3f26147 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3670,12 +3670,12 @@ _scsih_temp_threshold_events(struct MPT2SAS_ADAPTER *ioc,
 {
 	if (ioc->temp_sensors_count >= event_data->SensorNum) {
 		printk(MPT2SAS_ERR_FMT "Temperature Threshold flags %s%s%s%s"
-			" exceeded for Sensor: %d !!!\n", ioc->name,
-			((event_data->Status & 0x1) == 1) ? "0 " : " ",
-			((event_data->Status & 0x2) == 2) ? "1 " : " ",
-			((event_data->Status & 0x4) == 4) ? "2 " : " ",
-			((event_data->Status & 0x8) == 8) ? "3 " : " ",
-			event_data->SensorNum);
+		  " exceeded for Sensor: %d !!!\n", ioc->name,
+		  ((le16_to_cpu(event_data->Status) & 0x1) == 1) ? "0 " : " ",
+		  ((le16_to_cpu(event_data->Status) & 0x2) == 2) ? "1 " : " ",
+		  ((le16_to_cpu(event_data->Status) & 0x4) == 4) ? "2 " : " ",
+		  ((le16_to_cpu(event_data->Status) & 0x8) == 8) ? "3 " : " ",
+		  event_data->SensorNum);
 		printk(MPT2SAS_ERR_FMT "Current Temp In Celsius: %d\n",
 			ioc->name, event_data->CurrentTemperature);
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e8e6bd4..5a97e32 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3364,12 +3364,12 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 {
 	if (ioc->temp_sensors_count >= event_data->SensorNum) {
 		pr_err(MPT3SAS_FMT "Temperature Threshold flags %s%s%s%s"
-			" exceeded for Sensor: %d !!!\n", ioc->name,
-			((event_data->Status & 0x1) == 1) ? "0 " : " ",
-			((event_data->Status & 0x2) == 2) ? "1 " : " ",
-			((event_data->Status & 0x4) == 4) ? "2 " : " ",
-			((event_data->Status & 0x8) == 8) ? "3 " : " ",
-			event_data->SensorNum);
+		  " exceeded for Sensor: %d !!!\n", ioc->name,
+		  ((le16_to_cpu(event_data->Status) & 0x1) == 1) ? "0 " : " ",
+		  ((le16_to_cpu(event_data->Status) & 0x2) == 2) ? "1 " : " ",
+		  ((le16_to_cpu(event_data->Status) & 0x4) == 4) ? "2 " : " ",
+		  ((le16_to_cpu(event_data->Status) & 0x8) == 8) ? "3 " : " ",
+		  event_data->SensorNum);
 		pr_err(MPT3SAS_FMT "Current Temp In Celsius: %d\n",
 			ioc->name, event_data->CurrentTemperature);
 	}
-- 
2.0.2

