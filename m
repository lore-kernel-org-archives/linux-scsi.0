From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Mon, 19 Jan 2004 18:34:00 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119183400.A4182@infradead.org>
References: <40085EDA.4010802@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:5645 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262686AbUASSeO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 13:34:14 -0500
Content-Disposition: inline
In-Reply-To: <40085EDA.4010802@us.ibm.com>; from brking@us.ibm.com on Fri, Jan 16, 2004 at 03:59:54PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 16, 2004 at 03:59:54PM -0600, Brian King wrote:
> Hi,
> 
> I have just written a LLD for the IBM Power RAID family of adapters.
> This includes several IBM iSeries and pSeries SCSI adapters. Please
> review for 2.6 inclusion.

Here's some comments for thing I stumbled over.  Don't consider this
a full review yet.


+#include <linux/version.h>

You don't seem to need this one.

+#include <linux/proc_fs.h>

Dito.

+#include <linux/kdev_t.h>

You shouldn't need this one (haven't checked whether we actually do, but it
would be a bug to need it in a scsi LLDD)

+#include <linux/pci_ids.h>

You get this one from pci.h

+#include <linux/ctype.h>

Do you really need this one.

+#include <linux/devfs_fs.h>
+#include <linux/devfs_fs_kernel.h>

You shouldn't need this in a scsi LLDD.

+#include <linux/smp.h>

What do you need this for?

+#include <linux/smp_lock.h>

no needed.

+#include <linux/errno.h>

You already included this above..

+#include <asm/processor.h>

Why do you need this one?

+#include <asm/page.h>

And this?

+#ifdef CONFIG_COMPAT
+#include <linux/ioctl32.h>
+#endif

Shouldn't hurt to include this unconditionally.

+/*
+ *  Function Prototypes
+ */
+int ipr_biosparam(struct scsi_device *, struct block_device *, sector_t, int *);
+const char * ipr_ioa_info(struct Scsi_Host *);
+int ipr_release(struct Scsi_Host *);
+int ipr_eh_abort(struct scsi_cmnd *);
+int ipr_eh_dev_reset(struct scsi_cmnd *);
+int ipr_eh_host_reset(struct scsi_cmnd *);
+int ipr_slave_alloc(struct scsi_device *);
+int ipr_slave_configure(struct scsi_device *);
+void ipr_slave_destroy(struct scsi_device *);
+int ipr_queue(struct scsi_cmnd *, void (*done) (struct scsi_cmnd *));
+int ipr_task_thread(void *);
+irqreturn_t ipr_isr(int, void *, struct pt_regs *);

A single source-file driver shouldn't ever have non-static entry points.


+static int __devinit ipr_probe_ioa_part2(struct ipr_ioa_cfg *);
+static void ipr_initiate_ioa_reset(struct ipr_ioa_cfg *,
+				   enum ipr_shutdown_type);

...

You have lots of forward-declarations.  This is usually a sign of a bad
source file structure as code reads much easier if functions called by another
function are above them in the source.  Also there's some other strangeness
in the code, e.g. modern drivers usually have the module_init/exit routines
at the very end, before that the pci driver methods and objects, then the
scsi host template and before it it's methods.

+/**
+ * ipr_version_show - Show the driver version
+ * @dd:	device driver struct
+ * @buf:	buffer
+ * 
+ * Return value:
+ * 	number of bytes printed to buffer
+ **/
+static ssize_t ipr_version_show(struct device_driver *dd, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", IPR_DRIVER_VERSION);
+}
+
+static DRIVER_ATTR(version, S_IRUGO, ipr_version_show, NULL);

Please don't do this in sysfs.  We're still hoping for a MODULE_VERSION
macro, but every driver crafting it's own version telling mechanism
doesn't scale.

+MODULE_AUTHOR("Brian King <brking@us.ibm.com>");
+module_param_named(disable_tcq, ipr_disable_tcq, int, 0);
+MODULE_PARM_DESC(disable_tcq, "Set to 1 to disable tagged command queuing");
+module_param_named(safe, ipr_safe_settings, int, 0);
+MODULE_PARM_DESC(safe, "Use safe settings (slow)");
+module_param_named(verbose, ipr_verbose, int, 0);
+MODULE_PARM_DESC(verbose, "Set to 0 - 4 for increasing verbosity of device driver");
+module_param_named(unsafe, ipr_unsafe, int, 0);
+MODULE_PARM_DESC(unsafe, "Do not use!");
+MODULE_LICENSE("GPL");

