From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ibmvscsi driver - next version
Date: Mon, 23 Feb 2004 14:45:42 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040223144542.A9624@infradead.org>
References: <opr3s2iefyl6e53g@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:6670 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261898AbUBWOpq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 09:45:46 -0500
Content-Disposition: inline
In-Reply-To: <opr3s2iefyl6e53g@us.ibm.com>; from sleddog@us.ibm.com on Sun, Feb 22, 2004 at 10:24:04PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Dave Boutcher <sleddog@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 22, 2004 at 10:24:04PM -0600, Dave Boutcher wrote:
> This is the next version of the SCSI driver to support the adapter 
> implemented by the IBM Power5 firmware.  I have incorporated all comments 
>  from the first submission, which has resulted in a much cleaner, leaner, 
> meaner version.

Okay, this looks much better.  A few more comments:

+#include <linux/module.h>
+#include <scsi/scsi_device.h>
+#include "ibmvscsi.h"

	any reason you hid all headers in ibmvscsi.h?  normally we include
	them in the source files directly.

+MODULE_PARM(max_id, "i");
+MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
+MODULE_PARM(max_channel, "i");
+MODULE_PARM_DESC(max_channel, "Largest channel value");

	please use module_param{_named,} to make the options also
	available at the boot-time command line

+static int initialize_event_pool(struct event_pool *pool, int size, struct ibmvscsi_host_data *hostdata)

	please wraper after 80chars according to Documentation/CodingStyle

+	if(!pool->events)

	another nitpick, above document says this should be

	if (!pool->events)

	dito in a few other places

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

	Is there a specific reason host_busy / can_queue can don't the
	request limit checking for you?

+	} else {

	Why the else if we just returned?

+		/* Add this to the sent list.  We need to do this before we actually send 
+		 * in case it comes back REALLY fast
+		 */
+		spin_lock_irqsave(&hostdata->lock, flags);
+		list_add_tail(&evt_struct->list, &hostdata->sent);
+		spin_unlock_irqrestore(&hostdata->lock, flags);

	Do you really need the hostdata lock in addition to the scsi
	host_lock?

		
+			cmnd->result = DID_ERROR << 16;
+			evt_struct->cmnd_done(cmnd);
+			return SCSI_MLQUEUE_HOST_BUSY;

	This is wrong - either you set an error in cmnd->result and
	return 0 or your return non-zero from queuecommand, but not both.

+	/* Check if we are in a dead state before we go any farther */
+	if (atomic_read(&hostdata->request_limit) < 0) {
+		printk("ibmvscsi: rejecting SCSI command on failed adapter\n");
+		return FAILED;
+	}

	What about just setting can_queue to 0 when the adapter fails?
	Also the return value is wrong, valid return values are 0 or
	SCSI_MLQUEUE_{DEVICE,HOST}_BUSY.


+/* ------------------------------------------------------------
+ * Routines for driver initialization
+ */
+static void error_cleanup(struct ibmvscsi_host_data *hostdata) {
+	struct Scsi_Host *host = hostdata->host;
+	release_event_pool(&hostdata->pool, hostdata);
+	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata);
+	memset(hostdata, 0xff, sizeof(*hostdata));

	You can't poison the hostdata as it's only freed on ->release
	which might be much later, e.g. if a sysfs file is opened.

+	scsi_host_put(host);
+}

	This routine needs rreformating, btw - and as you use it only
	from login_rsp it might better be placed in there after an error
	goto.

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

	This can't ever happen.  You will only get called for commands
	that you have accepted in queuecommand and not called the completion
	routine for.

+static void purge_requests(struct ibmvscsi_host_data *hostdata) {
+	struct srp_event_struct *tmp_evt;
+	struct list_head	*pos, *next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hostdata->lock, flags);
+	if(!list_empty(&hostdata->sent)) {
+		list_for_each_safe(pos, next, &hostdata->sent) {
+			tmp_evt = list_entry(pos, struct srp_event_struct, list);

	The list_for_each* macros are safe against empty lists.
	What about using list_for_each_entry_safe, btw?

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

	list_del on empty lists is okay..

+int ibmvscsi_remove(struct ibmvscsi_host_data *hostdata)
+{
+	/* send an SRP_I_LOGOUT */
+	printk(KERN_INFO "ibmvscsi: remove called\n");

	this looks overly verbose, I don't remember any other LLDD do this.

	-> here you need a scsi_remove_host <-

+	
+	release_event_pool(&hostdata->pool, hostdata);
+	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata);
+
+	scsi_host_put(hostdata->host);
+	return 0;

	I think it should just return void

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

	useless layering - just put the module_init/exit into the
	iseris/rpa subdrivers.

+/* global variables */
+extern struct device *iSeries_vio_dev;
+static struct ibmvscsi_host_data *single_host_data = NULL; 

	You don't need  to inialize static variables to zero.

+/* ------------------------------------------------------------
+ * Routines for managing the command/response queue
+ */

	Stale comment?

+/**
+ * This stub is needed by ibmvscsi
+ */
+void ibmvscsi_task(unsigned long data) 
+{
+}

	I think you should just set up the task in the rpa subdriver
	when it's not needed by the iseries one.

+#include <asm/vio.h>
+#include <asm/pci_dma.h>
+#include <asm/hvcall.h>
+#include "ibmvscsi.h"
+#include <linux/interrupt.h> 

	linux/*.h before asm/*.h before your own headers, please.

+/**
+ * ibmvscsi_task: - Process srps asynchronously
+ * @data:	ibmvscsi_host_data of host
+ */
+void ibmvscsi_task(unsigned long data) 

	Isn't this a workqueue handler?  Last time I checked they took
	void * and not unsigned long

+	struct ibmvscsi_host_data *hostdata = ibmvscsi_probe(&vdev->dev);
+	if (hostdata) {
+		vdev->driver_data = hostdata;

	Please alwasy use dev_set_drvdata/dev_get_drvdata.

+char rpa_driver_name[] = "ibmvscsi";                                                                            
+static struct vio_driver ibmvscsi_driver = {
+	.name		= rpa_driver_name,

	Why not put the name directly in here?

