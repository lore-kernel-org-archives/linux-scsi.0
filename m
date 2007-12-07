From: rct@frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 7 Dec 2007 13:36:30 -0600 (CST)
Message-ID: <20071207193630.A3145DBA2@gherkin.frus.com>
References: <1197051572.3599.10.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:39091 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbXLGTgh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 14:36:37 -0500
In-Reply-To: <1197051572.3599.10.camel@lov.site> "from Kay Sievers at Dec 7,
 2007 07:19:32 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bob Tracy <rct@frus.com>, Andrew Morton <akpm@linux-foundation.org>, mcree@orcon.net.nz, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com

Kay Sievers wrote:
> On Fri, 2007-12-07 at 19:06 +0100, Ingo Molnar wrote:
> > i'm not sure how to do direct debugging on udev, so i can only guess 
> > about what effect on the kernel side could have caused this. One bad 
> > hack would be to "probe" udevd's behavior by changing the NET_TR entry 
> > in various ways:
> > 
> >   "tr" -> "token-ring"         # breaks
> >   "tr" -> "tr"                 # works
> >   "tr" -> "token-rin0"         # ?            (1)
> >   "tr" -> "TR"                 # ?            (2)
> > 
> > the question is, does tweak (1) and tweak (2) work or break?
> > 
> > but it would be a lot more effective i guess to get some udevd expert's 
> > attention on this ...
> 
> Could we get the output of:
>   ls -l /sys/block/sda/
> and:
>   grep . /sys/block/sda/*/dev
> ?

Here are the requested items for the 2.6.24-rc2-g6f37ac79-dirty kernel
(the working one with the sysctl_check.c patch reverted):

smirkin:/# ls -l /sys/block/sda
total 0
-r--r--r-- 1 root root 8192 Dec  7 08:36 capability
-r--r--r-- 1 root root 8192 Dec  7 08:36 dev
lrwxrwxrwx 1 root root    0 Dec  7 08:36 device -> ../../devices/pci0000:00/0000:00:14.0/0000:01:09.0/host0/target0:0:0/0:0:0:0
drwxr-xr-x 2 root root    0 Dec  7 08:36 holders
drwxr-xr-x 3 root root    0 Dec  7 08:36 queue
-r--r--r-- 1 root root 8192 Dec  7 08:36 range
-r--r--r-- 1 root root 8192 Dec  7 08:36 removable
drwxr-xr-x 3 root root    0 Dec  7 08:36 sda1
drwxr-xr-x 3 root root    0 Dec  7 08:36 sda2
drwxr-xr-x 3 root root    0 Dec  7 08:36 sda3
drwxr-xr-x 3 root root    0 Dec  7 08:36 sda4
drwxr-xr-x 3 root root    0 Dec  7 08:36 sda5
drwxr-xr-x 3 root root    0 Dec  7 08:36 sda6
drwxr-xr-x 3 root root    0 Dec  7 08:36 sda7
-r--r--r-- 1 root root 8192 Dec  7 08:36 size
drwxr-xr-x 2 root root    0 Dec  7 08:36 slaves
-r--r--r-- 1 root root 8192 Dec  7 08:36 stat
lrwxrwxrwx 1 root root    0 Dec  7 08:36 subsystem -> ../../block
--w------- 1 root root 8192 Dec  7 08:36 uevent
smirkin:/# grep . /sys/block/sda/*/dev
/sys/block/sda/sda1/dev:8:1
/sys/block/sda/sda2/dev:8:2
/sys/block/sda/sda3/dev:8:3
/sys/block/sda/sda4/dev:8:4
/sys/block/sda/sda5/dev:8:5
/sys/block/sda/sda6/dev:8:6
/sys/block/sda/sda7/dev:8:7

Assuming /sys/block even exists for the non-working case, I'll forward
that info in a few hours when I can get home to reboot the machine.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
