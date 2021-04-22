Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4681EC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 23:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16ADA610A2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 23:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbhDVXUI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 19:20:08 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:39572 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236763AbhDVXUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 19:20:07 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 53A9E92009C; Fri, 23 Apr 2021 01:19:30 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 4D33D92009B;
        Fri, 23 Apr 2021 01:19:30 +0200 (CEST)
Date:   Fri, 23 Apr 2021 01:19:30 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>
cc:     Ondrej Zary <linux@zary.sk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to
 Y2021
In-Reply-To: <0a4d979b-e3f8-959d-fb9a-3a0fcea42141@gonehiking.org>
Message-ID: <alpine.DEB.2.21.2104230057380.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk> <a099f7f8-9601-fd1c-03a4-93587e7276e6@gonehiking.org> <alpine.DEB.2.21.2104162157360.44318@angie.orcam.me.uk> <202104182221.21533.linux@zary.sk> <e3fe98a2-c480-e9bf-67b3-7f51b87975bd@gonehiking.org>
 <alpine.DEB.2.21.2104191747010.44318@angie.orcam.me.uk> <d7dc08a6-92be-e524-1f11-cd9f7326a0fd@gonehiking.org> <alpine.DEB.2.21.2104200456100.44318@angie.orcam.me.uk> <b23c0a0e-d95b-b941-1cc2-1a8bcf44401a@gonehiking.org> <alpine.DEB.2.21.2104221808170.44318@angie.orcam.me.uk>
 <0a4d979b-e3f8-959d-fb9a-3a0fcea42141@gonehiking.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 22 Apr 2021, Khalid Aziz wrote:

> >>>  Verifying actual ISA operations (third-party DMA, etc.) cannot be made 
> >>> this way, but as I understand the issue there is merely with passing data 
> >>> structures around and that may not require too much attention beyond 
> >>> getting things syntactically correct, which I gather someone forgot to do 
> >>> with a change made a while ago.  So that should be doable as well.
> >>
> >> In theory this sounds reasonable, but without being able to test with a
> >> real hardware I would be concerned about making this change.
> > 
> >  Sometimes you have little choice really and that would be less disruptive 
> > than dropping support altogether.  Even if there's a small issue somewhere 
> > it's easier to fix by a competent developer who actually gets the hands on 
> > a piece of hardware than bringing back old code that has been removed and 
> > consequently not updated according to internal API evolution, etc.
> 
> We are talking about removing support for BT-445S with firmware version
> older than 3.37.

 Umm, no.  As still quoted above I referred to ISA devices, such as the 
BT-545C.  ISA only has 24 address lines so no firmware change can make 
these devices address memory beyond 16MiB (whether as a bus master or with 
the aid of an 8237 DMA controller).

> That is a very specific case. To continue support for
> this very specific case, we have to add new code to use local bounce
> buffer and we have no hardware to verify this new code. This will be new
> code whether we add it now or later after we find someone even has this
> very old card with old firmware. I would prefer to remove support for
> now and add new code to add support for firmware version older than 3.37
> back only if there is a need later. For now anyone who is using a
> BT-445S and has updated firmware on their card will not see a change.

 As long as ISA support has been retained the BT-445S can just reuse the 
logic.

 I'm not strongly attached to ISA support though, and we continue 
supporting other SCSI HBAs for ISA.  But we do that even though they 
require a dedicated driver while with the unified MultiMaster architecture 
it would seem support for another host bus should be low-hanging fruit.

  Maciej
