Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFD8CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 20:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FEB720650
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 20:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HIj7hquE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfJ3UDF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 16:03:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54700 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3UDF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 16:03:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=B4MaiLsQCvLkOssBLa9fcFvK1YRehINVkEP+OJsdN4s=; b=HIj7hquEoNF9TkHFLwBPrIryd
        aAEkb4hPSn/FesggA5/E7GkDpT1+5w8luJJX6av7+U9on/YzxlbktgPXHQo54tjM0/9zUtZUqGYVG
        ozOEdGlGUDlNDwxJb1Vyqbxwa5dzHfiqsqk4j/7oS18xvJb940Ph3s0YnFii0trCJqGJ3cT6lFjRY
        slZKDuH1/OMIT21vGipeN+Lg4AFvCgw4yAaY2O4BqpC/MYhymWJBFrxTcEOGWMNTudgRvj/i7rheE
        FdvkepeN6HuO2U4giVu9TEuSJsNQHCA7HU823mkp5kdHlNwCtH7IjjKOa3b/I8qR/TcantTQ2gQkF
        rvAz3CyNw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPuAt-0000Aj-KO; Wed, 30 Oct 2019 20:02:35 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1B17D980DEA; Wed, 30 Oct 2019 21:02:32 +0100 (CET)
Date:   Wed, 30 Oct 2019 21:02:32 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Subject: Re: [PATCH 4/9] drivers/iio: Sign extend without triggering
 implementation-defined behavior
Message-ID: <20191030200232.GC3079@worktop.programming.kicks-ass.net>
References: <20191028200700.213753-1-bvanassche@acm.org>
 <20191028200700.213753-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028200700.213753-5-bvanassche@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 28, 2019 at 01:06:55PM -0700, Bart Van Assche wrote:
> From the C standard: "The result of E1 >> E2 is E1 right-shifted E2 bit
> positions. If E1 has an unsigned type or if E1 has a signed type and a
> nonnegative value, the value of the result is the integral part of the
> quotient of E1 / 2E2 . If E1 has a signed type and a negative value, the
> resulting value is implementation-defined."

FWIW, we actually hard rely on this implementation defined behaviour all
over the kernel. See for example the generic sign_extend{32,64}()
functions.

AFAIR the only reason the C standard says this is implementation defined
is because it wants to support daft things like 1s complement and
saturating integers.

Luckily, Linux doesn't run on any such hardware and we hard rely on
signed being 2s complement and tell the compiler that by using
-fno-strict-overflow (which implies -fwrapv).

And the only sane choice for 2s complement signed shift right is
arithmetic shift right.

(this recently came up in another thread, which I can't remember enough
of to find just now, and I'm not sure we got a GCC person to confirm if
-fwrapv does indeed guarantee arithmetic shift, the GCC documentation
does not mention this)
