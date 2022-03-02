Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D66C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 23:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiCBXqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 18:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiCBXqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 18:46:05 -0500
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2DA3FBDC;
        Wed,  2 Mar 2022 15:43:39 -0800 (PST)
Received: by mail-qv1-f49.google.com with SMTP id j5so2811599qvs.13;
        Wed, 02 Mar 2022 15:43:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YubSjBfIuHvUqf85+oZbcJlWJHy5V5+oMv2zbzjivfY=;
        b=Z4fxse9WuKTEQIl/j+PccFudevCMik/LMzm+qtuG0JK/MKiS1Af+FFgitvg79t8Ljq
         YepZcKc/5ZWAJdwLfbyoomIZVZHISKUbXsIFeik9lL3RbQHmgkjbqoUniENrqy+5Dj3b
         vBaXYw4PRJRKSxI6is82klOD4/1Wh5A4vyE98a/4V8BfstON/ghf+SzmFSMUXifQ9axq
         4fAbYmDFn3QaOJnUeN2bcEBnHyDAppe2TCxYHURJm9ZCJuyUEcc1mzSJX0SUxy3ZyT+e
         WyJ8XChvTNn3E3+DMygnZKXPaEstaK3xMBTjgyUUF3htGPkenlCRgvTYs0Pyw50j4558
         XQlg==
X-Gm-Message-State: AOAM531ck4QaLm0vQBOP8VrHVCGNgQYiWKJQ9jTXVKXkVpXTT8gQsHC0
        gtn4OLjlOhm5ZVTqAQ3hZBbnejnMVAs=
X-Google-Smtp-Source: ABdhPJxUsTDEZUjKOL/Hkg6jc21Fhkxg+c8+3++ArYMa3Xk3Lu21qOMBed3EIK/TolFwzwRvHO+G8A==
X-Received: by 2002:a17:902:f602:b0:14f:53a8:64f7 with SMTP id n2-20020a170902f60200b0014f53a864f7mr33024156plg.151.1646264018123;
        Wed, 02 Mar 2022 15:33:38 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00218200b004f66d50f054sm219507pfi.158.2022.03.02.15.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 15:33:37 -0800 (PST)
Message-ID: <9e818df5-e8c0-b397-ae21-1a0745074094@acm.org>
Date:   Wed, 2 Mar 2022 15:33:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: move more work to disk_release v2
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220227172144.508118-1-hch@lst.de>
 <741e087a-43f8-dc90-b679-7865cf503ac3@acm.org> <20220301125632.GA3911@lst.de>
 <c61b6a0d-c3b5-30e2-14c5-efa7ea475c23@acm.org>
 <20220302150319.GA30076@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302150319.GA30076@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/22 07:03, Christoph Hellwig wrote:
> On Tue, Mar 01, 2022 at 09:05:24PM -0800, Bart Van Assche wrote:
>> Hmm ... even with that patch applied, I still see the crash reported in my
>> previous email. After I observed that crash I did a clean kernel build to
>> make sure that the kernel binaries used in my test match the source code.
> 
> I still can't reproduce it at all.  With this patchset on Jens'
> for-5.18/block branch I do get a pre-existing crash in
> nvmf_connect_admin_queue, and on Jens' for-next tree that has all the
> latest fixes from Linus' tree I only see the CM lockdep warning you
> reported.
> 
> FYI, this is a branch with the patches applied ontop of the for-next
> branch:
> 
> http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/freeze-for-next

Hi Christoph,

Thanks for having published a merge of block-for-next and the branch 
with this patch series. That makes it easy for me to replicate your 
kernel tree. I can reproduce the null-ptr-deref with the freeze-for-next 
branch but not with Jens' block-for-next branch (commit e70f36e84f9b 
("Merge branch 'for-5.18/block' into for-next")). This is what appears 
in the kernel log on my test setup for the freeze-for-next branch 
(commit acac349e5516 ("block: move rq_qos_exit() into disk_release()"):

BUG: KASAN: null-ptr-deref in __blk_account_io_start+0x28/0xa0

Maybe we are using different kernel configurations? I'm using 
CONFIG_NVME_MULTIPATH=n. I guess that you are using CONFIG_NVME_MULTIPATH=y?

Bart.