What about a MODULE_DESCRIPTION?

+static struct file_operations ipr_fops = {
+	.ioctl = ipr_ioctl,
+	.open = ipr_open,
+	.release = ipr_close,
+};

Please don't add new 'management' character devices to scsi LLDDs anymore.

+unsigned int ipr_ioctls[] =
+{
+	IPR_IOCTL_PASSTHRU,
+	IPR_IOCTL_RUN_DIAGNOSTICS,
+	IPR_IOCTL_DUMP_IOA,
+	IPR_IOCTL_RESET_IOA,
+	IPR_IOCTL_READ_DRIVER_CFG,
+	IPR_IOCTL_WRITE_DRIVER_CFG,
+	IPR_IOCTL_GET_BUS_CAPABILTIES,
+	IPR_IOCTL_SET_BUS_ATTRIBUTES,
+	IPR_IOCTL_GET_TRACE,
+	IPR_IOCTL_RECLAIM_CACHE,
+	IPR_IOCTL_QUERY_CONFIGURATION,
+	IPR_IOCTL_UCODE_DOWNLOAD,
+	IPR_IOCTL_CHANGE_ADAPTER_ASSIGNMENT
+};

Please provide a brief explanation of every ioctl and why you need it as
ioctl.  At least the GET_BUS_CAPABILTIES / SET_BUS_ATTRIBUTES seem to be
better expressed in the transport sysfs API discussed on linux-scsi.

+/**
+ * ipr_sleep_no_lock - Sleep for the specified amount of time
+ * @delay:		time to sleep
+ *
+ * Sleep for the specified amount of time
+ * 
+ * Return value:
+ * 	none
+ **/
+static void ipr_sleep_no_lock(signed long delay)
+{
+	DECLARE_WAIT_QUEUE_HEAD(internal_wait);
+
+	sleep_on_timeout(&internal_wait, (delay * HZ) / 1000);
+	return;
+}

Okay, these sleep_on thingies seem to be fixed up with your additional
patch, I don't need to comment on them thankfully.

+/**
+ * ipr_get_mode_page - Locate specified mode page
+ * @mode_pages:	mode page buffer
+ * @page_code:	page code to find
+ * @len:		minimum required length for mode page
+ *
+ * Return value:
+ * 	pointer to mode page / NULL on failure
+ **/
+static void *ipr_get_mode_page(struct ipr_mode_pages *mode_pages,
+			       u32 page_code, u32 len)

Okay, this isn't good at all.  A LLDD driver shouldn't care about mode
pages and all the stuff you do with it.  Please do it from userspace using
the sg driver.

+	spin_lock_init(&ipr_driver_lock);
+	INIT_LIST_HEAD(&ipr_ioa_head);

These could be initialized at compile-time (but shouldn't be needed at all
without the character devices)

+	ipr_regs = (unsigned long)ioremap(ipr_regs_pci,
+					  pci_resource_len(pdev, 0));

You need to check the return value.

+/**
+ * ipr_scan_vsets - Scans for VSET devices
+ * @ioa_cfg:	ioa config struct
+ *
+ * Description: Since the VSET resources do not follow SAM in that we can have
+ * sparse LUNs with no LUN 0, we have to scan for these ourselves.
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_scan_vsets(struct ipr_ioa_cfg *ioa_cfg)
+{
+	int target, lun;
+
+	for (target = 0; target < IPR_MAX_NUM_TARGETS_PER_BUS; target++)
+		for (lun = 0; lun < IPR_MAX_NUM_VSET_LUNS_PER_TARGET; lun++ )
+			scsi_add_device(ioa_cfg->host, IPR_VSET_BUS, target, lun);
+}

Can you explain what these vsets are supposed to do?  And why a scsi_scan quirk can't
be done instead of doing this in a LLDD?

+/**
+ * ipr_inquiry - Send an Inquiry to the adapter.
+ * @ipr_cmd:	ipr command struct
+ *
+ * This utility function sends an inquiry to the adapter.
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_inquiry(struct ipr_cmnd *ipr_cmd, u8 flags, u8 page,
+			u32 dma_addr, u8 xfer_len)

Doing inquiries from a LLDD looks very, very wrong.  Explanations please.

+/**
+ * ipr_find_ses_entry - Find matching SES in SES table
+ * @res:	resource entry struct of SES
+ * 
+ * Return value:
+ * 	pointer to SES table entry / NULL on failure
+ **/

