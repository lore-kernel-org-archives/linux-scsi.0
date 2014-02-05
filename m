From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 06/32] target: Convert lu_gp_ref_cnt to kref
Date: Wed, 05 Feb 2014 14:02:58 -0800
Message-ID: <52F2B512.9040102@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>  <1386979160-6928-7-git-send-email-agrover@redhat.com> <1387227157.20247.203.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387227157.20247.203.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi nab, I'm getting back to looking at this patchset, but wanted to just
discuss and understand this one first because all the kref ones are
similar. see below.

On 12/16/2013 12:52 PM, Nicholas A. Bellinger wrote:
> On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
>> Use kref to handle reference counting
>>
>> Signed-off-by: Andy Grover <agrover@redhat.com>
>> ---
>>  drivers/target/target_core_alua.c |   37 ++++++++++++++++++++-----------------
>>  include/target/target_core_base.h |    2 +-
>>  2 files changed, 21 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
>> index 2ac2f11..8c01ade 100644
>> --- a/drivers/target/target_core_alua.c
>> +++ b/drivers/target/target_core_alua.c
>> @@ -54,6 +54,16 @@ static LIST_HEAD(lu_gps_list);
>>  
>>  struct t10_alua_lu_gp *default_lu_gp;
>>  
>> +static void release_alua_lu_gp(struct kref *ref)
>> +{
>> +	struct t10_alua_lu_gp *lu_gp = container_of(ref, struct t10_alua_lu_gp, refcount);
>> +
>> +	kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
>> +}
>> +
>> +#define get_alua_lu_gp(x) kref_get(&x->refcount)
>> +#define put_alua_lu_gp(x) kref_put(&x->refcount, release_alua_lu_gp)
>> +
>>  /*
>>   * REPORT_TARGET_PORT_GROUPS
>>   *
>> @@ -898,8 +908,7 @@ int core_alua_do_port_transition(
>>  	local_lu_gp_mem = l_dev->dev_alua_lu_gp_mem;
>>  	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
>>  	lu_gp = local_lu_gp_mem->lu_gp;
>> -	atomic_inc(&lu_gp->lu_gp_ref_cnt);
>> -	smp_mb__after_atomic_inc();
>> +	get_alua_lu_gp(lu_gp);
>>  	spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
>>  	/*
>>  	 * For storage objects that are members of the 'default_lu_gp',
>> @@ -913,8 +922,8 @@ int core_alua_do_port_transition(
>>  		 */
>>  		core_alua_do_transition_tg_pt(l_tg_pt_gp, l_port, l_nacl,
>>  					md_buf, new_state, explicit);
>> -		atomic_dec(&lu_gp->lu_gp_ref_cnt);
>> -		smp_mb__after_atomic_dec();
>> +
>> +		put_alua_lu_gp(lu_gp);
>>  		kfree(md_buf);
>>  		return 0;
>>  	}
>> @@ -985,8 +994,7 @@ int core_alua_do_port_transition(
>>  		l_tg_pt_gp->tg_pt_gp_id, (explicit) ? "explicit" : "implicit",
>>  		core_alua_dump_state(new_state));
>>  
>> -	atomic_dec(&lu_gp->lu_gp_ref_cnt);
>> -	smp_mb__after_atomic_dec();
>> +	put_alua_lu_gp(lu_gp);
>>  	kfree(md_buf);
>>  	return 0;
>>  }
>> @@ -1107,7 +1115,8 @@ core_alua_allocate_lu_gp(const char *name, int def_group)
>>  	INIT_LIST_HEAD(&lu_gp->lu_gp_node);
>>  	INIT_LIST_HEAD(&lu_gp->lu_gp_mem_list);
>>  	spin_lock_init(&lu_gp->lu_gp_lock);
>> -	atomic_set(&lu_gp->lu_gp_ref_cnt, 0);
>> +
>> +	kref_init(&lu_gp->refcount);
>>  
>>  	if (def_group) {
>>  		lu_gp->lu_gp_id = alua_lu_gps_counter++;
>> @@ -1200,13 +1209,7 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
>>  	list_del(&lu_gp->lu_gp_node);
>>  	alua_lu_gps_count--;
>>  	spin_unlock(&lu_gps_lock);
>> -	/*
>> -	 * Allow struct t10_alua_lu_gp * referenced by core_alua_get_lu_gp_by_name()
>> -	 * in target_core_configfs.c:target_core_store_alua_lu_gp() to be
>> -	 * released with core_alua_put_lu_gp_from_name()
>> -	 */
>> -	while (atomic_read(&lu_gp->lu_gp_ref_cnt))
>> -		cpu_relax();
>> +
>>  	/*
>>  	 * Release reference to struct t10_alua_lu_gp * from all associated
>>  	 * struct se_device.
>> @@ -1241,7 +1244,7 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
>>  	}
>>  	spin_unlock(&lu_gp->lu_gp_lock);
>>  
>> -	kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
>> +	put_alua_lu_gp(lu_gp);
>>  }
>>  

> The assumption that it's safe to 'Release reference to struct
> t10_alua_lu_gp * from all associated struct device' below the original
> cpu_relax(), while there are still other process contexts doing their
> respective put_alua_lu_gp() is totally wrong.

The only other spot is core_alua_do_port_transition, afaics. I think if
it races with free_lu_gp, lu_gp will either be the old lu_gp (which no
longer will have anything on lu_gp_mem_list) or will be default_lu_gp.
If it's the old lu_gp then it iterates over an empty list, and then the
lu_gp gets finally freed by the put() at the bottom.

> Furthermore, allowing a configfs_group_ops->drop_item() to return while
> there are still active references from other process contexts means that
> the parent struct config_group is no longer referenced counted (eg:
> configfs child is removed), and introduces a whole host of potential
> bugs.
> 
> So that said, NAK on this patch.

I think some of the other patches used drop_item() and thus were bad,
but in this one the existing code is already calling
core_alua_free_lu_gp() from release().

Thoughts?

Thanks in advance -- Regards -- Andy
