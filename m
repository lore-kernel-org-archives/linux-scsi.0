From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: sanitize INQUIRY strings
Date: Mon, 21 Aug 2006 14:31:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0608211412010.8319-100000@iolanthe.rowland.org>
References: <20060821173546.GA24068@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:8711 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751236AbWHUSbT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 14:31:19 -0400
In-Reply-To: <20060821173546.GA24068@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 21 Aug 2006, Matthew Wilcox wrote:

> On Mon, Aug 21, 2006 at 12:52:18PM -0400, Alan Stern wrote:
> > On Mon, 21 Aug 2006, Matthew Wilcox wrote:
> > 
> > > On Mon, Aug 21, 2006 at 12:03:21PM -0400, Alan Stern wrote:
> > > > This patch (as766) sanitizes the Vendor, Product, and Revision strings
> > > > contained in an INQUIRY result, by setting all non-graphic or
> > > > non-ASCII characters to ' '.  Since the standard disallows such
> > > > characters, this will affect only non-compliant devices.
> > > 
> > > I thiink you attached the wrong patch; it doesn't match the description
> > > at all.
> > 
> > No; it does match the description.  But you have to read it carefully, 
> > because the majority of the patch implements optimizations made possible 
> > by the small piece that does the actual sanitizing.
> 
> The description should have said that.  I don't know what you're trying
> to accomplish with pulling the length byte out of the inquiry data, for
> example.

I assumed the point of those optimizations was obvious enough not to need 
any comment.

For example, pulling the length byte out removes a bunch of duplicated
array indexes and additions; in three places it lets us change "i <
inq_result[4] + 5" to "i < n".  Whether the object code ends up being any
shorter will depend on the compiler, of course, but it does reduce
redundancy and opportunity for errors in the source code.

Likewise, replacing the "if" statements by conditional expressions (the 
'?:' operator) eliminates three printk subroutine calls.  Although the 
changes are trivial, in the end 12 lines of code are replaced by 4.  Who 
could complain about that?  Especially if the whole subroutine is going to 
vanish anyway.  (It is still present according to the web interface to the 
scsi-misc repository on www.kernel.org, BTW.)

The description should have mentioned the business about changing the
function prototypes so that they correctly declare inq_result as unsigned
char * rather than char *.  If you insist, I will resend the patch with an 
updated description.

> In any case, you didn't address my point that a NUL byte is probably
> meant to terminate the string, not merely be treated equivalently to
> a space.  Of course, we can do anything here, the device is out of spec,
> but in terms of trying to ascertain the intention of the drug-crazed
> hobo^W^W^W^W engineer who wrote the firmware, I think your interpretation
> is less likely.

Your point was already addressed by Philip Auld, who wrote:

  I wouldn't make an exception for NUL. Trying to guess that the device 
  vendor really meant to NUL-terminate does not seem right to me. 
  Plus it will hide out of spec devices more than "spacing" unprintable 
  characters.

Besides, let's assume you're right and the vendor really did mean to 
terminate the string by putting a NUL there.  The bytes following the 
NUL could be anything, but most likely the vendor would set them to more 
NULs or to spaces.  So the patch would change those NULs to spaces, and 
the result is you end up with exactly the string the vendor intended, 
except now it is padded with spaces to the correct length as required by 
the spec.

On the other hand, if some of the characters following the NUL happen to 
be printable then the patch does change the meaning of the string.  That's 
inevitable; when vendors don't follow the rules then sometimes they will 
be misunderstood.  Who's to say whether the pre-patch interpretation is 
any better than the post-patch interpretation?

Alan Stern

