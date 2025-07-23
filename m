Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B329238C2A
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 05:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753248366; cv=none; b=Z2ee2FB2airc++V2ljJEteOkHAMhNWfxGiOTFMhcAUvHcO/fnfahKq650RwAU3pXLhNJIsGzh/ISNbTo+lLiDASu0BQkZhgsE/Ei1HPyX3vLGvoTBHjf/efpolb+/YSj80PNzDBL+bLTTxATTje6sn5COhQqy30Go97F1gdm+rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753248366; c=relaxed/simple;
	bh=hOgC0Luv5ZC0XaJ31H6GGq2S7smpJiSOHEqRhiL3Kqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqq1jlqHyL82oaK/6rbWl64WtKdhkHlztpfKHMvUHV/XvHU8ATqpgGdqWUtrsu0afXkY+beetV5Wg92/jIWdZsNSh/y14NQ2OUjbha+uAyxT3UvA8nx4K93HZTOobLz5eKzGGJj22OFf7T3FIjRnYOCGnE7bWpS+K5rUsYqBx9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RiD2nxe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RiD2nxe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1BCC4CEF1;
	Wed, 23 Jul 2025 05:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753248365;
	bh=hOgC0Luv5ZC0XaJ31H6GGq2S7smpJiSOHEqRhiL3Kqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiD2nxe1QmTCgKf9zjKztYY6si5EeX80KEFD+QagHB4zf39si4T745Y5L4T6HsVcn
	 mS6rcF0vEvSUp70+SDOxjFOfunAawjnI9AQC8pwfaKFuUJlKzH5gbdHCYUo7RXiOCW
	 sqyil3auookzivZuQojffGBRIDF7Zkn4bmOXwxMkjl9hLTRO275TAGZ9o02WBOw15c
	 ptv/xwcNX8rpjTiGS9THVyrPEEUfoHvLhIsME6SbDwbtl/c/4ac2z1l356tKXJqUVa
	 IQeYIzlmwa2M+zLbJn5bQpm9GUDIDZvVSKD9kjmvZ0hFJDOqzrevdzcubSdtcTCVFx
	 2mb4DXbr7KwaQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com
Cc: Friedrich Weber <f.weber@proxmox.com>
Subject: [PATCH 2/2] scsi: mpt3sas: Disable Command Duration Limit Probing
Date: Wed, 23 Jul 2025 14:23:34 +0900
Message-ID: <20250723052334.32298-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723052334.32298-1-dlemoal@kernel.org>
References: <20250723052334.32298-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All SAS HBA models controlled by the mpt2sas and mp3sas drivers do not
support the Command Duration Limits (CDL) feature of ATA devices in
their SCSI-to-ATA translation layer (SAT) firmware. Probing ATA devices
for CDL support with scsi_cdl_check() will thus always result in CDL
being reported as not supported.

However, users in the field have reported that some of these HBA models
react badly to this probe and cause scan command errors when
scsi_cdl_check() is called, especially for device probe resulting from
a device hotplug. An example of such problem is shown below:

kernel: mpt3sas_cm0: handle(0xa) sas_address(0xREDACTED_SAS_ADDR) port_type(0x1)
kernel: scsi 5:0:1:0: Direct-Access     WDC      REDACTED_SN  C5C0 PQ: 0 ANSI: 7
kernel: scsi 5:0:1:0: SSP: handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR), phy(2), device_name(REDACTED_DEVICE_NAME)
kernel: scsi 5:0:1:0: enclosure logical id (REDACTED_LOGICAL_ID), slot(0)
kernel: scsi 5:0:1:0: enclosure level(0x0000), connector name(     )
kernel: scsi 5:0:1:0: qdepth(254), tagged(1), scsi_level(8), cmd_que(1)
kernel: scsi 5:0:1:0: Power-on or device reset occurred
kernel: mpt3sas_cm0: log_info(0x31110e05): originator(PL), code(0x11), sub_code(0x0e05)
kernel: mpt3sas_cm0: log_info(0x31130000): originator(PL), code(0x13), sub_code(0x0000)
kernel: sd 5:0:1:0: Attached scsi generic sg1 type 0
kernel: sd 5:0:1:0: [sdb] Test Unit Ready failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
kernel: sd 5:0:1:0: [sdb] Read Capacity(16) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
kernel: sd 5:0:1:0: [sdb] Sense not available.
kernel: sd 5:0:1:0: [sdb] Read Capacity(10) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
kernel: sd 5:0:1:0: [sdb] Sense not available.
kernel: sd 5:0:1:0: [sdb] 0 512-byte logical blocks: (0 B/0 B)
kernel: sd 5:0:1:0: [sdb] 0-byte physical blocks
kernel: sd 5:0:1:0: [sdb] Test WP failed, assume Write Enabled
kernel: sd 5:0:1:0: [sdb] Asking for cache data failed
kernel: sd 5:0:1:0: [sdb] Assuming drive cache: write through
kernel:  end_device-5:1: add: handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR)
kernel: mpt3sas_cm0: handle(0x000a), ioc_status(0x0022) failure at drivers/scsi/mpt3sas/mpt3sas_transport.c:225/_transport_set_identify()!
kernel: sd 5:0:1:0: [sdb] Attached SCSI disk
kernel: mpt3sas_cm0: mpt3sas_transport_port_remove: removed: sas_addr(0xREDACTED_SAS_ADDR)
kernel: mpt3sas_cm0: removing handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR)
kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(0)
kernel: mpt3sas_cm0: enclosure level(0x0000), connector name(     )

This issue sometimes even requires a full host power cycle to recover
and get a successful device scan.

This issue is likely limited to older models that are now EOL and since
no HBA firmware update will fix this issue, work around it by
force-disabling CDL probing on ATA devices by setting the no_ata_cdl
SCSI host template flag. This does not affect well-behaved HBA models
since as mentioned above, these HBAs do not support ATA CDL anyway. This
change also does not affect probing of CDL support on SAS devices.

Reported-by: Friedrich Weber <f.weber@proxmox.com>
Fixes: 624885209f31 ("scsi: core: Detect support for command duration limits")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d7d8244dfedc..32c3ab18cfbc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11943,6 +11943,7 @@ static const struct scsi_host_template mpt2sas_driver_template = {
 	.shost_groups			= mpt3sas_host_groups,
 	.sdev_groups			= mpt3sas_dev_groups,
 	.track_queue_depth		= 1,
+	.no_ata_cdl			= 1,
 	.cmd_size			= sizeof(struct scsiio_tracker),
 };
 
@@ -11982,6 +11983,7 @@ static const struct scsi_host_template mpt3sas_driver_template = {
 	.shost_groups			= mpt3sas_host_groups,
 	.sdev_groups			= mpt3sas_dev_groups,
 	.track_queue_depth		= 1,
+	.no_ata_cdl			= 1,
 	.cmd_size			= sizeof(struct scsiio_tracker),
 	.map_queues			= scsih_map_queues,
 	.mq_poll			= mpt3sas_blk_mq_poll,
-- 
2.50.1

