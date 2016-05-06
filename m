From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 2/6] mpt3sas: Handle active cable exception event
Date: Fri,  6 May 2016 14:29:27 +0530
Message-ID: <1462525171-6877-3-git-send-email-chaitra.basappa@broadcom.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

In-order to handle this 'MPI2_EVENT_ACTIVE_CABLE_EXCEPTION' event,
driver need to follow below steps,
1. Unmask the 'MPI2_EVENT_ACTIVE_CABLE_EXCEPTION' event,
so that FW can notify this event to host driver.
2. After receiving this event, add this event to AEN event queue,
for notifying this event to applications.
3. Then Print below message in kernel logs if the event data's reason
code is zero,
"Currently an active cable with ReceptacleID <ID_Value> cannot be powered
and devices connected to this active cable will not be seen. This active
cable requires <PowerValue_in_mW> of power"

This event is only for Intruder/Cutlass HBAs.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  5 +++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8c44b9c..4e9142f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -654,6 +654,9 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 	case MPI2_EVENT_TEMP_THRESHOLD:
 		desc = "Temperature Threshold";
 		break;
+	case MPI2_EVENT_ACTIVE_CABLE_EXCEPTION:
+		desc = "Active cable exception";
+		break;
 	}
 
 	if (!desc)
@@ -5424,6 +5427,8 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	_base_unmask_events(ioc, MPI2_EVENT_IR_OPERATION_STATUS);
 	_base_unmask_events(ioc, MPI2_EVENT_LOG_ENTRY_ADDED);
 	_base_unmask_events(ioc, MPI2_EVENT_TEMP_THRESHOLD);
+	if (ioc->hba_mpi_version_belonged == MPI26_VERSION)
+		_base_unmask_events(ioc, MPI2_EVENT_ACTIVE_CABLE_EXCEPTION);
 
 	r = _base_make_ioc_operational(ioc, CAN_SLEEP);
 	if (r)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e0e4920..221f8bf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7850,6 +7850,7 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	Mpi2EventNotificationReply_t *mpi_reply;
 	u16 event;
 	u16 sz;
+	Mpi26EventDataActiveCableExcept_t *ActiveCableEventData;
 
 	/* events turned off due to host reset or driver unloading */
 	if (ioc->remove_host || ioc->pci_error_recovery)
@@ -7962,6 +7963,18 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 			(Mpi2EventDataTemperature_t *)
 			mpi_reply->EventData);
 		break;
+	case MPI2_EVENT_ACTIVE_CABLE_EXCEPTION:
+		ActiveCableEventData =
+		    (Mpi26EventDataActiveCableExcept_t *) mpi_reply->EventData;
+		if (ActiveCableEventData->ReasonCode ==
+				MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER)
+			pr_info(MPT3SAS_FMT "Currently an active cable with ReceptacleID %d",
+			    ioc->name, ActiveCableEventData->ReceptacleID);
+			pr_info("cannot be powered and devices connected to this active cable");
+			pr_info("will not be seen. This active cable");
+			pr_info("requires %d mW of power",
+			    ActiveCableEventData->ActiveCablePowerRequirement);
+		break;
 
 	default: /* ignore the rest */
 		return 1;
-- 
1.8.3.1
