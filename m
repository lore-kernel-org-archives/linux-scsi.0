From: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Subject: [PATCH][SCST]: Implementation of subdirectories sessions, luns, ini_group
 inside targets/<target_name>/target/.
Date: Fri, 15 May 2009 18:41:24 -0300
Message-ID: <4A0DE184.4010603@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:54245 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZEOVl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 17:41:29 -0400
Received: from mailhub1.br.ibm.com (mailhub1.br.ibm.com [9.18.232.109])
	by e24smtp03.br.ibm.com (8.13.1/8.13.1) with ESMTP id n4FLehlC019603
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2009 18:40:43 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.18.232.47])
	by mailhub1.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4FLfm4s1405152
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2009 18:41:49 -0300
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4FLfP8M031303
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2009 18:41:25 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch implements the creation of the subdirectories sessions, luns, ini_group
inside targets/<target_name>/target/.

Also it makes some changes on scst_unregister since the scst_tgt can't just be
kfreed as long as it has a kobject embedded on it. Resuming, the scst_unregister
call kobject_put and on the kobject release functions there is a call to scst_release
(which is the same as scst_unregister was).

Signed-off-by: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Index: scst/include/scst.h
===================================================================
--- scst/include/scst.h	(revision 851)
+++ scst/include/scst.h	(working copy)
@@ -961,7 +961,10 @@ struct scst_tgt {
  	/* Name on the default security group ("Default_target_name") */
  	char *default_group_name;

-	struct kobject *tgt_kobj; /* kobject for this struct. */
+	struct kobject tgt_kobj; /* main kobject for this struct. */
+	struct kobject *tgt_sess_kobj;
+	struct kobject *tgt_luns_kobj;
+	struct kobject *tgt_ini_grp_kobj;
  };

  /* Hash size and hash fn for hash based lun translation */
