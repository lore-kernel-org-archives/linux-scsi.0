Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABA5C38A2D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 12:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiJYMSt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 08:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbiJYMSo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 08:18:44 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41716181C90
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 05:18:43 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id t16so8371025qvm.9
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 05:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oQrHD3DUmzYLl+f6cA65+ahPUoZYs9D5TtxLI2T2iBU=;
        b=oMMfoDK6mOWdTlWfPxSApERVImAkv75CK4Cgdjmz23BvpAO2YR1mb87LFYSuqzNZ6O
         /pIuj2KXP5qOvSW0629y90VXl6Rx8rHR9nwla72dDl4OVY4ese7gdWWoxVfRDgZ1byhh
         +yD3g2hgUYwJhXyn8nknHx/moh8M3qU6T0ssxkyTz6kRT/MDNhpHhZ10PzLICesnq/44
         rR2y2SknfAy+9yn/fuFS99JulPIjizryBDsHpwIPJgIEtPIhGWXms3/qdshhwF1sbxYb
         Rmn2AqKFEzcZl006b+6RrPjZp6ber+gw6DYWG5ZKgdspY1mFRoSpnyrivmUJZeaMDc7A
         YOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQrHD3DUmzYLl+f6cA65+ahPUoZYs9D5TtxLI2T2iBU=;
        b=Cp4cFuadcYGRDcCJn2CxXbrS3xQAF1KY4+v+mDlRzQ39xyaDd24OGK4iRwpCP3c+/L
         L9WMt3kqibASL3eXvoGDozqxiqIUgDwDyTOOdoCvKIYO6N3NZYKWKbpuyD8UOGZM7EpC
         mVy8SbP5VJi8nrEG1o/5EXPBlJLps1X18pJiD11eIkT2oblqx8sgg3dDzFHIjwDXZJZJ
         5zwZCb3cdoeahLCBCi/Pw1XI8CNkzjkW7a2zBEkD/gaGpvia2ZLc0HNUtfPxMaVHJllD
         sxJPQlAIsLezjrHAqG7zgqu2higCNQ0NYLLUHPl/SENI8YBRqZYCHOJPzXQFXqGTtgpd
         C5lg==
X-Gm-Message-State: ACrzQf3OQkxycEZ5HhCVHbYW/2nI5QOqdUYZJrSuMruZfgPjGhJnAw0+
        F95MTcPbpeoxniyzfG90rX40Bg==
X-Google-Smtp-Source: AMsMyM5BCiWxV5U/HxsohsYadHsdiWBhWhWYU7KxRsd0eG5OTcDBQ2j7WPtk1gxDKe3LgFsScLL/qw==
X-Received: by 2002:ad4:5cc4:0:b0:4bb:70de:bb81 with SMTP id iu4-20020ad45cc4000000b004bb70debb81mr8360273qvb.55.1666700322327;
        Tue, 25 Oct 2022 05:18:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id j22-20020a05620a411600b006eef13ef4c8sm1940469qko.94.2022.10.25.05.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 05:18:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1onItC-00EMCu-6n;
        Tue, 25 Oct 2022 09:18:38 -0300
Date:   Tue, 25 Oct 2022 09:18:38 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH 1/5] sgl_alloc_order: remove 4 GiB limit
Message-ID: <Y1fUHhJtaN4rg5SJ@ziepe.ca>
References: <20221024010244.9522-1-dgilbert@interlog.com>
 <20221024010244.9522-2-dgilbert@interlog.com>
 <Y1aDQznakNaWD8kd@ziepe.ca>
 <665f8dee-6688-60d1-5097-49f9726c38ec@gmail.com>
 <Y1bMKU5nq5DXYdbw@ziepe.ca>
 <78357696-d9aa-71a0-8cee-0fadbc90655f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78357696-d9aa-71a0-8cee-0fadbc90655f@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 25, 2022 at 12:46:55PM +0200, Bodo Stroesser wrote:
> On 24.10.22 19:32, Jason Gunthorpe wrote:
> > On Mon, Oct 24, 2022 at 04:32:30PM +0200, Bodo Stroesser wrote:
> > > > +struct scatterlist *sgl_alloc_order(size_t length, unsigned int order,
> > > > +				    bool chainable, gfp_t gfp, size_t *nent_p)
> > > >    {
> > > >    	struct scatterlist *sgl, *sg;
> > > >    	struct page *page;
> > > > -	unsigned int nent, nalloc;
> > > > +	size_t nent, nalloc;
> > > >    	u32 elem_len;
> > > > -	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
> > > > -	/* Check for integer overflow */
> > > > -	if (length > (nent << (PAGE_SHIFT + order)))
> > > > -		return NULL;
> > > > +	nent = length >> (PAGE_SHIFT + order);
> > > > +	if (length % (1 << (PAGE_SHIFT + order)))
> > > 
> > > This might end up doing a modulo operation for divisor 0, if caller
> > > specifies a too high order parameter, right?
> > 
> > If that happens then the first >> will be busted too and this is all
> > broken..
> > 
> > We assume the caller will pass a valid order paramter it seems, it is
> > not userspace controlled.
> > 
> 
> If a too high order is passed, alloc_pages will just return NULL, so
> in the old code sgl_alloc_order simply returns NULL. Using modulo op
> changes it to possibly crashing the system.

That is fine, we are not trying to protect against buggy callers
passing a weird order 

We are trying to protect against correct callers passing a large
length because length is user controlled or something.

Jason
