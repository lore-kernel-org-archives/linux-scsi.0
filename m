From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 08/13] iscsi-target: Add CHAP Authentication support
 using libcrypto
Date: Sun, 24 Jul 2011 09:50:17 +0400
Message-ID: <1311486617.2702.26.camel@mulgrave>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	 <1311410747-29947-9-git-send-email-nab@linux-iscsi.org>
	 <1311439173.23720.14.camel@mulgrave>
	 <CA+55aFzkEUbnoDg0KwXDRQMeCFeO5s6_4dWHTY59=hj3QHWL0w@mail.gmail.com>
	 <1311445075.17423.13.camel@mulgrave>
	 <1311455867.31450.287.camel@haakon2.linux-iscsi.org>
	 <1311479558.2702.8.camel@mulgrave>
	 <1311482486.31450.408.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311482486.31450.408.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-07-23 at 21:41 -0700, Nicholas A. Bellinger wrote:
> On Sun, 2011-07-24 at 07:52 +0400, James Bottomley wrote:
> > On Sat, 2011-07-23 at 14:17 -0700, Nicholas A. Bellinger wrote:
> > > On Sat, 2011-07-23 at 22:17 +0400, James Bottomley wrote:
> > > > On Sat, 2011-07-23 at 10:51 -0700, Linus Torvalds wrote:
> > > > > On Sat, Jul 23, 2011 at 9:39 AM, James Bottomley
> > > > > <James.Bottomley@hansenpartnership.com> wrote:
> > > > > >
> > > > > > I've asked you twice for input on the patch doing this in userspace,
> > > > > > which was posted five weeks ago.  Just ignoring something is
> > > > > > unacceptable behaviour ... what do I have to do to get your attention?
> > > > > > NAK the patch set?
> > > > > 
> > > > > So what's the advantage of user space?
> > > > > 
> > > > > Traditionally, kernel/userspace splits have been:
> > > > >  - fragile as hell
> > > > >  - more code
> > > > >  - slower
> > > > >  - complicated to set up
> > > > >  - problematic with backwards compatibility issues
> > > > > and these days when I see some kernel functionality that needs user
> > > > > space support, I just go "f*ck, that's going to be a pain".
> > > > > 
> > > > > So I think the "that part can be done in user space" argument is
> > > > > fundamentally crap.
> > > > > 
> > > > > Now, if it is an issue of "that can be done BETTER in user space
> > > > > BECAUSE xyz", then that's a different issue. I haven't seen that
> > > > > argument, though.
> > > > 
> > > 
> > > I think the 'fragile as hell' and 'complicated to set up' ring the most
> > > true here.  Thank you Linus..
> > 
> > The usual source of fragility here is a badly designed or complex ABI.
> > So why don't you actually respond to the patch (as you've been asked to
> > over the last five weeks) and point out what the problem is with its
> > user to kernel ABI rather than blindly asserting something for which you
> > have no evidence.
> > 
> 
> Because the patch does not do what I originally said I would accept as a
> userspace passthrough.  It's that simple.

Being a good maintainer isn't about imposing your own dogma on others,
it's actually about reading the patches and listening to the arguments.
In this case, someone cared enough about the issues in your code to
write an alternative; that's what deserves careful consideration.

> > > > Well, this is essentially the argument.  The iSCSI authentication code
> > > > follows a standard which originally had 4 different authentication
> > > > methods (of which CHAP is just one) but which is now up to about 8 I
> > > > think and rising.  It would be a massive amount of code to put them all
> > > > in kernel, plus the authentication isn't a fast path thing; it's done
> > > > once at login.  We already have the code to do this (although from the
> > > > client side, not the server side) in userspace in the initiator.
> > > > 
> > > 
> > > This is an incorrect statement.  I was very specific in May what type of
> > > authentication passthrough that I want for iscsi-target, and why moving
> > > the entire login path to userspace is a really bad idea for a
> > > kernel-level iscsi-target that has a configfs control plane supporting
> > > fully dynamic configuration.  So while I very much apprectiate the
> > > efforts by Tomo directed by yourself, this is *not* what I asked for,
> > > and is not acceptable for LIO iscsi-target code for the default login
> > > codepath.
> > 
> > Look, it's this simple.  If we accept the principle that authentication
> > should be done in-kernel for simplicity and ease of management, then it
> > should all be done there.  If, as you seem to be suggesting, some
> > authentication models are so complex they should be done in userspace,
> > then it should all be done there.  Having two separate paths, one
> > through kernel and one through user space for the same operation is the
> > real recipe for fragility because it doubles the amount of testing and
> > generally means that one path is less well tested than the other.
> > 
> 
> Again, this is a simplified view of something that is not 'black or
> white' in the actual implementation.  Passing the 'optional to
> implement' authentication payloads into userspace is hardly a 'recipe
> for fragility', considering that:
> 
> - We don't have a single client at this point that actually is going to
> need this for v3.1
> 
> - The previous iscsi-target code actually implemented things this way
> for the authentication path

