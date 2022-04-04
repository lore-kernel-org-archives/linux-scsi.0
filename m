Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71812C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 21:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379483AbiDDVTs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378983AbiDDQPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 12:15:36 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B68625C;
        Mon,  4 Apr 2022 09:13:38 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V9DJJPq_1649088814;
Received: from 30.32.77.251(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V9DJJPq_1649088814)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 05 Apr 2022 00:13:35 +0800
Message-ID: <3ed13bac-8e8a-3204-6bf9-08d16b1876ff@linux.alibaba.com>
Date:   Tue, 5 Apr 2022 00:13:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/3] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220323134940.31463-1-xiaoguang.wang@linux.alibaba.com>
 <20220323134940.31463-3-xiaoguang.wang@linux.alibaba.com>
 <b6280955-d3f5-f11b-5f62-07ab83cff4ac@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <b6280955-d3f5-f11b-5f62-07ab83cff4ac@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

> On 23.03.22 14:49, Xiaoguang Wang wrote:
>> When tcmu_vma_fault() gets one page successfully, before the current
>> context completes page fault procedure, find_free_blocks() may run in
>> and call unmap_mapping_range() to unmap this page. Assume when
>> find_free_blocks() completes its job firstly, previous page fault
>> procedure starts to run again and completes, then one truncated page has
>> beed mapped to use space, but note that tcmu_vma_fault() has gotten one
>> refcount for this page, so any other subsystem won't use this page,
>> unless later the use space addr is unmapped.
>>
>> If another command runs in later and needs to extends dbi_thresh, it may
>> reuse the corresponding slot to previous page in data_bitmap, then thouth
>> we'll allocate new page for this slot in data_area, but no page fault will
>> happen again, because we have a valid map, real request's data will lose.
>
> I don't think, this is a safe fix. It is possible that not only
> find_free_blocks runs before page fault procedure completes, but also
> allocation for next cmd happens. In that case the new call to
> unmap_mapping_range would also happen before page fault completes ->
> data corruption.
You're right, thanks for pointing this issue.
For your below questions, I need to take some time to read and understand
codes, I'll try to reply in tomorrow, sorry.

Regards,
Xiaoguang Wang
>
> AFAIK, no one ever has seen this this bug in real life, as
> find_free_blocks only runs seldomly and userspace would have to access
> a data page the very first time while the cmd that owned this page
> already has been completed by userspace. Therefore I think we should
> apply a perfect fix only.
>
> I'm wondering whether there really is such a race. If so, couldn't the
> same race happen in other drivers or even when truncating mapped files?
>
>
>>
>> To fix this issue, when extending dbi_thresh, we'll need to call
>> unmap_mapping_range() to unmap use space data area which may exist,
>> which I think it's a simple method.
>>
>> Filesystem implementations will also run into this issue, but they
>> ususally lock page when vm_operations_struct->fault gets one page, and
>> unlock page after finish_fault() completes. In truncate sides, they
>> lock pages in truncate_inode_pages() to protect race with page fault.
>> We can also have similar codes like filesystem to fix this issue.
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   drivers/target/target_core_user.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>> index 06a5c4086551..9196188504ec 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -862,6 +862,7 @@ static int tcmu_alloc_data_space(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>>       if (space < cmd->dbi_cnt) {
>>           unsigned long blocks_left =
>>                   (udev->max_blocks - udev->dbi_thresh) + space;
>> +        loff_t off, len;
>>             if (blocks_left < cmd->dbi_cnt) {
>>               pr_debug("no data space: only %lu available, but ask for %u\n",
>> @@ -870,6 +871,10 @@ static int tcmu_alloc_data_space(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>>               return -1;
>>           }
>>   +        off = udev->data_off + (loff_t)udev->dbi_thresh * udev->data_blk_size;
>> +        len = cmd->dbi_cnt * udev->data_blk_size;
>> +        unmap_mapping_range(udev->inode->i_mapping, off, len, 1);
>> +
>>           udev->dbi_thresh += cmd->dbi_cnt;
>>           if (udev->dbi_thresh > udev->max_blocks)
>>               udev->dbi_thresh = udev->max_blocks;

