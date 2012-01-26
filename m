From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] Staging: hv: Applied all the patches already in the staging queue
Date: Thu, 26 Jan 2012 09:38:34 -0800
Message-ID: <1327599515-12679-1-git-send-email-kys@microsoft.com>
References: <1327599460-12593-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1327599460-12593-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

This patch gets the storage driver to the same level as in the staging tree.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c | 1301 ++++++++++++++++++-------------------
 1 files changed, 633 insertions(+), 668 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index ddbdec8..695ffc3 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -42,56 +42,23 @@
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_dbg.h>
 
+/*
+ * All wire protocol details (storage protocol between the guest and the host)
+ * are consolidated here.
+ *
+ * Begin protocol definitions.
+ */
 
-#define STORVSC_MIN_BUF_NR				64
-#define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
-static int storvsc_ringbuffer_size = STORVSC_RING_BUFFER_SIZE;
-
-module_param(storvsc_ringbuffer_size, int, S_IRUGO);
-MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
-
-/* to alert the user that structure sizes may be mismatched even though the */
-/* protocol versions match. */
-
-
-#define REVISION_STRING(REVISION_) #REVISION_
-#define FILL_VMSTOR_REVISION(RESULT_LVALUE_)				\
-	do {								\
-		char *revision_string					\
-			= REVISION_STRING($Rev : 6 $) + 6;		\
-		RESULT_LVALUE_ = 0;					\
-		while (*revision_string >= '0'				\
-			&& *revision_string <= '9') {			\
-			RESULT_LVALUE_ *= 10;				\
-			RESULT_LVALUE_ += *revision_string - '0';	\
-			revision_string++;				\
-		}							\
-	} while (0)
-
-/* Major/minor macros.  Minor version is in LSB, meaning that earlier flat */
-/* version numbers will be interpreted as "0.x" (i.e., 1 becomes 0.1). */
-#define VMSTOR_PROTOCOL_MAJOR(VERSION_)		(((VERSION_) >> 8) & 0xff)
-#define VMSTOR_PROTOCOL_MINOR(VERSION_)		(((VERSION_))      & 0xff)
-#define VMSTOR_PROTOCOL_VERSION(MAJOR_, MINOR_)	((((MAJOR_) & 0xff) << 8) | \
-						 (((MINOR_) & 0xff)))
-#define VMSTOR_INVALID_PROTOCOL_VERSION		(-1)
-
-/* Version history: */
-/* V1 Beta                    0.1 */
-/* V1 RC < 2008/1/31          1.0 */
-/* V1 RC > 2008/1/31          2.0 */
-#define VMSTOR_PROTOCOL_VERSION_CURRENT VMSTOR_PROTOCOL_VERSION(4, 2)
-
-
-
+/*
+ * Version history:
+ * V1 Beta: 0.1
+ * V1 RC < 2008/1/31: 1.0
+ * V1 RC > 2008/1/31:  2.0
+ * Win7: 4.2
+ */
 
-/*  This will get replaced with the max transfer length that is possible on */
-/*  the host adapter. */
-/*  The max transfer length will be published when we offer a vmbus channel. */
-#define MAX_TRANSFER_LENGTH	0x40000
-#define DEFAULT_PACKET_SIZE (sizeof(struct vmdata_gpa_direct) +	\
-			sizeof(struct vstor_packet) +		\
-			sizesizeof(u64) * (MAX_TRANSFER_LENGTH / PAGE_SIZE)))
+#define VMSTOR_CURRENT_MAJOR  4
+#define VMSTOR_CURRENT_MINOR  2
 
 
 /*  Packet structure describing virtual storage requests. */
