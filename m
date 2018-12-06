From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.20-rc5
Date: Thu, 06 Dec 2018 09:38:20 +0900
Message-ID: <1544056700.3414.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Four obvious bug fixes.  The vmw_pscsi one is so old that it's amazing
no-one noticed before now.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Cathy Avery (1):
      scsi: vmw_pscsi: Rearrange code to avoid multiple calls to free_irq during unload

Dexuan Cui (1):
      scsi: storvsc: Fix a race in sub-channel creation that can cause panic

Fred Herard (1):
      scsi: libiscsi: Fix NULL pointer dereference in iscsi_eh_session_reset

Martin Wilck (1):
      scsi: lpfc: fix block guard enablement on SLI3 adapters

And the diffstat:

 drivers/scsi/libiscsi.c       |  4 +--
 drivers/scsi/lpfc/lpfc_init.c |  6 ++++-
 drivers/scsi/lpfc/lpfc_sli.c  |  1 -
 drivers/scsi/storvsc_drv.c    | 61 +++++++++++++++++++++----------------------
 drivers/scsi/vmw_pvscsi.c     |  4 +--
 5 files changed, 39 insertions(+), 37 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 93c66ebad907..f78d2e5c1471 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2416,8 +2416,8 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 failed:
 		ISCSI_DBG_EH(session,
 			     "failing session reset: Could not log back into "
-			     "%s, %s [age %d]\n", session->targetname,
-			     conn->persistent_address, session->age);
+			     "%s [age %d]\n", session->targetname,
+			     session->age);
 		spin_unlock_bh(&session->frwd_lock);
 		mutex_unlock(&session->eh_mutex);
 		return FAILED;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 20fa6785a0e2..68d62d55a3a5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -167,7 +167,11 @@ lpfc_config_port_prep(struct lpfc_hba *phba)
 		       sizeof(phba->wwpn));
 	}
 
