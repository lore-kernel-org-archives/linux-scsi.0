From: Jim Meyering <jim@meyering.net>
Subject: Re: tools support for non-512 byte sector sizes
Date: Wed, 30 Jul 2008 19:16:49 +0200
Message-ID: <87zlnzb8ce.fsf@rho.meyering.net>
References: <488F524F.6020905@redhat.com>
	<20080729182611.GB24924@parisc-linux.org>
	<1217356645.6103.48.camel@localhost.localdomain>
	<yq13alsr0g0.fsf@sermon.lab.mkp.net>
	<20080730135147.GA4513@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2-g19.free.fr ([212.27.42.28]:41953 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbYG3RQv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 13:16:51 -0400
In-Reply-To: <20080730135147.GA4513@auslistsprd01.us.dell.com> (Matt Domsch's
	message of "Wed, 30 Jul 2008 08:51:47 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>

Matt Domsch <Matt_Domsch@dell.com> wrote:
> On Tue, Jul 29, 2008 at 02:48:31PM -0400, Martin K. Petersen wrote:
...
>> Just yesterday I received a couple of prototype drives in the mail.
>> I'll ask the vendor whether they support 4KB and if so I'll give them
>> a whirl.
>
> I have access to disks with native 4KB sectors now too.  Would

Do they expose that sector size?
I.e., does ioctl(fd,BLKSSZGET,&ss) set ss to 4096?

I'm interested because I'm preparing GNU Parted's partition table
manipulation code (not its FS code) for just that.
In particular, now I've heard two stories:

  - disk makers will eventually sell drives with >512-byte sectors

  - some disk makers have sort of agreed not to do that, and
      expect forever to hide the larger underlying sector size
      behind a virtual 512 (of course, this imposes alignment
      restrictions, but that's a smaller problem)

Even if the latter is the case, we still have to deal with
optical and flash, both of which can already have larger sectors.

> interested parties be willing to share test plans, so we could be sure
> we have coverage wrt correctness: kernel internals, userspace tools like parted,
> fdisk, kpartx, apps using O_DIRECT)?  Benchmarking winds up being an
> NDA activity this early in the game so I don't want the focus of any
> joint work to be benchmarks yet.

Speaking of O_DIRECT, both dd and shred (both in coreutils), use
O_DIRECT, so you could get _some_ coverage just by running shred
and experimenting with dd's oflag=direct and iflag=direct options.
