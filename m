From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 5/7] genhd: send async notification on media change
Date: Tue, 22 May 2007 14:12:11 -0700
Message-ID: <20070522141211.fe00333f.akpm@linux-foundation.org>
References: <20070510072247.063476979@intel.com>
	<20070509163835.56ad28e0.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070509163835.56ad28e0.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 9 May 2007 16:38:35 -0700
Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:

> Send an uevent to user space to indicate that a media change event has occurred.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> Index: 2.6-git/block/genhd.c
> ===================================================================
> --- 2.6-git.orig/block/genhd.c
> +++ 2.6-git/block/genhd.c
> @@ -643,6 +643,27 @@ struct seq_operations diskstats_op = {
>  	.show	= diskstats_show
>  };
>  
> +static void media_change_notify_thread(struct work_struct *work)
> +{
> +	struct gendisk *gd = container_of(work, struct gendisk, async_notify);
> +	char event[] = "MEDIA_CHANGE=1";
> +	char *envp[] = { event, NULL };
> +
> +	/*
> +	 * set enviroment vars to indicate which event this is for
> +	 * so that user space will know to go check the media status.
> +	 */
> +	kobject_uevent_env(&gd->kobj, KOBJ_CHANGE, envp);
> +	put_device(gd->driverfs_dev);
> +}
> +
> +void genhd_media_change_notify(struct gendisk *disk)
> +{
> +	get_device(disk->driverfs_dev);
> +	schedule_work(&disk->async_notify);
> +}
> +EXPORT_SYMBOL_GPL(genhd_media_change_notify);
> +
>  struct gendisk *alloc_disk(int minors)
>  {
>  	return alloc_disk_node(minors, -1);
> @@ -672,6 +693,8 @@ struct gendisk *alloc_disk_node(int mino
>  		kobj_set_kset_s(disk,block_subsys);
>  		kobject_init(&disk->kobj);
>  		rand_initialize_disk(disk);
> +		INIT_WORK(&disk->async_notify,
> +			media_change_notify_thread);
>  	}
>  	return disk;

Why does this do a schedule_work() rather than calling kobject_uevent_env()
directly?
