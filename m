From: rct@frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 7 Dec 2007 16:39:08 -0600 (CST)
Message-ID: <20071207223908.4D1F9DBA2@gherkin.frus.com>
References: <1197062383.5483.46.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:39295 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbXLGWjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 17:39:14 -0500
In-Reply-To: <1197062383.5483.46.camel@lov.site> "from Kay Sievers at Dec 7,
 2007 10:19:43 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael Cree <mcree@orcon.net.nz>, Bob Tracy <rct@frus.com>, Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com

Kay Sievers wrote:
> Yeah, that looks all fine.
> 
> What distro is that, and what's the udev version?

Mine is Debian Etch, normally with the latest released or -rcX kernel
from kernel.org.  Updates current as of about 18 hours ago.  Udev
package version is 0.105-4.  The RELEASE-NOTES file in /usr/share/doc/udev
says "udev 105".

> You are booting your kernel with an initramfs?

Not in my case: everything I need at boot time is built-in.

> Is the udev daemon (still) running while it fails?
> 
> If you run /sbin/udevtrigger, do the nodes appear?

I can answer the above later when I'm back in front of the machine, but
even in the "not good" case, I still see the following messages from
the /etc/rcS.d/S03udev file:

	Starting the hotplug events dispatcher udevd.
	Synthesizing the initial hotplug events.

This is where udevtrigger gets called, followed by the load_input_modules
and create_dev_makedev functions, then...

	Waiting for /dev to be fully populated.

which is where udevsettle gets called.

None of the above appear to be exiting abnormally for the bad case, but
I'll definitely take a closer look at what MAKEDEV (/dev/MAKEDEV -->
/sbin/MAKEDEV) is doing.  In particular, Debian MAKEDEV is looking at
/proc/devices to decide what to do, so maybe "cat /proc/devices" would
be useful to look at for the broken case.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
