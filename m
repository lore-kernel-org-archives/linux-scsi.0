Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27104C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347704AbiBKHhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347699AbiBKHhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:09 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9446510D6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565027; x=1676101027;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=V82tCpFaYvpcK1xKWfEXtOUXB3QC/wmQbMrXpEthOUo=;
  b=BtXlT71pSXjjY6gRNGGcG+fnVDKQDVDEIDUw/uLP0ymkrJ8yqK6xovZ6
   8fyysmzWUrRM1d9oU7Mkqvm4xGbXgMLDbf6gkFYFwi07QnGvgJqOX8RCc
   0XZXwo4tGdQVXxb+rGVFWt+QjTEc99SdDimM64Sba64ny2qBpRoAjij+U
   yApczkfEov3+/UycnBv31fTXs+ZS01Qdlivm+R1U2glJha09kOtvX2P1I
   5i08Vgv0Oi5WkgNE1hAXqHKGCx8yrQkBRw+S5aXESp4tfqmmHmQqO4+gE
   GbJi0uxgqs15B02SXHaRMKpaufmg8JPKSPlqHCi7x1ZLk7Zow+Pcp08At
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675111"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:06 +0800
IronPort-SDR: 6G/jW7sFYD+hJiozLBc3cqSB9HscPzVpM9dj3kbT99i6YHXglM+RdTA0siNpmRNJSC/cFSotzl
 B3YT7IvfiRzsrP6OpTJ2/d/RaxEH1zyJfyC0iV5HEeceJHVHgDHcq149C8cnenjzJbK76WdHkK
 SEcCcXBiIHX3LHFvHdtg+OMVZ/5zLfm0Gr+HrScaoV9oHHyKUYImnjsozQHEZKOxAOTU5C/Mla
 GAbNw4yDms3JXbnWJDx5utLxOyPYcI/t7/hkLJ3Xm0iEOwW5tpSTUlB+15WLjsaH7KADcbrK1t
 rfiUMo8zXHRfi5GcPxNI9ZFV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:08:55 -0800
IronPort-SDR: TDveD8tKKOIxbpud9ntwLZZooAojR2N0pWaJlXSRZ0CI+Qr2nrHVi3DYcqFnF91BSEcGG40zwP
 Q0FOtDPjwiX54SoDObKAR5ShGzs6L4Mp8CbB6xW3LvP+92vk7srGEXcVz7viZGyeTIkbPlKEBr
 TLcuHNyHQuxCZjDiMJ4b4CwVZmKuU4inGYunapjxFnV2aDzt9TCnBJ5IZelR1Cr5grg4MLqvn/
 ewsukR8l3c4eU5fnIT9HODpmzeW/KBDWA2hAsK3qmukaV459ie9TleTWOyj6nW6xmHC8IFxZdu
 J/w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:09 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56X3PkPz1SVny
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:08 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565028; x=1647157029; bh=V82tCpFaYvpcK1xKWf
        EXtOUXB3QC/wmQbMrXpEthOUo=; b=I5HA9iQd1+3J25KeWE0eoK0Cpl90vjTHih
        6ZOziJ10+5y26Nk4wrwbWDxLyEf87PqJuDHp7OfF1vU7RGCDsV51JJWrlDUXcrzY
        ds61XfV/j1E1bvS+asyh3W1m9hTQ2CVbh9wEa+FLvbuToB+GqM5PJ5Pdjj+20fwK
        Qv0qtcSrPjCO/mcsBqSUF+lVnEMfp2wp9xgVMZvs6t3zzd2FXI/HLgU8tuA5SQ2b
        fObCFHR5zoHpgYd+/ZXKHvRwsjWiq3tO1ML/o+BE0GmDYay0afgOTDs0d1OtmL2h
        Ut5DVe9QfYb+XDDhDvLhNpNR/iSP751YQn1cCGSjMyMj9W0aQGwg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gD7IYj5zDaqr for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:08 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56W0km9z1SHwl;
        Thu, 10 Feb 2022 23:37:06 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 01/24] scsi: libsas: fix sas_ata_qc_issue() handling of NCQ NON DATA commands
Date:   Fri, 11 Feb 2022 16:36:41 +0900
Message-Id: <20220211073704.963993-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To detect for the DMA_NONE (no data transfer) DMA direction,
sas_ata_qc_issue() tests if the command protocol is ATA_PROT_NODATA.
This test does not include the ATA_CMD_NCQ_NON_DATA command as this
command protocol is defined as ATA_PROT_NCQ_NODATA (equal to
ATA_PROT_FLAG_NCQ) and not as ATA_PROT_NODATA.

To include both NCQ and non-NCQ commands when testing for the DMA_NONE
DMA direction, use "!ata_is_data()".

Fixes: 176ddd89171d ("scsi: libsas: Reset num_scatter if libata marks qc =
as NODATA")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
index a315715b3622..7e0cde710fc3 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -197,7 +197,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queue=
d_cmd *qc)
 		task->total_xfer_len =3D qc->nbytes;
 		task->num_scatter =3D qc->n_elem;
 		task->data_dir =3D qc->dma_dir;
-	} else if (qc->tf.protocol =3D=3D ATA_PROT_NODATA) {
+	} else if (!ata_is_data(qc->tf.protocol)) {
 		task->data_dir =3D DMA_NONE;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)
--=20
2.34.1

