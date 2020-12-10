Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300D6C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D380D23E24
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393830AbgLJUhl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:37:41 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:44703 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404645AbgLJUhe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:37:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632654; x=1639168654;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IeGnp3DWJKsJWF7ZhoFyAqz5lnsfjFnygOBpWTTn56M=;
  b=P9kpKRu6sHwcMpfZ4twO8ULwr9OPJFCKFEk2F4UCmft12np1eZEGdiZH
   EJvjuRGD/mwuiVhKWlETAZVSsOKhWrHdRJtcMcXXRf+4FNB97UAK749g6
   8RdEZ30AfeyOXqfGTENX97OLjcMxYCh1VdPsyTphbvNGzPvjXaEfVmHOw
   fyKN6CfJ5Dqa6JoRwHciNcyoOeMSmchryhdr/tU5izsFjt/6uNkcGx/TN
   rmMeFVD8q4FpKjVaaauZwvWI6d3Us1Gnx+6fEKD4LU/gWLr5M8/rixBHM
   NTped8BvHdgVLqpWb1WV65M9slQ3l5c4HKbN3LkgIysoCMzZJyj/SOHdu
   w==;
IronPort-SDR: /wHiV2OiM95lXK8RCUvvzQZMZ8iLLEEgHG10mKbagH/hEzuOm1IV1llmEc9CqD35Cj68bUnWFM
 eqjJYkZGPc0ENW57rm/r4JNZqq0QlM4bhARfPtNDnm684V67vUK//YjxC3PTIMaxZHbA9jKBCi
 1Cdl89zNK3ZQ+/PQzOQLkq3Q2S2xTR/d4PsNz2hVXsvdi6e0XbSvglFf6COvvQ//Inr9DDJUcr
 Nxl54M5Yv4yjP6cvnkxc/nJHtPChZguoi99fKPPodiXHvx01QAkmZLtItbd0NIh+BGulYvu5ls
 BK8=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="102325209"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:36:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:36:05 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:36:05 -0700
Subject: [PATCH V3 18/25] smartpqi: return busy indication for IOCTLs when
 ofa is active
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:36:05 -0600
Message-ID: <160763256504.26927.9864878430274064369.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
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
index 552072812771..f6bc7d9850e0 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6238,6 +6238,8 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 
 	if (pqi_ctrl_offline(ctrl_info))
 		return -ENXIO;
+	if (pqi_ofa_in_progress(ctrl_info) && pqi_ctrl_blocked(ctrl_info))
+		return -EBUSY;
 	if (!arg)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))

