Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B2FC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8D9264F89
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCKUSA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:18:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18884 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhCKURi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:17:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493858; x=1647029858;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7n6lCmtrdJ5vN7N8I6SkuHlFyX6Fn19VB68F2Rfr4EI=;
  b=owtTB3B4yMfSB/BU+M5F+R8WR+KlhpR4wlZzv8UUtFBhYZOx7x0hEWGc
   Zj/2zoro1d3BnV8CgmplCF0O3fUqSIaoRx8troHE5cXPM6evoYDrXvnQj
   vlmF1WgSMCI2tZSXY8XfWIHUz310w4Wfk9It5J5u3rvhp6LkGpX4f8esH
   +QyQ922KQCttQHWGDLWTXlgYR6aFqXMVNl8rSqbBMA8RdEDv9Boa3lzHP
   Nv/KyZvI6KzB5L/t3n16bFvqxdvC2+RmeVzJEALVn8LUFrK7A8fE8XnWU
   uD1ay9DxoptE1cyE++81KqaFG77WxaQpPojWLweT0nu77jK1Bqa9C59sN
   w==;
IronPort-SDR: qOruYeCjyyLuTZZPXTtlK2O8wvmyb6LYugeG7zhNM5AXu6GoqKdUkAKo9iZUGN2Llf0Ko/Pef/
 j8vJBkotMrU3r2gtv0r203RwYR2b9kkOoshK6gWbEdkZzZC3JCK/r5syQCAPwDeJzrOkw2ab3w
 t2prEpgs1ufKK7kc5bWzw/NJwS2snKReQJRsW5uniPNVM+ZUOsiJqgqFfrljcmq+4FRwOy6j5l
 VXpQQkBFrwuJeDWZW3gVnv8/VHjc7fylil3TYaUmkWvg/Uxgu4oMYcXI+AHvznJAoSBK78ucRh
 WEY=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="47186664"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:17:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:17:37 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:17:37 -0700
Subject: [PATCH V5 28/31] smartpqi: update enclosure identifier in sysfs
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:17:37 -0600
Message-ID: <161549385708.25025.17234953506918043750.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Update enclosure identifier field corresponding to
physical devices in lsscsi/sysfs.

During device add, the scsi devtype is filled in during
slave_configure.

But when pqi_scsi_update_device runs (REGNEWD):
  * The f/w returns zero for the scsi devtype field,
    and valid devtype is overwritten by zero.
  * Due to this lsscsi output shows wrong values.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 91616ddafd17..dbc0d3732d85 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1840,7 +1840,6 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 	struct pqi_scsi_dev *new_device)
 {
-	existing_device->devtype = new_device->devtype;
 	existing_device->device_type = new_device->device_type;
 	existing_device->bus = new_device->bus;
 	if (new_device->target_lun_valid) {

