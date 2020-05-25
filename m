Return-Path: <SRS0=b1yV=7H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FFDC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 06:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C417206DD
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 06:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388904AbgEYG5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 02:57:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:41082 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388630AbgEYG5T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 May 2020 02:57:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51546ABCE;
        Mon, 25 May 2020 06:57:18 +0000 (UTC)
Subject: Re: [RFC v2 1/6] scsi: xarray hctl
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kbuild test robot <lkp@intel.com>
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-2-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6527a0ca-954c-70e8-f0f5-08206c1779f2@suse.de>
Date:   Mon, 25 May 2020 08:57:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200524155814.5895-2-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/20 5:58 PM, Douglas Gilbert wrote:
> Replace three linked lists with xarrays:
>    - Scsi_Host::__devices  collection of scsi_device objects
>    - Scsi_Host::__targets  collection of scsi_target objects
>    - scsi_target::devices  collection of scsi_device objects that
>      belong to this target
> 
> The collection of Scsi_Host objects remains unaltered. It uses the
> idr/ida mechanism which already uses xarrays in its implementation.
> 
> Add a scsi_target::parent_shost pointer for direct access to a
> target's host since the oft called dev_to_shost() needs to loop through
> any intermediate (transport supplied) objects between a target and its
> parent host. Add a new, trivial access function: starg_to_shost() and
> thus allow calls to dev_to_shost(starg->dev.parent) to be replaced
> with starg_to_shost(starg). Use this faster replacement in mid-level
> source and in an inline function defined in scsi_transport.h .
> 
> Against the advice in scsi_devices.h and scsi_host.h this file:
> drivers/target/target_core_pscsi.c uses Scsi_Host::__devices directly
> and needs a minimal change to allow it to compile and work in the
> same fashion.
> 
> xarray technical info: all three xarrays are initialized with
> XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ flags. When XA_FLAGS_ALLOC is used
> a xarray allocates unique index numbers and uses one of the 3 available
> marks to manage that allocation. So there are two marks remaining and
> they are currently unused. The LOCK_IRQ flags means it calls
> spin_lock_irq() internally on xarray modifying operations. xarray
> non-modifying operations use the rcu lock.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/hosts.c               |  8 +++--
>   drivers/scsi/scsi.c                | 43 +++++++++++++++--------
>   drivers/scsi/scsi_lib.c            |  8 ++---
>   drivers/scsi/scsi_scan.c           | 48 +++++++++++++++++--------
>   drivers/scsi/scsi_sysfs.c          | 41 +++++++++++++++-------
>   drivers/target/target_core_pscsi.c |  2 +-
>   include/scsi/scsi_device.h         | 56 +++++++++++++++++++++++++-----
>   include/scsi/scsi_host.h           | 12 ++++---
>   include/scsi/scsi_transport.h      |  3 +-
>   9 files changed, 158 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 7ec91c3a66ca..2bba293a497d 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -345,6 +345,8 @@ static void scsi_host_dev_release(struct device *dev)
>   
>   	if (parent)
>   		put_device(parent);
> +	xa_destroy(&shost->__targets);
> +	xa_destroy(&shost->__devices);
>   	kfree(shost);
>   }
>   
> @@ -382,8 +384,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>   	shost->host_lock = &shost->default_lock;
>   	spin_lock_init(shost->host_lock);
>   	shost->shost_state = SHOST_CREATED;
> -	INIT_LIST_HEAD(&shost->__devices);
> -	INIT_LIST_HEAD(&shost->__targets);
> +	xa_init_flags(&shost->__devices, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
> +	xa_init_flags(&shost->__targets, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
>   	INIT_LIST_HEAD(&shost->eh_cmd_q);
>   	INIT_LIST_HEAD(&shost->starved_list);
>   	init_waitqueue_head(&shost->host_wait);
> @@ -502,6 +504,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>    fail_index_remove:
>   	ida_simple_remove(&host_index_ida, shost->host_no);
>    fail_kfree:
> +	xa_destroy(&shost->__targets);
> +	xa_destroy(&shost->__devices);
>   	kfree(shost);
>   	return NULL;
>   }
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 56c24a73e0c7..61aa68083f67 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -554,19 +554,32 @@ EXPORT_SYMBOL(scsi_device_put);
>   struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
>   					   struct scsi_device *prev)
>   {
> -	struct list_head *list = (prev ? &prev->siblings : &shost->__devices);
> -	struct scsi_device *next = NULL;
> -	unsigned long flags;
> +	struct scsi_device *next = prev;
> +	unsigned long flags, l_idx;
>   
>   	spin_lock_irqsave(shost->host_lock, flags);
> -	while (list->next != &shost->__devices) {
> -		next = list_entry(list->next, struct scsi_device, siblings);
> -		/* skip devices that we can't get a reference to */
> -		if (!scsi_device_get(next))
> -			break;
> +	if (xa_empty(&shost->__devices)) {
>   		next = NULL;
> -		list = list->next;
> +		goto unlock;
>   	}
> +	do {
> +		if (!next) {	/* get first element iff first iteration */
> +			l_idx = 0;
> +			next = xa_find(&shost->__devices, &l_idx,
> +				       scsi_xa_limit_16b.max, XA_PRESENT);
> +		} else {
> +			l_idx = next->sh_idx,
> +			next = xa_find_after(&shost->__devices, &l_idx,
> +					     scsi_xa_limit_16b.max,
> +					     XA_PRESENT);
> +		}
> +		if (next) {
> +			/* skip devices that we can't get a reference to */
> +			if (!scsi_device_get(next))
> +				break;
> +		}
> +	} while (next);
> +unlock:
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   
>   	if (prev)
This one is patently ugly.

Why not kill __scsi_iterate_devices() and use xa_for_each() on each call 
site?

> @@ -588,7 +601,7 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
>   void starget_for_each_device(struct scsi_target *starget, void *data,
>   		     void (*fn)(struct scsi_device *, void *))
>   {
> -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	struct Scsi_Host *shost = starg_to_shost(starget);
>   	struct scsi_device *sdev;
>   
>   	shost_for_each_device(sdev, shost) {

See comment above.

> @@ -616,7 +629,7 @@ EXPORT_SYMBOL(starget_for_each_device);
>   void __starget_for_each_device(struct scsi_target *starget, void *data,
>   			       void (*fn)(struct scsi_device *, void *))
>   {
> -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	struct Scsi_Host *shost = starg_to_shost(starget);
>   	struct scsi_device *sdev;
>   
>   	__shost_for_each_device(sdev, shost) {

Same here.

> @@ -645,9 +658,10 @@ EXPORT_SYMBOL(__starget_for_each_device);
>   struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
>   						   u64 lun)
>   {
> +	unsigned long l_idx;
>   	struct scsi_device *sdev;
>   
> -	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
> +	xa_for_each(&starget->devices, l_idx, sdev) {
>   		if (sdev->sdev_state == SDEV_DEL)
>   			continue;
>   		if (sdev->lun ==lun)
> @@ -671,7 +685,7 @@ struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
>   						 u64 lun)
>   {
>   	struct scsi_device *sdev;
> -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	struct Scsi_Host *shost = starg_to_shost(starget);
>   	unsigned long flags;
>   
>   	spin_lock_irqsave(shost->host_lock, flags);
> @@ -703,9 +717,10 @@ EXPORT_SYMBOL(scsi_device_lookup_by_target);
>   struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
>   		uint channel, uint id, u64 lun)
>   {
> +	unsigned long l_idx;
>   	struct scsi_device *sdev;
>   
> -	list_for_each_entry(sdev, &shost->__devices, siblings) {
> +	xa_for_each(&shost->__devices, l_idx, sdev) {
>   		if (sdev->sdev_state == SDEV_DEL)
>   			continue;
>   		if (sdev->channel == channel && sdev->id == id &&
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 47835c4b4ee0..68df68f54fc8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -372,9 +372,9 @@ static void scsi_kick_queue(struct request_queue *q)
>   static void scsi_single_lun_run(struct scsi_device *current_sdev)
>   {
>   	struct Scsi_Host *shost = current_sdev->host;
> -	struct scsi_device *sdev, *tmp;
> +	struct scsi_device *sdev;
>   	struct scsi_target *starget = scsi_target(current_sdev);
> -	unsigned long flags;
> +	unsigned long flags, l_idx;
>   
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	starget->starget_sdev_user = NULL;
> @@ -391,8 +391,8 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	if (starget->starget_sdev_user)
>   		goto out;
> -	list_for_each_entry_safe(sdev, tmp, &starget->devices,
> -			same_target_siblings) {
> +	/* XARRAY: was list_for_each_entry_safe(); is this safe ? */
> +	xa_for_each(&starget->devices, l_idx, sdev) {
>   		if (sdev == current_sdev)
>   			continue;
>   		if (scsi_device_get(sdev))

Frankly, I don't know why we're using the _safe variant here.
Typically the _safe variant is used to protect against removal
(ie if a list element is removed while iterating over the list),
but I can't really imagine why starting I/O on the device would
cause one entry to be deleted...
James?

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f2437a7570ce..b8f5850c5a04 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -217,7 +217,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   {
>   	struct scsi_device *sdev;
>   	int display_failure_msg = 1, ret;
> -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	struct Scsi_Host *shost = starg_to_shost(starget);
>   
>   	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
>   		       GFP_KERNEL);

This is actually a cleanup in itself :-)

> @@ -234,8 +234,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   	sdev->channel = starget->channel;
>   	mutex_init(&sdev->state_mutex);
>   	sdev->sdev_state = SDEV_CREATED;
> -	INIT_LIST_HEAD(&sdev->siblings);
> -	INIT_LIST_HEAD(&sdev->same_target_siblings);
> +	/* XARRAY: INIT_LIST_HEAD()s here on list leaves, why ? */
> +	sdev->sh_idx = -1;
> +	sdev->starg_idx = -1;		/* for debugging */
>   	INIT_LIST_HEAD(&sdev->starved_entry);
>   	INIT_LIST_HEAD(&sdev->event_list);
>   	spin_lock_init(&sdev->list_lock);

It is good practice to call INIT_LIST_HEAD() on list leaves as then you 
can call 'list_empty()' to figure out if they are part of a list or not.

But I'm wondering about the 'sh_idx' and the 'starg_idx' here.
We already have perfectly good indices with the 'lun' and 'id' entries 
in struct scsi_device, which (incidentally) _need_ to be unique.

So why not use them?

> @@ -306,8 +307,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   
>   static void scsi_target_destroy(struct scsi_target *starget)
>   {
> +	struct scsi_target *e_starg;
>   	struct device *dev = &starget->dev;
> -	struct Scsi_Host *shost = dev_to_shost(dev->parent);
> +	struct Scsi_Host *shost = starg_to_shost(starget);
>   	unsigned long flags;
>   
>   	BUG_ON(starget->state == STARGET_DEL);
> @@ -316,7 +318,10 @@ static void scsi_target_destroy(struct scsi_target *starget)
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	if (shost->hostt->target_destroy)
>   		shost->hostt->target_destroy(starget);
> -	list_del_init(&starget->siblings);
> +	/* XARRAY: was list_del_init(); why the _init ?  */
> +	e_starg = xa_erase(&shost->__targets, starget->sh_idx);
> +	if (e_starg != starget)
> +		pr_err("%s: bad xa_erase()\n", __func__);
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   	put_device(dev);
>   }
See above for my comment about INIT_LIST_HEAD().
Calling list_del_init() will reset the 'siblings' entry such that 
list_empty() returns true.

> @@ -326,6 +331,7 @@ static void scsi_target_dev_release(struct device *dev)
>   	struct device *parent = dev->parent;
>   	struct scsi_target *starget = to_scsi_target(dev);
>   
> +	xa_destroy(&starget->devices);
>   	kfree(starget);
>   	put_device(parent);
>   }
> @@ -344,12 +350,13 @@ EXPORT_SYMBOL(scsi_is_target_device);
>   static struct scsi_target *__scsi_find_target(struct device *parent,
>   					      int channel, uint id)
>   {
> +	unsigned long l_idx;
>   	struct scsi_target *starget, *found_starget = NULL;
>   	struct Scsi_Host *shost = dev_to_shost(parent);
>   	/*
> -	 * Search for an existing target for this sdev.
> +	 * Search for an existing target for this host.
>   	 */
> -	list_for_each_entry(starget, &shost->__targets, siblings) {
> +	xa_for_each(&shost->__targets, l_idx, starget) {
>   		if (starget->id == id &&
>   		    starget->channel == channel) {
>   			found_starget = starget; > @@ -412,6 +419,8 @@ static struct scsi_target 
*scsi_alloc_target(struct device *parent,
>   	struct Scsi_Host *shost = dev_to_shost(parent);
>   	struct device *dev = NULL;
>   	unsigned long flags;
> +	unsigned int u_idx;
> +	int res;
>   	const int size = sizeof(struct scsi_target)
>   		+ shost->transportt->target_size;
>   	struct scsi_target *starget;
> @@ -427,14 +436,15 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
>   	device_initialize(dev);
>   	kref_init(&starget->reap_ref);
>   	dev->parent = get_device(parent);
> +	starget->parent_shost = shost;
>   	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
>   	dev->bus = &scsi_bus_type;
>   	dev->type = &scsi_target_type;
>   	starget->id = id;
>   	starget->channel = channel;
>   	starget->can_queue = 0;
> -	INIT_LIST_HEAD(&starget->siblings);
> -	INIT_LIST_HEAD(&starget->devices);
> +	xa_init_flags(&starget->devices, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
> +	starget->sh_idx = -1;		/* debugging */
>   	starget->state = STARGET_CREATED;
>   	starget->scsi_level = SCSI_2;
>   	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;

Why do you need the parent_shost pointer?
That's precisely the point of the starget_to_shost() accessor; the shost 
device must be part of the parent chain, so we just need to follow it.
And it's not really performance-critical, either...

> @@ -445,7 +455,15 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
>   	if (found_target)
>   		goto found;
>   
> -	list_add_tail(&starget->siblings, &shost->__targets);
> +	/* XARRAY: was list_add_tail(); may get hole in xarray or tail */
> +	res = xa_alloc(&shost->__targets, &u_idx, starget, scsi_xa_limit_16b,
> +		       GFP_ATOMIC);
> +	if (res < 0) {
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		pr_err("%s: xa_alloc failure errno=%d\n", __func__, -res);
> +		return NULL;
> +	}
> +	starget->sh_idx = u_idx;
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   	/* allocate and add */
>   	transport_setup_device(dev);

'scsi_xa_limit_16b' ?
What's that for?
And, again, if we were to use the target id as an index we could be 
using 'xa_store' and the problem would be solved...

> @@ -1049,7 +1067,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   	unsigned char *result;
>   	blist_flags_t bflags;
>   	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
> -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	struct Scsi_Host *shost = starg_to_shost(starget);
>   
>   	/*
>   	 * The rescan flag is used as an optimization, the first scan of a
> @@ -1199,7 +1217,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
>   {
>   	uint max_dev_lun;
>   	u64 sparse_lun, lun;
> -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	struct Scsi_Host *shost = starg_to_shost(starget);
>   
>   	SCSI_LOG_SCAN_BUS(3, starget_printk(KERN_INFO, starget,
>   		"scsi scan: Sequential scan\n"));
> @@ -1297,7 +1315,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
>   	struct scsi_lun *lunp, *lun_data;
>   	struct scsi_sense_hdr sshdr;
>   	struct scsi_device *sdev;
> -	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	struct Scsi_Host *shost = starg_to_shost(starget);
>   	int ret = 0;
>   
>   	/*
> @@ -1860,11 +1878,11 @@ EXPORT_SYMBOL(scsi_scan_host);
>   void scsi_forget_host(struct Scsi_Host *shost)
>   {
>   	struct scsi_device *sdev;
> -	unsigned long flags;
> +	unsigned long flags, l_idx;
>   
>    restart:
>   	spin_lock_irqsave(shost->host_lock, flags);
> -	list_for_each_entry(sdev, &shost->__devices, siblings) {
> +	xa_for_each(&shost->__devices, l_idx, sdev) {
>   		if (sdev->sdev_state == SDEV_DEL)
>   			continue;
>   		spin_unlock_irqrestore(shost->host_lock, flags);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 163dbcb741c1..4bfcf33139a2 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -433,7 +433,7 @@ static void scsi_device_cls_release(struct device *class_dev)
>   
>   static void scsi_device_dev_release_usercontext(struct work_struct *work)
>   {
> -	struct scsi_device *sdev;
> +	struct scsi_device *sdev, *e_sdev;
>   	struct device *parent;
>   	struct list_head *this, *tmp;
>   	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
> @@ -447,8 +447,12 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>   	parent = sdev->sdev_gendev.parent;
>   
>   	spin_lock_irqsave(sdev->host->host_lock, flags);
> -	list_del(&sdev->siblings);
> -	list_del(&sdev->same_target_siblings);
> +	e_sdev = xa_erase(&sdev->host->__devices, sdev->sh_idx);
> +	if (e_sdev != sdev)
> +		pr_err("%s: bad xa_erase(host:__devices)\n", __func__);
> +	e_sdev = xa_erase(&sdev->sdev_target->devices, sdev->starg_idx);
> +	if (e_sdev != sdev)
> +		pr_err("%s: bad xa_erase(sdev_target->devices)\n", __func__);
>   	list_del(&sdev->starved_entry);
>   	spin_unlock_irqrestore(sdev->host->host_lock, flags);
>   

Oh yeah, these double lists. I really wonder if we shouldn't do away 
with one of them (presumably the starget device list), and iterate over 
the shost device list with the starget filter instead.

> @@ -1471,22 +1475,19 @@ EXPORT_SYMBOL(scsi_remove_device);
>   
>   static void __scsi_remove_target(struct scsi_target *starget)
>   {
> -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> -	unsigned long flags;
> +	struct Scsi_Host *shost = starg_to_shost(starget);
>   	struct scsi_device *sdev;
> +	unsigned long flags, l_idx;
>   
>   	spin_lock_irqsave(shost->host_lock, flags);
>    restart:
> -	list_for_each_entry(sdev, &shost->__devices, siblings) {
> +	xa_for_each(&starget->devices, l_idx, sdev) {
>   		/*
>   		 * We cannot call scsi_device_get() here, as
>   		 * we might've been called from rmmod() causing
>   		 * scsi_device_get() to fail the module_is_live()
>   		 * check.
>   		 */
> -		if (sdev->channel != starget->channel ||
> -		    sdev->id != starget->id)
> -			continue;
>   		if (sdev->sdev_state == SDEV_DEL ||
>   		    sdev->sdev_state == SDEV_CANCEL ||
>   		    !get_device(&sdev->sdev_gendev))
> @@ -1495,6 +1496,7 @@ static void __scsi_remove_target(struct scsi_target *starget)
>   		scsi_remove_device(sdev);
>   		put_device(&sdev->sdev_gendev);
>   		spin_lock_irqsave(shost->host_lock, flags);
> +		/* XARRAY: is this goto start of loop correct ? */
>   		goto restart;
>   	}
>   	spin_unlock_irqrestore(shost->host_lock, flags);
This is a very convoluted way of _not_ using list_for_each_safe() ;-)
(James will probably telling me off as I'm missing the intricacies here)
But again, the prime reason for the goto here is that we're removing an 
element from the list, and need to ensure list consistency as we want to 
iterate across all devices and remove each of them.

So no need for that complicated loop; xa_for_each() and xa_erase() on 
each element should be sufficient.

> @@ -1512,11 +1514,11 @@ void scsi_remove_target(struct device *dev)
>   {
>   	struct Scsi_Host *shost = dev_to_shost(dev->parent);
>   	struct scsi_target *starget;
> -	unsigned long flags;
> +	unsigned long flags, l_idx;
>   
>   restart:
>   	spin_lock_irqsave(shost->host_lock, flags);
> -	list_for_each_entry(starget, &shost->__targets, siblings) {
> +	xa_for_each(&shost->__targets, l_idx, starget) {
>   		if (starget->state == STARGET_DEL ||
>   		    starget->state == STARGET_REMOVE ||
>   		    starget->state == STARGET_CREATED_REMOVE)
> @@ -1584,6 +1586,8 @@ static struct device_type scsi_dev_type = {
>   
>   void scsi_sysfs_device_initialize(struct scsi_device *sdev)
>   {
> +	int res;
> +	unsigned int u_idx;
>   	unsigned long flags;
>   	struct Scsi_Host *shost = sdev->host;
>   	struct scsi_target  *starget = sdev->sdev_target;
> @@ -1614,8 +1618,19 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
>   
>   	transport_setup_device(&sdev->sdev_gendev);
>   	spin_lock_irqsave(shost->host_lock, flags);
> -	list_add_tail(&sdev->same_target_siblings, &starget->devices);
> -	list_add_tail(&sdev->siblings, &shost->__devices);
> +	/* XARRAY: might add in hole */
> +	res = xa_alloc(&starget->devices, &u_idx, sdev, scsi_xa_limit_16b,
> +		       GFP_ATOMIC);
> +	if (res < 0)
> +		pr_err("%s: xa_alloc 1 failure errno=%d\n", __func__, -res);
> +	else
> +		sdev->starg_idx = u_idx;
> +	res = xa_alloc(&shost->__devices, &u_idx, sdev, scsi_xa_limit_16b,
> +		       GFP_ATOMIC);
> +	if (res < 0)
> +		pr_err("%s: xa_alloc 2 failure errno=%d\n", __func__, -res);
> +	else
> +		sdev->sh_idx = u_idx;
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   	/*
>   	 * device can now only be removed via __scsi_remove_device() so hold
Same here.
While LUNs are 64-bit, I've yet to come across a target leveraging the 
full 64 bit range. Plus for most arrays the number of LUNs per host is 
capped to 255 anyway.
Hence I guess we should be okay with using the LUN as an index into the 
xarray. If we ever get a real 64-LUN we can stuff them into the unused 
areas of the LUN range, eg by using the single-level LUN structure with 
LUNs above 256.

> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index c9d92b3e777d..8547fc9ec344 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -496,7 +496,7 @@ static int pscsi_configure_device(struct se_device *dev)
>   	}
>   
>   	spin_lock_irq(sh->host_lock);
> -	list_for_each_entry(sd, &sh->__devices, siblings) {
> +	__shost_for_each_device(sd, sh) {
>   		if ((pdv->pdv_channel_id != sd->channel) ||
>   		    (pdv->pdv_target_id != sd->id) ||
>   		    (pdv->pdv_lun_id != sd->lun))
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index c3cba2aaf934..dc9de4cc0e79 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -7,7 +7,9 @@
>   #include <linux/workqueue.h>
>   #include <linux/blkdev.h>
>   #include <scsi/scsi.h>
> +#include <scsi/scsi_host.h>
>   #include <linux/atomic.h>
> +#include <linux/xarray.h>
>   
>   struct device;
>   struct request_queue;
> @@ -103,8 +105,8 @@ struct scsi_device {
>   	struct request_queue *request_queue;
>   
>   	/* the next two are protected by the host->host_lock */
> -	struct list_head    siblings;   /* list of all devices on this host */
> -	struct list_head    same_target_siblings; /* just the devices sharing same target id */
> +	int sh_idx;		/* index within host->__devices array */
> +	int starg_idx;		/* index within sdev_target->devices array */
>   
>   	atomic_t device_busy;		/* commands actually active on LLDD */
>   	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
> @@ -281,16 +283,18 @@ enum scsi_target_state {
>    * scsi_target: representation of a scsi target, for now, this is only
>    * used for single_lun devices. If no one has active IO to the target,
>    * starget_sdev_user is NULL, else it points to the active sdev.
> + * Invariant: starg->parent_shost == dev_to_shost(starg->dev.parent)
>    */
>   struct scsi_target {
>   	struct scsi_device	*starget_sdev_user;
> -	struct list_head	siblings;
> -	struct list_head	devices;
> -	struct device		dev;
> +	struct Scsi_Host	*parent_shost;
> +	int			sh_idx;	/* index within Scsi_Host::__targets */
>   	struct kref		reap_ref; /* last put renders target invisible */
>   	unsigned int		channel;
>   	unsigned int		id; /* target id ... replace
>   				     * scsi_device.id eventually */
> +	struct xarray devices;	/* scsi_device objects owned by this target */
> +	struct device		dev;
>   	unsigned int		create:1; /* signal that it needs to be added */
>   	unsigned int		single_lun:1;	/* Indicates we should only
>   						 * allow I/O to one of the luns
> @@ -329,6 +333,11 @@ static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
>   #define transport_class_to_starget(class_dev) \
>   	to_scsi_target(class_dev->parent)
>   
> +static inline struct Scsi_Host *starg_to_shost(struct scsi_target *starg)
> +{
> +	return starg->parent_shost;
> +}
> +
>   #define starget_printk(prefix, starget, fmt, a...)	\
>   	dev_printk(prefix, &(starget)->dev, fmt, ##a)
>   
> @@ -365,7 +374,7 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
>   /**
>    * shost_for_each_device - iterate over all devices of a host
>    * @sdev: the &struct scsi_device to use as a cursor
> - * @shost: the &struct scsi_host to iterate over
> + * @shost: the &struct Scsi_Host to iterate over
>    *
>    * Iterator that returns each device attached to @shost.  This loop
>    * takes a reference on each device and releases it at the end.  If
> @@ -376,21 +385,50 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
>   	     (sdev); \
>   	     (sdev) = __scsi_iterate_devices((shost), (sdev)))
>   
> +/* helper for __shost_for_each_device */
> +static inline struct scsi_device *__scsi_h2d_1st_it(struct Scsi_Host *shost)
> +{
> +	unsigned long l_idx = 0;
> +
> +	return xa_find(&shost->__devices, &l_idx, scsi_xa_limit_16b.max,
> +		       XA_PRESENT);
> +}
> +
> +/* helper for __shost_for_each_device */
> +static inline struct scsi_device *__scsi_h2d_next_it(struct Scsi_Host *shost,
> +						     struct scsi_device *prev)
> +{
> +	unsigned long l_idx;
> +
> +	if (prev) {
> +		l_idx = prev->sh_idx,
> +		prev = xa_find_after(&shost->__devices, &l_idx,
> +				     scsi_xa_limit_16b.max, XA_PRESENT);
> +	}
> +	return prev;	/* now either _next_ or NULL */
> +}
> +
>   /**
>    * __shost_for_each_device - iterate over all devices of a host (UNLOCKED)
>    * @sdev: the &struct scsi_device to use as a cursor
> - * @shost: the &struct scsi_host to iterate over
> + * @shost: the &struct Scsi_Host to iterate over
>    *
>    * Iterator that returns each device attached to @shost.  It does _not_
>    * take a reference on the scsi_device, so the whole loop must be
> - * protected by shost->host_lock.
> + * protected by shost->host_lock (see Note 2).
>    *
>    * Note: The only reason to use this is because you need to access the
>    * device list in interrupt context.  Otherwise you really want to use
>    * shost_for_each_device instead.
> + *
> + * Note 2: The iteration won't fail but dereferencing sdev might. To access
> + * the xarray features (e.g. marks) associated with sdev safely use:
> + * xa_for_each(&shost->__devices, l_idx, next) directly then use l_idx.
>    */
>   #define __shost_for_each_device(sdev, shost) \
> -	list_for_each_entry((sdev), &((shost)->__devices), siblings)
> +	for ((sdev) = __scsi_h2d_1st_it((shost)); \
> +	     (sdev); \
> +	     (sdev) = __scsi_h2d_next_it((shost), (sdev)))
>   
>   extern int scsi_change_queue_depth(struct scsi_device *, int);
>   extern int scsi_track_queue_full(struct scsi_device *, int);
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 822e8cda8d9b..e6386f3d6de1 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -9,6 +9,7 @@
>   #include <linux/mutex.h>
>   #include <linux/seq_file.h>
>   #include <linux/blk-mq.h>
> +#include <linux/xarray.h>
>   #include <scsi/scsi.h>
>   
>   struct block_device;
> @@ -29,6 +30,9 @@ struct scsi_transport_template;
>   #define MODE_INITIATOR 0x01
>   #define MODE_TARGET 0x02
>   
> +/* XARRAY: this limits number of devices (LUs) in host to 64K */
> +#define scsi_xa_limit_16b    XA_LIMIT(0, USHRT_MAX)
> +
>   struct scsi_host_template {
>   	struct module *module;
>   	const char *name;
> @@ -233,7 +237,7 @@ struct scsi_host_template {
>   	 * If a host has the ability to discover targets on its own instead
>   	 * of scanning the entire bus, it can fill in this function and
>   	 * call scsi_scan_host().  This function will be called periodically
> -	 * until it returns 1 with the scsi_host and the elapsed time of
> +	 * until it returns 1 with the Scsi_Host and the elapsed time of
>   	 * the scan in jiffies.
>   	 *
>   	 * Status: OPTIONAL
> @@ -520,9 +524,9 @@ struct Scsi_Host {
>   	 * their __ prefixed variants with the lock held. NEVER
>   	 * access this list directly from a driver.
>   	 */
> -	struct list_head	__devices;
> -	struct list_head	__targets;
> -	
> +	struct xarray		__devices;	/* array of scsi_debug objs */
> +	struct xarray		__targets;	/* array of scsi_target objs */
> +
>   	struct list_head	starved_list;
>   
>   	spinlock_t		default_lock;
> diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
> index a0458bda3148..3756b264809a 100644
> --- a/include/scsi/scsi_transport.h
> +++ b/include/scsi/scsi_transport.h
> @@ -70,7 +70,8 @@ scsi_transport_reserve_device(struct scsi_transport_template * t, int space)
>   static inline void *
>   scsi_transport_target_data(struct scsi_target *starget)
>   {
> -	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	struct Scsi_Host *shost = starg_to_shost(starget);
> +
>   	return (u8 *)starget->starget_data
>   		+ shost->transportt->target_private_offset;
>   
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
