From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: tools support for non-512 byte sector sizes
Date: Wed, 30 Jul 2008 12:29:22 -0500
Message-ID: <20080730172922.GA20191@auslistsprd01.us.dell.com>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net> <20080730135147.GA4513@auslistsprd01.us.dell.com> <87zlnzb8ce.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:33560 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbYG3R3Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 13:29:24 -0400
Content-Disposition: inline
In-Reply-To: <87zlnzb8ce.fsf@rho.meyering.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>

On Wed, Jul 30, 2008 at 07:16:49PM +0200, Jim Meyering wrote:
> Matt Domsch <Matt_Domsch@dell.com> wrote:
> > On Tue, Jul 29, 2008 at 02:48:31PM -0400, Martin K. Petersen wrote:
> ...
> >> Just yesterday I received a couple of prototype drives in the mail.
> >> I'll ask the vendor whether they support 4KB and if so I'll give them
> >> a whirl.
> >
> > I have access to disks with native 4KB sectors now too.  Would
> 
> Do they expose that sector size?
> I.e., does ioctl(fd,BLKSSZGET,&ss) set ss to 4096?

yes.
 
> I'm interested because I'm preparing GNU Parted's partition table
> manipulation code (not its FS code) for just that.
> In particular, now I've heard two stories:
> 
>   - disk makers will eventually sell drives with >512-byte sectors

yes
 
>   - some disk makers have sort of agreed not to do that, and
>       expect forever to hide the larger underlying sector size
>       behind a virtual 512 (of course, this imposes alignment
>       restrictions, but that's a smaller problem)

yes, this is happening also.

There will be 3 types of disks eventually:
1) those that report a 512-byte sector size, and are really a 512-byte
   size.  This is nearly all disks today.

2) those that report a 512-byte sector size, but are really a
   4096-byte size, and the drive does the conversions and
   read/modify/write.  T10 and T13 are looking to add commands to
   expose this different underlying physical sector size so the OS
   could be aware of it.  This is primarily being driven to mitigate
   any problems that may happen with "legacy" OSs that are not aware
   of the difference.

3) those that report a 4096-byte sector size, and are really a
   4096-byte size.  This seems ideal for aware OSs.

Which of 2) or 3) hit the market in mass remains to be seen.  I want
Linux to be able to handle either painlessly.


-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
