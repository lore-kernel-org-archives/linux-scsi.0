From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Don't use unnecessary GFP_ATOMIC in sg.c
Date: Mon, 25 Feb 2008 06:43:08 -0800
Message-ID: <1203950588.3254.12.camel@localhost.localdomain>
References: <20080224233632.GA31228@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40223 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbYBYOnT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 09:43:19 -0500
In-Reply-To: <20080224233632.GA31228@basil.nowhere.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-02-25 at 00:36 +0100, Andi Kleen wrote:
> Don't use unnecessary GFP_ATOMIC in sg.c
> 
> sg.c uses GFP_ATOMIC for a lot of allocations where it isn't necessary.
> There are no locks hold and I don't see any other reasons why GFP_ATOMIC
> should be needed here. So remove them for more reliable allocations.
> 
> Depends on the earlier GFP_DMA patchkit, but only because it happens
> to patch the same places (no real functional dependency) 
> 
> Tested by burning a CD on a kernel with all lock/sleep/etc. debugging enabled.

I'm afraid this is wrong.  Those paths are used in the block layer issue
path.  Most of the time this path does have user context.  However, it's
legal to call it from tasklet context, and most error retries do this.
In that case, your GFP_KERNEL will have problems, so these have to be
GFP_ATOMIC, I'm afraid.

James