@@ -115,35 +82,31 @@ enum vstor_packet_operation {
  * this remains the same across the write regardless of 32/64 bit
  * note: it's patterned off the SCSI_PASS_THROUGH structure
  */
-#define CDB16GENERIC_LENGTH			0x10
-
-#ifndef SENSE_BUFFER_SIZE
-#define SENSE_BUFFER_SIZE			0x12
-#endif
-
-#define MAX_DATA_BUF_LEN_WITH_PADDING		0x14
+#define STORVSC_MAX_CMD_LEN			0x10
+#define STORVSC_SENSE_BUFFER_SIZE		0x12
+#define STORVSC_MAX_BUF_LEN_WITH_PADDING	0x14
 
 struct vmscsi_request {
-	unsigned short length;
-	unsigned char srb_status;
-	unsigned char scsi_status;
+	u16 length;
+	u8 srb_status;
+	u8 scsi_status;
 
-	unsigned char port_number;
-	unsigned char path_id;
-	unsigned char target_id;
-	unsigned char lun;
+	u8  port_number;
+	u8  path_id;
+	u8  target_id;
+	u8  lun;
 
-	unsigned char cdb_length;
-	unsigned char sense_info_length;
-	unsigned char data_in;
-	unsigned char reserved;
+	u8  cdb_length;
+	u8  sense_info_length;
+	u8  data_in;
+	u8  reserved;
 
-	unsigned int data_transfer_length;
+	u32 data_transfer_length;
 
 	union {
-		unsigned char cdb[CDB16GENERIC_LENGTH];
-		unsigned char sense_data[SENSE_BUFFER_SIZE];
-		unsigned char reserved_array[MAX_DATA_BUF_LEN_WITH_PADDING];
+		u8 cdb[STORVSC_MAX_CMD_LEN];
+		u8 sense_data[STORVSC_SENSE_BUFFER_SIZE];
+		u8 reserved_array[STORVSC_MAX_BUF_LEN_WITH_PADDING];
 	};
 } __attribute((packed));
 
@@ -153,32 +116,36 @@ struct vmscsi_request {
  * properties of the channel.
  */
 struct vmstorage_channel_properties {
-	unsigned short protocol_version;
-	unsigned char path_id;
-	unsigned char target_id;
+	u16 protocol_version;
+	u8  path_id;
+	u8 target_id;
 
 	/* Note: port number is only really known on the client side */
-	unsigned int port_number;
-	unsigned int flags;
-	unsigned int max_transfer_bytes;
+	u32  port_number;
+	u32  flags;
+	u32   max_transfer_bytes;
 
-	/*  This id is unique for each channel and will correspond with */
-	/*  vendor specific data in the inquirydata */
-	unsigned long long unique_id;
+	/*
+	 * This id is unique for each channel and will correspond with
+	 * vendor specific data in the inquiry data.
+	 */
+
+	u64  unique_id;
 } __packed;
 
 /*  This structure is sent during the storage protocol negotiations. */
 struct vmstorage_protocol_version {
 	/* Major (MSW) and minor (LSW) version numbers. */
-	unsigned short major_minor;
+	u16 major_minor;
 
 	/*
 	 * Revision number is auto-incremented whenever this file is changed
 	 * (See FILL_VMSTOR_REVISION macro above).  Mismatch does not
 	 * definitely indicate incompatibility--but it does indicate mismatched
 	 * builds.
+	 * This is only used on the windows side. Just set it to 0.
 	 */
-	unsigned short revision;
+	u16 revision;
 } __packed;
 
 /* Channel Property Flags */
@@ -190,10 +157,10 @@ struct vstor_packet {
 	enum vstor_packet_operation operation;
 
 	/*  Flags - see below for values */
-	unsigned int flags;
+	u32 flags;
 
 	/* Status of the request returned from the server side. */
-	unsigned int status;
+	u32 status;
 
 	/* Data payload area */
 	union {
@@ -211,18 +178,47 @@ struct vstor_packet {
 	};
 } __packed;
 
-/* Packet flags */
 /*
+ * Packet Flags:
+ *
  * This flag indicates that the server should send back a completion for this
  * packet.
  */
+
 #define REQUEST_COMPLETION_FLAG	0x1
 
-/*  This is the set of flags that the vsc can set in any packets it sends */
-#define VSC_LEGAL_FLAGS		(REQUEST_COMPLETION_FLAG)
+/* Matches Windows-end */
+enum storvsc_request_type {
+	WRITE_TYPE = 0,
+	READ_TYPE,
+	UNKNOWN_TYPE,
+};
+
+/*
+ * SRB status codes and masks; a subset of the codes used here.
+ */
+
+#define SRB_STATUS_AUTOSENSE_VALID	0x80
+#define SRB_STATUS_INVALID_LUN	0x20
+#define SRB_STATUS_SUCCESS	0x01
+#define SRB_STATUS_ERROR	0x04
+
+/*
+ * This is the end of Protocol specific defines.
+ */
+
+
+/*
+ * We setup a mempool to allocate request structures for this driver
+ * on a per-lun basis. The following define specifies the number of
+ * elements in the pool.
+ */
 
+#define STORVSC_MIN_BUF_NR				64
+static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
 
-/* Defines */
+module_param(storvsc_ringbuffer_size, int, S_IRUGO);
+MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
 #define STORVSC_MAX_IO_REQUESTS				128
 
@@ -235,27 +231,23 @@ struct vstor_packet {
 #define STORVSC_MAX_LUNS_PER_TARGET			64
 #define STORVSC_MAX_TARGETS				1
 #define STORVSC_MAX_CHANNELS				1
-#define STORVSC_MAX_CMD_LEN				16
 
-/* Matches Windows-end */
-enum storvsc_request_type {
-	WRITE_TYPE,
-	READ_TYPE,
-	UNKNOWN_TYPE,
-};
 
 
-struct hv_storvsc_request {
+struct storvsc_cmd_request {
+	struct list_head entry;
+	struct scsi_cmnd *cmd;
+
+	unsigned int bounce_sgl_count;
+	struct scatterlist *bounce_sgl;
+
 	struct hv_device *device;
 
 	/* Synchronize the request/response if needed */
 	struct completion wait_event;
 
 	unsigned char *sense_buffer;
-	void *context;
-	void (*on_io_completion)(struct hv_storvsc_request *request);
 	struct hv_multipage_buffer data_buffer;
-
 	struct vstor_packet vstor_packet;
 };
 
@@ -281,8 +273,8 @@ struct storvsc_device {
 	unsigned char target_id;
 
 	/* Used for vsc/vsp channel reset process */
-	struct hv_storvsc_request init_request;
-	struct hv_storvsc_request reset_request;
+	struct storvsc_cmd_request init_request;
+	struct storvsc_cmd_request reset_request;
 };
 
 struct stor_mem_pools {
@@ -297,16 +289,6 @@ struct hv_host_device {
 	unsigned char target;
 };
 
-struct storvsc_cmd_request {
-	struct list_head entry;
-	struct scsi_cmnd *cmd;
-
-	unsigned int bounce_sgl_count;
-	struct scatterlist *bounce_sgl;
-
-	struct hv_storvsc_request request;
-};
-
 struct storvsc_scan_work {
 	struct work_struct work;
 	struct Scsi_Host *host;
@@ -352,6 +334,34 @@ done:
 	kfree(wrk);
 }
 
+/*
+ * Major/minor macros.  Minor version is in LSB, meaning that earlier flat
+ * version numbers will be interpreted as "0.x" (i.e., 1 becomes 0.1).
+ */
+
+static inline u16 storvsc_get_version(u8 major, u8 minor)
+{
+	u16 version;
+
+	version = ((major << 8) | minor);
+	return version;
+}
+
+/*
+ * We can get incoming messages from the host that are not in response to
+ * messages that we have sent out. An example of this would be messages
+ * received by the guest to notify dynamic addition/removal of LUNs. To
+ * deal with potential race conditions where the driver may be in the
+ * midst of being unloaded when we might receive an unsolicited message
+ * from the host, we have implemented a mechanism to gurantee sequential
+ * consistency:
+ *
+ * 1) Once the device is marked as being destroyed, we will fail all
+ *    outgoing messages.
+ * 2) We permit incoming messages when the device is being destroyed,
+ *    only to properly account for messages already sent out.
+ */
+
 static inline struct storvsc_device *get_out_stor_device(
 					struct hv_device *device)
 {
@@ -398,116 +408,342 @@ get_in_err:
 
 }
 
-static int storvsc_channel_init(struct hv_device *device)
+static void destroy_bounce_buffer(struct scatterlist *sgl,
+				  unsigned int sg_count)
 {
-	struct storvsc_device *stor_device;
-	struct hv_storvsc_request *request;
-	struct vstor_packet *vstor_packet;
-	int ret, t;
+	int i;
+	struct page *page_buf;
 
-	stor_device = get_out_stor_device(device);
-	if (!stor_device)
-		return -ENODEV;
+	for (i = 0; i < sg_count; i++) {
+		page_buf = sg_page((&sgl[i]));
+		if (page_buf != NULL)
+			__free_page(page_buf);
+	}
 
-	request = &stor_device->init_request;
-	vstor_packet = &request->vstor_packet;
+	kfree(sgl);
+}
 
-	/*
-	 * Now, initiate the vsc/vsp initialization protocol on the open
-	 * channel
-	 */
-	memset(request, 0, sizeof(struct hv_storvsc_request));
-	init_completion(&request->wait_event);
-	vstor_packet->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count)
+{
+	int i;
 
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0)
-		goto cleanup;
+	/* No need to check */
+	if (sg_count < 2)
+		return -1;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0) {
-		ret = -ETIMEDOUT;
-		goto cleanup;
+	/* We have at least 2 sg entries */
+	for (i = 0; i < sg_count; i++) {
+		if (i == 0) {
+			/* make sure 1st one does not have hole */
+			if (sgl[i].offset + sgl[i].length != PAGE_SIZE)
+				return i;
+		} else if (i == sg_count - 1) {
+			/* make sure last one does not have hole */
+			if (sgl[i].offset != 0)
+				return i;
+		} else {
+			/* make sure no hole in the middle */
+			if (sgl[i].length != PAGE_SIZE || sgl[i].offset != 0)
+				return i;
+		}
 	}
+	return -1;
+}
 
-	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
-		goto cleanup;
-
-
-	/* reuse the packet for version range supported */
-	memset(vstor_packet, 0, sizeof(struct vstor_packet));
-	vstor_packet->operation = VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
+						unsigned int sg_count,
+						unsigned int len,
+						int write)
+{
+	int i;
+	int num_pages;
+	struct scatterlist *bounce_sgl;
+	struct page *page_buf;
+	unsigned int buf_len = ((write == WRITE_TYPE) ? 0 : PAGE_SIZE);
 
-	vstor_packet->version.major_minor = VMSTOR_PROTOCOL_VERSION_CURRENT;
-	FILL_VMSTOR_REVISION(vstor_packet->version.revision);
+	num_pages = ALIGN(len, PAGE_SIZE) >> PAGE_SHIFT;
 
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0)
-		goto cleanup;
+	bounce_sgl = kcalloc(num_pages, sizeof(struct scatterlist), GFP_ATOMIC);
+	if (!bounce_sgl)
+		return NULL;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0) {
-		ret = -ETIMEDOUT;
-		goto cleanup;
+	for (i = 0; i < num_pages; i++) {
+		page_buf = alloc_page(GFP_ATOMIC);
+		if (!page_buf)
+			goto cleanup;
+		sg_set_page(&bounce_sgl[i], page_buf, buf_len, 0);
 	}
 
-	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
-		goto cleanup;
-
+	return bounce_sgl;
 
-	memset(vstor_packet, 0, sizeof(struct vstor_packet));
-	vstor_packet->operation = VSTOR_OPERATION_QUERY_PROPERTIES;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
-	vstor_packet->storage_channel_properties.port_number =
-					stor_device->port_number;
+cleanup:
+	destroy_bounce_buffer(bounce_sgl, num_pages);
+	return NULL;
+}
 
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+/* Assume the original sgl has enough room */
+static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
+					    struct scatterlist *bounce_sgl,
+					    unsigned int orig_sgl_count,
+					    unsigned int bounce_sgl_count)
+{
+	int i;
+	int j = 0;
+	unsigned long src, dest;
+	unsigned int srclen, destlen, copylen;
+	unsigned int total_copied = 0;
+	unsigned long bounce_addr = 0;
+	unsigned long dest_addr = 0;
+	unsigned long flags;
 
-	if (ret != 0)
-		goto cleanup;
+	local_irq_save(flags);
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
-	if (t == 0) {
-		ret = -ETIMEDOUT;
-		goto cleanup;
-	}
+	for (i = 0; i < orig_sgl_count; i++) {
+		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
+					KM_IRQ0) + orig_sgl[i].offset;
+		dest = dest_addr;
+		destlen = orig_sgl[i].length;
 
-	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
-		goto cleanup;
+		if (bounce_addr == 0)
+			bounce_addr =
+			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])),
+							KM_IRQ0);
 
