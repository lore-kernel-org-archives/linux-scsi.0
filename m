Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79BFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbiBAVtF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:49:05 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:24331 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbiBAVtE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:49:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752144; x=1675288144;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vUA+jNzZpOc9M6v/r997xoceaLfTlf0TsKVQm2oh7aY=;
  b=UOX+DIMJC9cGS8/2GouliRzN+ITWHxjk0ZAL1Or3Scx2xtPtUxxDZL3w
   vLwVqdgiSEDfvJ7R78yzu+M1K1qRn7ctwuRwu+wU1B2Dh6jn2xkglMygg
   bnvtOat48P7hbltmG24F2/eTex0MsL8IWiC+uOFQegF7NHD6vxgx4gJ/R
   uvT0UVxJ4efdHj20syHFwoIZ9/BS33Eux1jMOChdnAmFooupTMqSxAHUm
   8A8Ot6Hj3K1OmF5f81HZ7j22qz7bqyQrPJ38OgWZymtj9BUuyLp8rGTHa
   wRovjVufw4YWfjOkTChd5D2CL8L2A1ZVi/yJACMIReugAonPMc5W3YAmq
   A==;
IronPort-SDR: rcNhhH+NOBtxorrEiNiD7/S4oDw6hVAQDq6TF8Eqk62PhBz5nZygANptBjSTsufHV8fooX7PfV
 0/12FagiuXcNso5PcYGMBx31BwunO+TBuae+NKBuEuv2m0Dz7QxnFyeghhF76AxL1XTJf46xyv
 n8H1EwGG4fH6oyhpLO8THGGOReg1CTUklBBWeMSKr/CgNueXn6bDsgTjOVIA6MDHRLbbqtQgWE
 iGBAPZK/dE8Fy+718yc+cL11Q3C5ObCVcXq9veB9WXtgbcxKpyXlyBRcGnSx1uGSo7E6zt1mKC
 +ekkqbMRmXihsT2MM9s6SPSb
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="144582923"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:49:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:49:03 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:49:03 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 8F38070236E;
        Tue,  1 Feb 2022 15:49:03 -0600 (CST)
Subject: [PATCH 15/18] smartpqi: fix BUILD_BUG_ON() statements
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:49:03 -0600
Message-ID: <164375214355.440833.13129778749209816497.stgit@brunhilda.pdev.net>
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

Add calls to the functions at the beginning driver initialization.

The BUILD_BUG_ON() statements that are currently in functions named
verify_structures() in the modules smartpqi_init.c and smartpqi_sis.c
do not work as currently implemented.

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    5 ++++-
 drivers/scsi/smartpqi/smartpqi_sis.c  |    2 +-
 drivers/scsi/smartpqi/smartpqi_sis.h  |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d886a9c860af..29cef682bde9 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -54,6 +54,7 @@ MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
+static void pqi_verify_structures(void);
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
@@ -9703,6 +9704,8 @@ static int __init pqi_init(void)
 	int rc;
 
 	pr_info(DRIVER_NAME "\n");
+	pqi_verify_structures();
+	sis_verify_structures();
 
 	pqi_sas_transport_template = sas_attach_transport(&pqi_sas_transport_functions);
 	if (!pqi_sas_transport_template)
@@ -9726,7 +9729,7 @@ static void __exit pqi_cleanup(void)
 module_init(pqi_init);
 module_exit(pqi_cleanup);
 
-static void __attribute__((unused)) verify_structures(void)
+static void pqi_verify_structures(void)
 {
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_host_to_ctrl_doorbell) != 0x20);
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index e176a1a0534d..afc27adf68e9 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -479,7 +479,7 @@ int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info)
 	return rc;
 }
 
-static void __attribute__((unused)) verify_structures(void)
+void sis_verify_structures(void)
 {
 	BUILD_BUG_ON(offsetof(struct sis_base_struct,
 		revision) != 0x0);
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index bd92ff49f385..5f3575261a8e 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -12,6 +12,7 @@
 #if !defined(_SMARTPQI_SIS_H)
 #define _SMARTPQI_SIS_H
 
+void sis_verify_structures(void);
 int sis_wait_for_ctrl_ready(struct pqi_ctrl_info *ctrl_info);
 int sis_wait_for_ctrl_ready_resume(struct pqi_ctrl_info *ctrl_info);
 bool sis_is_firmware_running(struct pqi_ctrl_info *ctrl_info);


