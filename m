From: Tejun Heo <htejun@gmail.com>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Date: Tue, 15 May 2007 15:47:27 +0200
Message-ID: <4649B9EF.1070605@gmail.com>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca> <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com> <463B858E.6060002@cfl.rr.com> <463B99EE.2090001@gmail.com> <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com> <46489D3B.8050805@gmail.com> <e5ab0f710705141346o45ac8721jacbcb753f9d45406@mail.gmail.com> <20070515131632.GC16673@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.235]:37242 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbXEONsM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 09:48:12 -0400
Received: by nz-out-0506.google.com with SMTP id r28so146510nza
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2007 06:48:11 -0700 (PDT)
In-Reply-To: <20070515131632.GC16673@khazad-dum.debian.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@debian.org>
Cc: Francesco Pretto <ceztko@gmail.com>, Phillip Susi <psusi@cfl.rr.com>, linux-kernel <linux-kernel@vger.kernel.org>, pkg-sysvinit-devel@lists.alioth.debian.org, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>

Hello, Henrique.

Henrique de Moraes Holschuh wrote:
> On Mon, 14 May 2007, Francesco Pretto wrote:
>> Ubuntu [1] ang Gentoo [2] bugs opened. Sent a mail to Miquel van
>> Smoorenburg, dev  of sysvinit.
> 
> For all Debian sysvinit issues, please send email to
> pkg-sysvinit-devel@lists.alioth.debian.org (added to CC).
> 
> For the Debian sysvinit crew: Guys, have a look at
> http://linux-ata.org/shutdown.html.  We need to act on it, and also file a
> bug on all of our current kernels (poweroff causes minor but accumulating-
> over-time damage to all hardware under control of libata).  This is really
> something we should be trying to fix on our 2.6.18 kernels and stable
> sysvinit.
> 
>> [1] https://bugs.launchpad.net/upstart/+bug/114683
>> [2] http://bugs.gentoo.org/show_bug.cgi?id=178559

There have been further developments,

	http://article.gmane.org/gmane.linux.ide/18823	(bugfix)
	http://article.gmane.org/gmane.linux.ide/18846	(in discussion)

The second patch makes libata turn off the warning message and just
issue STANDBYNOW without userland modification, iff userland
halt/shutdown doesn't issue STANDBYNOW during shutdown.  I'm not sure
whether this will be accepted or not.  It makes the change much less
intrusive for distros which don't issue STANDBYNOW from userland but
disks will always do emergency-unload on all kernels with this problem.

> Tejun, am I right to assume that any servers with self-contained SCSI disks
> (i.e. that are not plugged into externally powered drive enclosures, etc)
> also get the emergency head unloads when they are powered off?

AFAIK, yes, all SCSI disks attached to a single host and shares power
on/off status will do emergency unload on poweroff.  In the updated
kernel, this is controlled by the following sysfs node.

 /sys/class/scsi_disk/h:c:i:l/manage_start_stop.

It defaults to 1 for libata devices and 0 for all others.  Echoing 1 to
it makes the sd driver spindown the device on suspend to ram/disk and
poweroff.

-- 
tejun