-	stor_device->path_id = vstor_packet->storage_channel_properties.path_id;
-	stor_device->target_id
-		= vstor_packet->storage_channel_properties.target_id;
+		while (destlen) {
+			src = bounce_addr + bounce_sgl[j].offset;
+			srclen = bounce_sgl[j].length - bounce_sgl[j].offset;
 
-	memset(vstor_packet, 0, sizeof(struct vstor_packet));
-	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
-	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+			copylen = min(srclen, destlen);
+			memcpy((void *)dest, (void *)src, copylen);
 
-	ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+			total_copied += copylen;
+			bounce_sgl[j].offset += copylen;
+			destlen -= copylen;
+			dest += copylen;
 
-	if (ret != 0)
-		goto cleanup;
+			if (bounce_sgl[j].offset == bounce_sgl[j].length) {
+				/* full */
+				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				j++;
+
+				/*
+				 * It is possible that the number of elements
+				 * in the bounce buffer may not be equal to
+				 * the number of elements in the original
+				 * scatter list. Handle this correctly.
+				 */
+
+				if (j == bounce_sgl_count) {
+					/*
+					 * We are done; cleanup and return.
+					 */
+					kunmap_atomic((void *)(dest_addr -
+							orig_sgl[i].offset),
+							KM_IRQ0);
+					local_irq_restore(flags);
+					return total_copied;
+				}
+
+				/* if we need to use another bounce buffer */
+				if (destlen || i != orig_sgl_count - 1)
+					bounce_addr =
+					(unsigned long)kmap_atomic(
+					sg_page((&bounce_sgl[j])), KM_IRQ0);
+			} else if (destlen == 0 && i == orig_sgl_count - 1) {
+				/* unmap the last bounce that is < PAGE_SIZE */
+				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+			}
+		}
+
+		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset),
+			      KM_IRQ0);
+	}
+
+	local_irq_restore(flags);
+
+	return total_copied;
+}
+
+/* Assume the bounce_sgl has enough room ie using the create_bounce_buffer() */
+static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
+					  struct scatterlist *bounce_sgl,
+					  unsigned int orig_sgl_count)
+{
+	int i;
+	int j = 0;
+	unsigned long src, dest;
+	unsigned int srclen, destlen, copylen;
+	unsigned int total_copied = 0;
+	unsigned long bounce_addr = 0;
+	unsigned long src_addr = 0;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	for (i = 0; i < orig_sgl_count; i++) {
+		src_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
+				KM_IRQ0) + orig_sgl[i].offset;
+		src = src_addr;
+		srclen = orig_sgl[i].length;
+
+		if (bounce_addr == 0)
+			bounce_addr =
+			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])),
+						KM_IRQ0);
+
+		while (srclen) {
+			/* assume bounce offset always == 0 */
+			dest = bounce_addr + bounce_sgl[j].length;
+			destlen = PAGE_SIZE - bounce_sgl[j].length;
+
+			copylen = min(srclen, destlen);
+			memcpy((void *)dest, (void *)src, copylen);
+
+			total_copied += copylen;
+			bounce_sgl[j].length += copylen;
+			srclen -= copylen;
+			src += copylen;
+
+			if (bounce_sgl[j].length == PAGE_SIZE) {
+				/* full..move to next entry */
+				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				j++;
+
+				/* if we need to use another bounce buffer */
+				if (srclen || i != orig_sgl_count - 1)
+					bounce_addr =
+					(unsigned long)kmap_atomic(
+					sg_page((&bounce_sgl[j])), KM_IRQ0);
+
+			} else if (srclen == 0 && i == orig_sgl_count - 1) {
+				/* unmap the last bounce that is < PAGE_SIZE */
+				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+			}
+		}
+
+		kunmap_atomic((void *)(src_addr - orig_sgl[i].offset), KM_IRQ0);
+	}
+
+	local_irq_restore(flags);
+
+	return total_copied;
+}
+
+static int storvsc_channel_init(struct hv_device *device)
+{
+	struct storvsc_device *stor_device;
+	struct storvsc_cmd_request *request;
+	struct vstor_packet *vstor_packet;
+	int ret, t;
+
+	stor_device = get_out_stor_device(device);
+	if (!stor_device)
+		return -ENODEV;
+
+	request = &stor_device->init_request;
+	vstor_packet = &request->vstor_packet;
+
+	/*
+	 * Now, initiate the vsc/vsp initialization protocol on the open
+	 * channel
+	 */
+	memset(request, 0, sizeof(struct storvsc_cmd_request));
+	init_completion(&request->wait_event);
+	vstor_packet->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
+			       sizeof(struct vstor_packet),
+			       (unsigned long)request,
+			       VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+	if (ret != 0)
+		goto cleanup;
+
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+	if (t == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
+
+	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstor_packet->status != 0)
+		goto cleanup;
+
+
+	/* reuse the packet for version range supported */
+	memset(vstor_packet, 0, sizeof(struct vstor_packet));
+	vstor_packet->operation = VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+
+	vstor_packet->version.major_minor =
+		storvsc_get_version(VMSTOR_CURRENT_MAJOR, VMSTOR_CURRENT_MINOR);
+
+	/*
+	 * The revision number is only used in Windows; set it to 0.
+	 */
+	vstor_packet->version.revision = 0;
+
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
+			       sizeof(struct vstor_packet),
+			       (unsigned long)request,
+			       VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+	if (ret != 0)
+		goto cleanup;
+
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+	if (t == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
+
+	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstor_packet->status != 0)
+		goto cleanup;
+
+
+	memset(vstor_packet, 0, sizeof(struct vstor_packet));
+	vstor_packet->operation = VSTOR_OPERATION_QUERY_PROPERTIES;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+	vstor_packet->storage_channel_properties.port_number =
+					stor_device->port_number;
+
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
+			       sizeof(struct vstor_packet),
+			       (unsigned long)request,
+			       VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+
+	if (ret != 0)
+		goto cleanup;
+
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+	if (t == 0) {
+		ret = -ETIMEDOUT;
+		goto cleanup;
+	}
+
+	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstor_packet->status != 0)
+		goto cleanup;
+
+	stor_device->path_id = vstor_packet->storage_channel_properties.path_id;
+	stor_device->target_id
+		= vstor_packet->storage_channel_properties.target_id;
+
+	memset(vstor_packet, 0, sizeof(struct vstor_packet));
+	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
+			       sizeof(struct vstor_packet),
+			       (unsigned long)request,
+			       VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+
+	if (ret != 0)
+		goto cleanup;
 
 	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t == 0) {
@@ -524,9 +760,84 @@ cleanup:
 	return ret;
 }
 
