Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15236C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C16CD64F85
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhCKUQx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:16:53 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45728 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhCKUQ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:16:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493790; x=1647029790;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g6jlkvs1wBR2sYKRpjxZvF44Hz3ukVx7LlpeSXUprEY=;
  b=uCMCzxAWVVHE19y2pATr9xW9s73jUrf1VZrNX4oJfBqPEFdm21owVPUd
   74S1gLBMppafHjDzMnJyvolWnLxFQ4cST2UHR59oXkvvBUN73TBk99tx+
   LKin5msIr/hngZogGG/kvBopfXlh4T/BJUPEaEW7SIfLoCopbJKxGFBmc
   oZ84+KGh1+N0bYNdBYPO9aE7Xuez0+36+9tYOuuSpnlQU7AmKBB1JfBMC
   5/ve4VefrXUT9poSs92rfNfOI50+TbZg/wpvGYlwWOHrOEFGJ25C9DV2+
   sCD6L/RdxbefVNnICJ5+nNidX0uilsrW0boyZNkGJFfya24NedVJpPoyD
   Q==;
IronPort-SDR: qtqUmeFRHwJpy9nWQGobcHFcjWgfldPgRxmoIB1vckkL0vWrvPuOUhW3fXwL4VdPBQ74yeYv+2
 nVmsyqyTl7h0HYKe3YToCnaC6NHxIyXXdaggNCv/3k+IdT1RdNKBnZf6us+8XrY9i7pFbMezoy
 YzXk/3cFA4y3D3YM0bzzeBgUDVXC3jXA2leH4+Ejli1lp3Yfu+3huH0Fes5HrYYCaJlkcKy0fv
 gOB0Cqm9nxUBSROLUnJuY4tW+OkqyjlnNXnhGv8yCYS6h7cborWRu9sp3vUU8UGzsmZD4GfiiR
 1Tk=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112406024"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:16:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:16:09 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:16:08 -0700
Subject: [PATCH V5 13/31] smartpqi: disable write_same for nvme hba disks
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:16:08 -0600
Message-ID: <161549376866.25025.5961694654342018260.stgit@brunhilda>
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

* Controller do not support SCSI WRITE SAME
  for NVMe drives in HBA mode

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index dce832f2614a..e8d27b133fc8 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6252,10 +6252,13 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
 			scsi_change_queue_depth(sdev,
 				device->advertised_queue_depth);
 		}
-		if (pqi_is_logical_device(device))
+		if (pqi_is_logical_device(device)) {
 			pqi_disable_write_same(sdev);
-		else
+		} else {
 			sdev->allow_restart = 1;
+			if (device->device_type == SA_DEVICE_TYPE_NVME)
+				pqi_disable_write_same(sdev);
+		}
 	}
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);

