From: Dave Boutcher <sleddog@us.ibm.com>
Subject: [PATCH] ibmvscsi driver - next version
Date: Sun, 22 Feb 2004 22:24:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <opr3s2iefyl6e53g@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=----------wspLrvyj4U2o1X7B5y3YFx
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:45983 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261802AbUBWEYK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2004 23:24:10 -0500
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e32.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id i1N4O9FD666184
	for <linux-scsi@vger.kernel.org>; Sun, 22 Feb 2004 23:24:09 -0500
Received: from hound (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i1N4O5cO110378
	for <linux-scsi@vger.kernel.org>; Sun, 22 Feb 2004 21:24:06 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

------------wspLrvyj4U2o1X7B5y3YFx
Content-Type: text/plain; format=flowed; charset=iso-8859-15
Content-Transfer-Encoding: 8bit

This is the next version of the SCSI driver to support the adapter 
implemented by the IBM Power5 firmware.  I have incorporated all comments 
 from the first submission, which has resulted in a much cleaner, leaner, 
meaner version.

If anyone would prefer to review the code in a prettier c2html format, you 
can see it at
http://www-users.cs.umn.edu/~boutcher/ibmvscsi/

And there is a tarball at
ftp://ftp.cs.umn.edu/dept/users/boutcher/ibmvscsi-feb22.tar.gz

Thanks,

Dave Boutcher
------------wspLrvyj4U2o1X7B5y3YFx
Content-Disposition: attachment; filename=patch-ibmvscsi-2.6-feb22.diff
Content-Type: application/octet-stream; name=patch-ibmvscsi-2.6-feb22.diff
Content-Transfer-Encoding: 8bit

diff -uNr --exclude=SCCS --exclude=*.o --exclude=*.cmd linux-2.5/drivers/scsi/ibmvscsi/Makefile ppc64-2.5new/drivers/scsi/ibmvscsi/Makefile
--- linux-2.5/drivers/scsi/ibmvscsi/Makefile	Wed Dec 31 18:00:00 1969
+++ ppc64-2.5new/drivers/scsi/ibmvscsi/Makefile	Sun Feb 22 03:14:58 2004
@@ -0,0 +1,7 @@
+obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsic.o
+
+ibmvscsic-y			+= ibmvscsi.o
+ibmvscsic-$(CONFIG_PPC_ISERIES)	+= iseries_vscsi.o 
+ibmvscsic-$(CONFIG_PPC_PSERIES)	+= rpa_vscsi.o 
+ 
+
diff -uNr --exclude=SCCS --exclude=*.o --exclude=*.cmd linux-2.5/drivers/scsi/ibmvscsi/ibmvscsi.c ppc64-2.5new/drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.5/drivers/scsi/ibmvscsi/ibmvscsi.c	Wed Dec 31 18:00:00 1969
+++ ppc64-2.5new/drivers/scsi/ibmvscsi/ibmvscsi.c	Sun Feb 22 21:56:16 2004
@@ -0,0 +1,967 @@
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
+#include <scsi/scsi_device.h>
+#include "ibmvscsi.h"
+
+
+MODULE_DESCRIPTION("IBM Virtual SCSI");
+MODULE_AUTHOR("Dave Boutcher");
+MODULE_LICENSE("GPL");
+
+MODULE_PARM(max_id, "i");
+MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
+MODULE_PARM(max_channel, "i");
+MODULE_PARM_DESC(max_channel, "Largest channel value");
+
+/* The values below are somewhat arbitrary default values, but 
+ * OS/400 will use 3 busses (disks, CDs, tapes, I think.)
+ * Note that there are 3 bits of channel value, 6 bits of id, and
+ * 5 bits of LUN.
+ */
+static int max_id = 64;       
+static int max_channel = 3;   
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
+static int initialize_event_pool(struct event_pool *pool, int size, struct ibmvscsi_host_data *hostdata)
+{
+	int i;
+
+	pool->size = size;
+	pool->lock = SPIN_LOCK_UNLOCKED;
+	pool->events = kmalloc(pool->size * sizeof(*pool->events), GFP_KERNEL);
+	if(!pool->events)
+		return -ENOMEM;
+	memset(pool->events, 0x00, pool->size * sizeof(*pool->events));
+
+	pool->iu_storage = dma_alloc_coherent(hostdata->dev, pool->size * sizeof(*pool->iu_storage), &pool->iu_token, 0);
+	if(!pool->iu_storage) {
+		kfree(pool->events);
+		return -ENOMEM;
+	}
+
+	for(i = 0; i < pool->size; ++i) {
+		struct srp_event_struct *evt = &pool->events[i];
+		memset(&evt->crq, 0x00, sizeof(evt->crq));
+		evt->crq.valid = 0x80;
+		evt->crq.IU_length = sizeof(*evt->evt);
+		evt->crq.IU_data_ptr = pool->iu_token + sizeof(*evt->evt) * i;
+		evt->evt = pool->iu_storage + i;
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
+static void release_event_pool(struct event_pool *pool, struct ibmvscsi_host_data *hostdata)
+{
+	int i, in_use = 0;
+	for(i = 0; i < pool->size; ++i)
+		if(pool->events[i].in_use)
+			++in_use;
+	if(in_use)
+		printk(KERN_WARNING "ibmvscsi: releasing event pool with %d events still in use?\n", in_use);
+	kfree(pool->events);
+	dma_free_coherent(hostdata->dev, pool->size * sizeof(*pool->iu_storage), pool->iu_storage, pool->iu_token);
+}
+
+/**
+ * ibmvscsi_valid_event_struct: - Determines if event is valid.
+ * @pool:	event_pool that contains the event
+ * @evt:	srp_event_struct to be checked for validity
+ *
+ * Returns zero if event is invalid, one otherwise.
+*/
+int ibmvscsi_valid_event_struct(struct event_pool *pool, struct srp_event_struct *evt)
+{
+	int index = evt - pool->events;
+	if(index < 0 || index >= pool->size) /* outside of bounds */
+		return 0;
+	if(evt != pool->events + index) /* unaligned */
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
+static void ibmvscsi_free_event_struct(struct event_pool *pool, struct srp_event_struct *evt)
+{
+	if(!ibmvscsi_valid_event_struct(pool, evt)) {
+		printk(KERN_ERR "ibmvscsi: YIKES! tried to free invalid event_struct %p (not in pool %p)\n", evt, pool->events);
+		return;
+	}
+	if(!evt->in_use) {
+		printk(KERN_ERR "ibmvscsi: YIKES! tried to free event_struct %p which is not in use!\n", evt);
+		return;
+	}
+	evt->in_use = 0;
+}
+
+/**
+ * ibmvscsi_get_event_struct: - Gets the next free event in pool
+ * @pool:	event_pool that contains the events to be searched
+ *
+ * Returns the next event in "free" state, and NULL if none are free.
+*/
+static struct srp_event_struct *ibmvscsi_get_event_struct(struct event_pool *pool)
+{
+	struct srp_event_struct *cur, *last = pool->events + pool->size;
+	unsigned long flags;	
+
+	spin_lock_irqsave(&pool->lock, flags);
+	for (cur = pool->events; cur < last; ++cur)
+		if (!cur->in_use) {
+			cur->in_use = 1;
+			break;
+		}
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	if(cur >= last) {
+		printk(KERN_ERR "ibmvscsi: found no event struct in pool!\n");
+		return NULL;
+	}
+
+	return cur;
+}
+
+/**
+ * evt_struct_for: - Initializes the next free event
+ * @pool:	event_pool that contains events to be searched
+ * @evt:	VIOSRP_IU that the event will point to
+ * @cmnd:	The scsi cmnd object for this event.  Can be NULL
+ * @done:	Callback function when event is processed
+ *
+ * Returns the initialized event, and NULL if there are no free events
+*/
+static struct srp_event_struct *evt_struct_for(struct event_pool *pool, union VIOSRP_IU *evt, struct scsi_cmnd *cmnd, void (*done)(struct srp_event_struct *))
+{
+	struct srp_event_struct *evt_struct = ibmvscsi_get_event_struct(pool);
+	if(!evt_struct)
+		return NULL;
+
+	*evt_struct->evt = *evt;
+	evt_struct->evt->srp.generic.tag = (u64)(unsigned long)evt_struct;
+
+	evt_struct->cmnd = cmnd;
+	evt_struct->done = done;
+	return evt_struct;
+}
+
+/* ------------------------------------------------------------
+ * Routines for receiving SCSI responses from the hosting partition
+ */
+/**
+ * unmap_direct_data: - Unmap address pointed by SRP_CMD
+ * @cmd:	SRP_CMD whose additional_data member will be unmapped
+ * @dev:	device for which the memory is mapped
+ *
+*/
+static void unmap_direct_data(struct SRP_CMD *cmd, struct device *dev)
+{
+	struct memory_descriptor *data = (struct memory_descriptor *)cmd->additional_data;
+	dma_unmap_single(dev, data->virtual_address, data->length, PCI_DMA_BIDIRECTIONAL);
+}
+
+/**
+ * unmap_direct_data: - Unmap array of address pointed by SRP_CMD
+ * @cmd:	SRP_CMD whose additional_data member will be unmapped
+ * @dev:	device for which the memory is mapped
+ *
+*/
+static void unmap_indirect_data(struct SRP_CMD *cmd, struct device *dev)
+{
+	struct indirect_descriptor *indirect = (struct indirect_descriptor *)cmd->additional_data;
+	int i, num_mapped = indirect->head.length / sizeof(indirect->list[0]);
+	for(i = 0; i < num_mapped; ++i) {
+		struct memory_descriptor *data = &indirect->list[i];
+		dma_unmap_single(dev, data->virtual_address, data->length, PCI_DMA_BIDIRECTIONAL);
+	}
+}
+
+/**
+ * unmap_direct_data: - Unmap data pointed in SRP_CMD based on the format
+ * @cmd:	SRP_CMD whose additional_data member will be unmapped
+ * @dev:	device for which the memory is mapped
+ *
+*/
+static void unmap_cmd_data(struct SRP_CMD *cmd, struct device *dev)
+{
+	if(cmd->data_out_format == SRP_NO_BUFFER && cmd->data_in_format == SRP_NO_BUFFER)
+		return;
+	else if(cmd->data_out_format == SRP_DIRECT_BUFFER || cmd->data_in_format == SRP_DIRECT_BUFFER)
+		unmap_direct_data(cmd, dev);
+	else
+		unmap_indirect_data(cmd, dev);
+}
+
+/**
+ * map_sg_data: - Maps dma for a scatterlist and initializes decriptor fields
+ * @cmd:	Scsi_Cmnd with the scatterlist
+ * @srp_cmd:	SRP_CMD that contains the memory descriptor
+ * @dev:	device for which to map dma memory
+ *
+ * Called by map_data_for_srp_cmd() when building srp cmd from scsi cmd.
+ * Returns 1 on success.
+*/
+static int map_sg_data(struct scsi_cmnd *cmd, struct SRP_CMD *srp_cmd, struct device *dev)
+{
+	
+	int i, sg_mapped;
+	u64 total_length = 0;
+	struct scatterlist *sg = cmd->request_buffer;
+	struct memory_descriptor *data = (struct memory_descriptor *)srp_cmd->additional_data;
+	struct indirect_descriptor *indirect = (struct indirect_descriptor *)data;
+	sg_mapped = dma_map_sg(dev, sg, cmd->use_sg, PCI_DMA_BIDIRECTIONAL);
+
+	/* special case; we can use a single direct descriptor */
+	if(sg_mapped == 1)
+	{
+		if(cmd->sc_data_direction == DMA_TO_DEVICE)
+			srp_cmd->data_out_format = SRP_DIRECT_BUFFER;
+		else
+			srp_cmd->data_in_format = SRP_DIRECT_BUFFER;
+		data->virtual_address = sg[0].dma_address;
+		data->length = sg[0].dma_length;
+		data->memory_handle = 0 /* viopath_sourceinst(viopath_hostLp) */;
+		return 1;
+	}
+
+	if(sg_mapped > MAX_INDIRECT_BUFS) {
+		printk(KERN_ERR "ibmvscsi: can't handle more than %d mapped sg entries, got %d\n", MAX_INDIRECT_BUFS, sg_mapped);
+		return 0;
+	}
+
+	if(cmd->sc_data_direction == DMA_TO_DEVICE) {
+		srp_cmd->data_out_format = SRP_INDIRECT_BUFFER;
+		srp_cmd->data_out_count = sg_mapped;
+	}
+	else {
+		srp_cmd->data_in_format = SRP_INDIRECT_BUFFER;
+		srp_cmd->data_in_count = sg_mapped;
+	}
+	indirect->head.virtual_address = 0; 
+	indirect->head.length = sg_mapped * sizeof(indirect->list[0]);
+	indirect->head.memory_handle = 0;
+	for(i = 0; i < sg_mapped; ++i) {
+		struct memory_descriptor *descr = &indirect->list[i];
+		struct scatterlist *sg_entry = &sg[i];
+		descr->virtual_address = sg_entry->dma_address;
+		descr->length = sg_entry->dma_length;
+		descr->memory_handle = 0 /* viopath_sourceinst(viopath_hostLp) */;
+		total_length += sg_entry->dma_length;
+	}
+	indirect->total_length = total_length;
+
+	return 1;
+}
+
+/**
+ * map_sg_data: - Maps memory and initializes memory decriptor fields
+ * @cmd:	struct scsi_cmnd with the memory to be mapped
+ * @srp_cmd:	SRP_CMD that contains the memory descriptor
+ * @dev:	device for which to map dma memory
+ *
+ * Called by map_data_for_srp_cmd() when building srp cmd from scsi cmd.
+ * Returns 1 on success.
+*/
+static int map_single_data(struct scsi_cmnd *cmd, struct SRP_CMD *srp_cmd, struct device *dev)
+{
+	struct memory_descriptor *data = (struct memory_descriptor *)srp_cmd->additional_data;
+
+	data->virtual_address = (u64)(unsigned long)dma_map_single(
+		dev, cmd->request_buffer, cmd->request_bufflen,
+		PCI_DMA_BIDIRECTIONAL);
+	if(data->virtual_address == 0xFFFFFFFF) {
+		printk(KERN_ERR "ibmvscsi: Unable to map request_buffer for command!\n");
+		return 0;
+	}
+	data->length = cmd->request_bufflen;
+	data->memory_handle = 0 /* viopath_sourceinst(viopath_hostLp) */;
+
+	if(cmd->sc_data_direction == DMA_TO_DEVICE)
+		srp_cmd->data_out_format = SRP_DIRECT_BUFFER;
+	else
+		srp_cmd->data_in_format = SRP_DIRECT_BUFFER;
+
+	return 1;
+}
+
+/**
+ * map_data_for_srp_cmd: - Calls functions to map data for srp cmds
+ * @cmd:	struct scsi_cmnd with the memory to be mapped
+ * @srp_cmd:	SRP_CMD that contains the memory descriptor
+ * @dev:	dma device for which to map dma memory
+ *
+ * Called by scsi_cmd_to_srp_cmd() when converting scsi cmds to srp cmds 
+ * Returns 1 on success.
+*/
+static int map_data_for_srp_cmd(struct scsi_cmnd *cmd, struct SRP_CMD *srp_cmd, struct device *dev)
+{
+	switch(cmd->sc_data_direction) {
+	case DMA_FROM_DEVICE:
+	case DMA_TO_DEVICE:
+		break;
+	case DMA_NONE:
+		return 1;
+	case DMA_BIDIRECTIONAL:
+		printk(KERN_ERR "ibmvscsi: Can't map DMA_BIDIRECTIONAL to read/write\n");
+		return 0;
+	default:
+		printk(KERN_ERR "ibmvscsi: Unknown data direction 0x%02x; can't map!\n", cmd->sc_data_direction);
+		return 0;
+	}
+
+	if(!cmd->request_buffer)
+		return 1;
+	if(cmd->use_sg)
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
+*/
+static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct, struct ibmvscsi_host_data *hostdata)
+{
+	struct scsi_cmnd *cmnd;
+	unsigned long flags;
+	u64 *crq_as_u64 = (u64*)&evt_struct->crq;
+
+	/* If we have exhausted our request limit, just queue this request */
+	if (atomic_dec_if_positive(&hostdata->request_limit)< 0) {
+		printk("ibmvscsi: Warning, request_limit exceeded\n");
+		return SCSI_MLQUEUE_HOST_BUSY;
+	} else {
+		/* Add this to the sent list.  We need to do this before we actually send 
+		 * in case it comes back REALLY fast
+		 */
+		spin_lock_irqsave(&hostdata->lock, flags);
+		list_add_tail(&evt_struct->list, &hostdata->sent);
+		spin_unlock_irqrestore(&hostdata->lock, flags);
+		
+		if (ibmvscsi_send_crq(hostdata, crq_as_u64[0], crq_as_u64[1]) != 0) {
+			spin_lock_irqsave(&hostdata->lock, flags);
+			list_del(&evt_struct->list);
+			spin_unlock_irqrestore(&hostdata->lock, flags);
+
+			cmnd = evt_struct->cmnd;
+			printk(KERN_ERR "ibmvscsi: failed to send event struct\n");
+			unmap_cmd_data(&evt_struct->evt->srp.cmd, hostdata->dev);
+			ibmvscsi_free_event_struct(&hostdata->pool, evt_struct);
+			cmnd->result = DID_ERROR << 16;
+			evt_struct->cmnd_done(cmnd);
+			return SCSI_MLQUEUE_HOST_BUSY;
+		}
+	}
+	return 0;
+}
+
+/**
+ * handle_cmd_rsp: -  Handle responses fom commands
+ * @evt_struct:	srp_event_struct to be handled
+ *
+ * Used as a callback by when sending scsi cmds (by scsi_cmd_to_event_struct). 
+ * Gets called by ibmvscsi_handle_crq()
+*/
+static void handle_cmd_rsp(struct srp_event_struct *evt_struct)
+{
+	struct SRP_RSP *rsp = &evt_struct->evt->srp.rsp;
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *) evt_struct->cmnd;
+	
+	if (cmnd) {
+		cmnd->result |= rsp->status;
+		if (((cmnd->result >> 1) & 0x1f) == CHECK_CONDITION)
+			memcpy(cmnd->sense_buffer, rsp->sense_and_response_data, rsp->sense_data_list_length);
+		unmap_cmd_data(&evt_struct->cmd, evt_struct->hostdata->dev);
+
+		if(rsp->dounder)
+			cmnd->resid = rsp->data_out_residual_count;
+		else if(rsp->diunder)
+			cmnd->resid = rsp->data_in_residual_count;
+	}
+	
+ 	if (evt_struct->cmnd_done) {
+		evt_struct->cmnd_done(cmnd);
+	}
+	
+	ibmvscsi_free_event_struct(&evt_struct->hostdata->pool, evt_struct);
+}
+
+
+/* ------------------------------------------------------------
+ * Routines for queuing individual SCSI commands to the hosting partition
+ */
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
+ * scsi_cmd_to_srp_cmd: - Initializes srp cmd with data from scsi cmd
+ * @cmd:	source struct scsi_cmnd
+ * @srp_cmd:	target SRP_CMD
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ * Returns 1 on success.
+*/
+static int scsi_cmd_to_srp_cmd(struct scsi_cmnd *cmd, struct SRP_CMD *srp_cmd, struct ibmvscsi_host_data *hostdata)
+{
+	u16 lun = lun_from_dev(cmd->device);
+	memset(srp_cmd, 0x00, sizeof(*srp_cmd));
+
+	srp_cmd->type = SRP_CMD_TYPE;
+	memcpy(srp_cmd->cdb, cmd->cmnd, sizeof(cmd->cmnd));
+	srp_cmd->lun = ((u64)lun) << 48;
+
+	return map_data_for_srp_cmd(cmd, srp_cmd, hostdata->dev);
+}
+
+/**
+ * scsi_cmd_to_event_struct: - Initializes a srp_event_struct with data from scsi cmd
+ * @cmd:	Source struct scsi_cmnd
+ * @done:	Callback function to be called when cmd is completed
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ * Returns the srp_event_struct to be used or NULL if not successful.
+*/
+static struct srp_event_struct *scsi_cmd_to_event_struct(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd*), struct ibmvscsi_host_data *hostdata)
+{
+	struct SRP_CMD srp_cmd;
+	struct srp_event_struct *evt_struct;
+
+	if(!scsi_cmd_to_srp_cmd(cmd, &srp_cmd, hostdata)) {
+		printk(KERN_ERR "ibmvscsi: couldn't convert cmd to SRP_CMD\n");
+		return NULL;
+	}
+
+	evt_struct = evt_struct_for(&hostdata->pool, (union VIOSRP_IU *)&srp_cmd, (void*)cmd, handle_cmd_rsp);
+	if(!evt_struct) {
+		printk(KERN_ERR "ibmvscsi: evt_struct_for() returned NULL\n");
+		return NULL;
+	}
+
+	evt_struct->cmd = srp_cmd;
+	evt_struct->cmnd_done = done;
+	evt_struct->crq.timeout = cmd->timeout;
+	return evt_struct;
+}
+
+/**
+ * ibmvscsi_queue: - The queuecommand function of the scsi template 
+ * @cmd:	struct scsi_cmnd to be executed
+ * @done:	Callback function to be called when cmd is completed
+ *
+ * Always returns zero
+*/
+static int ibmvscsi_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+{
+	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)&cmd->device->host->hostdata;
+	struct srp_event_struct *evt_struct = scsi_cmd_to_event_struct(cmd, done, hostdata);
+
+	/* Check if we are in a dead state before we go any farther */
+	if (atomic_read(&hostdata->request_limit) < 0) {
+		printk("ibmvscsi: rejecting SCSI command on failed adapter\n");
+		return FAILED;
+	}
+
+	if (!evt_struct) {
+		printk(KERN_ERR "ibmvscsi: unable to convert struct scsi_cmnd to LpEvent\n");
+		cmd->result = DID_ERROR << 16;
+		done(cmd);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	evt_struct->crq.format = VIOSRP_SRP_FORMAT;
+
+	return ibmvscsi_send_srp_event(evt_struct, hostdata);
+}
+
+/* ------------------------------------------------------------
+ * Routines for driver initialization
+ */
+static void error_cleanup(struct ibmvscsi_host_data *hostdata) {
+	struct Scsi_Host *host = hostdata->host;
+	release_event_pool(&hostdata->pool, hostdata);
+	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata);
+	memset(hostdata, 0xff, sizeof(*hostdata));
+	scsi_host_put(host);
+}
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
+	switch(evt_struct->evt->srp.generic.type) {
+	case SRP_LOGIN_RSP_TYPE: /* it worked! */
+		break;
+	case SRP_LOGIN_REJ_TYPE: /* refused! */
+		printk(KERN_INFO "ibmvscsi: SRP_LOGIN_REQ rejected\n");
+		error_cleanup(hostdata);
+		return;
+	default:
+		printk(KERN_ERR "ibmvscsi: Invalid SRP_LOGIN_REQ response typecode 0x%02x!\n", evt_struct->evt->srp.generic.type);
+		error_cleanup(hostdata);
+		return;
+	}
+	
+	printk(KERN_INFO "ibmvscsi: SRP_LOGIN succeeded\n");
+	
+	/* Now we know what the real request-limit is */
+	atomic_set(&hostdata->request_limit, evt_struct->evt->srp.login_rsp.request_limit_delta);
+
+	ibmvscsi_free_event_struct(&evt_struct->hostdata->pool, evt_struct);
+
+	hostdata->host->can_queue = evt_struct->evt->srp.login_rsp.request_limit_delta;
+
+	/* Now allow commands (such the queued up scans) to go */
+	scsi_unblock_requests(hostdata->host);
+
+	return;
+}
+
+
+/**
+ * send_srp_login: - Sends the srp login
+ * @hostdata:	ibmvscsi_host_data of host
+ * 
+ * Returns zero if successful.
+*/
+static int send_srp_login(struct ibmvscsi_host_data *hostdata)
+{
+	struct SRP_LOGIN_REQ req = {
+		.type = SRP_LOGIN_REQ_TYPE,
+		.max_requested_initiator_to_target_iulen = sizeof(union SRP_IU),
+		.required_buffer_formats = 0x0002 /* direct and indirect */
+	};
+	struct srp_event_struct *evt_struct =
+		evt_struct_for(&hostdata->pool, (union VIOSRP_IU *)&req, NULL, login_rsp);
+
+	if(!evt_struct) {
+		printk(KERN_ERR "ibmvscsi: couldn't allocate an event for SRP_LOGIN_REQ!\n");
+		return FAILED;
+	}
+
+	/* Start out with a request limit of 1, since this is negotiated in
+	 * the login request we are just sending
+	 */
+	atomic_set(&hostdata->request_limit, 1);
+	evt_struct->crq.format = VIOSRP_SRP_FORMAT;
+	
+	return ibmvscsi_send_srp_event(evt_struct, hostdata);
+};
+
+/**
+ * sync_completion: Signal that a synchronous command has completed
+ */
+static void sync_completion(struct srp_event_struct *evt_struct) {
+	complete(&evt_struct->comp);
+	ibmvscsi_free_event_struct(&evt_struct->hostdata->pool, evt_struct);
+}
+
+/**
+ * ibmvscsi_abort: Abort a command...from scsi host template
+ * send this over to the server and wait synchronously for the response
+ */
+static int ibmvscsi_abort(struct scsi_cmnd *cmd)
+{
+	struct ibmvscsi_host_data *hostdata = *(struct ibmvscsi_host_data **)&cmd->device->host->hostdata;
+	union VIOSRP_IU iu;
+	struct SRP_TSK_MGMT *tsk_mgmt = &iu.srp.tsk_mgmt;
+	struct SRP_RSP *rsp;
+	struct srp_event_struct *evt;
+	struct srp_event_struct *tmp_evt, *found_evt;
+	struct list_head	*pos, *next;
+	unsigned long flags;
+	u16 lun = lun_from_dev(cmd->device);
+
+	/* First, find this command in our sent list so we can figure
+	 * out the correct tag
+	 */
+	found_evt = NULL;
+	spin_lock_irqsave(&hostdata->lock, flags);
+	if(!list_empty(&hostdata->sent)) {
+		list_for_each_safe(pos, next, &hostdata->sent) {
+			tmp_evt = list_entry(pos, struct srp_event_struct, list);
+			
+			if (tmp_evt->cmnd == cmd) {
+				found_evt = tmp_evt;
+				break;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&hostdata->lock, flags);
+	
+	/* If we can't find this event, just return false */
+	if (found_evt == NULL) {
+		printk(KERN_ERR "ibmvscsi: failed to abort command\n");
+		return FAILED;
+	}
+
+	/* Set up an abort SRP command */
+	memset(&iu, 0x00, sizeof(iu));
+	tsk_mgmt->type = SRP_TSK_MGMT_TYPE;
+	tsk_mgmt->lun = ((u64)lun) << 48;
+	tsk_mgmt->task_mgmt_flags = 0x01; /* ABORT TASK */
+	tsk_mgmt->managed_task_tag = (u64)(unsigned long)found_evt;
+
+	printk(KERN_INFO "ibmvscsi: aborting command for lun 0x%lx, tag 0x%lx\n", tsk_mgmt->lun, tsk_mgmt->managed_task_tag);
+
+	evt = evt_struct_for(&hostdata->pool, &iu, NULL, sync_completion);
+	if(!evt) {
+		printk(KERN_ERR "ibmvscsi: failed to allocate abort() event struct\n");
+		return FAILED;
+	}
+	
+	init_completion(&evt->comp);
+	if(ibmvscsi_send_srp_event(evt, hostdata) != 0) {
+		printk(KERN_ERR "ibmvscsi: failed to send abort() event struct\n");
+		ibmvscsi_free_event_struct(&hostdata->pool, evt);
+		return FAILED;
+	}
+	
+	wait_for_completion(&evt->comp);
+	
+	if(evt->evt->srp.generic.type != SRP_RSP_TYPE) {
+		printk(KERN_ERR "ibmvscsi: bad TSK_MGMT response type 0x%02x\n", evt->evt->srp.generic.type);
+	}
+	
+	rsp = &evt->evt->srp.rsp;
+	if(!rsp->rspvalid || (rsp->response_data_list_length != 4)) {
+		printk(KERN_ERR "ibmvscsi: bad TSK_MGMT response--rsp invalid or invalid length\n");
+	}
+	
+	if(rsp->sense_and_response_data[3] != 0x00) {
+		printk(KERN_ERR "ibmvscsi: ABORT failed: response data rsp_code 0x%02x\n", rsp->sense_and_response_data[3]);
+	}
+
+	/* Whether the abort was successful or failed, if the command associated
+	 * with this abort is still sitting in our sent queue, remove it
+	 * and most importantly, unmap and free the event
+	 */
+	spin_lock_irqsave(&hostdata->lock, flags);
+	if(!list_empty(&hostdata->sent)) {
+		list_for_each_safe(pos, next, &hostdata->sent) {
+			tmp_evt = list_entry(pos, struct srp_event_struct, list);
+			
+			if (tmp_evt->cmnd == cmd) {
+				cmd->result = (DID_ABORT << 16);
+				list_del(&tmp_evt->list);
+				spin_unlock_irqrestore(&hostdata->lock, flags);
+				unmap_cmd_data(&tmp_evt->cmd, tmp_evt->hostdata->dev);
+				ibmvscsi_free_event_struct(&tmp_evt->hostdata->pool, tmp_evt);
+				atomic_inc(&hostdata->request_limit);
+				printk(KERN_INFO "ibmvscsi: successfully aborted task tag 0x%lx\n", tsk_mgmt->managed_task_tag);
+				return SUCCESS;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&hostdata->lock, flags);
+	printk(KERN_ERR "ibmvscsi: failed to abort command tag 0x%lx\n", tsk_mgmt->managed_task_tag);
+	
+	return FAILED;
+}
+
+/**
+ * purge_requests: Our virtual adapter just shut down.  purge any sent requests 
+ * @hostdata:    the adapter
+ */
+static void purge_requests(struct ibmvscsi_host_data *hostdata) {
+	struct srp_event_struct *tmp_evt;
+	struct list_head	*pos, *next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hostdata->lock, flags);
+	if(!list_empty(&hostdata->sent)) {
+		list_for_each_safe(pos, next, &hostdata->sent) {
+			tmp_evt = list_entry(pos, struct srp_event_struct, list);
+			tmp_evt->cmnd->result = (DID_ERROR << 16);
+			list_del(&tmp_evt->list);
+			spin_unlock_irqrestore(&hostdata->lock, flags);
+			unmap_cmd_data(&tmp_evt->cmd, tmp_evt->hostdata->dev);
+			ibmvscsi_free_event_struct(&tmp_evt->hostdata->pool, tmp_evt);
+			if (tmp_evt->cmnd_done) {
+				tmp_evt->cmnd_done(tmp_evt->cmnd);
+			}
+			spin_lock_irqsave(&hostdata->lock, flags);
+		}
+	}
+	spin_unlock_irqrestore(&hostdata->lock, flags);
+}
+
+/**
+ * ibmvscsi_handle_crq: - Handles and frees received events in the CRQ
+ * @crq:	Command/Response queue
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+*/
+void ibmvscsi_handle_crq(struct VIOSRP_CRQ *crq, struct ibmvscsi_host_data *hostdata)
+{
+	struct srp_event_struct *evt_struct = (struct srp_event_struct *)crq->IU_data_ptr;
+	switch(crq->valid) {
+	case 0xC0: /* initialization */
+		switch(crq->format) {
+		case 0x01: /* Initialization message */
+			printk(KERN_INFO "ibmvscsi: partner just initialized\n");
+			/* Send back a response */
+			ibmvscsi_send_crq(hostdata, 0xC002000000000000, 0);
+
+			/* Now login */
+			send_srp_login(hostdata);
+			break;
+		case 0x02: /* Initialization response */
+			printk(KERN_INFO "ibmvscsi: partner initialization complete\n");
+
+			/* Now login */
+			send_srp_login(hostdata);
+			break;
+		default:
+			printk(KERN_ERR "ibmvscsi: unknown crq message type\n");
+		}
+		return;
+	case 0xFF: /* Hypervisor telling us the connection is closed */
+		printk(KERN_INFO "ibmvscsi: Virtual adapter failed!\n");
+		
+		scsi_block_requests(hostdata->host);
+		atomic_set(&hostdata->request_limit, -1);
+		purge_requests(hostdata);
+		return;
+	case 0x80: /* real payload */
+		break;
+	default:
+		printk(KERN_ERR "ibmvscsi: got an invalid message type 0x%02x\n", crq->valid);
+		return;
+	}
+
+	/* The only kind of payload CRQs we should get are responses to things we send.
+	 * Make sure this response is to something we actually sent
+	 */
+	if(!ibmvscsi_valid_event_struct(&hostdata->pool, evt_struct)) {
+		printk(KERN_ERR "ibmvscsi: returned correlation_token 0x%p is invalid!\n", (void*)crq->IU_data_ptr);
+		return;
+	}
+	
+	/* Now remove the event from the sent queue.  If it is not there, we have a REALLY
+	 * wierd race condition, probably involving an abort.  Don't call the "done" 
+	 * method in that case.
+	 */
+	if (list_empty(&evt_struct->list)) {
+		printk(KERN_ERR "ibmvscsi: unexpected SRP response received!\n");
+		return;
+	} else {
+		list_del(&evt_struct->list);
+	}
+
+	if(crq->format == VIOSRP_SRP_FORMAT)
+		atomic_add(evt_struct->evt->srp.rsp.request_limit_delta, &hostdata->request_limit);
+
+	if(evt_struct->done)
+		evt_struct->done(evt_struct);
+	else
+		printk(KERN_ERR "ibmvscsi: returned done() is NULL; not running it!\n");
+}
+
+/* ------------------------------------------------------------
+ * SCSI driver registration
+ */
+static struct scsi_host_template driver_template = {
+	.name = "SCSI host adapter emulator for RPA/iSeries Virtual I/O",
+	.proc_name = "ibmvscsi",
+	.queuecommand = ibmvscsi_queue,
+	.eh_abort_handler = ibmvscsi_abort,
+	.can_queue = 1, /* Updated after SRP_LOGIN */
+	.this_id = -1,
+	.sg_tablesize = MAX_INDIRECT_BUFS,
+	.cmd_per_lun = 1, 
+	.use_clustering = DISABLE_CLUSTERING,
+	.emulated = 1
+};
+
+/**
+ * Called by bus code for each adapter
+ */
+struct ibmvscsi_host_data *ibmvscsi_probe(struct device *dev)
+{
+	struct ibmvscsi_host_data *hostdata;
+	struct Scsi_Host *host;
+	
+	host = scsi_host_alloc(&driver_template, sizeof(*hostdata));
+	if(!host) {
+		printk(KERN_ERR "ibmvscsi: couldn't allocate host data\n");
+		goto scsi_host_alloc_failed;
+	}
+	
+	hostdata = (struct ibmvscsi_host_data *)host->hostdata;
+	memset(hostdata, 0x00, sizeof(*hostdata));
+	INIT_LIST_HEAD(&hostdata->sent);
+	INIT_WORK(&hostdata->srp_task, (void *)ibmvscsi_task, hostdata);
+	hostdata->host = host;
+	hostdata->dev = dev;
+	atomic_set(&hostdata->request_limit, -1);
+		
+	if(ibmvscsi_init_crq_queue(&hostdata->queue, hostdata) != 0) {
+		printk(KERN_ERR "ibmvscsi: couldn't initialize crq\n");
+		goto init_crq_failed;
+	}
+	if(initialize_event_pool(&hostdata->pool, IBMVSCSI_MAX_REQUESTS, hostdata) != 0) {
+		printk(KERN_ERR "ibmvscsi: couldn't initialize event pool\n");
+		goto init_pool_failed;
+	}
+	if(ibmvscsi_send_crq(hostdata, 0xC001000000000000, 0) != 0){
+		printk(KERN_ERR "ibmvscsi: couldn't send init cmd\n");
+		goto send_crq_failed;
+	}
+	
+	host->max_lun = 8;
+	host->max_id = max_id;
+	host->max_channel = max_channel;
+	
+	/* Block requests until we get the SRP login back */
+	scsi_block_requests(host);
+	
+	if (!scsi_add_host(hostdata->host, hostdata->dev)) {
+		
+	    scsi_scan_host(host);
+	    return hostdata;
+	}
+	
+	printk(KERN_ERR "ibmvscsi: couldn't SRP_LOGIN to remote host\n");
+	
+ send_crq_failed:
+	release_event_pool(&hostdata->pool, hostdata);
+ init_pool_failed:
+	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata);
+ init_crq_failed:
+	scsi_host_put(host);
+ scsi_host_alloc_failed:
+	return NULL;
+}
+
+int ibmvscsi_remove(struct ibmvscsi_host_data *hostdata)
+{
+	/* send an SRP_I_LOGOUT */
+	printk(KERN_INFO "ibmvscsi: remove called\n");
+	
+	release_event_pool(&hostdata->pool, hostdata);
+	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata);
+
+	scsi_host_put(hostdata->host);
+	return 0;
+}
+
+int __init ibmvscsi_module_init(void)
+{
+	return ibmvscsi_register_driver();
+}
+
+void __exit ibmvscsi_module_exit(void)
+{
+	ibmvscsi_unregister_driver();
+}	
+module_init(ibmvscsi_module_init);
+module_exit(ibmvscsi_module_exit);
diff -uNr --exclude=SCCS --exclude=*.o --exclude=*.cmd linux-2.5/drivers/scsi/ibmvscsi/ibmvscsi.h ppc64-2.5new/drivers/scsi/ibmvscsi/ibmvscsi.h
--- linux-2.5/drivers/scsi/ibmvscsi/ibmvscsi.h	Wed Dec 31 18:00:00 1969
+++ ppc64-2.5new/drivers/scsi/ibmvscsi/ibmvscsi.h	Sun Feb 22 16:06:46 2004
@@ -0,0 +1,111 @@
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
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <linux/dma-mapping.h>
+#include <linux/completion.h>
+#include "viosrp.h"
+
+/**
+ * Work out the number of scatter/gather buffers we support
+ */
+static const struct SRP_CMD *fake_srp_cmd = NULL;
+enum {
+	IBMVSCSI_MAX_REQUESTS = 50,
+	MAX_INDIRECT_BUFS = (sizeof(fake_srp_cmd->additional_data) - sizeof(struct indirect_descriptor)) / sizeof(struct memory_descriptor)
+};
+
+/* ------------------------------------------------------------
+ * Data Structures
+ */
+/* an RPA command/response transport queue */
+struct crq_queue {
+	struct VIOSRP_CRQ *msgs;
+	int size, cur;
+	dma_addr_t msg_token;
+	spinlock_t lock;
+};
+
+/* a unit of work for the hosting partition */
+struct srp_event_struct {
+	union VIOSRP_IU *evt;		/* the actual SRP IU to send */
+	struct scsi_cmnd  *cmnd;		/* data to use for callback */
+	struct list_head list;		/* queued or sent list for active events*/
+	void (*done)(struct srp_event_struct *);	/* run done(this) when it comes back */
+	struct VIOSRP_CRQ crq;		/* points to *evt for DMA */
+	struct ibmvscsi_host_data *hostdata;
+	char in_use;
+	/* for the queue case only: */
+	struct SRP_CMD cmd;
+	void (*cmnd_done)(struct scsi_cmnd *);	/* special _done_ passed with scsi cmd */
+	struct completion comp;
+};
+
+/* a pool of event structs for use */
+struct event_pool {
+	struct srp_event_struct *events;
+	u32 size;
+	spinlock_t lock;
+	union VIOSRP_IU *iu_storage;
+	dma_addr_t iu_token;
+};
+
+/* all driver data associated with a host adapter */
+struct ibmvscsi_host_data {
+	atomic_t request_limit;
+	struct device *dev;
+	struct event_pool pool;
+	struct crq_queue queue;
+	struct work_struct srp_task;
+	spinlock_t lock; /* lock for queues */
+	struct list_head sent;
+	struct Scsi_Host *host;
+};
+
+
+int ibmvscsi_register_driver(void);
+void ibmvscsi_unregister_driver(void);
+
+/* routines for managing a command/response queue */
+int ibmvscsi_init_crq_queue(struct crq_queue *queue, struct ibmvscsi_host_data *hostdata);
+void ibmvscsi_release_crq_queue(struct crq_queue *queue, struct ibmvscsi_host_data *hostdata);
+void ibmvscsi_handle_crq(struct VIOSRP_CRQ *crq, struct ibmvscsi_host_data *hostdata);
+int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata, u64 word1, u64 word2);
+
+/* Probe/remove routines */
+struct ibmvscsi_host_data *ibmvscsi_probe(struct device *dev);
+int ibmvscsi_remove(struct ibmvscsi_host_data *hostdata);
+
+void ibmvscsi_task(unsigned long data);
+
+#endif /* IBMVSCSI_H */
diff -uNr --exclude=SCCS --exclude=*.o --exclude=*.cmd linux-2.5/drivers/scsi/ibmvscsi/iseries_vscsi.c ppc64-2.5new/drivers/scsi/ibmvscsi/iseries_vscsi.c
--- linux-2.5/drivers/scsi/ibmvscsi/iseries_vscsi.c	Wed Dec 31 18:00:00 1969
+++ ppc64-2.5new/drivers/scsi/ibmvscsi/iseries_vscsi.c	Sun Feb 22 21:56:16 2004
@@ -0,0 +1,157 @@
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
+#include "ibmvscsi.h"
+
+/* global variables */
+extern struct device *iSeries_vio_dev;
+static struct ibmvscsi_host_data *single_host_data = NULL; 
+
+/* ------------------------------------------------------------
+ * Routines for managing the command/response queue
+ */
+
+/* ------------------------------------------------------------
+ * Routines for direct interpartition interaction
+ */
+struct VIOSRPLpEvent {
+    struct HvLpEvent lpevt;	/* 0x00-0x17          */
+    u32 reserved1;		/* 0x18-0x1B; unused  */
+    u16 version;		/* 0x1C-0x1D; unused  */
+    u16 subtype_rc;		/* 0x1E-0x1F; unused  */
+    struct VIOSRP_CRQ crq;	/* 0x20-0x3F          */
+};
+
+/**
+ * This stub is needed by ibmvscsi
+ */
+void ibmvscsi_task(unsigned long data) 
+{
+}
+
+/** 
+ * standard interface for handling logical partition events.
+ */
+static void ibmvscsi_handle_event(struct HvLpEvent *lpevt)
+{
+	struct VIOSRPLpEvent *evt = (struct VIOSRPLpEvent *)lpevt;
+
+	if(!evt) {
+		printk(KERN_ERR "ibmvscsi: received null event\n");
+		return;
+	}
+
+	if (single_host_data == NULL) {
+		printk(KERN_ERR "ibmvscsi: received event, no adapter present\n");
+		return;
+	}
+	
+	ibmvscsi_handle_crq(&evt->crq, single_host_data);
+}
+
+/* ------------------------------------------------------------
+ * Routines for driver initialization
+ */
+int ibmvscsi_init_crq_queue(struct crq_queue *queue, struct ibmvscsi_host_data *hostdata)
+{
+	int rc;
+
+	rc = viopath_open(viopath_hostLp, viomajorsubtype_scsi, 0);
+	if (rc < 0) {
+		printk("viopath_open failed with rc %d in open_event_path\n", rc);
+		goto viopath_open_failed;
+	}
+
+	rc = vio_setHandler(viomajorsubtype_scsi, ibmvscsi_handle_event);
+	if (rc < 0) {
+		printk("vio_setHandler failed with rc %d in open_event_path\n", rc);
+		goto vio_setHandler_failed;
+	}
+	return 0;
+
+vio_setHandler_failed:
+	viopath_close(viopath_hostLp, viomajorsubtype_scsi,
+		IBMVSCSI_MAX_REQUESTS);
+viopath_open_failed:
+	return -1;
+}
+
+void ibmvscsi_release_crq_queue(struct crq_queue *queue, struct ibmvscsi_host_data *hostdata)
+{
+	vio_clearHandler(viomajorsubtype_scsi);
+	viopath_close(viopath_hostLp, viomajorsubtype_scsi,
+		IBMVSCSI_MAX_REQUESTS);
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
+	return HvCallEvent_signalLpEventFast(
+		viopath_hostLp,
+		HvLpEvent_Type_VirtualIo,
+		viomajorsubtype_scsi,
+		HvLpEvent_AckInd_NoAck,
+		HvLpEvent_AckType_ImmediateAck,
+		viopath_sourceinst(viopath_hostLp),
+		viopath_targetinst(viopath_hostLp),
+		0,
+		VIOVERSION << 16, word1, word2, 0, 0);
+}
+
+/**
+ * ibmvscsi_register_driver:  the call back from the generic ibmvscsi code at startup
+ * time.
+ */
+int ibmvscsi_register_driver(void)
+{
+	single_host_data = ibmvscsi_probe(iSeries_vio_dev);
+	return (single_host_data == NULL);
+}
+
+/**
+ * ibmvscsi_unregister_driver:  the call back from the generic ibmvscsi code at shutdown
+ * time.
+ */
+void ibmvscsi_unregister_driver(void)
+{
+	ibmvscsi_remove(single_host_data);
+}	
+
+
diff -uNr --exclude=SCCS --exclude=*.o --exclude=*.cmd linux-2.5/drivers/scsi/ibmvscsi/rpa_vscsi.c ppc64-2.5new/drivers/scsi/ibmvscsi/rpa_vscsi.c
--- linux-2.5/drivers/scsi/ibmvscsi/rpa_vscsi.c	Wed Dec 31 18:00:00 1969
+++ ppc64-2.5new/drivers/scsi/ibmvscsi/rpa_vscsi.c	Sun Feb 22 16:07:48 2004
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
+#include <asm/pci_dma.h>
+#include <asm/hvcall.h>
+#include "ibmvscsi.h"
+#include <linux/interrupt.h> 
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
+irqreturn_t ibmvscsi_handle_event(int irq, void *dev_instance, struct pt_regs *regs)
+{
+	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)dev_instance;
+	vio_disable_interrupts(to_vio_dev(hostdata->dev));
+	schedule_work(&hostdata->srp_task);
+	return IRQ_HANDLED;
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
+int ibmvscsi_init_crq_queue(struct crq_queue *queue, struct ibmvscsi_host_data *hostdata)
+{
+	int rc;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+
+	queue->msgs = (struct VIOSRP_CRQ *)get_zeroed_page(GFP_KERNEL);
+
+	if(!queue->msgs)
+		goto malloc_failed;
+	queue->size = PAGE_SIZE / sizeof(*queue->msgs);
+
+	if((queue->msg_token = dma_map_single(hostdata->dev, queue->msgs, queue->size * sizeof(*queue->msgs), PCI_DMA_BIDIRECTIONAL)) == NO_TCE)
+		goto map_failed;
+
+	rc = plpar_hcall_norets(H_REG_CRQ, vdev->unit_address, queue->msg_token, PAGE_SIZE);
+	if (rc != 0) {
+		printk(KERN_WARNING "ibmvscsi: couldn't register crq--rc 0x%x\n", rc);
+		goto reg_crq_failed;
+	}
+
+	if(request_irq(vdev->irq, &ibmvscsi_handle_event, 0, "ibmvscsi", (void *)hostdata) != 0) {
+		printk(KERN_ERR "ibmvscsi: couldn't register irq 0x%x\n", vdev->irq);
+		goto req_irq_failed;
+	}
+	
+	rc = vio_enable_interrupts(vdev);
+	if (rc != 0) {
+		printk(KERN_ERR "ibmvscsi:  Error %d enabling interrupts!!!\n",rc);
+		goto req_irq_failed;
+	}
+
+
+	queue->cur = 0;
+	queue->lock = SPIN_LOCK_UNLOCKED;
+	return 0;
+
+req_irq_failed:
+	plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
+reg_crq_failed:
+	dma_unmap_single(hostdata->dev, queue->msg_token, queue->size * sizeof(*queue->msgs), PCI_DMA_BIDIRECTIONAL);
+map_failed:
+	free_page((unsigned long)queue->msgs);
+malloc_failed:
+	return -1;
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
+void ibmvscsi_release_crq_queue(struct crq_queue *queue, struct ibmvscsi_host_data *hostdata)
+{
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+	free_irq(vdev->irq, (void *)hostdata);
+	plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
+	dma_unmap_single(hostdata->dev, queue->msg_token, queue->size * sizeof(*queue->msgs), PCI_DMA_BIDIRECTIONAL);
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
+static struct VIOSRP_CRQ *crq_queue_next_crq(struct crq_queue *queue)
+{
+	struct VIOSRP_CRQ *crq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->lock, flags);
+	crq = &queue->msgs[queue->cur];
+	if(crq->valid & 0x80) {
+		if(++queue->cur == queue->size)
+			queue->cur = 0;
+	}
+	else
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
+void ibmvscsi_task(unsigned long data) 
+{
+	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)data;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+	struct VIOSRP_CRQ *crq;
+	int done = 0;
+
+	while (!done)
+	{
+		/* Pull all the valid messages off the CRQ */
+		while((crq = crq_queue_next_crq(&hostdata->queue)) != NULL) {
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
+ * rpa_device_table: Used by vio.c to match devices in the device tree we 
+ * support.
+ */
+static struct vio_device_id rpa_device_table[] __devinitdata = {
+    { "scsi-3", "IBM,v-scsi" }, /* Note: This entry can go away when all the firmware is up to date */ 
+    { "vscsi",  "IBM,v-scsi" },
+    { 0,}
+};
+                                                                                
+/**
+ * rpa_probe: The callback from the virtual I/O bus code.
+ * @vdev     : The vio specific device structure
+ * @id       : the device id..we don't currently use it
+ */
+static int rpa_probe(struct vio_dev *vdev, const struct vio_device_id *id) 
+{
+	struct ibmvscsi_host_data *hostdata = ibmvscsi_probe(&vdev->dev);
+	if (hostdata) {
+		vdev->driver_data = hostdata;
+		return 0;
+	} else {
+		return -1;
+	}
+}
+
+/**
+ * rpa_remove: The callback from the virtual I/O bus code to remove a device
+ * @vdev     : The vio specific device structure
+ */
+static int rpa_remove(struct vio_dev *vdev)
+{
+	int rc;
+	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)vdev->driver_data;
+	rc = ibmvscsi_remove(hostdata);
+	return rc;
+}
+
+MODULE_DEVICE_TABLE(vio, rpa_device_table);
+char rpa_driver_name[] = "ibmvscsi";                                                                            
+static struct vio_driver ibmvscsi_driver = {
+	.name		= rpa_driver_name,
+	.id_table	= rpa_device_table,
+	.probe		= rpa_probe,
+	.remove		= rpa_remove
+};
+
+/**
+ * ibmvscsi_register_driver:  the call back from the generic ibmvscsi code at startup
+ * time.
+ */
+int ibmvscsi_register_driver(void)
+{
+	return vio_register_driver(&ibmvscsi_driver);
+}
+
+/**
+ * ibmvscsi_unregister_driver:  the call back from the generic ibmvscsi code at shutdown
+ * time.
+ */
+void ibmvscsi_unregister_driver(void)
+{
+	vio_unregister_driver(&ibmvscsi_driver);
+}	
+
diff -uNr --exclude=SCCS --exclude=*.o --exclude=*.cmd linux-2.5/drivers/scsi/ibmvscsi/srp.h ppc64-2.5new/drivers/scsi/ibmvscsi/srp.h
--- linux-2.5/drivers/scsi/ibmvscsi/srp.h	Wed Dec 31 18:00:00 1969
+++ ppc64-2.5new/drivers/scsi/ibmvscsi/srp.h	Sun Feb 22 03:10:38 2004
@@ -0,0 +1,218 @@
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
+enum SRP_TYPES {
+	SRP_LOGIN_REQ_TYPE = 0x00,
+	SRP_LOGIN_RSP_TYPE = 0xC0,
+	SRP_LOGIN_REJ_TYPE = 0x80,
+	SRP_I_LOGOUT_TYPE  = 0x03,
+	SRP_T_LOGOUT_TYPE  = 0x80,
+	SRP_TSK_MGMT_TYPE  = 0x01,
+	SRP_CMD_TYPE       = 0x02,
+	SRP_RSP_TYPE       = 0xC1,
+	SRP_CRED_REQ_TYPE  = 0x81,
+	SRP_CRED_RSP_TYPE  = 0x41,
+	SRP_AER_REQ_TYPE   = 0x82,
+	SRP_AER_RSP_TYPE   = 0x42
+};
+
+enum SRP_DESCRIPTOR_FORMATS {
+	SRP_NO_BUFFER = 0x00,
+	SRP_DIRECT_BUFFER = 0x01,
+	SRP_INDIRECT_BUFFER = 0x02
+};
+
+struct memory_descriptor {
+	u64 virtual_address; // 0x00
+	u32 memory_handle; // 0x08
+	u32 length; // 0x0C
+}; // 0x10
+
+struct indirect_descriptor {
+	struct memory_descriptor head;
+	u64 total_length;
+	struct memory_descriptor list[1];
+};
+
+struct SRP_GENERIC {
+	u8 type; // 0x00
+	u8 reserved1[7]; // 0x01
+	u64 tag; // 0x08
+}; // 0x10
+
+struct SRP_LOGIN_REQ {
+	u8 type;         // 0x00
+	u8 reserved1[7]; // 0x01
+	u64 tag;         // 0x08
+	u32 max_requested_initiator_to_target_iulen; // 0x10
+	u32 reserved2; // 0x14
+	u16 required_buffer_formats; // 0x18
+	u8 reserved3:6; u8 multi_channel_action:2; // 0x1A
+	u8 reserved4; // 0x1B
+	u32 reserved5; // 0x1C
+	u8 initiator_port_identifier[16]; // 0x20
+	u8 target_port_identifier[16]; // 0x30
+}; // 0x40
+
+struct SRP_LOGIN_RSP {
+	u8 type; // 0x00
+	u8 reserved1[3]; // 0x01
+	u32 request_limit_delta; // 0x04
+	u64 tag; // 0x08
+	u32 max_initiator_to_target_iulen; // 0x10
+	u32 max_target_to_initiator_iulen; // 0x14
+	u16 supported_buffer_formats;       // 0x18
+	u8 reserved2:6; u8 multi_channel_result:2; // 0x1A
+	u8 reserved3; // 0x1B
+	u8 reserved4[24]; // 0x1C
+}; // 0x34
+
+struct SRP_LOGIN_REJ {
+	u8 type; // 0x00
+	u8 reserved1[3]; // 0x01
+	u32 reason; // 0x04
+	u64 tag; // 0x08
+	u64 reserved2; // 0x10
+	u16 supported_buffer_formats; // 0x18
+	u8 reserved3[6]; // 0x1A
+}; // 0x20
+
+struct SRP_I_LOGOUT {
+	u8 type; // 0x00
+	u8 reserved1[7]; // 0x01
+	u64 tag; // 0x08
+}; // 0x10
+
+struct SRP_T_LOGOUT {
+	u8 type; // 0x00
+	u8 reserved1[3]; // 0x01
+	u32 reason; // 0x04
+	u64 tag; // 0x08
+}; // 0x10
+
+struct SRP_TSK_MGMT {
+	u8 type; // 0x00
+	u8 reserved1[7]; // 0x01
+	u64 tag; // 0x08
+	u32 reserved2; // 0x10
+	u64 lun PACKED; // 0x14
+	u8 reserved3; // 0x1C
+	u8 reserved4; // 0x1D
+	u8 task_mgmt_flags; // 0x1E
+	u8 reserved5; // 0x1F
+	u64 managed_task_tag; // 0x20
+	u64 reserved6; // 0x28
+}; // 0x30
+
+struct SRP_CMD {
+	u8 type;              // 0x00
+	u32 reserved1 PACKED;		  // 0x01
+	u8 data_out_format:4; u8 data_in_format:4; // 0x05
+	u8 data_out_count;    // 0x06
+	u8 data_in_count;     // 0x07
+	u64 tag;              // 0x08
+	u32 reserved2;        // 0x10
+	u64 lun PACKED;           // 0x14
+	u8 reserved3;         // 0x1C
+	u8 reserved4:5; u8 task_attribute:3;  // 0x1D
+	u8 reserved5;         // 0x1E
+	u8 additional_cdb_len; // 0x1F
+	u8 cdb[16];           // 0x20
+	u8 additional_data[0x100 - 0x30]; // 0x30
+}; // 0x100
+
+struct SRP_RSP {
+	u8 type; // 0x00
+	u8 reserved1[3]; // 0x01
+	u32 request_limit_delta; // 0x04
+	u64 tag; // 0x08
+	u16 reserved2; // 0x10
+	u8 reserved3:2; // 0x12
+		u8 diunder:1; u8 diover:1;
+		u8 dounder:1; u8 doover:1;
+		u8 snsvalid:1; u8 rspvalid:1;
+	u8 status; // 0x13
+	u32 data_in_residual_count; // 0x14
+	u32 data_out_residual_count; // 0x18
+	u32 sense_data_list_length; // 0x1C
+	u32 response_data_list_length; // 0x20
+	u8 sense_and_response_data[18]; // 0x24
+}; // 0x36
+
+struct SRP_CRED_REQ {
+	u8 type; // 0x00
+	u8 reserved1[3]; // 0x01
+	u32 request_limit_delta; // 0x04
+	u64 tag; // 0x08
+}; // 0x10
+
+struct SRP_CRED_RSP {
+	u8 type; // 0x00
+	u8 reserved1[7]; // 0x01
+	u64 tag; // 0x08
+}; // 0x10
+
+struct SRP_AER_REQ {
+	u8 type; // 0x00
+	u8 reserved1[3]; // 0x01
+	u32 request_limit_delta; // 0x04
+	u64 tag; // 0x08
+	u32 reserved2; // 0x10
+	u64 lun; // 0x14
+	u32 sense_data_list_length; // 0x1C
+	u32 reserved3; // 0x20
+	u8 sense_data[20]; // 0x24
+}; // 0x38
+
+struct SRP_AER_RSP {
+	u8 type; // 0x00
+	u8 reserved1[7]; // 0x01
+	u64 tag; // 0x08
+}; // 0x10
+
+union SRP_IU {
+	struct SRP_GENERIC generic;
+	struct SRP_LOGIN_REQ login_req;
+	struct SRP_LOGIN_RSP login_rsp;
+	struct SRP_LOGIN_REJ login_rej;
+	struct SRP_I_LOGOUT i_logout;
+	struct SRP_T_LOGOUT t_logout;
+	struct SRP_TSK_MGMT tsk_mgmt;
+	struct SRP_CMD cmd;
+	struct SRP_RSP rsp;
+	struct SRP_CRED_REQ cred_req;
+	struct SRP_CRED_RSP cred_rsp;
+	struct SRP_AER_REQ aer_req;
+	struct SRP_AER_RSP aer_rsp;
+};
+
+#endif
diff -uNr --exclude=SCCS --exclude=*.o --exclude=*.cmd linux-2.5/drivers/scsi/ibmvscsi/viosrp.h ppc64-2.5new/drivers/scsi/ibmvscsi/viosrp.h
--- linux-2.5/drivers/scsi/ibmvscsi/viosrp.h	Wed Dec 31 18:00:00 1969
+++ ppc64-2.5new/drivers/scsi/ibmvscsi/viosrp.h	Sun Feb 22 21:23:37 2004
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
+enum VIOSRP_CRQ_FORMATS {
+	VIOSRP_SRP_FORMAT = 0x01,
+	VIOSRP_MAD_FORMAT = 0x02,
+	VIOSRP_OS400_FORMAT = 0x03,
+	VIOSRP_AIX_FORMAT = 0x04,
+	VIOSRP_LINUX_FORMAT = 0x06,
+	VIOSRP_INLINE_FORMAT = 0x07
+};
+
+struct VIOSRP_CRQ {
+	u8 valid;		// used by RPA
+	u8 format;		// SCSI vs out-of-band
+	u8 reserved;
+	u8 status;		// non-scsi failure? (e.g. DMA failure)
+	u16 timeout;		// in seconds
+	u16 IU_length;		// in bytes
+	u64 IU_data_ptr;	// the TCE for transferring data
+};
+
+/* MADs are Management requests above and beyond the IUs defined in the SRP
+ * standard.  
+ */
+enum VIOSRP_MAD_TYPES {
+	VIOSRP_EMPTY_IU_TYPE = 0x01,
+	VIOSRP_ERROR_LOG_TYPE = 0x02,
+	VIOSRP_ADAPTER_INFO_TYPE = 0x03,
+	VIOSRP_HOST_CONFIG_TYPE = 0x04
+};
+
+/* 
+ * Common MAD header
+ */
+struct MAD_COMMON {
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
+struct VIOSRP_EMPTY_IU {
+	struct MAD_COMMON common;
+	u64 buffer;
+	u32 port;
+};
+
+struct VIOSRP_ERROR_LOG {
+	struct MAD_COMMON common;
+	u64 buffer;
+};
+
+struct VIOSRP_ADAPTER_INFO {
+	struct MAD_COMMON common;
+	u64 buffer;
+};
+
+struct VIOSRP_HOST_CONFIG {
+	struct MAD_COMMON common;
+	u64 buffer;
+};
+
+union MAD_IU {
+	struct VIOSRP_EMPTY_IU empty_iu;
+	struct VIOSRP_ERROR_LOG error_log;
+	struct VIOSRP_ADAPTER_INFO adapter_info;
+	struct VIOSRP_HOST_CONFIG host_config;
+};
+
+union VIOSRP_IU {
+	union SRP_IU srp;
+	union MAD_IU mad;
+};
+
+struct MAD_ADAPTER_INFO_DATA {
+    char srp_version[8];
+    char partition_name[96];
+    u32 partition_number;
+    u32 mad_version;
+    u32 os_type;
+    u32 port_max_txu[8]; /* per-port maximum transfer */
+};
+
+#endif
--- linux-2.5/drivers/scsi/Kconfig	Sun Feb 22 21:35:01 2004
+++ ppc64-2.5new/drivers/scsi/Kconfig	Sun Feb 22 03:18:22 2004
@@ -725,6 +725,15 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called ips.
 
+config SCSI_IBMVSCSI
+	tristate "IBM Virtual SCSI support"
+	depends on PPC_PSERIES || PPC_ISERIES
+	help
+	  This is the IBM Virtual SCSI Client
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ibmvscsic.
+
 config SCSI_INITIO
 	tristate "Initio 9100U(W) support"
 	depends on PCI && SCSI && BROKEN

------------wspLrvyj4U2o1X7B5y3YFx--