+
+static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
+{
+	struct scsi_cmnd *scmnd = cmd_request->cmd;
+	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
+	void (*scsi_done_fn)(struct scsi_cmnd *);
+	struct scsi_sense_hdr sense_hdr;
+	struct vmscsi_request *vm_srb;
+	struct storvsc_scan_work *wrk;
+	struct stor_mem_pools *memp = scmnd->device->hostdata;
+
+	vm_srb = &cmd_request->vstor_packet.vm_srb;
+	if (cmd_request->bounce_sgl_count) {
+		if (vm_srb->data_in == READ_TYPE)
+			copy_from_bounce_buffer(scsi_sglist(scmnd),
+					cmd_request->bounce_sgl,
+					scsi_sg_count(scmnd),
+					cmd_request->bounce_sgl_count);
+		destroy_bounce_buffer(cmd_request->bounce_sgl,
+					cmd_request->bounce_sgl_count);
+	}
+
+	/*
+	 * If there is an error; offline the device since all
+	 * error recovery strategies would have already been
+	 * deployed on the host side.
+	 */
+	if (vm_srb->srb_status == SRB_STATUS_ERROR)
+		scmnd->result = DID_TARGET_FAILURE << 16;
+	else
+		scmnd->result = vm_srb->scsi_status;
+
+	/*
+	 * If the LUN is invalid; remove the device.
+	 */
+	if (vm_srb->srb_status == SRB_STATUS_INVALID_LUN) {
+		struct storvsc_device *stor_dev;
+		struct hv_device *dev = host_dev->dev;
+		struct Scsi_Host *host;
+
+		stor_dev = get_in_stor_device(dev);
+		host = stor_dev->host;
+
+		wrk = kmalloc(sizeof(struct storvsc_scan_work),
+				GFP_ATOMIC);
+		if (!wrk) {
+			scmnd->result = DID_TARGET_FAILURE << 16;
+		} else {
+			wrk->host = host;
+			wrk->lun = vm_srb->lun;
+			INIT_WORK(&wrk->work, storvsc_remove_lun);
+			schedule_work(&wrk->work);
+		}
+	}
+
+	if (scmnd->result) {
+		if (scsi_normalize_sense(scmnd->sense_buffer,
+				SCSI_SENSE_BUFFERSIZE, &sense_hdr))
+			scsi_print_sense_hdr("storvsc", &sense_hdr);
+	}
+
+	scsi_set_resid(scmnd,
+		cmd_request->data_buffer.len -
+		vm_srb->data_transfer_length);
+
+	scsi_done_fn = scmnd->scsi_done;
+
+	scmnd->host_scribble = NULL;
+	scmnd->scsi_done = NULL;
+
+	scsi_done_fn(scmnd);
+
+	mempool_free(cmd_request, memp->request_mempool);
+}
+
 static void storvsc_on_io_completion(struct hv_device *device,
 				  struct vstor_packet *vstor_packet,
-				  struct hv_storvsc_request *request)
+				  struct storvsc_cmd_request *request)
 {
 	struct storvsc_device *stor_device;
 	struct vstor_packet *stor_pkt;
@@ -546,9 +857,9 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	 */
 
 	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
-		(stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
+	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
 		vstor_packet->vm_srb.scsi_status = 0;
-		vstor_packet->vm_srb.srb_status = 0x1;
+		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
 	}
 
 
@@ -559,7 +870,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	vstor_packet->vm_srb.sense_info_length;
 
 	if (vstor_packet->vm_srb.scsi_status != 0 ||
-		vstor_packet->vm_srb.srb_status != 1){
+		vstor_packet->vm_srb.srb_status != SRB_STATUS_SUCCESS){
 		dev_warn(&device->device,
 			 "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
 			 stor_pkt->vm_srb.cdb[0],
@@ -569,7 +880,8 @@ static void storvsc_on_io_completion(struct hv_device *device,
 
 	if ((vstor_packet->vm_srb.scsi_status & 0xFF) == 0x02) {
 		/* CHECK_CONDITION */
-		if (vstor_packet->vm_srb.srb_status & 0x80) {
+		if (vstor_packet->vm_srb.srb_status &
+			SRB_STATUS_AUTOSENSE_VALID) {
 			/* autosense data available */
 			dev_warn(&device->device,
 				 "stor pkt %p autosense data valid - len %d\n",
@@ -586,7 +898,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	stor_pkt->vm_srb.data_transfer_length =
 	vstor_packet->vm_srb.data_transfer_length;
 
-	request->on_io_completion(request);
+	storvsc_command_completion(request);
 
 	if (atomic_dec_and_test(&stor_device->num_outstanding_req) &&
 		stor_device->drain_notify)
@@ -597,7 +909,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 
 static void storvsc_on_receive(struct hv_device *device,
 			     struct vstor_packet *vstor_packet,
-			     struct hv_storvsc_request *request)
+			     struct storvsc_cmd_request *request)
 {
 	struct storvsc_scan_work *work;
 	struct storvsc_device *stor_device;
@@ -631,7 +943,7 @@ static void storvsc_on_channel_callback(void *context)
 	u32 bytes_recvd;
 	u64 request_id;
 	unsigned char packet[ALIGN(sizeof(struct vstor_packet), 8)];
-	struct hv_storvsc_request *request;
+	struct storvsc_cmd_request *request;
 	int ret;
 
 
@@ -645,7 +957,7 @@ static void storvsc_on_channel_callback(void *context)
 				       &bytes_recvd, &request_id);
 		if (ret == 0 && bytes_recvd > 0) {
 
-			request = (struct hv_storvsc_request *)
+			request = (struct storvsc_cmd_request *)
 					(unsigned long)request_id;
 
 			if ((request == &stor_device->init_request) ||
@@ -674,7 +986,6 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size)
 
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
-	/* Open the channel */
 	ret = vmbus_open(device->channel,
 			 ring_size,
 			 ring_size,
@@ -728,7 +1039,7 @@ static int storvsc_dev_remove(struct hv_device *device)
 }
 
 static int storvsc_do_io(struct hv_device *device,
-			      struct hv_storvsc_request *request)
+			      struct storvsc_cmd_request *request)
 {
 	struct storvsc_device *stor_device;
 	struct vstor_packet *vstor_packet;
@@ -749,342 +1060,94 @@ static int storvsc_do_io(struct hv_device *device,
 	vstor_packet->vm_srb.length = sizeof(struct vmscsi_request);
 
 
-	vstor_packet->vm_srb.sense_info_length = SENSE_BUFFER_SIZE;
-
-
-	vstor_packet->vm_srb.data_transfer_length =
-	request->data_buffer.len;
-
-	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
-
-	if (request->data_buffer.len) {
-		ret = vmbus_sendpacket_multipagebuffer(device->channel,
-				&request->data_buffer,
-				vstor_packet,
-				sizeof(struct vstor_packet),
-				(unsigned long)request);
-	} else {
-		ret = vmbus_sendpacket(device->channel, vstor_packet,
-			       sizeof(struct vstor_packet),
-			       (unsigned long)request,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	}
-
-	if (ret != 0)
-		return ret;
-
-	atomic_inc(&stor_device->num_outstanding_req);
-
-	return ret;
-}
-
-static void storvsc_get_ide_info(struct hv_device *dev, int *target, int *path)
-{
-	*target =
-		dev->dev_instance.b[5] << 8 | dev->dev_instance.b[4];
-
-	*path =
-		dev->dev_instance.b[3] << 24 |
-		dev->dev_instance.b[2] << 16 |
-		dev->dev_instance.b[1] << 8  | dev->dev_instance.b[0];
-}
-
-
-static int storvsc_device_alloc(struct scsi_device *sdevice)
-{
-	struct stor_mem_pools *memp;
-	int number = STORVSC_MIN_BUF_NR;
-
-	memp = kzalloc(sizeof(struct stor_mem_pools), GFP_KERNEL);
-	if (!memp)
-		return -ENOMEM;
-
-	memp->request_pool =
-		kmem_cache_create(dev_name(&sdevice->sdev_dev),
-				sizeof(struct storvsc_cmd_request), 0,
-				SLAB_HWCACHE_ALIGN, NULL);
-
-	if (!memp->request_pool)
-		goto err0;
-
-	memp->request_mempool = mempool_create(number, mempool_alloc_slab,
-						mempool_free_slab,
-						memp->request_pool);
-
-	if (!memp->request_mempool)
-		goto err1;
-
-	sdevice->hostdata = memp;
-
-	return 0;
-
-err1:
-	kmem_cache_destroy(memp->request_pool);
-
-err0:
-	kfree(memp);
-	return -ENOMEM;
-}
-
-static void storvsc_device_destroy(struct scsi_device *sdevice)
-{
-	struct stor_mem_pools *memp = sdevice->hostdata;
-
-	mempool_destroy(memp->request_mempool);
-	kmem_cache_destroy(memp->request_pool);
-	kfree(memp);
-	sdevice->hostdata = NULL;
-}
-
-static int storvsc_device_configure(struct scsi_device *sdevice)
-{
-	scsi_adjust_queue_depth(sdevice, MSG_SIMPLE_TAG,
-				STORVSC_MAX_IO_REQUESTS);
-
-	blk_queue_max_segment_size(sdevice->request_queue, PAGE_SIZE);
-
-	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
-
-	return 0;
-}
-
-static void destroy_bounce_buffer(struct scatterlist *sgl,
-				  unsigned int sg_count)
-{
-	int i;
-	struct page *page_buf;
-
-	for (i = 0; i < sg_count; i++) {
-		page_buf = sg_page((&sgl[i]));
-		if (page_buf != NULL)
-			__free_page(page_buf);
-	}
-
-	kfree(sgl);
-}
-
-static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count)
-{
-	int i;
-
-	/* No need to check */
-	if (sg_count < 2)
-		return -1;
-
-	/* We have at least 2 sg entries */
-	for (i = 0; i < sg_count; i++) {
-		if (i == 0) {
-			/* make sure 1st one does not have hole */
-			if (sgl[i].offset + sgl[i].length != PAGE_SIZE)
-				return i;
-		} else if (i == sg_count - 1) {
-			/* make sure last one does not have hole */
-			if (sgl[i].offset != 0)
-				return i;
-		} else {
-			/* make sure no hole in the middle */
-			if (sgl[i].length != PAGE_SIZE || sgl[i].offset != 0)
-				return i;
-		}
-	}
-	return -1;
-}
-
-static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
-						unsigned int sg_count,
-						unsigned int len,
-						int write)
-{
-	int i;
-	int num_pages;
-	struct scatterlist *bounce_sgl;
-	struct page *page_buf;
-	unsigned int buf_len = ((write == WRITE_TYPE) ? 0 : PAGE_SIZE);
-
-	num_pages = ALIGN(len, PAGE_SIZE) >> PAGE_SHIFT;
-
-	bounce_sgl = kcalloc(num_pages, sizeof(struct scatterlist), GFP_ATOMIC);
-	if (!bounce_sgl)
-		return NULL;
-
-	for (i = 0; i < num_pages; i++) {
-		page_buf = alloc_page(GFP_ATOMIC);
-		if (!page_buf)
-			goto cleanup;
-		sg_set_page(&bounce_sgl[i], page_buf, buf_len, 0);
-	}
-
-	return bounce_sgl;
-
-cleanup:
-	destroy_bounce_buffer(bounce_sgl, num_pages);
-	return NULL;
-}
-
-
-/* Assume the original sgl has enough room */
-static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
-					    struct scatterlist *bounce_sgl,
-					    unsigned int orig_sgl_count,
-					    unsigned int bounce_sgl_count)
-{
-	int i;
-	int j = 0;
-	unsigned long src, dest;
-	unsigned int srclen, destlen, copylen;
-	unsigned int total_copied = 0;
-	unsigned long bounce_addr = 0;
-	unsigned long dest_addr = 0;
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	for (i = 0; i < orig_sgl_count; i++) {
-		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])))
-					+ orig_sgl[i].offset;
-		dest = dest_addr;
-		destlen = orig_sgl[i].length;
-
-		if (bounce_addr == 0)
-			bounce_addr =
-			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])));
-
-		while (destlen) {
-			src = bounce_addr + bounce_sgl[j].offset;
-			srclen = bounce_sgl[j].length - bounce_sgl[j].offset;
-
-			copylen = min(srclen, destlen);
-			memcpy((void *)dest, (void *)src, copylen);
-
-			total_copied += copylen;
-			bounce_sgl[j].offset += copylen;
-			destlen -= copylen;
-			dest += copylen;
-
-			if (bounce_sgl[j].offset == bounce_sgl[j].length) {
-				/* full */
-				kunmap_atomic((void *)bounce_addr);
-				j++;
-
-				/*
-				 * It is possible that the number of elements
-				 * in the bounce buffer may not be equal to
-				 * the number of elements in the original
-				 * scatter list. Handle this correctly.
-				 */
+	vstor_packet->vm_srb.sense_info_length = STORVSC_SENSE_BUFFER_SIZE;
 
-				if (j == bounce_sgl_count) {
-					/*
-					 * We are done; cleanup and return.
-					 */
-					kunmap_atomic((void *)(dest_addr -
-							orig_sgl[i].offset),
-							KM_IRQ0);
-					local_irq_restore(flags);
-					return total_copied;
-				}
 
-				/* if we need to use another bounce buffer */
-				if (destlen || i != orig_sgl_count - 1)
-					bounce_addr =
-					(unsigned long)kmap_atomic(
-					sg_page((&bounce_sgl[j])));
-			} else if (destlen == 0 && i == orig_sgl_count - 1) {
-				/* unmap the last bounce that is < PAGE_SIZE */
-				kunmap_atomic((void *)bounce_addr);
-			}
-		}
+	vstor_packet->vm_srb.data_transfer_length =
+	request->data_buffer.len;
 
