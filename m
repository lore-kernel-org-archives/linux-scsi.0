Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D14EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbiBNCT4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239283AbiBNCTv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:51 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ED855480
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805182; x=1676341182;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=0btjr1vrPsbMAw6lPRCbCwzcLKrnll0azm1uZIVf4Fg=;
  b=lnG2R6JIpTM2dS+EpcjjexPOS2iM1SYgnQfIUzaAYp5N+y/pGfcZlbPG
   o70obSKHZIAS5yFn/y337I95YgkXOxARSF/Vmdb3/gt9XneSGz+aU+YmC
   TAYxJm6AMC5dlfkYPgVXptVck/itbEm/VPS0HjGlVjOxL7MO5kJljPQrX
   4iecQJAE86blWzZsJMKKEpFOxcZQdCtcK9nUuRFc3BAFk58ZcQsV1bn2a
   prBt5PtTN2mJKbocQ6KOKCQi0f12Btpis913ha3KVrZw6RH283CyfZ91G
   zwzDVtHAW89ctEQksfQTJf/UiH/fJGGj3Fz8WNA72hjfUMLQcFqdXMiOZ
   w==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819774"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:42 +0800
IronPort-SDR: tlQlv6t/ZhB46DTlWoFa6PkZB92T+0YKHALzPSTZjMG/pfxV224SvcSZXtqepXESGvQYk/f2uZ
 Ppha3ohownaVTZkfpwlOms2qDJaz1nc5OnKRcrPbSVtOfI6Hg3yVz0ixEEWnhroj9fqhkR3XVF
 aup4d4EejVdBDLfAlnBSiXFkITJAdZVQLBiywES7YUSr4uxFrL5vrSu/MdNnV2rTkcByOdpklm
 oNF0Q8AY7RnGhdyt4COmwslbsf7M/nij2W/I0nHoIKeuEFTjd0xhbseh4dkN8BSxb2DgTQ5tv4
 93VOr1ZahHcNPtfl4EXB+2ec
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:35 -0800
IronPort-SDR: ZoqHF3jfGTDmfXO3lkpHzj5ETjAHRJPfHtUawdznyOkD97v4HharXl1Jah7Ycxp0HGm2+hfpCV
 3LrwGhi+yxoBMj1xWrQ3uzQDBJpgQvpjNdtcKLf5Nb2jqDsoPWksZ3D4fLFEn0oaZxuF5nn5C7
 EXqTswalcpT1FrrjHwlhg3/nLBrPfjCf++pRT+WPzMnh7YyXHsPIsIshsaDRzZRyhu7V5jo5QC
 8xfo+s5e8ms1qLk7CX1k5WmfSm6lZCcu4kIiBB/eoVN8UsZAMWTiGo27tWnoTTpgCER5MrcEDa
 8Qo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwv3Hb1z1SVp5
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:43 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805182; x=1647397183; bh=0btjr1vrPsbMAw6lPR
        CbCwzcLKrnll0azm1uZIVf4Fg=; b=s2x8ou/WJfu1wk0wU7bc4SUahmWPxYl3yN
        0G+OCfesIXZd+uQ+dY5lq0pp1fBnz1HJOZB2XvyE+/QV+Wd2DohUYXiERCFwTjEb
        gpXNefkkly/Q9LP+QTWWyjw6FjIXH2833RwAwt2T1t1bN30MtKvquuuM8jOZxcMU
        6kt9EhlubrCWUqxZRipOsIF9BNQEGzhvpdh+aeAYM14hYvb54ggVhM7hwQ2A1kax
        uEG6sAxK19XarkQSMpJwzSa6KhU09FxYzh1c+BqCOJqFeTtzbWp3OhZYcUts0NxV
        mGuOUoR0BgTyW32KZPYHIwtRNVNjsZUF2ZvCzbcoIYUDwVS1Xf1w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cxhLL7H6ztGj for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:42 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnws5Q5yz1Rwrw;
        Sun, 13 Feb 2022 18:19:41 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 10/31] scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()
Date:   Mon, 14 Feb 2022 11:17:26 +0900
Message-Id: <20220214021747.4976-11-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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
index 8e4c515f54f4..0ed4bc114e5e 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4386,13 +4386,15 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
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
@@ -4403,7 +4405,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 	ssp_cmd.device_id =3D cpu_to_le32(pm8001_dev->device_id);
 	ssp_cmd.tag =3D cpu_to_le32(tag);
 	if (task->ssp_task.enable_first_burst)
-		ssp_cmd.ssp_iu.efb_prio_attr |=3D 0x80;
+		ssp_cmd.ssp_iu.efb_prio_attr =3D 0x80;
 	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_prio << 3);
 	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_attr & 7);
 	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
@@ -4435,21 +4437,24 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
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
@@ -4458,7 +4463,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 					cpu_to_le32(lower_32_bits(phys_addr));
 				ssp_cmd.enc_addr_high =3D
 					cpu_to_le32(upper_32_bits(phys_addr));
-				ssp_cmd.enc_esgl =3D cpu_to_le32(1<<31);
+				ssp_cmd.enc_esgl =3D cpu_to_le32(1U<<31);
 			}
 		} else if (task->num_scatter =3D=3D 0) {
 			ssp_cmd.enc_addr_low =3D 0;
@@ -4466,8 +4471,10 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hb=
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
@@ -4489,20 +4496,22 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
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

