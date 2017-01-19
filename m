From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 1/4] mpt3sas: Added print to notify cable running at a degraded speed.
Date: Thu, 19 Jan 2017 21:19:07 +0530
Message-ID: <1484840950-13656-2-git-send-email-chaitra.basappa@broadcom.com>
References: <1484840950-13656-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484840950-13656-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Driver processes the event MPI26_EVENT_ACTIVE_CABLE_DEGRADED
when a cable is present and is running at a degraded speed
(below the SAS3 12 Gb/s rate). Prints added
to inform the user that the cable is not running at
optimal speed.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
	       Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  |    2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   18 +++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
index 8bae305..af4be40 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
@@ -624,6 +624,8 @@ typedef struct _MPI26_EVENT_DATA_ACTIVE_CABLE_EXCEPT {
 
 /* defines for ReasonCode field */
 #define MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER     (0x00)
+#define MPI26_EVENT_ACTIVE_CABLE_PRESENT                (0x01)
+#define MPI26_EVENT_ACTIVE_CABLE_DEGRADED               (0x02)
 
 /*Hard Reset Received Event data */
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 75f3fce..5ffbfb1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8028,15 +8028,23 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	case MPI2_EVENT_ACTIVE_CABLE_EXCEPTION:
 		ActiveCableEventData =
 		    (Mpi26EventDataActiveCableExcept_t *) mpi_reply->EventData;
-		if (ActiveCableEventData->ReasonCode ==
-				MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER) {
+		switch (ActiveCableEventData->ReasonCode) {
+		case MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER:
 			pr_info(MPT3SAS_FMT "Currently an active cable with ReceptacleID %d",
 			    ioc->name, ActiveCableEventData->ReceptacleID);
-			pr_info("cannot be powered and devices connected to this active cable");
-			pr_info("will not be seen. This active cable");
-			pr_info("requires %d mW of power",
+			pr_info(" cannot be powered and devices connected to");
+			pr_info(" this active cable will not be seen. This");
+			pr_info(" cable requires %d mW of power",
 			    ActiveCableEventData->ActiveCablePowerRequirement);
+			break;
+
+		case MPI26_EVENT_ACTIVE_CABLE_DEGRADED:
+			pr_info(MPT3SAS_FMT "Currently a cable with ReceptacleID %d",
+			    ioc->name, ActiveCableEventData->ReceptacleID);
+			pr_info(" is not running at optimal speed(12 Gb/s)\n");
+			break;
 		}
+
 		break;
 
 	default: /* ignore the rest */
-- 
1.7.1