-		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset));
+	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
+
+	if (request->data_buffer.len) {
+		ret = vmbus_sendpacket_multipagebuffer(device->channel,
+				&request->data_buffer,
+				vstor_packet,
+				sizeof(struct vstor_packet),
+				(unsigned long)request);
+	} else {
+		ret = vmbus_sendpacket(device->channel, vstor_packet,
+			       sizeof(struct vstor_packet),
+			       (unsigned long)request,
+			       VM_PKT_DATA_INBAND,
+			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	}
 
-	local_irq_restore(flags);
+	if (ret != 0)
+		return ret;
 
-	return total_copied;
-}
+	atomic_inc(&stor_device->num_outstanding_req);
 
+	return ret;
+}
 
-/* Assume the bounce_sgl has enough room ie using the create_bounce_buffer() */
-static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
-					  struct scatterlist *bounce_sgl,
-					  unsigned int orig_sgl_count)
+static int storvsc_device_alloc(struct scsi_device *sdevice)
 {
-	int i;
-	int j = 0;
-	unsigned long src, dest;
-	unsigned int srclen, destlen, copylen;
-	unsigned int total_copied = 0;
-	unsigned long bounce_addr = 0;
-	unsigned long src_addr = 0;
-	unsigned long flags;
-
-	local_irq_save(flags);
+	struct stor_mem_pools *memp;
+	int number = STORVSC_MIN_BUF_NR;
 
-	for (i = 0; i < orig_sgl_count; i++) {
-		src_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])))
-				+ orig_sgl[i].offset;
-		src = src_addr;
-		srclen = orig_sgl[i].length;
+	memp = kzalloc(sizeof(struct stor_mem_pools), GFP_KERNEL);
+	if (!memp)
+		return -ENOMEM;
 
