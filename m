Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7964DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Mar 2022 14:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbiCWOew (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Mar 2022 10:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244801AbiCWOev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2022 10:34:51 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ABB25EBB;
        Wed, 23 Mar 2022 07:33:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V80FrRj_1648045993;
Received: from 30.225.28.175(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V80FrRj_1648045993)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Mar 2022 22:33:14 +0800
Message-ID: <57da7e54-f582-3b10-52a9-5166adacf4e6@linux.alibaba.com>
Date:   Wed, 23 Mar 2022 22:33:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFC 3/3] scsi: target: tcmu: Support zero copy
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-mm@kvack.org,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, xuyu@linux.alibaba.com
References: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
 <20220318095531.15479-4-xiaoguang.wang@linux.alibaba.com>
 <94b00e49-5efb-658f-3142-42e7cc551d19@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <94b00e49-5efb-658f-3142-42e7cc551d19@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

First thanks for your kind comments, it really will make codes better.
> On 18.03.22 10:55, Xiaoguang Wang wrote:
>> Currently in tcmu, for READ commands, it copies user space backstore's
>> data buffer to tcmu internal data area, then copies data in data area
>> to READ commands sgl pages. For WRITE commands, tcmu copies sgl pages
>> to tcmu internal data area, then copies data in data area to user space
>> backstore. For both cases, there are obvious copy overhead, which impact
>> io throughput, especially for large io size.
>>
>> To mitigate this issue, we implement zero copy feature to tcmu, which
>> map sgl pages to user space backstore's address space. Currently only
>> sgl pages's offset and length are both aligned to page size, can this
>> command go into tcmu zero copy path.
>
> Apart from my further comments below: since this change implies
> incompatibilities regarding timeout handling and KEEP_BUF, I think the
> new feature should be configurable with in default mode being switched
> off.
OK, agree.

> When userspace switches it on, I think
> - tcmu should fix ring timeout to 0 (= off). No change allowed
> - tcmu should either disallow KEEP_BUF at all (not set the feature bit
>   in mailbox) or should use a per cmd bit in the ring to show, for which
>   cmds KEEP_BUF is possible.
Sorry, since this is a RFC patch set, so I didn't consider this 
incompatibilities
well, I'll try to figure out a better method in following version.

