From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SMP pass through interface via bsg
Date: Mon, 02 Apr 2007 21:43:25 +0900
Message-ID: <20070402214325Y.fujita.tomonori@lab.ntt.co.jp>
References: <20070402110125U.fujita.tomonori@lab.ntt.co.jp>
	<1175486263.27675.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:37037 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934021AbXDBMoT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 08:44:19 -0400
In-Reply-To: <1175486263.27675.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, hch@infradead.org, dougg@torque.net, James.Smart@Emulex.Com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SMP pass through interface via bsg
Date: Sun, 01 Apr 2007 22:57:42 -0500

> On Mon, 2007-04-02 at 11:49 +0900, FUJITA Tomonori wrote:
> > I started to work on SMP pass through via bsg as a non-SCSI command
> > experimentation. I asked Doug to try the patch but it seems to take
> > some time to make Doug's hardware work with the mainline aic94xxx
> > driver.
> 
> If you post the code, others who also have the hardware can try it
> too ...

I've attached a patch against Jens' bsg tree and uploaed a patch
against the sgv4-tools tree:

http://zaal.org/bsg/smp-test.diff

The sgv4-tools tree is at:

http://git.kernel.org/?p=linux/kernel/git/tomo/sgv4-tools.git;a=summary


If everything works:

gazania:/sys/class/bsg# ls
end_device-0:0  end_device-0:1  expander-0:0  sas_host0  sda  sdb

gazania:/home/fujita/sgv4-tools# ./smp_test /sys/class/bsg/expander-0\:0


smp_test works like Doug's smp_rep_manufacturer.

Note that `smp_test /sys/class/bsg/expander-0\:0/` doesn't work.

I've not tested these patches at all since I don't have proper
hardware. So please don't be surprised if the kernel crashes.


> > How should a user-space tool (like Doug's smp_utils) send a request
> > and get the response via bsg?
> 
> Basic frame in/frame out ... this is why we need the block layer
> bidirectional support

Yeah. Currently, I use a dirty hack to use sense buffer for bidi.


> > -- each SAS object (host, device, expander, etc) has the own bsg
> > device
> 
> I think so; probably attached via the transport class.

I see. I changed my patch to use this approach.


> > A user-space tool opens a bsg device for a sas object that it wants to
> > send a request to.
> > 
> > -- one bsg device handles multiple SAS objects
> > 
> > Some options: one bsg device in the whole system; one bsg device per
> > SAS driver; one bsg device per SAS host; etc.
> > 
> > With this approach, we need to invent a header incluing routing
> > information.
> > 
> > My hacky patch creates one bsg device per SAS host and invents:
> > 
> > struct smp_passthrough_hdr {
> >         __u64 sas_address;
> >         __u8 phy_identifier;
> > };
> 
> I'd really rather not go this route unless the one device per object
> approach becomes untenable.

OK. Probably, Dougs has some comments on this. I chose this because
Dougs prefers it and at the workshop Christoph seemed to be neutral in
two approaches.

Anyway, as I said, the attached patch uses "one bsg device per one SAS
object" approach.


> > a user-space tool sends this header instead of scb via bsg and put a
> > SMP request at dout_xfer and a buffer response at din_xfer (note that
> > now I do bidi transfer in a hacky way).
> > 
> > 
> > - SAS implementation details
> > 
> > As I said, the patch is too hacky. I just tried to implement a
> > smp_portal alternative by using bsg.
> > 
> > The patch adds a hook into sas transport class. sas_host_setup calls
> > bsg_register_queue. Then, the request_fn calls smp_execute_task to
> > send a smp request and get the response. It doesn't look good to link
> > the sas transport class with libsas. In addition, the mpt driver
> > handles smp request/response in a very different way.
> > 
> > Any suggestion to bind SMP pass through via bsg to aic94xx and mpt
> > cleanly?
> 
> bind in the transport class, not the driver ...

Yeah. The problem is that requests go to libsas for aic94xx while requests
directly go to the mpt driver.

I added a hook for SMP to struct sas_function_template.

diff --git a/block/bsg.c b/block/bsg.c
index a333c93..6c7802f 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -230,8 +230,8 @@ static int blk_fill_sgv4_hdr_rq(request_
 	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
 			   hdr->request_len))
 		return -EFAULT;
-	if (blk_verify_command(rq->cmd, has_write_perm))
-		return -EPERM;
+/* 	if (blk_verify_command(rq->cmd, has_write_perm)) */
+/* 		return -EPERM; */
 
 	/*
 	 * fill in request structure
@@ -263,7 +263,7 @@ bsg_validate_sgv4_hdr(request_queue_t *q
 		return -EIO;
 
 	/* not supported currently */
-	if (hdr->protocol || hdr->subprotocol)
+	if (hdr->protocol)
 		return -EINVAL;
 
 	/*
@@ -273,7 +273,7 @@ bsg_validate_sgv4_hdr(request_queue_t *q
 		return 0;
 
 	/* not supported currently */
