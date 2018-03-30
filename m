From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 07/15] mpt3sas: Added support for SAS Device Discovery Error  Event.
Date: Fri, 30 Mar 2018 15:07:16 +0530
Message-ID: <1522402644-3016-8-git-send-email-chaitra.basappa@broadcom.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

The SAS Device Discovery Error Event is sent to the host when
discovery for a particular device is failed during discovery,
even after maximum retries by the IOC.

In this patch driver unmask the events and displays the details
associated with the event.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  4 ++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 44 ++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7f3b684..3f3f0f0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1029,6 +1029,9 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 	case MPI2_EVENT_ACTIVE_CABLE_EXCEPTION:
 		desc = "Cable Event";
 		break;
+	case MPI2_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
+		desc = "SAS Device Discovery Error";
+		break;
 	case MPI2_EVENT_PCIE_DEVICE_STATUS_CHANGE:
 		desc = "PCIE Device Status Change";
 		break;
@@ -6597,6 +6600,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	_base_unmask_events(ioc, MPI2_EVENT_LOG_ENTRY_ADDED);
 	_base_unmask_events(ioc, MPI2_EVENT_TEMP_THRESHOLD);
 	_base_unmask_events(ioc, MPI2_EVENT_ACTIVE_CABLE_EXCEPTION);
+	_base_unmask_events(ioc, MPI2_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
 	if (ioc->hba_mpi_version_belonged == MPI26_VERSION) {
 		if (ioc->is_gen35_ioc) {
 			_base_unmask_events(ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6b1aaa0..ec86ec5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7531,6 +7531,46 @@ _scsih_sas_discovery_event(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
+ * _scsih_sas_device_discovery_error_event - display SAS device discovery error
+ *						events
+ * @ioc: per adapter object
+ * @fw_event: The fw_event_work object
+ * Context: user.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_sas_device_discovery_error_event(struct MPT3SAS_ADAPTER *ioc,
+	struct fw_event_work *fw_event)
+{
+	Mpi25EventDataSasDeviceDiscoveryError_t *event_data =
+		(Mpi25EventDataSasDeviceDiscoveryError_t *)fw_event->event_data;
+
+	switch (event_data->ReasonCode) {
+
+	case MPI25_EVENT_SAS_DISC_ERR_SMP_FAILED:
+		pr_warn(MPT3SAS_FMT "SMP command sent to the expander"
+			"(handle:0x%04x, sas_address:0x%016llx,"
+			"physical_port:0x%02x) has failed",
+			ioc->name, le16_to_cpu(event_data->DevHandle),
+			(unsigned long long)le64_to_cpu(event_data->SASAddress),
+			event_data->PhysicalPort);
+		break;
+
+	case MPI25_EVENT_SAS_DISC_ERR_SMP_TIMEOUT:
+		pr_warn(MPT3SAS_FMT "SMP command sent to the expander"
+			"(handle:0x%04x, sas_address:0x%016llx,"
+			"physical_port:0x%02x) has timed out",
+			ioc->name, le16_to_cpu(event_data->DevHandle),
+			(unsigned long long)le64_to_cpu(event_data->SASAddress),
+			event_data->PhysicalPort);
+		break;
+	default:
+		break;
+	}
+}
+
+/**
  * _scsih_pcie_enumeration_event - handle enumeration events
  * @ioc: per adapter object
  * @fw_event: The fw_event_work object
@@ -9357,6 +9397,9 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 	case MPI2_EVENT_SAS_DISCOVERY:
 		_scsih_sas_discovery_event(ioc, fw_event);
 		break;
+	case MPI2_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
+		_scsih_sas_device_discovery_error_event(ioc, fw_event);
+		break;
 	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
 		_scsih_sas_broadcast_primitive_event(ioc, fw_event);
 		break;
@@ -9541,6 +9584,7 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
 	case MPI2_EVENT_IR_OPERATION_STATUS:
 	case MPI2_EVENT_SAS_DISCOVERY:
+	case MPI2_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
 	case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
 	case MPI2_EVENT_IR_PHYSICAL_DISK:
 	case MPI2_EVENT_PCIE_ENUMERATION:
-- 
1.8.3.1
