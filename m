From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: fusion: fix spelling mistakes of "primitive"
Date: Fri, 17 Feb 2017 20:16:26 +0000
Message-ID: <20170217201626.21075-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49929 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932673AbdBQUQ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2017 15:16:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistakes of "primitive" and
also re-join a literal string that spans 2 lines to
squelch a checkpatch warning.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/message/fusion/lsi/mpi_cnfg.h | 2 +-
 drivers/message/fusion/mptbase.c      | 7 +++----
 drivers/message/fusion/mptsas.c       | 8 ++++----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index d9bcfba..a6a7198 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -2003,7 +2003,7 @@ typedef struct _CONFIG_PAGE_FC_PORT_6
     U64                     LinkFailureCount;           /* 50h */
     U64                     LossOfSyncCount;            /* 58h */
     U64                     LossOfSignalCount;          /* 60h */
-    U64                     PrimativeSeqErrCount;       /* 68h */
+    U64                     PrimitiveSeqErrCount;       /* 68h */
     U64                     InvalidTxWordCount;         /* 70h */
     U64                     InvalidCrcCount;            /* 78h */
     U64                     FcpInitiatorIoCount;        /* 80h */
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 1e73064..b804c47 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -7601,11 +7601,10 @@ mpt_display_event_info(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply)
 		u8 phy_num = (u8)(evData0);
 		u8 port_num = (u8)(evData0 >> 8);
 		u8 port_width = (u8)(evData0 >> 16);
-		u8 primative = (u8)(evData0 >> 24);
+		u8 primitive = (u8)(evData0 >> 24);
 		snprintf(evStr, EVENT_DESCR_STR_SZ,
-		    "SAS Broadcase Primative: phy=%d port=%d "
-		    "width=%d primative=0x%02x",
-		    phy_num, port_num, port_width, primative);
+		    "SAS Broadcase Primitive: phy=%d port=%d width=%d primitive=0x%02x",
+		    phy_num, port_num, port_width, primitive);
 		break;
 	}
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index f6308ad..95133b1 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -129,7 +129,7 @@ static void mptsas_expander_delete(MPT_ADAPTER *ioc,
 static void mptsas_send_expander_event(struct fw_event_work *fw_event);
 static void mptsas_not_responding_devices(MPT_ADAPTER *ioc);
 static void mptsas_scan_sas_topology(MPT_ADAPTER *ioc);
-static void mptsas_broadcast_primative_work(struct fw_event_work *fw_event);
+static void mptsas_broadcast_primitive_work(struct fw_event_work *fw_event);
 static void mptsas_handle_queue_full_event(struct fw_event_work *fw_event);
 static void mptsas_volume_delete(MPT_ADAPTER *ioc, u8 id);
 void	mptsas_schedule_target_reset(void *ioc);
@@ -1666,7 +1666,7 @@ mptsas_firmware_event_work(struct work_struct *work)
 		mptsas_free_fw_event(ioc, fw_event);
 		break;
 	case MPI_EVENT_SAS_BROADCAST_PRIMITIVE:
-		mptsas_broadcast_primative_work(fw_event);
+		mptsas_broadcast_primitive_work(fw_event);
 		break;
 	case MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE:
 		mptsas_send_expander_event(fw_event);
@@ -4831,13 +4831,13 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 channel, u8 id, u64 lun,
 }
 
 /**
- *	mptsas_broadcast_primative_work - Handle broadcast primitives
+ *	mptsas_broadcast_primitive_work - Handle broadcast primitives
  *	@work: work queue payload containing info describing the event
  *
  *	this will be handled in workqueue context.
  */
 static void
-mptsas_broadcast_primative_work(struct fw_event_work *fw_event)
+mptsas_broadcast_primitive_work(struct fw_event_work *fw_event)
 {
 	MPT_ADAPTER *ioc = fw_event->ioc;
 	MPT_FRAME_HDR	*mf;
-- 
2.10.2
