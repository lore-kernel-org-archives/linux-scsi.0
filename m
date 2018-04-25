From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/40] proc: add a proc_create_reg helper
Date: Wed, 25 Apr 2018 17:47:50 +0200
Message-ID: <20180425154827.32251-4-hch@lst.de>
References: <20180425154827.32251-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180425154827.32251-1-hch@lst.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Common code for creating a regular file.  Factor out of proc_create_data, to
be reused by other functions soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/proc/generic.c  | 44 +++++++++++++++++++++++++-------------------
 fs/proc/internal.h |  2 ++
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index bd8480ff0d35..ab6a321076b8 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -511,33 +511,39 @@ struct proc_dir_entry *proc_create_mount_point(const char *name)
 }
 EXPORT_SYMBOL(proc_create_mount_point);
 
-struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
-					struct proc_dir_entry *parent,
-					const struct file_operations *proc_fops,
-					void *data)
+struct proc_dir_entry *proc_create_reg(const char *name, umode_t mode,
+		struct proc_dir_entry **parent, void *data)
 {
-	struct proc_dir_entry *pde;
+	struct proc_dir_entry *p;
+
 	if ((mode & S_IFMT) == 0)
 		mode |= S_IFREG;
-
-	if (!S_ISREG(mode)) {
-		WARN_ON(1);	/* use proc_mkdir() */
+	if ((mode & S_IALLUGO) == 0)
+		mode |= S_IRUGO;
+	if (WARN_ON_ONCE(!S_ISREG(mode)))
 		return NULL;
+
+	p = __proc_create(parent, name, mode, 1);
+	if (p) {
+		p->proc_iops = &proc_file_inode_operations;
+		p->data = data;
 	}
+	return p;
+}
+
+struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
+		struct proc_dir_entry *parent,
+		const struct file_operations *proc_fops, void *data)
+{
+	struct proc_dir_entry *p;
 
 	BUG_ON(proc_fops == NULL);
 
-	if ((mode & S_IALLUGO) == 0)
-		mode |= S_IRUGO;
-	pde = __proc_create(&parent, name, mode, 1);
-	if (!pde)
-		goto out;
-	pde->proc_fops = proc_fops;
-	pde->data = data;
-	pde->proc_iops = &proc_file_inode_operations;
-	return proc_register(parent, pde);
-out:
-	return NULL;
+	p = proc_create_reg(name, mode, &parent, data);
+	if (!p)
+		return NULL;
+	p->proc_fops = proc_fops;
+	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_data);
  
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 488e67490312..dd1e11400b97 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -162,6 +162,8 @@ extern bool proc_fill_cache(struct file *, struct dir_context *, const char *, i
 /*
  * generic.c
  */
+struct proc_dir_entry *proc_create_reg(const char *name, umode_t mode,
+		struct proc_dir_entry **parent, void *data);
 struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 		struct proc_dir_entry *dp);
 extern struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int);
-- 
2.17.0
