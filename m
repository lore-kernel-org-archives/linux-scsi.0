From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Don't use unnecessary GFP_ATOMIC in sg.c
Date: Mon, 25 Feb 2008 15:56:25 +0100
Message-ID: <20080225145625.GA16158@one.firstfloor.org>
References: <20080224233632.GA31228@basil.nowhere.org> <1203950588.3254.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:55148 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbYBYOzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 09:55:50 -0500
Content-Disposition: inline
In-Reply-To: <1203950588.3254.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org

On Mon, Feb 25, 2008 at 06:43:08AM -0800, James Bottomley wrote:
> On Mon, 2008-02-25 at 00:36 +0100, Andi Kleen wrote:
> > Don't use unnecessary GFP_ATOMIC in sg.c
> > 
> > sg.c uses GFP_ATOMIC for a lot of allocations where it isn't necessary.
> > There are no locks hold and I don't see any other reasons why GFP_ATOMIC
> > should be needed here. So remove them for more reliable allocations.
> > 
> > Depends on the earlier GFP_DMA patchkit, but only because it happens
> > to patch the same places (no real functional dependency) 
> > 
> > Tested by burning a CD on a kernel with all lock/sleep/etc. debugging enabled.
> 
> I'm afraid this is wrong.  Those paths are used in the block layer issue
> path.  Most of the time this path does have user context.  However, it's
> legal to call it from tasklet context, and most error retries do this.
> In that case, your GFP_KERNEL will have problems, so these have to be
> GFP_ATOMIC, I'm afraid.

In what path? I couldn't find one while reading the code. But I don't
claim to understand it completely so I might have missed something.

-Andi
