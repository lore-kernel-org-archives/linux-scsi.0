Return-Path: <SRS0=qYHy=XF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB10C3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 10:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D948520872
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 10:00:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov-name.20150623.gappssmtp.com header.i=@shutemov-name.20150623.gappssmtp.com header.b="GxPXDkYL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391953AbfIJKAE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 06:00:04 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45832 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388653AbfIJKAD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 06:00:03 -0400
Received: by mail-ed1-f67.google.com with SMTP id f19so16428535eds.12
        for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2019 03:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pUWhX3ThjBsfsGFjHTg5vM8zbxi9HZ/0nZMiaDbj8tw=;
        b=GxPXDkYLjPwpEyC9jWChtUTWeR0/79A5cu90rpnDmM8on2MRXtnBKzG29ORgLNA6f1
         txcUcoaQTdyTAiUGkQUZZPJkuD7nugbVl3CoybHPuQAFAMtvHrQNCku4QefgSsIOGT5b
         GUwbPSSrp+wXw9hrMHdTQNdmUSFac6yQhUk7I67mBDwyM41vxlCITlbm0a6vv00s+fSY
         qXDIpgTKRMsVg9s5v3fD0Iea3f5IqYCoYeYadWUZdGSt94hYnIyN0FHw7mmmsMZPFsKe
         4eW7ii0xEN698uaYMy49yVN+Hursc/82AAUIRsnWjFuvJblw4Boic9ulaxPxCxm0f7Y3
         0oLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pUWhX3ThjBsfsGFjHTg5vM8zbxi9HZ/0nZMiaDbj8tw=;
        b=D97BYoorUviTLXbfJP3lj7sRXVmXXmyBWIY2WQX6ajDZKIZ52EsnnMnxj0XO77hJb4
         pWpTeEyQmLfbR2EaNLD6lOT6WWK6rAu+ey1l8WTeGPRTk4jPPllf2rLM+cNOPpP8K3DB
         8HnmxJcBQB/GwLsJ849o78R9eHEEBeuoUf4588D06D3+FH8ESE9xP5cUFcnjuy5zd2lH
         zJg9m5gwT8dhGirHrh7n2/v6ikiz8rsWI2JhyYNbKRqy6S2zMX8UUCE2WzaDtUABrch1
         MsAzdz2UeSwB9A3x4l83/YXJMbY+DuYfNORm7HWw5VRNbR0ox2zhUDmoo9L/lXQfrSYd
         jcXg==
X-Gm-Message-State: APjAAAV5iQc4WknNNeO2EDI16Mt8F9PzNaZc6pRF+m+zUXa59cN6scuO
        PCpEJ/rKG03zfuceBPmVwsHzzQ==
X-Google-Smtp-Source: APXvYqzz4uL9Be0Dv1iBucS5Ebliv1AOhngwcvBEpja1udqCYli84dpW7omCy5uIzxmAlbj9c8Usvw==
X-Received: by 2002:a17:906:5f84:: with SMTP id a4mr23374522eju.109.1568109601468;
        Tue, 10 Sep 2019 03:00:01 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id a55sm3486246edd.34.2019.09.10.03.00.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 03:00:00 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id E0B701009F6; Tue, 10 Sep 2019 13:00:00 +0300 (+03)
Date:   Tue, 10 Sep 2019 13:00:00 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Mike Christie <mchristi@redhat.com>
Cc:     axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
Message-ID: <20190910100000.mcik63ot6o3dyzjv@box.shutemov.name>
References: <20190909162804.5694-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909162804.5694-1-mchristi@redhat.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 09, 2019 at 11:28:04AM -0500, Mike Christie wrote:
> There are several storage drivers like dm-multipath, iscsi, and nbd that
> have userspace components that can run in the IO path. For example,
> iscsi and nbd's userspace deamons may need to recreate a socket and/or
> send IO on it, and dm-multipath's daemon multipathd may need to send IO
> to figure out the state of paths and re-set them up.
> 
> In the kernel these drivers have access to GFP_NOIO/GFP_NOFS and the
> memalloc_*_save/restore functions to control the allocation behavior,
> but for userspace we would end up hitting a allocation that ended up
> writing data back to the same device we are trying to allocate for.
> 
> This patch allows the userspace deamon to set the PF_MEMALLOC* flags
> through procfs. It currently only supports PF_MEMALLOC_NOIO, but
> depending on what other drivers and userspace file systems need, for
> the final version I can add the other flags for that file or do a file
> per flag or just do a memalloc_noio file.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  Documentation/filesystems/proc.txt |  6 ++++
>  fs/proc/base.c                     | 53 ++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 99ca040e3f90..b5456a61a013 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -46,6 +46,7 @@ Table of Contents
>    3.10  /proc/<pid>/timerslack_ns - Task timerslack value
>    3.11	/proc/<pid>/patch_state - Livepatch patch operation state
>    3.12	/proc/<pid>/arch_status - Task architecture specific information
> +  3.13  /proc/<pid>/memalloc - Control task's memory reclaim behavior
>  
>    4	Configuring procfs
>    4.1	Mount options
> @@ -1980,6 +1981,11 @@ Example
>   $ cat /proc/6753/arch_status
>   AVX512_elapsed_ms:      8
>  
> +3.13 /proc/<pid>/memalloc - Control task's memory reclaim behavior
> +-----------------------------------------------------------------------
> +A value of "noio" indicates that when a task allocates memory it will not
> +reclaim memory that requires starting phisical IO.
> +
>  Description
>  -----------
>  
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index ebea9501afb8..c4faa3464602 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1223,6 +1223,57 @@ static const struct file_operations proc_oom_score_adj_operations = {
>  	.llseek		= default_llseek,
>  };
>  
> +static ssize_t memalloc_read(struct file *file, char __user *buf, size_t count,
> +			     loff_t *ppos)
> +{
> +	struct task_struct *task;
> +	ssize_t rc = 0;
> +
> +	task = get_proc_task(file_inode(file));
> +	if (!task)
> +		return -ESRCH;
> +
> +	if (task->flags & PF_MEMALLOC_NOIO)
> +		rc = simple_read_from_buffer(buf, count, ppos, "noio", 4);
> +	put_task_struct(task);
> +	return rc;
> +}
> +
> +static ssize_t memalloc_write(struct file *file, const char __user *buf,
> +			      size_t count, loff_t *ppos)
> +{
> +	struct task_struct *task;
> +	char buffer[5];
> +	int rc = count;
> +
> +	memset(buffer, 0, sizeof(buffer));
> +	if (count != sizeof(buffer) - 1)
> +		return -EINVAL;
> +
> +	if (copy_from_user(buffer, buf, count))
> +		return -EFAULT;
> +	buffer[count] = '\0';
> +
> +	task = get_proc_task(file_inode(file));
> +	if (!task)
> +		return -ESRCH;
> +
> +	if (!strcmp(buffer, "noio")) {
> +		task->flags |= PF_MEMALLOC_NOIO;
> +	} else {
> +		rc = -EINVAL;
> +	}

Really? Without any privilege check? So any random user can tap into
__GFP_NOIO allocations?

NAK.

I don't think that it's great idea in general to expose this low-level
machinery to userspace. But it's better to get comment from people move
familiar with reclaim path.

-- 
 Kirill A. Shutemov
