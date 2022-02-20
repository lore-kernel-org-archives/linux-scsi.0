Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DACDC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241843AbiBTDS5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236462AbiBTDSu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:50 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11D8340D2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327108; x=1676863108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NznwQIrXtOr3EbXJhwYPD9nDQOPGAk8nVW66eSLouuE=;
  b=i1mi9K22l4sI0o66GuAVGbj0MXhWRVmYsqBzBd7Q/6eNZ4/VgHcC/GN4
   25lUyAHW0Y7hnEHWjXfeP6hu9ODkaIaXoa7VeyGOOVboi60Bp3yWztwPZ
   XPeEutPyfeTHFTH2iptwrr8MLZ98FAcJxPcOnvI6/Wsx/jwWeiKF1iMl5
   ki8+ic+IpKo/Hsk6xQfunMUYHF77KcETZZMpnCiH3JA8pv6YwCNvQ67Ww
   HR5IlC7lLdqgv0qg0iA9/EUS+nHdhNZfA4GNwk6vK9jmKImbN3KHwmdgd
   POVIf2RtxalKdd7IFly37SWXB0EAsenmY699k5lLUkR4tFD1PKxYTZXh0
   g==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405758"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:28 +0800
IronPort-SDR: MAfd1q60B/l9re27SVnFwihAqLV0dZoutI/3p+fSWfBMc1dM/zD/wMVz+QABZw8iLIhngogA7p
 mMY/0XvcgJjG2XaxcYyp+oxep5520TYPlqIC5Daxl++gq7wvuGSDw6ofJtjgXFh+CUhLq5ymUL
 HH0UlCc0UYWbd02+Y1U53SXgD/5LI5nqyylae/4SIYS8BM2JbZbEfnFSYDUuESljyJ1jpkFByV
 gXpDWPGDSDE/5DI4NV8yRFKEYlZosEq95a1+Y/cY5XZjgZmZNBcmEpGLOuYNZqjqeMLpFjaufs
 YuBO69RqxEGy9jkweSNf0MKY
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:04 -0800
IronPort-SDR: fTzvbQG00I/Tir3Ujf5j/UO5KS6Yjkfi1nCU8b5yc/PJEIo3NfkQKEso4ibuJrWyrz7zIpCDqx
 Q6z6JyqZAh5iDUW1sBAN26ojvDNOQA1tM0UQWc8/UNdBpaclFIaLcIIKF/74zJXMBR4cunvBEV
 hyGlLGenNDM+en2isfe9EdmwWLg3kTic9IIVQ48QiUeQiW/gWNiTiPDtxdp6h4YI9TK8nE/sVP
 GfWx4vE+6PN/l6OB6Znc8vHUOLD4qnGaUwMH+bTAnG2z14C7hgF9sLRD5g294gDMGgagnSEQTq
 Y2o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:29 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxx10jCz1SHwl
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327108; x=1647919109; bh=NznwQIrXtOr3EbXJhw
        YPD9nDQOPGAk8nVW66eSLouuE=; b=Ft7fh0g0GZAgo4EZzgFD65Skd67daPJ3a7
        d3JJOyY8YTS+fOtyI78hcGWuI1hxMDDVDRENF8fawicC9M+xhjk7jW8ptQjE/G4G
        yW45ZzJt0Zh0QVzO9gCJdJHWRVSPILOFVV0XqQGyTCT4tyY6eKBMqIa3rqQ0hjc2
        //RH0vAl7wmZjpwD09u51gqlK0JkbEGUlUmoTPyjsQxERWX0HxtI4Aambqd1gi5O
        Mzd67oeHAOK1mwpHpU/nRlLvoDrV0jCljLG7OaKt8O8moLAlVjoKE3PxuPZdrmon
        crYyxH0cdxpiuCq2eU/Blv74ivWDCQojsx0yn7528iSW9sP2WjQA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yGeMMRXcn3_N for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:28 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxv2rpdz1Rvlx;
        Sat, 19 Feb 2022 19:18:27 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 10/31] scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()
Date:   Sun, 20 Feb 2022 12:17:49 +0900
Message-Id: <20220220031810.738362-11-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
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

