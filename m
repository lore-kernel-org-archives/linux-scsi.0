Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F7CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 19:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390153AbiEFT0S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 15:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbiEFT0R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 15:26:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644794163C
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 12:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BABD1CE3914
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 19:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB3CC385A9;
        Fri,  6 May 2022 19:22:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ouAwIFBj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651864947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pDmMMtFAeO6JUD9l825R0xX8ZBEHHuP5CXptsvw50Y0=;
        b=ouAwIFBj6qLZbnmFwBkUY3KUDmnZqqKMFI0cV1+hA0UBeTxTYQcbMpm5VqHzi4zkiomHp+
        knDjz0DQ/8VaCySffaeUQ0lVMB45jdfZ7PqDRIKAs9JujGOoXKHwOB90s34tkgMuoWAv9Y
        I+EqNygltczLCZ0gSesFa2Z6vBzTN5I=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 409e11c6 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 6 May 2022 19:22:27 +0000 (UTC)
Date:   Fri, 6 May 2022 21:22:24 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: calling context of scsi_end_request() always hard IRQ or
 sometimes different?
Message-ID: <YnV1cK6jHVLoDBWj@zx2c4.com>
References: <YnVTf+vkcLl2wZZE@zx2c4.com>
 <ce95ca87344df10a477f16232815e8590118188e.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ce95ca87344df10a477f16232815e8590118188e.camel@linux.ibm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Fri, May 06, 2022 at 02:19:43PM -0400, James Bottomley wrote:
> On Fri, 2022-05-06 at 18:57 +0200, Jason A. Donenfeld wrote:
> > Hey James, Martin,
> > 
> > I'm in the process of fixing a few issues with the RNG and one thing
> > that surprised me is that scsi_end_request() appears to be called
> > from hard IRQ context rather than some worker or soft IRQ as I
> > assumed it would be. That's fine, and I can deal with it, but what I
> > haven't yet been able to figure out is whether it's _always_ called
> > from hard IRQ, or whether it's sometimes from hard IRQ and sometimes
> > not, and so I should handle both cases in the thing I'm working on?
> > 
> > And if the answer turns out to be, "I don't know; that's really
> > complicated and..." just say so, and I'll just try to work out the
> > whole function graph.
> 
> Are you sure you mean scsi_end_request()?  It's static to scsi_lib.c so
> its call graph is tiny  it basically goes from the blk-mq complete
> function (softirq) through scsi_complete->scsi_finish_command-
> >scsi_io_completion->scsi_end_request
> 
> However, I didn't think it was ever called from hard IRQ context,
> that's usually scsi_done() (which can also be called from other
> contexts).

Really what I'm interested in is add_disk_randomness(), and the only
caller of that is scsi_end_request(), so I think my question is the
right one.

Interestingly, I _am_ seeing it from hardirq context (if
`in_interrupt()` is to be believed):

[    2.108954]  add_timer_randomness.cold+0x5/0x3a
[    2.110514]  scsi_end_request+0x136/0x1a0
[    2.111903]  scsi_io_completion+0x2e/0x710
[    2.113314]  virtscsi_req_done+0x59/0xa0
[    2.114705]  vring_interrupt+0x46/0x70
[    2.116002]  __handle_irq_event_percpu+0x32/0xb0
[    2.117591]  handle_irq_event+0x2f/0x70
[    2.118929]  handle_edge_irq+0x7c/0x210
[    2.120249]  __common_interrupt+0x33/0x90
[    2.121641]  common_interrupt+0x7b/0xa0
 
And it sounds like you're saying that this is really a softirq function.
So is it correct for me to conclude that the right answer here is that
it can be called from both/multiple contexts, and that's fine and
normal?

Jason
