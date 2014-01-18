From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 22:18:23 -0500
Message-ID: <52D9F27F.8060705@ubuntu.com>
References: <20140116220409.GA1183@linux.intel.com>	<Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org>	<CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>	<52D9976C.2010009@ubuntu.com> <CAPcyv4iJScXxpAzH99m6VNHv=vM+96KWgfmv-FH+McnCMb5Vfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:49948 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaARDSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 22:18:25 -0500
In-Reply-To: <CAPcyv4iJScXxpAzH99m6VNHv=vM+96KWgfmv-FH+McnCMb5Vfg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/17/2014 05:17 PM, Dan Williams wrote:
> Well, "at all" is overstating it.  The system was idle and now
> it's being woken up to do some work.  Inactivity timers are
> invalidated and now the decision becomes minimize access latency,
> or lazily wake up.

Sure, but that work may or may not involve disk access.  Think of a
laptop you are using to watch a video on youtube.  You need to get up
for a minute so you suspend, come back, and continue watching... no
need for disk IO just because you paused for a few minutes.  For a
single disk system you may argue that it is likely the disk will be
needed, but for multiple disk systems, that probability goes down.

>> It puts needless wear and tear on disks.
> 
> I'm not sure spin up cycles are predictive of drive failure?

Drive makers rate them to handle only so many start/stop cycles before
they fail, which is why SMART keeps track of the count.  Any time you
move mechanical parts, they wear out.

> I'm not arguing about the attach rate of HDDs in shipping systems,
> I'm asking what is the system suspend / resume frequency of such
> systems and is it worth carrying that complexity in the kernel and
> injecting unnecessary resume latency for what amounts to a niche
> use case.

It doesn't add any latency for an SSD, or even an ATA HDD that does
not have PuiS enabled.  SCSI disks are more likely to be in larger
systems where it is more likely that at least some of the drives won't
be accessed soon, and if you really want to avoid the latency, then
you can configure your user space pm scripts to disable runtime pm
prior to suspend to get the old behavior back.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJS2fJ/AAoJEI5FoCIzSKrwA+MH/jRP5zLyhA9RV7PICwP8LO8j
x9+p/I/WVdduMJnqxMQOX6TE9nWbsTHrCBxgI/MiUmQeiYnTTU8VTaOjLosJ5K+j
tu01bFZ2VNLQmv2ND9U0OAvf4drIqxEtyucZ4MgXwKYxUP3VRs19R26ns9LlOstD
YsxloBVF0Fm+q7LWIH3piiLJGpie/e7e7J3c7FGwtPItTFy8cDSOAMdtvbXpfE+N
M82TP+egl3DFwQ2dMhXBwwSh0MzXb/6/OCZZcl7rMf/G62sdrIG5onv0CRDHvcoF
t0Lz9HjQtHL5d59pTu2t7kkz7VjOfTHsp+hRTNWZNNFxK95ULMW+JEc/q53H9gY=
=y+KW
-----END PGP SIGNATURE-----
