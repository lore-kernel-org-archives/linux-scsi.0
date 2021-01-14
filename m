Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F538C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 21:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BED223A5C
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 21:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbhANVlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 16:41:36 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:33301 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbhANVlc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 16:41:32 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id F1A642EA095;
        Thu, 14 Jan 2021 16:40:49 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id BRR6184JUoSO; Thu, 14 Jan 2021 16:27:30 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 4AC072EA090;
        Thu, 14 Jan 2021 16:40:49 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v13 39/45] sg: add mmap_sz tracking
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com
References: <20210113224526.861000-1-dgilbert@interlog.com>
 <20210113224526.861000-40-dgilbert@interlog.com>
 <bb1cb45f-ace2-250e-a5ff-654c85013fe5@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <8f3c11cd-4899-6f15-3034-3dbfaa85f16c@interlog.com>
Date:   Thu, 14 Jan 2021 16:40:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bb1cb45f-ace2-250e-a5ff-654c85013fe5@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-14 2:18 a.m., Hannes Reinecke wrote:
> On 1/13/21 11:45 PM, Douglas Gilbert wrote:
>> Track mmap_sz from prior mmap(2) call, per sg file descriptor. Also
>> reset this value whenever munmap(2) is called. Fail SG_FLAG_MMAP_IO
>> uses if mmap(2) hasn't been called or the memory associated with it
>> is not large enough for the current request.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/sg.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index c5533bbaf0d5..d0f25f8f572b 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -232,6 +232,7 @@ struct sg_fd {        /* holds the state of a file 
>> descriptor */
>>       atomic_t waiting;    /* number of requests awaiting receive */
>>       atomic_t req_cnt;    /* number of requests */
>>       int sgat_elem_sz;    /* initialized to scatter_elem_sz */
>> +    int mmap_sz;        /* byte size of previous mmap() call */
>>       unsigned long ffd_bm[1];    /* see SG_FFD_* defines above */
>>       pid_t tid;        /* thread id when opened */
>>       u8 next_cmd_len;    /* 0: automatic, >0: use on next write() */
>> @@ -725,10 +726,14 @@ sg_write(struct file *filp, const char __user *p, size_t 
>> count, loff_t *ppos)
>>   static inline int
>>   sg_chk_mmap(struct sg_fd *sfp, int rq_flags, int len)
>>   {
>> +    if (!test_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm))
>> +        return -EBADFD;
>>       if (atomic_read(&sfp->submitted) > 0)
>>           return -EBUSY;  /* already active requests on fd */
>>       if (len > sfp->rsv_srp->sgat_h.buflen)
>>           return -ENOMEM; /* MMAP_IO size must fit in reserve */
>> +    if (unlikely(len > sfp->mmap_sz))
>> +        return -ENOMEM; /* MMAP_IO size can't exceed mmap() size */
>>       if (rq_flags & SG_FLAG_DIRECT_IO)
>>           return -EINVAL; /* not both MMAP_IO and DIRECT_IO */
>>       return 0;
>> @@ -2262,6 +2267,8 @@ sg_vma_close(struct vm_area_struct *vma)
>>           pr_warn("%s: sfp null\n", __func__);
>>           return;
>>       }
>> +    sfp->mmap_sz = 0;
>> +    clear_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm);
>>       kref_put(&sfp->f_ref, sg_remove_sfp); /* get in: sg_vma_open() */
>>   }
>> @@ -2383,6 +2390,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
>>               goto fini;
>>           }
>>       }
>> +    sfp->mmap_sz = req_sz;
>>       vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
>>       vma->vm_private_data = sfp;
>>       vma->vm_ops = &sg_mmap_vm_ops;
>> @@ -4048,8 +4056,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, 
>> unsigned long idx)
>>                  (int)test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm),
>>                  (int)test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm),
>>                  fp->ffd_bm[0]);
>> -    n += scnprintf(obp + n, len - n, "   mmap_called=%d\n",
>> -               test_bit(SG_FFD_MMAP_CALLED, fp->ffd_bm));
>> +    n += scnprintf(obp + n, len - n, "   mmap_sz=%d\n", fp->mmap_sz);
>>       n += scnprintf(obp + n, len - n,
>>                  "   submitted=%d waiting=%d   open thr_id=%d\n",
>>                  atomic_read(&fp->submitted),
>>
> What is the point of having the SG_FFD_MMAP_CALLED bit now?
> Doesn't the new 'mmap_sz' value carry the same information?

Touché! Will fix.

Doug Gilbert
