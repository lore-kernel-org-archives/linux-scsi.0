Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB3DC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 20:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiF3UTJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 16:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiF3UTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 16:19:08 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796B313DF0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 13:19:07 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id n16-20020a17090ade9000b001ed15b37424so528731pjv.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 13:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=01Byto7tuKVWujjm/FmQjbqr35jct4xbeS1CHxwyQT8=;
        b=mJPeDs9jQQtQWtbqGasMrQrQL2wCY5xewbT+xa7ENXVNz2Cr82EytTmt4FpwWpfx1Z
         J90vAkwckl4FayAC7HyMXOKpWNAwmFKdNeRjtrS0hemycfG4/HwQY2DBiLqYs5g8D+Rq
         zxvLvrXHunzPivM7oxP3M3xvIU8GivejE5N9koWfILytnjnHva8z0V/KmJiUo6oaC107
         Y2Vr17OzUChGfOrpRRVO+jCiM8XVP5CUauQIGOyclnI5xSz8hdTEKD2WDJL1rhOvUTo2
         o6fL1A04Jk6tF0naHfFvPSgcJULTpNwt92oFhOQNUG/j2//G2liwDdnlU8kuPVwm/3zY
         1ReQ==
X-Gm-Message-State: AJIora9eHXaZ1hEtV8l+FZIddGy3Y1e9OEyAs9jAox8HCQifsOxUKUZn
        69EvJaDjGljsj52fs4+kgEY=
X-Google-Smtp-Source: AGRyM1vySNhv+R4+Q9QedG3Shuki5pEWRWogYovFqJ4CDIiLETObY55e3gp+Fu7l2MXkuuNd7XbmDg==
X-Received: by 2002:a17:90a:590e:b0:1ed:59f0:bc2f with SMTP id k14-20020a17090a590e00b001ed59f0bc2fmr12014959pji.120.1656620346930;
        Thu, 30 Jun 2022 13:19:06 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q6-20020a63cc46000000b0040d287f1378sm13810314pgi.7.2022.06.30.13.19.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 13:19:06 -0700 (PDT)
Message-ID: <19d2da9e-edd9-9ed9-93f4-fd5f14c5ff06@acm.org>
Date:   Thu, 30 Jun 2022 13:19:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: core: Call blk_mq_free_tag_set() earlier
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
References: <20220628175612.2157218-1-bvanassche@acm.org>
 <YruoKUbpBZvAkZ4L@T590> <8e464697-e179-19f7-e417-be089821a861@acm.org>
 <Yrz18+1iFb/QkiBZ@T590>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Yrz18+1iFb/QkiBZ@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/22 18:01, Ming Lei wrote:
> .exit_cmd_priv is actually called from scsi_host_dev_release() instead
> of scsi_device_dev_release().

Agreed, I will fix this in the patch description.

> Both scsi host pointer and host->shost_data is
> still valid when calling .exit_cmd_priv via scsi_mq_destroy_tags().

I will change the patch description to make it clear that both 
exit_cmd_priv implementations use resources associated with the SCSI host.

Thanks,

Bart.
