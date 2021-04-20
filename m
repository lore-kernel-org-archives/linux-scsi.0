Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEBCC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 18:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F73060200
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 18:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbhDTSDK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 14:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbhDTSC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 14:02:57 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6983AC06138E;
        Tue, 20 Apr 2021 11:02:25 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id C6FCC92009C; Tue, 20 Apr 2021 20:02:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id BFB4692009B;
        Tue, 20 Apr 2021 20:02:24 +0200 (CEST)
Date:   Tue, 20 Apr 2021 20:02:24 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>
cc:     Ondrej Zary <linux@zary.sk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to
 Y2021
In-Reply-To: <d7dc08a6-92be-e524-1f11-cd9f7326a0fd@gonehiking.org>
Message-ID: <alpine.DEB.2.21.2104200456100.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk> <a099f7f8-9601-fd1c-03a4-93587e7276e6@gonehiking.org> <alpine.DEB.2.21.2104162157360.44318@angie.orcam.me.uk> <202104182221.21533.linux@zary.sk> <e3fe98a2-c480-e9bf-67b3-7f51b87975bd@gonehiking.org>
 <alpine.DEB.2.21.2104191747010.44318@angie.orcam.me.uk> <d7dc08a6-92be-e524-1f11-cd9f7326a0fd@gonehiking.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 19 Apr 2021, Khalid Aziz wrote:

> >  Khalid: I have skimmed over these documents and I infer 24-bit addressing 
> > can be verified with any MultiMaster adapter, including ones that do have 
> > 32-bit addressing implemented, by using the legacy Initialize Mailbox HBA 
> > command.  That could be used to stop Christoph's recent changes for older 
> > adapter support removal and replace them with proper fixes for whatever 
> > has become broken.  Is that something you'd be willing as the driver's 
> > maintainer to look into, or shall I?
> 
> Do you mean use OpCode 01 (INITIALIZE MAILBOX) to set a 24-bit address
> for mailbox in place of OpCode 81? Verifying the change would be a
> challenge. Do you have an old adapter to test it with? If you do, go
> ahead and make the changes. I will be happy to review. I have only a
> BT-757 adapter.

 Yes, but upon inspection it looks like our driver doesn't use that opcode 
and relies solely on 32-bit Mode Initialize Mailbox (0x81) even with ISA 
devices.  That makes sense as documentation indicates the firmware has 
been designed to be unified so that the same binary microcontroller code 
runs across all BusLogic MultiMaster devices.

 Anyway given the unified API it should be straightforward to simulate an 
older adapter with a newer one, except for host bus protocol differences.  
So verifying the workaround for broken BT-445S adapters continues to work 
once modernised is not going to be a problem as it can be unconditionally 
activated in a debug environment.  That would verify correct DMA bounce 
buffer operation under the new scheme.

 Verifying actual ISA operations (third-party DMA, etc.) cannot be made 
this way, but as I understand the issue there is merely with passing data 
structures around and that may not require too much attention beyond 
getting things syntactically correct, which I gather someone forgot to do 
with a change made a while ago.  So that should be doable as well.

 NB as noted before I only have a BT-958 readily wired for operation.  I 
don't expect I have any other BusLogic hardware, but I may yet have to 
double-check a stash of hardware I have accumulated over the years.  But 
that is overseas, so I won't be able to get at it before we're at least 
somewhat closer to normality.  If all else fails I could possibly buy one.

 I have respun the series now as promised.  Does your BT-757 adapter avoid 
the issue with trailing allocation somehow?

  Maciej
