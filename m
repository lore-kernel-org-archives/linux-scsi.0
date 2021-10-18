Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD642C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 10:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B81961212
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 10:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhJRK4G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 06:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhJRK4F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 06:56:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB534C06161C;
        Mon, 18 Oct 2021 03:53:54 -0700 (PDT)
Date:   Mon, 18 Oct 2021 12:53:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634554432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DmyYIQ6/Gn+EjOYyOfOHPKtVvGqXG+QS63gXgRjV3is=;
        b=c1JjhlVq2JLxhaE4mEibOQ0Rr42NuWh6jXeIqf/j+WBGOhmUZ1+4VPNlBBQyxIRdcbxxnd
        HQSpfaErRqgwy8WlkNKSTlbszmOU1MiGTd2L6Bv7apQABT0x/TMBHLLxLoKiW2xl/AdED5
        1XUN9gwz2w2KQNF+D6KmHgm1BmDu6WEJEXGxQmnOCEhvnpXfhw8nF6NW8tqt2OcOq8fT3+
        RXIBz4MQ7JCtSkCOaQJcJ0f2N8Ik+pEhKG92DEt6zHSARghm/h/eFJSmrZoH0uFvxPGSNe
        4bW9B29me+gDNziczQYfLK8V66lRsHtzcUm0gmf7NZU7zRwW3QCRBdCmVSq95A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634554432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DmyYIQ6/Gn+EjOYyOfOHPKtVvGqXG+QS63gXgRjV3is=;
        b=BLoxm2wOMyY2yny6TnhD5ICCWoAVKALx1QkCvtqk4fTKD8wzdr9gXqfPMoyRDtrbRm9r3P
        s8GIPEsCAX8CUkBg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3] scsi, usb: storage: Complete the blk-request
 directly.
Message-ID: <20211018105350.7p2exznyn6e2gbtn@linutronix.de>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
 <20211015151412.3229037-4-bigeasy@linutronix.de>
 <YWmmn4MpTSGHRVOU@infradead.org>
 <20211015161653.muq37x6mkeru6lxc@linutronix.de>
 <e567fc59-46b1-bc83-c90c-199257ff8c93@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e567fc59-46b1-bc83-c90c-199257ff8c93@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-10-16 19:17:05 [-0700], Bart Van Assche wrote:
> On 10/15/21 09:16, Sebastian Andrzej Siewior wrote:
> > On 2021-10-15 09:04:47 [-0700], Christoph Hellwig wrote:
> > > Bart has been working on removing the ->scsi_done indirection, so this
> > > will need to find a way to interact with that
> > 
> > Okay. So I just wait until it is there. Is this v5.15/16 material?
> 
> Isn't it too late to submit patches for v5.15 other than bugfixes for
> patches merged during the v5.15 merge window?

yeah, off by one, meant 16/17 ;)

> Martin Petersen, the SCSI maintainer, has been so kind to queue the patch
> series that removes the scsi_done member for the v5.16 merge window. So that
> patch series should become available soon in the following git repository:
> git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git

Thanks.

> Thanks,
> 
> Bart.

Sebastian
