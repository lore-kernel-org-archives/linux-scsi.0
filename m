Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B6CC4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E1CC23E26
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404271AbgLJUh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:37:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:60408 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404639AbgLJUhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632629; x=1639168629;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1XDWa90Kcn/OyHyZWhxlNsP0stchyXp5uXblwrFhBp8=;
  b=gUW0ISORN3R5q6cCPNiDHq/wxZgVXa9JfVV8BULpvOUGqm78wEmDHS5r
   dq6m/aKXpvv0eZqarWXq3q/vJqJRaykL3KX3OHJbWY7uzrc0iCYjhW/GT
   FUdKJKv0SWGo7K52hVU/arSUDp3nbOnBcUL72sK36iw310D08QtBrgs18
   WFnI4CEYdIBJWtCj6ajKg83sccWZmj1fQAAo2LrAdInI7dg6blvbswDiQ
   FNpyM8gG0J5v6mehNxUszdLd1QAS427uzgHUYK61u29PVIeYKCemYibgn
   lu2xfttjlthXJzNdKkgkNu2Be+aKSgNbBqzzRDSJ5ryKM5tldjet42cJ7
   Q==;
IronPort-SDR: +EZipUBGAFSdSy3DEhSICM2O+NRBai/WcdGrq6VLA3eWOB1B4HT9CTvpJM0b3zBUbigpiAyL+3
 sm3+a4Uuu+8ZefBiZl4snExIyRrmeg9RuG0lD/oYGMubBNQWEF4qy1Aua9smd+2ekXKrvnAbXI
 8PPLPgnSwrH0tks2K5y4rXuZ19+Gd9/Og2U8kvYMro4aUwOEd3BpcXB8Qkpl5+skBJzx9Qs/3d
 mU0wZQj/jCMisRrYSQgkdT6BZlPwcVJBsEsAhu6K7hwIYmQO4uSQz9rngzhLSI4bl8ZMejtLHz
 kck=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="96675154"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:36:29 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:36:28 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:36:28 -0700
Subject: [PATCH V3 22/25] smartpqi: update enclosure identifier in sysf
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:36:28 -0600
Message-ID: <160763258826.26927.5141004289781904133.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

* Update enclosure identifier field corresponding to
  physical devices in lsscsi/sysfs.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 1c51a59f1da6..40ae82470d8c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1841,7 +1841,6 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 	struct pqi_scsi_dev *new_device)
 {
-	existing_device->devtype = new_device->devtype;
 	existing_device->device_type = new_device->device_type;
 	existing_device->bus = new_device->bus;
 	if (new_device->target_lun_valid) {

