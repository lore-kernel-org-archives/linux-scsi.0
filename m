From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Don't use unnecessary GFP_ATOMIC in sg.c v2
Date: Mon, 25 Feb 2008 15:33:24 +0100
Message-ID: <20080225143324.GA15836@one.firstfloor.org>
References: <20080225090948.GA5843@basil.nowhere.org> <47C2C0C0.4010801@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:37933 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYBYOct (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 09:32:49 -0500
Content-Disposition: inline
In-Reply-To: <47C2C0C0.4010801@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Andi Kleen <andi@firstfloor.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

> Oh no, not again. This isn't the first time kernel folks
> have tried to demote the sg driver's GFP_ATOMIC to GFP_KERNEL.

That is because it is abusing GFP_ATOMIC.

> In the past it has ended in grief. The driver was written
> to attempt _fast_ allocation and if that failed then:

You want it to not swap?  Then __GFP_NOIO would be correct.

>   - lessen the requested allocation (e.g. smaller elements
>     but more of them in a scatter gather list), or

What is when the allocation is already 1 page? 

>   - report the error back to the user (i.e. ENOMEM) assuming
>     that they are knowledgeable enough to do something about it
>     (e.g. do two smaller READs rather than one larger one).

But the kernel can actually do something about it, just not
when you pass it __GFP_ATOMIC.

-Andi

