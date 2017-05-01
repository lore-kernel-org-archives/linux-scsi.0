From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v6 2/2] tcmu: Add global data block pool support
Date: Mon, 1 May 2017 13:40:32 -0500
Message-ID: <59078120.3000200@redhat.com>
References: <1493187952-13125-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1493187952-13125-3-git-send-email-lixiubo@cmss.chinamobile.com>
 <590592D4.8090607@redhat.com>
 <25e7247f-116f-aaa5-e895-b503c0a893f9@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <25e7247f-116f-aaa5-e895-b503c0a893f9@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: Xiubo Li <lixiubo@cmss.chinamobile.com>, nab@linux-iscsi.org
Cc: agrover@redhat.com, iliastsi@arrikto.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

On 04/30/2017 06:29 AM, Xiubo Li wrote:
> [...]
>>> +static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev,
>>> uint32_t dbi)
>>> +{
>>> +    struct page *page;
>>> +    int ret;
>>> +
>>> +    mutex_lock(&udev->cmdr_lock);
>>> +    page = tcmu_get_block_page(udev, dbi);
>>> +    if (likely(page)) {
>>> +        mutex_unlock(&udev->cmdr_lock);
>>> +        return page;
>>> +    }
>>> +
>>> +    /*
>>> +     * Normally it shouldn't be here:
>>> +     * Only when the userspace has touched the blocks which
>>> +     * are out of the tcmu_cmd's data iov[], and will return
>>> +     * one zeroed page.
>>
>> Is it a userspace bug when this happens? Do you know when it is
>> occcuring?
> Since the UIO will map the whole ring buffer to the user space at the
> beginning, and the userspace is allowed and legal to access any block
> within the limits of the mapped ring area.
> 
> But actually when this happens, it normally will be one bug of the
> userspace. Without this checking the kernel will output many page fault
> dump traces.
> 
> Maybe here outputing some warning message is a good idea, and will be
> easy to debug for userspace.

Yeah.

> 
> 
> [...]
>>> @@ -1388,6 +1509,81 @@ static ssize_t tcmu_cmd_time_out_store(struct
>>> config_item *item, const char *pag
>>>       .tb_dev_attrib_attrs    = NULL,
>>>   };
>>>   +static int unmap_thread_fn(void *data)
>>> +{
>>> +    struct tcmu_dev *udev;
>>> +    loff_t off;
>>> +    uint32_t start, end, block;
>>> +    struct page *page;
>>> +    int i;
>>> +
>>> +    while (1) {
>>> +        DEFINE_WAIT(__wait);
>>> +
>>> +        prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
>>> +        schedule();
>>> +        finish_wait(&unmap_wait, &__wait);
>>> +
>>> +        mutex_lock(&root_udev_mutex);
>>> +        list_for_each_entry(udev, &root_udev, node) {
>>> +            mutex_lock(&udev->cmdr_lock);
>>> +
>>> +            /* Try to complete the finished commands first */
>>> +            tcmu_handle_completions(udev);
>>> +
>>> +            /* Skip the udevs waiting the global pool or in idle */
>>> +            if (udev->waiting_global || !udev->dbi_thresh) {
>>> +                mutex_unlock(&udev->cmdr_lock);
>>> +                continue;
>>> +            }
>>> +
>>> +            end = udev->dbi_max + 1;
>>> +            block = find_last_bit(udev->data_bitmap, end);
>>> +            if (block == udev->dbi_max) {
>>> +                /*
>>> +                 * The last bit is dbi_max, so there is
>>> +                 * no need to shrink any blocks.
>>> +                 */
>>> +                mutex_unlock(&udev->cmdr_lock);
>>> +                continue;
>>> +            } else if (block == end) {
>>> +                /* The current udev will goto idle state */
>>> +                udev->dbi_thresh = start = 0;
>>> +                udev->dbi_max = 0;
>>> +            } else {
>>> +                udev->dbi_thresh = start = block + 1;
>>> +                udev->dbi_max = block;
>>> +            }
>>> +
>>> +            /* Here will truncate the data area from off */
>>> +            off = udev->data_off + start * DATA_BLOCK_SIZE;
>>> +            unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
>>> +
>>> +            /* Release the block pages */
>>> +            for (i = start; i < end; i++) {
>>> +                page = radix_tree_delete(&udev->data_blocks, i);
>>> +                if (page) {
>>> +                    __free_page(page);
>>> +                    atomic_dec(&global_db_count);
>>> +                }
>>> +            }
>>> +            mutex_unlock(&udev->cmdr_lock);
>>> +        }
>>> +
>>> +        /*
>>> +         * Try to wake up the udevs who are waiting
>>> +         * for the global data pool.
>>> +         */
>>> +        list_for_each_entry(udev, &root_udev, node) {
>>> +            if (udev->waiting_global)
>>> +                wake_up(&udev->wait_cmdr);
>>> +        }
>>
>> To avoid starvation, I think you want a second list/fifo that holds the
>> watiers. In tcmu_get_empty_block if the list is not empty, record how
>> many pages we needed and then add the device to the list and wait in
>> tcmu_queue_cmd_ring.
>>
>> Above if we freed enough pages for the device at head then wake up the
>> device.
>>
>> I think you also need a wake_up call in the completion path in case the
>> initial call could not free enough pages. It could probably check if the
>> completion was going to free enough pages for a waiter and then call
>> wake.
>>
> Yes, I meant to introduce this later after this series to not let the
> patches too
> complex to review.
> 
> If you agree I will do this later, or in V7 series ?


Yeah, I am ok with adding it after the initial patches go in.
