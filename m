From: Lin Ming <ming.m.lin@intel.com>
Subject: [RESEND PATCH 2/2] libata: Pass correct DMA device to scsi host
Date: Thu, 12 Apr 2012 13:50:39 +0800
Message-ID: <1334209839-21978-3-git-send-email-ming.m.lin@intel.com>
References: <1334209839-21978-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1334209839-21978-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use scsi_add_host_with_dma in ata_scsi_add_hosts to pass in the
correct DMA device(ATA host).

Bug report: http://marc.info/?l=3Dlinux-ide&m=3D133177818318187&w=3D2

Reported-and-tested-by: J=F6rg Sommer <joerg@alea.gnuu.de>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-scsi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1ee00c8..dae08a6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3399,7 +3399,8 @@ int ata_scsi_add_hosts(struct ata_host *host, str=
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
--=20
1.7.2.5

