Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4204C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 19:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiKHTTd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 14:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiKHTTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 14:19:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D996517416
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 11:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667935152; x=1699471152;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dIPrSVVe/BE3b2hE+f2PXoYKuj8+PEbZxXXeSB3Euf8=;
  b=MoiVhP32BpYXVZ9/DAD1hw61n3XQ45BWT/1KwnzJPslDzjF5gfj3u6JJ
   m77XEyaStQ0hnzTpA90CsZXHZfzoIXuTLVqq/WQ33e/14VrH1gL5jz43o
   +jDbO5jxdAaYmPMTr7oqQPWPZpKSBD9bQhhDo7qRoDr/mjVRXMLmRMLdn
   7Fbeoe2GK+2bOOrVX5FcmEzwmhphzfUff8P87iMev42Cc6hf2A/Hm8c3b
   jkr0mxxHgkpI8GTeqVJMP+kq/OCja0iPU9Hbw3eAhkpPKgIS0SOrvhSDr
   fCVHBUrp+R5IebuGVAOw50InZmXZxgno5oOBfHfk/KcTjsnZ+fApFBX2/
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="122430434"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Nov 2022 12:19:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 8 Nov 2022 12:19:12 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 8 Nov 2022 12:19:12 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 2A8JM3MX322628;
        Tue, 8 Nov 2022 13:22:03 -0600
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 2A8JM3xd322627;
        Tue, 8 Nov 2022 13:22:03 -0600
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH 6/8] smartpqi: add controller cache flush during rmmod
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Nov 2022 13:22:03 -0600
Message-ID: <166793532388.322537.878022136408270892.stgit@brunhilda>
In-Reply-To: <166793527478.322537.6742384652975581503.stgit@brunhilda>
References: <166793527478.322537.6742384652975581503.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gilbert Wu <Gilbert.Wu@microchip.com>

Add in a call to flush the controller cache during driver removal.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike Mcgowan <mike.mcgowan@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Gilbert Wu <Gilbert.Wu@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index e82f4de46ea7..e9c924ac1bb2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9040,6 +9040,7 @@ static void pqi_pci_remove(struct pci_dev *pci_dev)
 {
 	struct pqi_ctrl_info *ctrl_info;
 	u16 vendor_id;
+	int rc;
 
 	ctrl_info = pci_get_drvdata(pci_dev);
 	if (!ctrl_info)
@@ -9051,6 +9052,13 @@ static void pqi_pci_remove(struct pci_dev *pci_dev)
 	else
 		ctrl_info->ctrl_removal_state = PQI_CTRL_GRACEFUL_REMOVAL;
 
+	if (ctrl_info->ctrl_removal_state == PQI_CTRL_GRACEFUL_REMOVAL) {
+		rc = pqi_flush_cache(ctrl_info, RESTART);
+		if (rc)
+			dev_err(&pci_dev->dev,
+				"unable to flush controller cache during remove\n");
+	}
+
 	pqi_remove_ctrl(ctrl_info);
 }
 

