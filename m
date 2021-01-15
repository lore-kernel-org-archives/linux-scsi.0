Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC970C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 16:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 892F0238EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 16:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbhAOQ2K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 11:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbhAOQ2K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 11:28:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D50C061757;
        Fri, 15 Jan 2021 08:27:29 -0800 (PST)
Date:   Fri, 15 Jan 2021 17:27:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610728047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Lcn9A4KvylV3hNZuTJN63mQXyrp3wr9aYHHWJlFb5s=;
        b=ipBFsuPBLr0Zb3ltSIFfW0FWvcBuaAmK+T7dJyt0bWGYdP4Zpj/0tCzrY1Kbz1byUwhRPo
        9FPhc4fYRXwhKdwPxAIz1Qaeo5sWhXhEO4ulWALGOf0uTxsQV26K6SlpxiKHgdQgf/6GJA
        wFqHcoZKlnKj+Nz+0mKfLco9K+K6YaPWLwK3vDt0+DX2DSlBVjupKEd7yndjHBTSLDOau2
        CQ8DtAK+m6C65Ry/fxyAG45YKmlga6O8143mIfE3UOKX0dx5dInto1F+TcAh9Qp5NtUC50
        3LGmZlSI2AglnO7DJEflmVWrKFCx9l43r8irfv0C97dDZ2xZZXhqgICCHQA1NQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610728047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Lcn9A4KvylV3hNZuTJN63mQXyrp3wr9aYHHWJlFb5s=;
        b=keecvwfPdKbKd3+RDv51NsRfXtSBKYpNwRPdqegzrikcJk/PEsCodr6VYy6d/jrx/GUv49
        AaVeEd/4R4zzoIDw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 00/19] scsi: libsas: Remove in_interrupt() check
Message-ID: <YAHCbcNea47Zk+4w@lx-t490>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <8683f401-29b6-4067-af51-7b518ad3a10f@huawei.com>
 <X/2h0yNqtmgoLIb+@lx-t490>
 <e9bc0c89-a4d6-1e5b-793d-3c246882210e@huawei.com>
 <X/3dUkPCC1SrLT4m@lx-t490>
 <20e1034c-98af-a000-65ed-ae5f0e7a758f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20e1034c-98af-a000-65ed-ae5f0e7a758f@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 14, 2021 at 09:51:35AM +0000, John Garry wrote:
...
>
> To me, the series looks fine. Well, the end result - I didn't go through
> patch by patch. So:
>
> Reviewed-by: John Garry <john.garry@huawei.com>
>

Thanks!

Shall I add you r-b tag to the whole series then, or only to the ones
which directly touch libsas (#3, #12, #16, and #19)?

>
> As an aside, your analysis showed some quite poor usage of spinlocks in some
> drivers, specifically grabbing a lock and then calling into a depth of 3 or
> 4 functions.
>

Correct.

Kind regards,

--
Ahmed S. Darwish
