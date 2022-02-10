Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3162C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241156AbiBJLmp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241149AbiBJLml (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:41 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAA4102D
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493361; x=1676029361;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ugKyb7hkIOssRuWPir3Jh4P16cy0F+mxWtGhQtN+3Uk=;
  b=UkHrjBPVAPDHpWiD6p0KhVyM0XASaaxCdgAUBVklAXtSjn9hRN1JW8yX
   RkqEfTHm2owF4eMeJu49kl7e8b3bMnx6yPkSXu3nS74yBi10bWCTl+WeP
   jpLR7ewoZsS2uBQs/Y6OgE+IzKLmLQjQmu3mg4Uvj/YBBAYBbhqupFiuq
   y8YZQoPeHTucuVbbrvpra1tlNPSd29s1EvC12TZZdW1DIsA3+pghjwwJu
   s1ed+cUs0g8ffr02TjvTKwgyNgw3lGFnxw8uvzeTZxfsQbhx0vhieeNYo
   OzwB48cB8FQuLf55mCz484nQwHrBEEHn3LBDfmHPXT7wRZ9OyaQzu2i39
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575654"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:41 +0800
IronPort-SDR: KBUAnZfYzDleOxQ6MA3C7F1YtSy5RDK8YLU2rG+fnegAHQivr8VnlU6IeDNcnyZa8Xw7VUt+tl
 4Wgw3K0tPusaylFXyGMMue15OmKmoH924q874a52TIQ2BrzB4SLjNnXBcy22kVKxwG3NnT2LuH
 CnK/rY4TOQvDm+d6Mjqm0M6C6gYdV7srWsK3JV5psFdu3L0yVCLfXf5LP5aOgiLHIqb5ymUTxb
 25Ac6/hMMwLzUo6QeL+mOvFXCEm1BHww+bCkthsBF3ow+Fp2fJwt2vAbUnURQ64DFwZgTzjum0
 ++9AJWIS3ixl6+fqDNcs4mNe
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:37 -0800
IronPort-SDR: 48c+UBb0mzCo4Mpz3MdOvvmZYU7cb2QAf3p3rqTtUnWwk1+Z8mMFRegnzRzXsiq/e5ra8ZYKgr
 B7dGUxR/pTov5yD0EJBsxlJA2baWEDf39yqM9yUgp2/nwTvOC+ZFQqDhphH/b8ENf6gXujzwFt
 3ToTzPNuY2lYYmo6DvA9fZl0SYAJouA9FwLfOWDYvjWxHYGv7jnDTaCk7QoWeJfy8CLRsca7Os
 PktvBdq7e17ijmatmDZCJZ8Wg6sO0ibGIcuvT4OtE3wPmwIkP35WmkZTD0uK0FoDo+G53Rf9TS
 g3Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:41 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcH6sG4z1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:39 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493359; x=1647085360; bh=ugKyb7hkIOssRuWPir
        3Jh4P16cy0F+mxWtGhQtN+3Uk=; b=GU9+1PRSsFW+cAORDOIc+d+q4hTpctB5qd
        vN4Dv2zXBylUTGRHR3c7Qp4PH0IKqJbIUxA1ACrBlVt2v6mR2Q4a7yCupKXpF081
        292QSdve0/SqCw401+5TVIBF1gSY8DIwTKfmHMlwcQCqTSnqf1uKjlMyGhXfVibY
        x/ndruj4joVa6h4QQa4krSM7hsdBQFX6uWzUqdts42BC8O/sBTye8WWcuhRvw5h+
        EQ7eLc3UCf92CDVNbw3zXyONmxJHhA8YajhAmYjabxrAaYa7KpeBkC/8cV9sgvv2
        5YTs3nqFLbMTSmoaA1p5BVQdpFGZgWX3j/ehfeVB4EvdREI0Wffg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tmXrC6Sp2sqQ for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:39 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcG2Ljxz1SVny;
        Thu, 10 Feb 2022 03:42:38 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 13/20] scsi: pm8001: fix le32 values handling in pm80xx_chip_ssp_io_req()
Date:   Thu, 10 Feb 2022 20:42:11 +0900
Message-Id: <20220210114218.632725-14-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
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
index d37599a94003..2626a5bb0e4c 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4379,13 +4379,15 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
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
@@ -4396,7 +4398,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 	ssp_cmd.device_id =3D cpu_to_le32(pm8001_dev->device_id);
 	ssp_cmd.tag =3D cpu_to_le32(tag);
 	if (task->ssp_task.enable_first_burst)
-		ssp_cmd.ssp_iu.efb_prio_attr |=3D 0x80;
+		ssp_cmd.ssp_iu.efb_prio_attr =3D 0x80;
 	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_prio << 3);
 	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_attr & 7);
 	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
@@ -4428,21 +4430,24 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
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
@@ -4451,7 +4456,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 					cpu_to_le32(lower_32_bits(phys_addr));
 				ssp_cmd.enc_addr_high =3D
 					cpu_to_le32(upper_32_bits(phys_addr));
-				ssp_cmd.enc_esgl =3D cpu_to_le32(1<<31);
+				ssp_cmd.enc_esgl =3D cpu_to_le32(1U<<31);
 			}
 		} else if (task->num_scatter =3D=3D 0) {
 			ssp_cmd.enc_addr_low =3D 0;
@@ -4459,8 +4464,10 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hb=
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
@@ -4482,20 +4489,22 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
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

