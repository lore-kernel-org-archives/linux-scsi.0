From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Thu, 11 Mar 2004 22:11:19 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040312061119.GA6402@praka.local.home>
References: <20040305041850.GA9124@colo.lackof.org> <20040305071721.GA9684@praka.local.home> <20040305172147.GB17305@colo.lackof.org> <20040309164033.GA21648@praka.local.home> <20040310221241.GA7903@colo.lackof.org>
Reply-To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:62884 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261983AbUCLGdN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 01:33:13 -0500
Content-Disposition: inline
In-Reply-To: <20040310221241.GA7903@colo.lackof.org>
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 10 Mar 2004, Grant Grundler wrote:

> > There are three places where the driver could fall into stuck case of
> > handling RSCNs.  The attached patch introduces behaviour consistent
> > with what we have for several of our other platform drivers.  The end
> > result is the will be 1) The driver will not hang during
> > init/post-init due to the stream of RSCNs.  2) The driver after init,
> > will *not* present any devices to the mid-layer due to the volatility
> > within the fabric.
> 
> Still doesn't seem to make forward progress...console output appended.
> (cut/pasted...white space is probably mangled)
> 
> And now the ssh sessions are "hung" (un responsive).
> So I can't reboot the box to 'clear' the error.
> We must be pretty close to a fix. :^)
> 

Arrgg...  Ok, locally I managed to convince the firmware group to give
me a 'special' build which posts RSCN events to the driver every
100ms.  This, at least in my mind, should be similiar (perhaps not the
exact same) to the pattern of events present in your configuration
with the borken JBOD (as can be consistently observed from the
traces).  

On my dual Xeon (with HT) box, scsi-misc-2.6 with my earlier patch,
and some minimal printk()s, worked as I would expect -- looped 256
times through the qla2x00_configure_loop() do/while loop in
qla2x00_initialize_adapter().  No devices mapped, insmod completed.
And the DPC routine (kernel thread) then tasked with managing the
unending flood of RSCN events.  With all this activity, unloading the
driver (with a modprobe -r qla2300) took an a bit of time, but did
ultimately complete.

So, I'm not entirely clear on what else is going on with your
configuration.  I'll try to get some runtime on an ia64 machine
tomorrow to perform the same test.  

Sorry about leaving your machine in such a borked state, but, could
you reverify the test?  I don't believe we'll need any extended error
logging, so disable DEBUG2.  If that fails, then I just may need that
SSH access.

Thanks,
Andrew Vasquez
