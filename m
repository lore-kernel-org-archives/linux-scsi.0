Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BC9C11D3D
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 20:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A1832469C
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 20:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Oen5ndr/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgB0ULz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:11:55 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27256 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbgB0ULz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Feb 2020 15:11:55 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RK6i56001012;
        Thu, 27 Feb 2020 12:11:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=Xz4rNRtkWAc3KiNuLLg7WLpB2BlWmjWOGhy6uUUmPtg=;
 b=Oen5ndr/ksA6FmcYaAMy9jjmA5/KqblBYV2udg/pt+zZSm8zTHn/k1Nh1aGwfSG3NHxZ
 azv12MMFByRMQk4RFv6uDv/Tznk5SsSp5GkYo7aa0+jk5t0o5ApBcr11XXMLdJj15cB6
 Pc/cYHMydkm1E4iA9nG107pZfG1OP0LaX/RocEyv0w7AbJMvKZvBbQB4icTLcvBQikm1
 MhxyHp2cQ2KUaRfliiflr5uyuWVMJmNTklnMxQ8srSSDl6BfDosZruCOfeLf7xW0AWrC
 iHGdkozFwnjanJgpqGapNLHutbUVa58JZGkC6ZaIkD+0hD+UvWFdq9ztktuGtKJxPT04 nw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtj9f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 Feb 2020 12:11:52 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 Feb
 2020 12:11:49 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 Feb
 2020 12:11:49 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Feb 2020 12:11:48 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EADFE3F703F;
        Thu, 27 Feb 2020 12:11:48 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01RKBmlu014008;
        Thu, 27 Feb 2020 12:11:48 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01RKBm4B014007;
        Thu, 27 Feb 2020 12:11:48 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/1] qla2xxx: Fix sparse warning reported by kbuild bot
Date:   Thu, 27 Feb 2020 12:11:48 -0800
Message-ID: <20200227201148.13973-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_06:2020-02-26,2020-02-27 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

this patch fixes following sparse warnings

 >> drivers/scsi/qla2xxx/qla_tmpl.c:873:32: sparse: sparse: incorrect type in assignment (different base types)
 >> drivers/scsi/qla2xxx/qla_tmpl.c:873:32: sparse:    expected unsigned int [usertype] capture_timestamp
 >> drivers/scsi/qla2xxx/qla_tmpl.c:873:32: sparse:    got restricted __le32 [usertype]
    drivers/scsi/qla2xxx/qla_tmpl.c:885:29: sparse: sparse: incorrect type in assignment (different base types)
 >> drivers/scsi/qla2xxx/qla_tmpl.c:885:29: sparse:    expected unsigned int

  vim +873 drivers/scsi/qla2xxx/qla_tmpl.c

  869
  870	static void
  871	qla27xx_time_stamp(struct qla27xx_fwdt_template *tmp)
  872	{
> 873		tmp->capture_timestamp = cpu_to_le32(jiffies);
  874	}
  875
  876	static void
  877	qla27xx_driver_info(struct qla27xx_fwdt_template *tmp)
  878	{
  879		uint8_t v[] = { 0, 0, 0, 0, 0, 0 };
  880
  881		WARN_ON_ONCE(sscanf(qla2x00_version_str,
  882				    "%hhu.%hhu.%hhu.%hhu.%hhu.%hhu",
  883				    v+0, v+1, v+2, v+3, v+4, v+5) != 6);
  884
> 885		tmp->driver_info[0] = cpu_to_le32(
  886			v[3] << 24 | v[2] << 16 | v[1] << 8 | v[0]);
  887		tmp->driver_info[1] = cpu_to_le32(v[5] << 8 | v[4]);
  888		tmp->driver_info[2] = __constant_cpu_to_le32(0x12345678);
  889	}
  890

Fixes: a31056ddc665 ("scsi: qla2xxx: Use endian macros to assign static fields in fwdump header")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
Hi Martin, 

This patch fixes sparse warning introduced by pervious series. 

Please apply this patch to 5.7/scsi-queue at your earliest convenience.

Thanks,
Himanshu
---
 drivers/scsi/qla2xxx/qla_tmpl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.h b/drivers/scsi/qla2xxx/qla_tmpl.h
index d2a0014e8b21..bba8dc90acfb 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.h
+++ b/drivers/scsi/qla2xxx/qla_tmpl.h
@@ -18,11 +18,11 @@ struct __packed qla27xx_fwdt_template {
 
 	__le32 entry_count;
 	uint32_t template_version;
-	uint32_t capture_timestamp;
+	__le32 capture_timestamp;
 	uint32_t template_checksum;
 
 	uint32_t reserved_2;
-	uint32_t driver_info[3];
+	__le32 driver_info[3];
 
 	uint32_t saved_state[16];
 
-- 
2.12.0

