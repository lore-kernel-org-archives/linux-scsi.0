From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] mpt3sas: set an unlimited max_segment_size for SAS 3.0 HBAs
Date: Mon, 17 Jun 2019 14:19:59 +0200
Message-ID: <20190617122000.22181-8-hch@lst.de>
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
mpt3sas controllers we require an unlimited max_segment_size, as the
virt boundary merging code assumes that.  But we also need to propagate
that to the DMA mapping layer to make dma-debug happy.  The SCSI layer
takes care of that when using the per-host virt_boundary setting, but
given that mpt3sas only wants to set the virt_boundary for actual
NVMe devices we can't rely on that.  The DMA layer maximum segment
is global to the HBA however, so we have to set it explicitly.  This
patch assumes that mpt3sas does not have a segment size limitation,
which seems true based on the SGL format, but will need to be verified.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 1ccfbc7eebe0..c719b807f6d8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10222,6 +10222,7 @@ static struct scsi_host_template mpt3sas_driver_template = {
 	.this_id			= -1,
 	.sg_tablesize			= MPT3SAS_SG_DEPTH,
 	.max_sectors			= 32767,
+	.max_segment_size		= 0xffffffff,
 	.cmd_per_lun			= 7,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
-- 
2.20.1
