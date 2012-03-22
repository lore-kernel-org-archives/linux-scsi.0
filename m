From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH] [SCSI] scsi_lib: use correct DMA device in
 __scsi_alloc_queue
Date: Thu, 22 Mar 2012 13:52:30 +0800
Message-ID: <1332395550.3793.58.camel@minggr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: =?ISO-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, __scsi_alloc_queue uses SCSI host's parent device
as DMA device to set segment boundary. But the parent device may not
refer to the DMA device. For example, for ATA disk, SCSI host's parent
device now refers to ATA port.

Since commit d139b9b([SCSI] scsi_lib_dma: fix bug with dma maps on
nested scsi objects), a new field Scsi_Host->dma_device was introduced
to refer to the real DMA device.

Use ->dma_device in __scsi_alloc_queue to correctly set segment
boundary.

And use scsi_add_host_with_dma in ata_scsi_add_hosts to pass in the
correct DMA device.

Bug report: http://marc.info/?l=3Dlinux-ide&m=3D133177818318187&w=3D2

Reported-and-tested-by: J=C3=B6rg Sommer <joerg@alea.gnuu.de>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-scsi.c |    3 ++-
 drivers/scsi/scsi_lib.c   |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7ae1e77..e47f889 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3398,7 +3398,8 @@ int ata_scsi_add_hosts(struct ata_host *host, str=
uct scsi_host_template *sht)
 		 */
 		shost->max_host_blocked =3D 1;
=20
-		rc =3D scsi_add_host(ap->scsi_host, &ap->tdev);
+		rc =3D scsi_add_host_with_dma(ap->scsi_host,
+						&ap->tdev, ap->host->dev);
 		if (rc)
 			goto err_add;
 	}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f85cfa6..486088b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1642,7 +1642,7 @@ struct request_queue *__scsi_alloc_queue(struct S=
csi_Host *shost,
 					 request_fn_proc *request_fn)
 {
 	struct request_queue *q;
-	struct device *dev =3D shost->shost_gendev.parent;
+	struct device *dev =3D shost->dma_dev;
=20
 	q =3D blk_init_queue(request_fn, NULL);
 	if (!q)
--=20
1.7.2.5



