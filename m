From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 17:09:18 -0600
Message-ID: <1195600158.17601.15.camel@localhost.localdomain>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119.003802.100741794.davem@davemloft.net>
	 <1195501874.6539.5.camel@pasglop> <20071120082927.GA8856@alpha.franken.de>
	 <1195569362.3131.3.camel@localhost.localdomain> <adaabp8wuma.fsf@cisco.com>
	 <1195593015.17601.10.camel@localhost.localdomain>
	 <1195598343.6970.50.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:45962 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbXKTXJW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 18:09:22 -0500
In-Reply-To: <1195598343.6970.50.camel@pasglop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: benh@kernel.crashing.org
Cc: Roland Dreier <rdreier@cisco.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk


On Wed, 2007-11-21 at 09:39 +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2007-11-20 at 15:10 -0600, James Bottomley wrote:
> > We're talking about trying to fix this for 2.4; which is already at
> > -rc3 ... Is an entire arch change for dma alignment really a merge
> > candidate at this stage?
> 
> Well, as I said before... it's a matter of what seems to be the less
> likely to break something right ?
> 
> On one side,  I'm doing surgery on code I barely know, the scsi error
> handling, and now it seems I also have to fixup a handful of drivers
> that aren't the most obvious pieces of code around.
> 
> On the other side, Roland proposal is basically just adding a macro that
> can be empty for everybody but a handful of archs, and stick it onto one
> field in one structure...

Yes ... it's the getting arch owner agreement to send the patch that
slightly worries me.

> The later has about 0 chances to actually break something or cause a
> regression. I wouldn't say that about the former.
> 
> Now, I will see if I manage to fixup the NCR drivers to pass a
> pre-allocated buffer (USB storage I think can pass NULL as it's not
> calling prep in atomic context). But then, it complicates the matter
> because that means "restore" will have to know whether prep allocated
> the buffer or not, thus more fields to add to the save struct, it's
> getting messy, unless we decide -all- callers are responsible for the
> buffer allocation (hrm... maybe the best approach).

Sorry, yes, that's what I was thinking ... identically to the way the
struct scsi_eh_save is handled ... or indeed as an extra pointer field
inside scsi_eh_save.

James


