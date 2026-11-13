Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794581464;
	b=k4qDa4fiV8Qd+YoEYzZF0u4gKpMR3BKGyPEYEyNXckbeUux41rz2PTupvGACEfRKXJRZ
	 L91I2BkCir2b5nfntzrmEIZrMBa3C9DBAi5DDdr0egLlnhIO9p4oP2yZCeYh2lKMwQLzm
	 uKx959ymV5NPCzFhd6UoTIrdrrDQG6+0PV+Wbd2PB9CA8F1HDAodSKPiOV2Nzmql7JLtf
	 5w3i7sDUp5rAGGGNsSp6WyoBCbjV8YQ0lIEP9twg7RLQrZaOL/v8Ap0zVIzGlV1s5Amg7
	 wLcr5FXXtZrdOsi3e3eOOyt9/kF0t7fhrFJs8LBP01tCF6OrBHrMRln3HPxxHHlLqnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794581464;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=IVK54GaVP6TC5oPwMQmrDyfx/5ND6iqMHDE7/VK7o1c=;
	b=uKWty8IAv2S7tZTtGM7MYv0XGzzyW9E/tSqKvasl6Hzh/AaWf9JkmRvzuNNTYVh9hw8b
	 CciXOqXc+4PbZAOMEi3ZSppMRIEmawzFcDDSRG7jySRNZBfM0/TdsAreZdmwpbvSj0yif
	 oiDbQMTuc3pWrfPTOiMM992Z3AE0ALFOVAh7KMJNOmWT2p7QwcGq1eLKA4UIgTLQapoKn
	 qC+LQQieLrlPMqfCdKoqhRgphsTRcJ5yDEK2oqL9yXG9SYiicwPB8uTYV+QPmqPb38YEw
	 0nbxhkybiknPBmIRZdWSoU49ZoQfQ2fm0UlJaC/ZZ+PGwErQOh0Lg0EAs/hN2zbkcJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iDEKczXb;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59362606A334
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 14:51:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59362606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iDEKczXb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794581462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IVK54GaVP6TC5oPwMQmrDyfx/5ND6iqMHDE7/VK7o1c=;
	b=iDEKczXbZQHpfSV3IwAJ+oPVzmxdSbaDPaSroTZH42GNVJcOb0zi7WUD6Mopfm53hfKYA8
	DmjUQrw9thpg8aGfDZCZfdDenmCnE4FS6v6qD4FxixU+BU5xg9LgvH8Teuv2sxjsFRLZ+n
	8ooPnehQYGuTX9YUGtucFhpJPVbKbo0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-60sgr6khPkWVIzYMAEGyVw-1; Fri,
 13 Nov 2026 09:50:55 -0500
X-MC-Unique: 60sgr6khPkWVIzYMAEGyVw-1
X-Mimecast-MFC-AGG-ID: 60sgr6khPkWVIzYMAEGyVw_1794581453
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 350D21955F43;
	Fri, 13 Nov 2026 14:50:53 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.rmtusma.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D85CB1800545;
	Fri, 13 Nov 2026 14:50:50 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	Mira Limbeck <m.limbeck@proxmox.com>,
	Chandrakanth Patil <chanpati@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Fix off-by-one in NVMe PRP list transfer size limit
Date: Fri, 13 Nov 2026 09:50:46 -0500
Message-ID: <20261113145047.623807-1-loberman@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Commit 04631f55afc5 ("scsi: mpt3sas: Limit NVMe request size to 2 MiB")
capped max_hw_sectors at 2 MiB on the basis that the 4 KiB PRP list
buffer holds 512 entries. That does not account for how
base_make_prp_nvme() fills the buffer:

 - PRP1 is placed in the main message frame and covers the first,
   possibly partial, page of the transfer.
 - When the list reaches the last 8-byte slot of the page, that slot
   is used for a chain pointer, so only 511 data PRPs fit.

A transfer of length L starting at page offset O needs
DIV_ROUND_UP(L - (4096 - O), 4096) list entries. A page aligned 2 MiB
transfer needs 511 and fits. A transfer that starts at a non-zero page
offset, which O_DIRECT permits with 512 byte logical blocks, can need
512: the chain pointer is written to slot 511 and the next PRP to slot
512, one entry past the end of the per-command PCIe SGL buffer. This is
not limited to exactly 2 MiB; under the 2 MiB cap, any transfer of
2 MiB - 3 KiB or more starting at offset 3584 overruns, and likewise
for other offsets.

