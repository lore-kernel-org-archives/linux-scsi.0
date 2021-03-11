Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57223C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 282FF64F8C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhCKUSB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:18:01 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:20609 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhCKURo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:17:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493864; x=1647029864;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mgt62ZGMA5szaVFrqMgDhWJOl94gDhbN1lnJQgQlI/A=;
  b=oTU5OkUBRO7Q9FHvc5vhBTayasRdpkN63t6YWaQqiprNJvS3mr6YApma
   ng47rdp5CjEZYyEnhEVLBw2GFFQC4XIx4pSyTE4Yx+zTIjm3fRmyDSGnB
   C7QwVnPahFnVs0hKOHtqgYMarEFbTamDTGpyx7SS6okr6BBCDtYqRP+ju
   sqdGW2LgTdcj/6oRgI8HQ4aZAvhj+mtl0j/lwOaCXx6NnXG9UIsOOdhhk
   KNOTiEZbhQtVr5/SJXjerS5L+2NckIXOnSPYZtEBSah0PHPLSCa+3RIDZ
   TCH77jUyApqRW9gHf5NOvjvYY07q7zbL5Fsy0iFbJlcum2mRBdsirL+tG
   A==;
IronPort-SDR: ZGyV5AusdP947uBhXZJXcFZDxiW5/DNXjpaAtt9t6Q6M8jEtw2VGyCsP8yrWbVwzTli3aNKMQh
 QgXCOpi34Sf3u/FeAnVmYg1+ZR7SUQSNw2IQuko8wpFlX/hapBdE8QjtCKEwGbbE8S+u9IUow+
 hWSgpXu1gu7SlREt6DlQoD3zVh11IH9x0519RGBIgBsebrSv0EAEBQxRy0sqVs+Iuikf5+bdz4
 yNejKq7c56zNv69InN0FSzLChgXF0Q31rXHZkA/Ep7uIy2twFz1c9Od17MNlxkE7mBWTqrdG9L
 7IM=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="47186668"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:17:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:17:43 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:17:43 -0700
Subject: [PATCH V5 29/31] smartpqi: correct system hangs when resuming from
 hibernation
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:17:42 -0600
Message-ID: <161549386295.25025.14555840632114761610.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
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
index dbc0d3732d85..939da70058a0 100644
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
 

