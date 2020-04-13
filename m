Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764DAC2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 22:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ADCB20735
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 22:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389505AbgDMWPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 18:15:50 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42126 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727871AbgDMWPt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Apr 2020 18:15:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D5E8520425A;
        Tue, 14 Apr 2020 00:15:45 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bXtObVqnq5wF; Tue, 14 Apr 2020 00:15:40 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 0C172204155;
        Tue, 14 Apr 2020 00:15:38 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: sg: fix memory leak in sg_build_indirect
To:     Li Bin <huawei.libin@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiexiuqi@huawei.com
References: <1586777552-17524-1-git-send-email-huawei.libin@huawei.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <8a11ba5c-3836-0d95-7f70-7dc32bda95c1@interlog.com>
Date:   Mon, 13 Apr 2020 18:15:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1586777552-17524-1-git-send-email-huawei.libin@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-13 7:32 a.m., Li Bin wrote:
> Fix a memory leak when there have failed, that we should free the pages
> under the condition rem_sz > 0.

May I paraphrase the above:
"Fix a memory leak that occurs when alloc_pages() succeeds several
  times before failing. This condition is noticed when rem_sz > 0."

> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>
> ---
>   drivers/scsi/sg.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 4e6af592..8441ac5 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1959,8 +1959,12 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon

It is the sg_build_indirect() function not sg_compat_ioctl() as suggested
above by git. Can be get a replacement for git :-)

>   			 k, rem_sz));
>   
>   	schp->bufflen = blk_size;
> -	if (rem_sz > 0)	/* must have failed */
> +	if (rem_sz > 0)	{ /* must have failed */
> +		for (i = 0; i < k; i++)
> +			__free_pages(schp->pages[i], order);
> +
>   		return -ENOMEM;

It is easier, and less code, to replace 'return -ENOMEM'; with
'goto out'. Or even simpler:

     if (likely(rem_sz == 0))
	return 0;
out:
      ........

Doug Gilbert


BTW I spotted this one during the sg driver rewrite and fixed it.
Note that this bug and several others like it won't be fixed by
me while the sg driver rewrite is pending.

> +	}
>   	return 0;
>   out:
>   	for (i = 0; i < k; i++)
> 

