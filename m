From: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Subject: [PATCH] scst_sysfs branch: /targets/<target_driver_name> subdirectories
 and /targets/<target_name>/target subdirectory.
Date: Thu, 07 May 2009 19:18:55 -0300
Message-ID: <4A035E4F.9090207@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:38531 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355AbZEGWTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2009 18:19:11 -0400
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by e24smtp03.br.ibm.com (8.13.1/8.13.1) with ESMTP id n47MImxq030695
	for <linux-scsi@vger.kernel.org>; Thu, 7 May 2009 19:18:48 -0300
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.18.232.46])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n47NIKA83948678
	for <linux-scsi@vger.kernel.org>; Thu, 7 May 2009 20:18:20 -0300
Received: from d24av01.br.ibm.com (loopback [127.0.0.1])
	by d24av01.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n47MJ3ep007472
	for <linux-scsi@vger.kernel.org>; Thu, 7 May 2009 19:19:04 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Vlad,

Here comes a patch that adds the target_driver_name subdirectories and
target_name inside them when a target (like iscsi-scst) is added.

Some possible things that may be worth to comment.

  * function names: I am not that good choosing functions name, so if
anyone disagree/don't like them, feel free to comment or suggest.

  * Code duplication: You can see that functions like
scst_create_scst_template_kobj and scst_create_tgt_kobj does almost the
same thing. One possibility I see here is to have an
create_general_kobj(kobj, patent_kobj) function to make it. It would
avoid code to be duplicated but on the other hand the call side would
possibly be less intuitive. Also, It will not be flexible if we need to
make specific things (like create files or links) on the kobject
directory. If anyone has something to tell about it, be my guess.

Regards,
Daniel Debonzi

Index: include/scst.h
===================================================================
--- include/scst.h	(revision 813)
+++ include/scst.h	(working copy)
@@ -757,6 +757,8 @@ struct scst_tgt_template {
  	/* The pointer to the /proc directory entry */
  	struct proc_dir_entry *proc_tgt_root;

+	struct kobject *kobj; /* kobject for this struct. */
+
  	/* Device number in /proc */
  	int proc_dev_num;
  };
@@ -958,6 +960,8 @@ struct scst_tgt {

  	/* Name on the default security group ("Default_target_name") */
  	char *default_group_name;
+
+	struct kobject *kobj; /* kobject for this struct. */
  };

  /* Hash size and hash fn for hash based lun translation */
Index: src/scst_main.c
===================================================================
--- src/scst_main.c	(revision 813)
+++ src/scst_main.c	(working copy)
@@ -206,6 +206,10 @@ int __scst_register_target_template(stru
  		goto out_err;
  	}