-		if (bounce_addr == 0)
-			bounce_addr =
-			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])));
+	memp->request_pool =
+		kmem_cache_create(dev_name(&sdevice->sdev_dev),
+				sizeof(struct storvsc_cmd_request), 0,
+				SLAB_HWCACHE_ALIGN, NULL);
 
-		while (srclen) {
-			/* assume bounce offset always == 0 */
-			dest = bounce_addr + bounce_sgl[j].length;
-			destlen = PAGE_SIZE - bounce_sgl[j].length;
+	if (!memp->request_pool)
+		goto err0;
 
-			copylen = min(srclen, destlen);
-			memcpy((void *)dest, (void *)src, copylen);
+	memp->request_mempool = mempool_create(number, mempool_alloc_slab,
+						mempool_free_slab,
+						memp->request_pool);
 
-			total_copied += copylen;
-			bounce_sgl[j].length += copylen;
-			srclen -= copylen;
-			src += copylen;
+	if (!memp->request_mempool)
+		goto err1;
 
-			if (bounce_sgl[j].length == PAGE_SIZE) {
-				/* full..move to next entry */
-				kunmap_atomic((void *)bounce_addr);
-				j++;
+	sdevice->hostdata = memp;
 
-				/* if we need to use another bounce buffer */
-				if (srclen || i != orig_sgl_count - 1)
-					bounce_addr =
-					(unsigned long)kmap_atomic(
-					sg_page((&bounce_sgl[j])));
+	return 0;
 
-			} else if (srclen == 0 && i == orig_sgl_count - 1) {
-				/* unmap the last bounce that is < PAGE_SIZE */
-				kunmap_atomic((void *)bounce_addr);
-			}
-		}
+err1:
+	kmem_cache_destroy(memp->request_pool);
 