>
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   drivers/target/target_core_user.c | 257 
>> +++++++++++++++++++++++++++++++++-----
>>   1 file changed, 229 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/target/target_core_user.c 
>> b/drivers/target/target_core_user.c
>> index 7b2a89a67cdb..4314e0c00f8e 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -16,6 +16,8 @@
>>   #include <linux/xarray.h>
>>   #include <linux/stringify.h>
>>   #include <linux/bitops.h>
>> +#include <linux/sched/mm.h>
>> +#include <linux/mm.h>
>>   #include <linux/highmem.h>
>>   #include <linux/configfs.h>
>>   #include <linux/mutex.h>
>> @@ -72,6 +74,7 @@
>>    */
>>   #define DATA_PAGES_PER_BLK_DEF 1
>>   #define DATA_AREA_PAGES_DEF (256 * 1024)
>> +#define ZC_DATA_AREA_PAGES_DEF (256 * 1024)
>>     #define TCMU_MBS_TO_PAGES(_mbs) ((size_t)_mbs << (20 - PAGE_SHIFT))
>>   #define TCMU_PAGES_TO_MBS(_pages) (_pages >> (20 - PAGE_SHIFT))
>> @@ -145,9 +148,20 @@ struct tcmu_dev {
>>       struct list_head qfull_queue;
>>       struct list_head tmr_queue;
>>   +    /* For zero copy handle */
>> +    int zc_data_area_mb;
>> +    uint32_t zc_max_blocks;
>>       uint32_t dbi_max;
>>       uint32_t dbi_thresh;
>>       unsigned long *data_bitmap;
>> +
>> +    struct mm_struct *vma_vm_mm;
>> +    struct vm_area_struct *vma;
>> +
>> +    uint32_t zc_dbi_max;
>> +    uint32_t zc_dbi_thresh;
>> +    unsigned long *zc_data_bitmap;
>> +
>>       struct xarray data_pages;
>>       uint32_t data_pages_per_blk;
>>       uint32_t data_blk_size;
>> @@ -177,6 +191,12 @@ struct tcmu_cmd {
>>       struct tcmu_dev *tcmu_dev;
>>       struct list_head queue_entry;
>>   +    /* For zero_copy handle */
>> +    struct mm_struct *vma_vm_mm;
>> +    struct vm_area_struct *vma;
>> +    struct iovec *iov;
>> +    int iov_cnt;
>> +
>
> I think, you don't need iov and iov_cnt. You can easily use the list of
> dbis instead. Also, using the iovs from the ring during command
> completion will not work, since the iovs might already be overwritten by
> userspace.
OK, will fix it.

>
>>       uint16_t cmd_id;
>>         /* Can't use se_cmd when cleaning up expired cmds, because if
>> @@ -192,6 +212,7 @@ struct tcmu_cmd {
>>     #define TCMU_CMD_BIT_EXPIRED 0
>>   #define TCMU_CMD_BIT_KEEP_BUF 1
>> +#define TCMU_CMD_BIT_ZEROCOPY 2
>>       unsigned long flags;
>>   };
>>   @@ -495,10 +516,16 @@ static struct genl_family tcmu_genl_family 
>> __ro_after_init = {
>>   static void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd, uint32_t 
>> len)
>>   {
>>       struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
>> +    unsigned long *data_bitmap;
>>       uint32_t i;
>>   +    if (test_bit(TCMU_CMD_BIT_ZEROCOPY, &tcmu_cmd->flags))
>> +        data_bitmap = udev->zc_data_bitmap;
>> +    else
>> +        data_bitmap = udev->data_bitmap;
>> +
>>       for (i = 0; i < len; i++)
>> -        clear_bit(tcmu_cmd->dbi[i], udev->data_bitmap);
>> +        clear_bit(tcmu_cmd->dbi[i], data_bitmap);
>>   }
>>     static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
>> @@ -549,8 +576,30 @@ static inline int tcmu_get_empty_block(struct 
>> tcmu_dev *udev,
>>       return i == page_cnt ? dbi : -1;
>>   }
>>   +static inline int tcmu_get_zc_empty_block(struct tcmu_dev *udev,
>> +            struct tcmu_cmd *tcmu_cmd, int prev_dbi,
>> +            int *iov_cnt)
>> +{
>> +    int dbi;
>> +
>> +    dbi = find_first_zero_bit(udev->zc_data_bitmap, 
>> udev->zc_dbi_thresh);
>> +    if (dbi == udev->zc_dbi_thresh)
>> +        return -1;
>> +
>> +    if (dbi > udev->zc_dbi_max)
>> +        udev->zc_dbi_max = dbi;
>> +
>> +    set_bit(dbi, udev->zc_data_bitmap);
>> +    tcmu_cmd_set_dbi(tcmu_cmd, dbi);
>> +
>> +    if (dbi != prev_dbi + 1)
>> +        *iov_cnt += 1;
>> +    return dbi;
>> +}
>> +
>>   static int tcmu_get_empty_blocks(struct tcmu_dev *udev,
>> -                 struct tcmu_cmd *tcmu_cmd, int length)
>> +                 struct tcmu_cmd *tcmu_cmd, int length,
>> +                 bool zero_copy)
>>   {
>>       /* start value of dbi + 1 must not be a valid dbi */
>>       int dbi = -2;
>> @@ -559,16 +608,111 @@ static int tcmu_get_empty_blocks(struct 
>> tcmu_dev *udev,
>>         for (; length > 0; length -= blk_size) {
>>           blk_data_len = min_t(uint32_t, length, blk_size);
>> -        dbi = tcmu_get_empty_block(udev, tcmu_cmd, dbi, blk_data_len,
>> -                       &iov_cnt);
>> +        if (zero_copy) {
>> +            dbi = tcmu_get_zc_empty_block(udev, tcmu_cmd, dbi,
>> +                              &iov_cnt);
>> +        } else {
>> +            dbi = tcmu_get_empty_block(udev, tcmu_cmd, dbi,
>> +                    blk_data_len, &iov_cnt);
>> +        }
>>           if (dbi < 0)
>>               return -1;
>>       }
>>       return iov_cnt;
>>   }
>>   +#define TCMU_ZEROCOPY_PAGE_BATCH 32
>> +
>> +static inline void tcmu_zerocopy_one_seg(struct iovec *iov,
>> +            struct vm_area_struct *vma,
>> +            struct sg_page_iter *sgiter)
>> +{
>> +    struct page *pages[TCMU_ZEROCOPY_PAGE_BATCH];
>> +    unsigned int len = iov->iov_len;
>> +    unsigned long address = (unsigned long)iov->iov_base + 
>> vma->vm_start;
>> +    unsigned long pages_remaining, pg_index = 0;
>> +    struct page *page;
>> +
>> +    while (len > 0) {
>> +        __sg_page_iter_next(sgiter);
>> +        page = sg_page_iter_page(sgiter);
>> +        pages[pg_index++] = page;
>> +        len -= PAGE_SIZE;
>> +        if (pg_index == TCMU_ZEROCOPY_PAGE_BATCH || !len) {
>> +            pages_remaining = pg_index;
>> +            vm_insert_pages_mkspecial(vma, address, pages, 
>> &pages_remaining);
>> +            address = address + pg_index * PAGE_SIZE;
>> +            pg_index = 0;
>> +        }
>> +    }
>> +}
>> +
>> +static long tcmu_cmd_zerocopy_map(struct tcmu_dev *udev,
>> +                  struct tcmu_cmd *cmd,
>> +                  struct iovec *iov,
>> +                  int iov_cnt)
>> +{
>> +    struct se_cmd *se_cmd = cmd->se_cmd;
>> +    struct scatterlist *data_sg;
>> +    unsigned int data_nents;
>> +    struct iovec *tiov;
>> +    struct sg_page_iter sgiter;
>> +    struct vm_area_struct *vma = udev->vma;
>> +    int i, ret = 0;
>
> What happens if the tcmu device currently is not open / mapped?
I'm not sure how it will happen.
But we may check whether udev->vma has a valid value. If yes,
it'll enter tcmu_cmd_zerocopy_map().

>
>> +
>> +    mmap_read_lock(udev->vma_vm_mm);
>> +    data_sg = se_cmd->t_data_sg;
>> +    data_nents = se_cmd->t_data_nents;
>> +    __sg_page_iter_start(&sgiter, data_sg, data_nents, 0);
>> +    tiov = iov;
>> +    for (i = 0; i < iov_cnt; i++) {
>> +        tcmu_zerocopy_one_seg(tiov, vma, &sgiter);
>> +        tiov++;
>> +    }
>> +    cmd->iov = iov;
>> +    cmd->iov_cnt = iov_cnt;
>
> This won't work!
>
> The iov's can already be overwritten when you later want to read
> them. So you would have to take a real copy of the iovs.
OK, will fix it.

>
>> +    cmd->vma_vm_mm = vma->vm_mm;
>> +    cmd->vma = vma;
>> +    mmgrab(cmd->vma_vm_mm);
>> +    mmap_read_unlock(udev->vma_vm_mm);
>> +    return ret;
>> +}
>> +
>> +static void tcmu_cmd_zerocopy_unmap(struct tcmu_cmd *cmd)
>> +{
>> +    struct mm_struct *mm;
>> +    struct vm_area_struct *vma;
>> +    struct iovec *iov;
>> +    unsigned long address;
>> +    int i;
>> +
>> +    mm = cmd->vma_vm_mm;
>> +    if (!mm)
>> +        return;
>> +
>> +    vma = cmd->vma;
>> +    iov = cmd->iov;
>> +    if (mmget_not_zero(mm)) {
>> +        mmap_read_lock(mm);
>> +        for (i = 0; i < cmd->iov_cnt; i++) {
>> +            address = (unsigned long)iov->iov_base + vma->vm_start;
>> +            zap_page_range(vma, address, iov->iov_len);
>> +            iov++;
>> +        }
>> +        mmap_read_unlock(mm);
>> +        mmput(mm);
>> +    }
>> +
>> +    cmd->vma_vm_mm = NULL;
>> +    cmd->vma = NULL;
>> +    mmdrop(mm);
>> +}
>> +
>>   static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
>>   {
>> +    if (test_bit(TCMU_CMD_BIT_ZEROCOPY, &tcmu_cmd->flags))
>> +        tcmu_cmd_zerocopy_unmap(tcmu_cmd);
>> +
>>       kfree(tcmu_cmd->dbi);
>>       kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
>>   }
>> @@ -850,37 +994,57 @@ static bool is_ring_space_avail(struct tcmu_dev 
>> *udev, size_t cmd_size)
>>    * Called with ring lock held.
>>    */
>>   static int tcmu_alloc_data_space(struct tcmu_dev *udev, struct 
>> tcmu_cmd *cmd,
>> -                  int *iov_bidi_cnt)
>> +                  int *iov_bidi_cnt, bool zero_copy)
>>   {
>>       int space, iov_cnt = 0, ret = 0;
>>         if (!cmd->dbi_cnt)
>>           goto wr_iov_cnts;
>>   -    /* try to check and get the data blocks as needed */
>> -    space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
>> -    if (space < cmd->dbi_cnt) {
>> -        unsigned long blocks_left =
>> -                (udev->max_blocks - udev->dbi_thresh) + space;
>> +    if (!zero_copy) {
>> +        /* try to check and get the data blocks as needed */
>> +        space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
>> +        if (space < cmd->dbi_cnt) {
>> +            unsigned long blocks_left =
>> +                    (udev->max_blocks - udev->dbi_thresh) + space;
>> +
>> +            if (blocks_left < cmd->dbi_cnt) {
>> +                pr_debug("no data space: only %lu available, but ask 
>> for %u\n",
>> +                        blocks_left * udev->data_blk_size,
>> +                        cmd->dbi_cnt * udev->data_blk_size);
>> +                return -1;
>> +            }
>>   -        if (blocks_left < cmd->dbi_cnt) {
>> -            pr_debug("no data space: only %lu available, but ask for 
>> %u\n",
>> -                    blocks_left * udev->data_blk_size,
>> -                    cmd->dbi_cnt * udev->data_blk_size);
>> -            return -1;
>> +            udev->dbi_thresh += cmd->dbi_cnt;
>> +            if (udev->dbi_thresh > udev->max_blocks)
>> +                udev->dbi_thresh = udev->max_blocks;
>>           }
>> +    } else {
>> +        /* try to check and get the data blocks as needed */
>> +        space = spc_bitmap_free(udev->zc_data_bitmap, 
>> udev->zc_dbi_thresh);
>> +        if (space < cmd->dbi_cnt) {
>> +            unsigned long blocks_left =
>> +                    (udev->zc_max_blocks - udev->zc_dbi_thresh) + 
>> space;
>> +
>> +            if (blocks_left < cmd->dbi_cnt) {
>> +                pr_debug("no data space: only %lu available, but ask 
>> for %u\n",
>> +                        blocks_left * udev->data_blk_size,
>> +                        cmd->dbi_cnt * udev->data_blk_size);
>> +                return -1;
>> +            }
>>   -        udev->dbi_thresh += cmd->dbi_cnt;
>> -        if (udev->dbi_thresh > udev->max_blocks)
>> -            udev->dbi_thresh = udev->max_blocks;
>> +            udev->zc_dbi_thresh += cmd->dbi_cnt;
>> +            if (udev->zc_dbi_thresh > udev->zc_max_blocks)
>> +                udev->zc_dbi_thresh = udev->zc_max_blocks;
>> +        }
>>       }
>>   -    iov_cnt = tcmu_get_empty_blocks(udev, cmd, 
>> cmd->se_cmd->data_length);
>> +    iov_cnt = tcmu_get_empty_blocks(udev, cmd, 
>> cmd->se_cmd->data_length, zero_copy);
>>       if (iov_cnt < 0)
>>           return -1;
>>         if (cmd->dbi_bidi_cnt) {
>> -        ret = tcmu_get_empty_blocks(udev, cmd, cmd->data_len_bidi);
>> +        ret = tcmu_get_empty_blocks(udev, cmd, cmd->data_len_bidi, 
>> zero_copy);
>>           if (ret < 0)
>>               return -1;
>>       }
>> @@ -1021,6 +1185,7 @@ static int queue_cmd_ring(struct tcmu_cmd 
>> *tcmu_cmd, sense_reason_t *scsi_err)
>>       uint32_t blk_size = udev->data_blk_size;
>>       /* size of data buffer needed */
>>       size_t data_length = (size_t)tcmu_cmd->dbi_cnt * blk_size;
>> +    bool zero_copy = false;
>>         *scsi_err = TCM_NO_SENSE;
>>   @@ -1044,7 +1209,22 @@ static int queue_cmd_ring(struct tcmu_cmd 
>> *tcmu_cmd, sense_reason_t *scsi_err)
>>           return -1;
>>       }
>>   -    iov_cnt = tcmu_alloc_data_space(udev, tcmu_cmd, &iov_bidi_cnt);
>> +    if (!(se_cmd->se_cmd_flags & SCF_BIDI) && se_cmd->data_length &&
>> +        IS_ALIGNED(se_cmd->data_length, PAGE_SIZE)) {
>
> What is the problem with BIDI here? Why do you skip those cmds?
No special reason, just want to be simple in RFC patch set.
I will add this support in next version.

>
>> +        struct scatterlist *data_sg = se_cmd->t_data_sg, *sg;
>> +        unsigned int data_nents = se_cmd->t_data_nents;
>> +        int i;
>> +
>> +        for_each_sg(data_sg, sg, data_nents, i) {
>> +            if (!((!sg->offset || IS_ALIGNED(sg->offset, PAGE_SIZE)) &&
>> +                IS_ALIGNED(sg->length, PAGE_SIZE)))
>> +                break;
>> +        }
>> +        if (i == data_nents)
>> +            zero_copy = true;
>> +    }
>> +
>> +    iov_cnt = tcmu_alloc_data_space(udev, tcmu_cmd, &iov_bidi_cnt, 
>> zero_copy);
>>       if (iov_cnt < 0)
>>           goto free_and_queue;
>>   @@ -1093,7 +1273,7 @@ static int queue_cmd_ring(struct tcmu_cmd 
>> *tcmu_cmd, sense_reason_t *scsi_err)
>>       tcmu_cmd_reset_dbi_cur(tcmu_cmd);
>>       iov = &entry->req.iov[0];
>>   -    if (se_cmd->data_direction == DMA_TO_DEVICE ||
>> +    if (((se_cmd->data_direction == DMA_TO_DEVICE) && !zero_copy) ||
>>           se_cmd->se_cmd_flags & SCF_BIDI)
>>           scatter_data_area(udev, tcmu_cmd, &iov);
>>       else
>> @@ -1111,6 +1291,11 @@ static int queue_cmd_ring(struct tcmu_cmd 
>> *tcmu_cmd, sense_reason_t *scsi_err)
>>       tcmu_setup_cmd_timer(tcmu_cmd, udev->cmd_time_out, 
>> &udev->cmd_timer);
>>         entry->hdr.cmd_id = tcmu_cmd->cmd_id;
>> +    if (zero_copy) {
>> +        iov = &entry->req.iov[0];
>> +        tcmu_cmd_zerocopy_map(udev, tcmu_cmd, iov, entry->req.iov_cnt);
>
> This call maps the kernel pages from sgl to userspace no matter whether
> it is a READ or WRITE type of cmd. That means, if it is READ, then you
> might map old kernel data to userspace, right?
Yes, I'm not sure whether it would be a security issue. Use real hardware
storage will also run into this issue, if this real hardware storage 
isn't credible.

>
>> +        set_bit(TCMU_CMD_BIT_ZEROCOPY, &tcmu_cmd->flags);
>> +    }
>>         tcmu_hdr_set_len(&entry->hdr.len_op, command_size);
>>   @@ -1366,7 +1551,10 @@ static bool tcmu_handle_completion(struct 
>> tcmu_cmd *cmd,
>>           else
>>               se_cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;
>>       }
>> -    if (se_cmd->se_cmd_flags & SCF_BIDI) {
>> +
>> +    if (test_bit(TCMU_CMD_BIT_ZEROCOPY, &cmd->flags)) {
>> +        tcmu_cmd_zerocopy_unmap(cmd);
>> +    } else if (se_cmd->se_cmd_flags & SCF_BIDI) {
>>           /* Get Data-In buffer before clean up */
>>           gather_data_area(udev, cmd, true, read_len);
>>       } else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
>> @@ -1520,6 +1708,8 @@ static void tcmu_check_expired_ring_cmd(struct 
>> tcmu_cmd *cmd)
>>       if (!time_after_eq(jiffies, cmd->deadline))
>>           return;
>>   +    if (test_bit(TCMU_CMD_BIT_ZEROCOPY, &cmd->flags))
>> +        tcmu_cmd_zerocopy_unmap(cmd);
>>       set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
>>       list_del_init(&cmd->queue_entry);
>>       se_cmd = cmd->se_cmd;
>> @@ -1618,6 +1808,8 @@ static struct se_device 
>> *tcmu_alloc_device(struct se_hba *hba, const char *name)
>>       udev->data_pages_per_blk = DATA_PAGES_PER_BLK_DEF;
>>       udev->max_blocks = DATA_AREA_PAGES_DEF / udev->data_pages_per_blk;
>>       udev->data_area_mb = TCMU_PAGES_TO_MBS(DATA_AREA_PAGES_DEF);
>> +    udev->zc_max_blocks = ZC_DATA_AREA_PAGES_DEF / 
>> udev->data_pages_per_blk;
>> +    udev->zc_data_area_mb = TCMU_PAGES_TO_MBS(ZC_DATA_AREA_PAGES_DEF);
>>         mutex_init(&udev->cmdr_lock);
>>   @@ -1841,6 +2033,9 @@ static void tcmu_vma_open(struct 
>> vm_area_struct *vma)
>>         pr_debug("vma_open\n");
>>   +    udev->vma_vm_mm = vma->vm_mm;
>> +    udev->vma = vma;
>> +    mmgrab(udev->vma_vm_mm);
>
> What about the mmap being opened multiple times?
> Up to now tcmu allows one open() only. But after open() userspace might
> fork with parent and child calling mmap() independently.
> AFAIK, tcmu_vma_open will then be called twice, but I don't know whether
> it is the same vma in both calls.
I think parent and child process will have different vma address. I had 
thought
this usage before, it will result in inconsistent or bugs. But In real 
application,
even without zero copy feature, if parent and child process operate the same
comm ring, seems that it will also result inconsistent or bugs.
I'll have a deep look at codes, thanks.


Regards,
Xiaoguang Wang
>
>>       kref_get(&udev->kref);
>>   }
>>   @@ -1850,6 +2045,10 @@ static void tcmu_vma_close(struct 
>> vm_area_struct *vma)
>>         pr_debug("vma_close\n");
>>   +    mmdrop(udev->vma_vm_mm);
>> +    udev->vma_vm_mm = NULL;
>> +    udev->vma = NULL;
>> +
>>       /* release ref from tcmu_vma_open */
>>       kref_put(&udev->kref, tcmu_dev_kref_release);
>>   }
>> @@ -1901,7 +2100,7 @@ static int tcmu_mmap(struct uio_info *info, 
>> struct vm_area_struct *vma)
>>   {
>>       struct tcmu_dev *udev = container_of(info, struct tcmu_dev, 
>> uio_info);
>>   -    vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
>> +    vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP | VM_MIXEDMAP;
>>       vma->vm_ops = &tcmu_vm_ops;
>>         vma->vm_private_data = udev;
>> @@ -2172,7 +2371,7 @@ static int tcmu_configure_device(struct 
>> se_device *dev)
>>       struct tcmu_dev *udev = TCMU_DEV(dev);
>>       struct uio_info *info;
>>       struct tcmu_mailbox *mb;
>> -    size_t data_size;
>> +    size_t data_size, zc_data_size;
>>       int ret = 0;
>>         ret = tcmu_update_uio_info(udev);
>> @@ -2183,8 +2382,9 @@ static int tcmu_configure_device(struct 
>> se_device *dev)
>>         mutex_lock(&udev->cmdr_lock);
>>       udev->data_bitmap = bitmap_zalloc(udev->max_blocks, GFP_KERNEL);
>> +    udev->zc_data_bitmap = bitmap_zalloc(udev->zc_max_blocks, 
>> GFP_KERNEL);
>>       mutex_unlock(&udev->cmdr_lock);
>> -    if (!udev->data_bitmap) {
>> +    if (!udev->data_bitmap || !udev->zc_data_bitmap) {
>>           ret = -ENOMEM;
>>           goto err_bitmap_alloc;
>>       }
>> @@ -2201,7 +2401,8 @@ static int tcmu_configure_device(struct 
>> se_device *dev)
>>       udev->cmdr_size = CMDR_SIZE;
>>       udev->data_off = MB_CMDR_SIZE;
>>       data_size = TCMU_MBS_TO_PAGES(udev->data_area_mb) << PAGE_SHIFT;
>> -    udev->mmap_pages = (data_size + MB_CMDR_SIZE) >> PAGE_SHIFT;
>> +    zc_data_size = TCMU_MBS_TO_PAGES(udev->zc_data_area_mb) << 
>> PAGE_SHIFT;
>> +    udev->mmap_pages = (data_size + zc_data_size + MB_CMDR_SIZE) >> 
>> PAGE_SHIFT;
>>       udev->data_blk_size = udev->data_pages_per_blk * PAGE_SIZE;
>>       udev->dbi_thresh = 0; /* Default in Idle state */
>>   @@ -2221,7 +2422,7 @@ static int tcmu_configure_device(struct 
>> se_device *dev)
>>         info->mem[0].name = "tcm-user command & data buffer";
>>       info->mem[0].addr = (phys_addr_t)(uintptr_t)udev->mb_addr;
>> -    info->mem[0].size = data_size + MB_CMDR_SIZE;
>> +    info->mem[0].size = data_size + zc_data_size + MB_CMDR_SIZE;
>>       info->mem[0].memtype = UIO_MEM_NONE;
>>         info->irqcontrol = tcmu_irqcontrol;

