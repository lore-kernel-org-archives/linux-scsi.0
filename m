From: David.Egolf@Bull.com
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 06:25:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF09039075.A80B9FF6-ON07256E47.0047EBD3-07256E47.0049C1CD@az05.bull.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lionfish.bull.com ([141.112.4.90]:42914 "EHLO
	lionfish.az05.bull.com") by vger.kernel.org with ESMTP
	id S262855AbUB0NZz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 08:25:55 -0500
Received: from us-phx1.az05.bull.com (us-phx1.az05.bull.com [141.112.40.1])
	by lionfish.az05.bull.com (8.12.10/8.12.10) with ESMTP id i1RDPsXX007795
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2004 06:25:54 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


On Fri, 2004-02-27 at 02:04, Ben Collins wrote:
> On Thu, Feb 26, 2004 at 04:56:01PM -0800, Matthew Dharm wrote:
> > My only concern with something like this is the userspace race problem.
> > i.e the following sequence of events:
> >
> > (1) User uses cdrecord -scanbus to locate their device
(host:bus:dev:lun)
> > (2) HBA is disconnected
> > (3) New HBA is added
> > (4) User issues command to host:bus:dev:lun, and addresses the wrong
device
> >
> > While the current system doesn't prevent this, it makes it a much more
> > difficult situation to happen.
>
> Surely the user would have to have known that one device was
> disconnected and another connected. Same thing could already be said for
> the scsi device allocation (sda, sdb, and sg0, sg1, sg2, etc...).

An administrator should certainly know when devices are connected or
disconnected.  Unfortunately, failed devices can behave as if they were
disconnected.  I agree that the same thing could be said for scsi device
allocation.  It is also a problem there.  It happens to be a problem with
ethernet interfaces, as well.

We have systems with lots of HBA's and lots of redundant paths.  If the
names remain invariant, then we could continue to boot correctly and run
our applications.

On our legacy mainframes, the physical configuration is explicitly declared
by the administrator in a configuration map.  The software probes
components based on this map and simply skips over the components which are
not present or not responding, but the names remain invariant.  An added
advantage is that the OS is informed which of the visible hardware
components belong to it.  We do not have to resort to hardware fencing or
zoning strategies.  A third advantage to an explicit configuration is that
the OS, when it boots, can inform the administrator of discrepancies from
what was expected.  In a complex configuration it serves as a check on the
physical configuration.

When an OS, such as Linux, elects to "discover" the configuration and
assigns names as it finds components, then it is very difficult to maintain
a large configuration.  If the 12th component (of any type) out of 37 does
not respond, then all the components beginning at the 13th suddenly have
different names.



