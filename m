From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] Re: [PATCH 0/3] scsi_dh: Add ability to set
	parameters for scsi device handler
Date: Thu, 09 Jul 2009 18:59:05 -0700
Message-ID: <1247191145.28322.10.camel@chandra-ubuntu>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
	 <1246563299.8018.9.camel@eddie-laptop>
	 <1246566564.8018.21.camel@eddie-laptop>
	 <1246567622.7381.7.camel@chandra-ubuntu>
	 <1246970082.6646.9.camel@eddie-laptop>
	 <1247169346.28322.0.camel@chandra-ubuntu>
	 <1247174184.6367.237.camel@eddie-laptop>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-co0K2GVJDoK4BhJxmnya"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:42344 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZGJB4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2009 21:56:18 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n6A1s5w1011333
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jul 2009 19:54:05 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6A1uI6x188086
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jul 2009 19:56:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6A1uHZd011188
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jul 2009 19:56:17 -0600
In-Reply-To: <1247174184.6367.237.camel@eddie-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, agk@redhat.com


--=-co0K2GVJDoK4BhJxmnya
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Eddie,

Here is the set of patches ported to sles11.

It applies cleanly on linux-2.6.27.23-0.1

Anyways, you have to test the mainline version for it to be pushed
upstream. (this patch is just for verification purposes).

series:
sles11_scsi_dh_params
sles11_emc_parameters
sles11_parameters_fix_for_dmmpath

chandra
On Thu, 2009-07-09 at 17:16 -0400, Eddie Williams wrote:
> I have not tried to patch the 2.6.27-23 kernel.  Given that the patches
> were against 31-RC1 I assumed that there would be other changes I would
> need to pull in.  I have been looking at why the 31-RC1 was panicing as
> well as working with my EMC contacts to see if they already had a
> working 31-RC1 environment they could verify the patch in.
> Unfortunately I have been mostly in meetings...
> 
> I will give it a try.  I should have results in the morning.
> 
> Eddie
> 
> On Thu, 2009-07-09 at 12:55 -0700, Chandra Seetharaman wrote:
> > Did you try to port/apply my patches to the SLES11 tree and see if it
> > works ?
> > 
> > On Tue, 2009-07-07 at 08:34 -0400, Eddie Williams wrote:
> > > I was testing with the SLES 11 kernel.  Initially I was using
> > > 2.6.27.19-5 and also verified the same issue with their errata kernel
> > > 2.6.27.23-0.1.
> > > 
> > > Eddie
> > > On Thu, 2009-07-02 at 13:47 -0700, Chandra Seetharaman wrote:
> > > > On Thu, 2009-07-02 at 16:29 -0400, Eddie Williams wrote:
> > > > > On Thu, 2009-07-02 at 15:34 -0400, Eddie Williams wrote:
> > > > > > I have tried to set this up but have run into a problem probably due to
> > > > > > my error.  It has been a while since I have had to build kernels...
> > > > > > 
> > > > > > I pulled 2.6.31-rc1, applied the two patches below and then applied the
> > > > > > 3 patches for the interface.  The new kernel loads fine but when a
> > > > > > trespass command is sent I get an panic.  I am looking though how I
> > > > > > built the kernel and perhaps build with your 3 patches to see if it
> > > > > > happened before.  
> > > > > 
> > > > > I backed out the 3 patches with the same panic.
> > > > > 
> > > > Which version of the kernel were you originally testing with ? (when you
> > > > found the feature was gone).
> > > > 
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--=-co0K2GVJDoK4BhJxmnya
Content-Disposition: attachment; filename=sles11_emc_parameters
Content-Type: text/plain; name=sles11_emc_parameters; charset=UTF-8
Content-Transfer-Encoding: 7bit

Handle the parameters provided by user thru multipath.

This handler expects only 2 parameters and their value can either be 0 or 1.

This code originates from the old dm-emc.c file. Appropriate changes have
been made to make it work in the new design.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |   56 ++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

Index: linux/drivers/scsi/device_handler/scsi_dh_emc.c
===================================================================
--- linux.orig/drivers/scsi/device_handler/scsi_dh_emc.c
+++ linux/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -563,6 +563,61 @@ done:
 
 	return result;
 }
