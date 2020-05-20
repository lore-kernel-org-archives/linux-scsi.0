Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFB3C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 03:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447CD2075F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 03:57:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="RupVthUQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgETD5V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 23:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgETD5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 23:57:21 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756E5C061A0E
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2020 20:57:21 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id cx22so639427pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2020 20:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ytftJq4j1YH1FQpWCDVw46oQxuuWfHqAZeu5PQu5Tzk=;
        b=RupVthUQ83sxRLyitsvIhcmiGPK2Po7I/z826AfimUwFJzwEOKjyztPG3PJz/M/ceh
         7Mau9QrlcCKdhTw4WNt5c9my04TbiPVVxalOvtvtcD9yDptMKNnb3R72QvV4V4CF/6RX
         2jIZBke2vl3W9pAN1flGjYLGM3jp5/Dante/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ytftJq4j1YH1FQpWCDVw46oQxuuWfHqAZeu5PQu5Tzk=;
        b=A3H3KC9xeXD7uevXRNCaAUkB97/HXTJ0vtywlEKLGhDtyFfzK5jb0ZtphqLMb4RpMR
         JtOuwUssVquORMb4Flx/CMjQAdqVVmA4ahZVi0MNBgmypdUEpj+dDL+5O+/alls790Sx
         bMujkSTiw9vdEEVqE2t4gvZ+ZksD7EfQGgzH6qfE4yjoG7cmhnuvPWORHfPysxcDuUz5
         3rycJJh5uza3BFetzCpMF7DFYz8dvLQxnGLBRDbJInSoYrOJ4vxR30CBtuVtbPYAIwLV
         Z5ZFZ0V/XmJsq6YmAMakFlqqfq1IeY7LL9WhA//CUb4hZV+IM0MveoYac0nMRxc+wMRd
         v2EQ==
X-Gm-Message-State: AOAM531KDBL5SBkUrvFvrfAFzPtW22XCx2AH5FZgY73+0Blsq4M9FLci
        IxPhvM+KrMd/OUFuwKTBzg3DSA==
X-Google-Smtp-Source: ABdhPJyVuLf9DuTf0O3M8vk5AY3/sZqJfDELQ7nOpLn+HThDx00allfpx82tsOz+YkQ6sH4/KZp65A==
X-Received: by 2002:a17:902:9888:: with SMTP id s8mr2783660plp.168.1589947040946;
        Tue, 19 May 2020 20:57:20 -0700 (PDT)
Received: from localhost (2001-44b8-111e-5c00-b5ed-d3ff-25d3-7e68.static.ipv6.internode.on.net. [2001:44b8:111e:5c00:b5ed:d3ff:25d3:7e68])
        by smtp.gmail.com with ESMTPSA id 65sm776761pfy.219.2020.05.19.20.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 20:57:20 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [hnaz-linux-mm:master 156/523] include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
In-Reply-To: <20200519184847.5affb9238b7358ac0d18c98e@linux-foundation.org>
References: <202005191736.t1JQZSrV%lkp@intel.com> <87blmkhtpy.fsf@dja-thinkpad.axtens.net> <20200519184847.5affb9238b7358ac0d18c98e@linux-foundation.org>
Date:   Wed, 20 May 2020 13:57:16 +1000
Message-ID: <875zcri7hf.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 		inqdata[0] = TYPE_PROCESSOR;
> 		/* Periph Qualifier & Periph Dev Type */
> 		inqdata[1] = 0;
> 		/* rem media bit & Dev Type Modifier */
> 		inqdata[2] = 0;
> 		/* ISO, ECMA, & ANSI versions */
> 		inqdata[4] = 31;
> 		/* length of additional data */
> 		strncpy(&inqdata[8], "Areca   ", 8);
> 		/* Vendor Identification */
>>>>		strncpy(&inqdata[16], "RAID controller ", 16);
> 		/* Product Identification */
> 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */


> That strncpy() will indeed fail to copy the trailing null, but it looks
> like that null isn't appropriate in the inquiry data.
>
> So I suspect this is a valid usage of strncpy() and the checking is
> just too strict.
>
> otoh if this is the only place where we hit this issue then perhaps we
> can switch to memcpy() and get on with life ;)

Hmm, yes, I think you're right and gcc is being a bit ambitious here -
although I can understand the warning given that the behaviour relied
upon here is rarely going to be what the developer intendend!

We could build the file with -Wno-stringop-truncation, but I do wonder
if memcpy might make the semantics more obvious...

Regards,
Daniel
