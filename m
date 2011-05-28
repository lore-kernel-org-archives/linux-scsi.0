From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v5 07/13] iscsi-target: Add iSCSI Login Negotiation +
	Parameter logic
Date: Fri, 27 May 2011 17:52:27 -0700
Message-ID: <1306543947.23461.313.camel@haakon2.linux-iscsi.org>
References: <1306445587.23461.22.camel@haakon2.linux-iscsi.org>
	 <1306451068.4048.69.camel@mulgrave.site>
	 <1306452490.23461.60.camel@haakon2.linux-iscsi.org>
	 <20110527084752T.fujita.tomonori@lab.ntt.co.jp>
	 <1306454848.23461.77.camel@haakon2.linux-iscsi.org>
	 <1306538602.12244.22.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47910 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab1E1BAr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2011 21:00:47 -0400
In-Reply-To: <1306538602.12244.22.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.de, agrover@redhat.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, akpm@linux-foundation.org, martin.svec@zoner.cz, jxm@risingtidesystems.com, "J.H." <warthog9@kernel.org>

On Fri, 2011-05-27 at 18:23 -0500, James Bottomley wrote:
> On Thu, 2011-05-26 at 17:07 -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2011-05-27 at 08:47 +0900, FUJITA Tomonori wrote:
> > > On Thu, 26 May 2011 16:28:10 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > As we have discussed at length over the years, the split needs to be all
> > > > userspace or all kernelspace, and when implementations start doing
> > > > things in-between they quickly get painful to debug, maintain and
> > > > extend.  I have no interest in trying to evolve this further when LIO
> > > 
> > > Sorry, I disagree. As I explained, once user space passes established nexuses
> > > to kernel, kernel handles all. I don't think it's painful.
> > > 
> > > 
> > 
> > Then we are going to have to agree to disgree on this for an individual
> > target endpoint context and being able to manage (via configfs) a
> > complete set of iscsi-target features with native python library code.
> > 
> > As for moving the mainline iscsi-target efforts to a more complex
> > default direction is something that we (speaking as LIO maintainer and
> > on behalf of RisingTide userspace) do not have an interest for an
> > initial merge.  We owe our users a complete set of functional and stable
> > kernel and userspace library+shell, and not an untested design with
> > undetermined time-frame for deployment.
> 
> OK, so I understand the commercial imperatives.  However, when a trusted
> reviewer raises issues, and I check and find myself agreeing, I need
> them addressed to make forward progress.
> 

It's more than that.  It's about the future maintainability of the
target kernel code.  Doing this reset to push the entire iSCSI login
into userspace for drivers/target/iscsi/ is technically the wrong
direction.   We already have a userspace target, and going down this
direction (again) for iscsi-target is not making forward progress.

> The issue is simple:
> 
>       * We can put all the auth mechanisms in the kernel, so we need a
>         userspace upcall anyway
>       * Since we have to have an upcall, it should be the default path
>         for everything (so it gets well tested).
> 
> Just saying "everything has to be in the kernel because mixed
> user/kernel code is too complex" doesn't fly because we already have a
> growing list of counter examples, some of which were cited.
> 

I am not saying that everything has to be in the kernel.  I am saying
that the main iSCSI login state machines that *do* *not* effect
authentication payloads of the iSCSI login process need to be in kernel
for a kernel-level iscsi-target stack in order to properly support the
real-time management of the /sys/kernel/config/target/iscsi/ control
plane.

Being able to support the proper shutdown of all outstanding I/O across
N:M mapped iSCSI network portals <-> iSCSI TargetName
+TargetPortalGroupTag endpoints is already not trivial, and wanting to
move existing iscsi_target_login_thread() logic to (multi-threaded..?)
userspace where we now have to sychronize with everything going on in
the kernel is where there is a serious technical problem with what you
are suggesting that is now required for an initial iscsi-target merge.

That said, I am still open to a compromise of providing a method to
allow all iSCSI login CSG=0 state PDUs containing authentication
payloads sent/received into userspace.  However, this must be:

*) Enabled on individual /sys/kernel/config/target/iscsi/$IQN/$TPGT/
endpoint basis.  We need this to support independent userspace daemons
seperately of the authentication disabled mode that does not require any
userspace interaction.  This is important for the large scale
boot1.kernel.org public iscsi-target case (warthog9 CC'ed), where CSG=0
is being skipped all-together.

*) The main iSCSI login state machines stay in the kernel, and
individual successful login attempts with outstanding nexus I/O for
reinstatement events say in the kernel to avoid unwanted and unnecessary
sychronization complexity of a split kernel/user model across the entire
stack.

These two points are non negotiable for me, and are required for us
being able to properly support the required default iscsi-target kernel
feature set with target-core.  But more than that, its also about being
able to provide the python object library (rtslib) to drive the kernel
control plane.  This is what application developers and integrators
really want, and breaking the consistency of the object library for non
standard auth methods that do not even exist atm is where we are running
into disagreement.

We need to be able to support the user community with a proper library
moving forward to mask future underlying kernel control plane changes.
How iscsi-target currently works with rtslib is far superior in terms of
fuctionality and maintainability to any Linux/iSCSI target library have
exposed to application level devels thus far.  The non-standard auth
cases need to be able to work properly from both aspects, and the entire
iSCSI login state machine to userspace only IMHO complicates the
process.

--nab

