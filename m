Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC25EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347707AbiBKHhg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347720AbiBKHh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:26 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F8210F4
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565043; x=1676101043;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=//HcszDAJKd/CLH75b53FTwMYsQK+nBTlok5LRe6EaQ=;
  b=Uo7/7lZXHLyN06X6xCDw8nFZeym3ro3I4K8dAbnxUHeNnbuBqNNsbZbD
   UYWdNUBokZr1Sp8lFKRbLOgwgLAdV0alvWBUBKprIp1msbHG7T2Vdk9Bw
   ZOsFK4JUjBXOSX0tHZiqONlHm3Yb+yfWwvoryM80dRrQEIuvxbfaVfovU
   QubAHcD329Xguq9jn56YvzEK/UPT4HGHhIG2B5ucvRcfdTurRB50KxJg+
   nLyX7055Hi5oqiQzO0RMB9/snzO8NsRShmTNcYBrKtEJO8td8fZkkxkH0
   fe3CUL0M4qLufud4XYdFr5XIFNxz7j3untOGdtPtEcpj9YQBHUSwm6QRx
   w==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675149"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:23 +0800
IronPort-SDR: g+l/Q2DRDpRXQ0hwZEkQpS9xChVZts5VRWGt9Rjxkj7aBPtjBgWZH9XFwqo9MguZjTFjVmkSzb
 pInz5ue6bCwews17XJC2iDHuFaIqe9jKFdUhhKKkT+heBb3LphmsNcybWRhbdMF0ZoJdA53tr+
 YNbVGvr4gIDMIKPVLVaEXq4i5y1ZwIW2NQAvU13tYerh4P6Nc0TMQUM8PgCMZcjwrV9HKk1ZMk
 M/3eGM08FkAX0eYILz+tt4c1BPtjMG9hwgqQURjPcv5/81WeJkpOJT7YyF/pu//37EMPTXwGSe
 dlHE+Jz8C1ATuVS2NE52Qw4t
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:11 -0800
IronPort-SDR: iUsa7nYxms7eYuEy7n4PMePbVW5Ok0jMnd7t9E4zrqor/Nq0h4rJEhHX+hOFEfQNPtXecbYXIN
 nXNbyC5rIj96UYmryMni9BX3QGBf2gMG5WwxCSNAjofwQxSbgJOqcdC9SvRs+ubkSrpeGl2Afy
 vjMu+hj1gM18N8EXDgDZklnglvbqcfnRx6dVfcOIyPJTmbef2RTF2MJw6awaNEhA15Cv6xxv+M
 v5LQ8TmYhIxO68N3K9idF0ohB1lZ/mpqpd21PURW8OA5wXDus9QjWCD6s7qsTuh4LwP7PmjXkG
 JZ4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:25 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56r5zfxz1SVny
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:24 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565044; x=1647157045; bh=//HcszDAJKd/CLH75b
        53FTwMYsQK+nBTlok5LRe6EaQ=; b=Q8RGH03YSGbXcPipeKP8YdqrKe+T9YhOoD
        Whtr4UjT877FI5hMKQlfVLrZMOcs15Sy1PnrI0EW5gayfXDPGemZuHRFAc3ponm/
        4+HKBtnSB+W6hYVcjEDS/fx4bdpRqYYsD98RtwdSY/Xtk5ORKnAAh8t7OKrywZc/
        pl3Jv8a0llr/rzorYbHqsTE5cepUUK+ETcgYnjLIctC36R1RODUPKNef+Wpeg1Ov
        CaVjlIe8JbHzagi1IBdfXU0tM7ofpcUdpB6gibKAlKRbt/b4shelA5xWJG+ihEDL
        R30WwotwKJoy4bl+pv9QuHmuRHaFEDeWlaUoc6FIOwidkBiTbGxw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VF3D5uAR8Mlw for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:24 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56q0z9hz1SHwl;
        Thu, 10 Feb 2022 23:37:22 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 14/24] scsi: pm8001: fix le32 values handling in pm80xx_chip_sata_req()
Date:   Fri, 11 Feb 2022 16:36:54 +0900
Message-Id: <20220211073704.963993-15-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
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
index 2e1a9261212d..faff475333a9 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4538,7 +4538,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 	u32 q_index, cpu_id;
 	struct sata_start_req sata_cmd;
 	u32 hdr_tag, ncg_tag =3D 0;
-	u64 phys_addr, start_addr, end_addr;
+	u64 phys_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	u32 ATAP =3D 0x0;
 	u32 dir;
@@ -4599,32 +4599,38 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
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
@@ -4635,7 +4641,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_i=
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
@@ -4661,31 +4668,31 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
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
@@ -4693,27 +4700,28 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
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