-	if (hdr->dout_xfer_len && hdr->din_xfer_len)
+	if (!hdr->subprotocol && hdr->dout_xfer_len && hdr->din_xfer_len)
 		return -EINVAL;
 
 	*rw = hdr->dout_xfer_len ? WRITE : READ;
@@ -312,6 +312,12 @@ bsg_map_hdr(struct bsg_device *bd, struc
 		return ERR_PTR(ret);
 	}
 
+	if (hdr->subprotocol) {
+		rq->sense_len = hdr->dout_xfer_len;
+		rq->sense = (void*)(unsigned long)hdr->dout_xferp;
+		hdr->dout_xfer_len = 0;
+	}
+
 	if (hdr->dout_xfer_len) {
 		dxfer_len = hdr->dout_xfer_len;
 		dxferp = (void*)(unsigned long)hdr->dout_xferp;
@@ -361,8 +367,10 @@ static void bsg_rq_end_io(struct request
 static void bsg_add_command(struct bsg_device *bd, request_queue_t *q,
 			    struct bsg_command *bc, struct request *rq)
 {
-	rq->sense = bc->sense;
-	rq->sense_len = 0;
+	if (!bc->hdr.subprotocol) {
+		rq->sense = bc->sense;
+		rq->sense_len = 0;
+	}
 
 	/*
 	 * add bc command to busy queue and submit rq for io
@@ -449,7 +457,7 @@ static int blk_complete_sgv4_hdr_rq(stru
 	hdr->din_resid = rq->data_len;
 	hdr->response_len = 0;
 
-	if (rq->sense_len && hdr->response) {
+	if (!hdr->subprotocol && rq->sense_len && hdr->response) {
 		int len = min((unsigned int) hdr->max_response_len,
 			      rq->sense_len);
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 404c014..2fa4863 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -51,6 +51,8 @@ #include <linux/errno.h>
 #include <linux/jiffies.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>	/* for mdelay */
+#include <linux/blkdev.h>
+#include <linux/bio.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1324,11 +1326,24 @@ mptsas_get_bay_identifier(struct sas_rph
 	return rc;
 }
 
+static int mptsas_smp_request(struct Scsi_Host *host, struct sas_rphy *rphy,
+			      struct request *req)
+{
+	{
+		char *buf = bio_data(req->bio);
+		printk("%s %d: %x %x %x %x\n", __FUNCTION__, __LINE__,
+		       buf[0], buf[1], buf[2], buf[3]);
+	}
+
+	return 0;
+}
+
 static struct sas_function_template mptsas_transport_functions = {
 	.get_linkerrors		= mptsas_get_linkerrors,
 	.get_enclosure_identifier = mptsas_get_enclosure_identifier,
 	.get_bay_identifier	= mptsas_get_bay_identifier,
 	.phy_reset		= mptsas_phy_reset,
+	.smp_request		= mptsas_smp_request,
 };
 
 static struct scsi_transport_template *mptsas_transport_template;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index dc70c18..a082fe2 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -24,6 +24,7 @@
 
 #include <linux/pci.h>
 #include <linux/scatterlist.h>
+#include <linux/blkdev.h>
 
 #include "sas_internal.h"
 
@@ -1915,3 +1916,47 @@ out:
 	return res;
 }
 #endif
+
+int sas_smp_request(struct Scsi_Host *shost, struct sas_rphy *rphy,
+		    struct request *req)
+{
+	struct domain_device *dev;
+	char *rsp;
+	int error, type = rphy->identify.device_type;
+
+	/* seems aic94xx doesn't support */
+	if (!rphy) {
+		printk("can we send a smp request to a host?\n");
+		return -EINVAL;
+	}
+
+	if (type != SAS_EDGE_EXPANDER_DEVICE &&
+	    type != SAS_FANOUT_EXPANDER_DEVICE) {
+		printk("can we send a smp request to a device?\n");
+		return -EINVAL;
+	}
+
+	dev = sas_find_dev_by_rphy(rphy);
+	if (!dev) {
+		printk("fail to find a domain_device?\n");
+		return -EINVAL;
+	}
+
+	rsp = kzalloc(req->sense_len, GFP_KERNEL);
+	if (!rsp) {
+		printk("fail to alloc smp response buffer\n");
+		return -ENOMEM;
+	}
+
+	/* TODO: multiple pages */
+	error = smp_execute_task(dev, bio_data(req->bio),
+				 req->data_len,
+				 rsp, req->sense_len);
+
+	if (copy_to_user(req->sense, rsp, req->sense_len))
+		printk("%s %d: fault\n", __FUNCTION__, __LINE__);
+
+	kfree(rsp);
+
+	return error;
+}
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 965698c..a15b2f6 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -259,6 +259,7 @@ static struct sas_function_template sft
 	.phy_reset = sas_phy_reset,
 	.set_phy_speed = sas_set_phy_speed,
 	.get_linkerrors = sas_get_linkerrors,
+	.smp_request = sas_smp_request,
 };
 
 struct scsi_transport_template *
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index b2ef71a..bc17025 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -29,6 +29,8 @@ #include <linux/jiffies.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/blkdev.h>
+#include <linux/bsg.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -152,6 +154,77 @@ static struct {
 sas_bitfield_name_search(linkspeed, sas_linkspeed_names)
 sas_bitfield_name_set(linkspeed, sas_linkspeed_names)
 
