From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Convert scsi_scan to use generic async mechanism
Date: Wed, 29 Apr 2009 08:39:10 -0600
Message-ID: <20090429143910.GI21648@parisc-linux.org>
References: <20090428193557.GC21648@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38702 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZD2OjL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 10:39:11 -0400
Content-Disposition: inline
In-Reply-To: <20090428193557.GC21648@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Apr 28, 2009 at 01:35:58PM -0600, Matthew Wilcox wrote:
> The new generic async scanning infrastructure is a perfect replacement
> for the scsi async scanning code.  We do need to use a separate domain
> as libata drivers will deadlock waiting for themselves to complete if
> we don't.  Tested with 515 LUNs (3 on AHCI, two fibre channel cards,
> each with two targets, each with 128 LUNs).

I don't think this patch makes the situation any _worse_ than the
current code, but I wonder if the scan_mutex should be held over the
call to scsi_scan_host_selected().  Any thoughts?

> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6f51ca4..515e7f9 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -122,15 +122,7 @@ MODULE_PARM_DESC(inq_timeout,
>  		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
>  		 " Default is 5. Some non-compliant devices need more.");
>  
> -/* This lock protects only this list */
> -static DEFINE_SPINLOCK(async_scan_lock);
> -static LIST_HEAD(scanning_hosts);
> -
> -struct async_scan_data {
> -	struct list_head list;
> -	struct Scsi_Host *shost;
> -	struct completion prev_finished;
> -};
> +static LIST_HEAD(scan_domain);
>  
>  /**
>   * scsi_complete_async_scans - Wait for asynchronous scans to complete
> @@ -142,44 +134,7 @@ struct async_scan_data {
>   */
>  int scsi_complete_async_scans(void)
>  {
> -	struct async_scan_data *data;
> -
> -	do {
> -		if (list_empty(&scanning_hosts))
> -			return 0;
> -		/* If we can't get memory immediately, that's OK.  Just
> -		 * sleep a little.  Even if we never get memory, the async
> -		 * scans will finish eventually.
> -		 */
> -		data = kmalloc(sizeof(*data), GFP_KERNEL);
> -		if (!data)
> -			msleep(1);
> -	} while (!data);
> -
> -	data->shost = NULL;
> -	init_completion(&data->prev_finished);
> -
> -	spin_lock(&async_scan_lock);
> -	/* Check that there's still somebody else on the list */
> -	if (list_empty(&scanning_hosts))
> -		goto done;
> -	list_add_tail(&data->list, &scanning_hosts);
> -	spin_unlock(&async_scan_lock);
> -
> -	printk(KERN_INFO "scsi: waiting for bus probes to complete ...\n");
> -	wait_for_completion(&data->prev_finished);
> -
> -	spin_lock(&async_scan_lock);
> -	list_del(&data->list);
> -	if (!list_empty(&scanning_hosts)) {
> -		struct async_scan_data *next = list_entry(scanning_hosts.next,
> -				struct async_scan_data, list);
> -		complete(&next->prev_finished);
> -	}
> - done:
> -	spin_unlock(&async_scan_lock);
> -
> -	kfree(data);
> +	async_synchronize_full_domain(&scan_domain);
>  	return 0;
>  }
>  
> @@ -1711,88 +1666,31 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
>  	}
>  }
>  
> -/**
> - * scsi_prep_async_scan - prepare for an async scan
> - * @shost: the host which will be scanned
> - * Returns: a cookie to be passed to scsi_finish_async_scan()
> - *
> - * Tells the midlayer this host is going to do an asynchronous scan.
> - * It reserves the host's position in the scanning list and ensures
> - * that other asynchronous scans started after this one won't affect the
> - * ordering of the discovered devices.
> - */
> -static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
> +static void async_scsi_scan_host(void *data, async_cookie_t cookie)
>  {
> -	struct async_scan_data *data;
> +	struct Scsi_Host *shost = data;
>  	unsigned long flags;
>  
> -	if (strncmp(scsi_scan_type, "sync", 4) == 0)
> -		return NULL;
> -
> -	if (shost->async_scan) {
> -		printk("%s called twice for host %d", __func__,
> -				shost->host_no);
> -		dump_stack();
> -		return NULL;
> -	}
> -
> -	data = kmalloc(sizeof(*data), GFP_KERNEL);
> -	if (!data)
> -		goto err;
> -	data->shost = scsi_host_get(shost);
> -	if (!data->shost)
> -		goto err;
> -	init_completion(&data->prev_finished);
> -
> -	mutex_lock(&shost->scan_mutex);
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	shost->async_scan = 1;
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> -	mutex_unlock(&shost->scan_mutex);
> -
> -	spin_lock(&async_scan_lock);
> -	if (list_empty(&scanning_hosts))
> -		complete(&data->prev_finished);
> -	list_add_tail(&data->list, &scanning_hosts);
> -	spin_unlock(&async_scan_lock);
> -
> -	return data;
>  
> - err:
> -	kfree(data);
> -	return NULL;
> -}
> -
> -/**
> - * scsi_finish_async_scan - asynchronous scan has finished
> - * @data: cookie returned from earlier call to scsi_prep_async_scan()
> - *
> - * All the devices currently attached to this host have been found.
> - * This function announces all the devices it has found to the rest
> - * of the system.
> - */
> -static void scsi_finish_async_scan(struct async_scan_data *data)
> -{
> -	struct Scsi_Host *shost;
> -	unsigned long flags;
> +	if (shost->hostt->scan_finished) {
> +		unsigned long start = jiffies;
> +		if (shost->hostt->scan_start)
> +			shost->hostt->scan_start(shost);
>  
> -	if (!data)
> -		return;
> +		while (!shost->hostt->scan_finished(shost, jiffies - start))
> +			msleep(10);
> +	} else {
> +		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
> +				SCAN_WILD_CARD, 0);
> +	}
>  
> -	shost = data->shost;
> +	async_synchronize_cookie_domain(cookie, &scan_domain);
>  
>  	mutex_lock(&shost->scan_mutex);
>  
> -	if (!shost->async_scan) {
> -		printk("%s called twice for host %d", __func__,
> -				shost->host_no);
> -		dump_stack();
> -		mutex_unlock(&shost->scan_mutex);
> -		return;
> -	}
> -
> -	wait_for_completion(&data->prev_finished);
> -
>  	scsi_sysfs_add_devices(shost);
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> @@ -1801,40 +1699,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
>  
>  	mutex_unlock(&shost->scan_mutex);
>  
> -	spin_lock(&async_scan_lock);
> -	list_del(&data->list);
> -	if (!list_empty(&scanning_hosts)) {
> -		struct async_scan_data *next = list_entry(scanning_hosts.next,
> -				struct async_scan_data, list);
> -		complete(&next->prev_finished);
> -	}
> -	spin_unlock(&async_scan_lock);
> -
>  	scsi_host_put(shost);
> -	kfree(data);
> -}
> -
> -static void do_scsi_scan_host(struct Scsi_Host *shost)
> -{
> -	if (shost->hostt->scan_finished) {
> -		unsigned long start = jiffies;
> -		if (shost->hostt->scan_start)
> -			shost->hostt->scan_start(shost);
> -
> -		while (!shost->hostt->scan_finished(shost, jiffies - start))
> -			msleep(10);
> -	} else {
> -		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
> -				SCAN_WILD_CARD, 0);
> -	}
> -}
> -
> -static int do_scan_async(void *_data)
> -{
> -	struct async_scan_data *data = _data;
> -	do_scsi_scan_host(data->shost);
> -	scsi_finish_async_scan(data);
> -	return 0;
>  }
>  
>  /**
> @@ -1843,21 +1708,16 @@ static int do_scan_async(void *_data)
>   **/
>  void scsi_scan_host(struct Scsi_Host *shost)
>  {
> -	struct task_struct *p;
> -	struct async_scan_data *data;
> +	async_cookie_t cookie;
>  
>  	if (strncmp(scsi_scan_type, "none", 4) == 0)
>  		return;
>  
> -	data = scsi_prep_async_scan(shost);
> -	if (!data) {
> -		do_scsi_scan_host(shost);
> -		return;
> -	}
> -
> -	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
> -	if (IS_ERR(p))
> -		do_scan_async(data);
> +	scsi_host_get(shost);
> +	cookie = async_schedule_domain(async_scsi_scan_host, shost,
> +								&scan_domain);
> +	if (strncmp(scsi_scan_type, "sync", 4) == 0)
> +		async_synchronize_cookie_domain(cookie, &scan_domain);
>  }
>  EXPORT_SYMBOL(scsi_scan_host);
>  
> 
> -- 
> Matthew Wilcox				Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
