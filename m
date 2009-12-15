From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: [PATCH] SCSI/libsrp: document the libsrp source code
Date: Tue, 15 Dec 2009 21:33:20 +0100
Message-ID: <200912152133.20204.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:39692 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbZLOUdc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2009 15:33:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Adds documentation to the libsrp source code.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 9ad38e8..bd3229e 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -29,6 +29,10 @@
 #include <scsi/srp.h>
 #include <scsi/libsrp.h>
 
+/*
+ * Allowed values for the 'TASK ATTRIBUTE' field of an SRP_CMD request. See
+ * also section 6.8 of the T10 SRP r16a document.
+ */
 enum srp_task_attributes {
 	SRP_SIMPLE_TASK = 0,
 	SRP_HEAD_TASK = 1,
@@ -44,6 +48,16 @@ do {								\
 /* #define dprintk eprintk */
 #define dprintk(fmt, args...)
 
+/**
+ * Allocate a pool of information units for use by an SRP target.
+ * @q: pointer to the pool structure that will be initialized.
+ * @max: number of information units the pool will contain.
+ * @ring: pointer to an array of 'max' SRP buffer pointers. Each information
+ *   unit allocated for the pool will be initialized such that it points to
+ *   the corresponding SRP buffer in array 'ring'.
+ *
+ * Returns zero upon success and a negative error code upon failure.
+ */
 static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
 			     struct srp_buf **ring)
 {
@@ -77,12 +91,26 @@ free_pool:
 	return -ENOMEM;
 }
 
+/**
+ * Free the memory allocated by srp_iu_pool_alloc().
+ *
+ * Note: the memory occupied by the struct srp_queue itself is not freed
+ * -- this is the responsibility of the caller.
+ */
 static void srp_iu_pool_free(struct srp_queue *q)
 {
 	kfree(q->items);
 	kfree(q->pool);
 }
 
+/**
+ * Allocate a ring of SRP buffers and set up a coherent DMA mapping for each
+ * buffer.
+ * @max: number of elements the ring will contain.
+ * @size: size in bytes of one ring element.
+ *
+ * Returns a pointer to an array of 'max' pointers to SRP buffers.
+ */
 static struct srp_buf **srp_ring_alloc(struct device *dev,
 				       size_t max, size_t size)
 {
@@ -115,6 +143,7 @@ out:
 	return NULL;
 }
 
+/** Free the memory allocated by srp_ring_alloc(). */
 static void srp_ring_free(struct device *dev, struct srp_buf **ring, size_t max,
 			  size_t size)
 {
@@ -127,6 +156,15 @@ static void srp_ring_free(struct device *dev, struct srp_buf **ring, size_t max,
 	kfree(ring);
 }
 
+/**
+ * Initialize an SRP target structure and allocate an SRP information unit ring.
+ * @target: pointer to the SRP target structure to be initialized.
+ * @dev: device to be associated with the SRP target.
+ * @nr: number of elements the SRP receive ring will contain.
+ * @iu_size: size in bytes of a single information unit.
+ *
+ * Returns zero upon success and a negative error code upon failure.
+ */
 int srp_target_alloc(struct srp_target *target, struct device *dev,
 		     size_t nr, size_t iu_size)
 {
@@ -155,6 +193,7 @@ free_ring:
 }
 EXPORT_SYMBOL_GPL(srp_target_alloc);
 
+/** Free the memory allocated by srp_target_alloc(). */
 void srp_target_free(struct srp_target *target)
 {
 	srp_ring_free(target->dev, target->rx_ring, target->rx_ring_size,
@@ -163,6 +202,11 @@ void srp_target_free(struct srp_target *target)
 }
 EXPORT_SYMBOL_GPL(srp_target_free);
 
+/**
+ * Get an information unit from the SRP target receive ring that is not in use.
+ * Initialize the ilist and flags members of the information unit before
+ * returning.
+ */
 struct iu_entry *srp_iu_get(struct srp_target *target)
 {
 	struct iu_entry *iue = NULL;
@@ -177,12 +221,24 @@ struct iu_entry *srp_iu_get(struct srp_target *target)
 }
 EXPORT_SYMBOL_GPL(srp_iu_get);
 
+/** Put an information unit back in the SRP target receive ring. */
 void srp_iu_put(struct iu_entry *iue)
 {
 	kfifo_put(iue->target->iu_queue.queue, (void *) &iue, sizeof(void *));
 }
 EXPORT_SYMBOL_GPL(srp_iu_put);
 
+/**
+ * Transfer the data referred to by an SRP direct data buffer descriptor
+ * via RDMA.
+ * @sc: SCSI command.
+ * @md: SRP direct data buffer descriptor.
+ * @dir: DMA data direction, the second last parameter passed to the function
+ *       'rdma_io'.
+ * @rdma_io: pointer to a callback function that performs the actual I/O.
+ * @dma_map: whether or not to map and unmap the scsi_sglist(sc).
+ * @ext_desc: ignored.
+ */
 static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
 			   enum dma_data_direction dir, srp_rdma_t rdma_io,
 			   int dma_map, int ext_desc)
@@ -216,6 +272,17 @@ static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
 	return err;
 }
 
+/**
+ * Transfer the data referred to by an SRP indirect data buffer descriptor via
+ * RDMA.
+ * @sc: SCSI command.
+ * @md: SRP indirect data buffer descriptor.
+ * @dir: DMA data direction, the second last parameter passed to the function
+ *       'rdma_io'.
+ * @rdma_io: pointer to a callback function that performs the actual I/O.
+ * @dma_map: whether or not to map and unmap the scsi_sglist(sc).
+ * @ext_desc: whether or not this command uses an external indirect buffer.
+ */
 static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 			     struct srp_indirect_buf *id,
 			     enum dma_data_direction dir, srp_rdma_t rdma_io,
@@ -292,6 +359,10 @@ free_mem:
 	return err;
 }
 
