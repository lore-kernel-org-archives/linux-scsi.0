Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BD6C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 16:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FF7061285
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 16:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242031AbhDSQCW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 12:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242016AbhDSQCT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 12:02:19 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C5EEC06174A;
        Mon, 19 Apr 2021 09:01:49 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 469F992009D; Mon, 19 Apr 2021 18:01:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 435F492009C;
        Mon, 19 Apr 2021 18:01:47 +0200 (CEST)
Date:   Mon, 19 Apr 2021 18:01:47 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>, Ondrej Zary <linux@zary.sk>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to
 Y2021
In-Reply-To: <e3fe98a2-c480-e9bf-67b3-7f51b87975bd@gonehiking.org>
Message-ID: <alpine.DEB.2.21.2104191747010.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk> <a099f7f8-9601-fd1c-03a4-93587e7276e6@gonehiking.org> <alpine.DEB.2.21.2104162157360.44318@angie.orcam.me.uk> <202104182221.21533.linux@zary.sk>
 <e3fe98a2-c480-e9bf-67b3-7f51b87975bd@gonehiking.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 19 Apr 2021, Khalid Aziz wrote:

> On 4/18/21 2:21 PM, Ondrej Zary wrote:
> > 
> > Found the 3000763 document here:
> > https://doc.lagout.org/science/0_Computer Science/0_Computer History/old-hardware/buslogic/3000763_PCI_EISA_Wide_SCSI_Tech_Ref_Dec94.pdf
> > 
> > There's also 3002593 there:
> > https://doc.lagout.org/science/0_Computer Science/0_Computer History/old-hardware/buslogic/
> > 
> 
> Thanks!!!

 Ondrej: Thanks a lot indeed!  These documents seem to have the essential 
interface details all covered, except for Fast-20 SCSI adapters, which I 
guess are a minor modification from the software's point of view.

 Khalid: I have skimmed over these documents and I infer 24-bit addressing 
can be verified with any MultiMaster adapter, including ones that do have 
32-bit addressing implemented, by using the legacy Initialize Mailbox HBA 
command.  That could be used to stop Christoph's recent changes for older 
adapter support removal and replace them with proper fixes for whatever 
has become broken.  Is that something you'd be willing as the driver's 
maintainer to look into, or shall I?

  Maciej
