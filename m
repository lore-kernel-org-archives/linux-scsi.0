Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEBCC38142
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 06:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjA0GfK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 01:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjA0GfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 01:35:08 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776A339CF1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2023 22:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674801304; x=1706337304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UVFgoFejI+9PS5zEpnPsfzexNoDtD4C02Q20JO63kw4=;
  b=f+xy+S30iRy29mFAHpR9IgGd55a0kU+uQF+8yZpVT0gzMiS0aT7oZjES
   6DQMeBfNHp4tX87A8uHgOboIT8sHJVObuX0OrIUqpGpP92quUTupWvTYD
   lOaTy06piHXNvILIRojF7q0eU72LXviMLamVhlV2btuVa7vMLqXYmdd7S
   waQX9JKWvVk8pohQDmY12OBgdpJBO210te44F4lMnMNi4QWRYlaaxNReU
   cEEFrb0sc3oJUelK2SMNG+/JIIdV6ExS0M29E/JufNFyJDgjMKtAQ+BgG
   +xyLKmYmeUfdwOO+eSkpBEoIXana4mViznfKC9xOlf/GNyj0OWwiIDyAp
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,250,1669046400"; 
   d="scan'208";a="221934997"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2023 14:35:04 +0800
IronPort-SDR: dvInHzjvQfn+RVsOUZPABi4OCvaTaWHp38h9fahM1BI8itwES+CMwTfe+cP9F1nxrjBrHwMNaw
 glzAPn5+2WX9ZxwHUQQzhNwsgGObynml2DqhJlf5VOTGXGtp4dkFJPl4ywN0oIfJgicpAtnTjy
 4f6nr5lVWMC1PlWQwJlHm2+HewXKpaJ+hvS6FVGM2WAzCao7iTmqmh0/Yi7bMDAyrkZqmxRSLg
 fYDRqeREJ95Z3fDnasYiY/36GrsRVzsO4tJWoxC6Y+/6tmUiPOo40QqEVEqfeIwE/b8pxy0Xzq
 vCQ=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Jan 2023 21:46:48 -0800
IronPort-SDR: x2ugXV3YimJ2ssO8VYVxTHIk/euR9587CLhvDm+zhTJVwQ8U3a47HQt+TlJKmc7ITFnlcrR7Hj
 /OKZbmhzAKqsGoMptcVw5M0lNC9MfGBRaltYWBBv2lchEL/BuEPnbVneFTBW7eipFhYjr7JxKM
 xckHilfz3Rex5lEnuvqlvdr1wHbwOgL1K8yGAmDVrJa/nCJkso81irotug3FCvV/e8tcse6Mf4
 lEISd7JqLaVYcx8k4Wu4/b0BY/lZskBe8ausPBaVNb62sm7twoKnuZfA68OhuKP3Unc374oRpD
 I7U=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 26 Jan 2023 22:35:03 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 1/5] scsi: mpi3mr: fix calculation of valid entry length in alltgt_info
Date:   Fri, 27 Jan 2023 15:34:56 +0900
Message-Id: <20230127063500.1278068-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
References: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function mpi3mr_get_all_tgt_info calculates valid entry length in
alltgt_info whose type is pointer to struct mpi3mr_device_map_info.
However, the calculation assumes that the struct would have size of u32.
This results in wrong entry length. Fix the calculation to use the size
of *alltgt_info in place of u32.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Cc: stable@vger.kernel.org
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9baac224b213..49916ae617e5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -346,7 +346,8 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 
 	memcpy(&alltgt_info->num_devices, &num_devices, sizeof(num_devices));
 
-	usr_entrylen = (job->request_payload.payload_len - sizeof(u32)) / sizeof(*devmap_info);
+	usr_entrylen = (job->request_payload.payload_len - sizeof(*alltgt_info))
+		/ sizeof(*devmap_info);
 	usr_entrylen *= sizeof(*devmap_info);
 	min_entrylen = min(usr_entrylen, kern_entrylen);
 	if (min_entrylen && (!memcpy(&alltgt_info->dmi, devmap_info, min_entrylen))) {
-- 
2.38.1

