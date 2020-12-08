Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B35C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B60023B03
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgLHVQk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:16:40 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:52637 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgLHVQk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607462199; x=1638998199;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3iysbxdcweA6FpDb+JibMcw9480HYf8rzKU/XeCjF/g=;
  b=YIN8OqL4PY+ctLyxMoNX9NOTlrplu1CHRnHbrPE6D8bImNIhWebJg15j
   5inXXNiwDdBVnWC3RT8dOyziW96SfF97oDxTdDdPwnT0Si5NTmfAy1OI7
   mJLll5cxL/jn/fnull83c9PxNsykS9L1WepvdYMpUMIOXNE918VDGwqhZ
   WghxnAxnUPO9qHzf87FrM1qdJpZ0njnBvMEDWc1W/oNBv2NRqwU2D2Z7J
   DdOe4pN/b6SCYcl5rLhlLKaMAanqWz7m54Er+lUKeFxlsAHUxxkoDRBI6
   KebInCM0nOXABu1vuVrGlG7OtuGmgJAYZ+XQp3pw4sciIHBcqpisXWqAf
   Q==;
IronPort-SDR: yKHjEDiuR9ynW0xWHlyov6JLwryLRLOwsU6U5jCbOzq4BRkWUoXPu4lu879q/nLJWHi+7OauHU
 bMDbqgJcdCMe2R3np1QRfOiBTRiHkmoqbQibC+VoH1QfvL038o7zk3kM129rB7I1UbKQpt1k0z
 cw7OTvGAQvzlRFPueI8MqTk2lq96yCoxnlxbqCEDDn0VzJpuNIT2QFP0xp4dXGfpcpVho8H0pR
 LWwYkmc06idEKZBAJLgCVp17J6+dAK4DcKXS1wfzQ3ocKqfWmnAjbaaYUp4uPZtG7IKpu5+I+2
 gOM=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="99080275"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:38:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:38:43 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:38:43 -0700
Subject: [PATCH V2 22/25] smartpqi: update enclosure identifier in sysf
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:38:43 -0600
Message-ID: <160745632316.13450.10656596945342942613.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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
index f59f5a1827d3..e7526eb27060 100644
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

