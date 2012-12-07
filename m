From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v7 4/9] Remove offline devices when removing a host
Date: Fri, 07 Dec 2012 18:21:21 +0100
Message-ID: <50C22591.7020906@acm.org>
References: <50C0BEEE.4040907@acm.org> <50C0C00E.60709@acm.org> <50C206DC.3040202@suse.de> <50C20C3F.6020003@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:51653 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423001Ab2LGRVY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2012 12:21:24 -0500
In-Reply-To: <50C20C3F.6020003@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 12/07/12 16:33, Bart Van Assche wrote:
> On 12/07/12 16:10, Hannes Reinecke wrote:
>> On 12/06/2012 04:55 PM, Bart Van Assche wrote:
>>> Currently __scsi_remove_device() skips devices that are visible and
>>> offline. Make sure that these devices get removed by changing their
>>> device state into SDEV_DEL at the start of __scsi_remove_device().
>>> Also, avoid that __scsi_remove_device() gets called a second time
>>> for devices that are in state SDEV_CANCEL when scsi_forget_host()
>>> is invoked.
>>>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> Cc: James Bottomley <JBottomley@Parallels.com>
>>> Cc: Mike Christie <michaelc@cs.wisc.edu>
>>> Cc: Hannes Reinecke <hare@suse.de>
>>> Cc: Tejun Heo <tj@kernel.org>
>>> ---
>>>   drivers/scsi/scsi_scan.c  |    2 +-
>>>   drivers/scsi/scsi_sysfs.c |    4 ++--
>>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>> index 3e58b22..0612fba 100644
>>> --- a/drivers/scsi/scsi_scan.c
>>> +++ b/drivers/scsi/scsi_scan.c
>>> @@ -1889,7 +1889,7 @@ void scsi_forget_host(struct Scsi_Host *shost)
>>>    restart:
>>>       spin_lock_irqsave(shost->host_lock, flags);
>>>       list_for_each_entry(sdev, &shost->__devices, siblings) {
>>> -        if (sdev->sdev_state == SDEV_DEL)
>>> +        if (scsi_device_being_removed(sdev))
>>>               continue;
>>>           spin_unlock_irqrestore(shost->host_lock, flags);
>>>           __scsi_remove_device(sdev);
>>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>>> index 2ff7ba5..4348f12 100644
>>> --- a/drivers/scsi/scsi_sysfs.c
>>> +++ b/drivers/scsi/scsi_sysfs.c
>>> @@ -959,8 +959,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>>       unsigned long flags;
>>>
>>>       if (sdev->is_visible) {
>>> -        if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>>> -            return;
>>> +        WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_CANCEL) != 0 &&
>>> +                 scsi_device_set_state(sdev, SDEV_DEL) != 0);
>>>
>>>           bsg_unregister_queue(sdev->request_queue);
>>>           device_unregister(&sdev->sdev_dev);
>>>
>> Hmm. Then we would be getting a warning if the device is already in
>> SDEV_DEL, wouldn't we?
>> And what about offlined devices?
>> We should be safe to remove them, or?
>
> Hello Hannes,
>
> The intent of this patch is that __scsi_remove_device() gets invoked
> exactly once per device. This function shouldn't be invoked for devices
> already in state SDEV_DEL.
>
> Offlined devices will be transitioned directly from one of the two
> offline states into state SDEV_DEL.
>
> The above patch fixes a nasty crash by avoiding that a second
> __scsi_remove_device() call queues I/O (sd_shutdown()) after
> scsi_remove_host() has already finished.

(replying to my own e-mail)

Please ignore the above comment about sd_shutdown() - that didn't make 
sense. What I would like to add to the above is that it's only after I 
included the above patch in my tests that the following two call stacks 
could no longer be triggered:

BUG: spinlock bad magic on CPU#0, kworker/0:1H/178
  lock: 0xffff880177880c28, .magic: ffff8801, .owner: <none>/-1, 
.owner_cpu: 2006506176
Pid: 178, comm: kworker/0:1H Tainted: G        W  O 3.7.0-rc7-debug+ #2
Call Trace:
  [<ffffffff814120ef>] spin_dump+0x8c/0x91
  [<ffffffff81412115>] spin_bug+0x21/0x26
  [<ffffffff81218aef>] do_raw_spin_lock+0x13f/0x150
  [<ffffffff81417bb8>] _raw_spin_lock_irqsave+0x78/0xa0
  [<ffffffffa0766c6c>] srp_queuecommand+0x3c/0xc80 [ib_srp]
  [<ffffffffa0002f18>] scsi_dispatch_cmd+0x148/0x310 [scsi_mod]
  [<ffffffffa000a390>] scsi_request_fn+0x320/0x520 [scsi_mod]
  [<ffffffff811ec427>] __blk_run_queue+0x37/0x50
  [<ffffffff811ec539>] blk_delay_work+0x29/0x40
  [<ffffffff81059283>] process_one_work+0x1c3/0x5c0
  [<ffffffff8105b1be>] worker_thread+0x15e/0x440
  [<ffffffff8106137b>] kthread+0xdb/0xe0
  [<ffffffff81420d5c>] ret_from_fork+0x7c/0xb0
------------[ cut here ]------------

BUG: spinlock bad magic on CPU#1, udevd/1518
  lock: 0xffff8801a2384c28, .magic: ffff8801, .owner: <none>/-1, 
.owner_cpu: -1519491200
Pid: 1518, comm: udevd Not tainted 3.7.0-rc8-debug+ #2
Call Trace:
  [<ffffffff81411a9d>] spin_dump+0x8c/0x91
  [<ffffffff81411ac3>] spin_bug+0x21/0x26
  [<ffffffff812184ff>] do_raw_spin_lock+0x13f/0x150
  [<ffffffff81417568>] _raw_spin_lock_irqsave+0x78/0xa0
  [<ffffffffa04a0d1c>] srp_queuecommand+0x3c/0xc80 [ib_srp]
  [<ffffffffa0002f18>] scsi_dispatch_cmd+0x148/0x310 [scsi_mod]
  [<ffffffffa000a6cc>] scsi_request_fn+0x46c/0x570 [scsi_mod]
  [<ffffffff811ebe26>] __blk_run_queue+0x46/0x60
  [<ffffffff811ebe7e>] queue_unplugged+0x3e/0xd0
  [<ffffffff811ee9c3>] blk_flush_plug_list+0x1c3/0x240
  [<ffffffff811eea58>] blk_finish_plug+0x18/0x50
  [<ffffffff8110511c>] __do_page_cache_readahead+0x24c/0x2e0
  [<ffffffff811052e9>] force_page_cache_readahead+0x79/0xb0
  [<ffffffff8110573b>] page_cache_sync_readahead+0x4b/0x50
  [<ffffffff810fad30>] generic_file_aio_read+0x590/0x710
  [<ffffffff8114b127>] do_sync_read+0xa7/0xe0
  [<ffffffff8114b878>] vfs_read+0xa8/0x170
  [<ffffffff8114b995>] sys_read+0x55/0xa0
  [<ffffffff81420782>] system_call_fastpath+0x16/0x1b
------------[ cut here ]------------

Bart.
