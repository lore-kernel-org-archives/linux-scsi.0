From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 15:42:19 -0800
Message-ID: <20050119234219.GA6294@kroah.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com> <20050119213924.GG5508@us.ibm.com> <20050119224016.GA5086@kroah.com> <20050119230350.GA23553@infradead.org> <20050119230855.GA5646@kroah.com> <20050119231559.GA10404@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:25596 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261986AbVASXm0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 18:42:26 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0JNgNCO575464
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 18:42:23 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0JNgNjI319482
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 16:42:23 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0JNgM2i004644
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 16:42:22 -0700
Content-Disposition: inline
In-Reply-To: <20050119231559.GA10404@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Christoph Hellwig <hch@infradead.org>, jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, Jan 19, 2005 at 05:15:59PM -0600, Matt Domsch wrote:
> On Wed, Jan 19, 2005 at 03:08:55PM -0800, Greg KH wrote:
> > On Wed, Jan 19, 2005 at 11:03:50PM +0000, Christoph Hellwig wrote:
> > > On Wed, Jan 19, 2005 at 02:40:16PM -0800, Greg KH wrote:
> > > > I had a patch to do that around here somewhere, but I think it was
> > > > rejected as people can get the same info by using 'modinfo' instead.
> > > > You know, the old, "use a userspace tool instead of wasting kernel
> > > > memory" argument :)
> > > 
> > > How's that supposed to work for builtin drivers?
> > 
> > Oh wait.  I get your point.  Hm, I don't know.  Want me to dig up the
> > patch?
> 
> Yes, DKMS would like to use that too.

Here it was against 2.6.9.  Odds are it doesn't apply anymore due to
some recent changes in this area.  If anyone wants to take it and fix it
up, please do so.

Note, this patch needs the evil strdup() function to work properly.
That's one of the main reasons I decided to not submit it to the main
kernel tree...

thanks,

greg k-h

------------
Module:  Add module author, version and license to the sysfs tree

Signed-off-by: Greg Kroah-Hartman <greg@kroah.com>

diff -Nru a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h	2004-10-20 10:16:28 -07:00
+++ b/include/linux/module.h	2004-10-20 10:16:28 -07:00
@@ -308,6 +308,12 @@
 	/* Fake kernel param for refcnt. */
 	struct kernel_param refcnt_param;
 #endif
+	struct kernel_param author_param;
+	struct kernel_param version_param;
+	struct kernel_param license_param;
+	char *author;
+	char *version;
+	char *license;
 
 #ifdef CONFIG_KALLSYMS
 	/* We keep the symbol and string tables for kallsyms. */
diff -Nru a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c	2004-10-20 10:16:28 -07:00
+++ b/kernel/module.c	2004-10-20 10:16:28 -07:00
@@ -1094,6 +1094,25 @@
 	.store = module_attr_store,
 };
 
+#define MOD_SYSFS(field)	\
+static int field##_get_fn(char *buffer, struct kernel_param *kp)		\
+{										\
+	struct module *mod = container_of(kp, struct module, field##_param);	\
+	return sprintf(buffer, "%s", mod->field);				\
+}										\
+static int sysfs_##field##_setup(struct module *mod)				\
+{										\
+	if (!mod->field)							\
+		return 0;							\
+	mod->field##_param.name = __stringify(field);				\
+	mod->field##_param.perm = 0444;						\
+	mod->field##_param.get = field##_get_fn;				\
+	return add_attribute(mod, &mod->field##_param);				\
+}
+MOD_SYSFS(author);
+MOD_SYSFS(version);
+MOD_SYSFS(license);
+
 static void module_kobj_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct module_kobject, kobj));
@@ -1114,7 +1133,7 @@
 
 	/* We overallocate: not every param is in sysfs, and maybe no refcnt */
 	mod->mkobj = kmalloc(sizeof(*mod->mkobj)
-			     + sizeof(mod->mkobj->attr[0]) * (num_params+1),
+			     + sizeof(mod->mkobj->attr[0]) * (num_params+4),
 			     GFP_KERNEL);
 	if (!mod->mkobj)
 		return -ENOMEM;
@@ -1140,6 +1159,15 @@
 	err = sysfs_unload_setup(mod);
 	if (err)
 		goto out_unreg;
+	err = sysfs_author_setup(mod);
+	if (err)
+		goto out_unreg;
+	err = sysfs_version_setup(mod);
+	if (err)
+		goto out_unreg;
+	err = sysfs_license_setup(mod);
+	if (err)
+		goto out_unreg;
 	return 0;
 
 out_unreg:
@@ -1160,6 +1188,9 @@
 		sysfs_remove_file(&mod->mkobj->kobj,&mod->mkobj->attr[i].attr);
 	/* Calls module_kobj_release */
 	kobject_unregister(&mod->mkobj->kobj);
+	kfree(mod->author);
+	kfree(mod->license);
+	kfree(mod->version);
 }
 
 /* Free a module, remove from lists, etc (must hold module mutex). */
@@ -1346,11 +1377,25 @@
 		|| strcmp(license, "Dual MPL/GPL") == 0);
 }
 
+static char *strdup(const char *str)
+{
+	char *s;
+
+	if (!str)
+		return NULL;
+	s = kmalloc(strlen(str)+1, GFP_KERNEL);
+	if (!s)
+		return NULL;
+	strcpy(s, str);
+	return s;
+}
+
 static void set_license(struct module *mod, const char *license)
 {
 	if (!license)
 		license = "unspecified";
 
+	mod->license = strdup(license);
 	mod->license_gplok = license_is_gpl_compatible(license);
 	if (!mod->license_gplok && !(tainted & TAINT_PROPRIETARY_MODULE)) {
 		printk(KERN_WARNING "%s: module license '%s' taints kernel.\n",
@@ -1696,6 +1741,9 @@
 
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
+
+	mod->author = strdup(get_modinfo(sechdrs, infoindex, "author"));
+	mod->version = strdup(get_modinfo(sechdrs, infoindex, "version"));
 
 	/* Fix up syms, so that st_value is a pointer to location. */
 	err = simplify_symbols(sechdrs, symindex, strtab, versindex, pcpuindex,
