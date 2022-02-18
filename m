Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335B0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiBRDPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:47 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiBRDPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:43 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084FA1BAC68
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154112; x=1676690112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZdAZjOz0DdWfc2ddhVgvZaPj7g27emWw7eDrDZx7wkg=;
  b=CPK4c+IoCmsIfIJvPFSfr8yWSiiUotEp40+fT4F9JHB5VhtCe77Kt38x
   YcicgUP9gxN6KMHnNno1qJHAUfnUCh0mUo6mWBVbR8LJHwA8Cx8e9K6L3
   yGP3Kb+7WvyZQuVwzNmr6DC2/v+Z7AezdyW3HDrcABa6FjhwxySK8P4iY
   4fXuQc1yXNZABhlIZSqn4qY7BSmhplKukdLm7StVk/p9KNsUjCTNXMvad
   fmsMgv81ebvqAPXyehaBaJAjOKRDAcKUFAuu4ex6jchcRZZ5oumblW7Yh
   xVEi5pA7vmG4syDzrjXahJqQCh/8GyySDQhwhRGw36qjSHU5vO0kj7rWG
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225800"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:12 +0800
IronPort-SDR: dlF2m+Tez8fiWH+PK2GgaRyFCcOjR29xmslEm6f9iDhMFCIttWUJ7g0CGjB/IKpgxzINJyv0i0
 NMdR6vVaeP47sK5tk1nWsr5uA+isALb6y/fJSG9KFRxwC8Vf58zneXad9C5oI3FQ8QjHfIX0WO
 WelJkBy+sGPEAKLGfAXmdqwVq1cOFJdP4V20MHlSz27gvzFNEGt6hAs/tCUjSTZyEMK+gUuMQ+
 DQ0sAs+AVWQYsqpwVrJ9oGY2D6O1eqleTNyqtP9SuMD8z7tWACuYGenQJ0nSiORxuJvyAqRpd4
 +6KhdZLF17QA4pV7e/iOt0Xe
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:49 -0800
IronPort-SDR: MLqjkDlDilUGqhNsuzEw1XNYVsHnVJOE3pCaF2r93qGT+WbC27Ykb0EKnOQfg/7BMUzTH1c0DL
 mEDQ2R+i+JX9NgG8EVncaohjmL7j7HBq0ZL12BqAuRzx4cOX1dpVzZGpd4iPns7WAWzGgVmhoS
 SoMwiU64vQVyAtLIi0EGYWb7dvl6mUWTIL9Aa3rYfkGxJxq8EeAoKjtMSeC1s1cDWWLhk1DpdK
 glbOGUWj2AcmjbbbqBUD+0gyUqochCuC5RRr1Dbqr3XdPdfSe+FUzBD0BsuHf62tJddOUG2Oza
 anw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:12 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gz32pxwz1SVp4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:11 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154110; x=1647746111; bh=ZdAZjOz0DdWfc2ddhV
        gvZaPj7g27emWw7eDrDZx7wkg=; b=N7Wcsw5rtuV6OuKJ2g3GkCfqfVD6srZ0py
        Y9PEy4/VT9n9I5EsBdjfyaXxuVXgcja99iZKj4YrjHRgJa2AYokYZlImmHJSwdmS
        4LH+XoZV6Xlcpxqb61jhAtw2P1Z3UhvgMUCLfijD/TNZiDkkuNBrT+AXzqpZGijV
        khUI28LXqC22BwyWRi65g4u5XuTS5Ww8uOreV7Aohc7SxwveL3q/+3QkymvrM8c3
        6KRu5+dfLZ6aE+kQTKVILIJLyVCR3z836QAb2FVCX3J2yHFOIRllUtcwQ6oqpj+Q
        GG9AMJjdhIXgzY8HgiUg0BipefLQAV6AoIetna3+0uwIGCfUBaog==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id q3CPvhddtbsQ for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:10 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gz14zhcz1SHwl;
        Thu, 17 Feb 2022 19:15:09 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 16/31] scsi: pm8001: Fix abort all task initialization
Date:   Fri, 18 Feb 2022 12:14:30 +0900
Message-Id: <20220218031445.548767-17-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 ++
 drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 8149cc0d1ecd..35d62e5c9200 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1787,6 +1787,7 @@ static void pm8001_send_abort_all(struct pm8001_hba=
_info *pm8001_ha,
 	ccb->device =3D pm8001_ha_dev;
 	ccb->ccb_tag =3D ccb_tag;
 	ccb->task =3D task;
+	ccb->n_elem =3D 0;
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
=20
@@ -1848,6 +1849,7 @@ static void pm8001_send_read_log(struct pm8001_hba_=
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
index ac2178a13e4c..8fd38e54f07c 100644
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

