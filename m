Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE82FC5ACAE
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 10:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B40620863
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 10:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfIKKIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 06:08:02 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64208 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbfIKKIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2019 06:08:02 -0400
Received: from fsav302.sakura.ne.jp (fsav302.sakura.ne.jp [153.120.85.133])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x8BA7cIq048562;
        Wed, 11 Sep 2019 19:07:38 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav302.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav302.sakura.ne.jp);
 Wed, 11 Sep 2019 19:07:38 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav302.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126227201116.bbtec.net [126.227.201.116])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x8BA7YlU048512
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Wed, 11 Sep 2019 19:07:38 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: Re: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
To:     Hillf Danton <hdanton@sina.com>,
        Mike Christie <mchristi@redhat.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>, axboe@kernel.dk,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
References: <20190911031348.9648-1-hdanton@sina.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <c48cd3d8-699d-a614-b12d-1ddef71691f3@I-love.SAKURA.ne.jp>
Date:   Wed, 11 Sep 2019 19:07:34 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190911031348.9648-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/11 12:13, Hillf Danton wrote:
> 
> On Tue, 10 Sep 2019 11:06:03 -0500 From: Mike Christie <mchristi@redhat.com>
>>
>>> Really? Without any privilege check? So any random user can tap into
>>> __GFP_NOIO allocations?
>>
>> That was a mistake on my part. I will add it in.
>>
> You may alternatively madvise a nutcracker as long as you would have
> added a sledgehammer under /proc instead of a gavel.
> 
> --- a/include/uapi/asm-generic/mman-common.h
> +++ b/include/uapi/asm-generic/mman-common.h
> @@ -45,6 +45,7 @@
>  #define MADV_SEQUENTIAL	2		/* expect sequential page references */
>  #define MADV_WILLNEED	3		/* will need these pages */
>  #define MADV_DONTNEED	4		/* don't need these pages */
> +#define MADV_NOIO	5		/* set PF_MEMALLOC_NOIO */
>  
>  /* common parameters: try to keep these consistent across architectures */
>  #define MADV_FREE	8		/* free pages only if memory pressure */
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -716,6 +716,7 @@ madvise_behavior_valid(int behavior)
>  	case MADV_WILLNEED:
>  	case MADV_DONTNEED:
>  	case MADV_FREE:
> +	case MADV_NOIO:
>  #ifdef CONFIG_KSM
>  	case MADV_MERGEABLE:
>  	case MADV_UNMERGEABLE:
> @@ -813,6 +814,11 @@ SYSCALL_DEFINE3(madvise, unsigned long,
>  	if (!madvise_behavior_valid(behavior))
>  		return error;
>  
> +	if (behavior == MADV_NOIO) {
> +		current->flags |= PF_MEMALLOC_NOIO;

Yes, for "modifying p->flags when p != current" is not permitted.

But I guess that there is a problem. Setting PF_MEMALLOC_NOIO causes
current_gfp_context() to mask __GFP_IO | __GFP_FS, but the OOM killer cannot
be invoked when __GFP_FS is masked. As a result, any userspace thread which
has PF_MEMALLOC_NOIO cannot invoke the OOM killer. If the userspace thread
which uses PF_MEMALLOC_NOIO is involved in memory reclaiming activities,
the memory reclaiming activities won't be able to make forward progress when
the userspace thread triggered e.g. a page fault. Can the "userspace components
that can run in the IO path" survive without any memory allocation?

> +		return 0;
> +	}
> +
>  	if (start & ~PAGE_MASK)
>  		return error;
>  	len = (len_in + ~PAGE_MASK) & PAGE_MASK;

