From: boutcher@us.ibm.com
Subject: [PATCH] ibmvscsi driver v1.5.1
Date: Fri, 16 Jul 2004 23:51:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040717045124.GA24223@hound-gentoo.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:38838 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S266695AbUGQEva
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jul 2004 00:51:30 -0400
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e32.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id i6H4pTko839052
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jul 2004 00:51:29 -0400
Received: from hound.rchland.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with SMTP id i6H4pSC2180572
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jul 2004 22:51:28 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Based on comments from hch and jejb, an update to the ibmvscsi
driver patch.  Primarily style issues, though the removal of
gratuitous casting lead to some significant refactoring
of functions.

- Moved #include <asm/...> after #include <linux/...>
- removed the map_direct_data and map_indirect_data and moved
   the function inline
- Fixed function declaration style issues (static on a line by
   itself)
- Removed bogus cast from dma_map_single
- Moved setting of data transfer direction to a single helper
   function
- Fixed up some gratuitous casting of types
- Collapsed a couple of other functions inline
- Removed bogus check for NULL from remove 
- Removed the "evt_struct_for" routine as being needlessly obfuscatory

 drivers/scsi/Kconfig                            |    9 
 drivers/scsi/Makefile                           |    1 
 linux-2.6/drivers/scsi/ibmvscsi/Makefile        |    5 
 linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c      | 1415 ++++++++++++++++++++++++
 linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.h      |  111 +
 linux-2.6/drivers/scsi/ibmvscsi/iseries_vscsi.c |  144 ++
 linux-2.6/drivers/scsi/ibmvscsi/rpa_vscsi.c     |  260 ++++
 linux-2.6/drivers/scsi/ibmvscsi/srp.h           |  226 +++
 linux-2.6/drivers/scsi/ibmvscsi/viosrp.h        |  126 ++
 9 files changed, 2297 insertions(+)

Dave B

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch-ibmvscsi-2.6-jul16.diff"

