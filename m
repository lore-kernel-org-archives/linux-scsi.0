From: Chris Webb <chris@arachsys.com>
Subject: Re: MD/RAID time out writing superblock
Date: Thu, 17 Sep 2009 12:57:28 +0100
Message-ID: <20090917115728.GA13854@arachsys.com>
References: <19121.33823.893569.486518@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:55083 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009AbZIQL6Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 07:58:25 -0400
Content-Disposition: inline
In-Reply-To: <19121.33823.893569.486518@notabene.brown>
 <4AB17905.90606@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Neil Brown <neilb@suse.de>
Cc: Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>

Tejun Heo <tj@kernel.org> writes:

> The most common cause for FLUSH timeout has been power related issues.
> This problem becomes more pronounced in RAID configurations because
> FLUSHes end up being issued to all drives in the array simultaneously
> causing concurrent power spikes from the drives.  When proper barrier
> was introduced to md earlier this year, I got two separate reports
> where brief voltage drops caused by simultaneous FLUSHes led to drives
> powering off briefly and losing data in its buffer leading to data
> corruption.  People always think their PSUs are good because they are
> rated high wattage and bear hefty price tag but many people reporting
> problems which end up being diagnosed as power problem have these
> fancy PSUs.

Hi Tejun. This sounds very plausible as a diagnosis. Six drives hanging off the
single power supply is that maximum that can be fitted in this Supermicro
chassis, and we have 32GB of RAM and two 4-core Xeon processors in there too,
so we could well be right at the limit for the rating of the power supply.

> So, if your machines share the same configuration, the first thing I'll do
> would be to prepare a separate PSU, power it up and connect half of the
> drives including what used to be the offending one to it and see whether
> the failure pattern changes.

It's quite hard for us to do this with these machines as we have them managed
by a third party in a datacentre to which we don't have physical access.
However, I could very easily get an extra 'test' machine built in there,
generate a work load that consistently reproduces the problems on the six
drives, and then retry with an array build from 5, 4, 3 and 2 drives
successively, taking out the unused drives from chassis, to see if reducing the
load on the power supply with a smaller array helps.

When I try to write a test case, would it be worth me trying to reproduce
without md in the loop, e.g. do 6-way simultaneous random-seek+write+sync
continuously, or is it better to rely on md's barrier support and just do
random-seek+write via md? Is there a standard work pattern/write size that
would be particularly likely to provoke power overload problems on drives?

Neil Brown <neilb@suse.de> writes:

> [Chris Webb <chris@arachsys.com> wrote:]
>
> > 'cat /proc/mdstat' sometimes hangs before returning during normal
> > operation, although most of the time it is fine. We have seen hangs of
> > up to 15-20 seconds during resync. Might this be a less severe example
> > of the lock-up which causes a timeout and reset after 30 seconds?
>
> "cat /proc/mdstat" should only hang if the mddev reconfig_mutex is
> held for an extended period of time.
> The reconfig_mutex is held while superblocks are being written.
> 
> So yes, an extended device timeout while updating the md superblock
> can cause "cat /proc/mdstat" to hang for the duration of the timeout.

Thanks Neil. This implies that when we see these fifteen second hangs reading
/proc/mdstat without write errors, there are genuinely successful superblock
writes which are taking fifteen seconds to complete, presumably corresponding
to flushes which complete but take a full 15s to do so.

Would such very slow (but ultimately successful) flushes be consistent with the
theory of power supply issues affecting the drives? It feels like the 30s
timeouts on flush could be just a more severe version of the 15s very slow
flushes.

Tejun Heo <tj@kernel.org> writes:

> > Some of these timeouts also leave us with a completely dead drive,
> > and we need to reboot the machine before it can be accessed
> > again. (Hot plugging it out and back in again isn't sufficient to
> > bring it back to life, so maybe a controller problem, although other
> > drives on the same controller stay alive?) An example is [2].
> 
> Ports behave mostly independently and it sure is possible that one
> port locks up while others operate fine.  I've never seen such
> incidents reported for intel ahci's tho.  If you hot unplug and then
> replug the drive, what does the kernel say?

We've only tried this once, and on that occasion there was nothing in the
kernel log at all. (I actually telephoned the data centre engineer to ask when
he was going to do it for us because I didn't see any messages, and it turned
out he already had!)

Cheers,

Chris.
