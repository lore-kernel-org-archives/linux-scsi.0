From: "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Tue, 30 Oct 2007 20:40:11 -0400
Message-ID: <20071031004011.GA8309@jupiter.solarsys.private>
References: <1193671019.3383.13.camel@localhost.localdomain> <1193676852.2655.21.camel@lov.site> <1193677071.3383.56.camel@localhost.localdomain> <47261F50.3050901@s5r6.in-berlin.de> <1193768743.3321.91.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759562AbXJaAkl@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193768743.3321.91.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi James:

* James Bottomley <James.Bottomley@SteelEye.com> [2007-10-30 13:25:43 -0500]:
> On Mon, 2007-10-29 at 18:58 +0100, Stefan Richter wrote:
> > James Bottomley wrote:
> > >> >  struct attribute_group {
> > >> >  	const char		*name;
> > >> > +	int			(*filter_show)(struct kobject *, int);
> > 
> > > Actually, it returns a true/false value indicating whether the given
> > > attribute should be displayed.
> > 
> > How about this:
> > 
> > 	int (*is_visible)(...);
> 
> OK, so is this latest revision acceptable to everyone?

I've just been hacking around in this area a bit, for a completely different
reason: there are literally 1000's of attributes in drivers/hwmon/*.c that
really want to be const, but which cannot be due to the current API.  I was
about to propose some patches that move in a different direction...

> Index: BUILD-2.6/fs/sysfs/group.c
> ===================================================================
> --- BUILD-2.6.orig/fs/sysfs/group.c	2007-10-28 17:27:04.000000000 -0500
> +++ BUILD-2.6/fs/sysfs/group.c	2007-10-30 12:35:47.000000000 -0500
> @@ -16,25 +16,31 @@
>  #include "sysfs.h"
>  
>  
> -static void remove_files(struct sysfs_dirent *dir_sd,
> +static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>  			 const struct attribute_group *grp)
>  {
>  	struct attribute *const* attr;
> +	int i;
>  
> -	for (attr = grp->attrs; *attr; attr++)
> -		sysfs_hash_and_remove(dir_sd, (*attr)->name);
> +	for (i = 0, attr = grp->attrs; *attr; i++, attr++)
> +		if (grp->is_visible &&
> +		    grp->is_visible(kobj, *attr, i))
> +			sysfs_hash_and_remove(dir_sd, (*attr)->name);
>  }
>  
> -static int create_files(struct sysfs_dirent *dir_sd,
> +static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>  			const struct attribute_group *grp)
>  {
>  	struct attribute *const* attr;
> -	int error = 0;
> +	int error = 0, i;
>  
> -	for (attr = grp->attrs; *attr && !error; attr++)
> -		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
> +	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++)
> +		if (grp->is_visible &&
> +		    grp->is_visible(kobj, *attr, i))
> +			error |=
> +				sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
>  	if (error)
> -		remove_files(dir_sd, grp);
> +		remove_files(dir_sd, kobj, grp);
>  	return error;
>  }
>  
> @@ -54,7 +60,7 @@ int sysfs_create_group(struct kobject * 
>  	} else
>  		sd = kobj->sd;
>  	sysfs_get(sd);
> -	error = create_files(sd, grp);
> +	error = create_files(sd, kobj, grp);
>  	if (error) {
>  		if (grp->name)
>  			sysfs_remove_subdir(sd);
> @@ -75,7 +81,7 @@ void sysfs_remove_group(struct kobject *
>  	} else
>  		sd = sysfs_get(dir_sd);
>  
> -	remove_files(sd, grp);
> +	remove_files(sd, kobj, grp);
>  	if (grp->name)
>  		sysfs_remove_subdir(sd);
>  
> Index: BUILD-2.6/include/linux/sysfs.h
> ===================================================================
> --- BUILD-2.6.orig/include/linux/sysfs.h	2007-10-28 17:20:06.000000000 -0500
> +++ BUILD-2.6/include/linux/sysfs.h	2007-10-30 13:24:06.000000000 -0500
> @@ -32,6 +32,8 @@ struct attribute {
>  
>  struct attribute_group {
>  	const char		*name;
> +	int			(*is_visible)(struct kobject *,
> +					      struct attribute *, int);
>  	struct attribute	**attrs;
>  };

IMHO the fundamental problem is struct attribute_group itself.  This structure
is nothing but a convenience for packaging the arguments to sysfs_create_group
and sysfs_remove_group.  Those functions should take the contents of that
struct as direct arguments.  I haven't finished the patch series to implement
this, but since I noticed your patch I thought I'd better speak up now.  Here's
the first... the idea is to eventually deprecate sysfs_[create|remove]_group()
altogether.

commit 5b5bc08ae31519b7012d7fc23ff73e0c6474de53
Author: Mark M. Hoffman <mhoffman@lightlink.com>
Date:   Sun Oct 21 11:49:57 2007 -0400

    sysfs: allow attribute (group) lists to be const
    
    The current declaration of struct attribute_group prevents long lists of
    attributes from being marked const.  Ideally, the second argument to the
    sysfs_create_group() and sysfs_remove_group() functions would be marked "deep"
    const, but C has no such construct.  This patch provides a parallel set of
    functions with the desired decoration.
    
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index d197237..b217a8e 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -17,71 +17,84 @@
 
 
 static void remove_files(struct sysfs_dirent *dir_sd,
-			 const struct attribute_group *grp)
+			 const struct attribute * const * attrs)
 {
-	struct attribute *const* attr;
+	const struct attribute *const* attr;
 
-	for (attr = grp->attrs; *attr; attr++)
+	for (attr = attrs; *attr; attr++)
 		sysfs_hash_and_remove(dir_sd, (*attr)->name);
 }
 
 static int create_files(struct sysfs_dirent *dir_sd,
-			const struct attribute_group *grp)
+			const struct attribute * const * attrs)
 {
-	struct attribute *const* attr;
+	const struct attribute *const* attr;
 	int error = 0;
 
-	for (attr = grp->attrs; *attr && !error; attr++)
+	for (attr = attrs; *attr && !error; attr++)
 		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
 	if (error)
-		remove_files(dir_sd, grp);
+		remove_files(dir_sd, attrs);
 	return error;
 }
 