As far as the kernel is concerned, the previous code was STGT ... which
did it all in userspace.

> > > So restate what I want:  A passthrough for pushing 'optional to
> > > implement' iSCSI authentication payloads to userspace (like we had in
> > > LIO v2.x) that can be enabled optionally on a per iSCSI target endpoint
> > > context, and does not touch the default login path.  The specific code
> > > reasons for this have not changed at all in the last months, and can be
> > > found here for reference:
> > > 
> > > http://marc.info/?l=linux-kernel&m=130661363200680&w=2
> > > 
> > > > The prototype implementation, is very clean: it does the authenticated
> > > > login and then passes the connected socket to the kernel for operations,
> > > > so there's no real fragile state to pass across.
> > > > 
> > > 
> > > I completely disagree. 
> > 
> > Based on what, since you don't yet appear to have read the patch?
> > 
> 
> Yes I have read the patch, and no, I am not going to merge it into the
> LIO upstream tree or commit to supporting it's model in iscsi-target as
> the default.  It's wrong for the default paths, and gives us no upside
> benefit for the SW target.

The upside is surely support for all authentication models.  You've
still failed to say why it's wrong other than that the current out of
tree users would need a migration update to move to it.

> > > > There are a couple of reasons why user space makes sense apart from the
> > > > existing code and the clean separation of setup from operation: some of
> > > > the auth methods involve complex algorithms and debugging them in
> > > > userspace is just easier, plus it allows easy backward compatible
> > > > addition of new authentication mechanisms without having to respin a
> > > > kernel.
> > > > 
> > > 
> > > Again, the 'optional to implement' authentication methods are what needs
> > > to goto userspace in seperate authentication specific daemons, and not
> > > the entire login control path into a single userspace process for even
> > > the 'authentication disabled' case.  This is the wrong split.
> > > 
> > > Also, the patch did not address any form of backwards compatability
> > > because it did not provide any patches for rtslib to expose the new
> > > functionality to application level devels and distros who are already
> > > integrating this package.
> > 
> > What backwards compatibility?  iscsi target is a new feature for the
> > kernel.  The users of the out of tree code can surely continue to use it
> > and it's hardly an impossible task to migrate them.
> > 
> 
> Please understand that we have a complete iscsi-target userspace library
> using native python object code in userspace that drives configuration
> of /sys/kernel/config/target/iscsi control plane.  It's nice to just
> gloss over the fact, and go back to punting this part back into
> userspace and use a seperate configuration files that iscsi-login daemon
> is required to parse, and be aware of state changes etc.

With what you have currently it's impossible to use any other
authentication than CHAP; the infrastructure isn't even pluggable.  Plus
the control plane is tied to it, so the configfs ABI has to be changed
to add a new one ... that strikes me as the fragility here.

> This is where the real API fragililty comes into play from the
> perspective of application devels using this code.  Avoiding this for
> the default paths is very important from their perspective for a
> consistent API, and for backward compatability if and when the configfs
> control path needs to change.

a change in the configfs control plane is an effective userspace ABI
change.

James

> > > As mentioned before, we (LIO and RTS) have no interest in breaking a
> > > python object library that already exposes iscsi-target functionality
> > > users actually want, for a last-minute split that makes the overall
> > > design less effective for the default cases the vast majority of people
> > > actually care about.
> > > 
> > > > Quite a few other authentication mechanisms (like wireless and ipsec)
> > > > are in userspace for the setup and negotiation and in-kernel for the
> > > > operation, so it's a well understood paradigm.
> > > > 
> > > 
> > > And, we have also seen historically how painful the split has been with
> > > open-iscsi, which in the end took much longer to get stable (and is
> > > still harder to debug) than if a proper login split was used to begin
> > > with.
> > > 
> > > I have been very willing to compromise on many things throughout this
> > > target mode endevour, but making it more difficult for iscsi-target to
> > > 'just work' is not what the userbase wants, and will not be changing
> > > this for the default two cases.
> > 
> > Mike gave a fair assessment of this, so I'll leave the final word to
> > him.
> > 
> 
> While I apperciate Mike's input here, I'll leave the final word to Andy
> and Christoph who have been primarly driving iscsi-target v4.1
> development and are the guys who have their fingers deepest in the code.
> 
> But all that said, there is still one person who has the real final word
> here, and he's made it clear how he feels about this type of kernel/user
> split.
> 
> --nab
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