+	res = scst_create_scst_template_kobj(vtt);
+	if(res)
+	  goto out_err;
+
  	if (!vtt->no_proc_entry) {
  		res = scst_build_proc_target_dir_entries(vtt);
  		if (res < 0)
@@ -300,6 +304,7 @@ restart:
  out_up:
  	mutex_unlock(&scst_mutex);

+	scst_destroy_scst_template_kobj(vtt);
  	scst_cleanup_proc_target_dir_entries(vtt);

  	TRACE_EXIT();
@@ -360,8 +365,12 @@ struct scst_tgt *scst_register(struct sc
  	rc = scst_build_proc_target_entries(tgt);
  	if (rc < 0)
  		goto out_free_name;
-	else
-		list_add_tail(&tgt->tgt_list_entry, &vtt->tgt_list);
+	
+	rc = scst_create_tgt_kobj(tgt);
+	if (rc < 0)
+		goto out_kobj_err;
+
+	list_add_tail(&tgt->tgt_list_entry, &vtt->tgt_list);

  	mutex_unlock(&scst_mutex);
  	scst_resume_activity();
@@ -373,6 +382,9 @@ out:
  	TRACE_EXIT();
  	return tgt;

+out_kobj_err:
+	scst_cleanup_proc_target_entries(tgt);
+
  out_free_name:
  	kfree(tgt->default_group_name);

@@ -440,6 +452,7 @@ again:
  	list_del(&tgt->tgt_list_entry);

  	scst_cleanup_proc_target_entries(tgt);
+	scst_destroy_scst_tgt_kobj(tgt);

  	kfree(tgt->default_group_name);

Index: src/scst_priv.h
===================================================================
--- src/scst_priv.h	(revision 813)
+++ src/scst_priv.h	(working copy)
@@ -386,6 +386,10 @@ void scst_cleanup_proc_dev_handler_dir_e
  /* sysfs support  */
  int scst_sysfs_init(void);
  void scst_sysfs_cleanup(void);
+int scst_create_scst_template_kobj(struct scst_tgt_template *vtt);
+void scst_destroy_scst_template_kobj(struct scst_tgt_template *vtt);
+int scst_create_tgt_kobj(struct scst_tgt *tgt);
+void scst_destroy_scst_tgt_kobj(struct scst_tgt *tgt);

  int scst_get_cdb_len(const uint8_t *cdb);

Index: src/scst_sysfs.c
===================================================================
--- src/scst_sysfs.c	(revision 813)
+++ src/scst_sysfs.c	(working copy)
@@ -13,16 +13,56 @@

  static DEFINE_MUTEX(scst_sysfs_mutex);

-/* struct kobject *targets; */
-/* struct kobject *devices; */
-/* struct kobject *sgv; */
-/* struct kobject *drivers; */

  struct scst_sysfs_root {
  	struct kobject kobj;
  };

  struct scst_sysfs_root *scst_sysfs_root;
+struct kobject *scst_targets_kobj;
+struct kobject *scst_devices_kobj;
+struct kobject *scst_sgv_kobj;
+struct kobject *scst_back_drivers_kobj;
+
+
+int scst_create_scst_template_kobj(struct scst_tgt_template *vtt)
+{
+	int retval = 0;
+
+	TRACE_ENTRY();
+
+	vtt->kobj = kobject_create_and_add(vtt->name, scst_targets_kobj);
+	if(!vtt->kobj)
+		retval = -EINVAL;
+
+	TRACE_EXIT_RES(retval);
+	return retval; 	
+}
+
+void scst_destroy_scst_template_kobj(struct scst_tgt_template *vtt)
+{
+	kobject_put(vtt->kobj);
+}
+
+int scst_create_tgt_kobj(struct scst_tgt *tgt)
+{
+	int retval = 0;
+
+	TRACE_ENTRY();
+
+	tgt->kobj = kobject_create_and_add(tgt->default_group_name,
+					   tgt->tgtt->kobj);
+	if(!tgt->kobj)
+		retval = - EINVAL;
+
+	TRACE_EXIT_RES(retval);
+	return retval;
+}
+
+void scst_destroy_scst_tgt_kobj(struct scst_tgt *tgt)
+{
+	kobject_put(tgt->kobj);
+}

  static ssize_t scst_threads_show(struct kobject *kobj, struct kobj_attribute *attr,
  				 char *buf)
@@ -37,7 +77,6 @@ static ssize_t scst_threads_show(struct
  	return count;
  }

-
  static ssize_t scst_threads_store(struct kobject *kobj, struct kobj_attribute *attr,
  				  const char *buf, size_t count)
  {
@@ -85,22 +124,22 @@ out:
  	return res;
  }

-
-static ssize_t scst_trace_level_show(struct kobject *kobj, struct kobj_attribute *attr,
+static ssize_t scst_trace_level_show(struct kobject *kobj,
+				     struct kobj_attribute *attr,
  				     char *buf)
  {
  	return sprintf(buf, "stgt show!!\n");
  }

-
-static ssize_t scst_trace_level_store(struct kobject *kobj, struct kobj_attribute *attr,
+static ssize_t scst_trace_level_store(struct kobject *kobj,
+				      struct kobj_attribute *attr,
  				      const char *buf, size_t count)
  {
  	return count;
  }

-
-static ssize_t scst_version_show(struct kobject *kobj, struct kobj_attribute *attr,
+static ssize_t scst_version_show(struct kobject *kobj,
+				 struct kobj_attribute *attr,
  				 char *buf)
  {
  	TRACE_ENTRY();
@@ -156,12 +195,13 @@ static ssize_t scst_version_show(struct

  }

-
  struct kobj_attribute scst_threads_attr =
-	__ATTR(threads, S_IRUGO | S_IWUSR, scst_threads_show, scst_threads_store);
+	__ATTR(threads, S_IRUGO | S_IWUSR, scst_threads_show,
+	       scst_threads_store);

  struct kobj_attribute scst_trace_level_attr =
-	__ATTR(trace_level, S_IRUGO | S_IWUSR, scst_trace_level_show, scst_trace_level_store);
+	__ATTR(trace_level, S_IRUGO | S_IWUSR, scst_trace_level_show,
+	       scst_trace_level_store);


  struct kobj_attribute scst_version_attr =
@@ -221,14 +261,46 @@ int __init scst_sysfs_init(void)
  		goto sysfs_root_error;

  	retval = kobject_init_and_add(&scst_sysfs_root->kobj,
-			&scst_sysfs_root_ktype, NULL, "%s", "scsi_tgt");
+			&scst_sysfs_root_ktype, kernel_kobj, "%s", "scst_tgt");
  	if (retval)
  		goto sysfs_root_kobj_error;

+	scst_targets_kobj = kobject_create_and_add("targets",
+						   &scst_sysfs_root->kobj);
+	if(!scst_targets_kobj)
+		goto targets_kobj_error;
+	
+	scst_devices_kobj = kobject_create_and_add("devices",
+						   &scst_sysfs_root->kobj);
+	if(!scst_devices_kobj)
+		goto devices_kobj_error;
+
+	scst_sgv_kobj = kobject_create_and_add("sgv", &scst_sysfs_root->kobj);
+	if(!scst_sgv_kobj)
+		goto sgv_kobj_error;
+
+	scst_back_drivers_kobj = kobject_create_and_add("back_drivers",
+							&scst_sysfs_root->kobj);
+	if(!scst_back_drivers_kobj)
+		goto back_drivers_kobj_error;
+
+
  out:	
  	TRACE_EXIT_RES(retval);
  	return retval;

+back_drivers_kobj_error:
+	kobject_put(scst_sgv_kobj);
+
+sgv_kobj_error:
+	kobject_put(scst_devices_kobj);
+
+devices_kobj_error:
+	kobject_put(scst_targets_kobj);
+
+targets_kobj_error:
+	kobject_put(&scst_sysfs_root->kobj);
+
  sysfs_root_kobj_error:
  	kfree(scst_sysfs_root);

@@ -241,6 +313,10 @@ void __exit scst_sysfs_cleanup(void)
  {
  	TRACE_ENTRY();

+	kobject_put(scst_sgv_kobj);
+	kobject_put(scst_devices_kobj);
+	kobject_put(scst_targets_kobj);
+	kobject_put(scst_back_drivers_kobj);
  	kobject_put(&scst_sysfs_root->kobj);

  	TRACE_EXIT();
