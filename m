From: Rakib Mullick <rakib.mullick@gmail.com>
Subject: [PATCH] scsi: Fix unused variable warning in mpt2sas_scsih.c
Date: Fri, 23 Dec 2011 00:51:53 +0600
Message-ID: <1324579913.19018.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59212 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab1LVSw1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2011 13:52:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

 Fixes the following warning:

drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function =E2=80=98_scsih_sas_b=
roadcast_primative_event=E2=80=99:
drivers/scsi/mpt2sas/mpt2sas_scsih.c:5729:40: warning: unused variable =
=E2=80=98event_data=E2=80=99=20

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sa=
s/mpt2sas_scsih.c
index d570573..0301c5a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5726,7 +5726,6 @@ _scsih_sas_broadcast_primative_event(struct MPT2S=
AS_ADAPTER *ioc,
 	u32 termination_count;
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
-	Mpi2EventDataSasBroadcastPrimitive_t *event_data =3D fw_event->event_=
data;
 	u16 ioc_status;
 	unsigned long flags;
 	int r;
@@ -5735,8 +5734,8 @@ _scsih_sas_broadcast_primative_event(struct MPT2S=
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


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
