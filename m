From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [sym2] Re: Problem with 2.6.14 and up...
Date: Wed, 23 Nov 2005 09:43:42 -0700
Message-ID: <20051123164342.GV1598@parisc-linux.org>
References: <20051123134327.GS1598@parisc-linux.org> <20051123143508.GT1598@parisc-linux.org> <200511231723.45088.jsanchez@todounix.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:18844 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932071AbVKWQnp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 11:43:45 -0500
Content-Disposition: inline
In-Reply-To: <200511231723.45088.jsanchez@todounix.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jos? Luis S?nchez <jsanchez@todounix.homeip.net>
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 23, 2005 at 05:23:44PM +0100, Jos? Luis S?nchez wrote:
> El Mi?rcoles, 23 de Noviembre de 2005 15:35, Matthew Wilcox escribi?:
> > On Wed, Nov 23, 2005 at 06:43:27AM -0700, Matthew Wilcox wrote:
> > > 2. Can you try a later kernel?  If you have git, you can pull from
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/willy/sym2.git
> > >    otherwise http://www.parisc-linux.org/~willy/sym2-2.2.2.diff applies
> > >    to a 2.6.15-rc1 kernel.
> >
> > I also noticed that akpm put out 2.6.15-rc2-mm1 today which includes the
> > sym2 patches, so you could try that instead.
> 
> I've tried the patch in a 2.6.15-rc2 (patched OK) with the same result, a bus 
> reset and a bunch of "phase change..." messages. Any probe what I can try to 
> stress the driver?

Hmm.  Not sure at this point.  Let me think about it for a bit.

> Another minor glitch never reported is what the device id 5 is a DDS-4 DAT, 
> with a UW interface. But the driver reports a synchronous speed of 20 MB/sec, 
> I don't know why...
> In Solaris 10 x86 this DAT works very well at 40 MB/sec. This problem exists 
> from all the 2.4 kernel series.

Seems to me that it's not negotiating wide, for some reason.
	cat /sys/class/spi_transport/target0:0:5/width
(should be 0)
Then try
	echo 1 >/sys/class/spi_transport/target0:0:5/width

You'll then have to get it to perform some IO to the device -- an
'mt status' should do the trick.
