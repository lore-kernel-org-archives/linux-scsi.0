From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 08/13] iscsi-target: Add CHAP Authentication support
	using libcrypto
Date: Sat, 23 Jul 2011 14:17:47 -0700
Message-ID: <1311455867.31450.287.camel@haakon2.linux-iscsi.org>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	 <1311410747-29947-9-git-send-email-nab@linux-iscsi.org>
	 <1311439173.23720.14.camel@mulgrave>
	 <CA+55aFzkEUbnoDg0KwXDRQMeCFeO5s6_4dWHTY59=hj3QHWL0w@mail.gmail.com>
	 <1311445075.17423.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311445075.17423.13.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-07-23 at 22:17 +0400, James Bottomley wrote:
> On Sat, 2011-07-23 at 10:51 -0700, Linus Torvalds wrote:
> > On Sat, Jul 23, 2011 at 9:39 AM, James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> > >
> > > I've asked you twice for input on the patch doing this in userspace,
> > > which was posted five weeks ago.  Just ignoring something is
> > > unacceptable behaviour ... what do I have to do to get your attention?
> > > NAK the patch set?
> > 
> > So what's the advantage of user space?
> > 
> > Traditionally, kernel/userspace splits have been:
> >  - fragile as hell
> >  - more code
> >  - slower
> >  - complicated to set up
> >  - problematic with backwards compatibility issues
> > and these days when I see some kernel functionality that needs user
> > space support, I just go "f*ck, that's going to be a pain".
> > 
> > So I think the "that part can be done in user space" argument is
> > fundamentally crap.
> > 
> > Now, if it is an issue of "that can be done BETTER in user space
> > BECAUSE xyz", then that's a different issue. I haven't seen that
> > argument, though.
> 

I think the 'fragile as hell' and 'complicated to set up' ring the most
true here.  Thank you Linus..

> Well, this is essentially the argument.  The iSCSI authentication code
> follows a standard which originally had 4 different authentication
> methods (of which CHAP is just one) but which is now up to about 8 I
> think and rising.  It would be a massive amount of code to put them all
> in kernel, plus the authentication isn't a fast path thing; it's done
> once at login.  We already have the code to do this (although from the
> client side, not the server side) in userspace in the initiator.
> 

This is an incorrect statement.  I was very specific in May what type of
authentication passthrough that I want for iscsi-target, and why moving
the entire login path to userspace is a really bad idea for a
kernel-level iscsi-target that has a configfs control plane supporting
fully dynamic configuration.  So while I very much apprectiate the
efforts by Tomo directed by yourself, this is *not* what I asked for,
and is not acceptable for LIO iscsi-target code for the default login
codepath.

So restate what I want:  A passthrough for pushing 'optional to
implement' iSCSI authentication payloads to userspace (like we had in
LIO v2.x) that can be enabled optionally on a per iSCSI target endpoint
context, and does not touch the default login path.  The specific code
reasons for this have not changed at all in the last months, and can be
found here for reference:

http://marc.info/?l=linux-kernel&m=130661363200680&w=2

> The prototype implementation, is very clean: it does the authenticated
> login and then passes the connected socket to the kernel for operations,
> so there's no real fragile state to pass across.
> 

I completely disagree. 

> There are a couple of reasons why user space makes sense apart from the
> existing code and the clean separation of setup from operation: some of
> the auth methods involve complex algorithms and debugging them in
> userspace is just easier, plus it allows easy backward compatible
> addition of new authentication mechanisms without having to respin a
> kernel.
> 

Again, the 'optional to implement' authentication methods are what needs
to goto userspace in seperate authentication specific daemons, and not
the entire login control path into a single userspace process for even
the 'authentication disabled' case.  This is the wrong split.

Also, the patch did not address any form of backwards compatability
because it did not provide any patches for rtslib to expose the new
functionality to application level devels and distros who are already
integrating this package.

As mentioned before, we (LIO and RTS) have no interest in breaking a
python object library that already exposes iscsi-target functionality
users actually want, for a last-minute split that makes the overall
design less effective for the default cases the vast majority of people
actually care about.

> Quite a few other authentication mechanisms (like wireless and ipsec)
> are in userspace for the setup and negotiation and in-kernel for the
> operation, so it's a well understood paradigm.
> 

And, we have also seen historically how painful the split has been with
open-iscsi, which in the end took much longer to get stable (and is
still harder to debug) than if a proper login split was used to begin
with.

I have been very willing to compromise on many things throughout this
target mode endevour, but making it more difficult for iscsi-target to
'just work' is not what the userbase wants, and will not be changing
this for the default two cases.

--nab
