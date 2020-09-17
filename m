Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E35EC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 19:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC8B2078D
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 19:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DKmSBGMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIQTzZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 15:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbgIQO5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 10:57:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DEAC06178A;
        Thu, 17 Sep 2020 07:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DYbvYhbMXA9ajPbJG0Is0bvKHq8e2tKSFLIz7K4cCtw=; b=DKmSBGMZ8ouyh+lFHVFF2+PC1S
        6P9h3/975zGRn/faB+N9lXC9y2nImmDeIehApvvBnaubVjQC3jBJL52BbOeDdxIJdc66Gatu6X//o
        DyBsMMCBwhoUjxbyrzdbjIWGGTeoQjvwsmyvx/4JPellHtRekUV6IxhI82hmS77G1gBAdjwpqOebr
        N4ULZVA7W5yODbUa3ufgqWNrpYd/KoBsy3rPv/tIROnsN9XnLwWvnU+SIBcdC6QVaZZCmBkJbLK1w
        uSuIGqkvrDXUDp1t0IEkWR6c2obuf+E4xsec7LCbHnucJ94EZllMdsYRLExEuRaPeyJV5eaY+wKWy
        o9cd1AEw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIvLp-0000Ok-KT; Thu, 17 Sep 2020 14:57:33 +0000
Date:   Thu, 17 Sep 2020 15:57:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: compat_alloc_user_space removal, was Re: [PATCH 3/3] scsi:
 megaraid_sas: simplify compat_ioctl handling
Message-ID: <20200917145733.GA1433@infradead.org>
References: <20200908213715.3553098-1-arnd@arndb.de>
 <20200908213715.3553098-3-arnd@arndb.de>
 <20200912074757.GA6688@infradead.org>
 <CAK8P3a363DxgZnN9x4oNL7W4__kyG1U_34=7Hpqhpc-obAvjWw@mail.gmail.com>
 <20200913065051.GA17932@infradead.org>
 <CAK8P3a3W1EYts=2uL-6kTWwcgBeigLdv-W4mnxBd+En2ZFReLA@mail.gmail.com>
 <CAK8P3a2r=-JQLyVeLhFvDtWrdtJN_pWsPHRoi5VHcgfK0SbQ5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2r=-JQLyVeLhFvDtWrdtJN_pWsPHRoi5VHcgfK0SbQ5g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 17, 2020 at 04:55:49PM +0200, Arnd Bergmann wrote:
> Unfortunately, the commit b902bfb3f0e "arm64: stop using <asm/compat.h>
> directly" seems to introduce a circular header file inclusion between
> linux/compat.h and asm/stat.h, breaking arm64 compilation.
> 
> Moving the compat_u64/compat_s64 definitions to include/asm-generic/compat.h
> works fine though.

I posted a version doing exactly that a few hours ago.