Index: scst/src/scst_main.c
===================================================================
--- scst/src/scst_main.c	(revision 851)
+++ scst/src/scst_main.c	(working copy)
@@ -375,6 +375,10 @@ struct scst_tgt *scst_register(struct sc
  	mutex_unlock(&scst_mutex);
  	scst_resume_activity();

+	rc = scst_create_tgt_child_kobjs(tgt);
+	if (rc < 0)
+		goto out_child_kobjs_err;
+
  	PRINT_INFO("Target %s (%p) for template %s registered successfully",
  		target_name, tgt, vtt->name);

@@ -382,6 +386,11 @@ out:
  	TRACE_EXIT();
  	return tgt;

+out_child_kobjs_err:
+	scst_destroy_tgt_kobj(tgt);
+	TRACE_EXIT();
+	return NULL;
+
  out_kobj_err:
  	scst_cleanup_proc_target_entries(tgt);

@@ -416,6 +425,13 @@ static inline int test_sess_list(struct

  void scst_unregister(struct scst_tgt *tgt)
  {
+	scst_destroy_tgt_child_kobjs(tgt);
+	scst_destroy_tgt_kobj(tgt);
+}
+EXPORT_SYMBOL(scst_unregister);
+
+void scst_release(struct scst_tgt *tgt)
+{
  	struct scst_session *sess;
  	struct scst_tgt_template *vtt = tgt->tgtt;

@@ -452,7 +468,6 @@ again:
  	list_del(&tgt->tgt_list_entry);

  	scst_cleanup_proc_target_entries(tgt);
-	scst_destroy_tgt_kobj(tgt);

  	kfree(tgt->default_group_name);

@@ -468,8 +483,8 @@ again:

  	TRACE_EXIT();
  	return;
+
  }
-EXPORT_SYMBOL(scst_unregister);

  static int scst_susp_wait(bool interruptible)
  {
Index: scst/src/scst_priv.h
===================================================================
--- scst/src/scst_priv.h	(revision 851)
+++ scst/src/scst_priv.h	(working copy)
@@ -390,6 +390,12 @@ int scst_create_tgtt_kobj(struct scst_tg
  void scst_destroy_tgtt_kobj(struct scst_tgt_template *vtt);
  int scst_create_tgt_kobj(struct scst_tgt *tgt);
  void scst_destroy_tgt_kobj(struct scst_tgt *tgt);
+int scst_create_tgt_child_kobjs(struct scst_tgt *tgt);
+void scst_destroy_tgt_child_kobjs(struct scst_tgt *tgt);
+
+/* kobjects release functions */
+/*releases the scst_tgt sent to scst_unregister */
+void scst_release(struct scst_tgt *tgt);

  int scst_get_cdb_len(const uint8_t *cdb);

Index: scst/src/scst_sysfs.c
===================================================================
--- scst/src/scst_sysfs.c	(revision 851)
+++ scst/src/scst_sysfs.c	(working copy)
@@ -43,16 +43,31 @@ void scst_destroy_tgtt_kobj(struct scst_
  	kobject_put(vtt->tgtt_kobj);
  }

+void scst_tgt_release(struct kobject *kobj)
+{
+	struct scst_tgt *tgt;
+
+	TRACE_ENTRY();
+
+	tgt = container_of(kobj, struct scst_tgt, tgt_kobj);
+	scst_release(tgt);
+
+	TRACE_EXIT();
+}
+
+struct kobj_type tgt_ktype = {
+	.release = scst_tgt_release,
+};
+
  int scst_create_tgt_kobj(struct scst_tgt *tgt)
  {
  	int retval = 0;

  	TRACE_ENTRY();

-	tgt->tgt_kobj = kobject_create_and_add(tgt->default_group_name,
-					       tgt->tgtt->tgtt_kobj);
-	if (!tgt->tgt_kobj)
-		retval = -EINVAL;
+	retval = kobject_init_and_add(&tgt->tgt_kobj, &tgt_ktype,
+				      tgt->tgtt->tgtt_kobj,
+				      tgt->default_group_name);

  	TRACE_EXIT_RES(retval);
  	return retval;
@@ -60,7 +75,50 @@ int scst_create_tgt_kobj(struct scst_tgt

  void scst_destroy_tgt_kobj(struct scst_tgt *tgt)
  {
-	kobject_put(tgt->tgt_kobj);
+	kobject_put(&tgt->tgt_kobj);
+}
+
+int scst_create_tgt_child_kobjs(struct scst_tgt *tgt)
+{
+	int retval = 0;
+
+	TRACE_ENTRY();
+
+	tgt->tgt_sess_kobj = kobject_create_and_add("sessions", &tgt->tgt_kobj);
+	if (!tgt->tgt_sess_kobj) {
+		retval = -EINVAL;
+		goto sess_kobj_err;
+	}
+
+	tgt->tgt_luns_kobj = kobject_create_and_add("luns", &tgt->tgt_kobj);
+	if (!tgt->tgt_luns_kobj) {
+		retval = -EINVAL;
+		goto luns_kobj_err;
+	}
+
+	tgt->tgt_ini_grp_kobj = kobject_create_and_add("ini_group",
+						       &tgt->tgt_kobj);
+	if (!tgt->tgt_ini_grp_kobj) {
+		retval = -EINVAL;
+		goto ini_grp_kobj_err;
+	}
+
+out:
+	TRACE_EXIT_RES(retval);
+	return retval;
+ini_grp_kobj_err:
+	kobject_put(tgt->tgt_luns_kobj);
+luns_kobj_err:
+	kobject_put(tgt->tgt_sess_kobj);
+sess_kobj_err:
+	goto out;
+}
+
+void scst_destroy_tgt_child_kobjs(struct scst_tgt *tgt)
+{
+	kobject_put(tgt->tgt_sess_kobj);
+	kobject_put(tgt->tgt_luns_kobj);
+	kobject_put(tgt->tgt_ini_grp_kobj);
  }

  static ssize_t scst_threads_show(struct kobject *kobj, struct kobj_attribute *attr,
