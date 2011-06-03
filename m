From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH v2] libsas: export sas_alloc_task()
Date: Fri, 3 Jun 2011 09:47:55 +0800
Message-ID: <9CA988CDD3E54DBA829117B230B6F986@usish.com.cn>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:52722 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1FCBsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2011 21:48:05 -0400
In-Reply-To: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, JBottomley@parallels.com
Cc: 'Lindar Liu' <lindar_liu@usish.com>, 'Xiangliang Yu' <yuxiangl@marvell.com>, 'Ankit Jain' <jankit@suse.de>, linux-scsi@vger.kernel.org

Acked-by: Jack Wang <jack_wang@usish.com>

Thanks

> Cc: Jack Wang <jack_wang@usish.com>
> Cc: Lindar Liu <lindar_liu@usish.com>
> Cc: Xiangliang Yu <yuxiangl@marvell.com>
> Cc: Ankit Jain <jankit@suse.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> v2:
> * use KMEM_CACHE as noted by Ankit
> * remove redundant checking for NULL tasks as sas_free_tasks() checks
>   for NULL
> 
>  drivers/scsi/libsas/sas_init.c   |   30 +++++++++++++++++++++++++++---
>  drivers/scsi/mvsas/mv_sas.c      |   29 +++--------------------------
>  drivers/scsi/pm8001/pm8001_sas.c |   38
> ++++++--------------------------------
>  include/scsi/libsas.h            |   26 ++------------------------
>  4 files changed, 38 insertions(+), 85 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_init.c
> b/drivers/scsi/libsas/sas_init.c
> index 2dc5534..dd56ea8 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -37,7 +37,32 @@
> 
>  #include "../scsi_sas_internal.h"
> 
> -struct kmem_cache *sas_task_cache;
> +static struct kmem_cache *sas_task_cache;
> +
> +struct sas_task *sas_alloc_task(gfp_t flags)
> +{
> +	struct sas_task *task = kmem_cache_zalloc(sas_task_cache, flags);
> +
> +	if (task) {
> +		INIT_LIST_HEAD(&task->list);
> +		spin_lock_init(&task->task_state_lock);
> +		task->task_state_flags = SAS_TASK_STATE_PENDING;
> +		init_timer(&task->timer);
> +		init_completion(&task->completion);
> +	}
> +
> +	return task;
> +}
> +EXPORT_SYMBOL_GPL(sas_alloc_task);
> +
> +void sas_free_task(struct sas_task *task)
> +{
> +	if (task) {
> +		BUG_ON(!list_empty(&task->list));
> +		kmem_cache_free(sas_task_cache, task);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(sas_free_task);
> 
>  /*------------ SAS addr hash -----------*/
>  void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
> @@ -293,8 +318,7 @@ EXPORT_SYMBOL_GPL(sas_domain_release_transport);
> 
>  static int __init sas_class_init(void)
>  {
> -	sas_task_cache = kmem_cache_create("sas_task", sizeof(struct
sas_task),
> -					   0, SLAB_HWCACHE_ALIGN, NULL);
> +	sas_task_cache = KMEM_CACHE(sas_task, SLAB_HWCACHE_ALIGN);
>  	if (!sas_task_cache)
>  		return -ENOMEM;
> 
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 0ef2742..7921b61 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1518,28 +1518,6 @@ void mvs_dev_gone(struct domain_device *dev)
>  	mvs_dev_gone_notify(dev);
>  }
> 
> -static  struct sas_task *mvs_alloc_task(void)
> -{
> -	struct sas_task *task = kzalloc(sizeof(struct sas_task),
GFP_KERNEL);
> -
> -	if (task) {
> -		INIT_LIST_HEAD(&task->list);
> -		spin_lock_init(&task->task_state_lock);
> -		task->task_state_flags = SAS_TASK_STATE_PENDING;
> -		init_timer(&task->timer);
> -		init_completion(&task->completion);
> -	}
> -	return task;
> -}
> -
> -static  void mvs_free_task(struct sas_task *task)
> -{
> -	if (task) {
> -		BUG_ON(!list_empty(&task->list));
> -		kfree(task);
> -	}
> -}
> -
>  static void mvs_task_done(struct sas_task *task)
>  {
>  	if (!del_timer(&task->timer))
> @@ -1564,7 +1542,7 @@ static int mvs_exec_internal_tmf_task(struct
> domain_device *dev,
>  	struct sas_task *task = NULL;
> 
>  	for (retry = 0; retry < 3; retry++) {
> -		task = mvs_alloc_task();
> +		task = sas_alloc_task(GFP_KERNEL);
>  		if (!task)
>  			return -ENOMEM;
> 
> @@ -1622,15 +1600,14 @@ static int mvs_exec_internal_tmf_task(struct
> domain_device *dev,
>  				    SAS_ADDR(dev->sas_addr),
>  				    task->task_status.resp,
>  				    task->task_status.stat);
> -			mvs_free_task(task);
> +			sas_free_task(task);
>  			task = NULL;
> 
>  		}
>  	}
>  ex_err:
>  	BUG_ON(retry == 3 && task != NULL);
> -	if (task != NULL)
> -		mvs_free_task(task);
> +	sas_free_task(task);
>  	return res;
>  }
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c
> b/drivers/scsi/pm8001/pm8001_sas.c
> index 6ae059e..7dbbf8b 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -669,30 +669,6 @@ int pm8001_dev_found(struct domain_device *dev)
>  	return pm8001_dev_found_notify(dev);
>  }
> 
> -/**
> -  * pm8001_alloc_task - allocate a task structure for TMF
> -  */
> -static struct sas_task *pm8001_alloc_task(void)
> -{
> -	struct sas_task *task = kzalloc(sizeof(*task), GFP_KERNEL);
> -	if (task) {
> -		INIT_LIST_HEAD(&task->list);
> -		spin_lock_init(&task->task_state_lock);
> -		task->task_state_flags = SAS_TASK_STATE_PENDING;
> -		init_timer(&task->timer);
> -		init_completion(&task->completion);
> -	}
> -	return task;
> -}
> -
> -static void pm8001_free_task(struct sas_task *task)
> -{
> -	if (task) {
> -		BUG_ON(!list_empty(&task->list));
> -		kfree(task);
> -	}
> -}
> -
>  static void pm8001_task_done(struct sas_task *task)
>  {
>  	if (!del_timer(&task->timer))
> @@ -728,7 +704,7 @@ static int pm8001_exec_internal_tmf_task(struct
> domain_device *dev,
>  	struct pm8001_hba_info *pm8001_ha = pm8001_find_ha_by_dev(dev);
> 
>  	for (retry = 0; retry < 3; retry++) {
> -		task = pm8001_alloc_task();
> +		task = sas_alloc_task(GFP_KERNEL);
>  		if (!task)
>  			return -ENOMEM;
> 
> @@ -789,14 +765,13 @@ static int pm8001_exec_internal_tmf_task(struct
> domain_device *dev,
>  				SAS_ADDR(dev->sas_addr),
>  				task->task_status.resp,
>  				task->task_status.stat));
> -			pm8001_free_task(task);
> +			sas_free_task(task);
>  			task = NULL;
>  		}
>  	}
>  ex_err:
>  	BUG_ON(retry == 3 && task != NULL);
> -	if (task != NULL)
> -		pm8001_free_task(task);
> +	sas_free_task(task);
>  	return res;
>  }
> 
> @@ -811,7 +786,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info
> *pm8001_ha,
>  	struct sas_task *task = NULL;
> 
>  	for (retry = 0; retry < 3; retry++) {
> -		task = pm8001_alloc_task();
> +		task = sas_alloc_task(GFP_KERNEL);
>  		if (!task)
>  			return -ENOMEM;
> 
> @@ -864,14 +839,13 @@ pm8001_exec_internal_task_abort(struct
pm8001_hba_info
> *pm8001_ha,
>  				SAS_ADDR(dev->sas_addr),
>  				task->task_status.resp,
>  				task->task_status.stat));
> -			pm8001_free_task(task);
> +			sas_free_task(task);
>  			task = NULL;
>  		}
>  	}
>  ex_err:
>  	BUG_ON(retry == 3 && task != NULL);
> -	if (task != NULL)
> -		pm8001_free_task(task);
> +	sas_free_task(task);
>  	return res;
>  }
> 
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index ee86606..2517254 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -555,36 +555,14 @@ struct sas_task {
>  	struct work_struct abort_work;
>  };
> 
> -extern struct kmem_cache *sas_task_cache;
> -
>  #define SAS_TASK_STATE_PENDING      1
>  #define SAS_TASK_STATE_DONE         2
>  #define SAS_TASK_STATE_ABORTED      4
>  #define SAS_TASK_NEED_DEV_RESET     8
>  #define SAS_TASK_AT_INITIATOR       16
> 
> -static inline struct sas_task *sas_alloc_task(gfp_t flags)
> -{
> -	struct sas_task *task = kmem_cache_zalloc(sas_task_cache, flags);
> -
> -	if (task) {
> -		INIT_LIST_HEAD(&task->list);
> -		spin_lock_init(&task->task_state_lock);
> -		task->task_state_flags = SAS_TASK_STATE_PENDING;
> -		init_timer(&task->timer);
> -		init_completion(&task->completion);
> -	}
> -
> -	return task;
> -}
> -
> -static inline void sas_free_task(struct sas_task *task)
> -{
> -	if (task) {
> -		BUG_ON(!list_empty(&task->list));
> -		kmem_cache_free(sas_task_cache, task);
> -	}
> -}
> +extern struct sas_task *sas_alloc_task(gfp_t flags);
> +extern void sas_free_task(struct sas_task *task);
> 
>  struct sas_domain_function_template {
>  	/* The class calls these to notify the LLDD of an event. */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

