From: Adam Manzanares <adam.manzanares@hgst.com>
Subject: [PATCH] mpt3sas: Recognize and act on iopriority info
Date: Tue, 29 Nov 2016 13:13:59 -0800
Message-ID: <1480454039-2525-1-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0064.outbound.protection.outlook.com ([104.47.37.64]:18084
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757117AbcK2VrL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Nov 2016 16:47:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Adam Manzanares <adam.manzanares@wdc.com>

From: Adam Manzanares <adam.manzanares@wdc.com>

This patch adds support for request iopriority handling in the
mpt3sas layer. This works only when a ATA device is behind the
SATL. The ATA device also has to indicate that it supports
command priorities in the identify information that is pulled from
the SATL.

This patch depends on block: Add iocontext priority to request

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  6 +++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 43 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 31 ++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 3e71bc1..354cdc7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -402,6 +402,9 @@ struct MPT3SAS_DEVICE {
 	u8	block;
 	u8	tlr_snoop_check;
 	u8	ignore_delay_remove;
+	/* Iopriority Command Handling */
+	u8	ncq_prio_enable;
+
 };
 
 #define MPT3_CMD_NOT_USED	0x8000	/* free */
@@ -1449,4 +1452,7 @@ mpt3sas_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
 	u16 smid);
 
+/* NCQ Prio Handling Check */
+bool scsih_ncq_prio_supp(struct scsi_device *sdev);
+
 #endif /* MPT3SAS_BASE_H_INCLUDED */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 26cdc12..3ad8339 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3290,8 +3290,6 @@ static DEVICE_ATTR(diag_trigger_mpi, S_IRUGO | S_IWUSR,
 
 /*********** diagnostic trigger suppport *** END ****************************/
 
-
-
 /*****************************************/
 
 struct device_attribute *mpt3sas_host_attrs[] = {
@@ -3367,9 +3365,50 @@ _ctl_device_handle_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(sas_device_handle, S_IRUGO, _ctl_device_handle_show, NULL);
 
+/**
+ * _ctl_device_ncq_io_prio_show - send prioritized io commands to device
+ * @dev - pointer to embedded device
+ * @buf - the buffer returned
+ *
+ * A sysfs 'read/write' sdev attribute, only works with SATA
+ */
+static ssize_t
+_ctl_device_ncq_prio_enable_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct MPT3SAS_DEVICE *sas_device_priv_data = sdev->hostdata;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			sas_device_priv_data->ncq_prio_enable);
+}
+
+static ssize_t
+_ctl_device_ncq_prio_enable_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct MPT3SAS_DEVICE *sas_device_priv_data = sdev->hostdata;
+	bool ncq_prio_enable = 0;
+
+	if (kstrtobool(buf, &ncq_prio_enable))
+		return -EINVAL;
+
+	if (!scsih_ncq_prio_supp(sdev))
+		return -EINVAL;
+
+	sas_device_priv_data->ncq_prio_enable = ncq_prio_enable;
+	return strlen(buf);
+}
+static DEVICE_ATTR(sas_ncq_prio_enable, S_IRUGO | S_IWUSR,
+		   _ctl_device_ncq_prio_enable_show,
+		   _ctl_device_ncq_prio_enable_store);
+
 struct device_attribute *mpt3sas_dev_attrs[] = {
 	&dev_attr_sas_address,
 	&dev_attr_sas_device_handle,
+	&dev_attr_sas_ncq_prio_enable,
 	NULL,
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 209a969..e2117cc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4030,6 +4030,8 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct _raid_device *raid_device;
+	struct request *rq = scmd->request;
+	int class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	Mpi2SCSIIORequest_t *mpi_request;
 	u32 mpi_control;
 	u16 smid;
@@ -4085,6 +4087,10 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	/* set tags */
 	mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
+	/* NCQ Prio supported, make sure control indicated high priority */
+	if (class == IOPRIO_CLASS_RT &&
+	    sas_device_priv_data->ncq_prio_enable)
+		mpi_control |= 1 << MPI2_SCSIIO_CONTROL_CMDPRI_SHIFT;
 
 	/* Make sure Device is not raid volume.
 	 * We do not expose raid functionality to upper layer for warpdrive.
@@ -9031,6 +9037,31 @@ scsih_pci_mmio_enabled(struct pci_dev *pdev)
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
+/**
+ * scsih__ncq_prio_supp - Check for NCQ command priority support
+ * @sdev: scsi device struct
+ *
+ * This is called when a user indicates they would like to enable
+ * ncq command priorities. This works only on SATA devices.
+ */
+bool scsih_ncq_prio_supp(struct scsi_device *sdev)
+{
+	unsigned char *buf;
+	bool ncq_prio_supp = false;
+
+	if (!scsi_device_supports_vpd(sdev))
+		return ncq_prio_supp;
+
+	buf = kmalloc(SCSI_VPD_PG_LEN, GFP_KERNEL);
+	if (!buf)
+		return ncq_prio_supp;
+
+	if (!scsi_get_vpd_page(sdev, 0x89, buf, SCSI_VPD_PG_LEN))
+		ncq_prio_supp = (buf[213] >> 4) & 1;
+
+	kfree(buf);
+	return ncq_prio_supp;
+}
 /*
  * The pci device ids are defined in mpi/mpi2_cnfg.h.
  */
-- 
2.7.4

