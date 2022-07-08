Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4734FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239680AbiGHSq4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239681AbiGHSqv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:46:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4EF8239A
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657306011; x=1688842011;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AOT9YUDY3jHog0rvPFyV5GQi0iMc0Y8Tgn7hwRwn2zY=;
  b=tv6XjNoArpR3YBl504NktQ3CaU3irt0rqD6d0u/Kwh58ADzQKWAJy+H5
   ugS27YrMisUcyx35LBRjMhW2O1bsQnTBBkeRTsT6vFdSOqicnGWOLjBri
   PFbyJEHRFNc0xURwsnzO3A8E9fmtT2JGLyaTuvJOyzbwDg7Fjw1z1XlYB
   M5TkxWRy2/AV1YZwLQNtgRQMNuHK+CcnN+Hgb+4ipvFw7pc7QDUXZkOTt
   fo/sMh5DMmQtfIGgJEdPpVqc3Kr4egmVh8qe86zUQtcWEh2kJ6Qy+elkv
   0g8RPYGAgUVN8DeowPGsQMUrNLUSHbtbSr37g2agFJ2E6WOUdgOJu5xNT
   w==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="171374483"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:46:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:49 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:49 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268IlugO177505;
        Fri, 8 Jul 2022 13:47:56 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268Ilugw177504;
        Fri, 8 Jul 2022 13:47:56 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 14/16] smartpqi: add ctrl ready timeout module parameter
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:56 -0500
Message-ID: <165730607666.177165.9221211345284471213.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Allow user to override the default driver timeout for controller ready.

There are some rare configurations which require the driver to wait
longer than the normal 3 minutes for the controller to complete its
bootup sequence and be ready to accept commands from the driver.

The module parameter is:

ctrl_ready_timeout= { 0 | 30-1800 }

and specifies the timeout in seconds for the driver to wait
for controller ready. The valid range is 0 or 30-1800. The default
value is 0, which causes the driver to use a timeout of 180 seconds
(3 minutes).

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   28 ++++++++++++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_sis.c  |    4 +++-
 drivers/scsi/smartpqi/smartpqi_sis.h  |    2 ++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 122772628a2f..f18b63637d0b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -181,6 +181,12 @@ module_param_named(disable_managed_interrupts,
 MODULE_PARM_DESC(disable_managed_interrupts,
 	"Disable the kernel automatically assigning SMP affinity to IRQs.");
 
+static unsigned int pqi_ctrl_ready_timeout_secs;
+module_param_named(ctrl_ready_timeout,
+	pqi_ctrl_ready_timeout_secs, uint, 0644);
+MODULE_PARM_DESC(ctrl_ready_timeout,
+	"Timeout in seconds for driver to wait for controller ready.");
+
 static char *raid_levels[] = {
 	"RAID-0",
 	"RAID-4",
@@ -9089,9 +9095,31 @@ static void pqi_process_lockup_action_param(void)
 		DRIVER_NAME_SHORT, pqi_lockup_action_param);
 }
 
+#define PQI_CTRL_READY_TIMEOUT_PARAM_MIN_SECS		30
+#define PQI_CTRL_READY_TIMEOUT_PARAM_MAX_SECS		(30 * 60)
+
+static void pqi_process_ctrl_ready_timeout_param(void)
+{
+	if (pqi_ctrl_ready_timeout_secs == 0)
+		return;
+
+	if (pqi_ctrl_ready_timeout_secs < PQI_CTRL_READY_TIMEOUT_PARAM_MIN_SECS) {
+		pr_warn("%s: ctrl_ready_timeout parm of %u second(s) is less than minimum timeout of %d seconds - setting timeout to %d seconds\n",
+			DRIVER_NAME_SHORT, pqi_ctrl_ready_timeout_secs, PQI_CTRL_READY_TIMEOUT_PARAM_MIN_SECS, PQI_CTRL_READY_TIMEOUT_PARAM_MIN_SECS);
+		pqi_ctrl_ready_timeout_secs = PQI_CTRL_READY_TIMEOUT_PARAM_MIN_SECS;
+	} else if (pqi_ctrl_ready_timeout_secs > PQI_CTRL_READY_TIMEOUT_PARAM_MAX_SECS) {
+		pr_warn("%s: ctrl_ready_timeout parm of %u seconds is greater than maximum timeout of %d seconds - setting timeout to %d seconds\n",
+			DRIVER_NAME_SHORT, pqi_ctrl_ready_timeout_secs, PQI_CTRL_READY_TIMEOUT_PARAM_MAX_SECS, PQI_CTRL_READY_TIMEOUT_PARAM_MAX_SECS);
+		pqi_ctrl_ready_timeout_secs = PQI_CTRL_READY_TIMEOUT_PARAM_MAX_SECS;
+	}
+
+	sis_ctrl_ready_timeout_secs = pqi_ctrl_ready_timeout_secs;
+}
+
 static void pqi_process_module_params(void)
 {
 	pqi_process_lockup_action_param();
+	pqi_process_ctrl_ready_timeout_param();
 }
 
 #if defined(CONFIG_PM)
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 59d9c2792371..12b575f2bcef 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -86,6 +86,8 @@ struct sis_base_struct {
 
 #pragma pack()
 
+unsigned int sis_ctrl_ready_timeout_secs = SIS_CTRL_READY_TIMEOUT_SECS;
+
 static int sis_wait_for_ctrl_ready_with_timeout(struct pqi_ctrl_info *ctrl_info,
 	unsigned int timeout_secs)
 {
@@ -122,7 +124,7 @@ static int sis_wait_for_ctrl_ready_with_timeout(struct pqi_ctrl_info *ctrl_info,
 int sis_wait_for_ctrl_ready(struct pqi_ctrl_info *ctrl_info)
 {
 	return sis_wait_for_ctrl_ready_with_timeout(ctrl_info,
-		SIS_CTRL_READY_TIMEOUT_SECS);
+		sis_ctrl_ready_timeout_secs);
 }
 
 int sis_wait_for_ctrl_ready_resume(struct pqi_ctrl_info *ctrl_info)
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 5f3575261a8e..2f825d31a47e 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -32,4 +32,6 @@ void sis_soft_reset(struct pqi_ctrl_info *ctrl_info);
 u32 sis_get_product_id(struct pqi_ctrl_info *ctrl_info);
 int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info);
 
+extern unsigned int sis_ctrl_ready_timeout_secs;
+
 #endif	/* _SMARTPQI_SIS_H */

