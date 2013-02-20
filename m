From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH linux/linux-next] mpt2sas: _scsih_sas_broadcast_primitive_event: Quiet unused variable warning
Date: Wed, 20 Feb 2013 11:48:27 -0700
Message-ID: <1361386107-49136-1-git-send-email-tim.gardner@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If CONFIG_SCSI_MPT2SAS_LOGGING is undefined, then these warnings are emitted:

drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function '_scsih_sas_broadcast_primitive_event':
drivers/scsi/mpt2sas/mpt2sas_scsih.c:5810:40: warning: unused variable 'event_data' [-Wunused-variable]

Add __maybe_unused to the definition of event_data.

Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: support@lsi.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: DL-MPTFusionLinux@lsi.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c6bdc92..416f907 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5807,7 +5807,8 @@ _scsih_sas_broadcast_primitive_event(struct MPT2SAS_ADAPTER *ioc,
 	u32 termination_count;
 	u32 query_count;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
-	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
+	Mpi2EventDataSasBroadcastPrimitive_t *event_data __maybe_unused =
+		fw_event->event_data;
 	u16 ioc_status;
 	unsigned long flags;
 	int r;
-- 
1.7.9.5
