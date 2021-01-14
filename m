Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F38EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 07:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 497CD239A1
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 07:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbhANHSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 02:18:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:36824 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbhANHSn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 02:18:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 870A1AB7A;
        Thu, 14 Jan 2021 07:18:01 +0000 (UTC)
Subject: Re: [PATCH v13 39/45] sg: add mmap_sz tracking
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com
References: <20210113224526.861000-1-dgilbert@interlog.com>
 <20210113224526.861000-40-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bb1cb45f-ace2-250e-a5ff-654c85013fe5@suse.de>
Date:   Thu, 14 Jan 2021 08:18:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210113224526.861000-40-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/13/21 11:45 PM, Douglas Gilbert wrote:
> Track mmap_sz from prior mmap(2) call, per sg file descriptor. Also
> reset this value whenever munmap(2) is called. Fail SG_FLAG_MMAP_IO
> uses if mmap(2) hasn't been called or the memory associated with it
> is not large enough for the current request.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index c5533bbaf0d5..d0f25f8f572b 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -232,6 +232,7 @@ struct sg_fd {		/* holds the state of a file descriptor */
>   	atomic_t waiting;	/* number of requests awaiting receive */
>   	atomic_t req_cnt;	/* number of requests */
>   	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
> +	int mmap_sz;		/* byte size of previous mmap() call */
>   	unsigned long ffd_bm[1];	/* see SG_FFD_* defines above */
>   	pid_t tid;		/* thread id when opened */
>   	u8 next_cmd_len;	/* 0: automatic, >0: use on next write() */
> @@ -725,10 +726,14 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
>   static inline int
>   sg_chk_mmap(struct sg_fd *sfp, int rq_flags, int len)
>   {
> +	if (!test_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm))
> +		return -EBADFD;
>   	if (atomic_read(&sfp->submitted) > 0)
>   		return -EBUSY;  /* already active requests on fd */
>   	if (len > sfp->rsv_srp->sgat_h.buflen)
>   		return -ENOMEM; /* MMAP_IO size must fit in reserve */
> +	if (unlikely(len > sfp->mmap_sz))
> +		return -ENOMEM; /* MMAP_IO size can't exceed mmap() size */
>   	if (rq_flags & SG_FLAG_DIRECT_IO)
>   		return -EINVAL; /* not both MMAP_IO and DIRECT_IO */
>   	return 0;
> @@ -2262,6 +2267,8 @@ sg_vma_close(struct vm_area_struct *vma)
>   		pr_warn("%s: sfp null\n", __func__);
>   		return;
>   	}
> +	sfp->mmap_sz = 0;
> +	clear_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm);
>   	kref_put(&sfp->f_ref, sg_remove_sfp); /* get in: sg_vma_open() */
>   }
>   
> @@ -2383,6 +2390,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
>   			goto fini;
>   		}
>   	}
> +	sfp->mmap_sz = req_sz;
>   	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
>   	vma->vm_private_data = sfp;
>   	vma->vm_ops = &sg_mmap_vm_ops;
> @@ -4048,8 +4056,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
>   		       (int)test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm),
>   		       (int)test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm),
>   		       fp->ffd_bm[0]);
> -	n += scnprintf(obp + n, len - n, "   mmap_called=%d\n",
> -		       test_bit(SG_FFD_MMAP_CALLED, fp->ffd_bm));
> +	n += scnprintf(obp + n, len - n, "   mmap_sz=%d\n", fp->mmap_sz);
>   	n += scnprintf(obp + n, len - n,
>   		       "   submitted=%d waiting=%d   open thr_id=%d\n",
>   		       atomic_read(&fp->submitted),
> 
What is the point of having the SG_FFD_MMAP_CALLED bit now?
Doesn't the new 'mmap_sz' value carry the same information?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
