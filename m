Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8E4C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242505AbiBTDTb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243390AbiBTDTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:06 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D38D340D0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327126; x=1676863126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=icyG2a6vKJMXPyTVSV0pQp/YMvTKdf/9Dx/UzI1uFjM=;
  b=c9Xd71YBmW90CEX5oei6fj6saC3OAZflzLPHxAFOrlwDyZKK6C9JrOMl
   32PKgXOknmPEJ25ViSGuJaZf9OuwXIw7n5/KC7k9C1glX5rnDqXYl0+5z
   KVgqHSKGdJ9YoHKpE27XyIR7FxF2IRui2j7mbQ9pHeATfwCJ0LlG8HMzA
   HlDVwwTTFqyrIo4Gtr5qpAJ9DeLggJKXyNnRMcrN1HYR+dnUgJ/4giKty
   ZZXL9Q74/a5RvGGNcIDHyB0tMy5ioOxp/3ve/zWfRH/lrSvtf7TRFX767
   j6Z82rVbi128lEQJpect5kK6TIKh+NAvIcoxQAnaH/DBo1XEAAfpCa+Kt
   w==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405801"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:46 +0800
IronPort-SDR: KEafW3Qa2c5atQuX92bkMyEi1rYkzu3UGMO82xRvnv3UQWadIkMIZp+kJrBotoJveOSdDxpseT
 UexEsspRhoTD4rXqM7IDy7DwvtdfEDEJCZjloc9kPmHrixhX3Z8BmJFX/I66M8Hyd8FSE2mtzg
 ZApHWJShTUdhoZgAiXTVP/YsudxWsg8z3snRem1k/lXgGp03EsmN0ewUwj0dKK5JNpi5noHbIF
 sVHePZe0DX24rxSotya766ywp7NfEdTv+Zdp+MBNAALEHXT/nODcQmWNhSlzc/Y1XizrD8FcCC
 BHoBskqfPFLNRJ73Azl6WTGS
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:22 -0800
IronPort-SDR: F6XAzpNDK9WrFsIxMzReGzHVHYarqXxZJF59Y4dndjMBxG5xoFjYUwWoVNTYygy1FiFAD3eo4k
 HCwaOkDSIFePJXdmegaahSesE6m97K9nSpKA2L4RZXNawjxccLeCJdDak5VBCha3w2eZKy4sB5
 GbU3EytbIC058jB7aPHNyTecftdEIkZBASq/XJ9et1mCmI1sWWKNSja8+9MnoL6HQzKZIGeG9+
 SyVfTcDpgig4Doyr6JKYPEfhBucLUP+oW7Z4YbXzSEAF8T33tRWlmAxeGY86xf/Rx6Oknlsa9m
 0yU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:46 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1VyG1pwhz1SVp1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:46 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327125; x=1647919126; bh=icyG2a6vKJMXPyTVSV
        0pQp/YMvTKdf/9Dx/UzI1uFjM=; b=uZkbq69afewL4kXVDmDALiLBPaCQ6JbdVL
        AadlpBgAxI7E6QUKm23WXmEz+MHWXYWnVYiSAYNYzgmCDrYEYHVtw7rRS6gOUizl
        pWJd3rJhRN1ZTNOuqakXXLibK+7PWyRRqknWbDlhPKKQplQMXvLimSWBUmTCuQ9a
        smHk38nZGlnukq5RryEEP9pyJ9ay1py1zbIVHe1RaW6dDVd/kbdLG8peGnziIhSd
        TUJHeDfM1Kym1JeVzL4wBQ/zha08GvWcA0bdRFWtNf9v/hqJpFIqQlIo/BPXZbrr
        rnamdLtnsJJ76OQP6kJUOsxDGqohR1oBXsNpt/XKnYk7G0ka8BBw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2FFiSB1_o8Na for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:45 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1VyD5Zqsz1Rvlx;
        Sat, 19 Feb 2022 19:18:44 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 22/31] scsi: pm8001: fix memory leak in pm8001_chip_fw_flash_update_req()
Date:   Sun, 20 Feb 2022 12:18:01 +0900
Message-Id: <20220220031810.738362-23-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_chip_fw_flash_update_build(), if
pm8001_chip_fw_flash_update_build() fails, the struct fw_control_ex
allocated must be freed.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index ba7cefb803c3..14bc4f88c6e6 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4873,8 +4873,10 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_=
info *pm8001_ha,
 	ccb->ccb_tag =3D tag;
 	rc =3D pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
 		tag);
-	if (rc)
+	if (rc) {
+		kfree(fw_control_context);
 		pm8001_tag_free(pm8001_ha, tag);
+	}
=20
 	return rc;
 }
--=20
2.34.1

