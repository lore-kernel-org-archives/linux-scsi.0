From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/8] target_core_alua: Referrals configfs integration
Date: Tue, 17 Dec 2013 09:18:50 +0100
Message-ID: <1387268330-121064-9-git-send-email-hare@suse.de>
References: <1387268330-121064-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab3LQISz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Dec 2013 03:18:55 -0500
In-Reply-To: <1387268330-121064-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Referrals need an LBA map, which needs to be kept
consistent across all target port groups. So
instead of tying the map to the target port groups
I've implemented a single attribute containing the
entire map.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c      | 101 +++++++++++++++++++
 drivers/target/target_core_alua.h      |   8 ++
 drivers/target/target_core_configfs.c  | 171 +++++++++++++++++++++++++++++++++
 drivers/target/target_core_device.c    |   1 +
 drivers/target/target_core_transport.c |  28 +++++-
 5 files changed, 308 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index dbfbf14..dc0d399 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1350,6 +1350,107 @@ static int core_alua_set_tg_pt_secondary_state(
 	return 0;
 }
 
+struct t10_alua_lba_map *
+core_alua_allocate_lba_map(struct list_head *list,
+			   u64 first_lba, u64 last_lba)
+{
+	struct t10_alua_lba_map *lba_map;
+
+	lba_map = kmem_cache_zalloc(t10_alua_lba_map_cache, GFP_KERNEL);
+	if (!lba_map) {
+		pr_err("Unable to allocate struct t10_alua_lba_map\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	INIT_LIST_HEAD(&lba_map->lba_map_mem_list);
+	lba_map->lba_map_first_lba = first_lba;
+	lba_map->lba_map_last_lba = last_lba;
+
+	list_add_tail(&lba_map->lba_map_list, list);
+	return lba_map;
+}
+
+int
+core_alua_allocate_lba_map_mem(struct t10_alua_lba_map *lba_map,
+			       int pg_id, int state)
+{
+	struct t10_alua_lba_map_member *lba_map_mem;
+
+	list_for_each_entry(lba_map_mem, &lba_map->lba_map_mem_list,
+			    lba_map_mem_list) {
+		if (lba_map_mem->lba_map_mem_alua_pg_id == pg_id) {
+			pr_err("Duplicate pg_id %d in lba_map\n", pg_id);
+			return -EINVAL;
+		}
+	}
+
+	lba_map_mem = kmem_cache_zalloc(t10_alua_lba_map_mem_cache, GFP_KERNEL);
+	if (!lba_map_mem) {
+		pr_err("Unable to allocate struct t10_alua_lba_map_mem\n");
+		return -ENOMEM;
+	}
+	lba_map_mem->lba_map_mem_alua_state = state;
+	lba_map_mem->lba_map_mem_alua_pg_id = pg_id;
+
+	list_add_tail(&lba_map_mem->lba_map_mem_list,
+		      &lba_map->lba_map_mem_list);
+	return 0;
+}
+
+void
+core_alua_free_lba_map(struct list_head *lba_list)
+{
+	struct t10_alua_lba_map *lba_map, *lba_map_tmp;
+	struct t10_alua_lba_map_member *lba_map_mem, *lba_map_mem_tmp;
+
+	list_for_each_entry_safe(lba_map, lba_map_tmp, lba_list,
+				 lba_map_list) {
+		list_for_each_entry_safe(lba_map_mem, lba_map_mem_tmp,
+					 &lba_map->lba_map_mem_list,
+					 lba_map_mem_list) {
+			list_del(&lba_map_mem->lba_map_mem_list);
+			kmem_cache_free(t10_alua_lba_map_mem_cache,
+					lba_map_mem);
+		}
+		list_del(&lba_map->lba_map_list);
+		kmem_cache_free(t10_alua_lba_map_cache, lba_map);
+	}
+}
+
+void
+core_alua_set_lba_map(struct se_device *dev, struct list_head *lba_map_list,
+		      int segment_size, int segment_mult)
+{
+	struct list_head old_lba_map_list;
+	struct t10_alua_tg_pt_gp *tg_pt_gp;
+	int activate = 0, supported;
+
+	INIT_LIST_HEAD(&old_lba_map_list);
+	spin_lock(&dev->t10_alua.lba_map_lock);
+	dev->t10_alua.lba_map_segment_size = segment_size;
+	dev->t10_alua.lba_map_segment_multiplier = segment_mult;
+	list_splice_init(&dev->t10_alua.lba_map_list, &old_lba_map_list);
+	if (lba_map_list) {
+		list_splice_init(lba_map_list, &dev->t10_alua.lba_map_list);
+		activate = 1;
+	}
+	spin_unlock(&dev->t10_alua.lba_map_lock);
+	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
+	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
+			    tg_pt_gp_list) {
+
+		if (!tg_pt_gp->tg_pt_gp_valid_id)
+			continue;
+		supported = tg_pt_gp->tg_pt_gp_alua_supported_states;
+		if (activate)
+			supported |= ALUA_LBD_SUP;
+		else
+			supported &= ~ALUA_LBD_SUP;
+		tg_pt_gp->tg_pt_gp_alua_supported_states = supported;
+	}
+	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+	core_alua_free_lba_map(&old_lba_map_list);
+}
+
 struct t10_alua_lu_gp *
 core_alua_allocate_lu_gp(const char *name, int def_group)
 {
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index 47950cd..0a7d65e 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -86,6 +86,8 @@ extern struct kmem_cache *t10_alua_lu_gp_cache;
 extern struct kmem_cache *t10_alua_lu_gp_mem_cache;
 extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
 extern struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
+extern struct kmem_cache *t10_alua_lba_map_cache;
+extern struct kmem_cache *t10_alua_lba_map_mem_cache;
 
 extern sense_reason_t target_emulate_report_target_port_groups(struct se_cmd *);
 extern sense_reason_t target_emulate_set_target_port_groups(struct se_cmd *);
@@ -95,6 +97,12 @@ extern int core_alua_do_port_transition(struct t10_alua_tg_pt_gp *,
 				struct se_device *, struct se_port *,
 				struct se_node_acl *, int, int);
 extern char *core_alua_dump_status(int);
+extern struct t10_alua_lba_map *core_alua_allocate_lba_map(
+				struct list_head *, u64, u64);
+extern int core_alua_allocate_lba_map_mem(struct t10_alua_lba_map *, int, int);
+extern void core_alua_free_lba_map(struct list_head *);
+extern void core_alua_set_lba_map(struct se_device *, struct list_head *,
+				int, int);
 extern struct t10_alua_lu_gp *core_alua_allocate_lu_gp(const char *, int);
 extern int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *, u16);
 extern void core_alua_free_lu_gp(struct t10_alua_lu_gp *);
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index e74ef8c..1dbc1bc 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1741,6 +1741,176 @@ static struct target_core_configfs_attribute target_core_attr_dev_alua_lu_gp = {
 	.store	= target_core_store_alua_lu_gp,
 };
 
+static ssize_t target_core_show_dev_lba_map(void *p, char *page)
+{
+	struct se_device *dev = p;
+	struct t10_alua_lba_map *map;
+	struct t10_alua_lba_map_member *mem;
+	char *b = page;
+	int bl = 0;
+	char state;
+
+	spin_lock(&dev->t10_alua.lba_map_lock);
+	if (!list_empty(&dev->t10_alua.lba_map_list))
+	    bl += sprintf(b + bl, "%u %u\n",
+			  dev->t10_alua.lba_map_segment_size,
+			  dev->t10_alua.lba_map_segment_multiplier);
+	list_for_each_entry(map, &dev->t10_alua.lba_map_list, lba_map_list) {
+		bl += sprintf(b + bl, "%llu %llu",
+			      map->lba_map_first_lba, map->lba_map_last_lba);
+		list_for_each_entry(mem, &map->lba_map_mem_list,
+				    lba_map_mem_list) {
+			switch (mem->lba_map_mem_alua_state) {
+			case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
+				state = 'O';
+				break;
+			case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
+				state = 'A';
+				break;
+			case ALUA_ACCESS_STATE_STANDBY:
+				state = 'S';
+				break;
+			case ALUA_ACCESS_STATE_UNAVAILABLE:
+				state = 'U';
+				break;
+			default:
+				state = '.';
+				break;
+			}
+			bl += sprintf(b + bl, " %d:%c",
+				      mem->lba_map_mem_alua_pg_id, state);
+		}
+		bl += sprintf(b + bl, "\n");
+	}
+	spin_unlock(&dev->t10_alua.lba_map_lock);
+	return bl;
+}
+
+static ssize_t target_core_store_dev_lba_map(
+	void *p,
+	const char *page,
+	size_t count)
+{
+	struct se_device *dev = p;
+	struct t10_alua_lba_map *lba_map = NULL;
+	struct list_head lba_list;
+	char *map_entries, *ptr;
+	char state;
+	int pg_num = -1, pg;
+	int ret = 0, num = 0, pg_id, alua_state;
+	unsigned long start_lba = -1, end_lba = -1;
+	unsigned long segment_size = -1, segment_mult = -1;
+
+	map_entries = kstrdup(page, GFP_KERNEL);
+	if (!map_entries)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&lba_list);
+	while ((ptr = strsep(&map_entries, "\n")) != NULL) {
+		if (!*ptr)
+			continue;
+
+		if (num == 0) {
+			if (sscanf(ptr, "%lu %lu\n",
+				   &segment_size, &segment_mult) != 2) {
+				pr_err("Invalid line %d\n", num);
+				ret = -EINVAL;
+				break;
+			}
+			num++;
+			continue;
+		}
+		if (sscanf(ptr, "%lu %lu", &start_lba, &end_lba) != 2) {
+			pr_err("Invalid line %d\n", num);
+			ret = -EINVAL;
+			break;
+		}
+		ptr = strchr(ptr, ' ');
+		if (!ptr) {
+			pr_err("Invalid line %d, missing end lba\n", num);
+			ret = -EINVAL;
+			break;
+		}
+		ptr++;
+		ptr = strchr(ptr, ' ');
+		if (!ptr) {
+			pr_err("Invalid line %d, missing state definitions\n",
+			       num);
+			ret = -EINVAL;
+			break;
+		}
+		ptr++;
+		lba_map = core_alua_allocate_lba_map(&lba_list,
+						     start_lba, end_lba);
+		if (IS_ERR(lba_map)) {
+			ret = PTR_ERR(lba_map);
+			break;
+		}
+		pg = 0;
+		while (sscanf(ptr, "%d:%c", &pg_id, &state) == 2) {
+			switch (state) {
+			case 'O':
+				alua_state = ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED;
+				break;
+			case 'A':
+				alua_state = ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED;
+				break;
+			case 'S':
+				alua_state = ALUA_ACCESS_STATE_STANDBY;
+				break;
+			case 'U':
+				alua_state = ALUA_ACCESS_STATE_UNAVAILABLE;
+				break;
+			default:
+				pr_err("Invalid ALUA state '%c'\n", state);
+				ret = -EINVAL;
+				goto out;
+			}
+
+			ret = core_alua_allocate_lba_map_mem(lba_map,
+							     pg_id, alua_state);
+			if (ret) {
+				pr_err("Invalid target descriptor %d:%c "
+				       "at line %d\n",
+				       pg_id, state, num);
+				break;
+			}
+			pg++;
+			ptr = strchr(ptr, ' ');
+			if (ptr)
+				ptr++;
+			else
+				break;
+		}
+		if (pg_num == -1)
+		    pg_num = pg;
+		else if (pg != pg_num) {
+			pr_err("Only %d from %d port groups definitions "
+			       "at line %d\n", pg, pg_num, num);
+			ret = -EINVAL;
+			break;
+		}
+		num++;
+	}
+out:
+	if (ret) {
+		core_alua_free_lba_map(&lba_list);
+		count = ret;
+	} else
+		core_alua_set_lba_map(dev, &lba_list,
+				      segment_size, segment_mult);
+	kfree(map_entries);
+	return count;
+}
+
+static struct target_core_configfs_attribute target_core_attr_dev_lba_map = {
+	.attr	= { .ca_owner = THIS_MODULE,
+		    .ca_name = "lba_map",
+		    .ca_mode = S_IRUGO | S_IWUSR },
+	.show	= target_core_show_dev_lba_map,
+	.store	= target_core_store_dev_lba_map,
+};
+
 static struct configfs_attribute *lio_core_dev_attrs[] = {
 	&target_core_attr_dev_info.attr,
 	&target_core_attr_dev_control.attr,
@@ -1748,6 +1918,7 @@ static struct configfs_attribute *lio_core_dev_attrs[] = {
 	&target_core_attr_dev_udev_path.attr,
 	&target_core_attr_dev_enable.attr,
 	&target_core_attr_dev_alua_lu_gp.attr,
+	&target_core_attr_dev_lba_map.attr,
 	NULL,
 };
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 3c08f99..376a4d3 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1585,6 +1585,7 @@ void target_free_device(struct se_device *dev)
 	}
 
 	core_alua_free_lu_gp_mem(dev);
