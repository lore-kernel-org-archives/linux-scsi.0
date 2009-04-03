From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [ConfigFS]: Add struct
	configfs_item_operations->check_link()
Date: Fri, 03 Apr 2009 03:47:56 -0700
Message-ID: <1238755676.4250.459.camel@haakon2.linux-iscsi.org>
References: <1238747107.4250.448.camel@haakon2.linux-iscsi.org>
	 <20090403095128.GE32106@hawkmoon.kerlabs.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.206.147]:29490 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756815AbZDCKsL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 06:48:11 -0400
In-Reply-To: <20090403095128.GE32106@hawkmoon.kerlabs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Louis.Rilling@kerlabs.com
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

On Fri, 2009-04-03 at 11:51 +0200, Louis Rilling wrote:
> Hi,
> 
> On 03/04/09  1:25 -0700, Nicholas A. Bellinger wrote:
> > Hi Joel and co,
> > 
> > This patch adds struct configfs_item_operations->check_link() and
> > changes fs/configfs/symlink.c:configfs_unlink() so that
> > when (*check_link) is present, an ConfigFS unlink will fail, based upon
> > input by said symlinked struct config_item *parent_item.
> > 
> > If a non zero return is returned from (*check_link), said non zero value is
> > expected to use include/asm-generic/errno* values, and the failure is returned
> > to userspace via the unlink(2) system call.
> > 
> > Please consider this patch for v2.6.30.  It requires no changes to existing consumers
> > of ConfigFS like fs/ocfs2, and I have tested it with running LIO-Target v3.0 code.
> > 
> > Many thanks for your most valuable of time,
> 
> I can't judge the actual need for that since I don't really know your usecase
> (I've seen the second patch). However check_link() without target_item as
> parameter looks a bit restrictive for no valuable reason.
> 
> See inline for a concern about the error returned.
> Other than that, the patch looks ok.
> 
> Louis
> 
> > 
> > --nab
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  fs/configfs/symlink.c    |   13 +++++++++++++
> >  include/linux/configfs.h |    1 +
> >  2 files changed, 14 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
> > index 932a92b..a5dede6 100644
> > --- a/fs/configfs/symlink.c
> > +++ b/fs/configfs/symlink.c
> > @@ -202,6 +202,19 @@ int configfs_unlink(struct inode *dir, struct dentry *dentry)
> >  	parent_item = configfs_get_config_item(dentry->d_parent);
> >  	type = parent_item->ci_type;
> >  
> > +	/*
> > +	 * See if the underlying struct config_item has dependent
> > +	 * symlinks, and should return -EACCES here.
> > +	 */
> 
> I think that -EPERM is more natural than -EACCES. check_link() actually checks
> that the operation is permitted.
> 

Greeings Louis,

Makes sense to me. :-)   Here is the updated commit for lio-core-2.6.git
to return the default -EPERM from (*check_link), regardless of the
non-zero return from the calling struct configfs_item_opreations.  It
also adds the 2nd parameter of type struct config_item for underlying
ConfigFS consumer usage.

Thank you for your comments!

Many thanks for your most valuable of time,

--nab

>From 60309f152155c1382b2340bc87af200720b864b9 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 3 Apr 2009 03:36:11 -0700
Subject: [PATCH] [ConfigFS]: Add (*check_link) parameter and use -EPERM

This patch updates struct configfs_item_operations->check_link() to
use the 2nd parameter "struct config_item *target".  It also
updates the fs/configfs/symlink.c:configfs_unlink() caller for
(*check_link) to look for a strict non-zero return, and return the default
-EPERM from a local scope variable in configfs_unlink().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 fs/configfs/symlink.c    |    4 ++--
 include/linux/configfs.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index a5dede6..6c7db67 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -208,8 +208,8 @@ int configfs_unlink(struct inode *dir, struct dentry *dentry)
 	 */
 	if (type && type->ct_item_ops &&
 	    type->ct_item_ops->check_link) {
-		ret = type->ct_item_ops->check_link(parent_item);
-		if (ret != 0) {
+		if (type->ct_item_ops->check_link(parent_item,
+					sl->sl_target) != 0) {
 			config_item_put(parent_item);
 			goto out;
 		}
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index b026f16..fc072ce 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -226,7 +226,7 @@ struct configfs_item_operations {
 	ssize_t	(*show_attribute)(struct config_item *, struct configfs_attribute *,char *);
 	ssize_t	(*store_attribute)(struct config_item *,struct configfs_attribute *,const char *, size_t);
 	int (*allow_link)(struct config_item *src, struct config_item *target);
-	int (*check_link)(struct config_item *src);
+	int (*check_link)(struct config_item *src, struct config_item *target);
 	int (*drop_link)(struct config_item *src, struct config_item *target);
 };
 
-- 
1.5.4.1




