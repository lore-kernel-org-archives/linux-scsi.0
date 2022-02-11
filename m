Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A1C3C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347745AbiBKHhf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238659AbiBKHhY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:24 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74B410B1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565042; x=1676101042;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=0By2svS/qa6+92M3y1emldA/HHxQI5Ee/J/kHWALG8U=;
  b=DB2TU4g4H88FXqKJ7cD043f4QeFsM/6CPYcHBeB4WSQa9CIA6FnhoFiG
   BJ9Dy4MPaNnJWJz6sAyGpXXLiwxbwqRFulr9PCm/gS1/imrAmUnTjvwdD
   0XWyD7KCKsE0dH7f/BoE6KXcZakqtfAEnrlJbQAGe2ofjB78e34J4trw7
   gScRL94RQ7SYNgXxNiMJ6LHTIIFKEgzJ7IQrl4dOyOQ/3fPsUZdPpBbPY
   zTTbGwkylP/tTHs7hB5hiAKDtB0ir6/TB/PzCA5H8AIzxb+9qIAgCMcCl
   OqkRvsrNBM5ALRKsrc5eREfgPkej1zrM1eVyFyFl61Le42rdHVzcgyMv7
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675148"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:21 +0800
IronPort-SDR: RDe7F71NHH+FAPUYEiuH/5Tv76Y2OVnbSiMROni45cLbx4uymolvL+G6ZYx3y08RpLrI/uPXTY
 xiJUNEr3YovKl0eVBibMAdL7wutKYYhsdorroE6BS3Z7CtqX106IkezUp+x1o6k1UFXq+286Nk
 RAiQXFwwIYneiTeNC3eigj3OLqNv8+tIE3laOm99ZgxQrPwJ7nPMIVQRcRKKRWpLZ/+t0GziKJ
 WBEYkqqRVPeA9+uKkMz74kdFMbbDiX8+EzGhPSIX2s4u5Hc7P9jPWb4IER+a5rIZ9YZ/OZ6tTR
 PO1Kxd0vByyy6NvEZF4IOCx+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:10 -0800
IronPort-SDR: beev+G5IM++SoX1sX+xM8yTJkxWJviJFD9QTUeRNUlYjuCBieI5tXFtAcQyYkOc6sjNwTTDWpG
 Kb/WK9dRXXRD9EmwtHuokhcM2qtc10D2ZbjyD0yIQ9ZE0QOQNa9LvoTELpdAoaXuX/TcbxdWvk
 eh/s8azEHfGpNoX3kSjmn5Xpn5WDJf4BGEa5VBH9TO+hY7PLJUxc0Uonv3HhgfJsY9TBsmDH6E
 GWV+S9/4qT8GnJJbwqnQZRJadM3c07kxq5h9BZsJMbidW+pZBguyCT9RARWPJUgid3CKAgVZW2
 XIo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:24 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56q3Hykz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:23 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565042; x=1647157043; bh=0By2svS/qa6+92M3y1
        emldA/HHxQI5Ee/J/kHWALG8U=; b=KaAAI+spW/Hg+0GQtXoXk2nxaSqYAL5Zob
        P6BUJVXJldvZtCqyF4JJq3t23MYtd+gVAiVY0Zk7lLpM8IzGnYXU/U/xWK707vtd
        rmOQoHN7by9TaUfjROvwH/fLnS2s/mOSh/GoSvw82+sc0i9DrwJIHNuNhdE3ulKD
        1h3thrUSmW7uHZonDvPvl2bihVOs9uZmYhJK01RNzx9FyiLsH1HWPI35dz2zZoXR
        BiVrLCa+K9ktEwqe6t3W0uTp+mNLlN1F9jtiYZFTya9OM2oZeNDkWeuXobnc+eSY
        ey32oII7pLc+NXd2wDzjJz3E9anHljUmjj0l3gIsomnBDt90FngA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PTV2KfXHkfUM for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:22 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56n6V8Hz1Rwrw;
        Thu, 10 Feb 2022 23:37:21 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 13/24] scsi: pm8001: fix le32 values handling in pm80xx_chip_ssp_io_req()
Date:   Fri, 11 Feb 2022 16:36:53 +0900
Message-Id: <20220211073704.963993-14-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
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
index 41a74943888b..2e1a9261212d 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4378,13 +4378,15 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
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
@@ -4395,7 +4397,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 	ssp_cmd.device_id =3D cpu_to_le32(pm8001_dev->device_id);
 	ssp_cmd.tag =3D cpu_to_le32(tag);
 	if (task->ssp_task.enable_first_burst)
-		ssp_cmd.ssp_iu.efb_prio_attr |=3D 0x80;
+		ssp_cmd.ssp_iu.efb_prio_attr =3D 0x80;
 	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_prio << 3);
 	ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_attr & 7);
 	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
@@ -4427,21 +4429,24 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
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
@@ -4450,7 +4455,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba=
_info *pm8001_ha,
 					cpu_to_le32(lower_32_bits(phys_addr));
 				ssp_cmd.enc_addr_high =3D
 					cpu_to_le32(upper_32_bits(phys_addr));
-				ssp_cmd.enc_esgl =3D cpu_to_le32(1<<31);
+				ssp_cmd.enc_esgl =3D cpu_to_le32(1U<<31);
 			}
 		} else if (task->num_scatter =3D=3D 0) {
 			ssp_cmd.enc_addr_low =3D 0;
@@ -4458,8 +4463,10 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hb=
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
@@ -4481,20 +4488,22 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_h=
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