This was hit with the 2 MiB cap applied, on a Grace (arm64, SMMUv3 in
translated mode) system with a SAS3816 and an NVMe drive, running
xfs_repair from fstests on a KASAN kernel:

  sd 0:2:0:0: [sda] tag#2682 page boundary curr_buff: 0x00000000e986a684
  BUG: KASAN: vmalloc-out-of-bounds in _base_build_sg_scmd_ieee+0x115c/0x1508 [mpt3sas]
  Write of size 8 at addr ffff80008cc8a000 by task xfs_repair/210713
  ...
  The buggy address belongs to a 0-page vmalloc region starting at
  0xffff80008cc89000 allocated at dma_common_pages_remap+0x30/0x88
  ...
  Unable to handle kernel paging request at virtual address ffff80008cc8a000
  Internal error: Oops: 0000000096000047 [#1]  SMP
  pc : _base_build_sg_scmd_ieee+0x380/0x1508 [mpt3sas]
  Call trace:
   _base_build_sg_scmd_ieee+0x380/0x1508 [mpt3sas] (P)
   scsih_qcmd+0xdc8/0x15c8 [mpt3sas]
   scsi_dispatch_cmd+0x1f8/0x578
   scsi_queue_rq+0x528/0x12f0
   ...
   __blkdev_direct_IO+0x760/0xd40
   blkdev_direct_IO+0x338/0x4a0
   blkdev_read_iter+0x1e4/0x370

With the IOMMU remapping the coherent pool page, the overrun faults
on the guard page. Without that remap it silently corrupts 8 bytes of
the adjacent physical page.

Limit the transfer to 511 NVMe pages (2 MiB - 4 KiB), which fits the
PRP list for any starting offset. With this limit the list never
reaches the last slot of the page, so the "page boundary curr_buff"
message, which is only printed on the overrun path, can no longer
trigger.

Fixes: 04631f55afc5 ("scsi: mpt3sas: Limit NVMe request size to 2 MiB")
Cc: stable@vger.kernel.org
Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---

Notes:
    Tested on the system that hit the original oops: Quanta S74G-2U
    (NVIDIA Grace, arm64, SMMUv3 translated), SAS3816 FW 26.00.01.00,
    Samsung MZTL21T9 NVMe at 0:2:0:0, 6.12-based KASAN debug kernel.
    
    Reproducer: read-only O_DIRECT preads of max_sectors_kb into a hugetlb
    buffer at page offsets 512/1024/2048/3584, with max_sectors_kb set to
    max_hw_sectors_kb.
    
    Without this patch (2 MiB cap, max_hw_sectors_kb = 2048):
      2 MiB unaligned preads: system oopses in _base_build_sg_scmd_ieee
      within the first iterations, matching the trace above.
    
    With this patch (max_hw_sectors_kb = 2044):
      - blktrace confirms each read is issued as a single 4088-sector
        request (not split)
      - 10000 unaligned 2044 KiB preads complete
      - 20 loops of fstests generic/001 generic/004 generic/005 (the
        sequence that originally crashed in xfs_repair) pass
      - no "page boundary" messages and no KASAN reports
    
    Also validated with a userspace harness that compiles
    base_make_prp_nvme() verbatim from mpt3sas_base.c, places the PRP
    buffer in front of a PROT_NONE guard page, sweeps every 512-byte length
    from 16.5 KiB to the cap at every 512-byte offset (contiguous and split
    into up to 128 page-aligned segments), and walks each list as the
    device would:
    
      cap 2048 KiB: 292608 cases, 252 overruns, 0 malformed lists
        first overrun: len 2094080 off 3584 nsg 1
      cap 2044 KiB: 292032 cases, 0 overruns, 0 malformed lists
    
    Reproducer and harness available on request.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 085d467..1cb15b5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -57,6 +57,14 @@
 
 #include "mpt3sas_base.h"
 
+/*
+ * Largest NVMe transfer whose PRP list fits in one NVME_PRP_PAGE_SIZE
+ * buffer (last entry reserved for the chain pointer) for any buffer
+ * offset: (4096 / 8 - 1) * 4096 = 2 MiB - 4 KiB.
+ */
+#define MPT3SAS_NVME_MAX_XFER \
+	((NVME_PRP_PAGE_SIZE / NVME_PRP_SIZE - 1) * NVME_PRP_PAGE_SIZE)
+
 #define RAID_CHANNEL 1
 
 #define PCIE_CHANNEL 2
@@ -2741,14 +2749,22 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 		/*
 		 * The HBA firmware passes the NVMe drive's MDTS
 		 * (Maximum Data Transfer Size) up to the driver. However,
-		 * the driver hardcodes a 4K buffer size for the PRP list,
-		 * accommodating at most 512 entries. This strictly limits
-		 * the maximum supported NVMe I/O transfer to 2 MiB.
+		 * the driver hardcodes a 4K buffer size for the PRP list.
+		 * base_make_prp_nvme() reserves the last slot of that page
+		 * for a chain pointer, leaving 511 data PRP entries, and
+		 * PRP1 in the main message frame covers the first, possibly
+		 * partial, page.
+		 *
+		 * A transfer that is not page aligned spans one more page
+		 * than its length implies, so a 2 MiB I/O starting at a
+		 * non-zero page offset needs 512 list entries and overruns
+		 * the PRP buffer by one. Limit transfers to 511 pages, which
+		 * fits the PRP list for any starting offset.
 		 *
 		 * Cap max_hw_sectors to the smaller of the drive's reported
-		 * MDTS or the 2 MiB driver limit to prevent kernel oopses.
+		 * MDTS or the driver limit to prevent kernel oopses.
 		 */
-		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
+		lim->max_hw_sectors = MPT3SAS_NVME_MAX_XFER >> SECTOR_SHIFT;
 		if (pcie_device->nvme_mdts)
 			lim->max_hw_sectors = min(lim->max_hw_sectors,
 					pcie_device->nvme_mdts >> SECTOR_SHIFT);
-- 
2.43.0

