Return-Path: <SRS0=qYHy=XF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE14EC49ED8
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 16:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF91206A1
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 16:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394104AbfIJQGG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 12:06:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730821AbfIJQGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Sep 2019 12:06:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 44A1D302C08C;
        Tue, 10 Sep 2019 16:06:05 +0000 (UTC)
Received: from [10.10.120.129] (ovpn-120-129.rdu2.redhat.com [10.10.120.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 149295D6B2;
        Tue, 10 Sep 2019 16:06:03 +0000 (UTC)
Subject: Re: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
References: <20190909162804.5694-1-mchristi@redhat.com>
 <20190910100000.mcik63ot6o3dyzjv@box.shutemov.name>
Cc:     axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5D77C9EB.90807@redhat.com>
Date:   Tue, 10 Sep 2019 11:06:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <20190910100000.mcik63ot6o3dyzjv@box.shutemov.name>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 10 Sep 2019 16:06:05 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/10/2019 05:00 AM, Kirill A. Shutemov wrote:
> On Mon, Sep 09, 2019 at 11:28:04AM -0500, Mike Christie wrote:
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
>>
>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>> ---
>>  Documentation/filesystems/proc.txt |  6 ++++
>>  fs/proc/base.c                     | 53 ++++++++++++++++++++++++++++++
>>  2 files changed, 59 insertions(+)
>>
>> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
>> index 99ca040e3f90..b5456a61a013 100644
>> --- a/Documentation/filesystems/proc.txt
>> +++ b/Documentation/filesystems/proc.txt
>> @@ -46,6 +46,7 @@ Table of Contents
>>    3.10  /proc/<pid>/timerslack_ns - Task timerslack value
>>    3.11	/proc/<pid>/patch_state - Livepatch patch operation state
>>    3.12	/proc/<pid>/arch_status - Task architecture specific information
>> +  3.13  /proc/<pid>/memalloc - Control task's memory reclaim behavior
>>  
>>    4	Configuring procfs
>>    4.1	Mount options
>> @@ -1980,6 +1981,11 @@ Example
>>   $ cat /proc/6753/arch_status
>>   AVX512_elapsed_ms:      8
>>  
>> +3.13 /proc/<pid>/memalloc - Control task's memory reclaim behavior
>> +-----------------------------------------------------------------------
>> +A value of "noio" indicates that when a task allocates memory it will not
>> +reclaim memory that requires starting phisical IO.
>> +
>>  Description
>>  -----------
>>  
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index ebea9501afb8..c4faa3464602 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -1223,6 +1223,57 @@ static const struct file_operations proc_oom_score_adj_operations = {
>>  	.llseek		= default_llseek,
>>  };
>>  
>> +static ssize_t memalloc_read(struct file *file, char __user *buf, size_t count,
>> +			     loff_t *ppos)
>> +{
>> +	struct task_struct *task;
>> +	ssize_t rc = 0;
>> +
>> +	task = get_proc_task(file_inode(file));
>> +	if (!task)
>> +		return -ESRCH;
>> +
>> +	if (task->flags & PF_MEMALLOC_NOIO)
>> +		rc = simple_read_from_buffer(buf, count, ppos, "noio", 4);
>> +	put_task_struct(task);
>> +	return rc;
>> +}
>> +
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
> 
> Really? Without any privilege check? So any random user can tap into
> __GFP_NOIO allocations?

That was a mistake on my part. I will add it in.