-
-int sysfs_create_group(struct kobject * kobj, 
-		       const struct attribute_group * grp)
+int sysfs_create_attr_group(struct kobject * kobj,
+		const char *name, const struct attribute * const * attrs)
 {
 	struct sysfs_dirent *sd;
 	int error;
 
 	BUG_ON(!kobj || !kobj->sd);
 
-	if (grp->name) {
-		error = sysfs_create_subdir(kobj, grp->name, &sd);
+	if (name) {
+		error = sysfs_create_subdir(kobj, name, &sd);
 		if (error)
 			return error;
 	} else
 		sd = kobj->sd;
 	sysfs_get(sd);
-	error = create_files(sd, grp);
-	if (error) {
-		if (grp->name)
-			sysfs_remove_subdir(sd);
-	}
+	error = create_files(sd, attrs);
+	if (error && name)
+		sysfs_remove_subdir(sd);
+
 	sysfs_put(sd);
 	return error;
 }
 
-void sysfs_remove_group(struct kobject * kobj, 
-			const struct attribute_group * grp)
+int sysfs_create_group (struct kobject * kobj,
+	const struct attribute_group *grp)
+{
+	return sysfs_create_attr_group(kobj, grp->name,
+			(const struct attribute * const *)grp->attrs);
+}
+
+void sysfs_remove_attr_group(struct kobject * kobj,
+		const char *name, const struct attribute * const * attrs)
 {
 	struct sysfs_dirent *dir_sd = kobj->sd;
 	struct sysfs_dirent *sd;
 
-	if (grp->name) {
-		sd = sysfs_get_dirent(dir_sd, grp->name);
+	if (name) {
+		sd = sysfs_get_dirent(dir_sd, name);
 		BUG_ON(!sd);
 	} else
 		sd = sysfs_get(dir_sd);
 
-	remove_files(sd, grp);
-	if (grp->name)
+	remove_files(sd, attrs);
+	if (name)
 		sysfs_remove_subdir(sd);
 
 	sysfs_put(sd);
 }
 
+void sysfs_remove_group(struct kobject *kobj,
+			const struct attribute_group *grp)
+{
+	return sysfs_remove_attr_group(kobj, grp->name,
+			(const struct attribute * const *)grp->attrs);
+}
 
+EXPORT_SYMBOL_GPL(sysfs_create_attr_group);
+EXPORT_SYMBOL_GPL(sysfs_remove_attr_group);
 EXPORT_SYMBOL_GPL(sysfs_create_group);
 EXPORT_SYMBOL_GPL(sysfs_remove_group);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 149ab62..5066d50 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -101,10 +101,18 @@ int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
 				   const char *name);
 void sysfs_remove_link(struct kobject *kobj, const char *name);
 
+int __must_check sysfs_create_attr_group(struct kobject *,
+			const char * name, const struct attribute * const * attrs);
+
 int __must_check sysfs_create_group(struct kobject *kobj,
-				    const struct attribute_group *grp);
+					const struct attribute_group *grp);
+
+void sysfs_remove_attr_group(struct kobject *,
+			const char * name, const struct attribute * const * attrs);
+
 void sysfs_remove_group(struct kobject *kobj,
-			const struct attribute_group *grp);
+					const struct attribute_group *grp);
+
 int sysfs_add_file_to_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 void sysfs_remove_file_from_group(struct kobject *kobj,
@@ -190,8 +198,19 @@ static inline int sysfs_create_group(struct kobject *kobj,
 	return 0;
 }
 
-static inline void sysfs_remove_group(struct kobject *kobj,
-				      const struct attribute_group *grp)
+static inline int sysfs_create_attr_group(struct kobject *k,
+			const char * name, const struct attribute * const * attrs)
+{
+	return 0;
+}
+
+static inline void sysfs_remove_group(struct kobject * k, const struct attribute_group * g)
+{
+	;
+}
+
+static inline void sysfs_remove_attr_group(struct kobject * k,
+			const char * name, const struct attribute * const * attrs)
 {
 	;
 }

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com
