Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD329C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 15:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B55C61026
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 15:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343534AbhDPPS5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 11:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343523AbhDPPSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 11:18:47 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE3B6C06175F;
        Fri, 16 Apr 2021 08:18:21 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id CDA9292009C; Fri, 16 Apr 2021 17:18:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id C92F592009B;
        Fri, 16 Apr 2021 17:18:20 +0200 (CEST)
Date:   Fri, 16 Apr 2021 17:18:20 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Nix <nix@esperi.org.uk>
cc:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] scsi: Set allocation length to 255 for ATA Information
 VPD page
In-Reply-To: <878s5joh2d.fsf@esperi.org.uk>
Message-ID: <alpine.DEB.2.21.2104161628540.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk> <alpine.DEB.2.21.2104141306130.44318@angie.orcam.me.uk> <878s5joh2d.fsf@esperi.org.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 15 Apr 2021, Nix wrote:

> > Set the allocation length to 255 for the ATA Information VPD page 
> > requested in the WRITE SAME handler, so as not to limit information 
> > examined by `scsi_get_vpd_page' in the supported vital product data 
> > pages unnecessarily.
> >
> > Originally it was thought that Areca hardware may have issues with a 
> > valid allocation length supplied for a VPD inquiry, however older SCSI 
> > standard revisions[1] consider 255 the maximum length allowed and what 
> 
> Aaaah. That explains a lot! (Not that I can remember what SCSI standard
> rev that Areca firmware claimed to implement. I know I never updated the
> firmware, so it's going to be something no newer than mid-2009 and
> probably quite a bit older.)

 From the original discussion I gather Areca sometimes acts as a 
pass-through device to actual storage hardware, so it may well have been 
decided for the firmware to take a conservative approach and interpret 
the low order byte only.  A genuine bug cannot be ruled out either of 
course, which I why I will appreciate your testing.

> >  I can see you're still around.  Would you therefore please be so kind 
> > as to verify this change with your Areca hardware if you still have it?
> 
> It's been up in the loft for years, but I'll get it out this weekend and
> give it a spin :) this'll let me make sure the disks still spin as well,
> which matters for an in-case-of-lightning-strike disaster-recovery
> backup box.
> 
> (I just hope this kernel boots on it at all. It's about three years
> since I retired it... let's see!)

 FWIW if all else fails you can try this patch with the original kernel 
you used with the box.  This piece of code hasn't changed, so until I 
came up with the complete five-part solution proposed here I merely had 
the original commit reverted as it is so as to allow forward progress.

 In any case, as per the cover letter, I have upgraded from 2.6.18, much 
older, and this was the sole show-stopper for the machine, running SMP 
even, so chances are 5.11+ will work with your system as well.  The 
other plain 486/EISA/ATA box, similarly upgraded (now that I got its 
faulty odd industrial PSU finally replaced) works just fine with vanilla 
5.11.

 OTOH versions ~3.15 through to ~4.5 I have tried while bisecting this 
issue mostly failed to even start booting due to what looks like a 
heisenbug to me (e.g. switching from XZ to gzip for compression would 
make some, but not all versions/configurations boot occasionally), so 
YMMV.

 Overall we're not that bad with keeping stuff working, it's more new 
use that causes troubles sometimes.

> >  It looks to me like you were thinking in the right direction with: 
> > <https://lore.kernel.org/linux-scsi/87vc3nuipg.fsf@spindle.srvr.nix/>. 
> 
> It's the sort of mistake I could see myself making: an easy mistake to
> make when so many things in C require buffer size - 1 or you get a
> disastrous security hole...

 And here it's masking, except that with (256 - 1) rather than (512 - 1) 
as you suggested.

 Thank you for your input!

  Maciej