-		kunmap_atomic((void *)(src_addr - orig_sgl[i].offset));
-	}
+err0:
+	kfree(memp);
+	return -ENOMEM;
+}
 
-	local_irq_restore(flags);
+static void storvsc_device_destroy(struct scsi_device *sdevice)
+{
+	struct stor_mem_pools *memp = sdevice->hostdata;
 
-	return total_copied;
+	mempool_destroy(memp->request_mempool);
+	kmem_cache_destroy(memp->request_pool);
+	kfree(memp);
+	sdevice->hostdata = NULL;
 }
 
-
-static int storvsc_remove(struct hv_device *dev)
+static int storvsc_device_configure(struct scsi_device *sdevice)
 {
-	struct storvsc_device *stor_device = hv_get_drvdata(dev);
-	struct Scsi_Host *host = stor_device->host;
-
-	scsi_remove_host(host);
+	scsi_adjust_queue_depth(sdevice, MSG_SIMPLE_TAG,
+				STORVSC_MAX_IO_REQUESTS);
 
-	scsi_host_put(host);
+	blk_queue_max_segment_size(sdevice->request_queue, PAGE_SIZE);
 
-	storvsc_dev_remove(dev);
+	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
 
 	return 0;
 }
 
-
 static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
 			   sector_t capacity, int *info)
 {
@@ -1108,10 +1171,13 @@ static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
 	return 0;
 }
 
-static int storvsc_host_reset(struct hv_device *device)
+static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 {
+	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
+	struct hv_device *device = host_dev->dev;
+
 	struct storvsc_device *stor_device;
-	struct hv_storvsc_request *request;
+	struct storvsc_cmd_request *request;
 	struct vstor_packet *vstor_packet;
 	int ret, t;
 
@@ -1150,105 +1216,16 @@ static int storvsc_host_reset(struct hv_device *device)
 	return SUCCESS;
 }
 
-
-/*
- * storvsc_host_reset_handler - Reset the scsi HBA
- */
-static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
-{
-	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
-	struct hv_device *dev = host_dev->dev;
-
-	return storvsc_host_reset(dev);
-}
-
-
-/*
- * storvsc_command_completion - Command completion processing
- */
-static void storvsc_command_completion(struct hv_storvsc_request *request)
-{
-	struct storvsc_cmd_request *cmd_request =
-		(struct storvsc_cmd_request *)request->context;
-	struct scsi_cmnd *scmnd = cmd_request->cmd;
-	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
-	void (*scsi_done_fn)(struct scsi_cmnd *);
-	struct scsi_sense_hdr sense_hdr;
-	struct vmscsi_request *vm_srb;
-	struct storvsc_scan_work *wrk;
-	struct stor_mem_pools *memp = scmnd->device->hostdata;
-
-	vm_srb = &request->vstor_packet.vm_srb;
-	if (cmd_request->bounce_sgl_count) {
-		if (vm_srb->data_in == READ_TYPE)
-			copy_from_bounce_buffer(scsi_sglist(scmnd),
-					cmd_request->bounce_sgl,
-					scsi_sg_count(scmnd),
-					cmd_request->bounce_sgl_count);
-		destroy_bounce_buffer(cmd_request->bounce_sgl,
-					cmd_request->bounce_sgl_count);
-	}
-
-	/*
-	 * If there is an error; offline the device since all
-	 * error recovery strategies would have already been
-	 * deployed on the host side.
-	 */
-	if (vm_srb->srb_status == 0x4)
-		scmnd->result = DID_TARGET_FAILURE << 16;
-	else
-		scmnd->result = vm_srb->scsi_status;
-
-	/*
-	 * If the LUN is invalid; remove the device.
-	 */
-	if (vm_srb->srb_status == 0x20) {
-		struct storvsc_device *stor_dev;
-		struct hv_device *dev = host_dev->dev;
-		struct Scsi_Host *host;
-
-		stor_dev = get_in_stor_device(dev);
-		host = stor_dev->host;
-
-		wrk = kmalloc(sizeof(struct storvsc_scan_work),
-				GFP_ATOMIC);
-		if (!wrk) {
-			scmnd->result = DID_TARGET_FAILURE << 16;
-		} else {
-			wrk->host = host;
-			wrk->lun = vm_srb->lun;
-			INIT_WORK(&wrk->work, storvsc_remove_lun);
-			schedule_work(&wrk->work);
-		}
-	}
-
-	if (scmnd->result) {
-		if (scsi_normalize_sense(scmnd->sense_buffer,
-				SCSI_SENSE_BUFFERSIZE, &sense_hdr))
-			scsi_print_sense_hdr("storvsc", &sense_hdr);
-	}
-
-	scsi_set_resid(scmnd,
-		request->data_buffer.len -
-		vm_srb->data_transfer_length);
-
-	scsi_done_fn = scmnd->scsi_done;
-
-	scmnd->host_scribble = NULL;
-	scmnd->scsi_done = NULL;
-
-	scsi_done_fn(scmnd);
-
-	mempool_free(cmd_request, memp->request_mempool);
-}
-
-static bool storvsc_check_scsi_cmd(struct scsi_cmnd *scmnd)
+static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 {
 	bool allowed = true;
 	u8 scsi_op = scmnd->cmnd[0];
 
 	switch (scsi_op) {
-	/* smartd sends this command, which will offline the device */
+	/*
+	 * smartd sends this command and the host does not handle
+	 * this. So, don't send it.
+	 */
 	case SET_WINDOW:
 		scmnd->result = ILLEGAL_REQUEST << 16;
 		allowed = false;
@@ -1259,15 +1236,11 @@ static bool storvsc_check_scsi_cmd(struct scsi_cmnd *scmnd)
 	return allowed;
 }
 
-/*
- * storvsc_queuecommand - Initiate command processing
- */
 static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 {
 	int ret;
 	struct hv_host_device *host_dev = shost_priv(host);
 	struct hv_device *dev = host_dev->dev;
-	struct hv_storvsc_request *request;
 	struct storvsc_cmd_request *cmd_request;
 	unsigned int request_size = 0;
 	int i;
@@ -1276,38 +1249,31 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct vmscsi_request *vm_srb;
 	struct stor_mem_pools *memp = scmnd->device->hostdata;
 
-	if (storvsc_check_scsi_cmd(scmnd) == false) {
+	if (!storvsc_scsi_cmd_ok(scmnd)) {
 		scmnd->scsi_done(scmnd);
 		return 0;
 	}
 
-	/* If retrying, no need to prep the cmd */
-	if (scmnd->host_scribble) {
-
-		cmd_request =
-			(struct storvsc_cmd_request *)scmnd->host_scribble;
-
-		goto retry_request;
-	}
-
 	request_size = sizeof(struct storvsc_cmd_request);
 
 	cmd_request = mempool_alloc(memp->request_mempool,
 				       GFP_ATOMIC);
+
+	/*
+	 * We might be invoked in an interrupt context; hence
+	 * mempool_alloc() can fail.
+	 */
 	if (!cmd_request)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
 	memset(cmd_request, 0, sizeof(struct storvsc_cmd_request));
 
 	/* Setup the cmd request */
-	cmd_request->bounce_sgl_count = 0;
-	cmd_request->bounce_sgl = NULL;
 	cmd_request->cmd = scmnd;
 
 	scmnd->host_scribble = (unsigned char *)cmd_request;
 
-	request = &cmd_request->request;
-	vm_srb = &request->vstor_packet.vm_srb;
+	vm_srb = &cmd_request->vstor_packet.vm_srb;
 
 
 	/* Build the SRB */
@@ -1323,8 +1289,6 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		break;
 	}
 
-	request->on_io_completion = storvsc_command_completion;
-	request->context = cmd_request;/* scmnd; */
 
 	vm_srb->port_number = host_dev->port;
 	vm_srb->path_id = scmnd->device->channel;
@@ -1335,10 +1299,10 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 
 	memcpy(vm_srb->cdb, scmnd->cmnd, vm_srb->cdb_length);
 
-	request->sense_buffer = scmnd->sense_buffer;
+	cmd_request->sense_buffer = scmnd->sense_buffer;
 
 
-	request->data_buffer.len = scsi_bufflen(scmnd);
+	cmd_request->data_buffer.len = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
 		sg_count = scsi_sg_count(scmnd);
@@ -1350,11 +1314,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 						     scsi_bufflen(scmnd),
 						     vm_srb->data_in);
 			if (!cmd_request->bounce_sgl) {
-				scmnd->host_scribble = NULL;
-				mempool_free(cmd_request,
-						memp->request_mempool);
-
-				return SCSI_MLQUEUE_HOST_BUSY;
+				ret = SCSI_MLQUEUE_HOST_BUSY;
+				goto queue_error;
 			}
 
 			cmd_request->bounce_sgl_count =
@@ -1370,41 +1331,42 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 			sg_count = cmd_request->bounce_sgl_count;
 		}
 
