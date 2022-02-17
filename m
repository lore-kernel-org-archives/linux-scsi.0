Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA9EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240921AbiBQNal (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240907AbiBQNaa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:30 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8EF2AE709
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104614; x=1676640614;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dQUjKQiDsJ8EX4GKIomyT/ztM2AAXt+07VinlMn4BA0=;
  b=XSA6VEPuRExm3JMAUZ7/uzOkryvqeKey4bBmkUt+7GOf1lB+NjZEPV05
   oVuvVOER8dB/UiK/E+tCvnlTo3dkplUhM7D/cbQUF0kIGL42rRep9dVBL
   lrKEXp/qbs1HwHQcFM0cRO8I9ikeUIqpySbia3LOEVnc0YP867+Jl21wh
   QxyCofJO3RPhmhXZ7Cz7XqcAVxANZySQ3JcO5kIYE7r2zGp5oqhYQUptj
   z0a3a+m0Tf2/HsrmME1NuRkXGns4rgLEfnTv7Npy8qU+MQ5m98yLSLDvW
   QYh+ZWr6Bl4+Yq1yQNnPAjnlasY40mpYzhC2kc9s0S51Ic8JuS5/Y+uqO
   w==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303164"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:14 +0800
IronPort-SDR: 9E3kz8NHKjDEm+BQbrz7O6JEcVXFWh5FUFpH5xCIZjNdI4APbOGRD54kRkxGCx0JmZGRnMmZFe
 YQDZsua/AUVQBa/P6d9eJ0Icx9u5iB6H2Yit0G977m5JvJ1khJ4PokKy/sQC7UPo1xDnIemNZP
 C6XaDpkm9xG9eqoRD3orzytI1t5xUapuPy1dItW8z6r5c5zheRLUqQ8N7Q7ETKWpqtJKavrCmT
 5bxXouZXKLkeNYqHT/1sdKSn3N07d6hZclINk92xdgwZUQwHw75JJOMxAkPjowSXpzfltNDJKp
 YLuUmwV1fch0vn1P3C3efXjw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:53 -0800
IronPort-SDR: a20i7tzDxoyZr5ZDfDzUchxGArAsIb2wKvKeWnljAcvm+aI5bvW6Xi6+8BM+kfOA4fYunH26rd
 5JrwBH8zjokDIrf4VO5L5kZpYd4QpPnZ+PtWOnkkytyJxZVhCgJWB9xYBgmssmpsQMpP6fZgod
 eKV75ynwZoc3G00Dqxm85rHVcNj7IyLJxiZqXBjdoHKe0zoJKd8vmmEq42uf+oX8DIk6qXAN3+
 W0yyfMZzoNCuwAUST3fixUEx+1fYoKNxrQnHOgmfkQqz1bV4W49kGqZIvCYyFj3JVTtHDyEPLD
 PgE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:14 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwg962d6z1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:13 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104613; x=1647696614; bh=dQUjKQiDsJ8EX4GKIo
        myT/ztM2AAXt+07VinlMn4BA0=; b=RjshfH6pz5FSYOWyQ7qkFH0D8HrznoygYs
        1PGAwD9+gq0kgWnVfwGJrkOHRz9nhPrT2Ze39Jk68ld1G9Q8t8eR6OcO/SE1ER6W
        RX+XSzKCK23s8H8Du7cZbreeBnFodMfeIn2oT/rWvOoeaRIO6nuMDB+o6HPO3+/E
        uJxZkLA1S0QMBXYJSixU+gnrlvPebDJnwg5wWgbV4mBLM6i5Xg9vEg6V1hy7ycHb
        nbT2DTCAQvVQbEOUpNK+7nyGehUxO4eFEbSllSH4OsCUDfnbT1/rmkH8GRkd5H3a
        GLqZKS8GoOuGAT8skA0mJjmz+Diq6slUd9/8HUXX1IdaReCGCBCg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id FFUiS6nPLFd3 for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:13 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwg80Df7z1SHwl;
        Thu, 17 Feb 2022 05:30:11 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 10/31] scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()
Date:   Thu, 17 Feb 2022 22:29:35 +0900
Message-Id: <20220217132956.484818-11-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure that the __le32 fields of struct ssp_ini_io_start_req are
manipulated after applying the correct endian conversion. That is, use
cpu_to_le32() for assigning values and le32_to_cpu() for consulting a
field value. In particular, make sure that the calculations for the 4G
boundary check are done using CPU endianness and *not* little endian
values. With these fixes, many sparse warnings are removed.

While at it, add blank lines after variable declarations and in some
other places to make this code more readable.

Fixes: 0ecdf00ba6e5 ("[SCSI] pm80xx: 4G boundary fix.")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 41 +++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index b06d5ded45ca..130747b5a70a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4374,13 +4374,15 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
ba_info *pm8001_ha,
 	struct ssp_ini_io_start_req ssp_cmd;
 	u32 tag =3D ccb->ccb_tag;
 	int ret;
-	u64 phys_addr, start_addr, end_addr;
+	u64 phys_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	struct inbound_queue_table *circularQ;
 	u32 q_index, cpu_id;
 	u32 opc =3D OPC_INB_SSPINIIOSTART;
+
 	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
 	memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);
