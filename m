Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357DC5DF29
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 16:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707841343; cv=none; b=kF+UBEUUIDlWfkJDM7BGzMjmpM6E+FrSmqKt77NM2ndgeOkamBLhOo7p+hxpyKTUYnE3aw2U/MjU2YmJIS6VkprePO7fFnU56UjLHdekiSrdiFurl1AssjZQWgkNk4+4KE6R14pE2T1qKH2b6g+5DL32t6tyaTHMwUmMK6CaZgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707841343; c=relaxed/simple;
	bh=g8ULe2rGHOtOWs+LWp56qV/96vY8Lg+qwFde3eozw/0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VEIp0qZtOn4QAyrNRc07G2GQQ2tBVxbPDKfIi3jPLfrQttstCG4zIRyNQrYVdh+effX+zQjr5wy4vYNiEwc0xOn1tY0O6cWyIE0F71x0K78Ksx3NO1Dz6ln1MTwcrtZJ+t8diEMNcS8RfErwUflTFOgp6Ff42M5zzTXxsI7+soo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=E69MCDhM; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="E69MCDhM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1707841341; x=1739377341;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=g8ULe2rGHOtOWs+LWp56qV/96vY8Lg+qwFde3eozw/0=;
  b=E69MCDhM2U7k71JyN8c29m50vEVvtNFTboBvqw9jGNw5LEtNVSAtXrqd
   344vE/f/CIf1oKRXBHr3fAIkSRdNiiG9T9aOFeDcobsbybx0QOxDQodzM
   TcaLKNZqiuf3Q9NNLZ2DTDNBUjd6Egqj7oyjmP69RPI/Cjbi/LbqvMP8y
   UBEmdExA34Cz9U9Hi3Jk2XLI9WxsZogl0sejtFVAUIHqpkzeUO2N714Ja
   Hmrl7Cl/A/ZteMV5B+hi9QYwseNJ0UM2DozwUI0NCh8384l1HmYTHuksz
   PSfAMpNm3mNzsp8UUhU8q7XUYjSJklesfep24k283C8baYH/z4mjIHubQ
   Q==;
X-CSE-ConnectionGUID: w5KKbWU/SwilVwDndMwVdw==
X-CSE-MsgGUID: s8rPbMgMQPud9PWllgiAcg==
X-IronPort-AV: E=Sophos;i="6.06,157,1705388400"; 
   d="scan'208";a="16180974"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2024 09:22:19 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 13 Feb 2024 09:22:01 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 13 Feb 2024 09:22:00 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
	<scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
	<POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH] smartpqi: fix disable_managed_interrupts
Date: Tue, 13 Feb 2024 10:21:59 -0600
Message-ID: <20240213162200.1875970-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.44.0.rc0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Correct blk-mq registration issue with module parameter
disable_managed_interrupts enabled.

When we turn off the default PCI_IRQ_AFFINITY flag, the driver needs to
register with blk-mq using blk_mq_map_queues(). The driver is currently
calling blk_mq_pci_map_queues() which results in a stack trace and
possibly undefined behavior.

Stack Trace:
[    7.860089] scsi host2: smartpqi
[    7.871934] WARNING: CPU: 0 PID: 238 at block/blk-mq-pci.c:52 blk_mq_pci_map_queues+0xca/0xd0
[    7.889231] Modules linked in: sd_mod t10_pi sg uas smartpqi(+) crc32c_intel scsi_transport_sas usb_storage dm_mirror dm_region_hash dm_log dm_mod ipmi_devintf ipmi_msghandler fuse
[    7.924755] CPU: 0 PID: 238 Comm: kworker/0:3 Not tainted 4.18.0-372.88.1.el8_6_smartpqi_test.x86_64 #1
[    7.944336] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 03/08/2022
[    7.963026] Workqueue: events work_for_cpu_fn
[    7.978275] RIP: 0010:blk_mq_pci_map_queues+0xca/0xd0
[    7.978278] Code: 48 89 de 89 c7 e8 f6 0f 4f 00 3b 05 c4 b7 8e 01 72 e1 5b 31 c0 5d 41 5c 41 5d 41 5e 41 5f e9 7d df 73 00 31 c0 e9 76 df 73 00 <0f> 0b eb bc 90 90 0f 1f 44 00 00 41 57 49 89 ff 41 56 41 55 41 54
[    7.978280] RSP: 0018:ffffa95fc3707d50 EFLAGS: 00010216
[    7.978283] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 0000000000000010
[    7.978284] RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff9190c32d4310
[    7.978286] RBP: 0000000000000000 R08: ffffa95fc3707d38 R09: ffff91929b81ac00
[    7.978287] R10: 0000000000000001 R11: ffffa95fc3707ac0 R12: 0000000000000000
[    7.978288] R13: ffff9190c32d4000 R14: 00000000ffffffff R15: ffff9190c4c950a8
[    7.978290] FS:  0000000000000000(0000) GS:ffff9193efc00000(0000) knlGS:0000000000000000
[    7.978292] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.172814] CR2: 000055d11166c000 CR3: 00000002dae10002 CR4: 00000000007706f0
[    8.172816] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    8.172817] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    8.172818] PKRU: 55555554
[    8.172819] Call Trace:
[    8.172823]  blk_mq_alloc_tag_set+0x12e/0x310
[    8.264339]  scsi_add_host_with_dma.cold.9+0x30/0x245
[    8.279302]  pqi_ctrl_init+0xacf/0xc8e [smartpqi]
[    8.294085]  ? pqi_pci_probe+0x480/0x4c8 [smartpqi]
[    8.309015]  pqi_pci_probe+0x480/0x4c8 [smartpqi]
[    8.323286]  local_pci_probe+0x42/0x80
[    8.337855]  work_for_cpu_fn+0x16/0x20
[    8.351193]  process_one_work+0x1a7/0x360
[    8.364462]  ? create_worker+0x1a0/0x1a0
[    8.379252]  worker_thread+0x1ce/0x390
[    8.392623]  ? create_worker+0x1a0/0x1a0
[    8.406295]  kthread+0x10a/0x120
[    8.418428]  ? set_kthread_struct+0x50/0x50
[    8.431532]  ret_from_fork+0x1f/0x40
[    8.444137] ---[ end trace 1bf0173d39354506 ]---

Fixes: ("cf15c3e734e8 scsi: smartpqi: Add module param to disable managed ints")

Tested-by: Yogesh Chandra Pandey <YogeshChandra.Pandey@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ceff1ec13f9e..385180c98be4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6533,8 +6533,11 @@ static void pqi_map_queues(struct Scsi_Host *shost)
 {
 	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
 
-	blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+	if (!ctrl_info->disable_managed_interrupts)
+		return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
 			      ctrl_info->pci_dev, 0);
+	else
+		return blk_mq_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT]);
 }
 
 static inline bool pqi_is_tape_changer_device(struct pqi_scsi_dev *device)
-- 
2.44.0.rc0

