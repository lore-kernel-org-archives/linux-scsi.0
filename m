From: David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH]: Rewritten ESP driver, porters needed!
Date: Fri, 27 Apr 2007 13:28:38 -0700 (PDT)
Message-ID: <20070427.132838.39157332.davem@davemloft.net>
References: <20070424122235.GA26242@infradead.org>
	<20070424.134440.45874613.davem@davemloft.net>
	<20070427151658.GA21669@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57422
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757204AbXD0U2a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2007 16:28:30 -0400
In-Reply-To: <20070427151658.GA21669@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org, jskov@cygnus.co.uk, weisd3458@uni.edu, tymm@computer.org, tsbogend@alpha.franken.de, flo@rfc822.org, airlied@linux.ie, ralf@linux-mips.org, sparclinux@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 27 Apr 2007 16:16:58 +0100

> aic7xxx might not be the best driver to look at either :)  In practice
> a softirq has short enough latency so this doesn't matter, but you
> should probably benchmark it on your hardware.  53x700.c which is
> the most modern scsi driver and is in about the same hardware class
> as the esp gets away without using internal queues, but it also
> has a nice internal buffer where commands can just be put into slots
> for later execution.

This driver runs on machines with 10MHz cpus (sun4c), the delay to the
softirq surely matters for those guys :-)

> Btw, using the block layer tcq code and the scsi wrappers for it
> would be nice aswell.

Hmm, I though I was doing so by using the interfaces found in
include/scsi/scsi_tcq.h which I am doing.

Oh, you're suggesting to use scsi_find_tag() for reconnect handling?

Do I have to do anything special for that to work or can I just
add calls to it right now?
