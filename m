From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: [PATCH/RESEND v2 0/2] SATA disk resume time optimization
Date: Mon, 11 Nov 2013 08:59:20 -0800
Message-ID: <20131111165920.GA25366@linux.intel.com>
References: <20131017193331.GA11747@linux.intel.com>
 <527AF287.7020700@ubuntu.com>
 <20131109012023.GA8978@linux.intel.com>
 <527EA218.6010604@ubuntu.com>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10609 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab3KKQ7r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Nov 2013 11:59:47 -0500
Content-Disposition: inline
In-Reply-To: <527EA218.6010604@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org, JBottomley@parallels.com

500ms is actually quite alot when you compare it with android or iOS,
or even with other subsystems like USB. USB is the second worst offender 
after SATA disks and it tends to take around 600ms for most standard 
systems with an onboard webcam, and with other devices plugged in ever 
longer. I think we should optimize out every millisecond we can.

You mentioned that you tuned your system to remove all cases that trigger
non-essential disk wakeups, and that works great for you, but it won't 
help anyone using fedora or OpenSUSE or Yocto, etc. And even if you
could formallize your changes to Ubuntu to create a fully optimized 
user space, you're still at the mercy of the user's install choices, which
can quickly throw a wrench in the works.

On Sat, Nov 09, 2013 at 03:59:04PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> On 11/08/2013 08:20 PM, Todd E Brandt wrote:
> > I tested your patches and they do function. We tried a similar
> > approach a few months back where instead of waking the scsi disks
> > we just set them all to runtime_suspended and skipped the resume.
> > Then we let them be awakened later by read/write access just as you
> > have. It's a really tempting approach, in theory, since you're
> > saving both time and power by only waking those disks you know you
> > need. But in practice I've found that userspace doesn't play nice.
> 
> I've just about gotten rid of all instances of user space waking the
> disks on my system.  The one I have left to do is to fake the IDENTIFY
> DEVICE command using the cached identity info to satisfy a script that
> tries to set the APM mode of the disk after resume.  If I disable that
> script, my extra disks stay asleep and Xwindows fires up nice and fast.
> 
> > In my experience the user layer almost always manages to wake up
> > every mounted disk after resume, even if you didn't deliberately
> > use them prior to suspend. The accesses can come from the file
> > manager doing a scan after resume, or from any number of apps
> > running on the system that decide they need to get even the
> > smallest piece of information from the disks. A simple space check
> > will wake them up.
> 
> By simple space check I assume you mean df?  The superblocks easily
> fit in the cache so that shouldn't generate any IO.
> 
> > Thus when you leave all the disks stopped, user space ends up
> > triggering a traffic jam when the OS wakes back up, which makes
> > disk access take even longer.
> > 
> > My patch works very similarly to yours but just triggers an
> > asynchronous wakeup to all the disks in anticipation of userspace's
> > needs. We've tested it pretty heavily on ubuntu machines of all
> > types and it's done well.
> 
> I don't think the wakeup is needed since ( ata ) disks normally wake
> up on their own unless you enable power up in standby and pro-actively
> initiating the wakeup only buys you maybe 500ms or less?  What is that
> compared to a typical 10 second startup time?
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.14 (GNU/Linux)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBCgAGBQJSfqIUAAoJEJrBOlT6nu75v3sH/R374d/Sgx3DB0DVGgDch3jA
> ZlR4eb5x5umw2CApGE0jbbj91/330Z5uxgr76tn6/nSRftDJ5ZgLc6dBTF1VwX4q
> fqxKgNY1euIARiCL4jLxiK9JfX7hB0GtknJaMRvG4JHaSP4d0Cvhr0sbd5mpmJp7
> P0TMVslJJHyIFVk0QjvisDBcFgo1onBkbVnX6B5Z6mPZXhAd+WCA3CJfiHnAK7t+
> mINmlTBXnZQFXLXY2rDrmZEUCLFfTqtlprkAuGdlfXsMVYBTD31notuZ74Xbv7C7
> vBJLiQ6b7dyF8eqcHoc49qqNO1n38nhRmYhIOSYgsyRFhECjVms5/mfEj9UBkiY=
> =iDTY
> -----END PGP SIGNATURE-----
