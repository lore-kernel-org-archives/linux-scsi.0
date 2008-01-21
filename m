From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: fix isa/pcmcia compile problem
Date: Mon, 21 Jan 2008 08:59:24 -0600
Message-ID: <1200927564.3157.9.camel@localhost.localdomain>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	 <478F7F2B.9000801@linux.vnet.ibm.com>
	 <20080117111104.3baa878e.akpm@linux-foundation.org>
	 <47904927.1040000@linux.vnet.ibm.com> <47905348.1000709@gmail.com>
	 <20080121095619.GC5333@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38457 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbYAUO7j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2008 09:59:39 -0500
In-Reply-To: <20080121095619.GC5333@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fischer@norbit.de, Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, Samuel Ortiz <samuel@sortiz.org>


On Mon, 2008-01-21 at 09:56 +0000, Christoph Hellwig wrote:
> On Fri, Jan 18, 2008 at 04:20:40PM +0900, Tejun Heo wrote:
> > aha152x.c and fdomain are built twice - once for the isa driver and
> > once for the PCMCIA one.  Through #ifdefs, the compiled codes are
> > slightly different; thus, global symbols need to be given different
> > names depending on which flavor is being built.  This patch adds
> > GLOBAL() macro to aha152x.h and fdomain.h which change the symbol
> > depending on PCMCIA.
> > 
> > This bug has always existed but has been masked by the fact the
> > drivers/scsi/pcmcia used subdir-(y|m) instead of obj-(y|m) which made
> > drivers/scsi/pcmcia/built_in.o not linked into the kernel and thus
> > avoided the duplicate symbols during compilation.
> 
> The right fix would be to compile it only once and attach it to both
> busses.  It would be nice if someone could look into that instead of
> hacking around the issue.

I agree in principle, but without the hardware such a change would be
untested ... which is what makes me worry about it.

James


