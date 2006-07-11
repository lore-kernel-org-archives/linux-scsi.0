From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptsas : reserving a channel for integrated raid
Date: Tue, 11 Jul 2006 15:42:21 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701F6489@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:10691 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751330AbWGKVm3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 17:42:29 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

-- Tuesday, July 11, 2006 1:11 PM, James Bottomley wrote: 

> > This patch moves the reserved channel to -1. This can be
> > easily changed to some other value in the future release
> > since its a hash define.
> 
> I don't think -1 showing up in the channel field is a good idea ... I
> bet it will confuse parsers of that information.
> 

agreed.  It was merely a work around that didn't require transport
change.

> > Its higly doubtfull the transport layer would ever
> > use up all the port ids, and wrap back around to zero since
> > this is int.
> 
> Do we still need this channel number as port number stuff anyway?

no

> Originally it was the outgoing phy that was identified in the channel,
> but even that's no longer true.  Since the target ids are assigned per
> HBA, they're unique enough without requiring additional channel
> stuff ... how about killing the non zero channel in the sas transport
> class and then you can simply use 1 for the raid virtual channel?
> 

Correct, originally it was phy_id, then I changed it to port_id.

I'll work in it this afternoon, trying to getting something out later
today.

Eric

