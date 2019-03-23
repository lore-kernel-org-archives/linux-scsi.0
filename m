From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.1-rc1
Date: Sat, 23 Mar 2019 09:16:53 -0700
Message-ID: <1553357813.3120.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Six fixes to four drivers and two core fixes.  One core fix simply
corrects a missed destroy_rcu_head() but the other is hopefully the end
of an ongoing effort to make suspend/resume play nicely with scsi
quiesce.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (2):
      scsi: core: Avoid that a kernel warning appears during system resume
      scsi: core: Also call destroy_rcu_head() for passthrough requests

Himanshu Madhani (1):
      scsi: qla2xxx: Fix NULL pointer crash due to stale CPUID

Luo Jiaxing (1):
      scsi: hisi_sas: Add softreset in hisi_sas_I_T_nexus_reset()

Maurizio Lombardi (1):
      scsi: iscsi: flush running unbind operations when removing a session

Quinn Tran (1):
      scsi: qla2xxx: Fix FC-AL connection target discovery

Tyrel Datwyler (2):
      scsi: ibmvscsi: Fix empty event pool access during host removal
      scsi: ibmvscsi: Protect ibmvscsi_head from concurrent modificaiton

And the diffstat:

 drivers/scsi/hisi_sas/hisi_sas_main.c |  6 ++++++
 drivers/scsi/ibmvscsi/ibmvscsi.c      | 23 +++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_init.c       |  7 +++++++
 drivers/scsi/qla2xxx/qla_os.c         |  2 +-
 drivers/scsi/scsi_lib.c               | 15 ++++++++++++---
 drivers/scsi/scsi_transport_iscsi.c   |  2 ++
 6 files changed, 47 insertions(+), 8 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 3c3cf89f713f..14bac4966c87 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1801,6 +1801,12 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 	}
 	hisi_sas_dereg_device(hisi_hba, device);
 
+	if (dev_is_sata(device)) {
+		rc = hisi_sas_softreset_ata_disk(device);
+		if (rc)
+			return TMF_RESP_FUNC_FAILED;
+	}
+
 	rc = hisi_sas_debug_I_T_nexus_reset(device);
 
 	if ((rc == TMF_RESP_FUNC_COMPLETE) || (rc == -ENODEV))
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 1135e74646e2..8cec5230fe31 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -96,6 +96,7 @@ static int client_reserve = 1;
 static char partition_name[96] = "UNKNOWN";
 static unsigned int partition_number = -1;
 static LIST_HEAD(ibmvscsi_head);
+static DEFINE_SPINLOCK(ibmvscsi_driver_lock);
 
 static struct scsi_transport_template *ibmvscsi_transport_template;
 
@@ -2270,7 +2271,9 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	}
 
 	dev_set_drvdata(&vdev->dev, hostdata);
+	spin_lock(&ibmvscsi_driver_lock);
 	list_add_tail(&hostdata->host_list, &ibmvscsi_head);
+	spin_unlock(&ibmvscsi_driver_lock);
 	return 0;
 
       add_srp_port_failed:
@@ -2292,15 +2295,27 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 static int ibmvscsi_remove(struct vio_dev *vdev)
 {
 	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
-	list_del(&hostdata->host_list);
-	unmap_persist_bufs(hostdata);
+	unsigned long flags;
+
+	srp_remove_host(hostdata->host);
+	scsi_remove_host(hostdata->host);
+
+	purge_requests(hostdata, DID_ERROR);
+
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	release_event_pool(&hostdata->pool, hostdata);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+
 	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
 					max_events);
 
 	kthread_stop(hostdata->work_thread);
-	srp_remove_host(hostdata->host);
-	scsi_remove_host(hostdata->host);
+	unmap_persist_bufs(hostdata);
+
+	spin_lock(&ibmvscsi_driver_lock);
+	list_del(&hostdata->host_list);
+	spin_unlock(&ibmvscsi_driver_lock);
+
 	scsi_host_put(hostdata->host);
 
 	return 0;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 420045155ba0..0c700b140ce7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4991,6 +4991,13 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 		if ((domain & 0xf0) == 0xf0)
 			continue;
 
+		/* Bypass if not same domain and area of adapter. */
+		if (area && domain && ((area != vha->d_id.b.area) ||
+		    (domain != vha->d_id.b.domain)) &&
+		    (ha->current_topology == ISP_CFG_NL))
+			continue;
+
+
 		/* Bypass invalid local loop ID. */
 		if (loop_id > LAST_LOCAL_LOOP_ID)
 			continue;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 677f82fdf56f..91f576d743fe 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1517,7 +1517,7 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		goto eh_reset_failed;
 	}
 	err = 2;
-	if (do_reset(fcport, cmd->device->lun, blk_mq_rq_cpu(cmd->request) + 1)
+	if (do_reset(fcport, cmd->device->lun, 1)
 		!= QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800c,
 		    "do_reset failed for cmd=%p.\n", cmd);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 20189675677a..601b9f1de267 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -585,9 +585,16 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	if (!blk_rq_is_scsi(req)) {
 		WARN_ON_ONCE(!(cmd->flags & SCMD_INITIALIZED));
 		cmd->flags &= ~SCMD_INITIALIZED;
-		destroy_rcu_head(&cmd->rcu);
 	}
 
+	/*
+	 * Calling rcu_barrier() is not necessary here because the
+	 * SCSI error handler guarantees that the function called by
+	 * call_rcu() has been called before scsi_end_request() is
+	 * called.
+	 */
+	destroy_rcu_head(&cmd->rcu);
+
 	/*
 	 * In the MQ case the command gets freed by __blk_mq_end_request,
 	 * so we have to do all cleanup that depends on it earlier.
@@ -2541,8 +2548,10 @@ void scsi_device_resume(struct scsi_device *sdev)
 	 * device deleted during suspend)
 	 */
 	mutex_lock(&sdev->state_mutex);
-	sdev->quiesced_by = NULL;
-	blk_clear_pm_only(sdev->request_queue);
+	if (sdev->quiesced_by) {
+		sdev->quiesced_by = NULL;
+		blk_clear_pm_only(sdev->request_queue);
+	}
 	if (sdev->sdev_state == SDEV_QUIESCE)
 		scsi_device_set_state(sdev, SDEV_RUNNING);
 	mutex_unlock(&sdev->state_mutex);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0508831d6fb9..0a82e93566dc 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2200,6 +2200,8 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
 	/* flush running scans then delete devices */
 	flush_work(&session->scan_work);
+	/* flush running unbind operations */
+	flush_work(&session->unbind_work);
 	__iscsi_unbind_session(&session->unbind_work);
 
 	/* hw iscsi may not have removed all connections from session */
