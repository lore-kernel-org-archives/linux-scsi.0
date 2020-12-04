Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EB3C4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B7FC22D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgLDXE0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:04:26 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1456 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgLDXE0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:04:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607123066; x=1638659066;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xYZN3FRbTMguNn3cxo8CKKBXr+jqAuoIaHF1KU+m+wc=;
  b=XclMlUHdMJ0y/D4vSPvgDpt5tzxHWRatuld6mU/+Dt20Gh2nw2K8RdRT
   OKSQQwbYtcZn06AzMLoXxjSCSv5dqlhSFxqMe52HfGZKzxnDa3c9ALDoV
   RRAMGoG+nDeLPBEKArqZ2c2UTCLrUaXfPCjsRN4H73cI6jRkbtoZw69ED
   75wBJgJ8kb7PwfdYa2XBjagPLxyGU56/GK/Kxn9E92g+nIOPwzNSJrhc0
   3Fbi5Yro1DqTkwF/zYP+UCpoTDJp+9kY00UV5wo/YeS7h1lKK59hzjtp1
   Btk99QELK0h7grPBU0aixvP6uD0hR2ROJq/hk96Ag07yBjbW7k6gGndS3
   Q==;
IronPort-SDR: wsYeIkuZmASDyMRBU43BfkvgmjjLZdswCoFl3FfDD6oW5RltIqjjyApzeh0y+yLnIM4B49oVsX
 HyY6EpjMJbnjrqRZ1KcOkXbg9QyerWc99jQ+OngEMU8vFHldlzSva9VvhtD4wGhqKBfgcH5edi
 2IJSyvXbkWwX3lepTSWwQnbBy4QQxzLHP05DaxgHtr/0NmeWf03njYJSPJWYe4FIwDce36n3QT
 wRUMLbphCfs8pS1nLx8nx4fvSjOPz+XDxqICOg6bBpsJ9Lv0NJKcBsPj23JLjWwvAcJJ58HSve
 mX4=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="101548931"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:03:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:03:04 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:03:04 -0700
Subject: [PATCH 23/25] smartpqi: correct system hangs when resuming from
 hibernation
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:03:04 -0600
Message-ID: <160712298422.21372.9624784570305531704.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Correct system hangs when resuming from hibernation after
  first successful hibernation/resume cycle.
  * Rare condition involving OFA.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 01e62eb08583..acfa57beb3c5 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8619,6 +8619,11 @@ static __maybe_unused int pqi_resume(struct pci_dev *pci_dev)
 	pci_set_power_state(pci_dev, PCI_D0);
 	pci_restore_state(pci_dev);
 
+	pqi_ctrl_unblock_device_reset(ctrl_info);
+	pqi_ctrl_unblock_requests(ctrl_info);
+	pqi_scsi_unblock_requests(ctrl_info);
+	pqi_ctrl_unblock_scan(ctrl_info);
+
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 

