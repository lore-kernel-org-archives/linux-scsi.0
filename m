From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH]: Rewritten ESP driver, porters needed!
Date: Sun, 13 May 2007 22:10:35 +0100
Message-ID: <20070513211035.GA14264@infradead.org>
References: <20070424122235.GA26242@infradead.org> <20070424.134440.45874613.davem@davemloft.net> <20070427151658.GA21669@infradead.org> <20070427.132838.39157332.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46400 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbXEMVKj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 May 2007 17:10:39 -0400
Content-Disposition: inline
In-Reply-To: <20070427.132838.39157332.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, jskov@cygnus.co.uk, weisd3458@uni.edu, tymm@computer.org, tsbogend@alpha.franken.de, flo@rfc822.org, airlied@linux.ie, ralf@linux-mips.org, sparclinux@vger.kernel.org

On Fri, Apr 27, 2007 at 01:28:38PM -0700, David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Fri, 27 Apr 2007 16:16:58 +0100
> 
> > aic7xxx might not be the best driver to look at either :)  In practice
> > a softirq has short enough latency so this doesn't matter, but you
> > should probably benchmark it on your hardware.  53x700.c which is
> > the most modern scsi driver and is in about the same hardware class
> > as the esp gets away without using internal queues, but it also
> > has a nice internal buffer where commands can just be put into slots
> > for later execution.
> 
> This driver runs on machines with 10MHz cpus (sun4c), the delay to the
> softirq surely matters for those guys :-)

Hmm, okay.  I still hate having the queues in the driver so we should
think about a nice mid-layer helper for this.  E.g. having a return
value from ->queuecommand that means "prepared but not issued the command"
and then an irq-safe API to grab these commands from the irq handler.
This would mean all the list managment and especially the EH related
code could move to the midlayer.

> > Btw, using the block layer tcq code and the scsi wrappers for it
> > would be nice aswell.
> 
> Hmm, I though I was doing so by using the interfaces found in
> include/scsi/scsi_tcq.h which I am doing.
> 
> Oh, you're suggesting to use scsi_find_tag() for reconnect handling?
> 
> Do I have to do anything special for that to work or can I just
> add calls to it right now?

You don't need to anything too special.  You'll need calls to
scsi_set_tag_type and scsi_activate_tcq in ->slave_configure,
scsi_deactivate_tcq in case you need to deactivate tcq support on
a device and make sure to call scsi_populate_tag_msg when starting
a command.  All these have nice kerneldoc descriptions in
include/scsi/scsi_tcq.h.
