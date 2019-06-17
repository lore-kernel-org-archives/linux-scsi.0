From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] megaraid_sas: set an unlimited max_segment_size
Date: Mon, 17 Jun 2019 14:20:00 +0200
Message-ID: <20190617122000.22181-9-hch@lst.de>
References: <20190617122000.22181-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617122000.22181-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When using a virt_boundary_mask, as done for NVMe devices attached to
megaraid_sas controllers we require an unlimited max_segment_size, as
the virt boundary merging code assumes that.  But we also need to
propagate that to the DMA mapping layer to make dma-debug happy.  The
SCSI layer takes care of that when using the per-host virt_boundary
setting, but given that megaraid_sas only wants to set the virt_boundary
for actual NVMe devices we can't rely on that.  The DMA layer maximum
segment is global to the HBA however, so we have to set it explicitly.
This patch assumes that megaraid_sas does not have a segment size
limitation, which seems true based on the SGL format, but will need
to be verified.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3dd1df472dc6..59f709dbbab9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3207,6 +3207,7 @@ static struct scsi_host_template megasas_template = {
 	.shost_attrs = megaraid_host_attrs,
 	.bios_param = megasas_bios_param,
 	.change_queue_depth = scsi_change_queue_depth,
+	.max_segment_size = 0xffffffff,
 	.no_write_same = 1,
 };
 
-- 
2.20.1
