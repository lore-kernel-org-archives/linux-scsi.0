Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9635AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73240611C3
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhKSEdy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:33:54 -0500
Received: from mail-pj1-f50.google.com ([209.85.216.50]:34335 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhKSEdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2021 23:33:53 -0500
Received: by mail-pj1-f50.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so8090894pjb.1;
        Thu, 18 Nov 2021 20:30:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=jKkpEgqy21F+6MHgAKXtL1mfPkm3IkM1lMAPVxq134I=;
        b=r6p1nv4Et4N+wSjg/zHds8RVEnAx4KFGgeWtkWLZhf6C074FxchZYI9yNGKENHxhTo
         dNoIwpB8aFLVXcc3ZVM+S0KE0brR+s5TmDUDDsZo+odxJgLmrnimkrAJP9XLCBrNkjFi
         FYjecgA0qkJHuGk2a/zmnK6Ej1tQR0D9TmjoSGIIrYU/K5wE9aZZhs4LEFhop1yAFhFe
         seXFj6q/Amh22wzOS6280wW0ZQuZeIfWRaYKHfoP2Hq2Vf9klFGamV0vXcTJcOmj1OP4
         8RWSH3DHnmHWBADuyGeVmZanZZTMoMb2EwDpM6XSP4FrOSLln8Yk1WxzqdSW7PfxNrRm
         yfUA==
X-Gm-Message-State: AOAM5314C0/LJWIeAm1zyvIQdhC2i/r7/T+iIYuSGHiUQQqOeIgDaeyD
        gOiTivvzhKYDxl+bzx6DQY4=
X-Google-Smtp-Source: ABdhPJxeWkmCq0jJll1lI7VBTooLeihaoBCi0Kb4+SXOXNeC/pbSeIT5DrNT2lOoVc6HsGT3Bn/pHQ==
X-Received: by 2002:a17:90b:1812:: with SMTP id lw18mr1051673pjb.96.1637296252254;
        Thu, 18 Nov 2021 20:30:52 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id m127sm892396pgm.64.2021.11.18.20.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 20:30:51 -0800 (PST)
Message-ID: <a3192b20-fa76-0b64-a2a9-c0c337741156@acm.org>
Date:   Thu, 18 Nov 2021 20:30:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/5] blk-mq: move srcu from blk_mq_hw_ctx to request_queue
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-2-ming.lei@redhat.com>
Content-Language: en-US
In-Reply-To: <20211119021849.2259254-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/21 18:18, Ming Lei wrote:
> +	bool			alloc_srcu;

I found the following statement multiple times in this patch:

WARN_ON_ONCE(q->alloc_srcu != !!(q->tag_set->flags & BLK_MQ_F_BLOCKING));

Does this mean that the new q->alloc_srcu member variable can be left out
and that it can be replaced with the following test?

q->tag_set->flags & BLK_MQ_F_BLOCKING

Please note that I'm not concerned about the memory occupied by this
variable but only about avoiding redundancy.

If this variable is retained it probably should be renamed, e.g. "has_srcu"
instead of "alloc_srcu".

Thanks,

Bart.