-	phba->sli3_options = 0x0;
+	/*
+	 * Clear all option bits except LPFC_SLI3_BG_ENABLED,
+	 * which was already set in lpfc_get_cfgparam()
+	 */
+	phba->sli3_options &= (uint32_t)LPFC_SLI3_BG_ENABLED;
 
 	/* Setup and issue mailbox READ REV command */
 	lpfc_read_rev(phba, pmb);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 783a1540cfbe..b9e5cd79931a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4965,7 +4965,6 @@ lpfc_sli_config_port(struct lpfc_hba *phba, int sli_mode)
 		phba->sli3_options &= ~(LPFC_SLI3_NPIV_ENABLED |
 					LPFC_SLI3_HBQ_ENABLED |
 					LPFC_SLI3_CRP_ENABLED |
-					LPFC_SLI3_BG_ENABLED |
 					LPFC_SLI3_DSS_ENABLED);
 		if (rc != MBX_SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index f03dc03a42c3..8f88348ebe42 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -446,7 +446,6 @@ struct storvsc_device {
 
 	bool	 destroy;
 	bool	 drain_notify;
-	bool	 open_sub_channel;
 	atomic_t num_outstanding_req;
 	struct Scsi_Host *host;
 
@@ -636,33 +635,38 @@ static inline struct storvsc_device *get_in_stor_device(
 static void handle_sc_creation(struct vmbus_channel *new_sc)
 {
 	struct hv_device *device = new_sc->primary_channel->device_obj;
+	struct device *dev = &device->device;
 	struct storvsc_device *stor_device;
 	struct vmstorage_channel_properties props;
+	int ret;
 
 	stor_device = get_out_stor_device(device);
 	if (!stor_device)
 		return;
 
-	if (stor_device->open_sub_channel == false)
-		return;
-
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
-	vmbus_open(new_sc,
-		   storvsc_ringbuffer_size,
-		   storvsc_ringbuffer_size,
-		   (void *)&props,
-		   sizeof(struct vmstorage_channel_properties),
-		   storvsc_on_channel_callback, new_sc);
+	ret = vmbus_open(new_sc,
+			 storvsc_ringbuffer_size,
+			 storvsc_ringbuffer_size,
+			 (void *)&props,
+			 sizeof(struct vmstorage_channel_properties),
+			 storvsc_on_channel_callback, new_sc);
 
-	if (new_sc->state == CHANNEL_OPENED_STATE) {
-		stor_device->stor_chns[new_sc->target_cpu] = new_sc;
-		cpumask_set_cpu(new_sc->target_cpu, &stor_device->alloced_cpus);
+	/* In case vmbus_open() fails, we don't use the sub-channel. */
+	if (ret != 0) {
+		dev_err(dev, "Failed to open sub-channel: err=%d\n", ret);
+		return;
 	}
+
+	/* Add the sub-channel to the array of available channels. */
+	stor_device->stor_chns[new_sc->target_cpu] = new_sc;
+	cpumask_set_cpu(new_sc->target_cpu, &stor_device->alloced_cpus);
 }
 
 static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 {
+	struct device *dev = &device->device;
 	struct storvsc_device *stor_device;
 	int num_cpus = num_online_cpus();
 	int num_sc;
@@ -679,21 +683,11 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 	request = &stor_device->init_request;
 	vstor_packet = &request->vstor_packet;
 
-	stor_device->open_sub_channel = true;
 	/*
 	 * Establish a handler for dealing with subchannels.
 	 */
 	vmbus_set_sc_create_callback(device->channel, handle_sc_creation);
 
-	/*
-	 * Check to see if sub-channels have already been created. This
-	 * can happen when this driver is re-loaded after unloading.
-	 */
-
-	if (vmbus_are_subchannels_present(device->channel))
-		return;
-
-	stor_device->open_sub_channel = false;
 	/*
 	 * Request the host to create sub-channels.
 	 */
@@ -710,23 +704,29 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
-	if (ret != 0)
+	if (ret != 0) {
+		dev_err(dev, "Failed to create sub-channel: err=%d\n", ret);
 		return;
+	}
 
 	t = wait_for_completion_timeout(&request->wait_event, 10*HZ);
-	if (t == 0)
+	if (t == 0) {
+		dev_err(dev, "Failed to create sub-channel: timed out\n");
 		return;
+	}
 
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
+	    vstor_packet->status != 0) {
+		dev_err(dev, "Failed to create sub-channel: op=%d, sts=%d\n",
+			vstor_packet->operation, vstor_packet->status);
 		return;
+	}
 
 	/*
-	 * Now that we created the sub-channels, invoke the check; this
-	 * may trigger the callback.
+	 * We need to do nothing here, because vmbus_process_offer()
+	 * invokes channel->sc_creation_callback, which will open and use
+	 * the sub-channel(s).
 	 */
-	stor_device->open_sub_channel = true;
-	vmbus_are_subchannels_present(device->channel);
 }
 
 static void cache_wwn(struct storvsc_device *stor_device,
@@ -1794,7 +1794,6 @@ static int storvsc_probe(struct hv_device *device,
 	}
 
 	stor_device->destroy = false;
-	stor_device->open_sub_channel = false;
 	init_waitqueue_head(&stor_device->waiting_to_drain);
 	stor_device->device = device;
 	stor_device->host = host;
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 6e491023fdd8..0d6b2a88fc8e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1202,8 +1202,6 @@ static void pvscsi_shutdown_intr(struct pvscsi_adapter *adapter)
 
 static void pvscsi_release_resources(struct pvscsi_adapter *adapter)
 {
-	pvscsi_shutdown_intr(adapter);
-
 	if (adapter->workqueue)
 		destroy_workqueue(adapter->workqueue);
 
@@ -1534,6 +1532,7 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 out_reset_adapter:
 	ll_adapter_reset(adapter);
 out_release_resources:
+	pvscsi_shutdown_intr(adapter);
 	pvscsi_release_resources(adapter);
 	scsi_host_put(host);
 out_disable_device:
@@ -1542,6 +1541,7 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return error;
 
 out_release_resources_and_disable:
+	pvscsi_shutdown_intr(adapter);
 	pvscsi_release_resources(adapter);
 	goto out_disable_device;
 }