+static void sas_smp_fn(struct request_queue *q, struct Scsi_Host *shost,
+		       struct sas_rphy *rphy)
+{
+	struct request *req;
+	int error;
+
+	while (!blk_queue_plugged(q)) {
+		req = elv_next_request(q);
+		if (!req)
+			break;
+
+		blkdev_dequeue_request(req);
+
+		spin_unlock(q->queue_lock);
+
+		printk("%s %d: %u %p %u\n", __FUNCTION__, __LINE__,
+		       req->data_len, req->sense, req->sense_len);
+
+		error = to_sas_internal(shost->transportt)->f->smp_request(shost, rphy, req);
+
+		spin_lock_irq(q->queue_lock);
+		req->end_io(req, error);
+	}
+}
+
+static void sas_host_smp_fn(struct request_queue *q)
+{
+	printk("%s %d\n", __FUNCTION__, __LINE__);
+
+	sas_smp_fn(q, (struct Scsi_Host *)q->queuedata, NULL);
+}
+
+static void sas_non_host_smp_fn(struct request_queue *q)
+{
+	struct sas_rphy *rphy = q->queuedata;
+
+	printk("%s %d\n", __FUNCTION__, __LINE__);
+
+	sas_smp_fn(q, rphy_to_shost(rphy), rphy);
+}
+
+static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy,
+			      char *name)
+{
+	struct request_queue *q;
+	int error;
+
+	if (!to_sas_internal(shost->transportt)->f->smp_request)
+		return 0;
+
+	if (rphy)
+		q = blk_init_queue(sas_non_host_smp_fn, NULL);
+	else
+		q = blk_init_queue(sas_host_smp_fn, NULL);
+	if (!q)
+		return -ENOMEM;
+
+	error = bsg_register_queue(q, name);
+	if (error) {
+		blk_cleanup_queue(q);
+		return -ENOMEM;
+	}
+
+	if (rphy)
+		q->queuedata = rphy;
+	else
+		q->queuedata = shost;
+
+	return 0;
+}
+
 /*
  * SAS host attributes
  */
@@ -161,12 +234,19 @@ static int sas_host_setup(struct transpo
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+	char name[BUS_ID_SIZE];
 
 	INIT_LIST_HEAD(&sas_host->rphy_list);
 	mutex_init(&sas_host->lock);
 	sas_host->next_target_id = 0;
 	sas_host->next_expander_id = 0;
 	sas_host->next_port_id = 0;
+
+	snprintf(name, sizeof(name), "sas_host%d", shost->host_no);
+	if (sas_bsg_initialize(shost, NULL, name))
+		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
+			   shost->host_no);
+
 	return 0;
 }
 
@@ -1221,6 +1301,9 @@ struct sas_rphy *sas_end_device_alloc(st
 	sas_rphy_initialize(&rdev->rphy);
 	transport_setup_device(&rdev->rphy.dev);
 
+	if (sas_bsg_initialize(shost, &rdev->rphy, rdev->rphy.dev.bus_id))
+		printk("fail to a bsg device %s\n", rdev->rphy.dev.bus_id);
+
 	return &rdev->rphy;
 }
 EXPORT_SYMBOL(sas_end_device_alloc);
@@ -1260,6 +1343,9 @@ struct sas_rphy *sas_expander_alloc(stru
 	sas_rphy_initialize(&rdev->rphy);
 	transport_setup_device(&rdev->rphy.dev);
 
+	if (sas_bsg_initialize(shost, &rdev->rphy, rdev->rphy.dev.bus_id))
+		printk("fail to a bsg device %s\n", rdev->rphy.dev.bus_id);
+
 	return &rdev->rphy;
 }
 EXPORT_SYMBOL(sas_expander_alloc);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ad0182e..83af586 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -662,4 +662,6 @@ int __sas_task_abort(struct sas_task *);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
 int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd);
 
+extern int sas_smp_request(struct Scsi_Host *shost, struct sas_rphy *rphy,
+			   struct request *req);
 #endif /* _SASLIB_H_ */
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 9aedc19..29631c7 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -7,7 +7,7 @@ #include <linux/mutex.h>
 
 struct scsi_transport_template;
 struct sas_rphy;
-
+struct request;
 
 enum sas_device_type {
 	SAS_PHY_UNUSED,
@@ -166,6 +166,7 @@ struct sas_function_template {
 	int (*phy_reset)(struct sas_phy *, int);
 	int (*phy_enable)(struct sas_phy *, int);
 	int (*set_phy_speed)(struct sas_phy *, struct sas_phy_linkrates *);
+	int (*smp_request)(struct Scsi_Host *, struct sas_rphy *, struct request *);
 };
 
 