+
 	/* data address domain added for spcv; set to 0 by host,
 	 * used internally by controller
 	 * 0 for SAS 1.1 and SAS 2.0 compatible TLR
@@ -4391,7 +4393,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 	ssp_cmd.device_id =3D cpu_to_le32(pm8001_dev->device_id);
 	ssp_cmd.tag =3D cpu_to_le32(tag);
 	if (task->ssp_task.enable_first_burst)
-		ssp_cmd.ssp_iu.efb_prio_attr |=3D 0x80;
+		ssp_cmd.ssp_iu.efb_prio_attr =3D 0x80;
 	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_prio << 3);
 	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_attr & 7);
 	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
@@ -4423,21 +4425,24 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
ba_info *pm8001_ha,
 			ssp_cmd.enc_esgl =3D cpu_to_le32(1<<31);
 		} else if (task->num_scatter =3D=3D 1) {
 			u64 dma_addr =3D sg_dma_address(task->scatter);
+
 			ssp_cmd.enc_addr_low =3D
 				cpu_to_le32(lower_32_bits(dma_addr));
 			ssp_cmd.enc_addr_high =3D
 				cpu_to_le32(upper_32_bits(dma_addr));
 			ssp_cmd.enc_len =3D cpu_to_le32(task->total_xfer_len);
 			ssp_cmd.enc_esgl =3D 0;
+
 			/* Check 4G Boundary */
-			start_addr =3D cpu_to_le64(dma_addr);
-			end_addr =3D (start_addr + ssp_cmd.enc_len) - 1;
-			end_addr_low =3D cpu_to_le32(lower_32_bits(end_addr));
-			end_addr_high =3D cpu_to_le32(upper_32_bits(end_addr));
-			if (end_addr_high !=3D ssp_cmd.enc_addr_high) {
+			end_addr =3D dma_addr + le32_to_cpu(ssp_cmd.enc_len) - 1;
+			end_addr_low =3D lower_32_bits(end_addr);
+			end_addr_high =3D upper_32_bits(end_addr);
+
+			if (end_addr_high !=3D le32_to_cpu(ssp_cmd.enc_addr_high)) {
 				pm8001_dbg(pm8001_ha, FAIL,
 					   "The sg list address start_addr=3D0x%016llx data_len=3D0x%x end_=
addr_high=3D0x%08x end_addr_low=3D0x%08x has crossed 4G boundary\n",
-					   start_addr, ssp_cmd.enc_len,
+					   dma_addr,
+					   le32_to_cpu(ssp_cmd.enc_len),
 					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
@@ -4446,7 +4451,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 					cpu_to_le32(lower_32_bits(phys_addr));
 				ssp_cmd.enc_addr_high =3D
 					cpu_to_le32(upper_32_bits(phys_addr));
-				ssp_cmd.enc_esgl =3D cpu_to_le32(1<<31);
+				ssp_cmd.enc_esgl =3D cpu_to_le32(1U<<31);
 			}
 		} else if (task->num_scatter =3D=3D 0) {
 			ssp_cmd.enc_addr_low =3D 0;
@@ -4454,8 +4459,10 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hb=
a_info *pm8001_ha,
 			ssp_cmd.enc_len =3D cpu_to_le32(task->total_xfer_len);
 			ssp_cmd.enc_esgl =3D 0;
 		}
+
 		/* XTS mode. All other fields are 0 */
-		ssp_cmd.key_cmode =3D 0x6 << 4;
+		ssp_cmd.key_cmode =3D cpu_to_le32(0x6 << 4);
+
 		/* set tweak values. Should be the start lba */
 		ssp_cmd.twk_val0 =3D cpu_to_le32((task->ssp_task.cmd->cmnd[2] << 24) |
 						(task->ssp_task.cmd->cmnd[3] << 16) |
@@ -4477,20 +4484,22 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
ba_info *pm8001_ha,
 			ssp_cmd.esgl =3D cpu_to_le32(1<<31);
 		} else if (task->num_scatter =3D=3D 1) {
 			u64 dma_addr =3D sg_dma_address(task->scatter);
+
 			ssp_cmd.addr_low =3D cpu_to_le32(lower_32_bits(dma_addr));
 			ssp_cmd.addr_high =3D
 				cpu_to_le32(upper_32_bits(dma_addr));
 			ssp_cmd.len =3D cpu_to_le32(task->total_xfer_len);
 			ssp_cmd.esgl =3D 0;
+
 			/* Check 4G Boundary */
-			start_addr =3D cpu_to_le64(dma_addr);
-			end_addr =3D (start_addr + ssp_cmd.len) - 1;
-			end_addr_low =3D cpu_to_le32(lower_32_bits(end_addr));
-			end_addr_high =3D cpu_to_le32(upper_32_bits(end_addr));
-			if (end_addr_high !=3D ssp_cmd.addr_high) {
+			end_addr =3D dma_addr + le32_to_cpu(ssp_cmd.len) - 1;
+			end_addr_low =3D lower_32_bits(end_addr);
+			end_addr_high =3D upper_32_bits(end_addr);
+			if (end_addr_high !=3D le32_to_cpu(ssp_cmd.addr_high)) {
 				pm8001_dbg(pm8001_ha, FAIL,
 					   "The sg list address start_addr=3D0x%016llx data_len=3D0x%x end_=
addr_high=3D0x%08x end_addr_low=3D0x%08x has crossed 4G boundary\n",
-					   start_addr, ssp_cmd.len,
+					   dma_addr,
+					   le32_to_cpu(ssp_cmd.len),
 					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
--=20
2.34.1