-		request->data_buffer.offset = sgl[0].offset;
+		cmd_request->data_buffer.offset = sgl[0].offset;
 
 		for (i = 0; i < sg_count; i++)
-			request->data_buffer.pfn_array[i] =
+			cmd_request->data_buffer.pfn_array[i] =
 				page_to_pfn(sg_page((&sgl[i])));
 
 	} else if (scsi_sglist(scmnd)) {
-		request->data_buffer.offset =
+		cmd_request->data_buffer.offset =
 			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
-		request->data_buffer.pfn_array[0] =
+		cmd_request->data_buffer.pfn_array[0] =
 			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
 	}
 
-retry_request:
 	/* Invokes the vsc to start an IO */
-	ret = storvsc_do_io(dev, &cmd_request->request);
+	ret = storvsc_do_io(dev, cmd_request);
 
 	if (ret == -EAGAIN) {
 		/* no more space */
 
-		if (cmd_request->bounce_sgl_count)
+		if (cmd_request->bounce_sgl_count) {
 			destroy_bounce_buffer(cmd_request->bounce_sgl,
 					cmd_request->bounce_sgl_count);
 
-		mempool_free(cmd_request, memp->request_mempool);
-
-		scmnd->host_scribble = NULL;
-
-		ret = SCSI_MLQUEUE_DEVICE_BUSY;
+			ret = SCSI_MLQUEUE_DEVICE_BUSY;
+			goto queue_error;
+		}
 	}
 
+	return 0;
+
+queue_error:
+	mempool_free(cmd_request, memp->request_mempool);
+	scmnd->host_scribble = NULL;
 	return ret;
 }
 
-/* Scsi driver */
 static struct scsi_host_template scsi_driver = {
 	.module	=		THIS_MODULE,
 	.name =			"storvsc_host_t",
@@ -1445,11 +1407,6 @@ static const struct hv_vmbus_device_id id_table[] = {
 
 MODULE_DEVICE_TABLE(vmbus, id_table);
 
-
-/*
- * storvsc_probe - Add a new device for this driver
- */
-
 static int storvsc_probe(struct hv_device *device,
 			const struct hv_vmbus_device_id *dev_id)
 {
@@ -1457,7 +1414,6 @@ static int storvsc_probe(struct hv_device *device,
 	struct Scsi_Host *host;
 	struct hv_host_device *host_dev;
 	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
-	int path = 0;
 	int target = 0;
 	struct storvsc_device *stor_device;
 
@@ -1490,9 +1446,6 @@ static int storvsc_probe(struct hv_device *device,
 	if (ret)
 		goto err_out1;
 
-	if (dev_is_ide)
-		storvsc_get_ide_info(device, &target, &path);
-
 	host_dev->path = stor_device->path_id;
 	host_dev->target = stor_device->target_id;
 
@@ -1512,12 +1465,14 @@ static int storvsc_probe(struct hv_device *device,
 
 	if (!dev_is_ide) {
 		scsi_scan_host(host);
-		return 0;
-	}
-	ret = scsi_add_device(host, 0, target, 0);
-	if (ret) {
-		scsi_remove_host(host);
-		goto err_out2;
+	} else {
+		target = (device->dev_instance.b[5] << 8 |
+			 device->dev_instance.b[4]);
+		ret = scsi_add_device(host, 0, target, 0);
+		if (ret) {
+			scsi_remove_host(host);
+			goto err_out2;
+		}
 	}
 	return 0;
 
@@ -1539,7 +1494,17 @@ err_out0:
 	return ret;
 }
 
-/* The one and only one */
+static int storvsc_remove(struct hv_device *dev)
+{
+	struct storvsc_device *stor_device = hv_get_drvdata(dev);
+	struct Scsi_Host *host = stor_device->host;
+
+	scsi_remove_host(host);
+	storvsc_dev_remove(dev);
+	scsi_host_put(host);
+
+	return 0;
+}
 
 static struct hv_driver storvsc_drv = {
 	.name = KBUILD_MODNAME,
-- 
1.7.4.1
