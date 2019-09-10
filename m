Return-Path: <SRS0=qYHy=XF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB1EC49ED7
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 22:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD0B3216F4
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 22:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfIJWM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 18:12:27 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53419 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfIJWM1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 18:12:27 -0400
Received: from fsav405.sakura.ne.jp (fsav405.sakura.ne.jp [133.242.250.104])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x8AMC70E004224;
        Wed, 11 Sep 2019 07:12:07 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav405.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav405.sakura.ne.jp);
 Wed, 11 Sep 2019 07:12:07 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav405.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126227201116.bbtec.net [126.227.201.116])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x8AMC7JR004220
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Wed, 11 Sep 2019 07:12:07 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: Re: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
To:     Mike Christie <mchristi@redhat.com>
References: <20190909162804.5694-1-mchristi@redhat.com>
 <5D76995B.1010507@redhat.com>
Cc:     axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <ee39d997-ee07-22c7-3e59-a436cef4d587@I-love.SAKURA.ne.jp>
Date:   Wed, 11 Sep 2019 07:12:06 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5D76995B.1010507@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/10 3:26, Mike Christie wrote:
> Forgot to cc linux-mm.
> 
> On 09/09/2019 11:28 AM, Mike Christie wrote:
>> There are several storage drivers like dm-multipath, iscsi, and nbd that
>> have userspace components that can run in the IO path. For example,
>> iscsi and nbd's userspace deamons may need to recreate a socket and/or
>> send IO on it, and dm-multipath's daemon multipathd may need to send IO
>> to figure out the state of paths and re-set them up.
>>
>> In the kernel these drivers have access to GFP_NOIO/GFP_NOFS and the
>> memalloc_*_save/restore functions to control the allocation behavior,
>> but for userspace we would end up hitting a allocation that ended up
>> writing data back to the same device we are trying to allocate for.
>>
>> This patch allows the userspace deamon to set the PF_MEMALLOC* flags
>> through procfs. It currently only supports PF_MEMALLOC_NOIO, but
>> depending on what other drivers and userspace file systems need, for
>> the final version I can add the other flags for that file or do a file
>> per flag or just do a memalloc_noio file.

Interesting patch. But can't we instead globally mask __GFP_NOFS / __GFP_NOIO
than playing games with per a thread masking (which suffers from inability to
propagate current thread's mask to other threads indirectly involved)?

>> +static ssize_t memalloc_write(struct file *file, const char __user *buf,
>> +			      size_t count, loff_t *ppos)
>> +{
>> +	struct task_struct *task;
>> +	char buffer[5];
>> +	int rc = count;
>> +
>> +	memset(buffer, 0, sizeof(buffer));
>> +	if (count != sizeof(buffer) - 1)
>> +		return -EINVAL;
>> +
>> +	if (copy_from_user(buffer, buf, count))

copy_from_user() / copy_to_user() might involve memory allocation
via page fault which has to be done under the mask? Moreover, since
just open()ing this file can involve memory allocation, do we forbid
open("/proc/thread-self/memalloc") ?

>> +		return -EFAULT;
>> +	buffer[count] = '\0';
>> +
>> +	task = get_proc_task(file_inode(file));
>> +	if (!task)
>> +		return -ESRCH;
>> +
>> +	if (!strcmp(buffer, "noio")) {
>> +		task->flags |= PF_MEMALLOC_NOIO;
>> +	} else {
>> +		rc = -EINVAL;
>> +	}
>> +
>> +	put_task_struct(task);
>> +	return rc;
>> +}

