From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] 2.6.3 qla2xxx driver -- use readX_relaxed
Date: Wed, 3 Mar 2004 02:10:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040303101014.GA586666@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060EE25@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:43814 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S262386AbUCCKKr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2004 05:10:47 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060EE25@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, jbarnes@cthulhu.engr.sgi.com

On Mon, Mar 01, 2004 at 04:45:49PM -0800, Andrew Vasquez wrote:
> On Wednesday, February 25, 2004 8:06 PM,
> linux-scsi-owner@vger.kernel.org wrote: 
> > For those to whom this is new (it was discussed on linux-kernel and
> > linux-ia64 I believe), normal PCI register reads imply that PCI DMA
> > writes that occured prior to the PCI MMR (memory mapped register)
> > read (on the PCI bus) will be reflected in system memory once the
> > MMR read is complete.
> > 
> > On our platforms, we can speed up the MMR read significantly if that
> > ordering requirement is "relaxed".
> > 
> 
> Interesting...but this implementation seems to be applying a different
> set of semantic rules to the term 'relaxed' in comparison to the
> 'relaxed ordering' rules defined by PCI-X and PCI-Express, no?


I'm going to retract my previous agreement to this :-).  I took a good
look at the PCI Express specification today, and it appears to me as
though this implementation should be applicable to PCI Express.

Relaxed Ordering on PCI Express can be set on memory reads (i.e. PIO
reads originated by the processor) and posted memory writes (i.e. DMA
writes originated by the Qlogic chip).

When set, it indicates that the posted write or the read completion
(reply from the device to the PIO read) may pass other posted writes,
read completions, or messages.

For optimal efficiency, the Qlogic chip should set the relaxed order
bit for DMA writes of data (not response queue DMA writes), and the
host bridge should set the relaxed order bit on PIO reads in which
it is safe for the reply to pass posted writes, read completions, and
messages.  Of course, this all assume that the host bridge and the
PCI device implement this bit and can turn it on and off on a
per PCI transaction basis.

In theory, I think this would mean you could turn on relaxed ordering
for all PIO reads, save for the read of the response queue out (or
host status on the 2300).  You could make that read relaxed also with
a little bit of driver work.  You'd need to detect when the response
queue DMA write for IOCB X completes after a PIO read indicates that
IOCB X is done.  When you saw that, you could issue a non-relaxed read
of the response queue out (or host status).  Since mailbox completions
are relatively rare, you could issue a non-relaxed read for those
if necessary, before examing data that is implied by the mailbox
completion.

jeremy
