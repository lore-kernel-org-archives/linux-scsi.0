Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F115C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 20:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKOUgS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiKOUgC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 15:36:02 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B139029352
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 12:33:45 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id lf15so10542552qvb.9
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 12:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vinlxvUWQv1/kRM6ihJddAuJIrRn3iHpVDS5hn/bVNc=;
        b=KAGObVYtbx6BxPAlRvc1V2JZ1DRgFxgLLwv4vL/jR0uNai5ecFWLRqe1bpFD0YF8Bd
         5quUqF5mooAiC37RAAvsAQdE8JjrcqVLYC+xpCmHlJJHf6fZqpBcakdPm6YP4CSqrSzw
         Rd43qD4NmtZ2MQRmsfaKBxBpKOK85anF+rYPn9lUDlc8CrTWmG5gcQdisYiswPUtC1xP
         2wqGswNMZ1Tj2KI/YwnJHnKHBAZgcKDi/JTeZjkvZyjLqEmeVBZ788CVPRTU1eCGX/MJ
         V/XdryqPEBBrC19TxaZCNzIcjNRANEl3oMFDUpDZ3KYe8EftCvNYNK7qbe+CNF+iFbWJ
         YwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vinlxvUWQv1/kRM6ihJddAuJIrRn3iHpVDS5hn/bVNc=;
        b=LJMp9RwcY1SsrlwmCtisOBHnIROO1pM/i9G1iRhKLmstOlaJR2JVenrU4LsK4sGl7W
         1YQERagY96jC+eHwr5gv0LW3zK9/kQjSCCsDXz2wT7tq+beTJHpmADrqapm21R/zuXaO
         SHlwpBpqCw5ln8TWKfBKcB8i1q43Q7DXPg53lBgxUpoqbGoUX3stpnuZ8df2Gc7ZpsWd
         Phkw4Hg0BGi3KgGbBhL9DoRsedvTdXg9w/AcgIQ+uZjcqYmW4Ed3VDyS7zQFIi4Qzg7W
         BetuvzCHBQzjqE9CJn4N5hmdGHuUb6oZf1JUgAIWKOUTgsNF+h/d3Q4NTcd/b/pf2P4Q
         NEhQ==
X-Gm-Message-State: ANoB5pmCGOBxHFc1m98ObUOPuQyS0EM/mkhbbULB2vtgCCkuLQBw31BP
        TZPi8jzYD6kMMT/+3BLErbBGjA==
X-Google-Smtp-Source: AA0mqf7X/7bw/QGKYkIgztKFGSRSxq3hhTtsw9ND386uvzt9tc39rjkDo579dYqIhS72x7fkSZyX5Q==
X-Received: by 2002:a0c:f950:0:b0:4bb:f29c:9026 with SMTP id i16-20020a0cf950000000b004bbf29c9026mr18444140qvo.26.1668544424806;
        Tue, 15 Nov 2022 12:33:44 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id s19-20020a05620a0bd300b006bb8b5b79efsm8754392qki.129.2022.11.15.12.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 12:33:44 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1ov2cp-004jxy-Eh;
        Tue, 15 Nov 2022 16:33:43 -0400
Date:   Tue, 15 Nov 2022 16:33:43 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        bostroesser@gmail.com
Subject: Re: [PATCH v2 1/5] sgl_alloc_order: remove 4 GiB limit
Message-ID: <Y3P3p1XqxisASnQt@ziepe.ca>
References: <20221112194939.4823-1-dgilbert@interlog.com>
 <20221112194939.4823-2-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112194939.4823-2-dgilbert@interlog.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 12, 2022 at 02:49:35PM -0500, Douglas Gilbert wrote:
> This patch fixes a check done by sgl_alloc_order() before it starts
> any allocations. The comment in the original said: "Check for integer
> overflow" but the right hand side of the expression in the condition
> is resolved as u32 so it can not exceed UINT32_MAX (4 GiB) which
> means 'length' can not exceed that value.
> 
> This function may be used to replace vmalloc(unsigned long) for a
> large allocation (e.g. a ramdisk). vmalloc has no limit at 4 GiB so
> it seems unreasonable that sgl_alloc_order() whose length type is
> unsigned long long should be limited to 4 GB.
> 
> Solutions to this issue were discussed by Jason Gunthorpe
> <jgg@ziepe.ca> and Bodo Stroesser <bostroesser@gmail.com>. This
> version is base on a linux-scsi post by Jason titled: "Re:
> [PATCH v7 1/4] sgl_alloc_order: remove 4 GiB limit" dated 20220201.
> 
> An earlier patch fixed a memory leak in sg_alloc_order() due to the
> misuse of sgl_free(). Take the opportunity to put a one line comment
> above sgl_free()'s declaration warning that it is not suitable when
> order > 0 .
> 
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Bodo Stroesser <bostroesser@gmail.com>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  include/linux/scatterlist.h |  1 +
>  lib/scatterlist.c           | 23 ++++++++++++++---------
>  2 files changed, 15 insertions(+), 9 deletions(-)

I still prefer the version I posted here:

https://lore.kernel.org/linux-scsi/Y1aDQznakNaWD8kd@ziepe.ca/

Jason
