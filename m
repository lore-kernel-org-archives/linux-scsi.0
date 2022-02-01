Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066F9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbiBAVs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:30982 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbiBAVsY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752105; x=1675288105;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3VBkh0H7BmbBEB3KIm7RiyYljVMQPpin7e6PGAJCnt8=;
  b=TwjqnB5RiG173cS6s2oyz56jI8clVDG/4X6DkyjGl/EB4NM5HgqyHAxL
   JRC7tI3mMQI2HMRg7cZOutLqZf8Wtn6Avs9D08ODLeH7fcjiTWOY2VUrY
   w7nRS1N1u3CwZyps7p9q6GeypvmBQFoQkM1QSEY01nAxyJsXHxgGZGXmB
   wYAv5isODQHDcLeCTYRs754fP1iQ1ljFp5KHKvwdgiQ6l86ifMrL+4EgB
   Gk+cWpHB8Rea7xwqkYfMi0CUg4O38CUodn239ijQs8IFVLQNlw2/IZnZ9
   ehKDba8nu7P8EnnnijkLzs2afRgiw0yUK+3hdNoQnaN0sd3IkxuLiY9P2
   Q==;
IronPort-SDR: f5+pxna6rT1mnRk/A9Esg05uzxQVvW2/e/k3TcPD20bmChCEdq43ruU4Xxp1NqGDxPShMD6nfk
 gRwBlSuWfoFkKF4Tlbxay8rpSRQYPFJ2eqYPztaQPy3hS4qwIfm+ESSp8ZJij1YcdnNWU3Zm0q
 wWzmnkGiHTx57qkuYwoWVL0HDv3yHidHhzbmCLMPyXXO9hZG3aZL3qpTxa0JJEkpbTjF/dmFkI
 AlT53+AyIvNtHjUKvc19vZy7+7dbLB8WhChMTKqWmhnfeI29m6kX2Qx9/SaZLDstCHeFcoPEZf
 sMllUomhOhZqueqsOJsTtY5n
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="151639074"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:23 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:23 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 3E30F70236E;
        Tue,  1 Feb 2022 15:48:23 -0600 (CST)
Subject: [PATCH 07/18] smartpqi: fix a typo in func pqi_aio_submit_io
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:23 -0600
Message-ID: <164375210321.440833.2566086558909686629.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Use correct pqi_aio_path_request structure to calculate the offset to
sg_descriptors.

The function pqi_aio_submit_io() uses the pqi_raid_path_request
structure to calculate the offset of the structure member
sg_descriptors.  This is incorrect.  It should be using the
pqi_aio_path_request structure instead.

This typo is benign because the offsets are the same in both
structures.

Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8ff38e3ecd09..075e41b5ceaa 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5641,7 +5641,7 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	io_request->raid_bypass = raid_bypass;
 
 	request = io_request->iu;
-	memset(request, 0, offsetof(struct pqi_raid_path_request, sg_descriptors));
+	memset(request, 0, offsetof(struct pqi_aio_path_request, sg_descriptors));
 
 	request->header.iu_type = PQI_REQUEST_IU_AIO_PATH_IO;
 	put_unaligned_le32(aio_handle, &request->nexus_id);


