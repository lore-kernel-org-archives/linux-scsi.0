Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA790C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8BC023B1A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgLHVHI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:07:08 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:62372 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgLHVHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:07:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607461627; x=1638997627;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k/e2DKv1G865CjikOCYAmAQDYHJ7/nlBxqcSs2M+alw=;
  b=L4e2M7SO5g4nCslhzzvoqkn9zsDNzrUfCYvO0kO2vySQ0i7pkl8+7ykj
   jGpb/WjrmIkHoEa5g4vKEcfJPjLpSeTAeK2X9JDZv2ZNJrhpo40foRnx9
   459+7ZV0V3NdMqUkZYbsjfsB/roL6LHF+cW5XewMnelZuy+uIT5djv/ZI
   yCeAp+5SGM48tjkookY1TtYMSxGiQgK3y9EyzErxS8fmWDjwaJSfECXnJ
   uAJWcWbgV+X8HmBp0drd84bz7bE6zsE9xTt625TjmP1on5A1X8OKrjrn5
   crMHXRGGr2ZZyCZgFZPXX4BsROtBzK+uVhJo1Nx6K657HNQ+O6iCmEtC6
   Q==;
IronPort-SDR: nKUeOsqeml+ggO/sOZLGkxbZKBY4DfUAeMlVCWFLi/xM9rP2/eXnpeICtklHwNEVsbx94MnnGb
 8UesIacTnTgqHsvCc6Evv64daanTUqoPxWNOiwSCvq2Pi+eUUBevw05l4dsjNataxd8UVD5cou
 2JMwEYgn+DcFYnWb9kysCFlkBOy6L852Ca4mfSLz5pPxe+16lYWjwZNcurMSj0cjlkCeJRQnR/
 dNI8DzKEgI/d5J02l+5k0r5jGYzG0DRCAsv47U+2KQQAAUhkyR95n3ci6j0K/PhQAahCWC8+Eb
 HoU=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="36640096"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:38:20 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:38:20 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:38:20 -0700
Subject: [PATCH V2 18/25] smartpqi: return busy indication for IOCTLs when
 ofa is active
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:38:19 -0600
Message-ID: <160745629987.13450.10537034711793793154.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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
index e7d86356bc5a..0cb137a46d6b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6232,6 +6232,8 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 
 	if (pqi_ctrl_offline(ctrl_info))
 		return -ENXIO;
+	if (pqi_ofa_in_progress(ctrl_info) && pqi_ctrl_blocked(ctrl_info))
+		return -EBUSY;
 	if (!arg)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))

