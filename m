From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: sanitize INQUIRY strings
Date: Mon, 21 Aug 2006 15:08:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0608211455390.5767-100000@iolanthe.rowland.org>
References: <20060821184244.GC24068@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36365 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750749AbWHUTIV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 15:08:21 -0400
In-Reply-To: <20060821184244.GC24068@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 21 Aug 2006, Matthew Wilcox wrote:

> On Mon, Aug 21, 2006 at 02:31:18PM -0400, Alan Stern wrote:
> > I assumed the point of those optimizations was obvious enough not to need 
> > any comment.
> 
> Bad assumption.  When you say "This is what the patch does", then I
> assume the whole patch does that.  When you say "The patch does X, and
> by the way, does some other minor cleanups", then I know the bits which
> make no sense are the cleanups and not needed for X.

Okay, fine.

> > (It is still present according to the web interface to the 
> > scsi-misc repository on www.kernel.org, BTW.)
> 
> It's not ...
> http://git.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=blob;h=a24d3461fc788b797f492cfff333fa419e9f3bc3;hb=d2afb3ae04e36dbc6e9eb2d8bd54406ff7b6b3bd;f=drivers/scsi/scsi_scan.c

Arghh...  My browser's bookmark is set to an old tree node (i.e.,
drivers/scsi under scsi-misc-2.6), so whenever I pull it up I see only the
files that were current at the time the bookmark was created!  A subtle
user-interface problem made possible by GIT.

> I took it out with:
> http://git.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=4ff36718ede26ee2da73f2dae94d71e2b06845fc
> 
> > Besides, let's assume you're right and the vendor really did mean to 
> > terminate the string by putting a NUL there.  The bytes following the 
> > NUL could be anything, but most likely the vendor would set them to more 
> > NULs or to spaces.  So the patch would change those NULs to spaces, and 
> > the result is you end up with exactly the string the vendor intended, 
> > except now it is padded with spaces to the correct length as required by 
> > the spec.
> 
> My suggestion produced the same result as yours for these cases.
> 
> > On the other hand, if some of the characters following the NUL happen to 
> > be printable then the patch does change the meaning of the string.  That's 
> > inevitable; when vendors don't follow the rules then sometimes they will 
> > be misunderstood.  Who's to say whether the pre-patch interpretation is 
> > any better than the post-patch interpretation?
> 
> I say so.  I gave an example where my algorithm produces better results
> than yours in my response to Philip Auld.  Do you have an example where
> yours gives preferable results?

Well, yes.  Suppose the vendor's string was set to 'Abc\0Def\0'.  My 
algorithm would set it to 'Abc Def ' as desired, whereas yours would 
truncate it to 'Abc     '.

Multiplying far-out examples doesn't prove anything, though.  What we need
to do is decide which strategy works better, most of the time.  Up until
now these NUL characters have been interpreted has string terminators, so
it's probably best to keep that interpretation.  For non-NUL non-graphical 
characters, it's best to continue replacing them with spaces.

I will rework the patch (based on the current scsi_scan.c).

Alan Stern

