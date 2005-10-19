From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Wed, 19 Oct 2005 14:08:37 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C048F08AE@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:13478 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751279AbVJSUIz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 16:08:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Wednesday, October 19, 2005 1:24 PM, Luben Tuikov wrote: 

> On 10/19/05 14:01, Christoph Hellwig wrote:
> > Add a flag to mark a PHY as attached to the HBA as opposed 
> to beeing on
> > an expander.  This is needed because various features are 
> only supported
> > on those.  This is a crude hack, the proper fix would be to use
> > different classes for host-attached vs expander phys.  I'm 
> looking into
> > that.
> 
> The phy isn't quite "attached" -- i.e. at software level you do not
> care about that.  At least I've never heard anyone (not of 
> "the community")
> say that a phy is "attached".
> 

Luben:  He is adding support for linkerrors and link/phy reset;
these for for CSMI/SDI API.

Can you in your driver retreive link errors for the links on the expanders?

Same question for sending link and phy resets for expander phys? 
If so, then perhaps that check should be removed, and lets let the lld
decide whether these attibutes should return -EINVAL.

For fusion, these new attributes only work for the phys on the hba.
The problem is the firmware implmentation for `link errors and 
link/phy reset` is addressed only by the phy identifier for the phys
attacted directly on the host adapter.  Doesn't work for phys on
the expander. 

> You don't need to represent that.  While you can, you 
> completely do not
> need to do it.  All you should care about is the _port_.  Take a look
> at SAS section 4.
> 
> Also take a look at:
> drivers/scsi/sas/sas_phy.c,
> drivers/scsi/sas/sas_port.c and
> drivers/scsi/sas/sas_discover.c .

What and where can I get this?

Best regards,
Eric Moore