+/**
+ * Compute the number of bytes occupied by the DATA-OUT descriptor in an
+ * SRP_CMD request.
+ */
 static int data_out_desc_size(struct srp_cmd *cmd)
 {
 	int size = 0;
@@ -314,7 +385,16 @@ static int data_out_desc_size(struct srp_cmd *cmd)
 	return size;
 }
 
-/*
+/**
+ * Transfer the data associated with an SRP_CMD request.
+ * @sc: SCSI command.
+ * @cmd: SRP_CMD request.
+ * @rdma_io: callback function for performing RDMA I/O.
+ * @dma_map: second-last parameter passed to rdma_io.
+ * @ext_desc: whether this command uses an external indirect buffer.
+ *
+ * Note: does not support bidirectional commands.
+ *
  * TODO: this can be called multiple times for a single command if it
  * has very long data.
  */
@@ -327,10 +407,23 @@ int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 	int offset, err = 0;
 	u8 format;
 
+	/*
+	 * 'offset' is the offset in bytes of the data buffer descriptor in
+	 * an SRP_CMD request. For an SRP request that transfers data from
+	 * initiator to target, 'offset' is the offset of the data-out buffer
+	 * descriptor. For an SRP request that transfers data from target to
+	 * initiator, 'offset' is the offset of the data-in buffer descriptor.
+	 * In an SRP_CMD request the following descriptors are present starting
+	 * from cmd->add_data: additional CDB, data-out buffer descriptor and
+	 * data-in buffer descriptor.
+	 */
+
+	/* Skip over 'additional CDB' to start of data-out descriptor. */
 	offset = cmd->add_cdb_len * 4;
 
 	dir = srp_cmd_direction(cmd);
 	if (dir == DMA_FROM_DEVICE)
+		/* Skip over data-out descriptor to start of data-in. */
 		offset += data_out_desc_size(cmd);
 
 	if (dir == DMA_TO_DEVICE)
@@ -361,6 +454,13 @@ int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 }
 EXPORT_SYMBOL_GPL(srp_transfer_data);
 
