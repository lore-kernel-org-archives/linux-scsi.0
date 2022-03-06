Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE03C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 21:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiCFVWf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 16:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiCFVWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 16:22:33 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79243980C;
        Sun,  6 Mar 2022 13:21:40 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id n15so2143727plh.2;
        Sun, 06 Mar 2022 13:21:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zwxh13dQ8pcdMqyNQ85/ciDs6DNYQkgEAm94QA/j/6Y=;
        b=zkJmwPmst+MWeAZTXop1YW1yDnj+yO7JD54kR9G1m9YXI7ojbWfAszJbW8e2gz2xmv
         HSKzFsvXdl/9eq4N3/rE5OpY09TjmXiOPXVd0H8YW5yOFskvp7IDHGWwk6XKpuPNg6Fy
         Ii6/3DPCqVr/ES8Ek9GVueHKauvoHrI4Okp7p3Cxd3YVhkvVKNb4BFz01gvozITi2Af5
         TTnWwWeMUavoZM5v5aLiW3vzsTsV2qdu2n7fNxLtIEKh17Yb0fC7zTl33qLtuTGwPhtR
         YPWNU34FyTnRGNvcJDCRXx60dDxXN2Flax3oubYDH/XPFy0r9GoPPFDLmpmFO3ZpsdIL
         p9dA==
X-Gm-Message-State: AOAM531CckIuyWCf3xlpJ6N86hdw0abAMRIJfvSvWRZgGYx9ib5w5/CI
        LvaPpky5wom4xS1/e8yE8T0=
X-Google-Smtp-Source: ABdhPJzCnNyy3DviQZaxTJk27q+7KijuQpuvTltMaMmebBKg3Q7KlrS8aLAKQQsc8zuB/vJZjWdf1w==
X-Received: by 2002:a17:90a:ba10:b0:1bf:6900:2c5d with SMTP id s16-20020a17090aba1000b001bf69002c5dmr1332945pjr.36.1646601700058;
        Sun, 06 Mar 2022 13:21:40 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id ic6-20020a17090b414600b001bf691499e4sm453520pjb.33.2022.03.06.13.21.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 13:21:39 -0800 (PST)
Message-ID: <618100fc-2f65-e4ad-4636-cb2ef26326bc@acm.org>
Date:   Sun, 6 Mar 2022 13:21:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 12/14] block: move blk_exit_queue into disk_release
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-13-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220304160331.399757-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 08:03, Christoph Hellwig wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> There can't be FS IO in disk_release(), so move blk_exit_queue() there.
> 
> We still need to freeze queue here since the request is freed after the
> bio is completed and passthrough request rely on scheduler tags as well.
> 
> The disk can be released before or after queue is cleaned up, and we have
> to free the scheduler request pool before blk_cleanup_queue returns,
> while the static request pool has to be freed before exiting the
> I/O scheduler.

The above explains why it is safe to make this change but not why this 
change is made. Please add an explanation of why this change is made. 
Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