This is an extreme layering violation.  Any SES handling belongs into an
upper level scsi driver (or userspace via sg)

+/**
+ * ipr_do_req -  Send driver initiated requests.
+ * @ipr_cmd:		ipr command struct
+ * @done:			done function
+ * @timeout_func:	timeout function
+ * @timeout:		timeout value
+ *
+ * This function sends the specified command to the adapter with the
+ * timeout given. The done function is invoked on command completion.

This looks very wrong.  And fortunately it seems to be only called from
code that is totally misplaced in a LLDD anyway.  All scsi commands
should go through the midlayer queueing.

+/**
+ * ipr_vset_stop_unit - Send a STOP UNIT to a VSET resource
+ * @ioa_cfg:	ioa config struct
+ * @res:		resource entry struct
+ *
+ * This function sends a STOP UNIT to a VSET resource to
+ * flush the write cache..
+ *
+ * Return value:
+ * 	IOASC of the command
+ **/

Again, a LLDD is the very wrong place for something like that.
Is there a spec for that VSET stuff somewhere?

+/**
+ * ipr_send_cmd - Build and send a mid-layer command
+ * @ioa_cfg:	ioa config struct
+ * @scsi_cmd:	scsi command struct
+ * @res:		ipr resource entry
+ *
+ * Return value:
+ * 	0 on success / SCSI_MLQUEUE_HOST_BUSY if DMA mapping fails
+ **/
+static int ipr_send_cmd(struct ipr_ioa_cfg *ioa_cfg,
+			struct scsi_cmnd *scsi_cmd,
+			struct ipr_resource_entry *res)
+{
+	struct ipr_cmnd *ipr_cmd;
+	int rc = 0;
+	void (*timeout_func) (struct scsi_cmnd *);
+	int timeout;
+	struct ipr_ioarcb *ioarcb;
+
+	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
+	ioarcb = &ipr_cmd->ioarcb;
+
+	list_add_tail(&ipr_cmd->queue, &ioa_cfg->pending_q);

Can you explain the per-command list mess please?  In theory a properly
written driver shouldn't need lists like that, just start a command in
->queuecommand if possible, else return an error and immediately call
->done when you're done with a scsi command.

+	/*
+	 * Double the timeout value to use as we will use the adapter
+	 * as the primary timing mechanism
+	 */
+	timeout_func = (void (*)(struct scsi_cmnd *)) scsi_cmd->eh_timeout.function;
+	timeout = scsi_cmd->timeout_per_command;
+
+	scsi_add_timer(scsi_cmd, timeout * IPR_TIMEOUT_MULTIPLIER, timeout_func);

Okay, another driver that would like hooks into the EH timer.  We should probably
better fix this correctly by adding a host method for it.

+ **/
+int ipr_queue(struct scsi_cmnd *scsi_cmd, void (*done) (struct scsi_cmnd *))

ipr_queuecommand would be a better name.

+
+	/* xxx can I remove some of these checks? */
+	if (unlikely(ioa_cfg->ioa_is_dead || !res || res->del_from_ml)) {
+		memset(scsi_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+		scsi_cmd->result = (DID_NO_CONNECT << 16);
+		scsi_cmd->scsi_done(scsi_cmd);
+		return 0;
+	}

this should be handled by the midlayer per-device and per-host state bits.

+	rc = ipr_send_cmd(ioa_cfg, scsi_cmd, res);

merge this into the quecommand routine?

+int ipr_biosparam(struct scsi_device *scsi_device,
+		  struct block_device *block_device,
+		  sector_t capacity, int *parm)
+{
+	int heads, sectors, cylinders;
+
+	heads = 128;
+	sectors = 32;
+
+	cylinders = (capacity / (128 * 32));

You need to use sector_div here to avoid blowing up on 32bit systems.


