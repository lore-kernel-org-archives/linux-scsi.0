From: Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH] lpfc: fix compiler warning in lpfc_bus_reset_handler
Date: Wed, 20 Aug 2008 17:35:09 +0300
Message-ID: <1219242909-9068-1-git-send-email-bhalevy@panasas.com>
References: <1213498358.10002.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:39143 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYHTOyI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2008 10:54:08 -0400
In-Reply-To: <1213498358.10002.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>

gcc 4.3.0 prints this warning:

drivers/scsi/lpfc/lpfc_scsi.c: In function =E2=80=98lpfc_bus_reset_hand=
ler=E2=80=99:
drivers/scsi/lpfc/lpfc_scsi.c:1245:\
 warning: =E2=80=98status=E2=80=99 may be used uninitialized in this fu=
nction

It seems like the warning is bogus.  However, this patch makes
sure status is always initialized before used.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scs=
i.c
index 1bcebbd..9eda9b2 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1278,8 +1278,9 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 						     ndlp->rport->dd_data);
 			if (status !=3D TIMEOUT_ERROR)
 				lpfc_release_scsi_buf(phba, lpfc_cmd);
-		}
-		if (!lpfc_cmd || status !=3D SUCCESS) {
+		} else
+			status =3D FAILED;
+		if (status !=3D SUCCESS) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 					 "0700 Bus Reset on target %d failed\n",
 					 i);
--=20
1.6.0

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
