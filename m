Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DD0471268;
	Thu, 27 Aug 2026 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787854022; cv=none; b=l2JB2Uar7bhp5j66e1kYy0iJFlcX7H+/aCgoigB58cTvLF1GYTLFVedOVNydyJ9q4lAm6hWqJj2+JwVSvVdg4YLcLbeyJSsfSjW+z3QKaqTPUps8UN4M0gOhsARL7cYRsw/+lXm6RjDjYlPMYcILv3KUvXCW2DodmNmNq5xbrjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787854022; c=relaxed/simple;
	bh=vUxjF7NDXTGO4J/lLRHHBDemilqLVtHwctCaWe2exKY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kTKPK9F8TaMDsH4mTb9Ci7O2VHfL0H/DPuTvUcjEMNoSeDDtoyzLNBIch3Ln2K536CfjslaR+z081RGrQ6aTKoF6ZapPKcO03JYw5NLgMumJJeTmegz89ZV06mlT0YX6meD7EDB2t/LirJ+Q7AAbSJCGLQOAarKfnQhiWNCmYC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 972E7A323C;
	Thu, 27 Aug 2026 19:57:54 +0200 (CEST)
From: Thomas Lamprecht <t.lamprecht@proxmox.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	megaraidlinux.pdl@broadcom.com,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	regressions@lists.linux.dev,
	Lukasz Magiera <me@magik.net>,
	Mira Limbeck <m.limbeck@proxmox.com>,
	Daniel Fernau <mail@danielfernau.com>,
	Mats Topstad <Mats.topstad@intility.no>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame
Date: Thu, 27 Aug 2026 19:24:24 +0200
Message-ID: <20260827175743.734593-1-t.lamprecht@proxmox.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1787853463961

megasas_make_prp_nvme() builds a command's PRP list in cmd->sg_frame, a
DMA pool buffer of instance->max_chain_frame_sz bytes, spending one entry
per NVMe page of the transfer plus one per page of the buffer for the
chain pointer. The loop runs until the transfer is described and never
checks the buffer bound.

max_hw_sectors comes straight from the MDTS the firmware reports for the
drive. On drives with a large MDTS the only thing keeping the list inside
the buffer was the block layer default of 1280 KiB, which needs 320
entries, which fit into a 4 KiB frame as that holds 512. But since commit
9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP") that default is
4 MiB, and such a transfer needs 1025 entries, so the list runs a full
page past the end of the frame:

  sd 1:0:1:0: [sdb] tag#630 page boundary ptr_sgl: 0x00000000ba62d13f
  BUG: unable to handle page fault for address: ff663bcb81e7c000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  RIP: 0010:megasas_build_and_issue_cmd_fusion+0xeaa/0x1870 [megaraid_sas]

If the page after the frame happens to be mapped, the overrun does not
fault but silently corrupts the neighbouring pool entry, which is another
in-flight command's PRP list.

Cap max_hw_sectors at what the chain frame can describe, less one page
for transfers that do not start on a page boundary and so need one entry
more. This is the megaraid_sas counterpart of commit 04631f55afc5 ("scsi:
mpt3sas: Limit NVMe request size to 2 MiB"), but derives the limit from
max_chain_frame_sz rather than hardcoding it.

Cc: stable@vger.kernel.org
Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
Reported-by: Lukasz Magiera <me@magik.net>
Closes: https://lore.kernel.org/all/GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net/
Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
Closes: https://lore.kernel.org/all/d171cc76-bf25-48ce-b482-d344669dfc24@proxmox.com/
Suggested-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/all/yq17bmzd5jr.fsf@ca-mkp.ca.oracle.com/
Signed-off-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
---

Based on current master, but mostly tested on our downstream 7.0-based
kernel.

The derived cap was checked against a replay of the pointer arithmetic in
megasas_make_prp_nvme(), for chain frames of 1024
(MEGASAS_CHAIN_FRAME_SZ_MIN) to 15872 bytes and NVMe page sizes of 4 and
8 KiB, at every 512 byte start offset, with both fully coalesced and
one-entry-per-page scatterlists.

 drivers/scsi/megaraid/megaraid_sas_base.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ecd365d78ae3c14f4682d61063b6f216974daa7d..d83abded2039ba9ffae23d0c78a79e155b32424f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1973,12 +1973,23 @@ megasas_set_nvme_device_properties(struct scsi_device *sdev,
 {
 	struct megasas_instance *instance;
 	u32 mr_nvme_pg_size;
+	u64 max_prp_io;
 
 	instance = (struct megasas_instance *)sdev->host->hostdata;
 	mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
 				MR_DEFAULT_NVME_PAGE_SIZE);
 
-	lim->max_hw_sectors = max_io_size / 512;
+	/*
+	 * megasas_make_prp_nvme() builds the PRP list in cmd->sg_frame without
+	 * bounding it against that buffer, and spends one entry per page of
+	 * it on the chain pointer. Cap the transfer at what the buffer holds,
+	 * less one page for lists that start off a page boundary.
+	 */
+	max_prp_io = (u64)((instance->max_chain_frame_sz / sizeof(u64)) -
+			   (instance->max_chain_frame_sz / mr_nvme_pg_size) - 1) *
+		     mr_nvme_pg_size;
+
+	lim->max_hw_sectors = min_t(u64, max_io_size, max_prp_io) >> SECTOR_SHIFT;
 	lim->virt_boundary_mask = mr_nvme_pg_size - 1;
 }
 

base-commit: 18fbf5151d2c0bfe433c7428eef03cabf5fdb2fa
-- 
2.47.3


