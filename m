From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 22 Oct 2010 21:30:53 +0400
Message-ID: <4CC1CA4D.1090609@vlnb.net>
References: <4CA653F0.1010008@vlnb.net> <4CA656AD.8020408@vlnb.net> <20101009212047.GB27180@kroah.com> <4CB36592.6060909@vlnb.net> <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net> <20101012190345.GA25737@kroah.com> <4CB75E81.7000208@vlnb.net> <20101014200413.GA30831@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:63448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab0JVRbQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 13:31:16 -0400
In-Reply-To: <20101014200413.GA30831@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

Greg KH, on 10/15/2010 12:04 AM wrote:
> I am asking that ANY kobject release function call kfree to release the
> memory that object is embedded in.  That is how kobjects work, please
> read the documentation for more details.
> 
>> We have a simple and straightforward errors recovery semantic: if
>> scst_tgt_sysfs_create() failed, then tgt_kobj returned deinited as if
>> scst_tgt_sysfs_create() has never been called. This is a regular
>> practice in the kernel: don't return half-initialized objects.
> 
> True.
> 
>> If we implement freeing tgt in scst_tgtt_release() as you requesting, we
>> will need to add in the error recovery path additional recovery code to
>> track and delete half-initialized tgt_kobj. Particularly, we will need
>> to add additional flag to track that tgt_kobj initialized, hence needs
>> deleting. Similar flag and code will be added in all similar to scst_tgt
>> SCST objects.
>>
>> This code will be quite errors prone as you can see on the example of
>> device_register() which on failure requires device_put() to be called
>> (http://lkml.org/lkml/2010/9/19/93).
> 
> That's not "error prone", it's "people don't read the provided
> documentation about how to use the API".
> 
> And yes, one could argue to make the API easier to use, and patches are
> always welcome to do so.
> 
>> (I'm not questioning device_register() implementation, there might be
>> very good reasons to implement it this way (I don't know), I mean, it
>> is too easy to forget to do the needed recovery of the half-created
>> objects as this case demonstrating.)
> 
> There are good reasons, but the most important one being, if you pass
> off an object, as of that moment in time, you had better handle the
> reference counting correctly.  If you think of it this way, cleanup
> logic is even simpler as that's the only rule you ever need to think
> about, none of thies "half-initialized" stuff.
> 
>> Could you confirm if I understand you correctly and need to implement
>> freeing tgt in the kobject release() function, please?
> 
> Again, yes.  Please read the documentation.

Here is the patch. It converts all the cases except 3:

 - struct scst_tgt_template and struct scst_dev_type, because they are supplied by
target drivers and dev handlers correspondingly and usually static.

 - struct scst_session, because sometimes we need to create several sessions for the
same initiator (for iSCSI sessions reinstatement, for instance) and for such cases need
a logic to have different SYSFS names for them. To have this logic functioning correctly,
we need to keep sessions alive longer than life of their kobject (see scst_sess_sysfs_create()
and scst_free_session() for more details).

I don't like this patch, because it makes the code in almost 100 lines of code bigger and
worse by making objects initialization/freeing a lot more complicated and harder to audit.
But, since you insist, I applied it.

It isn't late to revert it, just say a word.

Thanks,
Vlad

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 drivers/scst/scst_lib.c   |  102 ++++++++++++++----
 drivers/scst/scst_main.c  |   26 +---
 drivers/scst/scst_priv.h  |   37 +++++-
 drivers/scst/scst_sysfs.c |  247 ++++++++++++++++++++++++----------------------
 include/scst/scst.h       |   22 +++-
 5 files changed, 261 insertions(+), 173 deletions(-)

diff -upr linux-2.6.35/include/scst/scst.h linux-2.6.35/include/scst/scst.h
--- include/scst/scst.h
+++ include/scst/scst.h
@@ -1431,8 +1431,10 @@ struct scst_tgt {
 	char *default_group_name;
 #endif
 
+	unsigned int tgt_kobj_initialized:1;
+
 	/* sysfs release completion */
-	struct completion tgt_kobj_release_cmpl;
+	struct completion *tgt_kobj_release_cmpl;
 
 	struct kobject tgt_kobj; /* main targets/target kobject */
 	struct kobject *tgt_sess_kobj; /* target/sessions/ */
@@ -2077,6 +2079,9 @@ struct scst_device {
 	/* If set, dev is read only */
 	unsigned short rd_only:1;
 
+	/* If set, dev_kobj was initialized */
+	unsigned short dev_kobj_initialized:1;
+
 	/**************************************************************/
 
 	/*************************************************************
@@ -2217,7 +2222,7 @@ struct scst_device {
 	enum scst_dev_type_threads_pool_type threads_pool_type;
 
 	/* sysfs release completion */
-	struct completion dev_kobj_release_cmpl;
+	struct completion *dev_kobj_release_cmpl;
 
 	struct kobject dev_kobj; /* kobject for this struct */
 	struct kobject *dev_exp_kobj; /* exported groups */
@@ -2342,6 +2347,9 @@ struct scst_tgt_dev {
 	/* Set if INQUIRY DATA HAS CHANGED UA is needed */
 	unsigned int inq_changed_ua_needed:1;
 
+	/* Set if tgt_dev_kobj was initialized */
+	unsigned int tgt_dev_kobj_initialized:1;
+
 	/*
 	 * Stored Unit Attention sense and its length for possible
 	 * subsequent REQUEST SENSE. Both protected by tgt_dev_lock.
@@ -2350,7 +2358,7 @@ struct scst_tgt_dev {
 	uint8_t tgt_dev_sense[SCST_SENSE_BUFFERSIZE];
 
 	/* sysfs release completion */
-	struct completion tgt_dev_kobj_release_cmpl;
+	struct completion *tgt_dev_kobj_release_cmpl;
 
 	struct kobject tgt_dev_kobj; /* kobject for this struct */
 
@@ -2378,6 +2386,9 @@ struct scst_acg_dev {
 	/* If set, the corresponding LU is read only */
 	unsigned int rd_only:1;
 
+	/* If set acg_dev_kobj was initialized */
+	unsigned int acg_dev_kobj_initialized:1;
+
 	struct scst_acg *acg; /* parent acg */
 
 	/* List entry in dev->dev_acg_dev_list */
@@ -2390,7 +2401,7 @@ struct scst_acg_dev {
 	struct kobject acg_dev_kobj;
 
 	/* sysfs release completion */
-	struct completion acg_dev_kobj_release_cmpl;
+	struct completion *acg_dev_kobj_release_cmpl;
 
 	/* Name of the link to the corresponding LUN */
 	char acg_dev_link_name[20];
@@ -2431,9 +2442,10 @@ struct scst_acg {
 	cpumask_t acg_cpu_mask;
 
 	unsigned int tgt_acg:1;
+	unsigned int acg_kobj_initialized:1;
 
 	/* sysfs release completion */
-	struct completion acg_kobj_release_cmpl;
+	struct completion *acg_kobj_release_cmpl;
 
 	/* kobject for this structure */
 	struct kobject acg_kobj;
diff -upr linux-2.6.35/drivers/scst/scst_main.c linux-2.6.35/drivers/scst/scst_main.c
--- drivers/scst/scst_main.c
+++ drivers/scst/scst_main.c
@@ -553,7 +553,6 @@ out:
 #ifndef CONFIG_SCST_PROC
 out_sysfs_del:
 	mutex_unlock(&scst_mutex);
-	scst_tgt_sysfs_del(tgt);
 	goto out_free_tgt;
 #endif
 
@@ -640,10 +639,6 @@ again:
 	mutex_unlock(&scst_mutex);
 	scst_resume_activity();
 
-#ifndef CONFIG_SCST_PROC
-	scst_tgt_sysfs_del(tgt);
-#endif
-
 	PRINT_INFO("Target %s for template %s unregistered successfully",
 		tgt->tgt_name, vtt->name);
 
@@ -862,7 +857,7 @@ static int scst_register_device(struct s
 #endif
 	}
 
-	res = scst_alloc_device(GFP_KERNEL, &dev);
+	res = scst_alloc_dev(GFP_KERNEL, &dev);
 	if (res != 0)
 		goto out_unlock;
 
@@ -925,7 +920,7 @@ out_del:
 	list_del(&dev->dev_list_entry);
 
 out_free_dev:
-	scst_free_device(dev);
+	scst_free_dev(dev);
 
 out_unlock:
 	mutex_unlock(&scst_mutex);
@@ -973,12 +968,10 @@ static void scst_unregister_device(struc
 
 	scst_resume_activity();
 
-	scst_dev_sysfs_del(dev);
-
 	PRINT_INFO("Detached from scsi%d, channel %d, id %d, lun %d, type %d",
 		scsidp->host->host_no, scsidp->channel, scsidp->id,
 		scsidp->lun, scsidp->type);
 
-	scst_free_device(dev);
+	scst_free_dev(dev);
 
 out:
@@ -1054,7 +1047,6 @@ int scst_register_virtual_device(struct 
 {
 	int res, rc;
 	struct scst_device *dev, *d;
-	bool sysfs_del = false;
 
@@ -1088,7 +1080,7 @@ int scst_register_virtual_device(struct 
 		goto out_resume;
 	}
 
-	res = scst_alloc_device(GFP_KERNEL, &dev);
+	res = scst_alloc_dev(GFP_KERNEL, &dev);
 	if (res != 0)
 		goto out_unlock;
 
@@ -1135,7 +1127,6 @@ int scst_register_virtual_device(struct 
 		if (strcmp(d->virt_name, dev_name) == 0) {
 			PRINT_ERROR("Device %s already exists", dev_name);
 			res = -EEXIST;
-			sysfs_del = true;
 			goto out_pr_clear_dev;
 		}
 	}
@@ -1143,7 +1134,6 @@ int scst_register_virtual_device(struct 
 	rc = scst_assign_dev_handler(dev, dev_handler);
 	if (rc != 0) {
 		res = rc;
-		sysfs_del = true;
 		goto out_pr_clear_dev;
 	}
 
@@ -1171,9 +1161,7 @@ out_pr_clear_dev:
 
 out_free_dev:
 	mutex_unlock(&scst_mutex);
-	if (sysfs_del)
-		scst_dev_sysfs_del(dev);
-	scst_free_device(dev);
+	scst_free_dev(dev);
 	goto out_resume;
 
 out_unlock:
@@ -1225,12 +1213,10 @@ void scst_unregister_virtual_device(int 
 	mutex_unlock(&scst_mutex);
 	scst_resume_activity();
 
-	scst_dev_sysfs_del(dev);
-
 	PRINT_INFO("Detached from virtual device %s (id %d)",
 		dev->virt_name, dev->virt_id);
 
-	scst_free_device(dev);
+	scst_free_dev(dev);
 
 out:
diff -upr linux-2.6.35/drivers/scst/scst_priv.h linux-2.6.35/drivers/scst/scst_priv.h
--- drivers/scst/scst_priv.h
+++ drivers/scst/scst_priv.h
@@ -306,13 +306,16 @@ int scst_queue_retry_cmd(struct scst_cmd
 
 int scst_alloc_tgt(struct scst_tgt_template *tgtt, struct scst_tgt **tgt);
 void scst_free_tgt(struct scst_tgt *tgt);
+void __scst_free_tgt(struct scst_tgt *tgt);
 
-int scst_alloc_device(gfp_t gfp_mask, struct scst_device **out_dev);
-void scst_free_device(struct scst_device *dev);
+int scst_alloc_dev(gfp_t gfp_mask, struct scst_device **out_dev);
+void scst_free_dev(struct scst_device *dev);
+void __scst_free_dev(struct scst_device *dev);
 
 struct scst_acg *scst_alloc_add_acg(struct scst_tgt *tgt,
 	const char *acg_name, bool tgt_acg);
 void scst_del_free_acg(struct scst_acg *acg);
+void __scst_free_acg(struct scst_acg *acg);
 
 struct scst_acg *scst_tgt_find_acg(struct scst_tgt *tgt, const char *name);
 struct scst_acg *scst_find_acg(const struct scst_session *sess);
@@ -323,6 +326,8 @@ int scst_sess_alloc_tgt_devs(struct scst
 void scst_sess_free_tgt_devs(struct scst_session *sess);
 void scst_nexus_loss(struct scst_tgt_dev *tgt_dev, bool queue_UA);
 
+void __scst_free_tgt_dev(struct scst_tgt_dev *tgt_dev);
+
 int scst_acg_add_lun(struct scst_acg *acg, struct kobject *parent,
 	struct scst_device *dev, uint64_t lun, int read_only,
 	bool gen_scst_report_luns_changed, struct scst_acg_dev **out_acg_dev);
@@ -336,6 +341,8 @@ int scst_acg_remove_name(struct scst_acg
 void scst_del_free_acn(struct scst_acn *acn, bool reassign);
 struct scst_acn *scst_find_acn(struct scst_acg *acg, const char *name);
 
+void scst_free_acg_dev(struct scst_acg_dev *acg_dev);
+
 /* The activity supposed to be suspended and scst_mutex held */
 static inline bool scst_acg_sess_is_empty(struct scst_acg *acg)
 {
@@ -426,19 +433,24 @@ static inline int scst_sysfs_init(void)
 }
 static inline void scst_sysfs_cleanup(void) { }
 
+static inline void scst_tgt_sysfs_del_free(struct scst_tgt *tgt) { BUG(); }
+
 static inline int scst_devt_dev_sysfs_create(struct scst_device *dev)
 {
 	return 0;
 }
 static inline void scst_devt_dev_sysfs_del(struct scst_device *dev) { }
 
-static inline void scst_dev_sysfs_del(struct scst_device *dev) { }
+static inline void scst_dev_sysfs_del_free(struct scst_device *dev) { BUG(); }
 
 static inline int scst_tgt_dev_sysfs_create(struct scst_tgt_dev *tgt_dev)
 {
 	return 0;
 }
-static inline void scst_tgt_dev_sysfs_del(struct scst_tgt_dev *tgt_dev) { }
+static inline void scst_tgt_dev_sysfs_del_free(struct scst_tgt_dev *tgt_dev)
+{
+	BUG();
+}
 
 static inline int scst_sess_sysfs_create(struct scst_session *sess)
 {
@@ -451,7 +463,12 @@ static inline int scst_acg_dev_sysfs_cre
 	return 0;
 }
 
-static inline void scst_acg_dev_sysfs_del(struct scst_acg_dev *acg_dev) { }
+static inline void scst_acg_dev_sysfs_del_free(struct scst_acg_dev *acg_dev)
+{
+	BUG();
+}
+
+static inline void scst_acg_sysfs_del_free(struct scst_acg *acg) { BUG(); }
 
 static inline int scst_acn_sysfs_create(struct scst_acn *acn)
 {
@@ -473,7 +490,7 @@ int scst_tgtt_sysfs_create(struct scst_t
 void scst_tgtt_sysfs_del(struct scst_tgt_template *tgtt);
 int scst_tgt_sysfs_create(struct scst_tgt *tgt);
 void scst_tgt_sysfs_prepare_put(struct scst_tgt *tgt);
-void scst_tgt_sysfs_del(struct scst_tgt *tgt);
+void scst_tgt_sysfs_del_free(struct scst_tgt *tgt);
 int scst_sess_sysfs_create(struct scst_session *sess);
 void scst_sess_sysfs_del(struct scst_session *sess);
 int scst_recreate_sess_luns_link(struct scst_session *sess);
@@ -482,17 +499,17 @@ void scst_sgv_sysfs_del(struct sgv_pool 
 int scst_devt_sysfs_create(struct scst_dev_type *devt);
 void scst_devt_sysfs_del(struct scst_dev_type *devt);
 int scst_dev_sysfs_create(struct scst_device *dev);
-void scst_dev_sysfs_del(struct scst_device *dev);
+void scst_dev_sysfs_del_free(struct scst_device *dev);
 int scst_tgt_dev_sysfs_create(struct scst_tgt_dev *tgt_dev);
-void scst_tgt_dev_sysfs_del(struct scst_tgt_dev *tgt_dev);
+void scst_tgt_dev_sysfs_del_free(struct scst_tgt_dev *tgt_dev);
 int scst_devt_dev_sysfs_create(struct scst_device *dev);
 void scst_devt_dev_sysfs_del(struct scst_device *dev);
 int scst_acg_sysfs_create(struct scst_tgt *tgt,
 	struct scst_acg *acg);
-void scst_acg_sysfs_del(struct scst_acg *acg);
+void scst_acg_sysfs_del_free(struct scst_acg *acg);
 int scst_acg_dev_sysfs_create(struct scst_acg_dev *acg_dev,
 	struct kobject *parent);
-void scst_acg_dev_sysfs_del(struct scst_acg_dev *acg_dev);
+void scst_acg_dev_sysfs_del_free(struct scst_acg_dev *acg_dev);
 int scst_acn_sysfs_create(struct scst_acn *acn);
 void scst_acn_sysfs_del(struct scst_acn *acn);
 
diff -upr linux-2.6.35/drivers/scst/scst_lib.c linux-2.6.35/drivers/scst/scst_lib.c
--- drivers/scst/scst_lib.c
+++ drivers/scst/scst_lib.c
@@ -2536,7 +2536,7 @@ out:
 }
 
 /* No locks */
-void scst_free_tgt(struct scst_tgt *tgt)
+void __scst_free_tgt(struct scst_tgt *tgt)
 {
@@ -2551,8 +2551,22 @@ void scst_free_tgt(struct scst_tgt *tgt)
 	return;
 }
 
+/* No locks */
+void scst_free_tgt(struct scst_tgt *tgt)
+{
+	if (tgt->tgt_kobj_initialized)
+		scst_tgt_sysfs_del_free(tgt);
+	else
+		__scst_free_tgt(tgt);
+	return;
+}
+
 /* Called under scst_mutex and suspended activity */
-int scst_alloc_device(gfp_t gfp_mask, struct scst_device **out_dev)
+int scst_alloc_dev(gfp_t gfp_mask, struct scst_device **out_dev)
 {
 	struct scst_device *dev;
 	int res = 0;
@@ -2596,7 +2610,20 @@ out:
 	return res;
 }
 
-void scst_free_device(struct scst_device *dev)
+void __scst_free_dev(struct scst_device *dev)
+{
+	TRACE_MEM("Freeing dev %p", dev);
+
+	kfree(dev->virt_name);
+	kfree(dev);
+}
+
+/*
+ * Must not be called under scst_mutex, due to possible deadlock with
+ * sysfs ref counting in sysfs works (it is waiting for the last put, but
+ * the last ref counter holder is waiting for scst_mutex)
+ */
+void scst_free_dev(struct scst_device *dev)
 {
@@ -2611,8 +2638,10 @@ void scst_free_device(struct scst_device
 
 	scst_deinit_threads(&dev->dev_cmd_threads);
 
-	kfree(dev->virt_name);
-	kfree(dev);
+	if (dev->dev_kobj_initialized)
+		scst_dev_sysfs_del_free(dev);
+	else
+		__scst_free_dev(dev);
 	return;
@@ -2656,11 +2685,17 @@ out:
 	return res;
 }
 
+void scst_free_acg_dev(struct scst_acg_dev *acg_dev)
+{
+	TRACE_MEM("Freeing acg_dev %p", acg_dev);
+	kmem_cache_free(scst_acgd_cachep, acg_dev);
+}
+
 /*
  * The activity supposed to be suspended and scst_mutex held or the
  * corresponding target supposed to be stopped.
  */
-static void scst_del_free_acg_dev(struct scst_acg_dev *acg_dev, bool del_sysfs)
+static void scst_del_free_acg_dev(struct scst_acg_dev *acg_dev)
 {
@@ -2669,10 +2704,10 @@ static void scst_del_free_acg_dev(struct
 	list_del(&acg_dev->acg_dev_list_entry);
 	list_del(&acg_dev->dev_acg_dev_list_entry);
 
-	if (del_sysfs)
-		scst_acg_dev_sysfs_del(acg_dev);
-
-	kmem_cache_free(scst_acgd_cachep, acg_dev);
+	if (acg_dev->acg_dev_kobj_initialized)
+		scst_acg_dev_sysfs_del_free(acg_dev);
+	else
+		scst_free_acg_dev(acg_dev);
 	return;
@@ -2688,7 +2723,6 @@ int scst_acg_add_lun(struct scst_acg *ac
 	struct scst_tgt_dev *tgt_dev;
 	struct scst_session *sess;
 	LIST_HEAD(tmp_tgt_dev_list);
-	bool del_sysfs = true;
 
@@ -2718,10 +2752,8 @@ int scst_acg_add_lun(struct scst_acg *ac
 	}
 
 	res = scst_acg_dev_sysfs_create(acg_dev, parent);
-	if (res != 0) {
-		del_sysfs = false;
+	if (res != 0)
 		goto out_free;
-	}
 
 	if (gen_scst_report_luns_changed)
 		scst_report_luns_changed(acg);
@@ -2742,7 +2774,7 @@ out_free:
 			 extra_tgt_dev_list_entry) {
 		scst_free_tgt_dev(tgt_dev);
 	}
-	scst_del_free_acg_dev(acg_dev, del_sysfs);
+	scst_del_free_acg_dev(acg_dev);
 	goto out;
 }
 
@@ -2774,7 +2806,7 @@ int scst_acg_del_lun(struct scst_acg *ac
 			scst_free_tgt_dev(tgt_dev);
 	}
 
-	scst_del_free_acg_dev(acg_dev, true);
+	scst_del_free_acg_dev(acg_dev);
 
 	if (gen_scst_report_luns_changed)
 		scst_report_luns_changed(acg);
@@ -2787,6 +2819,22 @@ out:
 	return res;
 }
 
+void __scst_free_acg(struct scst_acg *acg)
+{
+	TRACE_MEM("Freeing acg %p", acg);
+
+	kfree(acg->acg_name);
+	kfree(acg);
+}
+
+static void scst_free_acg(struct scst_acg *acg)
+{
+	if (acg->acg_kobj_initialized)
+		scst_acg_sysfs_del_free(acg);
+	else
+		__scst_free_acg(acg);
+}
+
 /* The activity supposed to be suspended and scst_mutex held */
 struct scst_acg *scst_alloc_add_acg(struct scst_tgt *tgt,
 	const char *acg_name, bool tgt_acg)
@@ -2844,7 +2892,7 @@ out_del:
 #endif
 
 out_free:
-	kfree(acg);
+	scst_free_acg(acg);
 	acg = NULL;
 	goto out;
 }
@@ -2871,7 +2919,7 @@ void scst_del_free_acg(struct scst_acg *
 			if (tgt_dev->acg_dev == acg_dev)
 				scst_free_tgt_dev(tgt_dev);
 		}
-		scst_del_free_acg_dev(acg_dev, true);
+		scst_del_free_acg_dev(acg_dev);
 	}
 
 	/* Freeing names */
@@ -2887,8 +2935,6 @@ void scst_del_free_acg(struct scst_acg *
 	if (acg->tgt_acg) {
 		TRACE_DBG("Removing acg %s from list", acg->acg_name);
 		list_del(&acg->acg_list_entry);
-
-		scst_acg_sysfs_del(acg);
 	} else
 		acg->tgt->default_acg = NULL;
 #endif
@@ -2897,8 +2943,7 @@ void scst_del_free_acg(struct scst_acg *
 	sBUG_ON(!list_empty(&acg->acg_dev_list));
 	sBUG_ON(!list_empty(&acg->acn_list));
 
-	kfree(acg->acg_name);
-	kfree(acg);
+	scst_free_acg(acg);
 	return;
@@ -3440,6 +3485,12 @@ void scst_nexus_loss(struct scst_tgt_dev
 	return;
 }
 
+void __scst_free_tgt_dev(struct scst_tgt_dev *tgt_dev)
+{
+	TRACE_MEM("Freeing tgt_dev %p", tgt_dev);
+	kmem_cache_free(scst_tgtd_cachep, tgt_dev);
+}
+
 /*
  * scst_mutex supposed to be held, there must not be parallel activity in this
  * session.
@@ -3456,8 +3507,6 @@ static void scst_free_tgt_dev(struct scs
 
 	list_del(&tgt_dev->sess_tgt_dev_list_entry);
 
-	scst_tgt_dev_sysfs_del(tgt_dev);
-
 	if (tgt_dev->sess->tgt->tgtt->get_initiator_port_transport_id == NULL)
 		dev->not_pr_supporting_tgt_devs_num--;
 
@@ -3476,7 +3525,10 @@ static void scst_free_tgt_dev(struct scs
 
 	sBUG_ON(!list_empty(&tgt_dev->thr_data_list));
 
-	kmem_cache_free(scst_tgtd_cachep, tgt_dev);
+	if (tgt_dev->tgt_dev_kobj_initialized)
+		scst_tgt_dev_sysfs_del_free(tgt_dev);
+	else
+		__scst_free_tgt_dev(tgt_dev);
 	return;
diff -upr linux-2.6.35/drivers/scst/scst_sysfs.c linux-2.6.35/drivers/scst/scst_sysfs.c
--- drivers/scst/scst_sysfs.c
+++ drivers/scst/scst_sysfs.c
@@ -922,7 +922,9 @@ static void scst_tgt_release(struct kobj
 	tgt = container_of(kobj, struct scst_tgt, tgt_kobj);
-	complete_all(&tgt->tgt_kobj_release_cmpl);
+	complete_all(tgt->tgt_kobj_release_cmpl);
+
+	__scst_free_tgt(tgt);
 	return;
@@ -940,7 +942,9 @@ static void scst_acg_release(struct kobj
 	acg = container_of(kobj, struct scst_acg, acg_kobj);
-	complete_all(&acg->acg_kobj_release_cmpl);
+	complete_all(acg->acg_kobj_release_cmpl);
+
+	__scst_free_acg(acg);
 	return;
@@ -1116,8 +1120,11 @@ static struct kobj_attribute tgt_enable_
 	       scst_tgt_enable_show, scst_tgt_enable_store);
 
 /*
- * Supposed to be called under scst_mutex. In case of error will drop,
- * then reacquire it.
+ * Supposed to be called under scst_mutex.
+ *
+ * Upon return, including with an error, if tgt_kobj_initialized set
+ * scst_tgt_sysfs_del_free() must be called to free tgt instead of
+ * __scst_free_tgt()!
  */
 int scst_tgt_sysfs_create(struct scst_tgt *tgt)
 {
@@ -1126,8 +1133,6 @@ int scst_tgt_sysfs_create(struct scst_tg
 
-	init_completion(&tgt->tgt_kobj_release_cmpl);
-
 	res = kobject_init_and_add(&tgt->tgt_kobj, &tgt_ktype,
 			&tgt->tgtt->tgtt_kobj, tgt->tgt_name);
 	if (res != 0) {
@@ -1135,6 +1140,8 @@ int scst_tgt_sysfs_create(struct scst_tg
 		goto out;
 	}
 
+	tgt->tgt_kobj_initialized = 1;
+
 	if ((tgt->tgtt->enable_target != NULL) &&
 	    (tgt->tgtt->is_target_enabled != NULL)) {
 		res = sysfs_create_file(&tgt->tgt_kobj,
@@ -1142,7 +1149,7 @@ int scst_tgt_sysfs_create(struct scst_tg
 		if (res != 0) {
 			PRINT_ERROR("Can't add attr %s to sysfs",
 				tgt_enable_attr.attr.name);
-			goto out_err;
+			goto out;
 		}
 	}
 
@@ -1162,7 +1169,7 @@ int scst_tgt_sysfs_create(struct scst_tg
 	if (res != 0) {
 		PRINT_ERROR("Can't add attribute %s for tgt %s",
 			scst_luns_mgmt.attr.name, tgt->tgt_name);
-		goto out_err;
+		goto out;
 	}
 
 	tgt->tgt_ini_grp_kobj = kobject_create_and_add("ini_groups",
@@ -1178,7 +1185,7 @@ int scst_tgt_sysfs_create(struct scst_tg
 	if (res != 0) {
 		PRINT_ERROR("Can't add attribute %s for tgt %s",
 			scst_ini_group_mgmt.attr.name, tgt->tgt_name);
-		goto out_err;
+		goto out;
 	}
 
 	res = sysfs_create_file(&tgt->tgt_kobj,
@@ -1186,7 +1193,7 @@ int scst_tgt_sysfs_create(struct scst_tg
 	if (res != 0) {
 		PRINT_ERROR("Can't add attribute %s for tgt %s",
 			scst_rel_tgt_id.attr.name, tgt->tgt_name);
-		goto out_err;
+		goto out;
 	}
 
 	res = sysfs_create_file(&tgt->tgt_kobj,
@@ -1194,7 +1201,7 @@ int scst_tgt_sysfs_create(struct scst_tg
 	if (res != 0) {
 		PRINT_ERROR("Can't add attribute %s for tgt %s",
 			scst_tgt_addr_method.attr.name, tgt->tgt_name);
-		goto out_err;
+		goto out;
 	}
 
 	res = sysfs_create_file(&tgt->tgt_kobj,
@@ -1202,14 +1209,14 @@ int scst_tgt_sysfs_create(struct scst_tg
 	if (res != 0) {
 		PRINT_ERROR("Can't add attribute %s for tgt %s",
 			scst_tgt_io_grouping_type.attr.name, tgt->tgt_name);
-		goto out_err;
+		goto out;
 	}
 
 	res = sysfs_create_file(&tgt->tgt_kobj, &scst_tgt_cpu_mask.attr);
 	if (res != 0) {
 		PRINT_ERROR("Can't add attribute %s for tgt %s",
 			scst_tgt_cpu_mask.attr.name, tgt->tgt_name);
-		goto out_err;
+		goto out;
 	}
 
 	pattr = tgt->tgtt->tgt_attrs;
@@ -1221,7 +1228,7 @@ int scst_tgt_sysfs_create(struct scst_tg
 			if (res != 0) {
 				PRINT_ERROR("Can't add tgt attr %s for tgt %s",
 					(*pattr)->name, tgt->tgt_name);
-				goto out_err;
+				goto out;
 			}
 			pattr++;
 		}
@@ -1233,25 +1240,24 @@ out:
 
 out_nomem:
 	res = -ENOMEM;
-
-out_err:
-	mutex_unlock(&scst_mutex);
-	scst_tgt_sysfs_del(tgt);
-	mutex_lock(&scst_mutex);
 	goto out;
 }
 
 /*
+ * Deletes tgt from sysfs and frees it in the tgt_kobj release()
+ *
  * Must not be called under scst_mutex, due to possible deadlock with
  * sysfs ref counting in sysfs works (it is waiting for the last put, but
  * the last ref counter holder is waiting for scst_mutex)
  */
-void scst_tgt_sysfs_del(struct scst_tgt *tgt)
+void scst_tgt_sysfs_del_free(struct scst_tgt *tgt)
 {
-	int rc;
+	DECLARE_COMPLETION_ONSTACK(cmpl);
 
+	tgt->tgt_kobj_release_cmpl = &cmpl;
+
 	kobject_del(tgt->tgt_sess_kobj);
 	kobject_put(tgt->tgt_sess_kobj);
 
@@ -1261,18 +1267,17 @@ void scst_tgt_sysfs_del(struct scst_tgt 
 	kobject_del(tgt->tgt_ini_grp_kobj);
 	kobject_put(tgt->tgt_ini_grp_kobj);
 
+	if (atomic_read(&tgt->tgt_kobj.kref.refcount) > 1)
+		TRACE_MGMT_DBG("Waiting for releasing sysfs entry "
+			"for tgt %s (%d refs)...", tgt->tgt_name,
+			atomic_read(&tgt->tgt_kobj.kref.refcount));
+
 	kobject_del(&tgt->tgt_kobj);
 	kobject_put(&tgt->tgt_kobj);
 
-	rc = wait_for_completion_timeout(&tgt->tgt_kobj_release_cmpl, HZ);
-	if (rc == 0) {
-		PRINT_INFO("Waiting for releasing sysfs entry "
-			"for target %s (%d refs)...", tgt->tgt_name,
-			atomic_read(&tgt->tgt_kobj.kref.refcount));
-		wait_for_completion(&tgt->tgt_kobj_release_cmpl);
-		PRINT_INFO("Done waiting for releasing sysfs "
-			"entry for target %s", tgt->tgt_name);
-	}
+	/* tgt can be dead here! */
+
+	wait_for_completion(&cmpl);
 	return;
@@ -1578,7 +1583,9 @@ static void scst_sysfs_dev_release(struc
 	dev = container_of(kobj, struct scst_device, dev_kobj);
-	complete_all(&dev->dev_kobj_release_cmpl);
+	complete_all(dev->dev_kobj_release_cmpl);
+
+	__scst_free_dev(dev);
 	return;
@@ -1690,8 +1697,9 @@ static struct kobj_type scst_dev_ktype =
 };
 
 /*
- * Must not be called under scst_mutex, because it can call
- * scst_dev_sysfs_del()
+ * Upon return, including with an error, if dev_kobj_initialized set
+ * scst_dev_sysfs_del_free() must be called to free dev instead of
+ * __scst_free_dev()!
  */
 int scst_dev_sysfs_create(struct scst_device *dev)
 {
@@ -1699,8 +1707,6 @@ int scst_dev_sysfs_create(struct scst_de
 
-	init_completion(&dev->dev_kobj_release_cmpl);
-
 	res = kobject_init_and_add(&dev->dev_kobj, &scst_dev_ktype,
 				      scst_devices_kobj, dev->virt_name);
 	if (res != 0) {
@@ -1708,13 +1714,15 @@ int scst_dev_sysfs_create(struct scst_de
 		goto out;
 	}
 
+	dev->dev_kobj_initialized = 1;
+
 	dev->dev_exp_kobj = kobject_create_and_add("exported",
 						   &dev->dev_kobj);
 	if (dev->dev_exp_kobj == NULL) {
 		PRINT_ERROR("Can't create exported link for device %s",
 			dev->virt_name);
 		res = -ENOMEM;
-		goto out_del;
+		goto out;
 	}
 
 	if (dev->scsi_dev != NULL) {
@@ -1723,7 +1731,7 @@ int scst_dev_sysfs_create(struct scst_de
 		if (res != 0) {
 			PRINT_ERROR("Can't create scsi_device link for dev %s",
 				dev->virt_name);
-			goto out_del;
+			goto out;
 		}
 	}
 
@@ -1734,7 +1742,7 @@ int scst_dev_sysfs_create(struct scst_de
 		if (res != 0) {
 			PRINT_ERROR("Can't create attr %s for dev %s",
 				dev_dump_prs_attr.attr.name, dev->virt_name);
-			goto out_del;
+			goto out;
 		}
 	}
 #endif
@@ -1742,38 +1750,37 @@ int scst_dev_sysfs_create(struct scst_de
 out:
 	return res;
-
-out_del:
-	scst_dev_sysfs_del(dev);
-	goto out;
 }
 
 /*
+ * Deletes dev from sysfs and frees it in the dev_kobj release()
+ *
  * Must not be called under scst_mutex, due to possible deadlock with
  * sysfs ref counting in sysfs works (it is waiting for the last put, but
  * the last ref counter holder is waiting for scst_mutex)
  */
-void scst_dev_sysfs_del(struct scst_device *dev)
+void scst_dev_sysfs_del_free(struct scst_device *dev)
 {
-	int rc;
+	DECLARE_COMPLETION_ONSTACK(cmpl);
 
+	dev->dev_kobj_release_cmpl = &cmpl;
+
 	kobject_del(dev->dev_exp_kobj);
 	kobject_put(dev->dev_exp_kobj);
 
+	if (atomic_read(&dev->dev_kobj.kref.refcount) > 1)
+		TRACE_MGMT_DBG("Waiting for releasing sysfs entry "
+			"for dev %s (%d refs)...", dev->virt_name,
+			atomic_read(&dev->dev_kobj.kref.refcount));
+
 	kobject_del(&dev->dev_kobj);
 	kobject_put(&dev->dev_kobj);
 
-	rc = wait_for_completion_timeout(&dev->dev_kobj_release_cmpl, HZ);
-	if (rc == 0) {
-		PRINT_INFO("Waiting for releasing sysfs entry "
-			"for device %s (%d refs)...", dev->virt_name,
-			atomic_read(&dev->dev_kobj.kref.refcount));
-		wait_for_completion(&dev->dev_kobj_release_cmpl);
-		PRINT_INFO("Done waiting for releasing sysfs "
-			"entry for device %s", dev->virt_name);
-	}
+	/* dev can be dead here! */
+
+	wait_for_completion(&cmpl);
 	return;
@@ -1930,7 +1937,9 @@ static void scst_sysfs_tgt_dev_release(s
 	tgt_dev = container_of(kobj, struct scst_tgt_dev, tgt_dev_kobj);
-	complete_all(&tgt_dev->tgt_dev_kobj_release_cmpl);
+	complete_all(tgt_dev->tgt_dev_kobj_release_cmpl);
+
+	__scst_free_tgt_dev(tgt_dev);
 	return;
@@ -1948,8 +1957,6 @@ int scst_tgt_dev_sysfs_create(struct scs
 
-	init_completion(&tgt_dev->tgt_dev_kobj_release_cmpl);
-
 	res = kobject_init_and_add(&tgt_dev->tgt_dev_kobj, &scst_tgt_dev_ktype,
 			      &tgt_dev->sess->sess_kobj, "lun%lld",
 			      (unsigned long long)tgt_dev->lun);
@@ -1959,38 +1966,42 @@ int scst_tgt_dev_sysfs_create(struct scs
 		goto out;
 	}
 
+	tgt_dev->tgt_dev_kobj_initialized = 1;
+
 out:
 	return res;
 }
 
 /*
+ * Deletes tgt_dev from sysfs and frees it in the tgt_dev_kobj release()
+ *
  * Called with scst_mutex held.
  *
  * !! No sysfs works must use kobject_get() to protect tgt_dev, due to possible
  * !! deadlock with scst_mutex (it is waiting for the last put, but
  * !! the last ref counter holder is waiting for scst_mutex)
  */
-void scst_tgt_dev_sysfs_del(struct scst_tgt_dev *tgt_dev)
+void scst_tgt_dev_sysfs_del_free(struct scst_tgt_dev *tgt_dev)
 {
-	int rc;
+	DECLARE_COMPLETION_ONSTACK(cmpl);
 
-	kobject_del(&tgt_dev->tgt_dev_kobj);
-	kobject_put(&tgt_dev->tgt_dev_kobj);
+	tgt_dev->tgt_dev_kobj_release_cmpl = &cmpl;
 
-	rc = wait_for_completion_timeout(
-			&tgt_dev->tgt_dev_kobj_release_cmpl, HZ);
-	if (rc == 0) {
-		PRINT_INFO("Waiting for releasing sysfs entry "
-			"for tgt_dev %lld (%d refs)...",
+	if (atomic_read(&tgt_dev->tgt_dev_kobj.kref.refcount) > 1)
+		TRACE_MGMT_DBG("Waiting for releasing sysfs entry "
+			"for tgt_dev LUN %lld, (%d refs)...",
 			(unsigned long long)tgt_dev->lun,
 			atomic_read(&tgt_dev->tgt_dev_kobj.kref.refcount));
-		wait_for_completion(&tgt_dev->tgt_dev_kobj_release_cmpl);
-		PRINT_INFO("Done waiting for releasing sysfs entry for "
-			"tgt_dev %lld", (unsigned long long)tgt_dev->lun);
-	}
+
+	kobject_del(&tgt_dev->tgt_dev_kobj);
+	kobject_put(&tgt_dev->tgt_dev_kobj);
+
+	/* tgt_dev can be dead here! */
+
+	wait_for_completion(&cmpl);
 	return;
@@ -2515,7 +2526,9 @@ static void scst_acg_dev_release(struct 
 	acg_dev = container_of(kobj, struct scst_acg_dev, acg_dev_kobj);
-	complete_all(&acg_dev->acg_dev_kobj_release_cmpl);
+	complete_all(acg_dev->acg_dev_kobj_release_cmpl);
+
+	scst_free_acg_dev(acg_dev);
 	return;
@@ -2550,41 +2563,49 @@ static struct kobj_type acg_dev_ktype = 
 };
 
 /*
+ * Deletes acg_dev from sysfs and frees it in the acg_dev_kobj release()
+ *
  * Called with scst_mutex held.
  *
  * !! No sysfs works must use kobject_get() to protect acg_dev, due to possible
  * !! deadlock with scst_mutex (it is waiting for the last put, but
  * !! the last ref counter holder is waiting for scst_mutex)
  */
-void scst_acg_dev_sysfs_del(struct scst_acg_dev *acg_dev)
+void scst_acg_dev_sysfs_del_free(struct scst_acg_dev *acg_dev)
 {
-	int rc;
+	DECLARE_COMPLETION_ONSTACK(cmpl);
 
+	acg_dev->acg_dev_kobj_release_cmpl = &cmpl;
+
 	if (acg_dev->dev != NULL) {
 		sysfs_remove_link(acg_dev->dev->dev_exp_kobj,
 			acg_dev->acg_dev_link_name);
 		kobject_put(&acg_dev->dev->dev_kobj);
 	}
 
+	if (atomic_read(&acg_dev->acg_dev_kobj.kref.refcount) > 1)
+		TRACE_MGMT_DBG("Waiting for releasing sysfs entry "
+			"for acg_dev %p (%d refs)...", acg_dev,
+			atomic_read(&acg_dev->acg_dev_kobj.kref.refcount));
+
 	kobject_del(&acg_dev->acg_dev_kobj);
 	kobject_put(&acg_dev->acg_dev_kobj);
 
-	rc = wait_for_completion_timeout(&acg_dev->acg_dev_kobj_release_cmpl, HZ);
-	if (rc == 0) {
-		PRINT_INFO("Waiting for releasing sysfs entry "
-			"for acg_dev %p (%d refs)...", acg_dev,
-			atomic_read(&acg_dev->acg_dev_kobj.kref.refcount));
-		wait_for_completion(&acg_dev->acg_dev_kobj_release_cmpl);
-		PRINT_INFO("Done waiting for releasing sysfs "
-			"entry for acg_dev %p", acg_dev);
-	}
+	/* acg_dev can be dead here! */
+
+	wait_for_completion(&cmpl);
 	return;
 }
 
+/*
+ * Upon return, including with an error, if acg_dev_kobj_initialized set
+ * scst_acg_dev_sysfs_del_free() must be called to free acg_dev instead of
+ * scst_free_acg_dev()!
+ */
 int scst_acg_dev_sysfs_create(struct scst_acg_dev *acg_dev,
 	struct kobject *parent)
 {
@@ -2592,8 +2613,6 @@ int scst_acg_dev_sysfs_create(struct scs
 
-	init_completion(&acg_dev->acg_dev_kobj_release_cmpl);
-
 	res = kobject_init_and_add(&acg_dev->acg_dev_kobj, &acg_dev_ktype,
 				      parent, "%u", acg_dev->lun);
 	if (res != 0) {
@@ -2601,6 +2620,8 @@ int scst_acg_dev_sysfs_create(struct scs
 		goto out;
 	}
 
+	acg_dev->acg_dev_kobj_initialized = 1;
+
 	kobject_get(&acg_dev->dev->dev_kobj);
 
 	snprintf(acg_dev->acg_dev_link_name, sizeof(acg_dev->acg_dev_link_name),
@@ -2611,7 +2632,7 @@ int scst_acg_dev_sysfs_create(struct scs
 	if (res != 0) {
 		PRINT_ERROR("Can't create acg %s LUN link",
 			acg_dev->acg->acg_name);
-		goto out_del;
+		goto out;
 	}
 
 	res = sysfs_create_link(&acg_dev->acg_dev_kobj,
@@ -2619,15 +2640,11 @@ int scst_acg_dev_sysfs_create(struct scs
 	if (res != 0) {
 		PRINT_ERROR("Can't create acg %s device link",
 			acg_dev->acg->acg_name);
-		goto out_del;
+		goto out;
 	}
 
 out:
 	return res;
-
-out_del:
-	scst_acg_dev_sysfs_del(acg_dev);
-	goto out;
 }
 
 static int __scst_process_luns_mgmt_store(char *buffer,
@@ -3340,41 +3357,49 @@ out:
 }
 
 /*
+ * Deletes acg from sysfs and frees it in the acg_kobj release()
+ *
  * Called with scst_mutex held.
  *
  * !! No sysfs works must use kobject_get() to protect acg, due to possible
  * !! deadlock with scst_mutex (it is waiting for the last put, but
  * !! the last ref counter holder is waiting for scst_mutex)
  */
-void scst_acg_sysfs_del(struct scst_acg *acg)
+void scst_acg_sysfs_del_free(struct scst_acg *acg)
 {
-	int rc;
+	DECLARE_COMPLETION_ONSTACK(cmpl);
 
+	acg->acg_kobj_release_cmpl = &cmpl;
+
 	kobject_del(acg->luns_kobj);
 	kobject_put(acg->luns_kobj);
 
 	kobject_del(acg->initiators_kobj);
 	kobject_put(acg->initiators_kobj);
 
+	if (atomic_read(&acg->acg_kobj.kref.refcount) > 1)
+		TRACE_MGMT_DBG("Waiting for releasing sysfs entry "
+			"for acg %s (%d refs)...", acg->acg_name,
+			atomic_read(&acg->acg_kobj.kref.refcount));
+
 	kobject_del(&acg->acg_kobj);
 	kobject_put(&acg->acg_kobj);
 
-	rc = wait_for_completion_timeout(&acg->acg_kobj_release_cmpl, HZ);
-	if (rc == 0) {
-		PRINT_INFO("Waiting for releasing sysfs entry "
-			"for acg %s (%d refs)...", acg->acg_name,
-			atomic_read(&acg->acg_kobj.kref.refcount));
-		wait_for_completion(&acg->acg_kobj_release_cmpl);
-		PRINT_INFO("Done waiting for releasing sysfs "
-			"entry for acg %s", acg->acg_name);
-	}
+	/* acg can be dead here! */
+
+	wait_for_completion(&cmpl);
 	return;
 }
 
+/*
+ * Upon return, including with an error, if acg_kobj_initialized set
+ * scst_acg_sysfs_del_free() must be called to free acg instead of
+ * __scst_free_acg()!
+ */
 int scst_acg_sysfs_create(struct scst_tgt *tgt,
 	struct scst_acg *acg)
 {
@@ -3382,8 +3407,6 @@ int scst_acg_sysfs_create(struct scst_tg
 
-	init_completion(&acg->acg_kobj_release_cmpl);
-
 	res = kobject_init_and_add(&acg->acg_kobj, &acg_ktype,
 		tgt->tgt_ini_grp_kobj, acg->acg_name);
 	if (res != 0) {
@@ -3391,19 +3414,21 @@ int scst_acg_sysfs_create(struct scst_tg
 		goto out;
 	}
 
+	acg->acg_kobj_initialized = 1;
+
 	acg->luns_kobj = kobject_create_and_add("luns", &acg->acg_kobj);
 	if (acg->luns_kobj == NULL) {
 		PRINT_ERROR("Can't create luns kobj for tgt %s",
 			tgt->tgt_name);
 		res = -ENOMEM;
-		goto out_del;
+		goto out;
 	}
 
 	res = sysfs_create_file(acg->luns_kobj, &scst_acg_luns_mgmt.attr);
 	if (res != 0) {
 		PRINT_ERROR("Can't add tgt attr %s for tgt %s",
 			scst_acg_luns_mgmt.attr.name, tgt->tgt_name);
-		goto out_del;
+		goto out;
 	}
 
 	acg->initiators_kobj = kobject_create_and_add("initiators",
@@ -3412,7 +3437,7 @@ int scst_acg_sysfs_create(struct scst_tg
 		PRINT_ERROR("Can't create initiators kobj for tgt %s",
 			tgt->tgt_name);
 		res = -ENOMEM;
-		goto out_del;
+		goto out;
 	}
 
 	res = sysfs_create_file(acg->initiators_kobj,
@@ -3420,37 +3445,33 @@ int scst_acg_sysfs_create(struct scst_tg
 	if (res != 0) {
 		PRINT_ERROR("Can't add tgt attr %s for tgt %s",
 			scst_acg_ini_mgmt.attr.name, tgt->tgt_name);
-		goto out_del;
+		goto out;
 	}
 
 	res = sysfs_create_file(&acg->acg_kobj, &scst_acg_addr_method.attr);
 	if (res != 0) {
 		PRINT_ERROR("Can't add tgt attr %s for tgt %s",
 			scst_acg_addr_method.attr.name, tgt->tgt_name);
-		goto out_del;
+		goto out;
 	}
 
 	res = sysfs_create_file(&acg->acg_kobj, &scst_acg_io_grouping_type.attr);
 	if (res != 0) {
 		PRINT_ERROR("Can't add tgt attr %s for tgt %s",
 			scst_acg_io_grouping_type.attr.name, tgt->tgt_name);
-		goto out_del;
+		goto out;
 	}
 
 	res = sysfs_create_file(&acg->acg_kobj, &scst_acg_cpu_mask.attr);
 	if (res != 0) {
 		PRINT_ERROR("Can't add tgt attr %s for tgt %s",
 			scst_acg_cpu_mask.attr.name, tgt->tgt_name);
-		goto out_del;
+		goto out;
 	}
 
 out:
 	return res;
-
-out_del:
-	scst_acg_sysfs_del(acg);
-	goto out;
 }
 
 static ssize_t scst_acg_addr_method_show(struct kobject *kobj,
