From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 08/13] iscsi-target: Add CHAP Authentication support
	using libcrypto
Date: Sun, 24 Jul 2011 00:52:04 -0700
Message-ID: <1311493924.31450.502.camel@haakon2.linux-iscsi.org>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	 <1311410747-29947-9-git-send-email-nab@linux-iscsi.org>
	 <1311439173.23720.14.camel@mulgrave>
	 <CA+55aFzkEUbnoDg0KwXDRQMeCFeO5s6_4dWHTY59=hj3QHWL0w@mail.gmail.com>
	 <1311445075.17423.13.camel@mulgrave>
	 <1311455867.31450.287.camel@haakon2.linux-iscsi.org>
	 <1311479558.2702.8.camel@mulgrave>
	 <1311482486.31450.408.camel@haakon2.linux-iscsi.org>
	 <1311486617.2702.26.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311486617.2702.26.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-07-24 at 09:50 +0400, James Bottomley wrote:
> On Sat, 2011-07-23 at 21:41 -0700, Nicholas A. Bellinger wrote:
> > On Sun, 2011-07-24 at 07:52 +0400, James Bottomley wrote:

<SNIP>

> > > > I think the 'fragile as hell' and 'complicated to set up' ring the most
> > > > true here.  Thank you Linus..
> > > 
> > > The usual source of fragility here is a badly designed or complex ABI.
> > > So why don't you actually respond to the patch (as you've been asked to
> > > over the last five weeks) and point out what the problem is with its
> > > user to kernel ABI rather than blindly asserting something for which you
> > > have no evidence.
> > > 
> > 

I've made it clear for some time now why this is design is broken for
us, and why moving the default login path to userspace for a dynamically
controlled target mode fabric is a *bad* idea:

http://marc.info/?l=linux-scsi&m=130661363200677&w=2


> > > > > Well, this is essentially the argument.  The iSCSI authentication code
> > > > > follows a standard which originally had 4 different authentication
> > > > > methods (of which CHAP is just one) but which is now up to about 8 I
> > > > > think and rising.  It would be a massive amount of code to put them all
> > > > > in kernel, plus the authentication isn't a fast path thing; it's done
> > > > > once at login.  We already have the code to do this (although from the
> > > > > client side, not the server side) in userspace in the initiator.
> > > > > 
> > > > 
> > > > This is an incorrect statement.  I was very specific in May what type of
> > > > authentication passthrough that I want for iscsi-target, and why moving
> > > > the entire login path to userspace is a really bad idea for a
> > > > kernel-level iscsi-target that has a configfs control plane supporting
> > > > fully dynamic configuration.  So while I very much apprectiate the
> > > > efforts by Tomo directed by yourself, this is *not* what I asked for,
> > > > and is not acceptable for LIO iscsi-target code for the default login
> > > > codepath.
> > > 
> > > Look, it's this simple.  If we accept the principle that authentication
> > > should be done in-kernel for simplicity and ease of management, then it
> > > should all be done there.  If, as you seem to be suggesting, some
> > > authentication models are so complex they should be done in userspace,
> > > then it should all be done there.  Having two separate paths, one
> > > through kernel and one through user space for the same operation is the
> > > real recipe for fragility because it doubles the amount of testing and
> > > generally means that one path is less well tested than the other.
> > > 
> > 
> > Again, this is a simplified view of something that is not 'black or
> > white' in the actual implementation.  Passing the 'optional to
> > implement' authentication payloads into userspace is hardly a 'recipe
> > for fragility', considering that:
> > 
> > - We don't have a single client at this point that actually is going to
> > need this for v3.1
> > 
> > - The previous iscsi-target code actually implemented things this way
> > for the authentication path
> 
> As far as the kernel is concerned, the previous code was STGT ... which
> did it all in userspace.
> 

Yes, but that does not help for moving forward for v3.1 code.

