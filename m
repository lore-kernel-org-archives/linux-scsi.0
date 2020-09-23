Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCEDC2D0A8
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 08:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4240238A1
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 08:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgIWIR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 04:17:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:38574 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgIWIR4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Sep 2020 04:17:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F8CEAEF8;
        Wed, 23 Sep 2020 08:18:32 +0000 (UTC)
Subject: Re: [PATCH] scsi: alua: fix the race between alua_bus_detach and
 alua_rtpg
To:     jitendra.khasdev@oracle.com, "Ewan D. Milne" <emilne@redhat.com>,
        martin.petersen@oracle.com, jejb@linux.ibm.com, hare@suse.com,
        loberman@redhat.com
Cc:     joe.jin@oracle.com, junxiao.bi@oracle.com,
        gulam.mohamed@oracle.com, RITIKA.SRIVASTAVA@oracle.com,
        linux-scsi@vger.kernel.org
References: <1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com>
 <c5e0700bb192a422541d1328db7ca0146edf7a81.camel@redhat.com>
 <c58d1877-1d30-e81d-f10f-3571e3a248b9@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d21e4a7c-9668-23db-c470-596a8e1e3af6@suse.de>
Date:   Wed, 23 Sep 2020 10:17:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <c58d1877-1d30-e81d-f10f-3571e3a248b9@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/18/20 5:49 AM, jitendra.khasdev@oracle.com wrote:
> 
> 
> On 9/17/20 11:00 PM, Ewan D. Milne wrote:
>> On Tue, 2020-09-15 at 16:28 +0530, Jitendra Khasdev wrote:
>>> This is patch to fix the race occurs between bus detach and alua_rtpg.
>>>
>>> It fluses the all pending workqueue in bus detach handler, so it can avoid
>>> race between alua_bus_detach and alua_rtpg.
>>>
>>> Here is call trace where race got detected.
>>>
>>> multipathd call stack:
>>> [exception RIP: native_queued_spin_lock_slowpath+100]
>>> --- <NMI exception stack> ---
>>> native_queued_spin_lock_slowpath at ffffffff89307f54
>>> queued_spin_lock_slowpath at ffffffff89307c18
>>> _raw_spin_lock_irq at ffffffff89bd797b
>>> alua_bus_detach at ffffffff8984dcc8
>>> scsi_dh_release_device at ffffffff8984b6f2
>>> scsi_device_dev_release_usercontext at ffffffff89846edf
>>> execute_in_process_context at ffffffff892c3e60
>>> scsi_device_dev_release at ffffffff8984637c
>>> device_release at ffffffff89800fbc
>>> kobject_cleanup at ffffffff89bb1196
>>> kobject_put at ffffffff89bb12ea
>>> put_device at ffffffff89801283
>>> scsi_device_put at ffffffff89838d5b
>>> scsi_disk_put at ffffffffc051f650 [sd_mod]
>>> sd_release at ffffffffc051f8a2 [sd_mod]
>>> __blkdev_put at ffffffff8952c79e
>>> blkdev_put at ffffffff8952c80c
>>> blkdev_close at ffffffff8952c8b5
>>> __fput at ffffffff894e55e6
>>> ____fput at ffffffff894e57ee
>>> task_work_run at ffffffff892c94dc
>>> exit_to_usermode_loop at ffffffff89204b12
>>> do_syscall_64 at ffffffff892044da
>>> entry_SYSCALL_64_after_hwframe at ffffffff89c001b8
>>>
>>> kworker:
>>> [exception RIP: alua_rtpg+2003]
>>> account_entity_dequeue at ffffffff892e42c1
>>> alua_rtpg_work at ffffffff8984f097
>>> process_one_work at ffffffff892c4c29
>>> worker_thread at ffffffff892c5a4f
>>> kthread at ffffffff892cb135
>>> ret_from_fork at ffffffff89c00354
>>>
>>> Signed-off-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>
>>> ---
>>>   drivers/scsi/device_handler/scsi_dh_alua.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
>>> index f32da0c..024a752 100644
>>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>>> @@ -1144,6 +1144,9 @@ static void alua_bus_detach(struct scsi_device *sdev)
>>>   	struct alua_dh_data *h = sdev->handler_data;
>>>   	struct alua_port_group *pg;
>>>   
>>> +	sdev_printk(KERN_INFO, sdev, "%s: flushing workqueues\n", ALUA_DH_NAME);
>>> +	flush_workqueue(kaluad_wq);
>>> +
>>>   	spin_lock(&h->pg_lock);
>>>   	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>>>   	rcu_assign_pointer(h->pg, NULL);
>>
>> I'm not sure this is the best solution.  The current code
>> references h->sdev when the dh_list is traversed.  So it needs
>> to remain valid.  Fixing it by flushing the workqueue to avoid
>> the list traversal code running leaves open the possibility that
>> future code alterations may expose this problem again.
>>
>> -Ewan
>>
>>
> 
> I see your point, but as we are in detach handler and this code path
> only execute when device is being detached. So, before detaching, flush
> work-queue will take care of any current code references h->sdev where
> dh_list is being traversed.
> 
Flushing the workqueue is a bit of an overkill, seeing that we know 
exactly which workqueue element we're waiting for.

> IMO, I do not think it would create any problem for future code
> alterations. Or may be I am missing something over here, what could
> be possible scenario for that?
> 
Problem is more that I'd like to understand where exactly the race 
condition is. Can you figure out which spinlock is triggering in your 
stack trace?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
