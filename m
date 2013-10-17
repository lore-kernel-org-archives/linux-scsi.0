From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] target_core_alua: Referrals configfs integration
Date: Thu, 17 Oct 2013 09:42:26 +0200
Message-ID: <525F94E2.80909@suse.de>
References: <1381908324-82135-1-git-send-email-hare@suse.de>  <1381908324-82135-3-git-send-email-hare@suse.de> <1381970210.19256.674.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381970210.19256.674.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Nic Bellinger <nab@daterainc.com>, Doug Gilber <dgilbert@interlog.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/17/2013 02:36 AM, Nicholas A. Bellinger wrote:
> On Wed, 2013-10-16 at 09:25 +0200, Hannes Reinecke wrote:
>> Referrals need an LBA map, which needs to be kept
>> consistent across all target port groups. So
>> instead of tying the map to the target port groups
>> I've implemented a single attribute containing the
>> entire map.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/target/target_core_alua.c      | 101 +++++++++++++++++++
>>  drivers/target/target_core_alua.h      |   8 ++
>>  drivers/target/target_core_configfs.c  | 171 ++++++++++++++++++++++=
+++++++++++
>>  drivers/target/target_core_device.c    |   1 +
>>  drivers/target/target_core_transport.c |  28 +++++-
>>  5 files changed, 308 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_alua.c b/drivers/target/targ=
et_core_alua.c
>> index 8f66146..9dd01ff 100644
>> --- a/drivers/target/target_core_alua.c
>> +++ b/drivers/target/target_core_alua.c
>> @@ -1340,6 +1340,107 @@ static int core_alua_set_tg_pt_secondary_sta=
te(
>>  	return 0;
>>  }
>> =20
>> +struct t10_alua_lba_map *
>> +core_alua_allocate_lba_map(struct list_head *list,
>> +			   u64 first_lba, u64 last_lba)
>> +{
>> +	struct t10_alua_lba_map *lba_map;
>> +
>> +	lba_map =3D kmem_cache_zalloc(t10_alua_lba_map_cache, GFP_KERNEL);
>> +	if (!lba_map) {
>> +		pr_err("Unable to allocate struct t10_alua_lba_map\n");
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +	INIT_LIST_HEAD(&lba_map->lba_map_mem_list);
>> +	lba_map->lba_map_first_lba =3D first_lba;
>> +	lba_map->lba_map_last_lba =3D last_lba;
>> +
>> +	list_add_tail(&lba_map->lba_map_list, list);
>> +	return lba_map;
>> +}
>=20
> This list_add_tail needs to be protected, no..?
>=20
No. The current usage is that we first construct the mapping in
memory, and then switching maps in set_lba_map.
This way we only need to protect the switch itself, not the map
construction.

>> +
>> +int
>> +core_alua_allocate_lba_map_mem(struct t10_alua_lba_map *lba_map,
>> +			       int pg_id, int state)
>> +{
>> +	struct t10_alua_lba_map_member *lba_map_mem;
>> +
>> +	list_for_each_entry(lba_map_mem, &lba_map->lba_map_mem_list,
>> +			    lba_map_mem_list) {
>> +		if (lba_map_mem->lba_map_mem_alua_pg_id =3D=3D pg_id) {
>> +			pr_err("Duplicate pg_id %d in lba_map\n", pg_id);
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +	lba_map_mem =3D kmem_cache_zalloc(t10_alua_lba_map_mem_cache, GFP_=
KERNEL);
>> +	if (!lba_map_mem) {
>> +		pr_err("Unable to allocate struct t10_alua_lba_map_mem\n");
>> +		return -ENOMEM;
>> +	}
>> +	lba_map_mem->lba_map_mem_alua_state =3D state;
>> +	lba_map_mem->lba_map_mem_alua_pg_id =3D pg_id;
>> +
>> +	list_add_tail(&lba_map_mem->lba_map_mem_list,
>> +		      &lba_map->lba_map_mem_list);
>> +	return 0;
>> +}
>=20
> Ditto here..
>=20
See above.

>> +
>> +void
>> +core_alua_free_lba_map(struct list_head *lba_list)
>> +{
>> +	struct t10_alua_lba_map *lba_map, *lba_map_tmp;
>> +	struct t10_alua_lba_map_member *lba_map_mem, *lba_map_mem_tmp;
>> +
>> +	list_for_each_entry_safe(lba_map, lba_map_tmp, lba_list,
>> +				 lba_map_list) {
>> +		list_for_each_entry_safe(lba_map_mem, lba_map_mem_tmp,
>> +					 &lba_map->lba_map_mem_list,
>> +					 lba_map_mem_list) {
>> +			list_del(&lba_map_mem->lba_map_mem_list);
>> +			kmem_cache_free(t10_alua_lba_map_mem_cache,
>> +					lba_map_mem);
>> +		}
>> +		list_del(&lba_map->lba_map_list);
>> +		kmem_cache_free(t10_alua_lba_map_cache, lba_map);
>> +	}
>> +}
>=20
> And here..
>=20
>> +
>> +void
>> +core_alua_set_lba_map(struct se_device *dev, struct list_head *lba_=
map_list,
>> +		      int segment_size, int segment_mult)
>> +{
>> +	struct list_head old_lba_map_list;
>> +	struct t10_alua_tg_pt_gp *tg_pt_gp;
>> +	int activate =3D 0, supported;
>> +
>> +	INIT_LIST_HEAD(&old_lba_map_list);
>> +	spin_lock(&dev->t10_alua.lba_map_lock);
>> +	dev->t10_alua.lba_map_segment_size =3D segment_size;
>> +	dev->t10_alua.lba_map_segment_multiplier =3D segment_mult;
>> +	list_splice_init(&dev->t10_alua.lba_map_list, &old_lba_map_list);
>> +	if (lba_map_list) {
>> +		list_splice_init(lba_map_list, &dev->t10_alua.lba_map_list);
>> +		activate =3D 1;
>> +	}
>> +	spin_unlock(&dev->t10_alua.lba_map_lock);
>> +	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
>> +	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
>> +			    tg_pt_gp_list) {
>> +
>> +		if (!tg_pt_gp->tg_pt_gp_valid_id)
>> +			continue;
>> +		supported =3D tg_pt_gp->tg_pt_gp_alua_supported_states;
>> +		if (activate)
>> +			supported |=3D ALUA_LBD_SUP;
>> +		else
>> +			supported &=3D ~ALUA_LBD_SUP;
>> +		tg_pt_gp->tg_pt_gp_alua_supported_states =3D supported;
>> +	}
>> +	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
>> +	core_alua_free_lba_map(&old_lba_map_list);
>> +}
>> +
>>  struct t10_alua_lu_gp *
>>  core_alua_allocate_lu_gp(const char *name, int def_group)
>>  {

This is what I meant; I'm protecting the map switching, not the map
construction.

>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/=
target_core_configfs.c
>> index 172a54e..613cafb 100644
>> --- a/drivers/target/target_core_configfs.c
>> +++ b/drivers/target/target_core_configfs.c
>> @@ -1741,6 +1741,176 @@ static struct target_core_configfs_attribute=
 target_core_attr_dev_alua_lu_gp =3D {
>>  	.store	=3D target_core_store_alua_lu_gp,
>>  };
>> =20
>> +static ssize_t target_core_show_dev_lba_map(void *p, char *page)
>> +{
>> +	struct se_device *dev =3D p;
>> +	struct t10_alua_lba_map *map;
>> +	struct t10_alua_lba_map_member *mem;
>> +	char *b =3D page;
>> +	int bl =3D 0;
>> +	char state;
>> +
>> +	spin_lock(&dev->t10_alua.lba_map_lock);
>> +	if (!list_empty(&dev->t10_alua.lba_map_list))
>> +	    bl +=3D sprintf(b + bl, "%u %u\n",
>> +			  dev->t10_alua.lba_map_segment_size,
>> +			  dev->t10_alua.lba_map_segment_multiplier);
>> +	list_for_each_entry(map, &dev->t10_alua.lba_map_list, lba_map_list=
) {
>> +		bl +=3D sprintf(b + bl, "%llu %llu",
>> +			      map->lba_map_first_lba, map->lba_map_last_lba);
>> +		list_for_each_entry(mem, &map->lba_map_mem_list,
>> +				    lba_map_mem_list) {
>> +			switch (mem->lba_map_mem_alua_state) {
>> +			case ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED:
>> +				state =3D 'O';
>> +				break;
>> +			case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
>> +				state =3D 'A';
>> +				break;
>> +			case ALUA_ACCESS_STATE_STANDBY:
>> +				state =3D 'S';
>> +				break;
>> +			case ALUA_ACCESS_STATE_UNAVAILABLE:
>> +				state =3D 'U';
>> +				break;
>> +			default:
>> +				state =3D '.';
>> +				break;
>> +			}
>> +			bl +=3D sprintf(b + bl, " %d:%c",
>> +				      mem->lba_map_mem_alua_pg_id, state);
>> +		}
>> +		bl +=3D sprintf(b + bl, "\n");
>> +	}
>> +	spin_unlock(&dev->t10_alua.lba_map_lock);
>> +	return bl;
>> +}
>=20
> Unfortunately due to the existing limitations of configfs/sysfs
> attribute output, the writing to *page needs to be limited to PAGE_SI=
ZE.
>=20
Okay, I'll be inserting the respective checks.

>> +
>> +static ssize_t target_core_store_dev_lba_map(
>> +	void *p,
>> +	const char *page,
>> +	size_t count)
>> +{
>> +	struct se_device *dev =3D p;
>> +	struct t10_alua_lba_map *lba_map =3D NULL;
>> +	struct list_head lba_list;
>> +	char *map_entries, *ptr;
>> +	char state;
>> +	int pg_num =3D -1, pg;
>> +	int ret =3D 0, num =3D 0, pg_id, alua_state;
>> +	unsigned long start_lba =3D -1, end_lba =3D -1;
>> +	unsigned long segment_size =3D -1, segment_mult =3D -1;
>> +
>> +	map_entries =3D kstrdup(page, GFP_KERNEL);
>> +	if (!map_entries)
>> +		return -ENOMEM;
>> +
>> +	INIT_LIST_HEAD(&lba_list);
>> +	while ((ptr =3D strsep(&map_entries, "\n")) !=3D NULL) {
>> +		if (!*ptr)
>> +			continue;
>> +
>> +		if (num =3D=3D 0) {
>> +			if (sscanf(ptr, "%lu %lu\n",
>> +				   &segment_size, &segment_mult) !=3D 2) {
>> +				pr_err("Invalid line %d\n", num);
>> +				ret =3D -EINVAL;
>> +				break;
>> +			}
>> +			num++;
>> +			continue;
>> +		}
>> +		if (sscanf(ptr, "%lu %lu", &start_lba, &end_lba) !=3D 2) {
>> +			pr_err("Invalid line %d\n", num);
>> +			ret =3D -EINVAL;
>> +			break;
>> +		}
>> +		ptr =3D strchr(ptr, ' ');
>> +		if (!ptr) {
>> +			pr_err("Invalid line %d, missing end lba\n", num);
>> +			ret =3D -EINVAL;
>> +			break;
>> +		}
>> +		ptr++;
>> +		ptr =3D strchr(ptr, ' ');
>> +		if (!ptr) {
>> +			pr_err("Invalid line %d, missing state definitions\n",
>> +			       num);
>> +			ret =3D -EINVAL;
>> +			break;
>> +		}
>> +		ptr++;
>> +		lba_map =3D core_alua_allocate_lba_map(&lba_list,
>> +						     start_lba, end_lba);
>> +		if (IS_ERR(lba_map)) {
>> +			ret =3D PTR_ERR(lba_map);>> +		num++;
>> +	}
>> +out:
>> +	if (ret) {
>> +		core_alua_free_lba_map(&lba_list);
>> +		count =3D ret;
>> +	} else
>> +		core_alua_set_lba_map(dev, &lba_list,
>> +				      segment_size, segment_mult);
>> +	kfree(map_entries);
>> +	return count;
>> +}
>> +
>> +static struct target_core_configfs_attribute target_core_attr_dev_l=
ba_map =3D {
>> +	.attr	=3D { .ca_owner =3D THIS_MODULE,
>> +		    .ca_name =3D "lba_map",
>> +		    .ca_mode =3D S_IRUGO | S_IWUSR },
>> +	.show	=3D target_core_show_dev_lba_map,
>> +	.store	=3D target_core_store_dev_lba_map,
>> +};
>> +
>>  static struct configfs_attribute *lio_core_dev_attrs[] =3D {
>>  	&target_core_attr_dev_info.attr,
>>  	&target_core_attr_dev_control.attr,
>> @@ -1748,6 +1918,7 @@ static struct configfs_attribute *lio_core_dev=
_attrs[] =3D {
>>  	&target_core_attr_dev_udev_path.attr,
>>  	&target_core_attr_dev_enable.attr,
>>  	&target_core_attr_dev_alua_lu_gp.attr,
>> +	&target_core_attr_dev_lba_map.attr,
>>  	NULL,
>>  };
>> =20
>> diff --git a/drivers/target/target_core_device.c b/drivers/target/ta=
rget_core_device.c
>> index f71cc33..6db76af 100644
>> --- a/drivers/target/target_core_device.c
>> +++ b/drivers/target/target_core_device.c
>> @@ -1578,6 +1578,7 @@ void target_free_device(struct se_device *dev)
>>  	}
>> =20
>>  	core_alua_free_lu_gp_mem(dev);
>> +	core_alua_set_lba_map(dev, NULL, 0, 0);
>>  	core_scsi3_free_all_registrations(dev);
>>  	se_release_vpd_for_dev(dev);
>> =20
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target=
/target_core_transport.c
>> index 98bb7c4..e34d4b4 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -63,6 +63,8 @@ struct kmem_cache *t10_alua_lu_gp_cache;
>>  struct kmem_cache *t10_alua_lu_gp_mem_cache;
>>  struct kmem_cache *t10_alua_tg_pt_gp_cache;
>>  struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
>> +struct kmem_cache *t10_alua_lba_map_cache;
>> +struct kmem_cache *t10_alua_lba_map_mem_cache;
>> =20
>>  static void transport_complete_task_attr(struct se_cmd *cmd);
>>  static void transport_handle_queue_full(struct se_cmd *cmd,
>> @@ -129,14 +131,36 @@ int init_se_kmem_caches(void)
>>  				"mem_t failed\n");
>>  		goto out_free_tg_pt_gp_cache;
>>  	}
>> +	t10_alua_lba_map_cache =3D kmem_cache_create(
>> +			"t10_alua_lba_map_cache",
>> +			sizeof(struct t10_alua_lba_map),
>> +			__alignof__(struct t10_alua_lba_map), 0, NULL);
>> +	if (!t10_alua_lba_map_cache) {
>> +		pr_err("kmem_cache_create() for t10_alua_lba_map_"
>> +				"cache failed\n");
>> +		goto out_free_tg_pt_gp_mem_cache;
>> +	}
>> +	t10_alua_lba_map_mem_cache =3D kmem_cache_create(
>> +			"t10_alua_lba_map_mem_cache",
>> +			sizeof(struct t10_alua_lba_map_member),
>> +			__alignof__(struct t10_alua_lba_map_member), 0, NULL);
>> +	if (!t10_alua_lba_map_mem_cache) {
>> +		pr_err("kmem_cache_create() for t10_alua_lba_map_mem_"
>> +				"cache failed\n");
>> +		goto out_free_lba_map_cache;
>> +	}
>> =20
>>  	target_completion_wq =3D alloc_workqueue("target_completion",
>>  					       WQ_MEM_RECLAIM, 0);
>>  	if (!target_completion_wq)
>> -		goto out_free_tg_pt_gp_mem_cache;
>> +		goto out_free_lba_map_mem_cache;
>> =20
>>  	return 0;
>> =20
>> +out_free_lba_map_mem_cache:
>> +	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
>> +out_free_lba_map_cache:
>> +	kmem_cache_destroy(t10_alua_lba_map_cache);
>>  out_free_tg_pt_gp_mem_cache:
>>  	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
>>  out_free_tg_pt_gp_cache:
>> @@ -165,6 +189,8 @@ void release_se_kmem_caches(void)
>>  	kmem_cache_destroy(t10_alua_lu_gp_mem_cache);
>>  	kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
>>  	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
>> +	kmem_cache_destroy(t10_alua_lba_map_cache);
>> +	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
>>  }
>> =20
>>  /* This code ensures unique mib indexes are handed out. */
>=20
>=20

>> +			break;
>> +		}
>> +		pg =3D 0;
>> +		while (sscanf(ptr, "%d:%c", &pg_id, &state) =3D=3D 2) {
>> +			switch (state) {
>> +			case 'O':
>> +				alua_state =3D ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED;
>> +				break;
>> +			case 'A':
>> +				alua_state =3D ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED;
>> +				break;
>> +			case 'S':
>> +				alua_state =3D ALUA_ACCESS_STATE_STANDBY;
>> +				break;
>> +			case 'U':
>> +				alua_state =3D ALUA_ACCESS_STATE_UNAVAILABLE;
>> +				break;
>> +			default:
>> +				pr_err("Invalid ALUA state '%c'\n", state);
>> +				ret =3D -EINVAL;
>> +				goto out;
>> +			}
>> +
>> +			ret =3D core_alua_allocate_lba_map_mem(lba_map,
>> +							     pg_id, alua_state);
>> +			if (ret) {
>> +				pr_err("Invalid target descriptor %d:%c "
>> +				       "at line %d\n",
>> +				       pg_id, state, num);
>> +				break;
>> +			}
>> +			pg++;
>> +			ptr =3D strchr(ptr, ' ');
>> +			if (ptr)
>> +				ptr++;
>> +			else
>> +				break;
>> +		}
>> +		if (pg_num =3D=3D -1)
>> +		    pg_num =3D pg;
>> +		else if (pg !=3D pg_num) {
>> +			pr_err("Only %d from %d port groups definitions "
>> +			       "at line %d\n", pg, pg_num, num);
>> +			ret =3D -EINVAL;
>> +			break;
>> +		}
>=20
> Btw, checkpatch complains about conditionals that don't have matching
> brackets on both code block, eg:
>=20
>    if foo
>    else {
>        bar
>    }
>=20
Ah. Of course.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