diff -uNr --exclude=SCCS linux-2.6-pure/drivers/scsi/ibmvscsi/ibmvscsi.c linux-2.6b-tmp1/drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6-pure/drivers/scsi/ibmvscsi/ibmvscsi.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6b-tmp1/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-07-16 18:23:59.652957616 -0500
@@ -0,0 +1,1393 @@
+/* ------------------------------------------------------------
+ * ibmvscsi.c
+ * (C) Copyright IBM Corporation 1994, 2004
+ * Authors: Colin DeVilbiss (devilbis@us.ibm.com)
+ *          Santiago Leon (santil@us.ibm.com)
+ *          Dave Boutcher (sleddog@us.ibm.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ * ------------------------------------------------------------
+ * Emulation of a SCSI host adapter for Virtual I/O devices
+ *
+ * This driver supports the SCSI adapter implemented by the IBM
+ * Power5 firmware.  That SCSI adapter is not a physical adapter,
+ * but allows Linux SCSI peripheral drivers to directly
+ * access devices in another logical partition on the physical system.
+ *
+ * The virtual adapter(s) are present in the open firmware device
+ * tree just like real adapters.
+ *
+ * One of the capabilities provided on these systems is the ability
+ * to DMA between partitions.  The architecture states that for VSCSI,
+ * the server side is allowed to DMA to and from the client.  The client
+ * is never trusted to DMA to or from the server directly.
+ *
+ * Messages are sent between partitions on a "Command/Response Queue" 
+ * (CRQ), which is just a buffer of 16 byte entries in the receiver's 
+ * Senders cannot access the buffer directly, but send messages by
+ * making a hypervisor call and passing in the 16 bytes.  The hypervisor
+ * puts the message in the next 16 byte space in round-robbin fashion,
+ * turns on the high order bit of the message (the valid bit), and 
+ * generates an interrupt to the receiver (if interrupts are turned on.) 
+ * The receiver just turns off the valid bit when they have copied out
+ * the message.
+ *
+ * The VSCSI client builds a SCSI Remote Protocol (SRP) Information Unit
+ * (IU) (as defined in the T10 standard available at www.t10.org), gets 
+ * a DMA address for the message, and sends it to the server as the
+ * payload of a CRQ message.  The server DMAs the SRP IU and processes it,
+ * including doing any additional data transfers.  When it is done, it
+ * DMAs the SRP response back to the same address as the request came from,
+ * and sends a CRQ message back to inform the client that the request has
+ * completed.
+ *
+ * Note that some of the underlying infrastructure is different between
+ * machines conforming to the "RS/6000 Platform Architecture" (RPA) and
+ * the older iSeries hypervisor models.  To support both, some low level
+ * routines have been broken out into rpa_vscsi.c and iseries_vscsi.c.
+ * The Makefile should pick one, not two, not zero, of these.
+ *
+ * TODO: This is currently pretty tied to the IBM i/pSeries hypervisor
+ * interfaces.  It would be really nice to abstract this above an RDMA
+ * layer.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/dma-mapping.h>
+#include <asm/vio.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include "ibmvscsi.h"
+
+/* The values below are somewhat arbitrary default values, but 
+ * OS/400 will use 3 busses (disks, CDs, tapes, I think.)
+ * Note that there are 3 bits of channel value, 6 bits of id, and
+ * 5 bits of LUN.
+ */
+static int max_id = 64;
+static int max_channel = 3;
+static int init_timeout = 5;
+static int max_requests = 50;
+
+#define IBMVSCSI_VERSION "1.5.1"
+
+MODULE_DESCRIPTION("IBM Virtual SCSI");
+MODULE_AUTHOR("Dave Boutcher");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(IBMVSCSI_VERSION);
+
+module_param_named(max_id, max_id, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
+module_param_named(max_channel, max_channel, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(max_channel, "Largest channel value");
+module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
+module_param_named(max_requests, max_requests, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter");
+
+/* ------------------------------------------------------------
+ * Routines for the event pool and event structs
+ */
+/**
+ * initialize_event_pool: - Allocates and initializes the event pool for a host
+ * @pool:	event_pool to be initialized
+ * @size:	Number of events in pool
+ * @hostdata:	ibmvscsi_host_data who owns the event pool
+ *
+ * Returns zero on success.
+*/
+static int initialize_event_pool(struct event_pool *pool,
+				 int size, struct ibmvscsi_host_data *hostdata)
+{
+	int i;
+
+	pool->size = size;
+	pool->next = 0;
+	pool->events = kmalloc(pool->size * sizeof(*pool->events), GFP_KERNEL);
+	if (!pool->events)
+		return -ENOMEM;
+	memset(pool->events, 0x00, pool->size * sizeof(*pool->events));
+
+	pool->iu_storage =
+	    dma_alloc_coherent(hostdata->dev,
+			       pool->size * sizeof(*pool->iu_storage),
+			       &pool->iu_token, 0);
+	if (!pool->iu_storage) {
+		kfree(pool->events);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < pool->size; ++i) {
+		struct srp_event_struct *evt = &pool->events[i];
+		memset(&evt->crq, 0x00, sizeof(evt->crq));
+		atomic_set(&evt->free, 1);
+		evt->crq.valid = 0x80;
+		evt->crq.IU_length = sizeof(*evt->xfer_iu);
+		evt->crq.IU_data_ptr = pool->iu_token + 
+			sizeof(*evt->xfer_iu) * i;
+		evt->xfer_iu = pool->iu_storage + i;
+		evt->hostdata = hostdata;
+	}
+
+	return 0;
+}
+
+/**
+ * release_event_pool: - Frees memory of an event pool of a host
+ * @pool:	event_pool to be released
+ * @hostdata:	ibmvscsi_host_data who owns the even pool
+ *
+ * Returns zero on success.
+*/
+static void release_event_pool(struct event_pool *pool,
+			       struct ibmvscsi_host_data *hostdata)
+{
+	int i, in_use = 0;
+	for (i = 0; i < pool->size; ++i)
+		if (atomic_read(&pool->events[i].free) != 1)
+			++in_use;
+	if (in_use)
+		printk(KERN_WARNING
+		       "ibmvscsi: releasing event pool with %d "
+		       "events still in use?\n", in_use);
+	kfree(pool->events);
+	dma_free_coherent(hostdata->dev,
+			  pool->size * sizeof(*pool->iu_storage),
+			  pool->iu_storage, pool->iu_token);
+}
+
+/**
+ * valid_event_struct: - Determines if event is valid.
+ * @pool:	event_pool that contains the event
+ * @evt:	srp_event_struct to be checked for validity
+ *
+ * Returns zero if event is invalid, one otherwise.
+*/
+static int valid_event_struct(struct event_pool *pool,
+				struct srp_event_struct *evt)
+{
+	int index = evt - pool->events;
+	if (index < 0 || index >= pool->size)	/* outside of bounds */
+		return 0;
+	if (evt != pool->events + index)	/* unaligned */
+		return 0;
+	return 1;
+}
+
+/**
+ * ibmvscsi_free-event_struct: - Changes status of event to "free"
+ * @pool:	event_pool that contains the event
+ * @evt:	srp_event_struct to be modified
+ *
+*/
+static void free_event_struct(struct event_pool *pool,
+				       struct srp_event_struct *evt)
+{
+	if (!valid_event_struct(pool, evt)) {
+		printk(KERN_ERR
+		       "ibmvscsi: Freeing invalid event_struct %p "
+		       "(not in pool %p)\n", evt, pool->events);
+		return;
+	}
+	if (atomic_inc_return(&evt->free) != 1) {
+		printk(KERN_ERR
+		       "ibmvscsi: Freeing event_struct %p "
+		       "which is not in use!\n", evt);
+		return;
+	}
+}
+
+/**
+ * get_evt_struct: - Gets the next free event in pool
+ * @pool:	event_pool that contains the events to be searched
+ *
+ * Returns the next event in "free" state, and NULL if none are free.
+ * Note that no synchronization is done here, we assume the host_lock
+ * will syncrhonze things.
+*/
+static struct srp_event_struct *get_event_struct(struct event_pool *pool)
+{
+	int i;
+	int poolsize = pool->size;
+	int offset = pool->next;
+
+	for (i = 0; i < poolsize; i++) {
+		offset = (offset + 1) % poolsize;
+		if (!atomic_dec_if_positive(&pool->events[offset].free)) {
+			pool->next = offset;
+			return &pool->events[offset];
+		}
+	}
+
+	printk(KERN_ERR "ibmvscsi: found no event struct in pool!\n");
+	return NULL;
+}
+
+/**
+ * init_event_struct: Initialize fields in an event struct that are always 
+ *                    required.
+ * @evt:        The event
+ * @done:       Routine to call when the event is responded to
+ * @format:     SRP or MAD format
+ * @timeout:    timeout value set in the CRQ
+ */
+static void init_event_struct(struct srp_event_struct *evt_struct,
+			      void (*done) (struct srp_event_struct *),
+			      u8 format,
+			      int timeout)
+{
+	evt_struct->cmnd = NULL;
+	evt_struct->cmnd_done = NULL;
+	evt_struct->crq.format = format;
+	evt_struct->crq.timeout = timeout;
+	evt_struct->done = done;
+}
+
+/* ------------------------------------------------------------
+ * Routines for receiving SCSI responses from the hosting partition
+ */
+
+/**
+ * set_srp_direction: Set the fields in the srp related to data
+ *     direction and number of buffers based on the direction in
+ *     the scsi_cmnd and the number of buffers
+ */
+static void set_srp_direction(struct scsi_cmnd *cmd,
+			      struct srp_cmd *srp_cmd, 
+			      int numbuf)
+{
+	if (numbuf == 0)
+		return;
+	
+	if (numbuf == 1) {
+		if (cmd->sc_data_direction == DMA_TO_DEVICE)
+			srp_cmd->data_out_format = SRP_DIRECT_BUFFER;
+		else 
+			srp_cmd->data_in_format = SRP_DIRECT_BUFFER;
+	} else {
+		if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+			srp_cmd->data_out_format = SRP_INDIRECT_BUFFER;
+			srp_cmd->data_out_count = numbuf;
+		} else {
+			srp_cmd->data_in_format = SRP_INDIRECT_BUFFER;
+			srp_cmd->data_in_count = numbuf;
+		}
+	}
+}
+
+/**
+ * unmap_cmd_data: - Unmap data pointed in srp_cmd based on the format
+ * @cmd:	srp_cmd whose additional_data member will be unmapped
+ * @dev:	device for which the memory is mapped
+ *
+*/
+static void unmap_cmd_data(struct srp_cmd *cmd, struct device *dev)
+{
+	int i;
+
+	if ((cmd->data_out_format == SRP_NO_BUFFER) &&
+	    (cmd->data_in_format == SRP_NO_BUFFER))
+		return;
+	else if ((cmd->data_out_format == SRP_DIRECT_BUFFER) ||
+		 (cmd->data_in_format == SRP_DIRECT_BUFFER)) {
+		struct memory_descriptor *data =
+			(struct memory_descriptor *)cmd->additional_data;
+		dma_unmap_single(dev, data->virtual_address, data->length,
+				 DMA_BIDIRECTIONAL);
+	} else {
+		struct indirect_descriptor *indirect =
+			(struct indirect_descriptor *)cmd->additional_data;
+		int num_mapped = indirect->head.length / 
+			sizeof(indirect->list[0]);
+		for (i = 0; i < num_mapped; ++i) {
+			struct memory_descriptor *data = &indirect->list[i];
+			dma_unmap_single(dev,
+					 data->virtual_address,
+					 data->length, DMA_BIDIRECTIONAL);
+		}
+	}
+}
+
+/**
+ * map_sg_data: - Maps dma for a scatterlist and initializes decriptor fields
+ * @cmd:	Scsi_Cmnd with the scatterlist
+ * @srp_cmd:	srp_cmd that contains the memory descriptor
+ * @dev:	device for which to map dma memory
+ *
+ * Called by map_data_for_srp_cmd() when building srp cmd from scsi cmd.
+ * Returns 1 on success.
+*/
+static int map_sg_data(struct scsi_cmnd *cmd,
+		       struct srp_cmd *srp_cmd, struct device *dev)
+{
+
+	int i, sg_mapped;
+	u64 total_length = 0;
+	struct scatterlist *sg = cmd->request_buffer;
+	struct memory_descriptor *data =
+	    (struct memory_descriptor *)srp_cmd->additional_data;
+	struct indirect_descriptor *indirect =
+	    (struct indirect_descriptor *)data;
+
+	sg_mapped = dma_map_sg(dev, sg, cmd->use_sg, DMA_BIDIRECTIONAL);
+
+	if (sg_mapped == 0)
+		return 0;
+
+	set_srp_direction(cmd, srp_cmd, sg_mapped);
+
+	/* special case; we can use a single direct descriptor */
+	if (sg_mapped == 1) {
+		data->virtual_address = sg_dma_address(&sg[0]);
+		data->length = sg_dma_len(&sg[0]);
+		data->memory_handle = 0;
+		return 1;
+	}
+
+	if (sg_mapped > MAX_INDIRECT_BUFS) {
+		printk(KERN_ERR
+		       "ibmvscsi: More than %d mapped sg entries, got %d\n",
+		       MAX_INDIRECT_BUFS, sg_mapped);
+		return 0;
+	}
+
+	indirect->head.virtual_address = 0;
+	indirect->head.length = sg_mapped * sizeof(indirect->list[0]);
+	indirect->head.memory_handle = 0;
+	for (i = 0; i < sg_mapped; ++i) {
+		struct memory_descriptor *descr = &indirect->list[i];
+		struct scatterlist *sg_entry = &sg[i];
+		descr->virtual_address = sg_dma_address(sg_entry);
+		descr->length = sg_dma_len(sg_entry);
+		descr->memory_handle = 0;
+		total_length += sg_dma_len(sg_entry);
+	}
+	indirect->total_length = total_length;
+
+	return 1;
+}
+
+/**
+ * map_single_data: - Maps memory and initializes memory decriptor fields
+ * @cmd:	struct scsi_cmnd with the memory to be mapped
+ * @srp_cmd:	srp_cmd that contains the memory descriptor
+ * @dev:	device for which to map dma memory
+ *
+ * Called by map_data_for_srp_cmd() when building srp cmd from scsi cmd.
+ * Returns 1 on success.
+*/
+static int map_single_data(struct scsi_cmnd *cmd,
+			   struct srp_cmd *srp_cmd, struct device *dev)
+{
+	struct memory_descriptor *data =
+	    (struct memory_descriptor *)srp_cmd->additional_data;
+
+	data->virtual_address =
+		dma_map_single(dev, cmd->request_buffer,
+			       cmd->request_bufflen,
+			       DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(data->virtual_address)) {
+		printk(KERN_ERR
+		       "ibmvscsi: Unable to map request_buffer for command!\n");
+		return 0;
+	}
+	data->length = cmd->request_bufflen;
+	data->memory_handle = 0;
+
+	set_srp_direction(cmd, srp_cmd, 1);
+
+	return 1;
+}
+
+/**
+ * map_data_for_srp_cmd: - Calls functions to map data for srp cmds
+ * @cmd:	struct scsi_cmnd with the memory to be mapped
+ * @srp_cmd:	srp_cmd that contains the memory descriptor
+ * @dev:	dma device for which to map dma memory
+ *
+ * Called by scsi_cmd_to_srp_cmd() when converting scsi cmds to srp cmds 
+ * Returns 1 on success.
+*/
+static int map_data_for_srp_cmd(struct scsi_cmnd *cmd,
+				struct srp_cmd *srp_cmd, struct device *dev)
+{
+	switch (cmd->sc_data_direction) {
+	case DMA_FROM_DEVICE:
+	case DMA_TO_DEVICE:
+		break;
+	case DMA_NONE:
+		return 1;
+	case DMA_BIDIRECTIONAL:
+		printk(KERN_ERR
+		       "ibmvscsi: Can't map DMA_BIDIRECTIONAL to read/write\n");
+		return 0;
+	default:
+		printk(KERN_ERR
+		       "ibmvscsi: Unknown data direction 0x%02x; can't map!\n",
+		       cmd->sc_data_direction);
+		return 0;
+	}
+
+	if (!cmd->request_buffer)
+		return 1;
+	if (cmd->use_sg)
+		return map_sg_data(cmd, srp_cmd, dev);
+	return map_single_data(cmd, srp_cmd, dev);
+}
+
+/* ------------------------------------------------------------
+ * Routines for sending and receiving SRPs
+ */
+/**
+ * ibmvscsi_send_srp_event: - Transforms event to u64 array and calls send_crq()
+ * @evt_struct:	evt_struct to be sent
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ * Returns the value returned from ibmvscsi_send_crq(). (Zero for success)
+ * Note that this routine assumes that host_lock is held for synchronization
+*/
+static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct,
+				   struct ibmvscsi_host_data *hostdata)
+{
+	struct scsi_cmnd *cmnd = evt_struct->cmnd;
+	u64 *crq_as_u64 = (u64 *) &evt_struct->crq;
+	int rc;
+
+	/* If we have exhausted our request limit, just fail this request.
+	 * Note that there are rare cases involving driver generated requests 
+	 * (such as task management requests) that the mid layer may think we
+	 * can handle more requests (can_queue) when we actually can't
+	 */
+	if ((evt_struct->crq.format == VIOSRP_SRP_FORMAT) &&
+	    (atomic_dec_if_positive(&hostdata->request_limit) < 0)) {
+		/* See if the adapter is disabled */
+		if (atomic_read(&hostdata->request_limit) < 0) {
+			if (cmnd)
+				cmnd->result = DID_ERROR << 16;
+			if (evt_struct->cmnd_done)
+				evt_struct->cmnd_done(cmnd);
+			unmap_cmd_data(&evt_struct->iu.srp.cmd,
+				       hostdata->dev);
+			free_event_struct(&hostdata->pool, evt_struct);
+			return 0;
+		} else {
+			printk("ibmvscsi: Warning, request_limit exceeded\n");
+			unmap_cmd_data(&evt_struct->iu.srp.cmd,
+				       hostdata->dev);
+			free_event_struct(&hostdata->pool, evt_struct);
+			return SCSI_MLQUEUE_HOST_BUSY;
+		}
+	}
+
+	/* Copy the IU into the transfer area */
+	*evt_struct->xfer_iu = evt_struct->iu;
+	evt_struct->xfer_iu->srp.generic.tag = (u64)evt_struct;
+
+	/* Add this to the sent list.  We need to do this 
+	 * before we actually send 
+	 * in case it comes back REALLY fast
+	 */
+	list_add_tail(&evt_struct->list, &hostdata->sent);
+
+	if ((rc =
+	     ibmvscsi_send_crq(hostdata, crq_as_u64[0], crq_as_u64[1])) != 0) {
+		list_del(&evt_struct->list);
+
+		cmnd = evt_struct->cmnd;
+		printk(KERN_ERR "ibmvscsi: failed to send event struct rc %d\n",
+		       rc);
+		unmap_cmd_data(&evt_struct->iu.srp.cmd, hostdata->dev);
+		free_event_struct(&hostdata->pool, evt_struct);
+		if (cmnd)
+			cmnd->result = DID_ERROR << 16;
+		if (evt_struct->cmnd_done)
+			evt_struct->cmnd_done(cmnd);
+	}
+
+	return 0;
+}
+
+/**
+ * handle_cmd_rsp: -  Handle responses from commands
+ * @evt_struct:	srp_event_struct to be handled
+ *
+ * Used as a callback by when sending scsi cmds.
+ * Gets called by ibmvscsi_handle_crq()
+*/
+static void handle_cmd_rsp(struct srp_event_struct *evt_struct)
+{
+	struct srp_rsp *rsp = &evt_struct->xfer_iu->srp.rsp;
+	struct scsi_cmnd *cmnd = evt_struct->cmnd;
+
+	if (cmnd) {
+		cmnd->result = rsp->status;
+		if (((cmnd->result >> 1) & 0x1f) == CHECK_CONDITION)
+			memcpy(cmnd->sense_buffer,
+			       rsp->sense_and_response_data,
+			       rsp->sense_data_list_length);
+		unmap_cmd_data(&evt_struct->iu.srp.cmd, 
+			       evt_struct->hostdata->dev);
+
+		if (rsp->doover)
+			cmnd->resid = rsp->data_out_residual_count;
+		else if (rsp->diover)
+			cmnd->resid = rsp->data_in_residual_count;
+	}
+
+	if (evt_struct->cmnd_done)
+		evt_struct->cmnd_done(cmnd);
+}
+
+/**
+ * lun_from_dev: - Returns the lun of the scsi device
+ * @dev:	struct scsi_device
+ *
+*/
+static inline u16 lun_from_dev(struct scsi_device *dev)
+{
+	return (0x2 << 14) | (dev->id << 8) | (dev->channel << 5) | dev->lun;
+}
+
+/**
+ * ibmvscsi_queue: - The queuecommand function of the scsi template 
+ * @cmd:	struct scsi_cmnd to be executed
+ * @done:	Callback function to be called when cmd is completed
+*/
+static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
+				 void (*done) (struct scsi_cmnd *))
+{
+	struct srp_cmd *srp_cmd;
+	struct srp_event_struct *evt_struct;
+	struct ibmvscsi_host_data *hostdata =
+		(struct ibmvscsi_host_data *)&cmnd->device->host->hostdata;
+	u16 lun = lun_from_dev(cmnd->device);
+
+	evt_struct = get_event_struct(&hostdata->pool);
+	if (!evt_struct)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	init_event_struct(evt_struct,
+			  handle_cmd_rsp,
+			  VIOSRP_SRP_FORMAT,
+			  cmnd->timeout);
+
+	evt_struct->cmnd = cmnd;
+	evt_struct->cmnd_done = done;
+
+	/* Set up the actual SRP IU */
+	srp_cmd = &evt_struct->iu.srp.cmd;
+	memset(srp_cmd, 0x00, sizeof(*srp_cmd));
+	srp_cmd->type = SRP_CMD_TYPE;
+	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(cmnd->cmnd));
+	srp_cmd->lun = ((u64) lun) << 48;
+
+	if (!map_data_for_srp_cmd(cmnd, srp_cmd, hostdata->dev)) {
+		printk(KERN_ERR "ibmvscsi: couldn't convert cmd to srp_cmd\n");
+		free_event_struct(&hostdata->pool, evt_struct);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	/* Fix up dma address of the buffer itself */
+	if ((srp_cmd->data_out_format == SRP_INDIRECT_BUFFER) ||
+	    (srp_cmd->data_in_format == SRP_INDIRECT_BUFFER)) {
+		struct indirect_descriptor *indirect =
+		    (struct indirect_descriptor *)srp_cmd->additional_data;
+		indirect->head.virtual_address = evt_struct->crq.IU_data_ptr +
+		    offsetof(struct srp_cmd, additional_data) +
+		    offsetof(struct indirect_descriptor, list);
+	}
+
+	return ibmvscsi_send_srp_event(evt_struct, hostdata);
+}
+
+/* ------------------------------------------------------------
+ * Routines for driver initialization
+ */
+/**
+ * adapter_info_rsp: - Handle response to MAD adapter info request
+ * @evt_struct:	srp_event_struct with the response
+ *
+ * Used as a "done" callback by when sending adapter_info. Gets called
+ * by ibmvscsi_handle_crq()
+*/
+static void adapter_info_rsp(struct srp_event_struct *evt_struct)
+{
+	struct ibmvscsi_host_data *hostdata = evt_struct->hostdata;
+	dma_unmap_single(hostdata->dev,
+			 evt_struct->iu.mad.adapter_info.buffer,
+			 evt_struct->iu.mad.adapter_info.common.length,
+			 DMA_BIDIRECTIONAL);
+
+	if (evt_struct->xfer_iu->mad.adapter_info.common.status) {
+		printk("ibmvscsi: error %d getting adapter info\n",
+		       evt_struct->xfer_iu->mad.adapter_info.common.status);
+	} else {
+		printk("ibmvscsi: host srp version: %s, "
+		       "host partition %s (%d), OS %d\n",
+		       hostdata->madapter_info.srp_version,
+		       hostdata->madapter_info.partition_name,
+		       hostdata->madapter_info.partition_number,
+		       hostdata->madapter_info.os_type);
+	}
+}
+
+/**
+ * send_mad_adapter_info: - Sends the mad adapter info request
+ *      and stores the result so it can be retrieved with
+ *      sysfs.  We COULD consider causing a failure if the
+ *      returned SRP version doesn't match ours.
+ * @hostdata:	ibmvscsi_host_data of host
+ * 
+ * Returns zero if successful.
+*/
+static void send_mad_adapter_info(struct ibmvscsi_host_data *hostdata)
+{
+	struct viosrp_adapter_info *req;
+	struct srp_event_struct *evt_struct;
+	
+	memset(&hostdata->madapter_info, 0x00, sizeof(hostdata->madapter_info));
+	
+	evt_struct = get_event_struct(&hostdata->pool);
+	if (!evt_struct) {
+		printk(KERN_ERR "ibmvscsi: couldn't allocate an event "
+		       "for ADAPTER_INFO_REQ!\n");
+		return;
+	}
+
+	init_event_struct(evt_struct,
+			  adapter_info_rsp,
+			  VIOSRP_MAD_FORMAT,
+			  init_timeout * HZ);
+	
+	req = &evt_struct->iu.mad.adapter_info;
+	memset(req, 0x00, sizeof(*req));
+	
+	req->common.type = VIOSRP_ADAPTER_INFO_TYPE;
+	req->common.length = sizeof(hostdata->madapter_info);
+	req->buffer = dma_map_single(hostdata->dev,
+				     &hostdata->madapter_info,
+				     sizeof(hostdata->madapter_info),
+				     DMA_BIDIRECTIONAL);
+
+	if (dma_mapping_error(req->buffer)) {
+		printk(KERN_ERR
+		       "ibmvscsi: Unable to map request_buffer "
+		       "for adapter_info!\n");
+		free_event_struct(&hostdata->pool, evt_struct);
+		return;
+	}
+	
+	if (ibmvscsi_send_srp_event(evt_struct, hostdata))
+		printk(KERN_ERR "ibmvscsi: couldn't send ADAPTER_INFO_REQ!\n");
+};
+
+/**
+ * login_rsp: - Handle response to SRP login request
+ * @evt_struct:	srp_event_struct with the response
+ *
+ * Used as a "done" callback by when sending srp_login. Gets called
+ * by ibmvscsi_handle_crq()
+*/
+static void login_rsp(struct srp_event_struct *evt_struct)
+{
+	struct ibmvscsi_host_data *hostdata = evt_struct->hostdata;
+	switch (evt_struct->xfer_iu->srp.generic.type) {
+	case SRP_LOGIN_RSP_TYPE:	/* it worked! */
+		break;
+	case SRP_LOGIN_REJ_TYPE:	/* refused! */
+		printk(KERN_INFO "ibmvscsi: SRP_LOGIN_REQ rejected\n");
+		/* Login failed.  */
+		atomic_set(&hostdata->request_limit, -1);
+		return;
+	default:
+		printk(KERN_ERR
+		       "ibmvscsi: Invalid login response typecode 0x%02x!\n",
+		       evt_struct->xfer_iu->srp.generic.type);
+		/* Login failed.  */
+		atomic_set(&hostdata->request_limit, -1);
+		return;
+	}
+
+	printk(KERN_INFO "ibmvscsi: SRP_LOGIN succeeded\n");
+
+	if (evt_struct->xfer_iu->srp.login_rsp.request_limit_delta >
+	    (max_requests - 2))
+		evt_struct->xfer_iu->srp.login_rsp.request_limit_delta =
+		    max_requests - 2;
+
+	/* Now we know what the real request-limit is */
+	atomic_set(&hostdata->request_limit,
+		   evt_struct->xfer_iu->srp.login_rsp.request_limit_delta);
+
+	hostdata->host->can_queue =
+	    evt_struct->xfer_iu->srp.login_rsp.request_limit_delta - 2;
+
+	if (hostdata->host->can_queue < 1) {
+		printk(KERN_ERR "ibmvscsi: Invalid request_limit_delta\n");
+		return;
+	}
+
+	send_mad_adapter_info(hostdata);
+	return;
+}
+
+/**
+ * send_srp_login: - Sends the srp login
+ * @hostdata:	ibmvscsi_host_data of host
+ * 
+ * Returns zero if successful.
+*/
+static int send_srp_login(struct ibmvscsi_host_data *hostdata)
+{
+	int rc;
+	unsigned long flags;
+	struct srp_login_req *login;
+	struct srp_event_struct *evt_struct = get_event_struct(&hostdata->pool);
+	if (!evt_struct) {
+		printk(KERN_ERR
+		       "ibmvscsi: couldn't allocate an event for login req!\n");
+		return FAILED;
+	}
+
+	init_event_struct(evt_struct,
+			  login_rsp,
+			  VIOSRP_SRP_FORMAT,
+			  init_timeout * HZ);
+
+	login = &evt_struct->iu.srp.login_req;
+	login->type = SRP_LOGIN_REQ_TYPE;
+	login->max_requested_initiator_to_target_iulen = sizeof(union srp_iu);
+	login->required_buffer_formats = 0x0006;
+	
+	/* Start out with a request limit of 1, since this is negotiated in
+	 * the login request we are just sending
+	 */
+	atomic_set(&hostdata->request_limit, 1);
+
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	return rc;
+};
+
+/**
+ * sync_completion: Signal that a synchronous command has completed
+ * Note that after returning from this call, the evt_struct is freed.
+ * the caller waiting on this completion shouldn't touch the evt_struct
+ * again.
+ */
+static void sync_completion(struct srp_event_struct *evt_struct)
+{
+	complete(&evt_struct->comp);
+}
+
+/**
+ * ibmvscsi_abort: Abort a command...from scsi host template
+ * send this over to the server and wait synchronously for the response
+ */
+static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
+{
+	struct ibmvscsi_host_data *hostdata =
+	    (struct ibmvscsi_host_data *)cmd->device->host->hostdata;
+	struct srp_tsk_mgmt *tsk_mgmt;
+	struct srp_event_struct *evt;
+	struct srp_event_struct *tmp_evt, *found_evt;
+	u16 lun = lun_from_dev(cmd->device);
+
+	/* First, find this command in our sent list so we can figure
+	 * out the correct tag
+	 */
+	found_evt = NULL;
+	list_for_each_entry(tmp_evt, &hostdata->sent, list) {
+		if (tmp_evt->cmnd == cmd) {
+			found_evt = tmp_evt;
+			break;
+		}
+	}
+
+	if (!found_evt) 
+		return FAILED;
+
+	evt = get_event_struct(&hostdata->pool);
+	if (evt == NULL) {
+		printk(KERN_ERR "ibmvscsi: failed to allocate abort event\n");
+		return FAILED;
+	}
+	
+	init_event_struct(evt,
+			  sync_completion,
+			  VIOSRP_SRP_FORMAT,
+			  init_timeout * HZ);
+
+	tsk_mgmt = &evt->iu.srp.tsk_mgmt;
+	
+	/* Set up an abort SRP command */
+	memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
+	tsk_mgmt->type = SRP_TSK_MGMT_TYPE;
+	tsk_mgmt->lun = ((u64) lun) << 48;
+	tsk_mgmt->task_mgmt_flags = 0x01;	/* ABORT TASK */
+	tsk_mgmt->managed_task_tag = (u64) found_evt;
+
+	printk(KERN_INFO "ibmvscsi: aborting command. lun 0x%lx, tag 0x%lx\n",
+	       tsk_mgmt->lun, tsk_mgmt->managed_task_tag);
+
+	init_completion(&evt->comp);
+	if (ibmvscsi_send_srp_event(evt, hostdata) != 0) {
+		printk(KERN_ERR "ibmvscsi: failed to send abort() event\n");
+		return FAILED;
+	}
+
+	spin_unlock_irq(hostdata->host->host_lock);
+	wait_for_completion(&evt->comp);
+	spin_lock_irq(hostdata->host->host_lock);
+
+	/* Because we dropped the spinlock above, it's possible
+	 * The event is no longer in our list.  Make sure it didn't
+	 * complete while we were aborting
+	 */
+	found_evt = NULL;
+	list_for_each_entry(tmp_evt, &hostdata->sent, list) {
+		if (tmp_evt->cmnd == cmd) {
+			found_evt = tmp_evt;
+			break;
+		}
+	}
+
+	printk(KERN_INFO
+	       "ibmvscsi: successfully aborted task tag 0x%lx\n",
+	       tsk_mgmt->managed_task_tag);
+
+	if (found_evt == NULL)
+		return SUCCESS;
+
+	cmd->result = (DID_ABORT << 16);
+	list_del(&found_evt->list);
+	unmap_cmd_data(&found_evt->iu.srp.cmd, found_evt->hostdata->dev);
+	free_event_struct(&found_evt->hostdata->pool, found_evt);
+	atomic_inc(&hostdata->request_limit);
+	return SUCCESS;
+}
+
+/**
+ * ibmvscsi_eh_device_reset_handler: Reset a single LUN...from scsi host 
+ * template send this over to the server and wait synchronously for the 
+ * response
+ */
+static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
+{
+	struct ibmvscsi_host_data *hostdata =
+	    (struct ibmvscsi_host_data *)cmd->device->host->hostdata;
+
+	struct srp_tsk_mgmt *tsk_mgmt;
+	struct srp_event_struct *evt;
+	struct srp_event_struct *tmp_evt, *pos;
+	u16 lun = lun_from_dev(cmd->device);
+
+	evt = get_event_struct(&hostdata->pool);
+	if (evt == NULL) {
+		printk(KERN_ERR "ibmvscsi: failed to allocate reset event\n");
+		return FAILED;
+	}
+	
+	init_event_struct(evt,
+			  sync_completion,
+			  VIOSRP_SRP_FORMAT,
+			  init_timeout * HZ);
+
+	tsk_mgmt = &evt->iu.srp.tsk_mgmt;
+
+	/* Set up a lun reset SRP command */
+	memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
+	tsk_mgmt->type = SRP_TSK_MGMT_TYPE;
+	tsk_mgmt->lun = ((u64) lun) << 48;
+	tsk_mgmt->task_mgmt_flags = 0x08;	/* LUN RESET */
+
+	printk(KERN_INFO "ibmvscsi: resetting device. lun 0x%lx\n",
+	       tsk_mgmt->lun);
+
+	init_completion(&evt->comp);
+	if (ibmvscsi_send_srp_event(evt, hostdata) != 0) {
+		printk(KERN_ERR "ibmvscsi: failed to send reset event\n");
+		return FAILED;
+	}
+
+	spin_unlock_irq(hostdata->host->host_lock);
+	wait_for_completion(&evt->comp);
+	spin_lock_irq(hostdata->host->host_lock);
+
+	/* We need to find all commands for this LUN that have not yet been
+	 * responded to, and fail them with DID_RESET
+	 */
+	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
+		if ((tmp_evt->cmnd) && (tmp_evt->cmnd->device == cmd->device)) {
+			if (tmp_evt->cmnd)
+				tmp_evt->cmnd->result = (DID_RESET << 16);
+			list_del(&tmp_evt->list);
+			unmap_cmd_data(&tmp_evt->iu.srp.cmd, tmp_evt->hostdata->dev);
+			free_event_struct(&tmp_evt->hostdata->pool,
+						   tmp_evt);
+			atomic_inc(&hostdata->request_limit);
+			if (tmp_evt->cmnd_done)
+				tmp_evt->cmnd_done(tmp_evt->cmnd);
+			else if (tmp_evt->done)
+				tmp_evt->done(tmp_evt);
+		}
+	}
+	return SUCCESS;
+}
+
+/**
+ * purge_requests: Our virtual adapter just shut down.  purge any sent requests
+ * @hostdata:    the adapter
+ */
+static void purge_requests(struct ibmvscsi_host_data *hostdata)
+{
+	struct srp_event_struct *tmp_evt, *pos;
+	unsigned long flags;
+
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
+	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
+		list_del(&tmp_evt->list);
+		if (tmp_evt->cmnd) {
+			tmp_evt->cmnd->result = (DID_ERROR << 16);
+			unmap_cmd_data(&tmp_evt->iu.srp.cmd, 
+				       tmp_evt->hostdata->dev);
+			if (tmp_evt->cmnd_done)
+				tmp_evt->cmnd_done(tmp_evt->cmnd);
+		} else {
+			if (tmp_evt->done) {
+				tmp_evt->done(tmp_evt);
+			}
+		}
+		free_event_struct(&tmp_evt->hostdata->pool, tmp_evt);
+	}
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+}
+
+/**
+ * ibmvscsi_handle_crq: - Handles and frees received events in the CRQ
+ * @crq:	Command/Response queue
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+*/
+void ibmvscsi_handle_crq(struct viosrp_crq *crq,
+			 struct ibmvscsi_host_data *hostdata)
+{
+	unsigned long flags;
+	struct srp_event_struct *evt_struct =
+	    (struct srp_event_struct *)crq->IU_data_ptr;
+	switch (crq->valid) {
+	case 0xC0:		/* initialization */
+		switch (crq->format) {
+		case 0x01:	/* Initialization message */
+			printk(KERN_INFO "ibmvscsi: partner initialized\n");
+			/* Send back a response */
+			if (ibmvscsi_send_crq(hostdata,
+					      0xC002000000000000LL, 0) == 0) {
+				/* Now login */
+				send_srp_login(hostdata);
+			} else {
+				printk(KERN_ERR
+				       "ibmvscsi: Unable to send init rsp\n");
+			}
+
+			break;
+		case 0x02:	/* Initialization response */
+			printk(KERN_INFO
+			       "ibmvscsi: partner initialization complete\n");
+
+			/* Now login */
+			send_srp_login(hostdata);
+			break;
+		default:
+			printk(KERN_ERR "ibmvscsi: unknown crq message type\n");
+		}
+		return;
+	case 0xFF:		/* Hypervisor telling us the connection is closed */
+		printk(KERN_INFO "ibmvscsi: Virtual adapter failed!\n");
+
+		atomic_set(&hostdata->request_limit, -1);
+		purge_requests(hostdata);
+		ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
+		return;
+	case 0x80:		/* real payload */
+		break;
+	default:
+		printk(KERN_ERR
+		       "ibmvscsi: got an invalid message type 0x%02x\n",
+		       crq->valid);
+		return;
+	}
+
+	/* The only kind of payload CRQs we should get are responses to
+	 * things we send. Make sure this response is to something we
+	 * actually sent
+	 */
+	if (!valid_event_struct(&hostdata->pool, evt_struct)) {
+		printk(KERN_ERR
+		       "ibmvscsi: returned correlation_token 0x%p is invalid!\n",
+		       (void *)crq->IU_data_ptr);
+		return;
+	}
+
+	if (crq->format == VIOSRP_SRP_FORMAT)
+		atomic_add(evt_struct->xfer_iu->srp.rsp.request_limit_delta,
+			   &hostdata->request_limit);
+
+	if (evt_struct->done)
+		evt_struct->done(evt_struct);
+	else
+		printk(KERN_ERR
+		       "ibmvscsi: returned done() is NULL; not running it!\n");
+
+	/*
+	 * Lock the host_lock before messing with these structures, since we
+	 * are running in a task context
+	 */
+	spin_lock_irqsave(evt_struct->hostdata->host->host_lock, flags);
+	list_del(&evt_struct->list);
+	free_event_struct(&evt_struct->hostdata->pool, evt_struct);
+	spin_unlock_irqrestore(evt_struct->hostdata->host->host_lock, flags);
+}
+
+/**
+ * ibmvscsi_get_host_config: Send the command to the server to get host
+ * configuration data.  The data is opaque to us.
+ */
+static int ibmvscsi_do_host_config(struct ibmvscsi_host_data *hostdata,
+				   unsigned char *buffer, int length)
+{
+	struct viosrp_host_config *host_config;
+	struct srp_event_struct *evt_struct;
+	int rc;
+
+	evt_struct = get_event_struct(&hostdata->pool);
+	if (!evt_struct) {
+		printk(KERN_ERR
+		       "ibmvscsi: could't allocate event for HOST_CONFIG!\n");
+		return -1;
+	}
+
+	init_event_struct(evt_struct,
+			  sync_completion,
+			  VIOSRP_MAD_FORMAT,
+			  init_timeout * HZ);
+
+	host_config = &evt_struct->iu.mad.host_config;
+
+	/* Set up a lun reset SRP command */
+	memset(host_config, 0x00, sizeof(*host_config));
+	host_config->common.type = VIOSRP_HOST_CONFIG_TYPE;
+	host_config->common.length = length;
+	host_config->buffer = dma_map_single(hostdata->dev, buffer, length,
+					    DMA_BIDIRECTIONAL);
+
+	if (dma_mapping_error(host_config->buffer)) {
+		printk(KERN_ERR
+		       "ibmvscsi: dma_mapping error " "getting host config\n");
+		free_event_struct(&hostdata->pool, evt_struct);
+		return -1;
+	}
+
+	init_completion(&evt_struct->comp);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata);
+	if (rc == 0) {
+		wait_for_completion(&evt_struct->comp);
+		dma_unmap_single(hostdata->dev, host_config->buffer,
+				 length, DMA_BIDIRECTIONAL);
+	}
+
+	return rc;
+}
+
+/* ------------------------------------------------------------
+ * sysfs attributes
+ */
+static ssize_t show_host_srp_version(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ibmvscsi_host_data *hostdata =
+	    (struct ibmvscsi_host_data *)shost->hostdata;
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "%s\n",
+		       hostdata->madapter_info.srp_version);
+	return len;
+}
+
+static struct class_device_attribute ibmvscsi_host_srp_version = {
+	.attr = {
+		 .name = "srp_version",
+		 .mode = S_IRUGO,
+		 },
+	.show = show_host_srp_version,
+};
+
+static ssize_t show_host_partition_name(struct class_device *class_dev,
+					char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ibmvscsi_host_data *hostdata =
+	    (struct ibmvscsi_host_data *)shost->hostdata;
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "%s\n",
+		       hostdata->madapter_info.partition_name);
+	return len;
+}
+
+static struct class_device_attribute ibmvscsi_host_partition_name = {
+	.attr = {
+		 .name = "partition_name",
+		 .mode = S_IRUGO,
+		 },
+	.show = show_host_partition_name,
+};
+
+static ssize_t show_host_partition_number(struct class_device *class_dev,
+					  char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ibmvscsi_host_data *hostdata =
+	    (struct ibmvscsi_host_data *)shost->hostdata;
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "%d\n",
+		       hostdata->madapter_info.partition_number);
+	return len;
+}
+
+static struct class_device_attribute ibmvscsi_host_partition_number = {
+	.attr = {
+		 .name = "partition_number",
+		 .mode = S_IRUGO,
+		 },
+	.show = show_host_partition_number,
+};
+
+static ssize_t show_host_mad_version(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ibmvscsi_host_data *hostdata =
+	    (struct ibmvscsi_host_data *)shost->hostdata;
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "%d\n",
+		       hostdata->madapter_info.mad_version);
+	return len;
+}
+
+static struct class_device_attribute ibmvscsi_host_mad_version = {
+	.attr = {
+		 .name = "mad_version",
+		 .mode = S_IRUGO,
+		 },
+	.show = show_host_mad_version,
+};
+
+static ssize_t show_host_os_type(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ibmvscsi_host_data *hostdata =
+	    (struct ibmvscsi_host_data *)shost->hostdata;
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "%d\n", hostdata->madapter_info.os_type);
+	return len;
+}
+
+static struct class_device_attribute ibmvscsi_host_os_type = {
+	.attr = {
+		 .name = "os_type",
+		 .mode = S_IRUGO,
+		 },
+	.show = show_host_os_type,
+};
+
+static ssize_t show_host_config(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ibmvscsi_host_data *hostdata =
+	    (struct ibmvscsi_host_data *)shost->hostdata;
+
+	/* returns null-terminated host config data */
+	if (ibmvscsi_do_host_config(hostdata, buf, PAGE_SIZE) == 0)
+		return strlen(buf);
+	else
+		return 0;
+}
+
+static struct class_device_attribute ibmvscsi_host_config = {
+	.attr = {
+		 .name = "config",
+		 .mode = S_IRUGO,
+		 },
+	.show = show_host_config,
+};
+
+static struct class_device_attribute *ibmvscsi_attrs[] = {
+	&ibmvscsi_host_srp_version,
+	&ibmvscsi_host_partition_name,
+	&ibmvscsi_host_partition_number,
+	&ibmvscsi_host_mad_version,
+	&ibmvscsi_host_os_type,
+	&ibmvscsi_host_config,
+	NULL
+};
+
+/* ------------------------------------------------------------
+ * SCSI driver registration
+ */
+static struct scsi_host_template driver_template = {
+	.module = THIS_MODULE,
+	.name = "IBM POWER Virtual SCSI Adapter " IBMVSCSI_VERSION,
+	.proc_name = "ibmvscsi",
+	.queuecommand = ibmvscsi_queuecommand,
+	.eh_abort_handler = ibmvscsi_eh_abort_handler,
+	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
+	.cmd_per_lun = 16,
+	.can_queue = 1,		/* Updated after SRP_LOGIN */
+	.this_id = -1,
+	.sg_tablesize = MAX_INDIRECT_BUFS,
+	.use_clustering = ENABLE_CLUSTERING,
+	.shost_attrs = ibmvscsi_attrs,
+};
+
+/**
+ * Called by bus code for each adapter
+ */
+static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
+{
+	struct ibmvscsi_host_data *hostdata;
+	struct Scsi_Host *host;
+	struct device *dev = &vdev->dev;
+	unsigned long wait_switch = 0;
+
+	vdev->dev.driver_data = NULL;
+
+	host = scsi_host_alloc(&driver_template, sizeof(*hostdata));
+	if (!host) {
+		printk(KERN_ERR "ibmvscsi: couldn't allocate host data\n");
+		goto scsi_host_alloc_failed;
+	}
+
+	hostdata = (struct ibmvscsi_host_data *)host->hostdata;
+	memset(hostdata, 0x00, sizeof(*hostdata));
+	INIT_LIST_HEAD(&hostdata->sent);
+	hostdata->host = host;
+	hostdata->dev = dev;
+	atomic_set(&hostdata->request_limit, -1);
+
+	if (ibmvscsi_init_crq_queue(&hostdata->queue, hostdata,
+				    max_requests) != 0) {
+		printk(KERN_ERR "ibmvscsi: couldn't initialize crq\n");
+		goto init_crq_failed;
+	}
+	if (initialize_event_pool(&hostdata->pool, max_requests, hostdata) != 0) {
+		printk(KERN_ERR "ibmvscsi: couldn't initialize event pool\n");
+		goto init_pool_failed;
+	}
+
+	host->max_lun = 8;
+	host->max_id = max_id;
+	host->max_channel = max_channel;
+
+	if (scsi_add_host(hostdata->host, hostdata->dev))
+		goto add_host_failed;
+
+	/* Try to send an initialization message.  Note that this is allowed
+	 * to fail if the other end is not acive.  In that case we don't
+	 * want to scan
+	 */
+	if (ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0) == 0) {
+		/*
+		 * Wait around max init_timeout secs for the adapter to finish
+		 * initializing. When we are done initializing, we will have a
+		 * valid request_limit.  We don't want Linux scanning before
+		 * we are ready.
+		 */
+		for (wait_switch = jiffies + (init_timeout * HZ);
+		     time_before(jiffies, wait_switch) &&
+		     atomic_read(&hostdata->request_limit) < 0;) {
+
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(HZ / 100);
+		}
+
+		/* if we now have a valid request_limit, initiate a scan */
+		if (atomic_read(&hostdata->request_limit) > 0)
+			scsi_scan_host(host);
+	}
+
+	vdev->dev.driver_data = hostdata;
+	return 0;
+
+      add_host_failed:
+	release_event_pool(&hostdata->pool, hostdata);
+      init_pool_failed:
+	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata, max_requests);
+      init_crq_failed:
+	scsi_host_put(host);
+      scsi_host_alloc_failed:
+	return -1;
+}
+
+static int ibmvscsi_remove(struct vio_dev *vdev)
+{
+	struct ibmvscsi_host_data *hostdata = vdev->dev.driver_data;
+	release_event_pool(&hostdata->pool, hostdata);
+	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
+				   max_requests);
+	
+	scsi_remove_host(hostdata->host);
+	scsi_host_put(hostdata->host);
+
+	return 0;
+}
+
+/**
+ * ibmvscsi_device_table: Used by vio.c to match devices in the device tree we 
+ * support.
+ */
+static struct vio_device_id ibmvscsi_device_table[] __devinitdata = {
+	{"vscsi", "IBM,v-scsi"},
+	{0,}
+};
+
+MODULE_DEVICE_TABLE(vio, ibmvscsi_device_table);
+static struct vio_driver ibmvscsi_driver = {
+	.name = "ibmvscsi",
+	.id_table = ibmvscsi_device_table,
+	.probe = ibmvscsi_probe,
+	.remove = ibmvscsi_remove
+};
+
+int __init ibmvscsi_module_init(void)
+{
+	return vio_register_driver(&ibmvscsi_driver);
+}
+
+void __exit ibmvscsi_module_exit(void)
+{
+	vio_unregister_driver(&ibmvscsi_driver);
+}
+
+module_init(ibmvscsi_module_init);
+module_exit(ibmvscsi_module_exit);
diff -uNr --exclude=SCCS linux-2.6-pure/drivers/scsi/ibmvscsi/ibmvscsi.h linux-2.6b-tmp1/drivers/scsi/ibmvscsi/ibmvscsi.h
--- linux-2.6-pure/drivers/scsi/ibmvscsi/ibmvscsi.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6b-tmp1/drivers/scsi/ibmvscsi/ibmvscsi.h	2004-07-16 17:50:35.537931320 -0500
@@ -0,0 +1,108 @@
+/* ------------------------------------------------------------
+ * ibmvscsi.h
+ * (C) Copyright IBM Corporation 1994, 2003
+ * Authors: Colin DeVilbiss (devilbis@us.ibm.com)
+ *          Santiago Leon (santil@us.ibm.com)
+ *          Dave Boutcher (sleddog@us.ibm.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ * ------------------------------------------------------------
+ * Emulation of a SCSI host adapter for Virtual I/O devices
+ *
+ * This driver allows the Linux SCSI peripheral drivers to directly
+ * access devices in the hosting partition, either on an iSeries
+ * hypervisor system or a converged hypervisor system.
+ */
+#ifndef IBMVSCSI_H
+#define IBMVSCSI_H
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/completion.h>
+#include <linux/interrupt.h>
+#include "viosrp.h"
+
+struct scsi_cmnd;
+struct Scsi_Host;
+
+/* Number of indirect bufs...the list of these has to fit in the
+ * additional data of the srp_cmd struct along with the indirect
+ * descriptor
+ */
+#define MAX_INDIRECT_BUFS 10
+
+/* ------------------------------------------------------------
+ * Data Structures
+ */
+/* an RPA command/response transport queue */
+struct crq_queue {
+	struct viosrp_crq *msgs;
+	int size, cur;
+	dma_addr_t msg_token;
+	spinlock_t lock;
+};
+
+/* a unit of work for the hosting partition */
+struct srp_event_struct {
+	union viosrp_iu *xfer_iu;
+	struct scsi_cmnd *cmnd;
+	struct list_head list;
+	void (*done) (struct srp_event_struct *);
+	struct viosrp_crq crq;
+	struct ibmvscsi_host_data *hostdata;
+	atomic_t free;
+	union viosrp_iu iu;
+	void (*cmnd_done) (struct scsi_cmnd *);
+	struct completion comp;
+};
+
+/* a pool of event structs for use */
+struct event_pool {
+	struct srp_event_struct *events;
+	u32 size;
+	int next;
+	union viosrp_iu *iu_storage;
+	dma_addr_t iu_token;
+};
+
+/* all driver data associated with a host adapter */
+struct ibmvscsi_host_data {
+	atomic_t request_limit;
+	struct device *dev;
+	struct event_pool pool;
+	struct crq_queue queue;
+	struct tasklet_struct srp_task;
+	struct list_head sent;
+	struct Scsi_Host *host;
+	struct mad_adapter_info_data madapter_info;
+};
+
+/* routines for managing a command/response queue */
+int ibmvscsi_init_crq_queue(struct crq_queue *queue,
+			    struct ibmvscsi_host_data *hostdata,
+			    int max_requests);
+void ibmvscsi_release_crq_queue(struct crq_queue *queue,
+				struct ibmvscsi_host_data *hostdata,
+				int max_requests);
+void ibmvscsi_reset_crq_queue(struct crq_queue *queue,
+			      struct ibmvscsi_host_data *hostdata);
+
+void ibmvscsi_handle_crq(struct viosrp_crq *crq,
+			 struct ibmvscsi_host_data *hostdata);
+int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata,
+		      u64 word1, u64 word2);
+
+#endif				/* IBMVSCSI_H */
diff -uNr --exclude=SCCS linux-2.6-pure/drivers/scsi/ibmvscsi/iseries_vscsi.c linux-2.6b-tmp1/drivers/scsi/ibmvscsi/iseries_vscsi.c
--- linux-2.6-pure/drivers/scsi/ibmvscsi/iseries_vscsi.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6b-tmp1/drivers/scsi/ibmvscsi/iseries_vscsi.c	2004-07-16 17:50:36.130976336 -0500
@@ -0,0 +1,144 @@
+/* ------------------------------------------------------------
+ * iSeries_vscsi.c
+ * (C) Copyright IBM Corporation 1994, 2003
+ * Authors: Colin DeVilbiss (devilbis@us.ibm.com)
+ *          Santiago Leon (santil@us.ibm.com)
+ *          Dave Boutcher (sleddog@us.ibm.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ * ------------------------------------------------------------
+ * iSeries-specific functions of the SCSI host adapter for Virtual I/O devices
+ *
+ * This driver allows the Linux SCSI peripheral drivers to directly
+ * access devices in the hosting partition, either on an iSeries
+ * hypervisor system or a converged hypervisor system.
+ */
+
+#include <asm/iSeries/vio.h>
+#include <asm/iSeries/HvLpEvent.h>
+#include <asm/iSeries/HvTypes.h>
+#include <asm/iSeries/HvLpConfig.h>
+#include <asm/vio.h>
+#include <linux/device.h>
+#include "ibmvscsi.h"
+
+/* global variables */
+static struct ibmvscsi_host_data *single_host_data;
+
+/* ------------------------------------------------------------
+ * Routines for direct interpartition interaction
+ */
+struct srp_lp_event {
+	struct HvLpEvent lpevt;	/* 0x00-0x17          */
+	u32 reserved1;		/* 0x18-0x1B; unused  */
+	u16 version;		/* 0x1C-0x1D; unused  */
+	u16 subtype_rc;		/* 0x1E-0x1F; unused  */
+	struct viosrp_crq crq;	/* 0x20-0x3F          */
+};
+
+/** 
+ * standard interface for handling logical partition events.
+ */
+static void ibmvscsi_handle_event(struct HvLpEvent *lpevt)
+{
+	struct srp_lp_event *evt = (struct srp_lp_event *)lpevt;
+
+	if (!evt) {
+		printk(KERN_ERR "ibmvscsi: received null event\n");
+		return;
+	}
+
+	if (single_host_data == NULL) {
+		printk(KERN_ERR
+		       "ibmvscsi: received event, no adapter present\n");
+		return;
+	}
+
+	ibmvscsi_handle_crq(&evt->crq, single_host_data);
+}
+
+/* ------------------------------------------------------------
+ * Routines for driver initialization
+ */
+int ibmvscsi_init_crq_queue(struct crq_queue *queue,
+			    struct ibmvscsi_host_data *hostdata,
+			    int max_requests)
+{
+	int rc;
+
+	single_host_data = hostdata;
+	rc = viopath_open(viopath_hostLp, viomajorsubtype_scsi, 0);
+	if (rc < 0) {
+		printk("viopath_open failed with rc %d in open_event_path\n",
+		       rc);
+		goto viopath_open_failed;
+	}
+
+	rc = vio_setHandler(viomajorsubtype_scsi, ibmvscsi_handle_event);
+	if (rc < 0) {
+		printk("vio_setHandler failed with rc %d in open_event_path\n",
+		       rc);
+		goto vio_setHandler_failed;
+	}
+	return 0;
+
+      vio_setHandler_failed:
+	viopath_close(viopath_hostLp, viomajorsubtype_scsi, max_requests);
+      viopath_open_failed:
+	return -1;
+}
+
+void ibmvscsi_release_crq_queue(struct crq_queue *queue,
+				struct ibmvscsi_host_data *hostdata,
+				int max_requests)
+{
+	vio_clearHandler(viomajorsubtype_scsi);
+	viopath_close(viopath_hostLp, viomajorsubtype_scsi, max_requests);
+}
+
+/**
+ * reset_crq_queue: - resets a crq after a failure
+ * @queue:	crq_queue to initialize and register
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ * no-op for iSeries
+ */
+void ibmvscsi_reset_crq_queue(struct crq_queue *queue,
+			      struct ibmvscsi_host_data *hostdata)
+{
+}
+
+/**
+ * ibmvscsi_send_crq: - Send a CRQ
+ * @hostdata:	the adapter
+ * @word1:	the first 64 bits of the data
+ * @word2:	the second 64 bits of the data
+ */
+int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata, u64 word1, u64 word2)
+{
+	single_host_data = hostdata;
+	return HvCallEvent_signalLpEventFast(viopath_hostLp,
+					     HvLpEvent_Type_VirtualIo,
+					     viomajorsubtype_scsi,
+					     HvLpEvent_AckInd_NoAck,
+					     HvLpEvent_AckType_ImmediateAck,
+					     viopath_sourceinst(viopath_hostLp),
+					     viopath_targetinst(viopath_hostLp),
+					     0,
+					     VIOVERSION << 16, word1, word2, 0,
+					     0);
+}
diff -uNr --exclude=SCCS linux-2.6-pure/drivers/scsi/ibmvscsi/Makefile linux-2.6b-tmp1/drivers/scsi/ibmvscsi/Makefile
--- linux-2.6-pure/drivers/scsi/ibmvscsi/Makefile	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6b-tmp1/drivers/scsi/ibmvscsi/Makefile	2004-07-16 17:50:35.449944696 -0500
@@ -0,0 +1,5 @@
+obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsic.o
+
+ibmvscsic-y			+= ibmvscsi.o
+ibmvscsic-$(CONFIG_PPC_ISERIES)	+= iseries_vscsi.o 
+ibmvscsic-$(CONFIG_PPC_PSERIES)	+= rpa_vscsi.o 
diff -uNr --exclude=SCCS linux-2.6-pure/drivers/scsi/ibmvscsi/rpa_vscsi.c linux-2.6b-tmp1/drivers/scsi/ibmvscsi/rpa_vscsi.c
--- linux-2.6-pure/drivers/scsi/ibmvscsi/rpa_vscsi.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6b-tmp1/drivers/scsi/ibmvscsi/rpa_vscsi.c	2004-07-16 17:50:36.141974664 -0500
@@ -0,0 +1,260 @@
+/* ------------------------------------------------------------
+ * rpa_vscsi.c
+ * (C) Copyright IBM Corporation 1994, 2003
+ * Authors: Colin DeVilbiss (devilbis@us.ibm.com)
+ *          Santiago Leon (santil@us.ibm.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ * ------------------------------------------------------------
+ * RPA-specific functions of the SCSI host adapter for Virtual I/O devices
+ *
+ * This driver allows the Linux SCSI peripheral drivers to directly
+ * access devices in the hosting partition, either on an iSeries
+ * hypervisor system or a converged hypervisor system.
+ */
+
+#include <asm/vio.h>
+#include <asm/iommu.h>
+#include <asm/hvcall.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include "ibmvscsi.h"
+
+/* ------------------------------------------------------------
+ * Routines for managing the command/response queue
+ */
+/**
+ * ibmvscsi_handle_event: - Interrupt handler for crq events
+ * @irq:	number of irq to handle, not used
+ * @dev_instance: ibmvscsi_host_data of host that received interrupt
+ * @regs:	pt_regs with registers
+ *
+ * Disables interrupts and schedules srp_task
+ * Always returns IRQ_HANDLED
+ */
+static irqreturn_t ibmvscsi_handle_event(int irq,
+					 void *dev_instance,
+					 struct pt_regs *regs)
+{
+	struct ibmvscsi_host_data *hostdata =
+	    (struct ibmvscsi_host_data *)dev_instance;
+	vio_disable_interrupts(to_vio_dev(hostdata->dev));
+	tasklet_schedule(&hostdata->srp_task);
+	return IRQ_HANDLED;
+}
+
+/**
+ * release_crq_queue: - Deallocates data and unregisters CRQ
+ * @queue:	crq_queue to initialize and register
+ * @host_data:	ibmvscsi_host_data of host
+ *
+ * Frees irq, deallocates a page for messages, unmaps dma, and unregisters
+ * the crq with the hypervisor.
+ */
+void ibmvscsi_release_crq_queue(struct crq_queue *queue,
+				struct ibmvscsi_host_data *hostdata,
+				int max_requests)
+{
+	long rc;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+	free_irq(vdev->irq, (void *)hostdata);
+	tasklet_kill(&hostdata->srp_task);
+	do {
+		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
+	} while ((rc == H_Busy) || (H_isLongBusy(rc)));
+	dma_unmap_single(hostdata->dev,
+			 queue->msg_token,
+			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
+	free_page((unsigned long)queue->msgs);
+}
+
+/**
+ * crq_queue_next_crq: - Returns the next entry in message queue
+ * @queue:	crq_queue to use
+ *
+ * Returns pointer to next entry in queue, or NULL if there are no new 
+ * entried in the CRQ.
+ */
+static struct viosrp_crq *crq_queue_next_crq(struct crq_queue *queue)
+{
+	struct viosrp_crq *crq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->lock, flags);
+	crq = &queue->msgs[queue->cur];
+	if (crq->valid & 0x80) {
+		if (++queue->cur == queue->size)
+			queue->cur = 0;
+	} else
+		crq = NULL;
+	spin_unlock_irqrestore(&queue->lock, flags);
+
+	return crq;
+}
+
+/**
+ * ibmvscsi_send_crq: - Send a CRQ
+ * @hostdata:	the adapter
+ * @word1:	the first 64 bits of the data
+ * @word2:	the second 64 bits of the data
+ */
+int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata, u64 word1, u64 word2)
+{
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+
+	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
+}
+
+/**
+ * ibmvscsi_task: - Process srps asynchronously
+ * @data:	ibmvscsi_host_data of host
+ */
+static void ibmvscsi_task(void *data)
+{
+	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)data;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+	struct viosrp_crq *crq;
+	int done = 0;
+
+	while (!done) {
+		/* Pull all the valid messages off the CRQ */
+		while ((crq = crq_queue_next_crq(&hostdata->queue)) != NULL) {
+			ibmvscsi_handle_crq(crq, hostdata);
+			crq->valid = 0x00;
+		}
+
+		vio_enable_interrupts(vdev);
+		if ((crq = crq_queue_next_crq(&hostdata->queue)) != NULL) {
+			vio_disable_interrupts(vdev);
+			ibmvscsi_handle_crq(crq, hostdata);
+			crq->valid = 0x00;
+		} else {
+			done = 1;
+		}
+	}
+}
+
+/**
+ * initialize_crq_queue: - Initializes and registers CRQ with hypervisor
+ * @queue:	crq_queue to initialize and register
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ * Allocates a page for messages, maps it for dma, and registers
+ * the crq with the hypervisor.
+ * Returns zero on success.
+ */
+int ibmvscsi_init_crq_queue(struct crq_queue *queue,
+			    struct ibmvscsi_host_data *hostdata,
+			    int max_requests)
+{
+	int rc;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+
+	queue->msgs = (struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
+
+	if (!queue->msgs)
+		goto malloc_failed;
+	queue->size = PAGE_SIZE / sizeof(*queue->msgs);
+
+	queue->msg_token = dma_map_single(hostdata->dev, queue->msgs,
+					  queue->size * sizeof(*queue->msgs),
+					  DMA_BIDIRECTIONAL);
+
+	if (dma_mapping_error(queue->msg_token))
+		goto map_failed;
+
+	rc = plpar_hcall_norets(H_REG_CRQ,
+				vdev->unit_address,
+				queue->msg_token, PAGE_SIZE);
+	if (rc == 2) {
+		/* Adapter is good, but other end is not ready */
+		printk(KERN_WARNING "ibmvscsi: Partner adapter not ready\n");
+	} else if (rc != 0) {
+		printk(KERN_WARNING "ibmvscsi: Error %d opening adapter\n", rc);
+		goto reg_crq_failed;
+	}
+
+	if (request_irq(vdev->irq,
+			ibmvscsi_handle_event,
+			0, "ibmvscsi", (void *)hostdata) != 0) {
+		printk(KERN_ERR "ibmvscsi: couldn't register irq 0x%x\n",
+		       vdev->irq);
+		goto req_irq_failed;
+	}
+
+	rc = vio_enable_interrupts(vdev);
+	if (rc != 0) {
+		printk(KERN_ERR "ibmvscsi:  Error %d enabling interrupts!!!\n",
+		       rc);
+		goto req_irq_failed;
+	}
+
+	queue->cur = 0;
+	queue->lock = SPIN_LOCK_UNLOCKED;
+
+	tasklet_init(&hostdata->srp_task, (void *)ibmvscsi_task,
+		     (unsigned long)hostdata);
+
+	return 0;
+
+      req_irq_failed:
+	do {
+		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
+	} while ((rc == H_Busy) || (H_isLongBusy(rc)));
+      reg_crq_failed:
+	dma_unmap_single(hostdata->dev,
+			 queue->msg_token,
+			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
+      map_failed:
+	free_page((unsigned long)queue->msgs);
+      malloc_failed:
+	return -1;
+}
+
+/**
+ * reset_crq_queue: - resets a crq after a failure
+ * @queue:	crq_queue to initialize and register
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ */
+void ibmvscsi_reset_crq_queue(struct crq_queue *queue,
+			      struct ibmvscsi_host_data *hostdata)
+{
+	int rc;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+
+	/* Close the CRQ */
+	do {
+		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
+	} while ((rc == H_Busy) || (H_isLongBusy(rc)));
+
+	/* Clean out the queue */
+	memset(queue->msgs, 0x00, PAGE_SIZE);
+	queue->cur = 0;
+
+	/* And re-open it again */
+	rc = plpar_hcall_norets(H_REG_CRQ,
+				vdev->unit_address,
+				queue->msg_token, PAGE_SIZE);
+	if (rc == 2) {
+		/* Adapter is good, but other end is not ready */
+		printk(KERN_WARNING "ibmvscsi: Partner adapter not ready\n");
+	} else if (rc != 0) {
+		printk(KERN_WARNING
+		       "ibmvscsi: couldn't register crq--rc 0x%x\n", rc);
+	}
+}
Files linux-2.6-pure/drivers/scsi/ibmvscsi/rpa_vscsi.o and linux-2.6b-tmp1/drivers/scsi/ibmvscsi/rpa_vscsi.o differ
diff -uNr --exclude=SCCS linux-2.6-pure/drivers/scsi/ibmvscsi/srp.h linux-2.6b-tmp1/drivers/scsi/ibmvscsi/srp.h
--- linux-2.6-pure/drivers/scsi/ibmvscsi/srp.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6b-tmp1/drivers/scsi/ibmvscsi/srp.h	2004-07-16 17:50:36.198966000 -0500
@@ -0,0 +1,225 @@
+/*****************************************************************************/
+/* srp.h -- SCSI RDMA Protocol definitions                                   */
+/*                                                                           */
+/* Written By: Colin Devilbis, IBM Corporation                               */
+/*                                                                           */
+/* Copyright (C) 2003 IBM Corporation                                        */
+/*                                                                           */
+/* This program is free software; you can redistribute it and/or modify      */
+/* it under the terms of the GNU General Public License as published by      */
+/* the Free Software Foundation; either version 2 of the License, or         */
+/* (at your option) any later version.                                       */
+/*                                                                           */
+/* This program is distributed in the hope that it will be useful,           */
+/* but WITHOUT ANY WARRANTY; without even the implied warranty of            */
+/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             */
+/* GNU General Public License for more details.                              */
+/*                                                                           */
+/* You should have received a copy of the GNU General Public License         */
+/* along with this program; if not, write to the Free Software               */
+/* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA */
+/*                                                                           */
+/*                                                                           */
+/* This file contains structures and definitions for the SCSI RDMA Protocol  */
+/* (SRP) as defined in the T10 standard available at www.t10.org.  This      */
+/* file was based on the 16a version of the standard                         */
+/*                                                                           */
+/*****************************************************************************/
+#ifndef SRP_H
+#define SRP_H
+
+#define PACKED __attribute__((packed))
+
+enum srp_types {
+	SRP_LOGIN_REQ_TYPE = 0x00,
+	SRP_LOGIN_RSP_TYPE = 0xC0,
+	SRP_LOGIN_REJ_TYPE = 0x80,
+	SRP_I_LOGOUT_TYPE = 0x03,
+	SRP_T_LOGOUT_TYPE = 0x80,
+	SRP_TSK_MGMT_TYPE = 0x01,
+	SRP_CMD_TYPE = 0x02,
+	SRP_RSP_TYPE = 0xC1,
+	SRP_CRED_REQ_TYPE = 0x81,
+	SRP_CRED_RSP_TYPE = 0x41,
+	SRP_AER_REQ_TYPE = 0x82,
+	SRP_AER_RSP_TYPE = 0x42
+};
+
+enum srp_descriptor_formats {
+	SRP_NO_BUFFER = 0x00,
+	SRP_DIRECT_BUFFER = 0x01,
+	SRP_INDIRECT_BUFFER = 0x02
+};
+
+struct memory_descriptor {
+	u64 virtual_address;
+	u32 memory_handle;
+	u32 length;
+};
+
+struct indirect_descriptor {
+	struct memory_descriptor head;
+	u32 total_length;
+	struct memory_descriptor list[1] PACKED;
+};
+
+struct srp_generic {
+	u8 type;
+	u8 reserved1[7];
+	u64 tag;
+};
+
+struct srp_login_req {
+	u8 type;
+	u8 reserved1[7];
+	u64 tag;
+	u32 max_requested_initiator_to_target_iulen;
+	u32 reserved2;
+	u16 required_buffer_formats;
+	u8 reserved3:6;
+	u8 multi_channel_action:2;
+	u8 reserved4;
+	u32 reserved5;
+	u8 initiator_port_identifier[16];
+	u8 target_port_identifier[16];
+};
+
+struct srp_login_rsp {
+	u8 type;
+	u8 reserved1[3];
+	u32 request_limit_delta;
+	u64 tag;
+	u32 max_initiator_to_target_iulen;
+	u32 max_target_to_initiator_iulen;
+	u16 supported_buffer_formats;
+	u8 reserved2:6;
+	u8 multi_channel_result:2;
+	u8 reserved3;
+	u8 reserved4[24];
+};
+
+struct srp_login_rej {
+	u8 type;
+	u8 reserved1[3];
+	u32 reason;
+	u64 tag;
+	u64 reserved2;
+	u16 supported_buffer_formats;
+	u8 reserved3[6];
+};
+
+struct srp_i_logout {
+	u8 type;
+	u8 reserved1[7];
+	u64 tag;
+};
+
+struct srp_t_logout {
+	u8 type;
+	u8 reserved1[3];
+	u32 reason;
+	u64 tag;
+};
+
+struct srp_tsk_mgmt {
+	u8 type;
+	u8 reserved1[7];
+	u64 tag;
+	u32 reserved2;
+	u64 lun PACKED;
+	u8 reserved3;
+	u8 reserved4;
+	u8 task_mgmt_flags;
+	u8 reserved5;
+	u64 managed_task_tag;
+	u64 reserved6;
+};
+
+struct srp_cmd {
+	u8 type;
+	u32 reserved1 PACKED;
+	u8 data_out_format:4;
+	u8 data_in_format:4;
+	u8 data_out_count;
+	u8 data_in_count;
+	u64 tag;
+	u32 reserved2;
+	u64 lun PACKED;
+	u8 reserved3;
+	u8 reserved4:5;
+	u8 task_attribute:3;
+	u8 reserved5;
+	u8 additional_cdb_len;
+	u8 cdb[16];
+	u8 additional_data[0x100 - 0x30];
+};
+
+struct srp_rsp {
+	u8 type;
+	u8 reserved1[3];
+	u32 request_limit_delta;
+	u64 tag;
+	u16 reserved2;
+	u8 reserved3:2;
+	u8 diunder:1;
+	u8 diover:1;
+	u8 dounder:1;
+	u8 doover:1;
+	u8 snsvalid:1;
+	u8 rspvalid:1;
+	u8 status;
+	u32 data_in_residual_count;
+	u32 data_out_residual_count;
+	u32 sense_data_list_length;
+	u32 response_data_list_length;
+	u8 sense_and_response_data[18];
+};
+
+struct srp_cred_req {
+	u8 type;
+	u8 reserved1[3];
+	u32 request_limit_delta;
+	u64 tag;
+};
+
+struct srp_cred_rsp {
+	u8 type;
+	u8 reserved1[7];
+	u64 tag;
+};
+
+struct srp_aer_req {
+	u8 type;
+	u8 reserved1[3];
+	u32 request_limit_delta;
+	u64 tag;
+	u32 reserved2;
+	u64 lun;
+	u32 sense_data_list_length;
+	u32 reserved3;
+	u8 sense_data[20];
+};
+
+struct srp_aer_rsp {
+	u8 type;
+	u8 reserved1[7];
+	u64 tag;
+};
+
+union srp_iu {
+	struct srp_generic generic;
+	struct srp_login_req login_req;
+	struct srp_login_rsp login_rsp;
+	struct srp_login_rej login_rej;
+	struct srp_i_logout i_logout;
+	struct srp_t_logout t_logout;
+	struct srp_tsk_mgmt tsk_mgmt;
+	struct srp_cmd cmd;
+	struct srp_rsp rsp;
+	struct srp_cred_req cred_req;
+	struct srp_cred_rsp cred_rsp;
+	struct srp_aer_req aer_req;
+	struct srp_aer_rsp aer_rsp;
+};
+
+#endif
diff -uNr --exclude=SCCS linux-2.6-pure/drivers/scsi/ibmvscsi/viosrp.h linux-2.6b-tmp1/drivers/scsi/ibmvscsi/viosrp.h
--- linux-2.6-pure/drivers/scsi/ibmvscsi/viosrp.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6b-tmp1/drivers/scsi/ibmvscsi/viosrp.h	2004-07-16 17:50:36.217963112 -0500
@@ -0,0 +1,126 @@
+/*****************************************************************************/
+/* srp.h -- SCSI RDMA Protocol definitions                                   */
+/*                                                                           */
+/* Written By: Colin Devilbis, IBM Corporation                               */
+/*                                                                           */
+/* Copyright (C) 2003 IBM Corporation                                        */
+/*                                                                           */
+/* This program is free software; you can redistribute it and/or modify      */
+/* it under the terms of the GNU General Public License as published by      */
+/* the Free Software Foundation; either version 2 of the License, or         */
+/* (at your option) any later version.                                       */
+/*                                                                           */
+/* This program is distributed in the hope that it will be useful,           */
+/* but WITHOUT ANY WARRANTY; without even the implied warranty of            */
+/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             */
+/* GNU General Public License for more details.                              */
+/*                                                                           */
+/* You should have received a copy of the GNU General Public License         */
+/* along with this program; if not, write to the Free Software               */
+/* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA */
+/*                                                                           */
+/*                                                                           */
+/* This file contains structures and definitions for IBM RPA (RS/6000        */
+/* platform architecture) implementation of the SRP (SCSI RDMA Protocol)     */
+/* standard.  SRP is used on IBM iSeries and pSeries platforms to send SCSI  */
+/* commands between logical partitions.                                      */
+/*                                                                           */
+/* SRP Information Units (IUs) are sent on a "Command/Response Queue" (CRQ)  */
+/* between partitions.  The definitions in this file are architected,        */
+/* and cannot be changed without breaking compatibility with other versions  */
+/* of Linux and other operating systems (AIX, OS/400) that talk this protocol*/
+/* between logical partitions                                                */
+/*****************************************************************************/
+#ifndef VIOSRP_H
+#define VIOSRP_H
+#include "srp.h"
+
+enum viosrp_crq_formats {
+	VIOSRP_SRP_FORMAT = 0x01,
+	VIOSRP_MAD_FORMAT = 0x02,
+	VIOSRP_OS400_FORMAT = 0x03,
+	VIOSRP_AIX_FORMAT = 0x04,
+	VIOSRP_LINUX_FORMAT = 0x06,
+	VIOSRP_INLINE_FORMAT = 0x07
+};
+
+struct viosrp_crq {
+	u8 valid;		/* used by RPA */
+	u8 format;		/* SCSI vs out-of-band */
+	u8 reserved;
+	u8 status;		/* non-scsi failure? (e.g. DMA failure) */
+	u16 timeout;		/* in seconds */
+	u16 IU_length;		/* in bytes */
+	u64 IU_data_ptr;	/* the TCE for transferring data */
+};
+
+/* MADs are Management requests above and beyond the IUs defined in the SRP
+ * standard.  
+ */
+enum viosrp_mad_types {
+	VIOSRP_EMPTY_IU_TYPE = 0x01,
+	VIOSRP_ERROR_LOG_TYPE = 0x02,
+	VIOSRP_ADAPTER_INFO_TYPE = 0x03,
+	VIOSRP_HOST_CONFIG_TYPE = 0x04
+};
+
+/* 
+ * Common MAD header
+ */
+struct mad_common {
+	u32 type;
+	u16 status;
+	u16 length;
+	u64 tag;
+};
+
+/*
+ * All SRP (and MAD) requests normally flow from the
+ * client to the server.  There is no way for the server to send
+ * an asynchronous message back to the client.  The Empty IU is used
+ * to hang out a meaningless request to the server so that it can respond
+ * asynchrouously with something like a SCSI AER 
+ */
+struct viosrp_empty_iu {
+	struct mad_common common;
+	u64 buffer;
+	u32 port;
+};
+
+struct viosrp_error_log {
+	struct mad_common common;
+	u64 buffer;
+};
+
+struct viosrp_adapter_info {
+	struct mad_common common;
+	u64 buffer;
+};
+
+struct viosrp_host_config {
+	struct mad_common common;
+	u64 buffer;
+};
+
+union mad_iu {
+	struct viosrp_empty_iu empty_iu;
+	struct viosrp_error_log error_log;
+	struct viosrp_adapter_info adapter_info;
+	struct viosrp_host_config host_config;
+};
+
+union viosrp_iu {
+	union srp_iu srp;
+	union mad_iu mad;
+};
+
+struct mad_adapter_info_data {
+	char srp_version[8];
+	char partition_name[96];
+	u32 partition_number;
+	u32 mad_version;
+	u32 os_type;
+	u32 port_max_txu[8];	/* per-port maximum transfer */
+};
+
+#endif
--- linux-2.6-pure/drivers/scsi/Kconfig	2004-06-30 04:59:26.965918968 -0500
+++ linux-2.6/drivers/scsi/Kconfig	2004-06-30 04:13:51.000000000 -0500
@@ -780,6 +780,15 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called ips.
 
+config SCSI_IBMVSCSI
+	tristate "IBM Virtual SCSI support"
+	depends on PPC_PSERIES || PPC_ISERIES
+	help
+	  This is the IBM POWER Virtual SCSI Client
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ibmvscsic.
+
 config SCSI_INITIO
 	tristate "Initio 9100U(W) support"
 	depends on PCI && SCSI && BROKEN
--- linux-2.6-pure/drivers/scsi/Makefile	2004-06-30 04:58:53.099007976 -0500
+++ linux-2.6/drivers/scsi/Makefile	2004-06-30 04:13:52.000000000 -0500
@@ -119,6 +119,7 @@
 obj-$(CONFIG_SCSI_LASI700)	+= 53c700.o lasi700.o
 obj-$(CONFIG_SCSI_NSP32)	+= nsp32.o
 obj-$(CONFIG_SCSI_IPR)		+= ipr.o
+obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_SATA_SVW)	+= libata.o sata_svw.o
 obj-$(CONFIG_SCSI_ATA_PIIX)	+= libata.o ata_piix.o
 obj-$(CONFIG_SCSI_SATA_PROMISE)	+= libata.o sata_promise.o

--IJpNTDwzlM2Ie8A6--
