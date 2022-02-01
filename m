Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0C4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbiBAVsf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:35 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:19926 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236393AbiBAVse (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752114; x=1675288114;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pITlBycQY8G9WEbV9LzMe+lca6eLk4z69yWy0dPWgRg=;
  b=J2LfXveVpx0WUFAjw4MxzhSkw6mIvxYEIvQgMiGvIjAoMU2CjswAPR/a
   COAMufF6jhTRoRPVe27GaFz64K8p2yUtB9yMWLuf02bCMCcWcme7q53Qz
   G1C3eCHpdI6lErIEC+t1UkiSjRdy3SQUTLvvshp/c4+/c/OObrXP558dg
   jnFeUtkP1iU18iOEuT6Vh9yUzNIqSpFDvmzfcr/T6cX4EBrQH+zVaboFR
   tqSqsqN0h3fF4WTd2Hwm1iHH074I50vS8YZy6Wt3tAzUPvFyEGTHhoJqd
   vS/1cQg77pLRkzMuLu6KBjz8QiA9JXFp5N63tWXz7S3llD8QsNUbaAGxv
   g==;
IronPort-SDR: a4mrNviVTf8TYJu51oSwbCrEfDTNIh9VoNzSTMDwCIfozjzGHef7QzELOP0vAjLzkkkN/IDfJT
 kHPGbAZKcSYMebnlO89zqt1gS4WPA7Uo3r7ihq/jn1w10IfDACvzW9KKXUwLl5WYnaQs0EvjJg
 xyf8vIj0EEf3Dpeg0THv2iBgK38rHWtwn7XFj5XXyrAjwmUDSa6R57Fe+sbegUcUxYqTV5JzwO
 5ZugQB+mv5D10Zx75DBvbkH/V4JtsAE68pXxRjCvR8GxXtO9kEUexzZgkE0Qn8/mq8A19/1Uah
 l12K5z0TP8e0PcLJzi+x0L6j
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="152163268"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:33 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:33 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 5168F70236E;
        Tue,  1 Feb 2022 15:48:33 -0600 (CST)
Subject: [PATCH 09/18] smartpqi: avoid drive spin-down during suspend
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:33 -0600
Message-ID: <164375211330.440833.7203813692110347698.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Sagar Biradar <sagar.biradar@microchip.com>

Avoid drive spin-down during system RESTARTs.

On certain systems (based on PCI IDs), when the OS transitions the
system into the suspend (S3) state, the BMIC flush cache command
will indicate a system RESTART instead of SUSPEND.

This avoids drive spin-down.

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b32a5a5a5c21..ab12507da436 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8976,10 +8976,19 @@ static void pqi_process_module_params(void)
 	pqi_process_lockup_action_param();
 }
 
+static inline enum bmic_flush_cache_shutdown_event pqi_get_flush_cache_shutdown_event(struct pci_dev *pci_dev)
+{
+	if (pci_dev->subsystem_vendor == PCI_VENDOR_ID_ADAPTEC2 && pci_dev->subsystem_device == 0x1304)
+		return RESTART;
+	return SUSPEND;
+}
+
 static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t state)
 {
 	struct pqi_ctrl_info *ctrl_info;
+	enum bmic_flush_cache_shutdown_event shutdown_event;
 
+	shutdown_event = pqi_get_flush_cache_shutdown_event(pci_dev);
 	ctrl_info = pci_get_drvdata(pci_dev);
 
 	pqi_wait_until_ofa_finished(ctrl_info);
@@ -8989,7 +8998,7 @@ static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t stat
 	pqi_ctrl_block_device_reset(ctrl_info);
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
-	pqi_flush_cache(ctrl_info, SUSPEND);
+	pqi_flush_cache(ctrl_info, shutdown_event);
 	pqi_stop_heartbeat_timer(ctrl_info);
 
 	pqi_crash_if_pending_command(ctrl_info);


