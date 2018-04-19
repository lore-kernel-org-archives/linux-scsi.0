From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/39] ipmi: simplify procfs code
Date: Thu, 19 Apr 2018 14:41:17 +0200
Message-ID: <20180419124140.9309-17-hch@lst.de>
References: <20180419124140.9309-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <20180419124140.9309-1-hch@lst.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/jfs-discussion>,
 <mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
 <mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Corey Minyard <minyard@acm.org>, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Use remove_proc_subtree to remove the whole subtree on cleanup instead
of a hand rolled list of proc entries, unwind the registration loop into
individual calls.  Switch to use proc_create_single to further simplify
the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/char/ipmi/ipmi_msghandler.c | 150 +++++-----------------------
 drivers/char/ipmi/ipmi_si_intf.c    |  47 +--------
 drivers/char/ipmi/ipmi_ssif.c       |  34 +------
 include/linux/ipmi_smi.h            |   8 +-
 4 files changed, 33 insertions(+), 206 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 361148938801..c18db313e4c4 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -247,13 +247,6 @@ struct ipmi_my_addrinfo {
 	unsigned char lun;
 };
 
-#ifdef CONFIG_IPMI_PROC_INTERFACE
-struct ipmi_proc_entry {
-	char                   *name;
-	struct ipmi_proc_entry *next;
-};
-#endif
-
 /*
  * Note that the product id, manufacturer id, guid, and device id are
  * immutable in this structure, so dyn_mutex is not required for
@@ -430,10 +423,6 @@ struct ipmi_smi {
 	void                     *send_info;
 
 #ifdef CONFIG_IPMI_PROC_INTERFACE
-	/* A list of proc entries for this interface. */
-	struct mutex           proc_entry_lock;
-	struct ipmi_proc_entry *proc_entries;
-
 	struct proc_dir_entry *proc_dir;
 	char                  proc_dir_name[10];
 #endif
