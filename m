Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86623C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242177AbiBTDS5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239698AbiBTDSv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:51 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3E9340D3
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327110; x=1676863110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RWs2sw36i5zBmGZYuC/mk8fWJ3x6aeqwKl3ALeic7R0=;
  b=qHleYOVo+RD4nEEsBRU4OWj5D6jYo28KqE4QPFoDhKqhdocx5pj1ok/t
   9Qntj2CQtM7ysFN3UGnsKq+7Oy2yKOuQ0BqzsjSjYQKVIvYp45LYyUTUq
   nD26GbNoTTTsywmRKxI7DIoPHU6K8Tw/rG2IL9dbgM2gqzyfGN0H3qwDZ
   b1ZZaFF5xf/zZkW4uOuYFcY0yW++RVa4IZ9Feak/XOl+CaqjNLK8RFeFc
   4LL3Z+Jd7lSbR17h/b4csLwXb4EIMRnUL9dfnG5I5MRiQVX/iKoZVOUZW
   bzZI/lBW37xfVzQd20agTCiXcN7WJNGJULE+t2c1STRPd+68t0g6koNzV
   g==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405761"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:30 +0800
IronPort-SDR: M1s6XxVY5CpjHfRCy8s0Fo1wvz2IfTpLKQc4xFkfaxsz7yTMe2NCUSBTWKFZeqgrXtVe3l4WXw
 6HwwI125Dt60dXzR+P7POrUM7gdYb+EQQQnaHn6NsS3VUgI8Ldcc/sX2eh8RfH7zaBMHt8D+yb
 WnPALNEzibbxzP1I1ajsZjcyIMT7sSe0MJPqPtLdCLZsqYM62b9mkqX82z8vXLNamzzFLYO5aK
 7KAseRp6e3uqQ5dGjCAsw5/YCziC5JZ4bRbgg7HMWP0MpHy89G/52N4ZP+NFLGNcqgi5jlNyJc
 eYszAb47qHcukWsWFu0d+bbK
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:06 -0800
IronPort-SDR: 2+G579Jn8X1jmedOpb3EKQ8oopy71NqX69eFL+Unu9ey3TEF6OZx8CLFki4Cw/0JE6Ois59mgd
 DeGRD8u/pCkEHTUJp3lhxfCEUMGL62N7KFsnPe1IojstihOqJkqkNUkXz3JMV4+tp0bge1Onwr
 BRhhy9RFEKr9T6xqsfD5+5MtvuCI5fS/LPMMWDNAHVYcQc5BvRsrjVW/Ch76eJ5JgeRfifTGJJ
 TyC0T1aZcCb+hsSemTX1q9DHY6PHTdDusyglelbmSLjStJgGUa8vFhXCMTt0qd+2d4zhA3Dkb+
 LzM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:31 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxy587mz1SVp0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:30 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327109; x=1647919110; bh=RWs2sw36i5zBmGZYuC
        /mk8fWJ3x6aeqwKl3ALeic7R0=; b=f01VcrYY2aExMrvADI1FBmtxqcWPV2imAT
        FgMQVPxK6L1xVTUCRfM7S35R4+3MiLpTp4Gam505JmYRKK6AzLeeGtH77Joh06oa
        eLP/g6jOmybCzNSX6Z2ycXXKiKX6hIaKJYsS2q8K3s4isWj+/9yZdcOb7Vpopd9L
        jnEugutj5jX19RwdDKLICOoDl46z07H6qh4cClxnxlB3GlfHqr/x8aZtECJ7qcjR
        Br+qVY6vckjBWfydvoA4/21fabBG93o8gC9i2VK7LCtadB2pyBQwkkrCMnzjki7K
        3qxF2HeFAckvIpeSv3EQhZQtDz/vW34ili6VQIf9g0JLbK+X9VGw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id uwVfzXpomkDQ for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:29 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxw5Pxqz1Rwrw;
        Sat, 19 Feb 2022 19:18:28 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 11/31] scsi: pm8001: Fix le32 values handling in pm80xx_chip_sata_req()
Date:   Sun, 20 Feb 2022 12:17:50 +0900
Message-Id: <20220220031810.738362-12-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure that the __le32 fields of struct sata_cmd are manipulated
after applying the correct endian conversion. That is, use cpu_to_le32()
for assigning values and le32_to_cpu() for consulting a field value.
In particular, make sure that the calculations for the 4G boundary check
are done using CPU endianness and *not* little endian values. With these
fixes, many sparse warnings are removed.