+	core_alua_set_lba_map(dev, NULL, 0, 0);
 	core_scsi3_free_all_registrations(dev);
 	se_release_vpd_for_dev(dev);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 91953da..18c828d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -62,6 +62,8 @@ struct kmem_cache *t10_alua_lu_gp_cache;
 struct kmem_cache *t10_alua_lu_gp_mem_cache;
 struct kmem_cache *t10_alua_tg_pt_gp_cache;
 struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
+struct kmem_cache *t10_alua_lba_map_cache;
+struct kmem_cache *t10_alua_lba_map_mem_cache;
 
 static void transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_handle_queue_full(struct se_cmd *cmd,
@@ -128,14 +130,36 @@ int init_se_kmem_caches(void)
 				"mem_t failed\n");
 		goto out_free_tg_pt_gp_cache;
 	}
+	t10_alua_lba_map_cache = kmem_cache_create(
+			"t10_alua_lba_map_cache",
+			sizeof(struct t10_alua_lba_map),
+			__alignof__(struct t10_alua_lba_map), 0, NULL);
+	if (!t10_alua_lba_map_cache) {
+		pr_err("kmem_cache_create() for t10_alua_lba_map_"
+				"cache failed\n");
+		goto out_free_tg_pt_gp_mem_cache;
+	}
+	t10_alua_lba_map_mem_cache = kmem_cache_create(
+			"t10_alua_lba_map_mem_cache",
+			sizeof(struct t10_alua_lba_map_member),
+			__alignof__(struct t10_alua_lba_map_member), 0, NULL);
+	if (!t10_alua_lba_map_mem_cache) {
+		pr_err("kmem_cache_create() for t10_alua_lba_map_mem_"
+				"cache failed\n");
+		goto out_free_lba_map_cache;
+	}
 
 	target_completion_wq = alloc_workqueue("target_completion",
 					       WQ_MEM_RECLAIM, 0);
 	if (!target_completion_wq)
-		goto out_free_tg_pt_gp_mem_cache;
+		goto out_free_lba_map_mem_cache;
 
 	return 0;
 
+out_free_lba_map_mem_cache:
+	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
+out_free_lba_map_cache:
+	kmem_cache_destroy(t10_alua_lba_map_cache);
 out_free_tg_pt_gp_mem_cache:
 	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
 out_free_tg_pt_gp_cache:
@@ -164,6 +188,8 @@ void release_se_kmem_caches(void)
 	kmem_cache_destroy(t10_alua_lu_gp_mem_cache);
 	kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
 	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
+	kmem_cache_destroy(t10_alua_lba_map_cache);
+	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
 }
 
 /* This code ensures unique mib indexes are handed out. */
-- 
1.7.12.4

