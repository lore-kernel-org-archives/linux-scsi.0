Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97499C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 18:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767C060F9B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 18:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbhJZSUm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 14:20:42 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:51326 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238165AbhJZSUm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 14:20:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635272298;
        bh=hEbOqWecMirQvqRf3xkx1fd3IMdUnyDIb/WN/jwyfqw=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=LPbyFpX594kpDMz3+CbyleD1nzneQtjv85Cx4d5azMM8YOkUBlPvB8iq0TWaZPCDk
         PTx+BJyjOHBtSv6au+e00KGR8IivpTsLSAnK0zp11OWWHPmAJPYYNNAXRfc3hxDBtP
         H9zKwNlMtf+So1dN5QLBabVweJl3kZM4Yb1ucyQ4=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 03F451280727;
        Tue, 26 Oct 2021 14:18:18 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cQen1bmZNkwM; Tue, 26 Oct 2021 14:18:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635272297;
        bh=hEbOqWecMirQvqRf3xkx1fd3IMdUnyDIb/WN/jwyfqw=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=P41fWLq8xLtq0kAyac3Gnj5caNks0a2LQN8wBjK5PYF7q5KWCYy/mWhc/GtHihuXh
         YySV9kCLmYWgXb/2BGgYyDV07bqmo9jMmm5+OgH/mq0G33lrDLvQdlWwsNOk/tyv2/
         i37xzZgx6CMOXghKfPWE32IS8hPhbaeWmJt1Pry0=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 1DF8512805D0;
        Tue, 26 Oct 2021 14:18:17 -0400 (EDT)
Message-ID: <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Date:   Tue, 26 Oct 2021 14:18:16 -0400
In-Reply-To: <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
References: <20211026071204.1709318-1-hch@lst.de>
         <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
         <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
         <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
         <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
         <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-10-26 at 12:10 -0600, Jens Axboe wrote:
> On 10/26/21 12:05 PM, Bart Van Assche wrote:
[...]
> > Hi Jens and James,
> > 
> > This is what I found in the HPB 2.0 specification (the spec is
> > copyrighted but I assume that I have the right to quote small parts
> > of that spec):
> > 
> > <quote>
> > 6.3 HPB WRITE BUFFER Command
> > 
> > HPB WRITE BUFFER command have following 3 different function
> > depending
> > on the value of BUFFER_ID field.
> > 1) Inactivating an HPB Region (supported in host control mode only)
> > 2) prefetching HPB Entries from the host to the device (supported
> > in any control mode)
> > 3) Inactivating all HPB Regions, except for Provisioning Pinned
> > Region
> >     in the host (supported in device control mode only)
> > </quote>
> > 
> > Reverting only the problematic code (HPB 2.0) sounds reasonable to
> > me because reworking the HPB 2.0 code will be nontrivial.
> 
> Then let's please go ahead and do that. I'm assuming this is a
> smaller set than what Christoph originally posted, who's taking on
> the job of lining it up?

I was hoping the HPB guys would do this.  I think I know how to do it
based on my investigations, but I'd really prefer that someone who
cares about HPB did it.  It looks like a fairly simple excision, so I
think we can have this done before the end of the week and if it isn't
we could revert the whole driver.

> > Using BLK_MQ_F_BLOCKING might be a viable approach. However, I
> > don't want to see that flag enabled in the UFS driver if HPB is not
> > used because of the negative performance effects of that flag.
> 
> Agree, and if we do just the problematic revert, then the decision on
> whether BLK_MQ_F_BLOCKING is useful or not belongs to whoever reworks
> the WRITE BUFFER code and reposts that support.

Agreed, that was my initial proposed solution: get rid of the write
buffer optimzation now to fix the API abuse and see if we can add it
back in a more acceptable form later.

James


