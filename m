From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 13/25] mpt3sas: Ported the providing sysfs attribute to report Backup Rail Monitor Status
Date: Wed, 11 Nov 2015 17:30:29 +0530
Message-ID: <1447243241-10912-14-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

A new sysfs shost attribute called "BMR_status" is implemented to
report Backup Rail Monitor status.

This attribute is located in the path
        /sys/class/scsi_host/host#/BMR_status

when reading this adapter attribute, then driver will output the state
of GPIO[24]. It returns "0" if BMR is healthy and it returns "1" for
failure.

if it returns an empty string then it means that there was an error while
obtaining the BMR status. Then check dmesg for what error has occurred.

This sysfs shost attribute is mainly for WarpDrive controllers.

This changes are ported form below mpt2sas driver patch

'commit 6c265660c26267754a02063642ae042d469b4ef9
("mpt2sas: Provide sysfs attribute to report Backup Rail Monitor Status")

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  4 ++
 drivers/scsi/mpt3sas/mpt3sas_config.c | 38 ++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c    | 74 +++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 397f8a5..3b4aaa1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1224,6 +1224,10 @@ int mpt3sas_config_get_sas_iounit_pg0(struct MPT3SAS_ADAPTER *ioc,
 	u16 sz);
 int mpt3sas_config_get_iounit_pg1(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2IOUnitPage1_t *config_page);
+#ifdef SCSI_MPT2SAS
+int mpt3sas_config_get_iounit_pg3(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage3_t *config_page, u16 sz);
+#endif
 int mpt3sas_config_set_iounit_pg1(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2IOUnitPage1_t *config_page);
 int mpt3sas_config_get_iounit_pg8(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 53eb701..2bbb034 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -865,6 +865,44 @@ mpt3sas_config_set_iounit_pg1(struct MPT3SAS_ADAPTER *ioc,
 	return r;
 }
 
+#ifdef SCSI_MPT2SAS
+/**
+ * mpt3sas_config_get_iounit_pg3 - obtain iounit page 3
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * @sz: size of buffer passed in config_page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_get_iounit_pg3(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage3_t *config_page, u16 sz)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_IO_UNIT;
+	mpi_request.Header.PageNumber = 3;
+	mpi_request.Header.PageVersion = MPI2_IOUNITPAGE3_PAGEVERSION;
+	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page, sz);
+ out:
+	return r;
+}
+#endif
+
 /**
  * mpt3sas_config_get_iounit_pg8 - obtain iounit page 8
  * @ioc: per adapter object
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 3f22754..1c62db8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2720,6 +2720,77 @@ _ctl_ioc_reply_queue_count_show(struct device *cdev,
 static DEVICE_ATTR(reply_queue_count, S_IRUGO, _ctl_ioc_reply_queue_count_show,
 	NULL);
 
+#ifdef SCSI_MPT2SAS
+/**
+ * _ctl_BRM_status_show - Backup Rail Monitor Status
+ * @cdev - pointer to embedded class device
+ * @buf - the buffer returned
+ *
+ * This is number of reply queues
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
+static ssize_t
+_ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
+	char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	Mpi2IOUnitPage3_t *io_unit_pg3 = NULL;
+	Mpi2ConfigReply_t mpi_reply;
+	u16 backup_rail_monitor_status = 0;
+	u16 ioc_status;
+	int sz;
+	ssize_t rc = 0;
+
+	if (!ioc->is_warpdrive) {
+		pr_err(MPT3SAS_FMT "%s: BRM attribute is only for"
+		    " warpdrive\n", ioc->name, __func__);
+		goto out;
+	}
+
+	/* allocate upto GPIOVal 36 entries */
+	sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
+	io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
+	if (!io_unit_pg3) {
+		pr_err(MPT3SAS_FMT "%s: failed allocating memory "
+		    "for iounit_pg3: (%d) bytes\n", ioc->name, __func__, sz);
+		goto out;
+	}
+
+	if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz) !=
+	    0) {
+		pr_err(MPT3SAS_FMT
+		    "%s: failed reading iounit_pg3\n", ioc->name,
+		    __func__);
+		goto out;
+	}
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		pr_err(MPT3SAS_FMT "%s: iounit_pg3 failed with "
+		    "ioc_status(0x%04x)\n", ioc->name, __func__, ioc_status);
+		goto out;
+	}
+
+	if (io_unit_pg3->GPIOCount < 25) {
+		pr_err(MPT3SAS_FMT "%s: iounit_pg3->GPIOCount less than "
+		     "25 entries, detected (%d) entries\n", ioc->name, __func__,
+		    io_unit_pg3->GPIOCount);
+		goto out;
+	}
+
+	/* BRM status is in bit zero of GPIOVal[24] */
+	backup_rail_monitor_status = le16_to_cpu(io_unit_pg3->GPIOVal[24]);
+	rc = snprintf(buf, PAGE_SIZE, "%d\n", (backup_rail_monitor_status & 1));
+
+ out:
+	kfree(io_unit_pg3);
+	return rc;
+}
+static DEVICE_ATTR(BRM_status, S_IRUGO, _ctl_BRM_status_show, NULL);
+#endif
+
 struct DIAG_BUFFER_START {
 	__le32	Size;
 	__le32	DiagVersion;
@@ -3172,6 +3243,9 @@ struct device_attribute *mpt3sas_host_attrs[] = {
 	&dev_attr_diag_trigger_event,
 	&dev_attr_diag_trigger_scsi,
 	&dev_attr_diag_trigger_mpi,
+#ifdef SCSI_MPT2SAS
+	&dev_attr_BRM_status,
+#endif
 	NULL,
 };
 
-- 
2.0.2
