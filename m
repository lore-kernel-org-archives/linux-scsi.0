From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ibmvscsi driver
Date: Mon, 9 Feb 2004 21:27:56 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209212756.A26996@infradead.org>
References: <opr232htwdl6e53g@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:34579 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262902AbUBIV2A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 16:28:00 -0500
Content-Disposition: inline
In-Reply-To: <opr232htwdl6e53g@us.ibm.com>; from sleddog@us.ibm.com on Mon, Feb 09, 2004 at 10:23:43AM -0600
List-Id: linux-scsi@vger.kernel.org
To: Dave Boutcher <sleddog@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Feb 09, 2004 at 10:23:43AM -0600, Dave Boutcher wrote:
> I would like to submit the following new driver for inclusion in the 2.6 
> kernel.  This is the first patch I'm sending outside of IBM, so I expect 
> there will be comments.
> 
> This driver supports Linux in one logical partition using a SCSI device in 
> a different logical partition on IBM PPC64 systems (similar in function to 
> what VMWare provides.)  I will be submitting the server-side shortly, but 
> the client side stands alone functionally, since the server can be Linux 
> or a couple of IBM operating systems (versions of which have not been 
> released yet.)


+EXTRA_CFLAGS += -Idrivers/scsi

	A modern scsi driver shouldn't use headers from there.
	Use the scsi headers in include/scsi.

+obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsic.o
+
+ifeq ($(CONFIG_PPC_ISERIES),y)
+  ibmvscsic-objs	:= ibmvscsi.o iSeries_vscsi.o
+else
+  ibmvscsic-objs	:= ibmvscsi.o rpa_vscsi.o
+endif

	Should be more like:

obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsic.o
ibmvscsic-y			+= ibmvscsi.o
ibvmscsic-$(CONFIG_PPC_ISERIES)	+= iSeries_vscsi.o
ibvmscsic-$(CONFIG_PPC_PSERIES)	+= rpa_vscsi.o

	And please write iseries lowercase - we're not a marketing department.


