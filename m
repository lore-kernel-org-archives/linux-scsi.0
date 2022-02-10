Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D272C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbiBJLnA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:43:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241167AbiBJLms (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:48 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849EA102D
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493370; x=1676029370;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=+J8FxMhXR8JWNegw+xYbyFv9L2V5iQzskG8x+OQmcLU=;
  b=ag4Dnl9Z42CH74xPsgpJggRiQiWL6XR3v8OuxyXkvWg0G9NBEWBxXBDd
   Ww4DcCVI+1L9LcAtul5ILDcARpDHK7LGt7Gl0M5luWfVfC9Rihb0wnJ12
   mRg3GIkDDM66FHyy7iUF0jf51QuN5+8AFmL3Q9/ng1fLzLYrjppV40IDR
   rKxh71KDmOhi5cXFc3AP0gITSJSMxQiiah5WtWcGKuChOsR49c3TFNRRv
   s7wWHX38HVfvL0BhlfjSA6Tq3XdUbB8ZMlQgG7mVEHkrnhPMqOFiQ1MF0
   UhJyPHX8iGLUGAvA/6TFg1ElXY5Ubs8/r3Auje40/E/2yKD+LHAEUG2or
   w==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575672"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:50 +0800
IronPort-SDR: gJ0WNMk5OiUGjMMRaxMNF3LjhmjiyAdoBwNePOxpclsQLSXiRyXgBPzueB1WM7NaAn7v3JVm39
 8kN9tbFoSO3LDHAKeb3LLiERWMlP1cK+HDdJPmaYonAmNf+dGesEHbUcoJKVzFQCaObrfHUgRi
 7+hqlTpKF/0lm/2GCfO2Ock7jtHK7s5NUOP9ocuPP28hAIF8Nb/as+lDMW1BmEKCIDl2pW7X4v
 /qRUu2hLtbaMqBaU1uLr4Bx+j0mQI/PGcMrnhk3BofeeuNOdWaA6RDK0nzLT5f0tSgotj2DW7/
 TUhpAIx7J2cffBarcz76djat
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:46 -0800
IronPort-SDR: f5VHWXWV9TqF2h/fTktrGMy6s2FoKPpEEKdiKKDvarGkoKAbqTSlR6LKHtWMVP9i8Zv6on4A5T
 1tzNgiC6Lv/jpSNauhB2I1I7H7do6M15A/odoACjmj3TTrh4sdm4B8FdhbhvqQ0k7Vm7kEEcAT
 uikazlotwD5LPfvIv7Um8p7ZWmV3Fc27TypxSQI30DgAG81eU3p7XrKDPhB1P9TqevsQ3QYYen
 DxHD2Uf7krNOLT3YJgtmdCgJcfu9glpqkduFvjUD0Seiu3cCpE28/fMisuYQIw7f11jq8jRSN4
 5YY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:50 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcT0X3Pz1Rwrw
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:49 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493368; x=1647085369; bh=+J8FxMhXR8JWNegw+x
        YbyFv9L2V5iQzskG8x+OQmcLU=; b=eYG9CiXWVd1RTjEbwsuo7cVvhpnWoRydVN
        Dckd/KipAzXxGeU2ZFilTrL1rHNcTlwq5PKO7nKqkaFewmZFR4VqGlFaIX2wu2NI
        yiYNqnkSBWQB0emaYKRlzOZv7RvmAcXLnq02Ki3uv40pClmKfrIafzsk/dON3RY0
        1ZYmGaW88ppW5tTe2sggQZVL86XfsOtfDZ1ZWx/TSuOFnnEiqi/7TEJ6y7Xkl1wc
        tmlsOwtpRG4YPOr13vYN2Q47OOeSQkO1si9D1gN2UkXzWM/c91ZH92odnLQZR+ea
        rPAOqVFX/UElE0Naahjj9wAZHQZaKWsaIMtZB7r3nVeq6rTffvfg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fpaiGLRrjPyT for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:48 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcR4htyz1SHwl;
        Thu, 10 Feb 2022 03:42:47 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 20/20] scsi: pm8001: fix abort all task initialization
