Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D22FC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 13:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25C93611AC
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 13:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhDONZc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:25:32 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:48454 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDONZb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 09:25:31 -0400
X-Greylist: delayed 2585 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2021 09:25:31 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTP id 13FCg21I028870;
        Thu, 15 Apr 2021 13:42:02 +0100
From:   Nix <nix@esperi.org.uk>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] scsi: Set allocation length to 255 for ATA Information VPD page
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
        <alpine.DEB.2.21.2104141306130.44318@angie.orcam.me.uk>
Emacs:  a compelling argument for pencil and paper.
Date:   Thu, 15 Apr 2021 13:42:02 +0100
In-Reply-To: <alpine.DEB.2.21.2104141306130.44318@angie.orcam.me.uk> (Maciej
        W. Rozycki's message of "Thu, 15 Apr 2021 00:39:28 +0200 (CEST)")
Message-ID: <878s5joh2d.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1481; Body=8 Fuz1=8 Fuz2=8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14 Apr 2021, Maciej W. Rozycki stated:

> Set the allocation length to 255 for the ATA Information VPD page 
> requested in the WRITE SAME handler, so as not to limit information 
> examined by `scsi_get_vpd_page' in the supported vital product data 
> pages unnecessarily.
>
> Originally it was thought that Areca hardware may have issues with a 
> valid allocation length supplied for a VPD inquiry, however older SCSI 
> standard revisions[1] consider 255 the maximum length allowed and what 

Aaaah. That explains a lot! (Not that I can remember what SCSI standard
rev that Areca firmware claimed to implement. I know I never updated the
firmware, so it's going to be something no newer than mid-2009 and
probably quite a bit older.)

> Nix,
>
>  I can see you're still around.  Would you therefore please be so kind 
> as to verify this change with your Areca hardware if you still have it?

It's been up in the loft for years, but I'll get it out this weekend and
give it a spin :) this'll let me make sure the disks still spin as well,
which matters for an in-case-of-lightning-strike disaster-recovery
backup box.

(I just hope this kernel boots on it at all. It's about three years
since I retired it... let's see!)

>  It looks to me like you were thinking in the right direction with: 
> <https://lore.kernel.org/linux-scsi/87vc3nuipg.fsf@spindle.srvr.nix/>. 

It's the sort of mistake I could see myself making: an easy mistake to
make when so many things in C require buffer size - 1 or you get a
disastrous security hole...

-- 
NULL && (void)