+/**
+ * ibmvscsi_send_srp_event: - Transforms event to u64 array and calls send_crq()
+ * @evt_struct:	evt_struct to be sent
+ * @hostdata:	ibmvscsi_host_data of host
+ * @pending:    This came off the pending queue.  If can't be sent, put it back
+ *              at the head.
+ *
+ * Returns the value returned from ibmvscsi_send_crq(). (Zero for success)
+*/
+static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct, struct ibmvscsi_host_data *hostdata, int pending)
+{
+	u64 *crq_as_u64 = (u64*)&evt_struct->crq;
+
+	/* If we have exhausted our request limit, just queue this request */
+	if (atomic_dec_return(&hostdata->request_limit) < 0) {

	Please use can_queue in the host template for this instead of redoing it
	yourself.

+		atomic_inc(&hostdata->request_limit);
+		spin_lock(&hostdata->lock);
+		if (pending) {
+			list_add(&evt_struct->list, &hostdata->queued);
+		} else {
+			list_add_tail(&evt_struct->list, &hostdata->queued);
+		}
+		spin_unlock(&hostdata->lock);
+		return 0;

	don't do your own queuing.  The midlayer has much better code for that.


+	} else {
+		/* Add this to the sent list.  We need to do this before we actually send 
+		 * in case it comes back REALLY fast
+		 */
+		spin_lock(&hostdata->lock);
+		list_add_tail(&evt_struct->list, &hostdata->sent);
+		spin_unlock(&hostdata->lock);

	What's the point of the sent list?  I can't see it referenced anywhere.

+/**
+ * ibmvscsi_queue: - The queuecommand function of the scsi template 
+ * @cmd:	Scsi_Cmnd to be executed
+ * @done:	Callback function to be called when cmd is completed
+ *
+ * Always returns zero
+*/
+static int ibmvscsi_queue(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
+{
+	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)&cmd->device->host->hostdata;
+	struct srp_event_struct *evt_struct = scsi_cmd_to_event_struct(cmd, done, hostdata);
+
+	if (!evt_struct) {
+		printk(KERN_ERR "ibmvscsi: unable to convert Scsi_Cmnd to LpEvent\n");
+		cmd->result = DID_ERROR << 16;
+		done(cmd);
+		return 0;
+	}

	Bogus, return SCSI_MLQUEUE_HOST_BUSY here to let the midlayer retry for you.

+/**
+ * send_report_luns: - Generate a report LUNS command and send it to the
+ * server.  We need to do this to figure out how many bus/targets are
+ * really over there.
+ *
+ * Note that we can's use the scsi_lib routines for allocating a command
+ * etc. because we haven't actually added our host yet.
+ *
+ * @hostdata::	the adapter we are asking about
+ *
+*/

	So don't call REPORT_LUNS.  It's up to the midlayer to do that.

+static const char *ibmvscsi_info(struct Scsi_Host *host)
+{
+	return "SCSI host adapter emulator for RPA/iSeries Virtual I/O";
+}

	This is a constant string.  Just stick it into ->name


+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
+static int ibmvscsi_bios(Scsi_Disk *disk, kdev_t dev, int *parm)
+{
+	off_t capacity = disk->capacity;
+#else
+static int ibmvscsi_bios(struct scsi_device *sdev, struct block_device *bdev, sector_t capacity, int parm[3])
+{
+#endif
+	parm[0] = 255;
+	parm[1] = 63;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+	parm[2] = capacity / (parm[0] * parm[1]);
+#else
+	sector_div(capacity, 255*63);
+#endif
+	parm[2] = capacity;
+	return 0;
+}

	any reason the default disc geometry doesn't work for you?  Also the ifdefs
	are horrible.
	And while we're at it, please name your entry points ibmvscsi_<entrypointname>,
	not something slightly different.  This makes grepping much worse than it should be.


+#if LINUX_VERSION_CODE >= 0x020600
+	INIT_BOTTOM_HALF(&hostdata->scan_task, (void *)ibmvscsi_scan_task, (unsigned long)hostdata);
+	hostdata->srp_workqueue = create_workqueue("ibmvscsi");
+#endif

	Don't do that.  If you want asynch scanning do it from userland.

+int ibmvscsi_remove_generic(struct ibmvscsi_host_data *hostdata)
+{
+	/* send an SRP_I_LOGOUT */
+	printk("ibmvscsi: release called\n");

where's your scsi_remove_host?

+	
+	release_event_pool(&hostdata->pool, hostdata);
+	release_crq_queue(&hostdata->queue, hostdata);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	hostdata->srp_workqueue = create_workqueue("ibmvscsi");

	huh, creating a workqueue in a removal method?

+
+	/* Note that in 2.4 this is taken care of by scsi_module.c */
+	scsi_host_put(hostdata->host);
+#endif
+	return 0;
+}

+#include "scsi.h"

	don't include this in a 2.6 scsi driver.

+/* ------------------------------------------------------------
+ * Platform-specific includes and definitions
+ */
+#ifdef CONFIG_PPC_ISERIES
+#define dma_dev              pci_dev
+#define dma_map_single       pci_map_single
+#define dma_unmap_single     pci_unmap_single
+#define dma_alloc_consistent pci_alloc_consistent
+#define dma_free_consistent  pci_free_consistent
+#define dma_map_sg           pci_map_sg
+#define dma_device_id        void
+#define SG_TABLESIZE		SG_ALL
+#else /* CONFIG_PPC_ISERIES */
+#define dma_dev              vio_dev
+#define dma_map_single       vio_map_single
+#define dma_unmap_single     vio_unmap_single
+#define dma_alloc_consistent vio_alloc_consistent
+#define dma_free_consistent  vio_free_consistent
+#define dma_map_sg           vio_map_sg
+#define dma_device_id        struct vio_device_id 
+#define SG_TABLESIZE		MAX_INDIRECT_BUFS	
+#endif

	Yikes!  Please use the real dma_ foo interface that operate on struct device
	instead.

+/* global variables */
+irqreturn_t ibmvscsi_handle_event(int irq, void *dev_instance, struct pt_regs *regs);

	Please just implement it before using it.  And mark it static.

+	//if(request_irq(hostdata->dmadev->irq, &ibmvscsi_handle_event, SA_INTERRUPT, "ibmvscsi", (void *)hostdata) != 0) {
+	if(request_irq(hostdata->dmadev->irq, &ibmvscsi_handle_event, 0, "ibmvscsi", (void *)hostdata) != 0) {

	So which version do you want to keep? :)  The & is superflous, too.

+irqreturn_t ibmvscsi_handle_event(int irq, void *dev_instance, struct pt_regs *regs)
+{
+	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)dev_instance;
+	ibmvscsi_disable_interrupts(hostdata->dmadev);
+	SCHEDULE_BOTTOM_HALF_QUEUE(hostdata->srp_workqueue,&hostdata->srp_task);

	Please this horrible SHOUTING macro.  If you really want one source for 2.4 &
	2.6 (which I wouldn't recommend) emulate the 2.6 interface on 2.4.

+static atomic_t ibmvscsi_host_count;
+int ibmvscsi_detect(Scsi_Host_Template * host_template)
+{
+	int host_count;
+	ibmvscsi_driver.driver_data = (unsigned long)host_template;
+	host_count = vio_register_driver(&ibmvscsi_driver);
+	atomic_set(&ibmvscsi_host_count, host_count);
+	
+	return host_count;
+}
+
+/* All we do on release (called by the older SCSI infrastructure) is
+ * decrement a counter.  When the counter goes to zero, we call
+ * vio_unregister_driver, which will actually drive the remove of all
+ * the adapters
+ */
+int ibmvscsi_release(struct Scsi_Host *host)
+{
+	if (atomic_dec_return(&ibmvscsi_host_count) == 0) {
+		vio_unregister_driver(&ibmvscsi_driver);
+	}

	That's totally bogus.  Register the driver in module_init and remove it
	in module_exit and kill all this numbers of drivers crap.  And the bogus
	2.4ish scsi methods.

+/* global variables */
+extern struct dma_dev *iSeries_vio_dev;
+struct ibmvscsi_host_data *single_host_data = NULL; 

	No need to initialize to NULL, it's in .bss.

+/* ------------------------------------------------------------
+ * Routines for managing the command/response queue
+ */
+/* these routines should all be no-ops under iSeries; just succeed and end */
+
+int initialize_crq_queue(struct crq_queue *queue, struct ibmvscsi_host_data *hostdata)
+{
+	return 0;
+}
+
+void release_crq_queue(struct crq_queue *queue, struct ibmvscsi_host_data *hostdata)
+{
+}

Please stub out all those no-ops in the headers.

+
+/* For iSeries, there is architecturally never more than one
+ * virtual SCSI server for a partition.  So when the detect
+ * routine gets called, we just call "probe" once, as if we
+ * had found one adapter.
+ */
+int ibmvscsi_detect(Scsi_Host_Template * host_template)
+{
+	struct dma_dev *dma_dev;
+
+	if(!open_event_path()) {
+		printk("ibmvscsi: couldn't open vio event path\n");
+		return 0;
+	}
+	dma_dev = iSeries_vio_dev;
+	if(!dma_dev) {
+		printk("ibmvscsi: couldn't find a device to open\n");
+		vio_clearHandler(viomajorsubtype_scsi);
+		return 0;
+	}
+
+	single_host_data = ibmvscsi_probe_generic(dma_dev, NULL);
+
+	return 1;

Please call this directly instead of the 2.4ish _detect indirection.

+int ibmvscsi_release(struct Scsi_Host *host)
+{
+	struct ibmvscsi_host_data *hostdata = *(struct ibmvscsi_host_data **)&host->hostdata;
+	/* send an SRP_I_LOGOUT */
+	printk("ibmvscsi: release called\n");
+
+	ibmvscsi_remove_generic(hostdata);
+	single_host_data = NULL;

	you're just unloading, no need to reset.

+
+	vio_clearHandler(viomajorsubtype_scsi);
+	viopath_close(viopath_hostLp, viomajorsubtype_scsi,
+		IBMVSCSI_MAX_REQUESTS);
+	return 0;

	this whole function doesn't ever get called, does it?

+/**
+ * iSeries_vscsi_init: - Init function for module
+ *
+*/
+int __init ibmvscsi_module_init(void)
+{
+	printk(KERN_DEBUG "Loading iSeries_vscsi module\n");
+	inter_module_register("vscsi_ref", THIS_MODULE, NULL);
+	return 0;
+}

	What the heck is this?
