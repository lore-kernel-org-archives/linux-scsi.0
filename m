From: Lin Ming <mlin@ss.pku.edu.cn>
Subject: [PATCH 2/2] libata: Pass correct DMA device to scsi host
Date: Fri, 23 Mar 2012 00:32:06 +0800
Message-ID: <1332433926-9132-3-git-send-email-mlin@ss.pku.edu.cn>
References: <1332433926-9132-1-git-send-email-mlin@ss.pku.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [124.207.24.138] ([124.207.24.138]:33164 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab2CVQlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Mar 2012 12:41:17 -0400
In-Reply-To: <1332433926-9132-1-git-send-email-mlin@ss.pku.edu.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: =?UTF-8?q?J=F6rg=20Sommer?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

=46rom: Lin Ming <ming.m.lin@intel.com>

Use scsi_add_host_with_dma in ata_scsi_add_hosts to pass in the
correct DMA device(ATA host).

Bug report: http://marc.info/?l=3Dlinux-ide&m=3D133177818318187&w=3D2

Reported-and-tested-by: J=F6rg Sommer <joerg@alea.gnuu.de>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-scsi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 508a60b..321797f 100644
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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
