From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk_rq_map_user_iov: fix error override
Date: Mon, 15 Jan 2018 08:50:53 -0700
Message-ID: <0241d415-dc04-110a-771f-c245d963fec0@kernel.dk>
References: <20180114220048.8114-1-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:45660 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965032AbeAOPuz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2018 10:50:55 -0500
Received: by mail-pf0-f177.google.com with SMTP id a88so6769770pfe.12
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2018 07:50:55 -0800 (PST)
In-Reply-To: <20180114220048.8114-1-dgilbert@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: bart.vanassche@wdc.com, dvyukov@google.com

On 1/14/18 3:00 PM, Douglas Gilbert wrote:
> During stress tests by syzkaller on the sg driver the block layer
> infrequently returns EINVAL. Closer inspection shows the block
> layer was trying to return ENOMEM (which is much more
> understandable) but for some reason overroad that useful error.
> 
> Patch below does not show this (unchanged) line:
>    ret =__blk_rq_map_user_iov(rq, map_data, &i, gfp_mask, copy);
> That 'ret' was being overridden when that function failed.

Thanks, applied.

-- 
Jens Axboe
