From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 5/7] genhd: send async notification on media change
Date: Tue, 24 Apr 2007 17:20:03 +0900
Message-ID: <462DBDB3.9010102@gmail.com>
References: <20070424074856.005152262@intel.com> <20070423170010.5514072e.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:44251 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbXDXIUJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2007 04:20:09 -0400
Received: by an-out-0708.google.com with SMTP id b33so2145073ana
        for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2007 01:20:09 -0700 (PDT)
In-Reply-To: <20070423170010.5514072e.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Kristen Carlson Accardi wrote:
> Send an uevent to user space to indicate that a media change event has occurred.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> Index: 2.6-git/block/genhd.c
> ===================================================================
> --- 2.6-git.orig/block/genhd.c
> +++ 2.6-git/block/genhd.c
> @@ -643,6 +643,25 @@ struct seq_operations diskstats_op = {
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
> +}
> +
> +void genhd_media_change_notify(struct gendisk *disk)
> +{
> +	schedule_work(&disk->async_notify);
> +}
> +EXPORT_SYMBOL_GPL(genhd_media_change_notify);

genhd might go away while async_notify work is in-flight.  You'll need
to either grab a reference or wait for the work to finish in release
routine.

-- 
tejun
