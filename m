Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEE2C5ACAE
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 14:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C0BA20872
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 14:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfIKOVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 10:21:16 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63115 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKOVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2019 10:21:16 -0400
Received: from fsav403.sakura.ne.jp (fsav403.sakura.ne.jp [133.242.250.102])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x8BEKgld005032;
        Wed, 11 Sep 2019 23:20:42 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav403.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav403.sakura.ne.jp);
 Wed, 11 Sep 2019 23:20:42 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav403.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126227201116.bbtec.net [126.227.201.116])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x8BEKg1D005028
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Wed, 11 Sep 2019 23:20:42 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
To:     Hillf Danton <hdanton@sina.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, axboe@kernel.dk,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
References: <20190911031348.9648-1-hdanton@sina.com>
 <20190911135237.11248-1-hdanton@sina.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <6cff2ae9-4436-8df7-55a7-59e2e80b1054@i-love.sakura.ne.jp>
Date:   Wed, 11 Sep 2019 23:20:38 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190911135237.11248-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/11 22:52, Hillf Danton wrote:
> 
> On Wed, 11 Sep 2019 19:07:34 +0900
>>
>> But I guess that there is a problem.
> 
> Not a new one. (see commit 7dea19f9ee63)
> 
>> Setting PF_MEMALLOC_NOIO causes
>> current_gfp_context() to mask __GFP_IO | __GFP_FS, but the OOM killer cannot
>> be invoked when __GFP_FS is masked. As a result, any userspace thread which
>> has PF_MEMALLOC_NOIO cannot invoke the OOM killer.
> 
> Correct.
> 
>> If the userspace thread
>> which uses PF_MEMALLOC_NOIO is involved in memory reclaiming activities,
>> the memory reclaiming activities won't be able to make forward progress when
>> the userspace thread triggered e.g. a page fault. Can the "userspace components
>> that can run in the IO path" survive without any memory allocation?
> 
> Good question.
> 
> It can be solved without oom killer involved because user should be
> aware of the risk of PF_MEMALLOC_NOIO if they ask for the convenience.
> OTOH we are able to control any abuse of it as you worry, knowing that
> the combination of __GFP_FS and oom killer can not get more than 50 users
> works done, and we have to pay as much attention as we can to the decisions
> they make. In case of PF_MEMALLOC_NOIO, we simply fail the allocation
> rather than killing a random victim.

According to commit c288983dddf71421 ("mm/page_alloc.c: make sure OOM victim can
try allocations with no watermarks once"), memory allocation failure from a page
fault results in invocation of the OOM killer via pagefault_out_of_memory() which
after all kills a random victim.

> 
> 
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3854,6 +3854,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
>  	 * out_of_memory). Once filesystems are ready to handle allocation
>  	 * failures more gracefully we should just bail out here.
>  	 */
> +	if (current->flags & PF_MEMALLOC_NOIO)
> +		goto out;
>  
>  	/* The OOM killer may not free memory on a specific node */
>  	if (gfp_mask & __GFP_THISNODE)
> 
> 
