From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] scsi: Add added_to_sysfs sdev flag to fix device
	scanning oops
Date: Mon, 18 Aug 2008 09:12:07 -0500
Message-ID: <1219068727.3261.7.camel@localhost.localdomain>
References: <200808111804.m7BI46kb004687@d03av03.boulder.ibm.com>
	 <1218840807.3350.72.camel@localhost.localdomain>
	 <48A981F0.5030002@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51138 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbYHROMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2008 10:12:10 -0400
In-Reply-To: <48A981F0.5030002@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-08-18 at 09:06 -0500, Brian King wrote:
> James Bottomley wrote:
> > What this seems to be exposing is a bug in the state model around the
> > blocked state.
> > 
> > The transition:
> > 
> > CREATED -> BLOCK -> RUNNING
> > 
> > shouldn't be legal.  My initial reaction is just to forbid the CREATED
> > -> BLOCK transition, but it looks like the fc transport code never
> > checks return values from scsi_target_block() (sigh!)
> > 
> > So an alternate fix should be to correct the state model rather than try
> > and work around the deficiencies with additional flags.
> > 
> > It looks like, to allow the CREATED -> BLOCK -> CREATED transition we
> > need an extra state (CREATED_BLOCK) and we forbid the CREATED -> BLOCK
> > in favour of it.
> > 
> > The model also now allows an online transition to do CREATED_BLOCK ->
> > BLOCK
> > 
> > This is a rough code of that, does it work for you?
> 
> I loaded up your patch and this fixes my issue as well. Do we need to also
> add a check for SDEV_CREATED_BLOCK in scsi_dispatch_cmd?

Yes ... everywhere we previously checked for SDEV_BLOCK ... really, that
check now needs to be made into an inline function.  I'll reroll the
patch properly with that included.

James


