Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA39C54EBD
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Jan 2023 01:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjAJBzq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjAJBzn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 20:55:43 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F0813F81
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 17:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673315742; x=1704851742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yP+pfioZVPWpcD8jAC85tCAaBqkXEUgxq9uVOK+1vnM=;
  b=qLd/BO3FutusRhF/fOPKIM66WtgKz5WuABhnpy+5Q2n53/up//UaG5Wz
   bgvlkDUlnPnzIAko5xB3oo0FHBvQqdqKFj+RHBV4ttWf9dOVqcQ0ivmZS
   b85eA5WoVrtJ6dPpUWfn8L+dm4W+JNkvInVdWkKHHxFhNRYmlKgXCDGfL
   rh8WxXU/nTsVMTgcRgOzUElbfE8cj/8BtCK4KyN4+eBuh9OI3nlyYCDBr
   CuBeBZ/0U772c5RAsuudTSFlDJ6ipeO1e8waKquw0pAFqV83XFLEUxVQu
   7jaSQvSRs8YbzySddLPZprZt+pb4DiDJsOBlSf4+151Rnray0ygwa6vVE
   g==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665417600"; 
   d="scan'208";a="324698281"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2023 09:55:42 +0800
IronPort-SDR: oorP4nn5SgHGkrgnqHfGj4J+zCeOVUz/y6eJ6NER/ChDuRCeYSxmnRxBH4rDSKWKlncZ/n5cZr
 q/vzwk7vv9TVz51aLlcDsT+80lVx+k39CHKHZwf5k0l6WW/Uf7Fvpt6XIeQlDlnafkhqUs5/Vw
 HRZD0V2UnDF4LfMYcddQ+biZA2psoZZop2lc3zM5MZWqctfHoDFHB/AhlOlzyj+HcQh2WgMEyj
 vxDJipnEhB7hU7qrGe+U0t5m1fyVCc4vLTIYncEzeJbB3yai5iAgEdBKLEl8Kq1vulsjldwD3V
 tXg=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jan 2023 17:07:48 -0800
IronPort-SDR: Jx2nqKqoveCzDuVh5fYF0UCFBm16qx8Hr/gNdg/ifcfrFmiQz5zroSKaN8sKmmazOEJxlssUGJ
 kxiXXGzGydTqJs1xiwIDkqhzAiaRGU+ry931KEGXRREgs7OqcnQ1jFjB+/+gbDZnSvgZyCScL6
 pDPZy3P0IPNrSb0XuDhXF3OA9YEZmNZyTmysTvYEJUzEtyFtbUUs19hhdlVo027XAmWR7u2lKm
 L5GpO8fXgyf61MSpe9dSBa1d4OpXKp5Jw7kexkjScuUxqkf8b34yNyHwlIUNcQuIZUHIpWncOr
 u/g=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Jan 2023 17:55:42 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 2/5] scsi: mpi3mr: fix calculation of valid entry length in alltgt_info
Date:   Tue, 10 Jan 2023 10:55:35 +0900
Message-Id: <20230110015538.201332-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
References: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
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
index 5bbfdff70570..239cb5e07b24 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -345,7 +345,8 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 
 	memcpy(&alltgt_info->num_devices, &num_devices, sizeof(num_devices));
 
-	usr_entrylen = (job->request_payload.payload_len - sizeof(u32)) / sizeof(*devmap_info);
+	usr_entrylen = (job->request_payload.payload_len - sizeof(*alltgt_info))
+		/ sizeof(*devmap_info);
 	usr_entrylen *= sizeof(*devmap_info);
 	min_entrylen = min(usr_entrylen, kern_entrylen);
 
-- 
2.38.1

