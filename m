From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 08/17] mpt2sas: Added sysfs support for trace buffer
Date: Thu, 17 Jun 2010 13:43:17 +0530
Message-ID: <20100617081317.GI28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48787 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759464Ab0FQIsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:48:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com

Added support so the diag ring buffer can be pulled via sysfs
Added three new shost attributes: host_trace_buffer,
host_trace_buffer_enable, and host_trace_buffer_size.  The
host_trace_buffer_enable attribute is used to either post or release
the trace buffers.   The host_trace_buffer_size attribute contains
the size of the trace buffer. The host_trace_buffer atttribute contains
a maximum 4KB window of the buffer. In order to read the entire host buffer,
you will need to write the offset to  host_trace_buffer prior to reading
it. release the host buffer, then write the entire host buffer contents to
a file.
In addition to this enhancement, we moved the automatic posting of host buffers
at driver load time to be called prior to port_enable, instead of after.
That way discovery is available in the host buffer.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 88befc7..93c0623 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3529,8 +3529,12 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	if (sleep_flag == CAN_SLEEP)
 		_base_static_config_pages(ioc);
 
-	if (ioc->wait_for_port_enable_to_complete && disable_discovery > 0)
-		return r;
+	if (ioc->wait_for_port_enable_to_complete) {
+		if (diag_buffer_enable != 0)
+			mpt2sas_enable_diag_buffer(ioc, diag_buffer_enable);
+		if (disable_discovery > 0)
+			return r;
+	}
 
 	r = _base_send_port_enable(ioc, sleep_flag);
 	if (r)
@@ -3679,8 +3683,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 		goto out_free_resources;
 
 	mpt2sas_base_start_watchdog(ioc);