> > > > So restate what I want:  A passthrough for pushing 'optional to
> > > > implement' iSCSI authentication payloads to userspace (like we had in
> > > > LIO v2.x) that can be enabled optionally on a per iSCSI target endpoint
> > > > context, and does not touch the default login path.  The specific code
> > > > reasons for this have not changed at all in the last months, and can be
> > > > found here for reference:
> > > > 
> > > > http://marc.info/?l=linux-kernel&m=130661363200680&w=2
> > > > 
> > > > > The prototype implementation, is very clean: it does the authenticated
> > > > > login and then passes the connected socket to the kernel for operations,
> > > > > so there's no real fragile state to pass across.
> > > > > 
> > > > 
> > > > I completely disagree. 
> > > 
> > > Based on what, since you don't yet appear to have read the patch?
> > > 
> > 
> > Yes I have read the patch, and no, I am not going to merge it into the
> > LIO upstream tree or commit to supporting it's model in iscsi-target as
> > the default.  It's wrong for the default paths, and gives us no upside
> > benefit for the SW target.
> 
> The upside is surely support for all authentication models.  You've
> still failed to say why it's wrong other than that the current out of
> tree users would need a migration update to move to it.
> 

I am not sure what you mean here.  I think the reasons why it's wrong
are obvious for the default login path because as Mike mentioned it
quickly moves from a simple kernel/user split interface to a complex one
because userspace needs to become more and more aware of specific
protocol state changes.

With a completely dynamic control plane and object library with
iscsi-target, it makes no sense to push the entire login path to
userspace, and only makes the default login cases that users want more
difficult to configure and manage.

> > > > > There are a couple of reasons why user space makes sense apart from the
> > > > > existing code and the clean separation of setup from operation: some of
> > > > > the auth methods involve complex algorithms and debugging them in
> > > > > userspace is just easier, plus it allows easy backward compatible
> > > > > addition of new authentication mechanisms without having to respin a
> > > > > kernel.
> > > > > 
> > > > 
> > > > Again, the 'optional to implement' authentication methods are what needs
> > > > to goto userspace in seperate authentication specific daemons, and not
> > > > the entire login control path into a single userspace process for even
> > > > the 'authentication disabled' case.  This is the wrong split.
> > > > 
> > > > Also, the patch did not address any form of backwards compatability
> > > > because it did not provide any patches for rtslib to expose the new
> > > > functionality to application level devels and distros who are already
> > > > integrating this package.
> > > 
> > > What backwards compatibility?  iscsi target is a new feature for the
> > > kernel.  The users of the out of tree code can surely continue to use it
> > > and it's hardly an impossible task to migrate them.
> > > 
> > 
> > Please understand that we have a complete iscsi-target userspace library
> > using native python object code in userspace that drives configuration
> > of /sys/kernel/config/target/iscsi control plane.  It's nice to just
> > gloss over the fact, and go back to punting this part back into
> > userspace and use a seperate configuration files that iscsi-login daemon
> > is required to parse, and be aware of state changes etc.
> 
> With what you have currently it's impossible to use any other
> authentication than CHAP; the infrastructure isn't even pluggable.  Plus
> the control plane is tied to it, so the configfs ABI has to be changed
> to add a new one ... that strikes me as the fragility here.
> 

Impossible is a very strong word for pushing iSCSI authentication
payloads (and not the entire login process) to userspace, especially
considering that is what v2.x iscsi-target originaly did before the
conversion to the modern libcrypto/md5 based in-kernel CHAP state
machine login we have here today.

> > This is where the real API fragililty comes into play from the
> > perspective of application devels using this code.  Avoiding this for
> > the default paths is very important from their perspective for a
> > consistent API, and for backward compatability if and when the configfs
> > control path needs to change.
> 
> a change in the configfs control plane is an effective userspace ABI
> change.
> 

Yes, but the important bit is that application devels should not be
talking to configfs directly anyways.  The rtslib object library is the
API that the default set of CHAP auth credentials (along with everything
else) are properly exposed to higher level apps, and where presenting a
consistent API is very important.

This is also where the 'optional to implement' authentication pieces
would also need to be enabled with seperate authentication daemons
attached to individual TargetName+TargetPortalGroupTag endpoints, so
that the kernel configfs control plane is *not* effected directly by
userspace code for the default login cases.

Making a change to iscsi-target kernel code for optionally pushing
RFC-3720 Login Phase CSG=0 (SecurityNegotiation) payloads into a
seperate codepath is really pretty simple for the main login codepath,
and I would be willing to add a simple example for doing authentication
payload passthrough for future 'optional to implement' authentication
methods post merge if there is actually enough interest to support
'optional to implement' security methods for the next round.

This would clearly demonstrate that it's possible to do the type of
thing for the future methods in the non default path, and not push the
main login process outside of the kernel.

--nab