+/**
+ * Compute the size in bytes of one of the two data descriptors at the end of
+ * an SRP_CMD request.
+ * @cmd: SRP_CMD request.
+ * @dir: DMA_TO_DEVICE for the size of the data-out buffer descriptor;
+ * DMA_FROM_DEVICE for the size of the data-in buffer descriptor.
+ */
 static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
 {
 	struct srp_direct_buf *md;
@@ -393,6 +493,10 @@ static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
 	return len;
 }
 
+/**
+ * Queue an SRP_CMD request for processing by appropriate target software,
+ * e.g. the user space process tgtd.
+ */
 int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
 		  u64 itn_id, u64 addr)
 {
diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
index ba615e4..e783830 100644
--- a/include/scsi/libsrp.h
+++ b/include/scsi/libsrp.h
@@ -1,11 +1,17 @@
 #ifndef __LIBSRP_H__
 #define __LIBSRP_H__
 
+/*
+ * Structures and constants exported by libsrp, a library for implementing
+ * SRP initiators and targets.
+ */
+
 #include <linux/list.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <scsi/srp.h>
 
+/* Names assigned to the bits of iu_entry::flags by the ibmvstgt driver. */
 enum iue_flags {
 	V_DIOVER,
 	V_WRITE,
@@ -13,43 +19,73 @@ enum iue_flags {
 	V_FLYING,
 };
 
+/* SRP data buffer as managed by libsrp. */
 struct srp_buf {
 	dma_addr_t dma;
 	void *buf;
 };
 
+/* Pool of SRP information units. */
 struct srp_queue {
+	/* kfifo storage; an array of n struct iu_entry* items. */
 	void *pool;
+	/* information unit storage; an array of n struct iu_entry items. */
 	void *items;
+	/* kfifo containing pointers to iu_entry items currently not in use. */
 	struct kfifo *queue;
+	/* spinlock associated with the above kfifo. */
 	spinlock_t lock;
 };
 
+/* SRP target. */
 struct srp_target {
+	/* Pointer to the SCSI host associated with the SRP target. */
 	struct Scsi_Host *shost;
+	/* Pointer to the device node associated with the SRP target. */
 	struct device *dev;
 
+	/* Initialized but not used otherwise inside libsrp. */
 	spinlock_t lock;
+	/* Initialized but not used otherwise inside libsrp. */
 	struct list_head cmd_queue;
 
+	/* Size in bytes of a single information unit. */
 	size_t srp_iu_size;
+	/* Information unit receive ring. */
 	struct srp_queue iu_queue;
+	/* Number of elements in the information unit receive ring. */
 	size_t rx_ring_size;
+	/* Pointer to an array of SRP buffers associated with the rx ring. */
 	struct srp_buf **rx_ring;
 
+	/* Pointer to target-private data. */
 	void *ldata;
 };
 
+/* Information unit as processed by an SRP target. */
 struct iu_entry {
+	/* Backpointer to the SRP target processing this information unit. */
 	struct srp_target *target;
 
+	/* Used by ibmvscsi for insertion in the srp_target::cmd_queue list. */
 	struct list_head ilist;
+	/* Used by the ibmvscsi driver but not by libsrp. */
 	dma_addr_t remote_token;
+	/* Initialized by libsrp but not used otherwise by libsrp. */
 	unsigned long flags;
 
+	/* SRP buffer associated with this information unit. */
 	struct srp_buf *sbuf;
 };
 
+/*
+ * Pointer to a callback function that performs RDMA I/O.
+ *
+ * Arguments (in order): SCSI command pointer, scatterlist pointer,
+ * number of entries in the scatterlist, pointer to an array of SRP
+ * memory descriptor pointers, number of elements in this array, DMA
+ * data direction, maximum number of bytes to transfer.
+ */
 typedef int (srp_rdma_t)(struct scsi_cmnd *, struct scatterlist *, int,
 			 struct srp_direct_buf *, int,
 			 enum dma_data_direction, unsigned int);
@@ -69,6 +105,16 @@ static inline struct srp_target *host_to_srp_target(struct Scsi_Host *host)
 	return (struct srp_target *) host->hostdata;
 }
 
+/*
+ * Find out whether an SRP_CMD request is transferring data from initiator to
+ * target or from target to initiator.
+ *
+ * Returns DMA_TO_DEVICE when transferring data from initiator to target and
+ * DMA_FROM_DEVICE when transferring data from target to initiator. This
+ * reflects the point of view of an SRP initiator implementation.
+ *
+ * Note: do not use this function for bidirectional commands.
+ */
 static inline int srp_cmd_direction(struct srp_cmd *cmd)
 {
 	return (cmd->buf_fmt >> 4) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index ad178fa..ebb6096 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -38,11 +38,13 @@
 /*
  * Structures and constants for the SCSI RDMA Protocol (SRP) as
  * defined by the INCITS T10 committee.  This file was written using
- * draft Revision 16a of the SRP standard.
+ * draft Revision 16a of the SRP standard. See also
+ * http://www.t10.org/drafts.htm#SCSI3_SRP.
  */
 
 #include <linux/types.h>
 
+/* SRP information unit types. */
 enum {
 	SRP_LOGIN_REQ	= 0x00,
 	SRP_TSK_MGMT	= 0x01,
@@ -58,17 +60,31 @@ enum {
 	SRP_AER_RSP	= 0x42
 };
 
+/*
+ * Flags for the 'REQUIRED BUFFER FORMATS' field of the SRP_LOGIN_REQ request
+ * (srp_login_req::req_buf_fmt) or the 'SUPPORTED BUFFER FORMATS' field of the
+ * SRP_LOGIN_RSP response (srp_login_rsp::buf_fmt). See also section 5.6.2.2
+ * in the T10 SRP r16a document.
+ */
 enum {
 	SRP_BUF_FORMAT_DIRECT	= 1 << 1,
 	SRP_BUF_FORMAT_INDIRECT	= 1 << 2
 };
 
+/*
+ * Format of data-in and data-out buffer descriptors in an SRP_CMD
+ * request. See also section 5.6.2.1 in the T10 SRP r16a document.
+ */
 enum {
 	SRP_NO_DATA_DESC	= 0,
 	SRP_DATA_DESC_DIRECT	= 1,
 	SRP_DATA_DESC_INDIRECT	= 2
 };
 
+/*
+ * Allowed values for the 'TASK MANAGEMENT FUNCTION' field of the SRP_TSK_MGMT
+ * request. See also section 6.7 in the T10 SRP r16a document.
+ */
 enum {
 	SRP_TSK_ABORT_TASK	= 0x01,
 	SRP_TSK_ABORT_TASK_SET	= 0x02,
@@ -77,6 +93,10 @@ enum {
 	SRP_TSK_CLEAR_ACA	= 0x40
 };
 
+/*
+ * Allowed values for the 'REASON' field of the SRP_LOGIN_REJ response. See
+ * also section 6.4 in the T10 SRP r16a document.
+ */
 enum srp_login_rej_reason {
 	SRP_LOGIN_REJ_UNABLE_ESTABLISH_CHANNEL		= 0x00010000,
 	SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES		= 0x00010001,
@@ -87,11 +107,20 @@ enum srp_login_rej_reason {
 	SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED		= 0x00010006
 };
 
+/*
+ * IB I/O class assigned to revisions 10 and r16a of the SRP protocol.
+ * See also section B.7 in the T10 SRP r16a document.
+ */
 enum {
 	SRP_REV10_IB_IO_CLASS	= 0xff00,
 	SRP_REV16A_IB_IO_CLASS	= 0x0100
 };
 
+/*
+ * Direct data buffer descriptor as defined in section 5.6.2.4 of the T10 SRP
+ * r16a document. Each direct data buffer descriptor consists of a virtual
+ * address, a memory handle and a data length.
+ */
 struct srp_direct_buf {
 	__be64	va;
 	__be32	key;
@@ -99,6 +128,9 @@ struct srp_direct_buf {
 };
 
 /*
+ * Indirect data buffer descriptor as defined in section 5.6.2.5 of the T10
+ * SRP r16a document.
+ *
  * We need the packed attribute because the SRP spec puts the list of
  * descriptors at an offset of 20, which is not aligned to the size of
  * struct srp_direct_buf.  The whole structure must be packed to avoid
@@ -110,11 +142,20 @@ struct srp_indirect_buf {
 	struct srp_direct_buf	desc_list[0];
 } __attribute__((packed));
 
+/*
+ * Allowed values for the 'MULTI-CHANNEL ACTION CODE' field of the
+ * SRP_LOGIN_REQ request, as defined in section 6.2 of the T10 SRP r16a
+ * document.
+ */
 enum {
 	SRP_MULTICHAN_SINGLE = 0,
 	SRP_MULTICHAN_MULTI  = 1
 };
 
+/*
+ * SRP_LOGIN_REQ request, also defined in section 6.2 of the T10 SRP r16a
+ * document.
+ */
 struct srp_login_req {
 	u8	opcode;
 	u8	reserved1[7];
@@ -129,6 +170,9 @@ struct srp_login_req {
 };
 
 /*
+ * SRP_LOGIN_RSP response, as defined in section 6.3 of the T10 SRP r16a
+ * document.
+ *
  * The SRP spec defines the size of the LOGIN_RSP structure to be 52
  * bytes, so it needs to be packed to avoid having it padded to 56
  * bytes on 64-bit architectures.
@@ -145,6 +189,10 @@ struct srp_login_rsp {
 	u8	reserved2[25];
 } __attribute__((packed));
 
+/*
+ * SRP_LOGIN_REJ response, as defined in section 6.4 of the T10 SRP r16a
+ * document.
+ */
 struct srp_login_rej {
 	u8	opcode;
 	u8	reserved1[3];
@@ -155,12 +203,19 @@ struct srp_login_rej {
 	u8	reserved3[6];
 };
 
+/*
+ * SRP_I_LOGOUT request, as defined in section 6.5 of the T10 SRP r16a
+ * document.
+ */
 struct srp_i_logout {
 	u8	opcode;
 	u8	reserved[7];
 	u64	tag;
 };
 
+/*
+ * SRP_T_LOGOUT request, as defined in section 6.6 of the T10 SRP r16a document.
+ */
 struct srp_t_logout {
 	u8	opcode;
 	u8	sol_not;
@@ -170,6 +225,8 @@ struct srp_t_logout {
 };
 
 /*
+ * SRP_TSK_MGMT request, as defined in section 6.7 of the T10 SRP r16a document.
+ *
  * We need the packed attribute because the SRP spec only aligns the
  * 8-byte LUN field to 4 bytes.
  */
@@ -188,6 +245,9 @@ struct srp_tsk_mgmt {
 };
 
 /*
+ * SRP_CMD request with a single CDB as defined in section 6.8 of the T10 SRP
+ * r16a document.
+ *
  * We need the packed attribute because the SRP spec only aligns the
  * 8-byte LUN field to 4 bytes.
  */
@@ -209,6 +269,10 @@ struct srp_cmd {
 	u8	add_data[0];
 };
 
+/*
+ * Allowed flags for the flags field of the SRP_RSP response. See also
+ * section 6.9 of the T10 SRP r16a document.
+ */
 enum {
 	SRP_RSP_FLAG_RSPVALID = 1 << 0,
 	SRP_RSP_FLAG_SNSVALID = 1 << 1,
@@ -219,6 +283,8 @@ enum {
 };
 
 /*
+ * SRP_RSP response, as defined in section 6.9 of the T10 SRP r16a document.
+ *
  * The SRP spec defines the size of the RSP structure to be 36 bytes,
  * so it needs to be packed to avoid having it padded to 40 bytes on
  * 64-bit architectures.
