Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAAF9C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbiGHSqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239647AbiGHSqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:46:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250A84507A
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657305958; x=1688841958;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=owPSXz2FNyGZVYkm1mD4JYTa4HcHy1V8Gni3UU0GnJ8=;
  b=O+iYvDMcblrYkhsk8hW2qfc94p/aURLNdx3iN2VKtU0kpfSRkIErz1G8
   wItUOXZ+Q56waxW3pg/4hNurP6GcBuHAtfYheG5Lk2CQ7cosftb/D0r20
   q7gks4amR1OaewdbPwM6+4ipDAYBdMEPxUj3NiQho9WvDIzUJ+SJW7J9/
   FPcgFa2enosF9/vP7TVGezNNHbD/Uz+iweGwO+1w+bBttWWrMHrErfFtD
   lSB/WQgzoX9yYoi6MIU6eb06m3hAfl5vMTXD4OyMBphAHL9thh44cRes4
   b9mEzB2K0Mogrkqkeq64MrF8NozJTya9+MhjA05hG2p1NNEQaFE+VwmnK
   A==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="171645941"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:45:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:45:58 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:45:58 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268Il5Dv177331;
        Fri, 8 Jul 2022 13:47:05 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268Il5YD177330;
        Fri, 8 Jul 2022 13:47:05 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 04/16] smartpqi: close write read holes
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:05 -0500
Message-ID: <165730602555.177165.11181012469428348394.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <Mike.McGowen@microchip.com>

Insert a minimum 1 millisecond delay after writing to a register before
reading from it.

SIS and PQI registers that can be both written to and read from can
return stale data if read from too soon after having been written to.

There is no read/write ordering or hazard detection on the inbound path
to the MSGU from the PCIe bus, therefore reads could pass writes.

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Co-developed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Co-developed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_sis.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index afc27adf68e9..2b99b6e9cd71 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -194,6 +194,7 @@ static int sis_send_sync_cmd(struct pqi_ctrl_info *ctrl_info,
 
 	/* Disable doorbell interrupts by masking all interrupts. */
 	writel(~0, &registers->sis_interrupt_mask);
+	usleep_range(1000, 2000);
 
 	/*
 	 * Force the completion of the interrupt mask register write before
@@ -383,6 +384,7 @@ static int sis_wait_for_doorbell_bit_to_clear(
 static inline int sis_set_doorbell_bit(struct pqi_ctrl_info *ctrl_info, u32 bit)
 {
 	writel(bit, &ctrl_info->registers->sis_host_to_ctrl_doorbell);
+	usleep_range(1000, 2000);
 
 	return sis_wait_for_doorbell_bit_to_clear(ctrl_info, bit);
 }
@@ -423,6 +425,7 @@ int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info)
 void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value)
 {
 	writel(value, &ctrl_info->registers->sis_driver_scratch);
+	usleep_range(1000, 2000);
 }
 
 u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info)

