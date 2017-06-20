From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] tcmu: Add fifo type waiter list support to
 avoidstarvation
Date: Tue, 20 Jun 2017 09:34:22 +0800
Message-ID: <79944e7a-45f1-c9d9-3fba-3e03cef2d5f1@cmss.chinamobile.com>
References: <1493952686-29396-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <5933887D.5080708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5933887D.5080708@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, nab@linux-iscsi.org
Cc: agrover@redhat.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Nic & Mike

I will update this just after the issue reported by Bryant on his 
environment been fixed later.

Thanks,
BRs
Xiubo


On 2017年06月04日 12:11, Mike Christie wrote:
> On 05/04/2017 09:51 PM, lixiubo@cmss.chinamobile.com wrote:
>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>
>> The fifo type waiter list will hold the udevs who are waiting for the
>> blocks from the data global pool. The unmap thread will try to feed the
>> first udevs in waiter list, if the global free blocks available are
>> not enough, it will stop traversing the list and abort waking up the
>> others.
>>
>> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
>> ---
>>   drivers/target/target_core_user.c | 82 +++++++++++++++++++++++++++++++--------
>>   1 file changed, 66 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>> index 9045837..10c99e7 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -97,6 +97,7 @@ struct tcmu_hba {
>>   
>>   struct tcmu_dev {
>>   	struct list_head node;
>> +	struct list_head waiter;
>>   
>>   	struct se_device se_dev;
>>   
>> @@ -123,7 +124,7 @@ struct tcmu_dev {
>>   	wait_queue_head_t wait_cmdr;
>>   	struct mutex cmdr_lock;
>>   
>> -	bool waiting_global;
>> +	uint32_t waiting_blocks;
>>   	uint32_t dbi_max;
>>   	uint32_t dbi_thresh;
>>   	DECLARE_BITMAP(data_bitmap, DATA_BLOCK_BITS);
>> @@ -165,6 +166,10 @@ struct tcmu_cmd {
>>   static DEFINE_MUTEX(root_udev_mutex);
>>   static LIST_HEAD(root_udev);
>>   
>> +/* The data blocks global pool waiter list */
>> +static DEFINE_MUTEX(root_udev_waiter_mutex);
> Sorry for the delay.
>
>
> Could you just add a comment about the lock ordering. It will be helpful
> to new engineers/reviewers to check for errors.
>
>
>> +static LIST_HEAD(root_udev_waiter);
>> +
>>   static atomic_t global_db_count = ATOMIC_INIT(0);
>>   
>>   static struct kmem_cache *tcmu_cmd_cache;
>> @@ -195,6 +200,11 @@ enum tcmu_multicast_groups {
>>   #define tcmu_cmd_set_dbi(cmd, index) ((cmd)->dbi[(cmd)->dbi_cur++] = (index))
>>   #define tcmu_cmd_get_dbi(cmd) ((cmd)->dbi[(cmd)->dbi_cur++])
>>   
>> +static inline bool is_in_waiter_list(struct tcmu_dev *udev)
>> +{
>> +	return !!udev->waiting_blocks;
>> +}
>> +
>>   static void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd, uint32_t len)
>>   {
>>   	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
>> @@ -250,8 +260,6 @@ static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
>>   {
>>   	int i;
>>   
>> -	udev->waiting_global = false;
>> -
>>   	for (i = tcmu_cmd->dbi_cur; i < tcmu_cmd->dbi_cnt; i++) {
>>   		if (!tcmu_get_empty_block(udev, tcmu_cmd))
>>   			goto err;
>> @@ -259,9 +267,7 @@ static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
>>   	return true;
>>   
>>   err:
>> -	udev->waiting_global = true;
>> -	/* Try to wake up the unmap thread */
>> -	wake_up(&unmap_wait);
>> +	udev->waiting_blocks += tcmu_cmd->dbi_cnt - i;
>>   	return false;
>>   }
>>   
>> @@ -671,6 +677,7 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
>>   
>>   	while (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
>>   		int ret;
>> +		bool is_waiting_blocks = !!udev->waiting_blocks;
> You can use your helper is_in_waiter_list().
>
>>   		DEFINE_WAIT(__wait);
>>   
>>   		prepare_to_wait(&udev->wait_cmdr, &__wait, TASK_INTERRUPTIBLE);
>> @@ -688,6 +695,18 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
>>   			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>   		}
>>   
>> +		/*
>> +		 * Try to insert the current udev to waiter list and
>> +		 * then wake up the unmap thread
>> +		 */
>> +		if (is_waiting_blocks) {
>> +			mutex_lock(&root_udev_waiter_mutex);
>> +			list_add_tail(&udev->waiter, &root_udev_waiter);
>> +			mutex_unlock(&root_udev_waiter_mutex);
>> +
>> +			wake_up(&unmap_wait);
>> +		}
> Is this supposed to go before the schedule_timeout call?
>
> If we are here and schedule_timeout returned non zero then our wait_cmdr
> has been woken up from the unmap thread because it freed some space, so
> we do not want to again add ourself and call unmap again.
>
>
>> +
>>   		mutex_lock(&udev->cmdr_lock);
>>   
>>   		/* We dropped cmdr_lock, cmd_head is stale */
>> @@ -902,8 +921,6 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
>>   	if (mb->cmd_tail == mb->cmd_head)
>>   		del_timer(&udev->timeout); /* no more pending cmds */
>>   
>> -	wake_up(&udev->wait_cmdr);
>> -
>>   	return handled;
>>   }
>>   
>> @@ -996,7 +1013,17 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
>>   	struct tcmu_dev *tcmu_dev = container_of(info, struct tcmu_dev, uio_info);
>>   
>>   	mutex_lock(&tcmu_dev->cmdr_lock);
>> -	tcmu_handle_completions(tcmu_dev);
>> +	/*
>> +	 * If the current udev is also in waiter list, this will
>> +	 * make sure that the other waiters in list be feeded ahead
>> +	 * of it.
>> +	 */
>> +	if (is_in_waiter_list(tcmu_dev)) {
>> +		wake_up(&unmap_wait);
>> +	} else {
>> +		tcmu_handle_completions(tcmu_dev);
>> +		wake_up(&tcmu_dev->wait_cmdr);
>> +	}
>>   	mutex_unlock(&tcmu_dev->cmdr_lock);
>>   
>>   	return 0;
>> @@ -1231,7 +1258,7 @@ static int tcmu_configure_device(struct se_device *dev)
>>   	udev->data_off = CMDR_SIZE;
>>   	udev->data_size = DATA_SIZE;
>>   	udev->dbi_thresh = 0; /* Default in Idle state */
>> -	udev->waiting_global = false;
>> +	udev->waiting_blocks = 0;
>>   
>>   	/* Initialise the mailbox of the ring buffer */
>>   	mb = udev->mb_addr;
>> @@ -1345,6 +1372,13 @@ static void tcmu_free_device(struct se_device *dev)
>>   	list_del(&udev->node);
>>   	mutex_unlock(&root_udev_mutex);
>>   
>> +	mutex_lock(&root_udev_waiter_mutex);
>> +	mutex_lock(&udev->cmdr_lock);
>> +	if (is_in_waiter_list(udev))
>> +		list_del(&udev->waiter);
>> +	mutex_unlock(&udev->cmdr_lock);
>> +	mutex_unlock(&root_udev_waiter_mutex);
>> +
>>   	vfree(udev->mb_addr);
>>   
>>   	/* Upper layer should drain all requests before calling this */
>> @@ -1550,6 +1584,7 @@ static int unmap_thread_fn(void *data)
>>   	struct tcmu_dev *udev;
>>   	loff_t off;
>>   	uint32_t start, end, block;
>> +	static uint32_t free_blocks;
>>   	struct page *page;
>>   	int i;
>>   
>> @@ -1571,7 +1606,7 @@ static int unmap_thread_fn(void *data)
>>   			tcmu_handle_completions(udev);
>>   
>>   			/* Skip the udevs waiting the global pool or in idle */
>> -			if (udev->waiting_global || !udev->dbi_thresh) {
>> +			if (is_in_waiter_list(udev) || !udev->dbi_thresh) {
>>   				mutex_unlock(&udev->cmdr_lock);
>>   				continue;
>>   			}
>> @@ -1607,17 +1642,32 @@ static int unmap_thread_fn(void *data)
>>   				}
>>   			}
>>   			mutex_unlock(&udev->cmdr_lock);
>> +
>> +			free_blocks += end - start;
>>   		}
>> +		mutex_unlock(&root_udev_mutex);
>>   
>>   		/*
>>   		 * Try to wake up the udevs who are waiting
>> -		 * for the global data pool.
>> +		 * for the global data pool blocks.
>>   		 */
>> -		list_for_each_entry(udev, &root_udev, node) {
>> -			if (udev->waiting_global)
>> -				wake_up(&udev->wait_cmdr);
>> +		mutex_lock(&root_udev_waiter_mutex);
>> +		list_for_each_entry(udev, &root_udev_waiter, waiter) {
>> +			mutex_lock(&udev->cmdr_lock);
>> +			if (udev->waiting_blocks < free_blocks) {
>> +				mutex_unlock(&udev->cmdr_lock);
>> +				break;
>> +			}
>> +
>> +			free_blocks -= udev->waiting_blocks;
>> +			udev->waiting_blocks = 0;
>> +			mutex_unlock(&udev->cmdr_lock);
>> +
>> +			list_del(&udev->waiter);
>> +
>> +			wake_up(&udev->wait_cmdr);
>>   		}
>> -		mutex_unlock(&root_udev_mutex);
>> +		mutex_unlock(&root_udev_waiter_mutex);
>>   	}
>>   
>>   	return 0;
>>
