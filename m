From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: Fw: [Bugme-new] [Bug 3125] New: Can't read data from zip250 reiserfs partition
Date: Tue, 3 Aug 2004 02:33:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040803013315.GP12308@parcelfarce.linux.theplanet.co.uk>
References: <20040727125712.71011b65.akpm@osdl.org> <20040802213323.GO12308@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:37796 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264929AbUHCBd0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Aug 2004 21:33:26 -0400
Content-Disposition: inline
In-Reply-To: <20040802213323.GO12308@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 02, 2004 at 10:33:23PM +0100, viro@parcelfarce.linux.theplanet.co.uk wrote:
> On Tue, Jul 27, 2004 at 12:57:12PM -0700, Andrew Morton wrote:
> > 
> > Looks like a repeatable crash in the imm.c driver.
> 
> Can't reproduce it here.  OTOH, randy had been able to; looks like we
> might get somewhere tonight (it's on his home box).

OK...  Here's what's going on: imm is PIO-only (hardly a surprise, since it's
a parport ZIP drive).  If we have highmem enabled, eventually we get a request
with sglist refering to unmapped page.  Normally we wouldn't give a fsck -
we know that it's accessible to DMA and that's it.  However, in this driver
we really need CPU access to the damn thing.

So imm.c and ppa.c are screwed on highmem kernels and I would expect even more
fun on non-x86.  AFAICS, other non-DMA drivers are no better - e.g. eata_pio()
is broken in the same way, ditto for fdomain.c, etc.

Any suggestions re clean fix?  I'm seriously tempted to do atomic kmap of
pages we are accessing, ugly as it is...
