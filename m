Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBBFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbiBAVsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39807 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiBAVsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752088; x=1675288088;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DJ3T2ggtpSoCill2TfLc2bOreHs/JxdSczSCFxUAlWI=;
  b=ACI0hcvtBC2QtuTM7by+uQQ+JCuP7GgAPzjmcz/bV3zUoQB040uFb83C
   hMmyjnKMLrPjRlylg5cZiGWHmzTYFX2rckLgaHVsabGR2f/qQUOPhA+3R
   ElbuSFwpro40AjaN4+KauOVJDEtN4k0AQAOc/RtNC3BdhLavBEuW8W3OK
   CXwJG3fhJ4QaVmV1u6NigOb/Fh5ddmyW5E2cgI0+2DJsB3OEs59m0pjBW
   CconQ14HZuzpHnv7BM5Q7qfPvhtaSZywc0TvgBLxpF/UdRNEF8sImvOlE
   LzK/vSYETo9iAdKJvUqQoWkSEj62cnOWYULM0F7bVsIZwRNzm3VXoKOpC
   g==;
IronPort-SDR: AP4jPGN/5xfBq8iFnYJc3iNS2A1krDFNq9iekpQwnHEAfy+pLie/zDk0rz7ePPQcEDr8kn1VWE
 9LLp9RJQXsDBeruz/jDbCAtCpZm849Wps+LUDOnOTeOUcoHNtMwLohLqwL7fjFodc/Oncibvq0
 03dDtXHzJtrmshNhSOp1iHaGsPToRuIdtnlsf0Msxtkg9dYTxJye30kclqnQjD8xHiXJYnenbU
 eh8QnHoz+PloZ1Ss6JjrRjFKs8922/nzbfIO7FF0mefkgd/yg2sGyl0Fr01YsS6ovIrdhQr39F
 VHlr+oF61/EONkh9oknaI/mG
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="160764656"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:08 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:08 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 1FC7C70236E;
        Tue,  1 Feb 2022 15:48:08 -0600 (CST)
Subject: [PATCH 04/18] smartpqi: eliminate drive spin down on warm boot
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:08 -0600
Message-ID: <164375208810.440833.11254644025650871435.stgit@brunhilda.pdev.net>
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

Avoid drive spin down during a warm boot on Linux.

Call the BMIC Flush Cache command (0xc2) to indicate the reason for
the flush cache (shutdown, hibernate, suspend, or restart).

Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ad9fa1628a69..f51605cd098c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8902,6 +8902,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 {
 	int rc;
 	struct pqi_ctrl_info *ctrl_info;
+	enum bmic_flush_cache_shutdown_event shutdown_event;
 
 	ctrl_info = pci_get_drvdata(pci_dev);
 	if (!ctrl_info) {
@@ -8917,11 +8918,16 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
 
+	if (system_state == SYSTEM_RESTART)
+		shutdown_event = RESTART;
+	else
+		shutdown_event = SHUTDOWN;
+
 	/*
 	 * Write all data in the controller's battery-backed cache to
 	 * storage.
 	 */
-	rc = pqi_flush_cache(ctrl_info, SHUTDOWN);
+	rc = pqi_flush_cache(ctrl_info, shutdown_event);
 	if (rc)
 		dev_err(&pci_dev->dev,
 			"unable to flush controller cache\n");


