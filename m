From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH v6 2/2] tcmu: Add global data block pool support
Date: Sun, 30 Apr 2017 19:29:08 +0800
Message-ID: <25e7247f-116f-aaa5-e895-b503c0a893f9@cmss.chinamobile.com>
References: <1493187952-13125-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1493187952-13125-3-git-send-email-lixiubo@cmss.chinamobile.com>
 <590592D4.8090607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:14076 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbdD3L3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Apr 2017 07:29:17 -0400
In-Reply-To: <590592D4.8090607@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, nab@linux-iscsi.org
Cc: agrover@redhat.com, iliastsi@arrikto.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>

[...]

>> +
>> +static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
>> +				  struct tcmu_cmd *tcmu_cmd,
>> +				  uint32_t blocks_needed)
>
> Can drop blocks_needed.
>
Will fix it.

[...]
>>   
>> -static void *tcmu_get_block_addr(struct tcmu_dev *udev, uint32_t dbi)
>> +static inline struct page *
>> +tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
>>   {
>>   	return radix_tree_lookup(&udev->data_blocks, dbi);
>>   }
>> @@ -365,17 +417,20 @@ static int alloc_and_scatter_data_area(struct tcmu_dev *udev,
>
> We don't actually alloc the area here any more. Could probably rename
> it to be similar to gather_data_area.
>
Yes, will rename to scatter_data_area.

[...]
>
>> @@ -616,6 +711,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
>>   			&iov, &iov_cnt, copy_to_data_area);
>>   	if (ret) {
>>   		pr_err("tcmu: alloc and scatter data failed\n");
>> +		mutex_unlock(&udev->cmdr_lock);
>
> I think here and in the error case below, you need to do a
> tcmu_cmd_free_data.
>
Yes, good catch, and the tcmu_cmd_free_data is needed here to free the 
bits in udev->data_bitmap.
And the unlock will be added in the first patch.

[...]
>> +static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
>> +{
>> +	struct page *page;
>> +	int ret;
>> +
>> +	mutex_lock(&udev->cmdr_lock);
>> +	page = tcmu_get_block_page(udev, dbi);
>> +	if (likely(page)) {
>> +		mutex_unlock(&udev->cmdr_lock);
>> +		return page;
>> +	}
>> +
>> +	/*
>> +	 * Normally it shouldn't be here:
>> +	 * Only when the userspace has touched the blocks which
>> +	 * are out of the tcmu_cmd's data iov[], and will return
>> +	 * one zeroed page.
>
> Is it a userspace bug when this happens? Do you know when it is occcuring?
Since the UIO will map the whole ring buffer to the user space at the 
beginning, and the userspace is allowed and legal to access any block 
within the limits of the mapped ring area.

But actually when this happens, it normally will be one bug of the 
userspace. Without this checking the kernel will output many page fault 
dump traces.

Maybe here outputing some warning message is a good idea, and will be 
easy to debug for userspace.


[...]
>> @@ -1388,6 +1509,81 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
>>   	.tb_dev_attrib_attrs	= NULL,
>>   };
>>   
>> +static int unmap_thread_fn(void *data)
>> +{
>> +	struct tcmu_dev *udev;
>> +	loff_t off;
>> +	uint32_t start, end, block;
>> +	struct page *page;
>> +	int i;
>> +
>> +	while (1) {
>> +		DEFINE_WAIT(__wait);
>> +
>> +		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
>> +		schedule();
>> +		finish_wait(&unmap_wait, &__wait);
>> +
>> +		mutex_lock(&root_udev_mutex);
>> +		list_for_each_entry(udev, &root_udev, node) {
>> +			mutex_lock(&udev->cmdr_lock);
>> +
>> +			/* Try to complete the finished commands first */
>> +			tcmu_handle_completions(udev);
>> +
>> +			/* Skip the udevs waiting the global pool or in idle */
>> +			if (udev->waiting_global || !udev->dbi_thresh) {
>> +				mutex_unlock(&udev->cmdr_lock);
>> +				continue;
>> +			}
>> +
>> +			end = udev->dbi_max + 1;
>> +			block = find_last_bit(udev->data_bitmap, end);
>> +			if (block == udev->dbi_max) {
>> +				/*
>> +				 * The last bit is dbi_max, so there is
>> +				 * no need to shrink any blocks.
>> +				 */
>> +				mutex_unlock(&udev->cmdr_lock);
>> +				continue;
>> +			} else if (block == end) {
>> +				/* The current udev will goto idle state */
>> +				udev->dbi_thresh = start = 0;
>> +				udev->dbi_max = 0;
>> +			} else {
>> +				udev->dbi_thresh = start = block + 1;
>> +				udev->dbi_max = block;
>> +			}
>> +
>> +			/* Here will truncate the data area from off */
>> +			off = udev->data_off + start * DATA_BLOCK_SIZE;
>> +			unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
>> +
>> +			/* Release the block pages */
>> +			for (i = start; i < end; i++) {
>> +				page = radix_tree_delete(&udev->data_blocks, i);
>> +				if (page) {
>> +					__free_page(page);
>> +					atomic_dec(&global_db_count);
>> +				}
>> +			}
>> +			mutex_unlock(&udev->cmdr_lock);
>> +		}
>> +
>> +		/*
>> +		 * Try to wake up the udevs who are waiting
>> +		 * for the global data pool.
>> +		 */
>> +		list_for_each_entry(udev, &root_udev, node) {
>> +			if (udev->waiting_global)
>> +				wake_up(&udev->wait_cmdr);
>> +		}
>
> To avoid starvation, I think you want a second list/fifo that holds the
> watiers. In tcmu_get_empty_block if the list is not empty, record how
> many pages we needed and then add the device to the list and wait in
> tcmu_queue_cmd_ring.
>
> Above if we freed enough pages for the device at head then wake up the
> device.
>
> I think you also need a wake_up call in the completion path in case the
> initial call could not free enough pages. It could probably check if the
> completion was going to free enough pages for a waiter and then call wake.
>
Yes, I meant to introduce this later after this series to not let the 
patches too
complex to review.

If you agree I will do this later, or in V7 series ?

>> +		mutex_unlock(&root_udev_mutex);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int __init tcmu_module_init(void)
>>   {
>>   	int ret, i, len = 0;
>> @@ -1433,8 +1629,17 @@ static int __init tcmu_module_init(void)
>>   	if (ret)
>>   		goto out_attrs;
>>   
>> +	init_waitqueue_head(&unmap_wait);
>> +	unmap_thread = kthread_run(unmap_thread_fn, NULL, "tcmu_unmap");
>> +	if (IS_ERR(unmap_thread)) {
>> +		unmap_thread = NULL;
> No need to set unmap_thread to NULL since nothing will ever see it
> again. You should set ret to an error value so module_init is failed
> properly:
>
> ret = PTR_ERR(unmap_thread);
>
>
Will fix it.

>> +		goto out_unreg_transport;
>> +	}
>> +
>>   	return 0;
>>   
>> +out_unreg_transport:
>> +	target_backend_unregister(&tcmu_ops);
>>   out_attrs:
>>   	kfree(tcmu_attrs);
>>   out_unreg_genl:
>> @@ -1449,6 +1654,9 @@ static int __init tcmu_module_init(void)
>>   
>>   static void __exit tcmu_module_exit(void)
>>   {
>> +	if (unmap_thread)
>
> The module exit will only be called if init succeeded so you can drop
> the check.
Will fix it.

Thank very much,

BRs
Xiubo

>> +		kthread_stop(unmap_thread);
>> +
>>   	target_backend_unregister(&tcmu_ops);
>>   	kfree(tcmu_attrs);
>>   	genl_unregister_family(&tcmu_genl_family);
>>
