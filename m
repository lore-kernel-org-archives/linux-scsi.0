From: Lin Ming <mlin@ss.pku.edu.cn>
Subject: [PATCH 1/2] [SCSI] scsi_lib: use correct DMA device in  __scsi_alloc_queue
Date: Fri, 23 Mar 2012 00:32:05 +0800
Message-ID: <1332433926-9132-2-git-send-email-mlin@ss.pku.edu.cn>
References: <1332433926-9132-1-git-send-email-mlin@ss.pku.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [124.207.24.138] ([124.207.24.138]:33159 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758656Ab2CVQlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2012 12:41:17 -0400
In-Reply-To: <1332433926-9132-1-git-send-email-mlin@ss.pku.edu.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: =?UTF-8?q?J=F6rg=20Sommer?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

=46rom: Lin Ming <ming.m.lin@intel.com>

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
index a33b2b6..fa2636e2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1637,7 +1637,7 @@ struct request_queue *__scsi_alloc_queue(struct S=
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
