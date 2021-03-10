Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2303C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C73B164FD2
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhCJUEA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:04:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38591 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhCJUDy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:03:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406633; x=1646942633;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=libaO7361Fie9I0PS+qJ50MdjBQBa0J8Ak+x0QGKWdo=;
  b=ci5fdOc+fnMlwsoydY0vvTJWdpOW+2uRHBCI9nkDmBXzdpcC2BLRUfSu
   Y6xSbTOWsvl/m/CnJNG5smLomp8I5vAxcGbh3cMuxrrtMGzyoBVSIx32r
   JP+0sdX2qPx3Dw9fa8/2NpFVLz+CLT0z2ME6apJmyWGnKdJJSe9VVvUlj
   Rcv+qBaXuJbRCieRNpTf+Ont7qDQ0u2ZDDkxpsay7Zerh5xLig6ahj7AR
   D4cDyPIeOa2ZVFCywJ9MiCoLap26jNvfBxafRsug+3UYCLj7Cg3ge1EPo
   Ov4HylSbWqew8+G/rkQooM+8dMBotwBsHy97qDrl4HjkW5T/H/VJOHCML
   w==;
IronPort-SDR: Rg9q+vg7ooZ4/jeFoe64tPZFvBgTsLQE7F/Q0B9iMPdupD4yICpw64UflHVH+2lt/gtUkvCvGl
 bjNksnHh2ZUDZM9EmFcBA/TpabVVdMhazAVAENbr6V2erCBX9LgNU/uocMqrDfhZbDVx0S47c0
 v8fqyEvGXvHu8xHiBn9/IxlGX+DshqrLvcHCUmAZ1MLakb5njDZlc9DWNvVNPZgAk4vm2A+FvZ
 ET/IibpKRdLV30xYeJ7ZQD1ATmy4jcn60OjSnUdQ9BneB0x12874tT70kqHAVl8bxVqIqQeA4Z
 BT8=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="106699618"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:03:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:03:35 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:03:34 -0700
Subject: [PATCH V4 29/31] smartpqi: correct system hangs when resuming from
 hibernation
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:03:34 -0600
Message-ID: <161540661452.19430.1006952941211641788.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
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

Note: suspend/resume is not supported on many platforms.
      It was originally intended for workstations. This patch
      is already in our out-of-box driver and has undergone a
      lot of testing.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 330688c32808..48eddfdf0a08 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8651,14 +8651,21 @@ static __maybe_unused int pqi_resume(struct pci_dev *pci_dev)
 				pci_dev->irq, rc);
 			return rc;
 		}
+		pqi_ctrl_unblock_device_reset(ctrl_info);
 		pqi_ctrl_unblock_requests(ctrl_info);
 		pqi_scsi_unblock_requests(ctrl_info);
+		pqi_ctrl_unblock_scan(ctrl_info);
 		return 0;
 	}
 
 	pci_set_power_state(pci_dev, PCI_D0);
 	pci_restore_state(pci_dev);
 
+	pqi_ctrl_unblock_device_reset(ctrl_info);
+	pqi_ctrl_unblock_requests(ctrl_info);
+	pqi_scsi_unblock_requests(ctrl_info);
+	pqi_ctrl_unblock_scan(ctrl_info);
+
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 

