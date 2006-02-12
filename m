From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] ipr: don't doublefree pages from scatterlist
Date: Sun, 12 Feb 2006 18:57:56 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0602121838050.15101@goblin.wat.veritas.com>
References: <Pine.LNX.4.61.0602040004020.5406@goblin.wat.veritas.com>
 <43E7613B.5060706@us.ibm.com> <Pine.LNX.4.61.0602061621450.3560@goblin.wat.veritas.com>
 <200602062211.29993.ak@suse.de> <Pine.LNX.4.61.0602062154430.3652@goblin.wat.veritas.com>
 <20060211223810.GA12064@tau.solarneutrino.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silver.veritas.com ([143.127.12.111]:14396 "EHLO
	silver.veritas.com") by vger.kernel.org with ESMTP id S1750831AbWBLS52
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 13:57:28 -0500
Received: from goblin.wat.veritas.com([10.10.97.2]) (2938 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1F8MPX-0001UNC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2006 10:57:27 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <20060211223810.GA12064@tau.solarneutrino.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Richter <ryan@tau.solarneutrino.net>, Andi Kleen <ak@suse.de>
Cc: Brian King <brking@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 11 Feb 2006, Ryan Richter wrote:
> On Mon, Feb 06, 2006 at 10:11:09PM +0000, Hugh Dickins wrote:
> > Below is, I think, the 2.6.15 equivalent of the patch Andi posted.
> > Ryan cannot effectively test Andi's patch on 2.6.16-rc because Mike
> > Christie's scsi_execute_async changes have serendipitously fixed
> > the st instance.  Ryan, would you be able to test the patch below
> > on 2.6.15 without my st.c,st.h patch?
> 
> This patch survived 6 runs, and I'll keep running it.

Many thanks for all your efforts on this, Ryan: for reporting the bug,
for your patience in waiting for a diagnosis and a fix, and for
uncomplainingly testing so many workarounds and fixes.

I'll say a mean thing, but please take it as the compliment it's
intended to be: I hope you find lots more bugs, because you're the
rare someone we can depend on to see them through to the final fix!
Nah, you've had your share, you deserve a break.

Andi, do you feel this x86_64-gart-dma-merge.patch has now had enough
testing?  I've read through your gart_map_sg() more carefully now, and
the patch looks right to me (it seems to be a misunderstanding that the
lines you're now deleting were ever in).  I've also read through, less
carefully, the sg coalescing routines in other architectures, and found
no such offending code in them.  Brian did the same earlier and found
nothing.

So I'd like to believe that your x86_64-gart-dma-merge.patch is the
final answer to this issue, and see it go forward into 2.6.16-rc -
if you feel it's ready now.  Then we can just throw away those driver
patches I posted a week ago (including the "ipr" one of this thread).

Thanks,
Hugh