Date:   Thu, 10 Feb 2022 20:42:18 +0900
Message-Id: <20220210114218.632725-21-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm80xx_send_abort_all(), the n_elem field of the ccb used is not
initialized to 0. This missing initialization sometimes lead to the
task completion path seeing the ccb with a non-zero n_elem resulting in
the execution of invalid dma_unmap_sg() calls in pm8001_ccb_task_free(),
causing a crash such as:

[  197.676341] RIP: 0010:iommu_dma_unmap_sg+0x6d/0x280
[  197.700204] RSP: 0018:ffff889bbcf89c88 EFLAGS: 00010012
[  197.705485] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8=
3d0bda0
[  197.712687] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff88810=
dffc0d0
[  197.719887] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8881c=
790098b
[  197.727089] R10: ffffed1038f20131 R11: 0000000000000001 R12: 000000000=
0000000
[  197.734296] R13: ffff88810dffc0d0 R14: 0000000000000010 R15: 000000000=
0000000
[  197.741493] FS:  0000000000000000(0000) GS:ffff889bbcf80000(0000) knlG=
S:0000000000000000
[  197.749659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  197.755459] CR2: 00007f16c1b42734 CR3: 0000000004814000 CR4: 000000000=
0350ee0
[  197.762656] Call Trace:
[  197.765127]  <IRQ>
[  197.767162]  pm8001_ccb_task_free+0x5f1/0x820 [pm80xx]
[  197.772364]  ? do_raw_spin_unlock+0x54/0x220
[  197.776680]  pm8001_mpi_task_abort_resp+0x2ce/0x4f0 [pm80xx]
[  197.782406]  process_oq+0xe85/0x7890 [pm80xx]
[  197.786817]  ? lock_acquire+0x194/0x490
[  197.790697]  ? handle_irq_event+0x10e/0x1b0
[  197.794920]  ? mpi_sata_completion+0x2d70/0x2d70 [pm80xx]
[  197.800378]  ? __wake_up_bit+0x100/0x100
[  197.804340]  ? lock_is_held_type+0x98/0x110
[  197.808565]  pm80xx_chip_isr+0x94/0x130 [pm80xx]
[  197.813243]  tasklet_action_common.constprop.0+0x24b/0x2f0
[  197.818785]  __do_softirq+0x1b5/0x82d
[  197.822485]  ? do_raw_spin_unlock+0x54/0x220
[  197.826799]  __irq_exit_rcu+0x17e/0x1e0
[  197.830678]  irq_exit_rcu+0xa/0x20
[  197.834114]  common_interrupt+0x78/0x90
[  197.840051]  </IRQ>
[  197.844236]  <TASK>
[  197.848397]  asm_common_interrupt+0x1e/0x40

Avoid this issue by always initializing the ccb n_elem field to 0 in
pm8001_send_abort_all(), pm8001_send_read_log() and
pm80xx_send_abort_all().

Fixes: c6b9ef5779c3 ("[SCSI] pm80xx: NCQ error handling changes")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 ++
 drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 8095eb0b04f7..d853e8d0195a 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1788,6 +1788,7 @@ static void pm8001_send_abort_all(struct pm8001_hba=
_info *pm8001_ha,
 	ccb->device =3D pm8001_ha_dev;
 	ccb->ccb_tag =3D ccb_tag;
 	ccb->task =3D task;
+	ccb->n_elem =3D 0;
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
@@ -1849,6 +1850,7 @@ static void pm8001_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
 	ccb->device =3D pm8001_ha_dev;
 	ccb->ccb_tag =3D ccb_tag;
 	ccb->task =3D task;
+	ccb->n_elem =3D 0;
 	pm8001_ha_dev->id |=3D NCQ_READ_LOG_FLAG;
 	pm8001_ha_dev->id |=3D NCQ_2ND_RLE_FLAG;
=20
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 4d88c0dbcefc..902af4eefa26 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1801,6 +1801,7 @@ static void pm80xx_send_abort_all(struct pm8001_hba=
_info *pm8001_ha,
 	ccb->device =3D pm8001_ha_dev;
 	ccb->ccb_tag =3D ccb_tag;
 	ccb->task =3D task;
+	ccb->n_elem =3D 0;
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
--=20
2.34.1

