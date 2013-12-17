From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 8/8] target_core_alua: Referrals configfs integration
Date: Tue, 17 Dec 2013 12:49:07 -0800
Message-ID: <1387313347.20247.316.camel@haakon3.risingtidesystems.com>
References: <1387268330-121064-1-git-send-email-hare@suse.de>
	 <1387268330-121064-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387268330-121064-9-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-12-17 at 09:18 +0100, Hannes Reinecke wrote:
> Referrals need an LBA map, which needs to be kept
> consistent across all target port groups. So
> instead of tying the map to the target port groups
> I've implemented a single attribute containing the
> entire map.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_alua.c      | 101 +++++++++++++++++++
>  drivers/target/target_core_alua.h      |   8 ++
>  drivers/target/target_core_configfs.c  | 171 +++++++++++++++++++++++++++++++++
>  drivers/target/target_core_device.c    |   1 +
>  drivers/target/target_core_transport.c |  28 +++++-
>  5 files changed, 308 insertions(+), 1 deletion(-)
> 

Applied, with one comment below..

<SNIP>

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index e74ef8c..1dbc1bc 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1741,6 +1741,176 @@ static struct target_core_configfs_attribute target_core_attr_dev_alua_lu_gp = {
>  	.store	= target_core_store_alua_lu_gp,
>  };
>  
> +static ssize_t target_core_show_dev_lba_map(void *p, char *page)
> +{
> +	struct se_device *dev = p;
> +	struct t10_alua_lba_map *map;
> +	struct t10_alua_lba_map_member *mem;
> +	char *b = page;
> +	int bl = 0;
> +	char state;
> +
> +	spin_lock(&dev->t10_alua.lba_map_lock);
> +	if (!list_empty(&dev->t10_alua.lba_map_list))
> +	    bl += sprintf(b + bl, "%u %u\n",
> +			  dev->t10_alua.lba_map_segment_size,
> +			  dev->t10_alua.lba_map_segment_multiplier);
> +	list_for_each_entry(map, &dev->t10_alua.lba_map_list, lba_map_list) {
> +		bl += sprintf(b + bl, "%llu %llu",
> +			      map->lba_map_first_lba, map->lba_map_last_lba);
> +		list_for_each_entry(mem, &map->lba_map_mem_list,
> +				    lba_map_mem_list) {
> +			switch (mem->lba_map_mem_alua_state) {
> +			case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
> +				state = 'O';
> +				break;
> +			case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
> +				state = 'A';
> +				break;
> +			case ALUA_ACCESS_STATE_STANDBY:
> +				state = 'S';
> +				break;
> +			case ALUA_ACCESS_STATE_UNAVAILABLE:
> +				state = 'U';
> +				break;
> +			default:
> +				state = '.';
> +				break;
> +			}
> +			bl += sprintf(b + bl, " %d:%c",
> +				      mem->lba_map_mem_alua_pg_id, state);
> +		}
> +		bl += sprintf(b + bl, "\n");
> +	}
> +	spin_unlock(&dev->t10_alua.lba_map_lock);

The above loop can possibly overflow the passed *page..

Care to send an incremental patch for this as well..?

Btw, I assume this is not the only method for extracting the LBA map
from a running system, right..?

--nab

> +	return bl;
> +}
> +
> +static ssize_t target_core_store_dev_lba_map(
> +	void *p,
> +	const char *page,
> +	size_t count)
> +{
> +	struct se_device *dev = p;
> +	struct t10_alua_lba_map *lba_map = NULL;
> +	struct list_head lba_list;
> +	char *map_entries, *ptr;
> +	char state;
> +	int pg_num = -1, pg;
> +	int ret = 0, num = 0, pg_id, alua_state;
> +	unsigned long start_lba = -1, end_lba = -1;
> +	unsigned long segment_size = -1, segment_mult = -1;
> +
> +	map_entries = kstrdup(page, GFP_KERNEL);
> +	if (!map_entries)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&lba_list);
> +	while ((ptr = strsep(&map_entries, "\n")) != NULL) {
> +		if (!*ptr)
> +			continue;
> +
> +		if (num == 0) {
> +			if (sscanf(ptr, "%lu %lu\n",
> +				   &segment_size, &segment_mult) != 2) {
> +				pr_err("Invalid line %d\n", num);
> +				ret = -EINVAL;
> +				break;
> +			}
> +			num++;
> +			continue;
> +		}
> +		if (sscanf(ptr, "%lu %lu", &start_lba, &end_lba) != 2) {
> +			pr_err("Invalid line %d\n", num);
> +			ret = -EINVAL;
> +			break;
> +		}
> +		ptr = strchr(ptr, ' ');
> +		if (!ptr) {
> +			pr_err("Invalid line %d, missing end lba\n", num);
> +			ret = -EINVAL;
> +			break;
> +		}
> +		ptr++;
> +		ptr = strchr(ptr, ' ');
> +		if (!ptr) {
> +			pr_err("Invalid line %d, missing state definitions\n",
> +			       num);
> +			ret = -EINVAL;
> +			break;
> +		}
> +		ptr++;
> +		lba_map = core_alua_allocate_lba_map(&lba_list,
> +						     start_lba, end_lba);
> +		if (IS_ERR(lba_map)) {
> +			ret = PTR_ERR(lba_map);
> +			break;
> +		}
> +		pg = 0;
> +		while (sscanf(ptr, "%d:%c", &pg_id, &state) == 2) {
> +			switch (state) {
> +			case 'O':
> +				alua_state = ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED;
> +				break;
> +			case 'A':
> +				alua_state = ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED;
> +				break;
> +			case 'S':
> +				alua_state = ALUA_ACCESS_STATE_STANDBY;
> +				break;
> +			case 'U':
> +				alua_state = ALUA_ACCESS_STATE_UNAVAILABLE;
> +				break;
> +			default:
> +				pr_err("Invalid ALUA state '%c'\n", state);
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +
> +			ret = core_alua_allocate_lba_map_mem(lba_map,
> +							     pg_id, alua_state);
> +			if (ret) {
> +				pr_err("Invalid target descriptor %d:%c "
> +				       "at line %d\n",
> +				       pg_id, state, num);
> +				break;
> +			}
> +			pg++;
> +			ptr = strchr(ptr, ' ');
> +			if (ptr)
> +				ptr++;
> +			else
> +				break;
> +		}
> +		if (pg_num == -1)
> +		    pg_num = pg;
> +		else if (pg != pg_num) {
> +			pr_err("Only %d from %d port groups definitions "
> +			       "at line %d\n", pg, pg_num, num);
> +			ret = -EINVAL;
> +			break;
> +		}
> +		num++;
> +	}
> +out:
> +	if (ret) {
> +		core_alua_free_lba_map(&lba_list);
> +		count = ret;
> +	} else
> +		core_alua_set_lba_map(dev, &lba_list,
> +				      segment_size, segment_mult);
> +	kfree(map_entries);
> +	return count;
> +}
> +
> +static struct target_core_configfs_attribute target_core_attr_dev_lba_map = {
> +	.attr	= { .ca_owner = THIS_MODULE,
> +		    .ca_name = "lba_map",
> +		    .ca_mode = S_IRUGO | S_IWUSR },
> +	.show	= target_core_show_dev_lba_map,
> +	.store	= target_core_store_dev_lba_map,
> +};
> +
>  static struct configfs_attribute *lio_core_dev_attrs[] = {
>  	&target_core_attr_dev_info.attr,
>  	&target_core_attr_dev_control.attr,
> @@ -1748,6 +1918,7 @@ static struct configfs_attribute *lio_core_dev_attrs[] = {
>  	&target_core_attr_dev_udev_path.attr,
>  	&target_core_attr_dev_enable.attr,
>  	&target_core_attr_dev_alua_lu_gp.attr,
> +	&target_core_attr_dev_lba_map.attr,
>  	NULL,
>  };
>  
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 3c08f99..376a4d3 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -1585,6 +1585,7 @@ void target_free_device(struct se_device *dev)
>  	}
>  
>  	core_alua_free_lu_gp_mem(dev);
> +	core_alua_set_lba_map(dev, NULL, 0, 0);
>  	core_scsi3_free_all_registrations(dev);
>  	se_release_vpd_for_dev(dev);
>  
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 91953da..18c828d 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -62,6 +62,8 @@ struct kmem_cache *t10_alua_lu_gp_cache;
>  struct kmem_cache *t10_alua_lu_gp_mem_cache;
>  struct kmem_cache *t10_alua_tg_pt_gp_cache;
>  struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
> +struct kmem_cache *t10_alua_lba_map_cache;
> +struct kmem_cache *t10_alua_lba_map_mem_cache;
>  
>  static void transport_complete_task_attr(struct se_cmd *cmd);
>  static void transport_handle_queue_full(struct se_cmd *cmd,
> @@ -128,14 +130,36 @@ int init_se_kmem_caches(void)
>  				"mem_t failed\n");
>  		goto out_free_tg_pt_gp_cache;
>  	}
> +	t10_alua_lba_map_cache = kmem_cache_create(
> +			"t10_alua_lba_map_cache",
> +			sizeof(struct t10_alua_lba_map),
> +			__alignof__(struct t10_alua_lba_map), 0, NULL);
> +	if (!t10_alua_lba_map_cache) {
> +		pr_err("kmem_cache_create() for t10_alua_lba_map_"
> +				"cache failed\n");
> +		goto out_free_tg_pt_gp_mem_cache;
> +	}
> +	t10_alua_lba_map_mem_cache = kmem_cache_create(
> +			"t10_alua_lba_map_mem_cache",
> +			sizeof(struct t10_alua_lba_map_member),
> +			__alignof__(struct t10_alua_lba_map_member), 0, NULL);
> +	if (!t10_alua_lba_map_mem_cache) {
> +		pr_err("kmem_cache_create() for t10_alua_lba_map_mem_"
> +				"cache failed\n");
> +		goto out_free_lba_map_cache;
> +	}
>  
>  	target_completion_wq = alloc_workqueue("target_completion",
>  					       WQ_MEM_RECLAIM, 0);
>  	if (!target_completion_wq)
> -		goto out_free_tg_pt_gp_mem_cache;
> +		goto out_free_lba_map_mem_cache;
>  
>  	return 0;
>  
> +out_free_lba_map_mem_cache:
> +	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
> +out_free_lba_map_cache:
> +	kmem_cache_destroy(t10_alua_lba_map_cache);
>  out_free_tg_pt_gp_mem_cache:
>  	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
>  out_free_tg_pt_gp_cache:
> @@ -164,6 +188,8 @@ void release_se_kmem_caches(void)
>  	kmem_cache_destroy(t10_alua_lu_gp_mem_cache);
>  	kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
>  	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
> +	kmem_cache_destroy(t10_alua_lba_map_cache);
> +	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
>  }
>  
>  /* This code ensures unique mib indexes are handed out. */
