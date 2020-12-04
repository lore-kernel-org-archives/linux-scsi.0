Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4CAC4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C74DF22C9E
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgLDXDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:24 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:21231 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLDXDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607123003; x=1638659003;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jK8Ao6vti47kIYtZeEfaypWBis8c7YLbSL2H2Sqzbmw=;
  b=w8nWH9VctVHv2m7dk+r9WUfH5bCYPd1V0q4wlear+cDlRKm9vztOoVgF
   Li+s2RybB3aJdDyYs1RNdCzBWbtmTpq9WHD+hPFdUkB4fEwuwsjVMK/hL
   x1Yj9ESU/Nm0+6iq/NM1JocpOmoHLtRMQhAbn2njqB2O8fCxjN7sVIISy
   PlWGXXtvaXqzkl4FZqV+DP5O7/aMN5omssdfyuqxJMC+hbXYV7LhC5Zg8
   C1682cYBmep5M3KfS+yxjfRJj1YcpNVsdR+3cBt+s/Gbb8QlD2EPLikJK
   BKovVXHYxvEwQppxYcNML0QycLvcUxAx4K1klO3o9JSPXNqTOC3iC/pOD
   g==;
IronPort-SDR: pb3D0iBal8yJhK91GJn0N0L5JPX3KmwawSND2IIXRAtuNlOfDfk6vZwsU88VEQAMnLwX4G7g2x
 p5aEPqSAAFxYOrgf8RSSrOCH9Ni7AVmsKyQU0R4KyMX2LprexOf5CRrQzpQ3fFVt7lkAEsUZaH
 crfEhu+vJ9Vj+2zvmocCvQhw/WFXenKG2Yyun+53WYZKhnmP4Lb5+2Y3lEj4jQtfhYWNUA3yS4
 OFNSem8g2u7aHQDDGCP9tO2CUFFgP5OcEOopnC0XEUg0XdwWepnpctxgpJ0yFR9sY+yx2C2wnF
 nm8=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="36193302"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:02:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:02:35 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:02:35 -0700
Subject: [PATCH 18/25] smartpqi: return busy indication for IOCTLs when ofa
 is active
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:02:35 -0600
Message-ID: <160712295524.21372.17275357939433334592.stgit@brunhilda>
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

* Prevent Kernel crashes while issuing ioctl during OFA.
* Before this fix, the driver returned busy indication for
    pass-through IOCTLs throughout all stages of OFA.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 52f59ae50fda..748735d71464 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6169,6 +6169,8 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 
 	if (pqi_ctrl_offline(ctrl_info))
 		return -ENXIO;
+	if (pqi_ofa_in_progress(ctrl_info) && pqi_ctrl_blocked(ctrl_info))
+		return -EBUSY;
 	if (!arg)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))

