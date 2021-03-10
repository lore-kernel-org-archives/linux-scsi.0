Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15D4C4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9488064FCE
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhCJUBU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:01:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10557 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhCJUA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406458; x=1646942458;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yCza0KXmw/iBm0rfhBOvh/mSkQrLBUB53lstGy7dZec=;
  b=Jw/Vf2IpYXJy0zgbu34SVdKZf6AmXtHQjMlERsRBTDXzQyPHfJJ/zctV
   bE2H9NDBoC6mBV6U9Xuf6pWMXfs+iyKmViAypj3U0q95eeAIUKBeSJz6J
   VbKubisx20pS6xv6wsYTOGq2ctGHdoEvliT4PtWHYOLuza6GnCEDmBeYU
   Y0EEpyFi8IJatFIgyn40d/scsC/FDFlEppOPavD3y+JULaWeUQhChZkZL
   Ck1/8Hw8FkK1wTKtcW02cvzVW2W5KXzN2mDNSWZIFLtvgCX59J4QOWoAx
   M3XYgZCfZCQoGxUCPTXMs7o+vMfvVN4Ecfa1wZJVRZySt+5BeS6MrAP15
   w==;
IronPort-SDR: U/O2Iq5KHVIFB9nQ3YLl25GgXZFibSc1+Sy9RfAmMZ6nk908nbcANf2HzvCMfXpK8I1ZVkXWAX
 kgQao0IFA/u1oX4t4KC45KekSmtQGvrDeg/icg1WRucRAnVAt2+pntNh+DfvAgwW3wH6ocMqA8
 lS39Ui8x3Xp2wYCjLThrY9gWLW7qzTc9nXg/nXsiUvE3Ff/GVPNn1dmu8MxgqiXkbrDgM2SE3j
 SKpkhQD2ybepepK3ccFfb9s9g7lXNh466w7YsGne7qVi+u8QjBxRm1yA4Jsnw4pvbEq+d4DKJ+
 vE8=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="112247013"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:00:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:00:57 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:00:56 -0700
Subject: [PATCH V4 02/31] smartpqi: fix request leakage
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:00:56 -0600
Message-ID: <161540645657.19430.13799090089591940013.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Correct request leakage during reset operations.
 * While failing queued IOs in TMF path, there was a request
   leak and hence stale entries in request pool with ref
   count being nonzero. In shutdown path, we have a BUG_ON
   to catch stuck IO either in f/w or in the driver.

   The stale requests caused a system crash.
   The IO request pool leakage also lead to a significant
   performance drop.

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c154e4578e55..2886884ad584 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5489,6 +5489,8 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 
 				list_del(&io_request->request_list_entry);
 				set_host_byte(scmd, DID_RESET);
+				pqi_free_io_request(io_request);
+				scsi_dma_unmap(scmd);
 				pqi_scsi_done(scmd);
 			}
 
@@ -5525,6 +5527,8 @@ static void pqi_fail_io_queued_for_all_devices(struct pqi_ctrl_info *ctrl_info)
 
 				list_del(&io_request->request_list_entry);
 				set_host_byte(scmd, DID_RESET);
+				pqi_free_io_request(io_request);
+				scsi_dma_unmap(scmd);
 				pqi_scsi_done(scmd);
 			}
 