While at it, fix some code identation and add blank lines after
variable declarations and in some other places to make this code more
readable.

Fixes: 0ecdf00ba6e5 ("[SCSI] pm80xx: 4G boundary fix.")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 82 ++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 130747b5a70a..1f3b01c70f24 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4534,7 +4534,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 	u32 q_index, cpu_id;
 	struct sata_start_req sata_cmd;
 	u32 hdr_tag, ncg_tag =3D 0;
-	u64 phys_addr, start_addr, end_addr;
+	u64 phys_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	u32 ATAP =3D 0x0;
 	u32 dir;
@@ -4595,32 +4595,38 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
 			pm8001_chip_make_sg(task->scatter,
 						ccb->n_elem, ccb->buf_prd);
 			phys_addr =3D ccb->ccb_dma_handle;
-			sata_cmd.enc_addr_low =3D lower_32_bits(phys_addr);
-			sata_cmd.enc_addr_high =3D upper_32_bits(phys_addr);
+			sata_cmd.enc_addr_low =3D
+				cpu_to_le32(lower_32_bits(phys_addr));
+			sata_cmd.enc_addr_high =3D
+				cpu_to_le32(upper_32_bits(phys_addr));
 			sata_cmd.enc_esgl =3D cpu_to_le32(1 << 31);
 		} else if (task->num_scatter =3D=3D 1) {
 			u64 dma_addr =3D sg_dma_address(task->scatter);
-			sata_cmd.enc_addr_low =3D lower_32_bits(dma_addr);
-			sata_cmd.enc_addr_high =3D upper_32_bits(dma_addr);
+
+			sata_cmd.enc_addr_low =3D
+				cpu_to_le32(lower_32_bits(dma_addr));
+			sata_cmd.enc_addr_high =3D
+				cpu_to_le32(upper_32_bits(dma_addr));
 			sata_cmd.enc_len =3D cpu_to_le32(task->total_xfer_len);
 			sata_cmd.enc_esgl =3D 0;
+
 			/* Check 4G Boundary */
-			start_addr =3D cpu_to_le64(dma_addr);
-			end_addr =3D (start_addr + sata_cmd.enc_len) - 1;
-			end_addr_low =3D cpu_to_le32(lower_32_bits(end_addr));
-			end_addr_high =3D cpu_to_le32(upper_32_bits(end_addr));
-			if (end_addr_high !=3D sata_cmd.enc_addr_high) {
+			end_addr =3D dma_addr + le32_to_cpu(sata_cmd.enc_len) - 1;
+			end_addr_low =3D lower_32_bits(end_addr);
+			end_addr_high =3D upper_32_bits(end_addr);
+			if (end_addr_high !=3D le32_to_cpu(sata_cmd.enc_addr_high)) {
 				pm8001_dbg(pm8001_ha, FAIL,
 					   "The sg list address start_addr=3D0x%016llx data_len=3D0x%x end_=
addr_high=3D0x%08x end_addr_low=3D0x%08x has crossed 4G boundary\n",
-					   start_addr, sata_cmd.enc_len,
+					   dma_addr,
+					   le32_to_cpu(sata_cmd.enc_len),
 					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
 				phys_addr =3D ccb->ccb_dma_handle;
 				sata_cmd.enc_addr_low =3D
-					lower_32_bits(phys_addr);
+					cpu_to_le32(lower_32_bits(phys_addr));
 				sata_cmd.enc_addr_high =3D
-					upper_32_bits(phys_addr);
+					cpu_to_le32(upper_32_bits(phys_addr));
 				sata_cmd.enc_esgl =3D
 					cpu_to_le32(1 << 31);
 			}
@@ -4631,7 +4637,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 			sata_cmd.enc_esgl =3D 0;
 		}
 		/* XTS mode. All other fields are 0 */
-		sata_cmd.key_index_mode =3D 0x6 << 4;
+		sata_cmd.key_index_mode =3D cpu_to_le32(0x6 << 4);
+
 		/* set tweak values. Should be the start lba */
 		sata_cmd.twk_val0 =3D
 			cpu_to_le32((sata_cmd.sata_fis.lbal_exp << 24) |
@@ -4657,31 +4664,31 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
 			phys_addr =3D ccb->ccb_dma_handle;
 			sata_cmd.addr_low =3D lower_32_bits(phys_addr);
 			sata_cmd.addr_high =3D upper_32_bits(phys_addr);
-			sata_cmd.esgl =3D cpu_to_le32(1 << 31);
+			sata_cmd.esgl =3D cpu_to_le32(1U << 31);
 		} else if (task->num_scatter =3D=3D 1) {
 			u64 dma_addr =3D sg_dma_address(task->scatter);
+
 			sata_cmd.addr_low =3D lower_32_bits(dma_addr);
 			sata_cmd.addr_high =3D upper_32_bits(dma_addr);
 			sata_cmd.len =3D cpu_to_le32(task->total_xfer_len);
 			sata_cmd.esgl =3D 0;
+
 			/* Check 4G Boundary */
-			start_addr =3D cpu_to_le64(dma_addr);
-			end_addr =3D (start_addr + sata_cmd.len) - 1;
-			end_addr_low =3D cpu_to_le32(lower_32_bits(end_addr));
-			end_addr_high =3D cpu_to_le32(upper_32_bits(end_addr));
+			end_addr =3D dma_addr + le32_to_cpu(sata_cmd.len) - 1;
+			end_addr_low =3D lower_32_bits(end_addr);
+			end_addr_high =3D upper_32_bits(end_addr);
 			if (end_addr_high !=3D sata_cmd.addr_high) {
 				pm8001_dbg(pm8001_ha, FAIL,
 					   "The sg list address start_addr=3D0x%016llx data_len=3D0x%xend_a=
ddr_high=3D0x%08x end_addr_low=3D0x%08x has crossed 4G boundary\n",
-					   start_addr, sata_cmd.len,
+					   dma_addr,
+					   le32_to_cpu(sata_cmd.len),
 					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
 				phys_addr =3D ccb->ccb_dma_handle;
-				sata_cmd.addr_low =3D
-					lower_32_bits(phys_addr);
-				sata_cmd.addr_high =3D
-					upper_32_bits(phys_addr);
-				sata_cmd.esgl =3D cpu_to_le32(1 << 31);
+				sata_cmd.addr_low =3D lower_32_bits(phys_addr);
+				sata_cmd.addr_high =3D upper_32_bits(phys_addr);
+				sata_cmd.esgl =3D cpu_to_le32(1U << 31);
 			}
 		} else if (task->num_scatter =3D=3D 0) {
 			sata_cmd.addr_low =3D 0;
@@ -4689,27 +4696,28 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
 			sata_cmd.len =3D cpu_to_le32(task->total_xfer_len);
 			sata_cmd.esgl =3D 0;
 		}
+
 		/* scsi cdb */
 		sata_cmd.atapi_scsi_cdb[0] =3D
 			cpu_to_le32(((task->ata_task.atapi_packet[0]) |
-			(task->ata_task.atapi_packet[1] << 8) |
-			(task->ata_task.atapi_packet[2] << 16) |
-			(task->ata_task.atapi_packet[3] << 24)));
+				     (task->ata_task.atapi_packet[1] << 8) |
+				     (task->ata_task.atapi_packet[2] << 16) |
+				     (task->ata_task.atapi_packet[3] << 24)));
 		sata_cmd.atapi_scsi_cdb[1] =3D
 			cpu_to_le32(((task->ata_task.atapi_packet[4]) |
-			(task->ata_task.atapi_packet[5] << 8) |
-			(task->ata_task.atapi_packet[6] << 16) |
-			(task->ata_task.atapi_packet[7] << 24)));
+				     (task->ata_task.atapi_packet[5] << 8) |
+				     (task->ata_task.atapi_packet[6] << 16) |
+				     (task->ata_task.atapi_packet[7] << 24)));
 		sata_cmd.atapi_scsi_cdb[2] =3D
 			cpu_to_le32(((task->ata_task.atapi_packet[8]) |
-			(task->ata_task.atapi_packet[9] << 8) |
-			(task->ata_task.atapi_packet[10] << 16) |
-			(task->ata_task.atapi_packet[11] << 24)));
+				     (task->ata_task.atapi_packet[9] << 8) |
+				     (task->ata_task.atapi_packet[10] << 16) |
+				     (task->ata_task.atapi_packet[11] << 24)));
 		sata_cmd.atapi_scsi_cdb[3] =3D
 			cpu_to_le32(((task->ata_task.atapi_packet[12]) |
-			(task->ata_task.atapi_packet[13] << 8) |
-			(task->ata_task.atapi_packet[14] << 16) |
-			(task->ata_task.atapi_packet[15] << 24)));
+				     (task->ata_task.atapi_packet[13] << 8) |
+				     (task->ata_task.atapi_packet[14] << 16) |
+				     (task->ata_task.atapi_packet[15] << 24)));
 	}
=20
 	/* Check for read log for failed drive and return */
--=20
2.34.1

