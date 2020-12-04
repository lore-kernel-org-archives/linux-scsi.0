Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C184C0018C
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBD0B22D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgLDXDt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:49 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:48973 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgLDXDs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607123028; x=1638659028;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V3ZFAee8kjnF5fem46YCVTq9Tu6zPg0HPIuxEfi3qMU=;
  b=t+XH9hp0Fbh/aFtNUGUrIbO/CnLB1JiH/AKXLXYR0TTErDpKBK8e8PzO
   ie1qAJP0gMHH2sD95KUKXfPfbZ/Suo6UsXRBPlidp/WGoJqJ27/DiktPU
   OfK0+UJGBdFNyKrlyLnmcGQr12wqki07Nx29oTi6Bgqz8sKh52OSNExm0
   79i38GydGS5+xDTiUnhp06PTnPu3A3/+lHQnY+GJcsDWzipNKiryPdYzl
   YVMRV6VFBdbKEO63LeUv87TSdFmMLcw3hTcmQgENkktU5Nvv7kq0ts5PR
   ShP31PoU9/ojT4fmRo4hbAOuW1gHI0T03Us5hRxnKlZrJEw0iU/mBEzsE
   A==;
IronPort-SDR: 7LT+VtB3CGeep+rRP7SU6ZS16lhK/LWRF9RtTp5n2BZLdSsjQqXaAJ3zfPXQqPQTQw5U9VCrQ6
 wQj7lfN/llAl2wDovGgSz1igmpR+Tq+Le/0v1EJAqEV9EVPWRsL/Z92x8b51qar+Atvhv/Saoq
 FO9nFxvjEl26DdM78QCdBPHjCBNoLMllNnnP5n84Mto5ea9BkL1LRsejAweeFE3AQs5NIOuVae
 GZ8M32t+iaxRrC2mQymqXXHXu06jWFqkZ/5AYQ5gghoAvv41R/8btNshG00/Q+rv0EcElP+Xk4
 2cc=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="95934708"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:02:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:02:59 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:02:58 -0700
Subject: [PATCH 22/25] smartpqi: update enclosure identifier in sysf
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:02:58 -0600
Message-ID: <160712297842.21372.14060743747106039439.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
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
index cfc5505e8234..01e62eb08583 100644
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

