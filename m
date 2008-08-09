From: Pavel Machek <pavel@suse.cz>
Subject: Re: tools support for non-512 byte sector sizes
Date: Sat, 9 Aug 2008 15:21:44 +0200
Message-ID: <20080809132144.GB13169@ucw.cz>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net> <20080730135147.GA4513@auslistsprd01.us.dell.com> <87zlnzb8ce.fsf@rho.meyering.net> <20080730172922.GA20191@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3679 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754333AbYHJUC4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2008 16:02:56 -0400
Content-Disposition: inline
In-Reply-To: <20080730172922.GA20191@auslistsprd01.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Jim Meyering <jim@meyering.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>

Hi!

> >   - some disk makers have sort of agreed not to do that, and
> >       expect forever to hide the larger underlying sector size
> >       behind a virtual 512 (of course, this imposes alignment
> >       restrictions, but that's a smaller problem)
> 
> yes, this is happening also.
> 
> There will be 3 types of disks eventually:
> 1) those that report a 512-byte sector size, and are really a 512-byte
>    size.  This is nearly all disks today.
> 
> 2) those that report a 512-byte sector size, but are really a
>    4096-byte size, and the drive does the conversions and
>    read/modify/write.  T10 and T13 are looking to add commands to
>    expose this different underlying physical sector size so the OS
>    could be aware of it.  This is primarily being driven to mitigate
>    any problems that may happen with "legacy" OSs that are not aware
>    of the difference.

How is this going to work with journaling? This has nasty property
that if you are writing to sector n during powerfail, disk may also
kill sectors n-3, n-2 and n-1..... and that's bad right?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
