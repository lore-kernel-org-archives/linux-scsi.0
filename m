From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 08/13] iscsi-target: Add CHAP Authentication support
 using libcrypto
Date: Sat, 23 Jul 2011 22:17:55 +0400
Message-ID: <1311445075.17423.13.camel@mulgrave>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	 <1311410747-29947-9-git-send-email-nab@linux-iscsi.org>
	 <1311439173.23720.14.camel@mulgrave>
	 <CA+55aFzkEUbnoDg0KwXDRQMeCFeO5s6_4dWHTY59=hj3QHWL0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35186 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828Ab1GWSSE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2011 14:18:04 -0400
In-Reply-To: <CA+55aFzkEUbnoDg0KwXDRQMeCFeO5s6_4dWHTY59=hj3QHWL0w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andrew Morton <akpm@linux-foundation.org>

On Sat, 2011-07-23 at 10:51 -0700, Linus Torvalds wrote:
> On Sat, Jul 23, 2011 at 9:39 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > I've asked you twice for input on the patch doing this in userspace,
> > which was posted five weeks ago.  Just ignoring something is
> > unacceptable behaviour ... what do I have to do to get your attention?
> > NAK the patch set?
> 
> So what's the advantage of user space?
> 
> Traditionally, kernel/userspace splits have been:
>  - fragile as hell
>  - more code
>  - slower
>  - complicated to set up
>  - problematic with backwards compatibility issues
> and these days when I see some kernel functionality that needs user
> space support, I just go "f*ck, that's going to be a pain".
> 
> So I think the "that part can be done in user space" argument is
> fundamentally crap.
> 
> Now, if it is an issue of "that can be done BETTER in user space
> BECAUSE xyz", then that's a different issue. I haven't seen that
> argument, though.

Well, this is essentially the argument.  The iSCSI authentication code
follows a standard which originally had 4 different authentication
methods (of which CHAP is just one) but which is now up to about 8 I
think and rising.  It would be a massive amount of code to put them all
in kernel, plus the authentication isn't a fast path thing; it's done
once at login.  We already have the code to do this (although from the
client side, not the server side) in userspace in the initiator.

The prototype implementation, is very clean: it does the authenticated
login and then passes the connected socket to the kernel for operations,
so there's no real fragile state to pass across.

There are a couple of reasons why user space makes sense apart from the
existing code and the clean separation of setup from operation: some of
the auth methods involve complex algorithms and debugging them in
userspace is just easier, plus it allows easy backward compatible
addition of new authentication mechanisms without having to respin a
kernel.

Quite a few other authentication mechanisms (like wireless and ipsec)
are in userspace for the setup and negotiation and in-kernel for the
operation, so it's a well understood paradigm.

James