-	if (diag_buffer_enable != 0)
-		mpt2sas_enable_diag_buffer(ioc, diag_buffer_enable);
 	return 0;
 
  out_free_resources:
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index ad277f3..d201c20 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -750,6 +750,8 @@ struct MPT2SAS_ADAPTER {
 	Mpi2ManufacturingPage10_t manu_pg10;
 	u32		product_specific[MPI2_DIAG_BUF_TYPE_COUNT][23];
 	u32		diagnostic_flags[MPI2_DIAG_BUF_TYPE_COUNT];
+	u32		ring_buffer_offset;
+	u32		ring_buffer_sz;
 };
 
 typedef u8 (*MPT_CALLBACK)(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 25c866e..371f063 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -2603,6 +2603,195 @@ _ctl_ioc_reset_count_show(struct device *cdev, struct device_attribute *attr,
 static DEVICE_ATTR(ioc_reset_count, S_IRUGO,
     _ctl_ioc_reset_count_show, NULL);
 
+struct DIAG_BUFFER_START {
+	u32 Size;
+	u32 DiagVersion;
+	u8 BufferType;
+	u8 Reserved[3];
+	u32 Reserved1;
+	u32 Reserved2;
+	u32 Reserved3;
+};
+/**
+ * _ctl_host_trace_buffer_size_show - host buffer size (trace only)
+ * @cdev - pointer to embedded class device
+ * @buf - the buffer returned
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
+static ssize_t
+_ctl_host_trace_buffer_size_show(struct device *cdev,
+    struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
+	u32 size = 0;
+	struct DIAG_BUFFER_START *request_data;
+
+	if (!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) {
+		printk(MPT2SAS_ERR_FMT "%s: host_trace_buffer is not "
+		    "registered\n", ioc->name, __func__);
+		return 0;
+	}
+
+	if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
+	    MPT2_DIAG_BUFFER_IS_REGISTERED) == 0) {
+		printk(MPT2SAS_ERR_FMT "%s: host_trace_buffer is not "
+		    "registered\n", ioc->name, __func__);
+		return 0;
+	}
+
+	request_data = (struct DIAG_BUFFER_START *)
+	    ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE];
+	if ((le32_to_cpu(request_data->DiagVersion) == 0x00000000 ||
+	    le32_to_cpu(request_data->DiagVersion) == 0x01000000) &&
+	    le32_to_cpu(request_data->Reserved3) == 0x4742444c)
+		size = le32_to_cpu(request_data->Size);
+
+	ioc->ring_buffer_sz = size;
+	return snprintf(buf, PAGE_SIZE, "%d\n", size);
+}
+static DEVICE_ATTR(host_trace_buffer_size, S_IRUGO,
+	 _ctl_host_trace_buffer_size_show, NULL);
+
+/**
+ * _ctl_host_trace_buffer_show - firmware ring buffer (trace only)
+ * @cdev - pointer to embedded class device
+ * @buf - the buffer returned
+ *
+ * A sysfs 'read/write' shost attribute.
+ *
+ * You will only be able to read 4k bytes of ring buffer at a time.
+ * In order to read beyond 4k bytes, you will have to write out the
+ * offset to the same attribute, it will move the pointer.
+ */
+static ssize_t
+_ctl_host_trace_buffer_show(struct device *cdev, struct device_attribute *attr,
+     char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
+	void *request_data;
+	u32 size;
+
+	if (!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) {
+		printk(MPT2SAS_ERR_FMT "%s: host_trace_buffer is not "
+		    "registered\n", ioc->name, __func__);
+		return 0;
+	}
+
+	if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
+	    MPT2_DIAG_BUFFER_IS_REGISTERED) == 0) {
+		printk(MPT2SAS_ERR_FMT "%s: host_trace_buffer is not "
+		    "registered\n", ioc->name, __func__);
+		return 0;
+	}
+
+	if (ioc->ring_buffer_offset > ioc->ring_buffer_sz)
+		return 0;
+
+	size = ioc->ring_buffer_sz - ioc->ring_buffer_offset;
+	size = (size > PAGE_SIZE) ? PAGE_SIZE : size;
+	request_data = ioc->diag_buffer[0] + ioc->ring_buffer_offset;
+	memcpy(buf, request_data, size);
+	return size;
+}
+
+static ssize_t
+_ctl_host_trace_buffer_store(struct device *cdev, struct device_attribute *attr,
+    const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
+	int val = 0;
+
+	if (sscanf(buf, "%d", &val) != 1)
+		return -EINVAL;
+
+	ioc->ring_buffer_offset = val;
+	return strlen(buf);
+}
+static DEVICE_ATTR(host_trace_buffer, S_IRUGO | S_IWUSR,
+    _ctl_host_trace_buffer_show, _ctl_host_trace_buffer_store);
+
+/*****************************************/
+
+/**
+ * _ctl_host_trace_buffer_enable_show - firmware ring buffer (trace only)
+ * @cdev - pointer to embedded class device
+ * @buf - the buffer returned
+ *
+ * A sysfs 'read/write' shost attribute.
+ *
+ * This is a mechnism to post/release host_trace_buffers
+ */
+static ssize_t
+_ctl_host_trace_buffer_enable_show(struct device *cdev,
+    struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
+
+	if ((!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) ||
+	   ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
+	    MPT2_DIAG_BUFFER_IS_REGISTERED) == 0))
+		return snprintf(buf, PAGE_SIZE, "off\n");
+	else if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
+	    MPT2_DIAG_BUFFER_IS_RELEASED))
+		return snprintf(buf, PAGE_SIZE, "release\n");
+	else
+		return snprintf(buf, PAGE_SIZE, "post\n");
+}
+
+static ssize_t
+_ctl_host_trace_buffer_enable_store(struct device *cdev,
+    struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
+	char str[10] = "";
+	struct mpt2_diag_register diag_register;
+	u8 issue_reset = 0;
+
+	if (sscanf(buf, "%s", str) != 1)
+		return -EINVAL;
+
+	if (!strcmp(str, "post")) {
+		/* exit out if host buffers are already posted */
+		if ((ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) &&
+		    (ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
+		    MPT2_DIAG_BUFFER_IS_REGISTERED) &&
+		    ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
+		    MPT2_DIAG_BUFFER_IS_RELEASED) == 0))
+			goto out;
+		memset(&diag_register, 0, sizeof(struct mpt2_diag_register));
+		printk(MPT2SAS_INFO_FMT "posting host trace buffers\n",
+		    ioc->name);
+		diag_register.buffer_type = MPI2_DIAG_BUF_TYPE_TRACE;
+		diag_register.requested_buffer_size = (1024 * 1024);
+		diag_register.unique_id = 0x7075900;
+		ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] = 0;
+		_ctl_diag_register_2(ioc,  &diag_register);
+	} else if (!strcmp(str, "release")) {
+		/* exit out if host buffers are already released */
+		if (!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE])
+			goto out;
+		if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
+		    MPT2_DIAG_BUFFER_IS_REGISTERED) == 0)
+			goto out;
+		if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
+		    MPT2_DIAG_BUFFER_IS_RELEASED))
+			goto out;
+		printk(MPT2SAS_INFO_FMT "releasing host trace buffer\n",
+		    ioc->name);
+		_ctl_send_release(ioc, MPI2_DIAG_BUF_TYPE_TRACE, &issue_reset);
+	}
+
+ out:
+	return strlen(buf);
+}
+static DEVICE_ATTR(host_trace_buffer_enable, S_IRUGO | S_IWUSR,
+    _ctl_host_trace_buffer_enable_show, _ctl_host_trace_buffer_enable_store);
 
 struct device_attribute *mpt2sas_host_attrs[] = {
 	&dev_attr_version_fw,
@@ -2621,6 +2810,9 @@ struct device_attribute *mpt2sas_host_attrs[] = {
 	&dev_attr_fw_queue_depth,
 	&dev_attr_host_sas_address,
 	&dev_attr_ioc_reset_count,
+	&dev_attr_host_trace_buffer_size,
+	&dev_attr_host_trace_buffer,
+	&dev_attr_host_trace_buffer_enable,
 	NULL,
 };
 
