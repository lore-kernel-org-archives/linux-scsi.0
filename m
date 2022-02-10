Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DD3C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241169AbiBJLms (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241153AbiBJLml (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:41 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D2B1035
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493362; x=1676029362;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Wr5ZYY0zPt1PAFBy8hWO0m0Gx4QV/QzSPJL5V8CADbk=;
  b=gdiBPbE2lLCNxpY9HJ1O1h0S4UZdZYxvCjQentMZTvrTSqV9+l5RVq0M
   ZcTwpBcUQXaH+nptBGXCvW17Qg7QVW0lxT04puHGY1K9zAx0CiC2ob4Di
   5iAv5149aY4ETdEvGKZbp6BbjTMrYewzHzts3HAb0yfkqEYHK3BxIRaT4
   d+8XVIzk816fYw0arlMt6E2icAhj+jDZCld1Jjznsfrs6o/bA9tN1ZUYX
   ocdGAlp5LRKpw0DQbytKg98443xr5Rwqsa7ZrB9F+jI7tfvkeTqOEXpdK
   zmyt9GzJUC1TMjAbCpJM5PE9p6yQ7afVsptE1j3sHIECbj1UESxmQ5LQR
   A==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575656"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:42 +0800
IronPort-SDR: CVlZbu8XRfNTc6pBJHxRmSgi61msDCXch0r6Sy1mb2dbgGie9iuy8jiiSJcGGvkd8hAigqcsFg
 9SNnXNPwvKCq3/47EgM6hi51gHDFtkyr0jWY4sKK+35r6g2PNvPBfKkyPWlQ/fI8FWsGMU4DHr
 sAVGSk1w/URnwIMGXzHPoEZfe3rqWPJveXtxYFKOcjQW23zoqURWW4J2Uwd9beFExc5xqXJEzz
 e12W3Tb9KSwVW+Wt53JHKGq7PGnfMne3F/On+A0L1RDVJ4KARtQyBdE/1IgpLuAPdq6BlUxFuq
 +4ZNOFpYYV79KTrpx1RqTPA5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:38 -0800
IronPort-SDR: YYZCP6nPGkKXx9ALhSvQ1Z4R1m/H93pieXdlYoW1OXTKo2x/kBzygP6knBxhpkEmyCW7MctQSy
 VNdJjGa+FF4LC7DeTU+sivRNNBiqLWxbd0IDMjR4pFTrTgqMa+OQem3YAoDv/bz7SqO4jThqg1
 pr/BV9stUGkCP5D/m4e3NFjNOP4N2eJST0pLqr8l2VXI/cGfJoy6UmxsfLBj/nM/TiPXbIQf4B
 IQO8n4FeWiPnn4vE0KXAneWiuSajITxgfzRhtP75sIyiIqhDVbxfIRShodmS+p08t+Xh2d/qtb
 D44=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:42 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcK2zgFz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:41 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493360; x=1647085361; bh=Wr5ZYY0zPt1PAFBy8h
        WO0m0Gx4QV/QzSPJL5V8CADbk=; b=rASL6aT/6B/xDvQPwKQrvsUWQ90rffXTDZ
        8pBjyaeLTo0Rz71RhnsUWnoqL9Jr/KlIiM/dCXxmqMJSyQtMi3twqxExKdbsjFS6
        +/OYPuRiiGOIMWRAz+g0lde5bfEJxH07VbXY6EBdYwFAZreHEKc7+50MzDAuDpWB
        PsiGwHhyy4McQlfxP192lK8d9euvZmkbHQzT0yv9xudRWs/YikwPwRJISypZSNML
        nG6Oy3U9u4lgxe8sutPfwgXL19RNzvH+k6vKELtWFxDQ32Lae1KYNm2F3f8uorqw
        bH3gU4A7zjU9/rmEEYSvmKXdWgjn6TeK129+U6WF8Yz8nrC/e+bg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xpHDNOOSjm8s for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:40 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcH42y2z1Rwrw;
        Thu, 10 Feb 2022 03:42:39 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 14/20] scsi: pm8001: fix le32 values handling in pm80xx_chip_sata_req()
Date:   Thu, 10 Feb 2022 20:42:12 +0900
Message-Id: <20220210114218.632725-15-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
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
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 82 ++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 2626a5bb0e4c..fbdc56351901 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4539,7 +4539,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 	u32 q_index, cpu_id;
 	struct sata_start_req sata_cmd;
 	u32 hdr_tag, ncg_tag =3D 0;
-	u64 phys_addr, start_addr, end_addr;
+	u64 phys_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	u32 ATAP =3D 0x0;
 	u32 dir;
@@ -4600,32 +4600,38 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
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
@@ -4636,7 +4642,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_i=
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
@@ -4662,31 +4669,31 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
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
@@ -4694,27 +4701,28 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
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

