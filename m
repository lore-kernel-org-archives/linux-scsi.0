From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH] mpt2sas: fix -Wunused-variable warning
Date: Tue, 14 Feb 2012 15:38:46 +0100
Message-ID: <1329230326-26868-1-git-send-email-danny.kukawka@bisect.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:52394 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756647Ab2BNOiv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2012 09:38:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LSI Corporation <DL-MPTFusionLinux@lsi.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Kashyap Desai <kashyap.desai@lsi.com>, James Bottomley <James.Bottomley@suse.de>, Eric Moore <eric.moore@lsi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

=46ix for:
drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function
  =E2=80=98_scsih_sas_broadcast_primative_event=E2=80=99:
drivers/scsi/mpt2sas/mpt2sas_scsih.c:5766:40: warning: unused
  variable =E2=80=98event_data=E2=80=99 [-Wunused-variable]

remove Mpi2EventDataSasBroadcastPrimitive_t *event_data,
use fw_event->event_data directly instead.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sa=
s/mpt2sas_scsih.c
index 193e33e..067d359 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5763,7 +5763,6 @@ _scsih_sas_broadcast_primative_event(struct MPT2S=
AS_ADAPTER *ioc,
 	u32 termination_count;
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
-	Mpi2EventDataSasBroadcastPrimitive_t *event_data =3D fw_event->event_=
data;
 	u16 ioc_status;
 	unsigned long flags;
 	int r;
@@ -5772,8 +5771,8 @@ _scsih_sas_broadcast_primative_event(struct MPT2S=
AS_ADAPTER *ioc,
=20
 	mutex_lock(&ioc->tm_cmds.mutex);
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter: phy number(%d), "
-	    "width(%d)\n", ioc->name, __func__, event_data->PhyNum,
-	     event_data->PortWidth));
+	    "width(%d)\n", ioc->name, __func__, fw_event->event_data->PhyNum,
+	     fw_event->event_data->PortWidth));
=20
 	_scsih_block_io_all_device(ioc);
=20
--=20
1.7.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
