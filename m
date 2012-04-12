From: Lin Ming <ming.m.lin@intel.com>
Subject: [RESEND PATCH 1/2] scsi_lib: use correct DMA device in __scsi_alloc_queue
Date: Thu, 12 Apr 2012 13:50:38 +0800
Message-ID: <1334209839-21978-2-git-send-email-ming.m.lin@intel.com>
References: <1334209839-21978-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7955 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773Ab2DLFu5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Apr 2012 01:50:57 -0400
In-Reply-To: <1334209839-21978-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Currently, __scsi_alloc_queue uses SCSI host's parent device
as DMA device to set segment boundary. But the parent device may not
refer to the DMA device. For example, for ATA disk, SCSI host's parent
device now refers to ATA port.

Since commit d139b9b([SCSI] scsi_lib_dma: fix bug with dma maps on
nested scsi objects), a new field Scsi_Host->dma_dev was introduced
to refer to the real DMA device.

Use ->dma_dev in __scsi_alloc_queue to correctly set segment
boundary.

Bug report: http://marc.info/?l=3Dlinux-ide&m=3D133177818318187&w=3D2

Reported-and-tested-by: J=F6rg Sommer <joerg@alea.gnuu.de>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ead6405..5dfd749 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1638,7 +1638,7 @@ struct request_queue *__scsi_alloc_queue(struct S=
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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
