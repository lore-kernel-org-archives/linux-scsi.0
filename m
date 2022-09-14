Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF5BECAAD8
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 09:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiINJo0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 05:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiINJn5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 05:43:57 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9F52496F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 02:43:55 -0700 (PDT)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MSFfT3SFfz67yhg;
        Wed, 14 Sep 2022 17:39:29 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 11:43:53 +0200
Received: from [10.48.151.55] (10.48.151.55) by lhrpeml500003.china.huawei.com
 (7.191.162.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Sep
 2022 10:43:52 +0100
Message-ID: <33c751b4-9c6d-ac2c-d394-86ae0de3af0d@huawei.com>
Date:   Wed, 14 Sep 2022 10:43:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v4 3/4] scsi: core: Introduce a new list for SCSI proc
 directory entries
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220913195716.3966875-1-bvanassche@acm.org>
 <20220913195716.3966875-4-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220913195716.3966875-4-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.151.55]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/09/2022 20:57, Bart Van Assche wrote:
> Instead of using scsi_host_template members to track the SCSI proc
> directory entries, track these entries in a list. This patch changes the
> time needed for looking up the proc dir pointer from O(1) into O(n). I
> think this is acceptable since the number of SCSI host adapter types per
> host is usually small (less than ten).
> 
> This patch has been tested by attaching two USB storage devices to a
> qemu host:
> 
> $ grep -aH . /proc/scsi/usb-storage/*
> /proc/scsi/usb-storage/7:   Host scsi7: usb-storage
> /proc/scsi/usb-storage/7:       Vendor: QEMU
> /proc/scsi/usb-storage/7:      Product: QEMU USB HARDDRIVE
> /proc/scsi/usb-storage/7:Serial Number: 1-0000:00:02.1:00.0-6
> /proc/scsi/usb-storage/7:     Protocol: Transparent SCSI
> /proc/scsi/usb-storage/7:    Transport: Bulk
> /proc/scsi/usb-storage/7:       Quirks: SANE_SENSE
> /proc/scsi/usb-storage/8:   Host scsi8: usb-storage
> /proc/scsi/usb-storage/8:       Vendor: QEMU
> /proc/scsi/usb-storage/8:      Product: QEMU USB HARDDRIVE
> /proc/scsi/usb-storage/8:Serial Number: 1-0000:00:02.1:00.0-7
> /proc/scsi/usb-storage/8:     Protocol: Transparent SCSI
> /proc/scsi/usb-storage/8:    Transport: Bulk
> /proc/scsi/usb-storage/8:       Quirks: SANE_SENSE
> 
> This patch prepares for constifying most SCSI host templates.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_priv.h |   4 +-
>   drivers/scsi/scsi_proc.c | 111 +++++++++++++++++++++++++++++++++------
>   include/scsi/scsi_host.h |  12 -----
>   3 files changed, 96 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index f385b3f04d6e..be5d7c9b7f39 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -100,8 +100,8 @@ extern void scsi_evt_thread(struct work_struct *work);
>   
>   /* scsi_proc.c */
>   #ifdef CONFIG_SCSI_PROC_FS
> -extern void scsi_proc_hostdir_add(struct scsi_host_template *);
> -extern void scsi_proc_hostdir_rm(struct scsi_host_template *);
> +extern void scsi_proc_hostdir_add(const struct scsi_host_template *);
> +extern void scsi_proc_hostdir_rm(const struct scsi_host_template *);
>   extern void scsi_proc_host_add(struct Scsi_Host *);
>   extern void scsi_proc_host_rm(struct Scsi_Host *);
>   extern int scsi_init_procfs(void);
> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
> index 456b43097288..7dffa73d6f92 100644
> --- a/drivers/scsi/scsi_proc.c
> +++ b/drivers/scsi/scsi_proc.c
> @@ -43,8 +43,23 @@
>   
>   static struct proc_dir_entry *proc_scsi;
>   
> -/* Protect sht->present and sht->proc_dir */
> +/* Protects scsi_proc_list */
>   static DEFINE_MUTEX(global_host_template_mutex);
> +static LIST_HEAD(scsi_proc_list);
> +
> +/**
> + * struct scsi_proc_entry - (host template, SCSI proc dir) association
> + * @entry: entry in scsi_proc_list.
> + * @sht: SCSI host template associated with the procfs directory.
> + * @proc_dir: procfs directory associated with the SCSI host template.
> + * @present: Number of SCSI hosts instantiated for @sht.
> + */
> +struct scsi_proc_entry {
> +	struct list_head	entry;
> +	const struct scsi_host_template *sht;
> +	struct proc_dir_entry	*proc_dir;
> +	unsigned int		present;
> +};
>   
>   static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
>                              size_t count, loff_t *ppos)
> @@ -83,6 +98,32 @@ static int proc_scsi_host_open(struct inode *inode, struct file *file)
>   				4 * PAGE_SIZE);
>   }
>   
> +static struct scsi_proc_entry *
> +__scsi_lookup_proc_entry(const struct scsi_host_template *sht)
> +{
> +	struct scsi_proc_entry *e;
> +
> +	lockdep_assert_held(&global_host_template_mutex);
> +
> +	list_for_each_entry(e, &scsi_proc_list, entry)
> +		if (e->sht == sht)
> +			return e;
> +
> +	return NULL;
> +}
> +
> +static struct scsi_proc_entry *
> +scsi_lookup_proc_entry(const struct scsi_host_template *sht)
> +{
> +	struct scsi_proc_entry *e;
> +
> +	mutex_lock(&global_host_template_mutex);
> +	e = __scsi_lookup_proc_entry(sht);
> +	mutex_unlock(&global_host_template_mutex);
> +
> +	return e;
> +}
> +
>   /**
>    * scsi_template_proc_dir() - returns the procfs dir for a SCSI host template
>    * @sht: SCSI host template pointer.
> @@ -90,7 +131,9 @@ static int proc_scsi_host_open(struct inode *inode, struct file *file)
>   struct proc_dir_entry *
>   scsi_template_proc_dir(const struct scsi_host_template *sht)
>   {
> -	return sht->proc_dir;
> +	struct scsi_proc_entry *e = scsi_lookup_proc_entry(sht);
> +
> +	return e ? e->proc_dir : NULL;
>   }
>   EXPORT_SYMBOL_GPL(scsi_template_proc_dir);
>   
> @@ -109,34 +152,57 @@ static const struct proc_ops proc_scsi_ops = {
>    * Sets sht->proc_dir to the new directory.
>    */
>   
> -void scsi_proc_hostdir_add(struct scsi_host_template *sht)
> +void scsi_proc_hostdir_add(const struct scsi_host_template *sht)
>   {
> +	struct scsi_proc_entry *e;
> +
>   	if (!sht->show_info)
>   		return;
>   
>   	mutex_lock(&global_host_template_mutex);
> -	if (!sht->present++) {
> -		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
> -        	if (!sht->proc_dir)
> -			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
> -			       __func__, sht->proc_name);
> +	e = __scsi_lookup_proc_entry(sht);
> +	if (!e) {
> +		e = kzalloc(sizeof(*e), GFP_KERNEL);


So this following scenario is safe, right?

1. host0 calls scsi_proc_hostdir_add() but alloc here fails
2. host1 calls scsi_proc_hostdir_add() but alloc passes, so e->present = 1
3. host0 calls scsi_proc_hostdir_rm(), so e->present goes to zero and we 
dealloc the scsi_proc_entry
4. host1 calls scsi_proc_hostdir_rm(), but does not find the 
scsi_proc_entry and returns

I suppose the only problem is that we try to free the procfs dir but 
host1 still has a procfs entry after 3

I just wonder why we can't make scsi_alloc_alloc() -> 
scsi_proc_hostdir_add() error, i.e. return an error code in this 
function - it would seem to make things simpler

> +		if (!e)
> +			goto unlock;
>   	}
> +	if (e->present++) {
> +		e = NULL;
> +		goto unlock;
> +	}
> +	e->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
> +	if (!e->proc_dir) {
> +		printk(KERN_ERR "%s: proc_mkdir failed for %s\n", __func__,
> +		       sht->proc_name);
> +		e->present--;

I don't see why we decrement e->present and then free e

> +		goto unlock;
> +	}
> +	e->sht = sht;
> +	list_add_tail(&e->entry, &scsi_proc_list);
> +	e = NULL;
> +unlock:
>   	mutex_unlock(&global_host_template_mutex);
> +
> +	kfree(e);
>   }
>   
>   /**
>    * scsi_proc_hostdir_rm - remove directory in /proc for a scsi host
>    * @sht: owner of directory
>    */
> -void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
> +void scsi_proc_hostdir_rm(const struct scsi_host_template *sht)
>   {
> +	struct scsi_proc_entry *e;
> +
>   	if (!sht->show_info)
>   		return;
>   
>   	mutex_lock(&global_host_template_mutex);
> -	if (!--sht->present && sht->proc_dir) {
> +	e = __scsi_lookup_proc_entry(sht);
> +	if (e && !--e->present) {
>   		remove_proc_entry(sht->proc_name, proc_scsi);
> -		sht->proc_dir = NULL;
> +		list_del(&e->entry);
> +		kfree(e);
>   	}
>   	mutex_unlock(&global_host_template_mutex);
>   }
> @@ -148,16 +214,21 @@ void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
>    */
>   void scsi_proc_host_add(struct Scsi_Host *shost)
>   {
> -	struct scsi_host_template *sht = shost->hostt;
> +	const struct scsi_host_template *sht = shost->hostt;
> +	struct scsi_proc_entry *e;
>   	struct proc_dir_entry *p;
>   	char name[10];
>   
> -	if (!sht->proc_dir)
> +	if (!sht->show_info)
> +		return;
> +
> +	e = scsi_lookup_proc_entry(sht);
> +	if (!e)
>   		return;
>   
>   	sprintf(name,"%d", shost->host_no);
> -	p = proc_create_data(name, S_IRUGO | S_IWUSR,
> -		sht->proc_dir, &proc_scsi_ops, shost);
> +	p = proc_create_data(name, S_IRUGO | S_IWUSR, e->proc_dir,
> +			     &proc_scsi_ops, shost);
>   	if (!p)
>   		printk(KERN_ERR "%s: Failed to register host %d in"
>   		       "%s\n", __func__, shost->host_no,
> @@ -170,13 +241,19 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
>    */
>   void scsi_proc_host_rm(struct Scsi_Host *shost)
>   {
> +	const struct scsi_host_template *sht = shost->hostt;
> +	struct scsi_proc_entry *e;
>   	char name[10];
>   
> -	if (!shost->hostt->proc_dir)
> +	if (!sht->show_info)
> +		return;
> +
> +	e = scsi_lookup_proc_entry(sht);
> +	if (!e)
>   		return;
>   
>   	sprintf(name,"%d", shost->host_no);
> -	remove_proc_entry(name, shost->hostt->proc_dir);
> +	remove_proc_entry(name, e->proc_dir);
>   }
>   /**
>    * proc_print_scsidevice - return data about this host
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 030faca947d2..fb8184d87384 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -357,12 +357,6 @@ struct scsi_host_template {
>   	 */
>   	const char *proc_name;
>   
> -	/*
> -	 * Used to store the procfs directory if a driver implements the
> -	 * show_info method.
> -	 */
> -	struct proc_dir_entry *proc_dir;
> -
>   	/*
>   	 * This determines if we will use a non-interrupt driven
>   	 * or an interrupt driven scheme.  It is set to the maximum number
> @@ -423,12 +417,6 @@ struct scsi_host_template {
>   	 */
>   	short cmd_per_lun;
>   
> -	/*
> -	 * present contains counter indicating how many boards of this
> -	 * type were found when we did the scan.
> -	 */
> -	unsigned char present;
> -
>   	/* If use block layer to manage tags, this is tag allocation policy */
>   	int tag_alloc_policy;
>   
> 
> .

