Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A48C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 05:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354934AbiDDFCm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 01:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241713AbiDDFCl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 01:02:41 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDD42408B
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 22:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649048444; x=1680584444;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SX24wARsKkOPZqHwIO5oo/zBB2j0nWvYAJ1CNwA6+bo=;
  b=fQ6d+O8A6wXL2Xtn9uHZN3hfAMki6DdbP4eAgGRekXiA+6dABebbbm1N
   RIzkA/JB2/enF4+IEZvSrbafkMrDqPZmxETes1NUTtw66HoB5vNdnwZ+E
   Qp3ZNpKvetoDcWWgnmRrkTKh7OzGcWmFBDqQtOeXdnD9DbRknVsnuT5Ch
   B5wiuB9H3J2oRo5TiddgIRyCP7kRx/YWTXLM622ljJn7bVEt7RfO8CbbL
   BHfzkM7xza0MXND1u/KpihDc2tHjSHXCeGGoaE74kY8ic5gBO10jtHSza
   cZ2UvnmHmwSEA6wHfYPs1gydDiVscJxQzUmv+Pa/57zMnYFPZ1ZFlpeOZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,233,1643644800"; 
   d="scan'208";a="197007528"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Apr 2022 13:00:43 +0800
IronPort-SDR: q5lyoOXDJsoIud8zMH2Pj9SKaXTz4xFcc9aWtNHTCk1tk+wj8dfBDyGc81JXuef6Lsp5sIFwtA
 mJ4LA9oN5YpmTrRg383uapUniCSsnRzsgilztRU1HFE9XO0g6wETx9UZsQM9c1Ui8thXLW7jG3
 30qd1yZIIIjvbsD7uZidSd5QZduXqy6yzHTpT36tGrJe7d2ed6m/EXu/LCbGu/58pCTu+fjq9q
 lNySf8t1SgIOGCrKkJ7Rc0PeTb9rFZjXuWqN7tBy5uRFmPRYPfBiMVpJrBQl+zvU1DkJ5t/FfK
 oKBVqoACCEW8cbj0XEfsIuWt
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Apr 2022 21:31:28 -0700
IronPort-SDR: Qez465yxz15o7kkg0OBNVyfg1CZviSqpan9T9JOHFwA2scXJWSBZhhEP//2ILvwwZtJGOEtiRh
 u3IykEEbn/eihz09kW+wIW8mYAWjXS1wOOCbsed1Ijf1ouicWH1M1w3l5Gsu81Fre/5ChIs1I/
 aMnQR+LXhCpQiK1J91vHqp8sKJpkj3cMTUuCdyY/IFR2z+ViLiFUbg1BcZcm1rfYbqg2a7RcsO
 h+dLq4hsvkwjLcWL9ZdNlCAWaNBZC5EPZqSyoJcsUNU308MTx2wTHsF5CfDQfejpWUQpEt5SMJ
 YSQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Apr 2022 22:00:44 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KWzB42sy1z1Rwrw
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 22:00:44 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1649048444;
         x=1651640445; bh=SX24wARsKkOPZqHwIO5oo/zBB2j0nWvYAJ1CNwA6+bo=; b=
        KxcVMCQfc1IuKHQuFvcPFQfaGH/zyZ/XeO1e6Vj4Ad3Xv648H/nMdxOPD9fyHyNP
        O8u96B/m7GhpdaK5mAZlQSQ9oHnqPiEMscus82AQEiuS1juJ0SwEwYYLqtYUWUf3
        wb7mVpdJQtRyohFDizakqnOojaBgmx6Nltc2pG5PktuhnMqDuP+DWJjuJSpH8jFL
        0IcraC0decY+VTIQjrD7nKZnbp07ORQ4T9Yi5PWlKRww9kY8dY3EIjzdBsxG55u1
        /45gcS0FsT14km+0zXHg61F2qyLOtzajuasrvsT68f5OwRclXaWvfikrmwSbllhN
        NHqg17luoKqwzm0wk00cpA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ssBi6nTnJIQT for <linux-scsi@vger.kernel.org>;
        Sun,  3 Apr 2022 22:00:44 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KWzB30M0tz1Rvlx;
        Sun,  3 Apr 2022 22:00:42 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH] scsi: mpt3sas: Fix mpt3sas_check_same_4gb_region() kdoc comment
Date:   Mon,  4 Apr 2022 14:00:41 +0900
Message-Id: <20220404050041.594774-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The start_addres argument of mpt3sas_check_same_4gb_region() was
misnamed in the function kdoc comment, resulting in the following
warning when compiling with W=3D1.

drivers/scsi/mpt3sas/mpt3sas_base.c:5728: warning: Function parameter or
member 'start_address' not described in 'mpt3sas_check_same_4gb_region'
drivers/scsi/mpt3sas/mpt3sas_base.c:5728: warning: Excess function
parameter 'reply_pool_start_address' description in
'mpt3sas_check_same_4gb_region'

Fix the argument name in the function kdoc comment to avoid it. While at
it, remove a useless blank line between the kdoc and function code.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index b57f1803371e..538d2c0cd971 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5716,13 +5716,12 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER=
 *ioc)
 /**
  * mpt3sas_check_same_4gb_region - checks whether all reply queues in a =
set are
  *	having same upper 32bits in their base memory address.
- * @reply_pool_start_address: Base address of a reply queue set
+ * @start_address: Base address of a reply queue set
  * @pool_sz: Size of single Reply Descriptor Post Queues pool size
  *
  * Return: 1 if reply queues in a set have a same upper 32bits in their =
base
  * memory address, else 0.
  */
-
 static int
 mpt3sas_check_same_4gb_region(dma_addr_t start_address, u32 pool_sz)
 {
--=20
2.35.1

