Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94055C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347704AbiBKHho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347751AbiBKHhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:37 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF357271B
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565051; x=1676101051;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=m9ONpfbaNybtnS2LxOy9cE3+ApQLiS17hBJJN1ZGn9o=;
  b=YNcxnjkQC/NowUJQnpuQ8421kb0OrB6jxO7IEadPEFz037iGBht0Jo8J
   8u1P4xAYs250PocnnUE4PxeNPV6ebSoRPCaTm51BkhPVxsGQPzph/JBe6
   K56oELSoMv/3q9aGP4+9JjKWkWwCMvHm2919PsoB9UXwgo+eJMLPMqZTK
   8KvdCgaKR+E2TcnzaLNXET9eWMtu43wqyeG7I44s+RkPObE6qwcjNC021
   CllM5C+SoTHdKs1o/PX4d/y+MFQPBQbF+Ac7u8jB75hbYe8m7QSCTNU8u
   c2rQaQqRVuTsoxcu/lNRd1EHqFBYCOav4Gx8Lyl/jzHSMdhlmp3W0AmWX
   A==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675158"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:30 +0800
IronPort-SDR: A6YfhkLwW9N0RQbk8Ou6Bgd1J+9WvoWVvjJVcgrpkyoRrJzo4hZ90vUTpDNyjj4xV+V4Ok9ZsK
 JCqKBJcSIuWxEyXZJI/rnsoFI9BBkzhKXka/YGAwY3LJ/08emz7zc+OUUDXO1PogIt0U0yrSKG
 1sn/zVv/mgZqnLGWZIOX4/2rBmf4j18CiFqAlHZ8WjmV4hHRC8ghyqKjAzFA+nFJ1wSXqvcznM
 sU4BH+fR87oKejdup9a7rnunGKSB52Bt3QQIYImVaT0Z6ZRdNfoYjXHdtM7Um0/DDFsFToEG8m
 JW7kyGDLY9Z6L5vvR/R/S9Rk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:19 -0800
IronPort-SDR: rIwrTnbQ7x23p82vMbZ0ih85XEco5LKFVLL7PUmY1obTYzh+YJLU9GT90D/kaiK39nJBStSK+S
 2maTLTvSXCLodrrTSYcxZRSOvTU7tFCEqigWO/y0484rKEkPRZKuLH4GyjVto6v4Swuhr7smhy
 2lE1dCbLLhXOrEyRfQAKjlbwDbCHgOltANUxUWaDsreqyVnzVldafZRNAmjJP71giEZpB/R5fP
 lif+a0CFvHRLIsWZjypGXM5ySUgjlm8VFAKQ/jZ/OQls2jeGhRXe00CVjK3M4Gt0i+DS29lyon
 2MI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:33 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw5703vHrz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565051; x=1647157052; bh=m9ONpfbaNybtnS2LxO
        y9cE3+ApQLiS17hBJJN1ZGn9o=; b=ZlsL+uU9AYNrRQP58iR+Z8MmCfLyO4DwL1
        Gyy80vdOC75P6u7NHlh7Zz5QeSUup7B1yIWFA7YiwJdRKVXp4PZpaeWVq/QPtlDr
        71SPyuLgC6enm8yr0d99f8bRI+rmiJn40L5/vRRUSW1EXiIU04jMWquqeotkHTK9
        acybukOvVAgmL4O0wCmrMjyyoLJBvAG0J+5Rjtbzam1KQe4D90q5pMolPDnPHJH6
        z/HAr1njEzaVLoAbECfI4i/Hh+TUDAILLHQqCcqXKGqrGqDEJuzs1clrxJxnFdKq
        a/vaNyru+GuSMxEWzhTf37BBEUp4vZXvqEI8BgJICt1GKRPzo/FQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id WkR_1LyMMpE1 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:31 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56y6HScz1SHwl;
        Thu, 10 Feb 2022 23:37:30 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 20/24] scsi: pm8001: fix abort all task initialization
Date:   Fri, 11 Feb 2022 16:37:00 +0900
Message-Id: <20220211073704.963993-21-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
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
index d9f0afe784e7..0cf515844493 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1800,6 +1800,7 @@ static void pm80xx_send_abort_all(struct pm8001_hba=
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

