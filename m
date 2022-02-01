Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED0FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbiBAVry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:47:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:19880 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbiBAVrx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752073; x=1675288073;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9jwKpXgIGRiAgCml0weWCctF7Ds1lVxof1cPp+TLdJ4=;
  b=L/CJ0nAJaa4Hvcb+7kqKNCbzzGhDPf2wVhCo0TAdQvfyaBVU53Y55TS4
   PFwV0o4a4+KVdaDYghLBQ8lrJ6ICAGiOLSriw4XIuKdESaBohn0aQ5C3A
   r1aeyIQdtqoKBAsXcYEJ2TmwmdCOA4Nr3VAK8g3NdMzqQu0d6ldllBKa3
   k5OhBQG3o+SMRgAzQsfdON2+gh8PJwavNCh1/RFNGhj2YNBh6ECobBW7p
   mXdrT2a3DAPZ3SCXzPuT41ot/WOZ4nd+57sdE0q/K0be/gYmbcYq1liMC
   VGtPWy+Uk9GDBluTrMxwyRMMYBZ38S8yozekFhWUPMyEAfxbNPBGLKaDj
   w==;
IronPort-SDR: NC+YY86P6c8vWwJEHU5EKOvBY6Xb5mWF1SCgcruyW7O5MSBJNGOH5ifp/g6GGj/2Ec2D5O0iba
 ejuI1PKsi/nqdWVNhU2sa/Px55AS+h0tYzibx+5lrsywPYg2xsPzt3VDXz1BmZAZxO9A1jRylD
 BMCMo2AOURqQTDeD4kdu0SrWjEzuebTm7UFoj5afWnWqI+VMlnCucbD0u2seUUZgVcKGTz1jCz
 mMduykWXNoj0BwwHtxnK6PmfSG0ZF9JSY2kR9lOR0dq1feDueV4kXpcvLAyGDkiKGQ1BJVQ5fj
 p7p3iD672jt4f88Rld97v6OR
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="152163252"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:47:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:47:53 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:47:53 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 0426C70236E;
        Tue,  1 Feb 2022 15:47:53 -0600 (CST)
Subject: [PATCH 01/18] smartpqi: fix rmmod stack trace
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:47:53 -0600
Message-ID: <164375207296.440833.4996145011193819683.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prevent "BUG: scheduling while atomic: rmmod" stack trace.

Stop setting spin_locks before calling OS functions to remove devices.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f0897d587454..2db9f874cc51 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2513,17 +2513,15 @@ static void pqi_remove_all_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 	struct pqi_scsi_dev *device;
 	struct pqi_scsi_dev *next;
 
-	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
-
 	list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
 		scsi_device_list_entry) {
 		if (pqi_is_device_added(device))
 			pqi_remove_device(ctrl_info, device);
+		spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 		list_del(&device->scsi_device_list_entry);
 		pqi_free_device(device);
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 	}
-
-	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 }
 
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)


