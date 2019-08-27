Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD67C3A5A6
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 15:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D792C214DA
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 15:01:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=plexistor-com.20150623.gappssmtp.com header.i=@plexistor-com.20150623.gappssmtp.com header.b="YA5mA/Wp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfH0PBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 11:01:34 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:40402 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfH0PBe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 11:01:34 -0400
Received: by mail-wr1-f42.google.com with SMTP id c3so19145544wrd.7
        for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2019 08:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=plexistor-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Rh4dW/p/0ptDZbGvTsHkhReMwL9BApKR4ATW/fhWj0U=;
        b=YA5mA/WpJ2bUfwYghy/JbMnrzaCDhfLXowtzIUUoVpWBqlEgZ2BTchvq9N8NE7QAfk
         uarCD9Re2OubHm9NhWhQUZYkQroeNN2MC+5zCwwruM5hUiLPCL/B83GKDo/nXOIyN01E
         SfnN5eSNbeeTrgC/Wx3g6OHGMddjbpF+/jwVweARfy9A7j3CJ8+zeze7fGUXiQLYjezq
         L/e4z/aEWTx2bnQ6Q9+zkfUGobxz/F1HnRdA1ZTY8l8KFwsHs/EZ0fTX6A8fK+IdE84T
         Luo6y/iJbHrPg3KUT/h26oSkYd2OY2VUt25+bxf/HPuMPAl3RTU1SmL1YuuOGqSpOmGx
         PNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rh4dW/p/0ptDZbGvTsHkhReMwL9BApKR4ATW/fhWj0U=;
        b=rjg1KeqFzCAMUpzPhpoerUO+wixsAik7tnpF/zmGVLrHzEmZZhAGTLxUp0misX3tNZ
         Qt4lBPWxLRdxwyq05Ik8dBDUKnC7SaLi7Y/r0zodIyCJS9X14w59nmynYswg7iEv6bVc
         JmKsaI/RqRA5S63PxMU+MdZQFMCiyh06zFrlRx3mIv55F5Fv/GmYcDBolkSjD8H6dRMM
         XTCcgTVM80PJQtpvKqB3b/cCcZFJ0yzmQKtBZITkCjEW4tlXXFaIfo6eekUjTlRopPvm
         RX95bnrx1Mfdwp7b+rN2esOeIPmSaOEjHfmbhZYLihW6s2gxeqzAEg44bTiEXbv4sVaW
         DtAg==
X-Gm-Message-State: APjAAAUNEZpvYHokTD/V3ou9eICRo3X0Jy0KFp2OO2Z/G8jj8l6/pYSP
        xtBBqYqINLkerskoExFklX6ncmvc/7M=
X-Google-Smtp-Source: APXvYqxALOqf+EnAXERTJqYNuB9QwId0e76VhksXmlnbeqSA3iEQW9rErg7i0v0A0rcSfXhaat/YHA==
X-Received: by 2002:a5d:60c1:: with SMTP id x1mr5251694wrt.75.1566918091981;
        Tue, 27 Aug 2019 08:01:31 -0700 (PDT)
Received: from [10.68.217.182] ([217.70.211.18])
        by smtp.googlemail.com with ESMTPSA id t8sm38019169wra.73.2019.08.27.08.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2019 08:01:30 -0700 (PDT)
Subject: Re: [RFC] Re: broken userland ABI in configfs binary attributes
To:     Al Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?Q?Kai_M=c3=a4kisara_=28Kolumbus=29?= 
        <kai.makisara@kolumbus.fi>
Cc:     Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi@vger.kernel.org
References: <20190826024838.GN1131@ZenIV.linux.org.uk>
 <20190826162949.GA9980@ZenIV.linux.org.uk>
 <B35B5EA9-939C-49F5-BF65-491D70BCA8D4@kolumbus.fi>
 <20190826193210.GP1131@ZenIV.linux.org.uk>
From:   Boaz Harrosh <boaz@plexistor.com>
Message-ID: <b362af55-4f45-bf29-9bc4-dd64e6b04688@plexistor.com>
Date:   Tue, 27 Aug 2019 18:01:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826193210.GP1131@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/08/2019 22:32, Al Viro wrote:
<>
> D'oh...  OK, that settles it; exclusion with st_write() would've been
> painful, but playing with the next st_write() on the same struct file
> rewinding the damn thing to overwrite what st_flush() had spewed is
> an obvious no-go.
> 

So what are the kind of errors current ->release implementation is trying to return?
Is it actual access the HW errors or its more of a resource allocations errors?
If the later then maybe the allocations can be done before hand, say at ->flush but
are not redone on redundant flushes?

If the former then yes looks like troubles. That said I believe the 
->last_close_with_error() is a very common needed pattern which few use exactly
because it does not work. But which I wanted/needed many times before.

So I would break some eggs which ever is the most elegant way, and perhaps add a
new parameter to ->flush(bool last) or some other easy API.
[Which is BTW the worst name ever, while at it lets rename it to ->close() which
 is what it is. "flush" is used elsewhere to mean sync.
]

So yes please lets fix VFS API with drivers so to have an easy and safe way
to execute very last close, all the while still being able to report errors to
close(2).

My $0.017 Thanks
Boaz
