From: "Scott M. Ferris" <sferris@acm.org>
Subject: Re: SAS overview
Date: Sun, 28 Mar 2004 16:06:32 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040328220632.ADD8D76C4F@isis.visi.com>
References: <40664024.2070700@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from conn.mc.mpls.visi.com ([208.42.156.2]:9931 "EHLO
	conn.mc.mpls.visi.com") by vger.kernel.org with ESMTP
	id S262399AbUC1WGe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Mar 2004 17:06:34 -0500
In-Reply-To: <40664024.2070700@torque.net> from Douglas Gilbert at "Mar 27, 2004
 10:07:41 pm"
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "Scott M. Ferris" <sferris@acm.org>, Matthew Wilcox <willy@debian.org>, linux-scsi <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
>
> Whether two phys on a SAS HBA are two separate SCSI initiators or
> one initiator on a wide link depends on what those phys are attached
> to. 

Right.  To handle wide ports, the HBA firmware/hardware is going to
need access to information flowing over all of the phys in the wide
port, which is why I expect that all of the phys that could be part of
a wide port will be connected to the same PCI function, rather than
one PCI function per phy.

> That seems pretty dynamic so it seems to me the HBA driver needs
> to look at phys individually. 

For some things, such as phy link resets and hard resets, phy link
speed configuration, etc, the HBA driver will need to address
individual phys, so there will have to be some way of doing that,
probably by phy number to mimic the way expanders work.

For issuing commands, I'd expect that the HBA firmware interface won't
normally specify particular phys, precisely because it should be
dynamic in order to take advantage of wide ports.  To minimize the
command latency, you want the HBA to issue the next command on any
available phy of a wide port.  You don't want a command to wait for a
connection on phy 0 to finish when phys 1-3 are available immediately.
That kind of low-level routing really needs to be in the HBA firmware
or hardware in order to be dynamic enough.  Any information the HBA
driver has on phy utilization may be out of date by the time a
particular command makes it to the head of the queue in the HBA
firmware.

> So if the phys are not separate PCI devices then they at least need
> to be individually addressable (and the SAS address isn't going to
> help since it's the same for all HBA phys). 

I think we agree that for some functions the phys will have to be
individually addressable.  SAS addresses are only useful to specify
the other end of connection, independent of phy path.

> At the moment for SPI PCI HBAs sysfs has a one to one link between a
> PCI device and a SCSI host.  Such sysfs links might look a little
> different in the presene of SAS wide links.

That might not have to change, depending on how the HBA interfaces are
designed.  A SAS HBA can have a variable number of initiator ports for
each PCI function, depending on whether the ports are cabled wide or
narrow.  That could be modeled as one channel for each initiator port
if the HBA exposes the ports, or just one channel if the HBA interface
doesn't expose the ports.

Which ports to collect into the same host structure will depend on the
granularity a host_reset() can operate at (since a reset/reboot of the
HBA firmware may clobber more than one port).  That's usually pretty
apparent once the HBA documentation is available.

Another factor is whether there are any global limitations on the
total number of commands the HBA firmware can accept.  There may need
to be limits on the number of commands per initiator port as well per
HBA, which may or may not fit into the current Linux concept of a
channel, though it wouldn't be hard to check port limits in the
low-level driver's queuecommand() if that doesn't get enforced at
higher levels of the Linux SCSI stack.

> Knowing the physical components (cables) that make up a wide link
> seems important IMO. It's possible to incorrectly "wire" a SAS
> domain so it might be useful to point out which cable(s) (by
> identifying the phys at either end) is inappropriate. Also the
> "unit" of routing in a SAS expander is the phy.

Knowledge of the phy topology would certainly be useful for
troubleshooting.  I'd expect a SAS HBA to have some way of reporting
some or all of the information it discovered when it scanned the SAS
domain, but that's a quality of implementation issue.

> SAS has a protocol stack and it is connection-oriented towards the
> top of that stack. IMO its important to know what is going on at
> the lower levels as well.

Sometimes yes, but usually no.  Or at least I'm not used to getting
much information about the lower level details from the SCSI HBAs I've
worked with.  I've usually needed an analyzer to tell me what was
really going wrong at the lower levels.

For troubleshooting any information you can get from the HBA is nice.
It's a question of how much low-level info the HBA vendor is willing
to provide.  Some information may be unavailable, either because the
ASICs don't expose it to the HBA firmware, or because the firmware
doesn't expose it to the HBA driver.

For the fast path of queueing and completing commands, I'd expect SAS
HBAs to work similar to SPI HBAs, where all the HBA driver does is
queue commands with data buffers, and wait for an interrupt to
indicate that one or more commands have completed.  For performance,
the HBA needs to manage the entire lifetime of the command, and DMA
data back and forth without needing intervention by the HBA driver.

Perhaps I'm just misunderstanding what kinds of control and diagnostic
information you're hoping to get from the lower levels.

-- 
Scott M. Ferris,
sferris@acm.org 