+/*
+ * params - parameters in the following format
+ *      "no_of_params\0param1\0param2\0param3\0...\0"
+ *      for example, string for 2 parameters with value 10 and 21
+ *      is specified as "2\010\021\0".
+ */
+static int clariion_set_params(struct scsi_device *sdev, const char *params)
+{
+	struct clariion_dh_data *csdev = get_clariion_data(sdev);
+	unsigned int hr = 0, st = 0, argc;
+	char *p = params;
+	int result = SCSI_DH_OK;
+
+	if ((sscanf(params, "%u", &argc) != 1) || (argc != 2))
+		return -EINVAL;
+
+	while (*p++)
+		;
+	if ((sscanf(p, "%u", &st) != 1) || (st > 1))
+		return -EINVAL;
+
+	while (*p++)
+		;
+	if ((sscanf(p, "%u", &hr) != 1) || (hr > 1))
+		return -EINVAL;
+
+	if (st)
+		csdev->flags |= CLARIION_SHORT_TRESPASS;
+	else
+		csdev->flags &= ~CLARIION_SHORT_TRESPASS;
+
+	if (hr)
+		csdev->flags |= CLARIION_HONOR_RESERVATIONS;
+	else
+		csdev->flags &= ~CLARIION_HONOR_RESERVATIONS;
+
+	/*
+	 * If this path is owned, we have to send a trespass command
+	 * with the new parameters. If not, simply return. Next trespass
+	 * command would use the parameters.
+	 */
+	if (csdev->lun_state != CLARIION_LUN_OWNED)
+		goto done;
+
+	csdev->lun_state = CLARIION_LUN_UNINITIALIZED;
+	result = send_trespass_cmd(sdev, csdev);
+	if (result != SCSI_DH_OK)
+		goto done;
+
+	/* Update status */
+	result = clariion_send_inquiry(sdev, csdev);
+
+done:
+	return result;
+}
 
 static const struct scsi_dh_devlist clariion_dev_list[] = {
 	{"DGC", "RAID", 0},
@@ -583,6 +638,7 @@ static struct scsi_device_handler clarii
 	.check_sense	= clariion_check_sense,
 	.activate	= clariion_activate,
 	.prep_fn	= clariion_prep_fn,
+	.set_params	= clariion_set_params,
 };
 
 /*

--=-co0K2GVJDoK4BhJxmnya
Content-Disposition: attachment; filename=sles11_parameters_fix_for_dmmpath
Content-Type: text/plain; name=sles11_parameters_fix_for_dmmpath; charset=UTF-8
Content-Transfer-Encoding: 7bit

Use scsi_dh_set_params() set parameters provided. Save the parameters in
parse_hw_handler() and use it in parse_path().

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/md/dm-mpath.c |   40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

Index: linux/drivers/md/dm-mpath.c
===================================================================
--- linux.orig/drivers/md/dm-mpath.c
+++ linux/drivers/md/dm-mpath.c
@@ -63,6 +63,7 @@ struct multipath {
 	spinlock_t lock;
 
 	const char *hw_handler_name;
+	char *hw_handler_params;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
@@ -216,6 +217,7 @@ static void free_multipath(struct multip
 	}
 
 	kfree(m->hw_handler_name);
+	kfree(m->hw_handler_params);
 	mempool_destroy(m->mpio_pool);
 	kfree(m);
 }
@@ -645,6 +647,17 @@ static struct pgpath *parse_path(struct
 				goto bad;
 			}
 		}
+
+		if (m->hw_handler_params) {
+			r = scsi_dh_set_params(q, m->hw_handler_params);
+			if (r < 0) {
+				ti->error = "unable to set hardware "
+							"handler parameters";
+				scsi_dh_detach(q);
+				dm_put_device(ti, p->path.dev);
+				goto bad;
+			}
+		}
 	}
 
 	r = ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->error);
@@ -738,6 +751,7 @@ static struct priority_group *parse_prio
 static int parse_hw_handler(struct arg_set *as, struct multipath *m)
 {
 	unsigned hw_argc;
+	int ret;
 	struct dm_target *ti = m->ti;
 
 	static struct param _params[] = {
@@ -754,13 +768,33 @@ static int parse_hw_handler(struct arg_s
 	request_module("scsi_dh_%s", m->hw_handler_name);
 	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
 		ti->error = "unknown hardware handler type";
-		kfree(m->hw_handler_name);
-		m->hw_handler_name = NULL;
-		return -EINVAL;
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	if (hw_argc > 1) {
+		char *p;
+		int i, j, len = 4;
+
+		for (i = 0; i <= hw_argc - 2; i++)
+			len += strlen(as->argv[i]) + 1;
+		p = m->hw_handler_params = kzalloc(len, GFP_KERNEL);
+		if (!p) {
+			ti->error = "memory allocation failed";
+			ret = -ENOMEM;
+			goto fail;
+		}
+		j = sprintf(p, "%d", hw_argc - 1);
+		for (i = 0, p+=j+1; i <= hw_argc - 2; i++, p+=j+1)
+			j = sprintf(p, "%s", as->argv[i]);
 	}
 	consume(as, hw_argc - 1);
 
 	return 0;
+fail:
+	kfree(m->hw_handler_name);
+	m->hw_handler_name = NULL;
+	return ret;
 }
 
 static int parse_features(struct arg_set *as, struct multipath *m)

--=-co0K2GVJDoK4BhJxmnya
Content-Disposition: attachment; filename=sles11_scsi_dh_params
Content-Type: text/plain; name=sles11_scsi_dh_params; charset=UTF-8
Content-Transfer-Encoding: 7bit

When we moved the device handler functionality from dm layer to SCSI layer
we dropped the paramaeter functionality.

This path adds an interface to scsi dh layer to set device handler 
parameters.

Basically, multipath layer need to create a string with all the parameters
and call scsi_dh_set_params() after it called scsi_dh_attach() on a
device.

If a device handler provides such an interface it will handle the parameters as
it expects them.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh.c |   33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h            |    1 +
 include/scsi/scsi_dh.h                |    5 +++++
 3 files changed, 39 insertions(+)

Index: linux/include/scsi/scsi_device.h
===================================================================
--- linux.orig/include/scsi/scsi_device.h
+++ linux/include/scsi/scsi_device.h
@@ -189,6 +189,7 @@ struct scsi_device_handler {
 	void (*detach)(struct scsi_device *);
 	int (*activate)(struct scsi_device *);
 	int (*prep_fn)(struct scsi_device *, struct request *);
+	int (*set_params)(struct scsi_device *, const char *);
 };
 
 struct scsi_dh_data {
Index: linux/include/scsi/scsi_dh.h
===================================================================
--- linux.orig/include/scsi/scsi_dh.h
+++ linux/include/scsi/scsi_dh.h
@@ -60,6 +60,7 @@ extern int scsi_dh_activate(struct reque
 extern int scsi_dh_handler_exist(const char *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
 extern void scsi_dh_detach(struct request_queue *);
+extern int scsi_dh_set_params(struct request_queue *, const char *);
 #else
 static inline int scsi_dh_activate(struct request_queue *req)
 {
@@ -77,4 +78,8 @@ static inline void scsi_dh_detach(struct
 {
 	return;
 }
+static inline int scsi_dh_set_params(struct request_queue *req, const char *params)
+{
+	return -SCSI_DH_NOSYS;
+}
 #endif
Index: linux/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux/drivers/scsi/device_handler/scsi_dh.c
@@ -445,6 +445,39 @@ int scsi_dh_activate(struct request_queu
 EXPORT_SYMBOL_GPL(scsi_dh_activate);
 
 /*
+ * scsi_dh_set_params - set the parameters for the device as per the
+ *      string specified in params.
+ * @q - Request queue that is associated with the scsi_device for
+ *      which the parameters to be set.
+ * @params - parameters in the following format
+ *      "no_of_params\0param1\0param2\0param3\0...\0"
+ *      for example, string for 2 parameters with value 10 and 21
+ *      is specified as "2\010\021\0".
+ */
+int scsi_dh_set_params(struct request_queue *q, const char *params)
+{
+	int err = -SCSI_DH_NOSYS;
+	unsigned long flags;
+	struct scsi_device *sdev;
+	struct scsi_device_handler *scsi_dh = NULL;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	sdev = q->queuedata;
+	if (sdev && sdev->scsi_dh_data)
+		scsi_dh = sdev->scsi_dh_data->scsi_dh;
+	if (scsi_dh && scsi_dh->set_params && get_device(&sdev->sdev_gendev))
+		err = 0;
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (err)
+		return err;
+	err = scsi_dh->set_params(sdev, params);
+	put_device(&sdev->sdev_gendev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_set_params);
+
+/*
  * scsi_dh_handler_exist - Return TRUE(1) if a device handler exists for
  *	the given name. FALSE(0) otherwise.
  * @name - name of the device handler.

--=-co0K2GVJDoK4BhJxmnya--

