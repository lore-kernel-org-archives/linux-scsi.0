Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C74FA373F
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 19:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiJXTCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 15:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbiJXTBm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 15:01:42 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3595617F983
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 10:40:57 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id j21so6504503qkk.9
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 10:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bmSknnfuOqNQfFnjTEwN/bDPIo8aNvNZAU8b8CJN9+A=;
        b=KFIga3WkA0Bj1wWE8yos9W2X9CKd8tduuz5cmAhP2ca3jwpEFcmY3yBfDQBSalwbN9
         gDGneRtvWcPtTGSxS4dBYpz02wRuTjV0TQ48+mC/E3h+eyEAqCZKipYbYoSqCtrwY+Jf
         dOfbMoST9okqQSF5oPzKJ4DEdyKhfN4MRDB0+g1CYtFdEaoGxU05jwhgJZrQ6gvuzJCd
         CxRCl+TXqH7pAVcYj7EuKF56sPhfz9g25H59n1xMzq/xwc9KLoeybNBSvFMFOo9AARJG
         wDMh+stLJGOww8GudjWb2bUCjk/zuwNFuy4HONOqBsVjT5r/1fGyEd1i3heKh36oA7Oi
         ZJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmSknnfuOqNQfFnjTEwN/bDPIo8aNvNZAU8b8CJN9+A=;
        b=40wWTPb+fDUGhm6tFVOWpnoUZpdBsGcREnMxPgYyeTqf3pQQAQb50sCNFi+46zD8m7
         jRwHeM5ZofKb2UP3xJbU36YnAIZiIg9J0KSdT46CSFlO+JeTwdXbCYRANV2OPyaXq6tI
         8/MLK5AK6foAIPhROj+KFppmezwiVPL2CapDnMTnFs3D8k9YC5Rhgm7cZle2IIBEHWJQ
         Yx3ryjHFAbxJUt+Q0Ts0e4Z0nziPOt+1vnpGp5wcIR5iNo3j7aP/p7QEwN131rSKvqMw
         3ImJrKESrkRwvPi8Q9AwocScG0aWRSE1H6gg9H0nL8HUD384tLBTdEYd6y3o31lbLqEp
         DvcQ==
X-Gm-Message-State: ACrzQf3OAK5owNbcY0Id3AD9sZLFjLVsE5UpQQngDg94ekU+8VzaIf/+
        d3tpPj9SC6Rw1bYumpS4YTTfYYs3vzB/9A==
X-Google-Smtp-Source: AMsMyM7lE6smdgk6Dj87yC/LLXctQnAZvj1+Cslnw0zlOjxBuSTi1Sq9+LSOPFtV0XI4qFYt21YA5g==
X-Received: by 2002:a05:620a:4445:b0:6ee:a916:866 with SMTP id w5-20020a05620a444500b006eea9160866mr23613663qkp.240.1666632747279;
        Mon, 24 Oct 2022 10:32:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id b14-20020ac8540e000000b00399ad646794sm277124qtq.41.2022.10.24.10.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 10:32:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1on1JJ-00DiDr-W1;
        Mon, 24 Oct 2022 14:32:25 -0300
Date:   Mon, 24 Oct 2022 14:32:25 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH 1/5] sgl_alloc_order: remove 4 GiB limit
Message-ID: <Y1bMKU5nq5DXYdbw@ziepe.ca>
References: <20221024010244.9522-1-dgilbert@interlog.com>
 <20221024010244.9522-2-dgilbert@interlog.com>
 <Y1aDQznakNaWD8kd@ziepe.ca>
 <665f8dee-6688-60d1-5097-49f9726c38ec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <665f8dee-6688-60d1-5097-49f9726c38ec@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 24, 2022 at 04:32:30PM +0200, Bodo Stroesser wrote:
> > +struct scatterlist *sgl_alloc_order(size_t length, unsigned int order,
> > +				    bool chainable, gfp_t gfp, size_t *nent_p)
> >   {
> >   	struct scatterlist *sgl, *sg;
> >   	struct page *page;
> > -	unsigned int nent, nalloc;
> > +	size_t nent, nalloc;
> >   	u32 elem_len;
> > -	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
> > -	/* Check for integer overflow */
> > -	if (length > (nent << (PAGE_SHIFT + order)))
> > -		return NULL;
> > +	nent = length >> (PAGE_SHIFT + order);
> > +	if (length % (1 << (PAGE_SHIFT + order)))
> 
> This might end up doing a modulo operation for divisor 0, if caller
> specifies a too high order parameter, right?

If that happens then the first >> will be busted too and this is all
broken..

We assume the caller will pass a valid order paramter it seems, it is
not userspace controlled.

Jason
