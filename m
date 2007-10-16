From: Theodore Tso <tytso@mit.edu>
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 16:34:49 -0400
Message-ID: <20071016203449.GA1314@closure.lan>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net> <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de> <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm> <20071016111911.30a18e12@the-village.bc.nu> <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm> <20071016195432.GA31306@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58289 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760532AbXJPUfV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2007 16:35:21 -0400
Content-Disposition: inline
In-Reply-To: <20071016195432.GA31306@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Tue, Oct 16, 2007 at 01:54:33PM -0600, Matthew Wilcox wrote:
> On Tue, Oct 16, 2007 at 12:54:58PM -0700, david@lang.hm wrote:
> > On Tue, 16 Oct 2007, Alan Cox wrote:
> > >I wouldn't try dividing those by pata v sata. You'll cause all sorts of
> > >problems in the process because of PATA-SATA and SATA-PATA bridges.
> > 
> > if you use a PATA-SATA bridge (IDE drive SATA controller), it would look 
> > to the system like a SATA drive and be addressed and enumerated as SATA.
> 
> But you don't know where the bridge is.  It might be on the drive's
> board, it might be an explicit enclosure, or it might be on the
> motherboard.  Each of those scenarios is going to have a different user
> expectation.

And worse yet, depending on what BIOS options you set at config time,
or what might happen after you upgrade the BIOS, whether the drive
looks like PATA or SATA could change over time.  So if you have
/dev/hda hard-coded in your /etc/fstab file, you could and probably
will potentially lose after you change a BIOS option or take a BIOS
upgrade causing the BIOS configs to get resent and disabling PATA
emulation, such that your disk that had previously been /dev/hda now
shows up as /dev/sda.  (And this is something you will very badly
*want* since your disk drive access will be **much** faster once you
stop using PATA emulation.)

Yet another reason why people who desperately are trying to cling to
the good old days of stable device enumerations are going to be
disappointed; the *type* of the drive can change over time, even for
something as simple as a laptop's primary hard drive, which seem to be
some people's favorite example.

Unfortunately, people are just going to have to suck it up and get
used to a much more complicated world.

						- Ted