@@ -2358,18 +2347,6 @@ static int smi_ipmb_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int smi_ipmb_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, smi_ipmb_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations smi_ipmb_proc_ops = {
-	.open		= smi_ipmb_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int smi_version_proc_show(struct seq_file *m, void *v)
 {
 	ipmi_smi_t intf = m->private;
@@ -2387,18 +2364,6 @@ static int smi_version_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int smi_version_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, smi_version_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations smi_version_proc_ops = {
-	.open		= smi_version_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int smi_stats_proc_show(struct seq_file *m, void *v)
 {
 	ipmi_smi_t intf = m->private;
@@ -2462,95 +2427,45 @@ static int smi_stats_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int smi_stats_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, smi_stats_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations smi_stats_proc_ops = {
-	.open		= smi_stats_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
-			    const struct file_operations *proc_ops,
-			    void *data)
+		int (*show)(struct seq_file *, void *), void *data)
 {
-	int                    rv = 0;
-	struct proc_dir_entry  *file;
-	struct ipmi_proc_entry *entry;
-
-	/* Create a list element. */
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
+	if (!proc_create_single_data(name, 0, smi->proc_dir, show, data))
 		return -ENOMEM;
-	entry->name = kstrdup(name, GFP_KERNEL);
-	if (!entry->name) {
-		kfree(entry);
-		return -ENOMEM;
-	}
-
-	file = proc_create_data(name, 0, smi->proc_dir, proc_ops, data);
-	if (!file) {
-		kfree(entry->name);
-		kfree(entry);
-		rv = -ENOMEM;
-	} else {
-		mutex_lock(&smi->proc_entry_lock);
-		/* Stick it on the list. */
-		entry->next = smi->proc_entries;
-		smi->proc_entries = entry;
-		mutex_unlock(&smi->proc_entry_lock);
-	}
-
-	return rv;
+	return 0;
 }
 EXPORT_SYMBOL(ipmi_smi_add_proc_entry);
 
 static int add_proc_entries(ipmi_smi_t smi, int num)
 {
-	int rv = 0;
-
 	sprintf(smi->proc_dir_name, "%d", num);
 	smi->proc_dir = proc_mkdir(smi->proc_dir_name, proc_ipmi_root);
 	if (!smi->proc_dir)
-		rv = -ENOMEM;
-
-	if (rv == 0)
-		rv = ipmi_smi_add_proc_entry(smi, "stats",
-					     &smi_stats_proc_ops,
-					     smi);
-
-	if (rv == 0)
-		rv = ipmi_smi_add_proc_entry(smi, "ipmb",
-					     &smi_ipmb_proc_ops,
-					     smi);
-
-	if (rv == 0)
-		rv = ipmi_smi_add_proc_entry(smi, "version",
-					     &smi_version_proc_ops,
-					     smi);
-
-	return rv;
+		return -ENOMEM;
+	if (!proc_create_single_data("stats", 0, smi->proc_dir,
+			smi_stats_proc_show, smi))
+		return -ENOMEM;
+	if (!proc_create_single_data("ipmb", 0, smi->proc_dir,
+			smi_ipmb_proc_show, smi))
+		return -ENOMEM;
+	if (!proc_create_single_data("version", 0, smi->proc_dir,
+			smi_version_proc_show, smi))
+		return -ENOMEM;
+	return 0;
 }
 
 static void remove_proc_entries(ipmi_smi_t smi)
 {
-	struct ipmi_proc_entry *entry;
-
-	mutex_lock(&smi->proc_entry_lock);
-	while (smi->proc_entries) {
-		entry = smi->proc_entries;
-		smi->proc_entries = entry->next;
-
-		remove_proc_entry(entry->name, smi->proc_dir);
-		kfree(entry->name);
-		kfree(entry);
-	}
-	mutex_unlock(&smi->proc_entry_lock);
-	remove_proc_entry(smi->proc_dir_name, proc_ipmi_root);
+	if (smi->proc_dir)
+		remove_proc_subtree(smi->proc_dir_name, proc_ipmi_root);
+}
+#else
+static int add_proc_entries(ipmi_smi_t smi, int num)
+{
+	return 0;
+}
+static void remove_proc_entries(ipmi_smi_t smi)
+{
 }
 #endif /* CONFIG_IPMI_PROC_INTERFACE */
 
@@ -3386,9 +3301,6 @@ int ipmi_register_smi(const struct ipmi_smi_handlers *handlers,
 		intf->seq_table[j].seqid = 0;
 	}
 	intf->curr_seq = 0;
-#ifdef CONFIG_IPMI_PROC_INTERFACE
-	mutex_init(&intf->proc_entry_lock);
-#endif
 	spin_lock_init(&intf->waiting_rcv_msgs_lock);
 	INIT_LIST_HEAD(&intf->waiting_rcv_msgs);
 	tasklet_init(&intf->recv_tasklet,
@@ -3410,10 +3322,6 @@ int ipmi_register_smi(const struct ipmi_smi_handlers *handlers,
 	for (i = 0; i < IPMI_NUM_STATS; i++)
 		atomic_set(&intf->stats[i], 0);
 
-#ifdef CONFIG_IPMI_PROC_INTERFACE
-	intf->proc_dir = NULL;
-#endif
-
 	mutex_lock(&smi_watchers_mutex);
 	mutex_lock(&ipmi_interfaces_mutex);
 	/* Look for a hole in the numbers. */
@@ -3448,17 +3356,11 @@ int ipmi_register_smi(const struct ipmi_smi_handlers *handlers,
 	if (rv)
 		goto out;
 
-#ifdef CONFIG_IPMI_PROC_INTERFACE
 	rv = add_proc_entries(intf, i);
-#endif
-
  out:
 	if (rv) {
 		ipmi_bmc_unregister(intf);
-#ifdef CONFIG_IPMI_PROC_INTERFACE
-		if (intf->proc_dir)
-			remove_proc_entries(intf);
-#endif
+		remove_proc_entries(intf);
 		intf->handlers = NULL;
 		list_del_rcu(&intf->link);
 		mutex_unlock(&ipmi_interfaces_mutex);
@@ -3563,9 +3465,7 @@ int ipmi_unregister_smi(ipmi_smi_t intf)
 	intf->handlers = NULL;
 	mutex_unlock(&ipmi_interfaces_mutex);
 
-#ifdef CONFIG_IPMI_PROC_INTERFACE
 	remove_proc_entries(intf);
-#endif
 	ipmi_bmc_unregister(intf);
 
 	/*
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index ff870aa91cfe..7acc8cbf8d6f 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1602,18 +1602,6 @@ static int smi_type_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int smi_type_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, smi_type_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations smi_type_proc_ops = {
-	.open		= smi_type_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int smi_si_stats_proc_show(struct seq_file *m, void *v)
 {
 	struct smi_info *smi = m->private;
@@ -1645,18 +1633,6 @@ static int smi_si_stats_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int smi_si_stats_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, smi_si_stats_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations smi_si_stats_proc_ops = {
-	.open		= smi_si_stats_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int smi_params_proc_show(struct seq_file *m, void *v)
 {
 	struct smi_info *smi = m->private;
@@ -1674,18 +1650,6 @@ static int smi_params_proc_show(struct seq_file *m, void *v)
 
 	return 0;
 }
-
-static int smi_params_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, smi_params_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations smi_params_proc_ops = {
-	.open		= smi_params_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 #define IPMI_SI_ATTR(name) \
@@ -2182,10 +2146,8 @@ static int try_smi_init(struct smi_info *new_smi)
 		goto out_err;
 	}
 
-#ifdef CONFIG_IPMI_PROC_INTERFACE
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "type",
-				     &smi_type_proc_ops,
-				     new_smi);
+				     smi_type_proc_show, new_smi);
 	if (rv) {
 		dev_err(new_smi->io.dev,
 			"Unable to create proc entry: %d\n", rv);
@@ -2193,8 +2155,7 @@ static int try_smi_init(struct smi_info *new_smi)
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "si_stats",
-				     &smi_si_stats_proc_ops,
-				     new_smi);
+				     smi_si_stats_proc_show, new_smi);
 	if (rv) {
 		dev_err(new_smi->io.dev,
 			"Unable to create proc entry: %d\n", rv);
@@ -2202,14 +2163,12 @@ static int try_smi_init(struct smi_info *new_smi)
 	}
 
 	rv = ipmi_smi_add_proc_entry(new_smi->intf, "params",
-				     &smi_params_proc_ops,
-				     new_smi);
+				     smi_params_proc_show, new_smi);
 	if (rv) {
 		dev_err(new_smi->io.dev,
 			"Unable to create proc entry: %d\n", rv);
 		goto out_err;
 	}
-#endif
 
 	/* Don't increment till we know we have succeeded. */
 	smi_num++;
diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 35a82f4bfd78..57f6116a17b2 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1349,18 +1349,6 @@ static int smi_type_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int smi_type_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, smi_type_proc_show, inode->i_private);
-}
-
-static const struct file_operations smi_type_proc_ops = {
-	.open		= smi_type_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int smi_stats_proc_show(struct seq_file *m, void *v)
 {
 	struct ssif_info *ssif_info = m->private;
@@ -1393,18 +1381,6 @@ static int smi_stats_proc_show(struct seq_file *m, void *v)
 		   ssif_get_stat(ssif_info, alerts));
 	return 0;
 }
-
-static int smi_stats_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, smi_stats_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations smi_stats_proc_ops = {
-	.open		= smi_stats_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 static int strcmp_nospace(char *s1, char *s2)
@@ -1740,23 +1716,19 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		goto out_remove_attr;
 	}
 
-#ifdef CONFIG_IPMI_PROC_INTERFACE
 	rv = ipmi_smi_add_proc_entry(ssif_info->intf, "type",
-				     &smi_type_proc_ops,
-				     ssif_info);
+				     smi_type_proc_show, ssif_info);
 	if (rv) {
 		pr_err(PFX "Unable to create proc entry: %d\n", rv);
 		goto out_err_unreg;
 	}
 
 	rv = ipmi_smi_add_proc_entry(ssif_info->intf, "ssif_stats",
-				     &smi_stats_proc_ops,
-				     ssif_info);
+				     smi_stats_proc_show, ssif_info);
 	if (rv) {
 		pr_err(PFX "Unable to create proc entry: %d\n", rv);
 		goto out_err_unreg;
 	}
-#endif
 
  out:
 	if (rv) {
@@ -1775,10 +1747,8 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	kfree(resp);
 	return rv;
 
-#ifdef CONFIG_IPMI_PROC_INTERFACE
 out_err_unreg:
 	ipmi_unregister_smi(ssif_info->intf);
-#endif
 
 out_remove_attr:
 	device_remove_group(&ssif_info->client->dev, &ipmi_ssif_dev_attr_group);
diff --git a/include/linux/ipmi_smi.h b/include/linux/ipmi_smi.h
index af457b5a689e..78d9fd480fe8 100644
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -223,12 +223,10 @@ static inline void ipmi_free_smi_msg(struct ipmi_smi_msg *msg)
 }
 
 #ifdef CONFIG_IPMI_PROC_INTERFACE
-/* Allow the lower layer to add things to the proc filesystem
-   directory for this interface.  Note that the entry will
-   automatically be dstroyed when the interface is destroyed. */
 int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
-			    const struct file_operations *proc_ops,
-			    void *data);
+		int (*show)(struct seq_file *, void *), void *data);
+#else
+#define ipmi_smi_add_proc_entry(smi, name, show, data)	0
 #endif
 
 #endif /* __LINUX_IPMI_SMI_H */
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
