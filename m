From: linas@austin.ibm.com (Linas Vepstas)
Subject: EDAC & PCI error recovery (was Re: [PATCH 2/2] powerpc: MPC85xx EDAC device driver)
Date: Wed, 1 Aug 2007 14:48:57 -0500
Message-ID: <20070801194857.GL4884@austin.ibm.com>
References: <20070730214404.GE4884@austin.ibm.com> <845900.3390.qm@web50107.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:56768 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbXHATtF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 15:49:05 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l71Jn0iY016038
	for <linux-scsi@vger.kernel.org>; Wed, 1 Aug 2007 15:49:00 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l71Jn0ok262090
	for <linux-scsi@vger.kernel.org>; Wed, 1 Aug 2007 13:49:00 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l71JmvCo032193
	for <linux-scsi@vger.kernel.org>; Wed, 1 Aug 2007 13:49:00 -0600
Content-Disposition: inline
In-Reply-To: <845900.3390.qm@web50107.mail.re2.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougthompson@xmission.com
Cc: Dave Jiang <djiang@mvista.com>, Arnd Bergmann <arnd@arndb.de>, galak@kernel.crashing.org, linuxppc-dev@ozlabs.org, bluesmoke-devel@lists.sourceforge.net, norsk5@yahoo.com, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, halr@voltaire.com, openib-general@openib.org, rolandd@cisco.com, amitkale@netxen.com, munsone@us.ibm.com

On Mon, Jul 30, 2007 at 03:47:05PM -0700, Doug Thompson wrote:
> 
> --- Linas Vepstas <linas@austin.ibm.com> wrote:
> > Also: please note that the linux kernel has a pci error recovery
> > mechanism built in; its used by pseries and PCI-E. I'm not clear
> > on what any of this has to do with EDAC, which I thought was supposed 
> > to be for RAM only. (The EDAC project once talked about doing pci error 
> > recovery, but that was years ago, and there is a separate system for
> > that, now.)
> 
> no, edac can/does harvest PCI bus errors, via polling and other hardware error detectors.

Ehh! I had no idea. A few years ago, when I was working on the PCI error
recovery, I sent a number of emails to the various EDAC people and mailing 
lists that I could find, and never got a response.  I assumed the
project was dead. I guess its not ... 

> But at the current time, few PCI device drivers initialize those callback functions and
> thus errors are lost and some IO transactions fail.

There are patches for 6 drivers in mainline (e100, e1000, ixgb, s2io,
ipr, lpfc), and two more pending (sym53cxxx, tg3).  So far, I've written 
all of them. 

> Over time, as drivers get updated (might take some time) then drivers
> can take some sort of action FOR THEMSELVES

I think I need to do more to raise awareness and interest.

> Yet, there is no tracking of errors - except for a log message in the log file.
> 
> There is NO meter on frequency of errors, etc. One must grep the log file and that is not a very
> cycle friendly mechanism.

Yeah, there was low interest in stats. There's a core set of stats in
/proc/pp64/eeh, but these are clearly arch-specific. I'd ike to move
away from those.  Some recent patches added stats to the /sys tree,
under the individual pci bridge and device nodes.  Again, these are
arch-specific; I'd like to move to some geeral/standardized presentation.

> The reason I added PCI parity/error device scanning, was that when I was at Linux Networx, we had
> parity errors on the PCI-X bus, but didn't know the cause.  After we discovered that a simple
> PCI-X riser card had manufacturing problems (quality) and didn't drive lines properly, it caused
> parity errors. 

Heh. Not unusual. I've seen/heard of cases with voltages being low,
and/or ground-bounce in slots near the end. There's a whole zoo of
hardware/firmware bugs that we've had to painfully crawl through and
fix. That's why the IBM boxes cost big $$$; here's to hoping that 
customers understand why.

> This feature allowed us to track nodes that were having parity problems, but we had
> no METER to know it.
> 
> Recovery is a good thing, BUT how do you know you having LOTS of errors/recovery events? You need
> a meter. EDAC provides that METER

I'm lazy. What source code should I be looking at?  I'm concerned about
duplication of function and proliferation of interfaces. I've got my 
metering data under (for example)
/sys/bus/pci/devices/0001:c0:01.0/eeh_*, mostly very arch specific.
The code for this is in arch/powerpc/platforms/pseries/eeh_sysfs.c

> I met with Yanmin Zhang of Intel at OLS after his paper presentation on PCI Express Advanced Error
> Reporting in the Kernel, and we talked about this same thing. I am talking with him on having the
> recovery code present information into EDAC sysfs area. (hopefully, anyway)

Hmm. OK, where's that?  Back when, I'd talked to Yamin about coming up 
with a generic, arch-indep way of driving the recovery routines. But
this wasn't exactly easy, and we were still grappling with just getting
things working.  Now that things are working, its time to broaden
horizons.

Can you point me to the current edac code?
find . -print |grep edac is not particuarly revealing at the moment.

> The recovery generates log messages BUT having to periodically 'grep' the log file looking for
> errors is not a good use of CPU cycles. grep once for a count and then grep later for a count and
> then compare the counts for a delta count per unit time. ugly.

Yep. Maybe send events up to udev?

> The EDAC solution is to be able to have a Listener thread in user space that can be notified (via
> poll()) that an event has occurred.

Hmm. OK, I'm alarmingly nave about udev, but my initial gut instinct is
to pipe all such events to udev. Most of user-space has already been
given the marching orders to use udev and/or hal for this kind of stuff.
So this makes sense to me.

> There are more than one consumer (error recover) of error events:
> 1) driver recovery after a transaction (which is the recovery consumer above)

I had to argue loudly for recovery in the kernel. The problem was that
it was impossible to recover erros on scsi devics from userspace (since
the block device and filesystems would go bonkers).

> 2) Management agents for health of a node
> 3) Maintainance agents for predictive component replacement

Yes, agreed. Care to ask your management agent friends for where they'd
like to get these events from (i.e. udev, or somewhere else?)

> We have MEMORY (edac_mc) devices for chipsets now, but via the new edac_device class, such things
> as ECC error tracking on DMA error checkers, FABRIC switchs, L1 and L2 cache ECC events, core CPU
> data ECC checkers, etc can be done. I have an out of kernel tree MIPS driver do just this. Other
> types of harvesters can be generated as well for other and/or new hardware error detectors.

Ohh. I've got hardware tha does this, but its not currently usng EDAC.
There must be some edac mailing list I'm not subscribed to??

--linas

