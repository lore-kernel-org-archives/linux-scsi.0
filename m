From: Matthew Wilcox <willy@debian.org>
Subject: Re: U160 on sym53c8xx very slow
Date: Mon, 20 Oct 2003 14:32:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031020133218.GK18370@parcelfarce.linux.theplanet.co.uk>
References: <pan.2003.10.20.13.02.47.426779@mandrakesoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39382 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262570AbTJTNcT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 09:32:19 -0400
Content-Disposition: inline
In-Reply-To: <pan.2003.10.20.13.02.47.426779@mandrakesoft.com>
List-Id: linux-scsi@vger.kernel.org
To: nico <nico@mandrakesoft.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 20, 2003 at 03:02:47PM +0200, nico wrote:
> I have very poor performance with my Ultra160 disks (fujitsu MAN3184MP,
> 10000rpms).
> When I copy a reasonably large (500MB) file from /dev/sda2 to /dev/sda3,
> it copies at a rate of 10-20 MB/sec maximum.
> I was expecting better troughput.
> 
> Here is the result of a dmesg:

(Thanks for the dmesg, this is exactly what you needed to report).

> sym0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 31)

Here's the problem.  For some reason, your 160MB/s disc and 160MB/s
controller have only managed to negotiate 40MB/s between them.

You're copying from sda2 to sda3, so you should get approx half of that
-- 20MB/s which fits with your report (reductions from there would be
due to head seeks and so on).

> Something wrong with my configuration? Is it a setting of my adapter
> (Tekram DC-390-U3W) that is wrong? Should I plug it on another pci slot?
> Else?

I think PCI slot is very unlikely.  Try a shorter SCSI cable, perhaps.

BTW, looking at
http://www.fujitsu.com/support/computing/storage/hdd/eol/ehdd/man3-catalog.html
shows you can only expect a maximum of 40MB/s in your test:

Data transfer rate 	To/from media	52.0 to 84.1 MB/s
			To/from host	160 MB/s

We need to try to figure out why you only get half that though.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
