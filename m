Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75D0C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 14:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C7B921841
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 14:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfI0OLk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 10:11:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32912 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726540AbfI0OLk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Sep 2019 10:11:40 -0400
Received: (qmail 2212 invoked by uid 2102); 27 Sep 2019 10:11:39 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 27 Sep 2019 10:11:39 -0400
Date:   Fri, 27 Sep 2019 10:11:39 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Douglas Gilbert <dgilbert@interlog.com>
cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-usb@vger.kernel.org>,
        <usb-storage@lists.one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH 0/2] Fix SCSI & USB Storage CHECK CONDITION handling
In-Reply-To: <631aa72f-4eee-bb5d-a81c-62df3a5a09e8@interlog.com>
Message-ID: <Pine.LNX.4.44L0.1909271004470.1698-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 26 Sep 2019, Douglas Gilbert wrote:

> On 2019-09-26 7:57 p.m., Alan Stern wrote:

> > PS: The correct term is "residue", not "residual".  I know that the
> > code sometimes uses the wrong word.
> 
> Digging into my T10 document archive I found this cam3r03.pdf :
> 
>    − cam_resid;
>      The data residual length member contains the difference in twos
>      complement form of the number of data bytes transferred by the
>      HA for the SCSI command compared with the number of bytes
>      requested by the CCB cam_dxfer_len member. This is calculated
>      by the total number of bytes requested to be transferred by the
>      CCB minus the actual number of bytes transferred by the HA.
> 
> CAM is a now withdrawn T10 standard from the 1990s that was influential
> at the time. FreeBSD's SCSI subsystem is (still) based on CAM.

I was going by my old copy of X3T9.2 Project 375D Rev 10L, Working 
Draft, "Information technology - Small Computer System Interface - 2", 
from back in 1996.  Yes, it's thoroughly out of date, but you would 
think that the nomenclature would still be accurate.  At any rate, it 
includes 24 instances of the word "residue" and no instances of 
"residual".

On the other hand, my copy of X3T10/792D Rev 12b, draft proposed, 
"Information technology - SCSI-2 Common access method transport and 
SCSI interface module", dated 1995, contains 24 instances of "residual" 
and only 2 instances of "residue".

So I guess this was never defined precisely.

> For a more recent standard/draft there is fcp5r00.pdf that uses the
> term "residual value" when defining its fcp_resid.
> 
> The only reference to the term "residue" that I found is in CAM: an
> optional message: IGNORE WIDE RESIDUE .
> 
> So I would leave the naming up to the patch author. It is pretty
> clear what is being referred to in either case.

True enough.

Alan Stern

> Doug Gilbert
> 
> 
> P.S. I prefer "residual" because it is more flexible being both
> an adjective and a noun.
> [Ref: https://www.lexico.com/en/definition/residual]

