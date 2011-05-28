From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH-v5 07/13] iscsi-target: Add iSCSI Login Negotiation +
 Parameter logic
Date: Sat, 28 May 2011 13:31:31 -0500
Message-ID: <1306607491.5630.45.camel@mulgrave.site>
References: <1306445587.23461.22.camel@haakon2.linux-iscsi.org>
	 <1306451068.4048.69.camel@mulgrave.site>
	 <1306452490.23461.60.camel@haakon2.linux-iscsi.org>
	 <20110527084752T.fujita.tomonori@lab.ntt.co.jp>
	 <1306454848.23461.77.camel@haakon2.linux-iscsi.org>
	 <1306538602.12244.22.camel@mulgrave.site>
	 <1306543947.23461.313.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55804 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683Ab1E1Sbh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 May 2011 14:31:37 -0400
In-Reply-To: <1306543947.23461.313.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.de, agrover@redhat.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, akpm@linux-foundation.org, martin.svec@zoner.cz, jxm@risingtidesystems.com, "J.H." <warthog9@kernel.org>

On Fri, 2011-05-27 at 17:52 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2011-05-27 at 18:23 -0500, James Bottomley wrote:
> > On Thu, 2011-05-26 at 17:07 -0700, Nicholas A. Bellinger wrote:
> > > On Fri, 2011-05-27 at 08:47 +0900, FUJITA Tomonori wrote:
> > > > On Thu, 26 May 2011 16:28:10 -0700
> > > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > > 
> > > > > As we have discussed at length over the years, the split needs to be all
> > > > > userspace or all kernelspace, and when implementations start doing
> > > > > things in-between they quickly get painful to debug, maintain and
> > > > > extend.  I have no interest in trying to evolve this further when LIO
> > > > 
> > > > Sorry, I disagree. As I explained, once user space passes established nexuses
> > > > to kernel, kernel handles all. I don't think it's painful.
> > > > 
> > > > 
> > > 
> > > Then we are going to have to agree to disgree on this for an individual
> > > target endpoint context and being able to manage (via configfs) a
> > > complete set of iscsi-target features with native python library code.
> > > 
> > > As for moving the mainline iscsi-target efforts to a more complex
> > > default direction is something that we (speaking as LIO maintainer and
> > > on behalf of RisingTide userspace) do not have an interest for an
> > > initial merge.  We owe our users a complete set of functional and stable
> > > kernel and userspace library+shell, and not an untested design with
> > > undetermined time-frame for deployment.
> > 
> > OK, so I understand the commercial imperatives.  However, when a trusted
> > reviewer raises issues, and I check and find myself agreeing, I need
> > them addressed to make forward progress.
> > 
> 
> It's more than that.  It's about the future maintainability of the
> target kernel code.  Doing this reset to push the entire iSCSI login
> into userspace for drivers/target/iscsi/ is technically the wrong
> direction.

You've stated this many times, but never actually given an explanation
of why.

>    We already have a userspace target, and going down this
> direction (again) for iscsi-target is not making forward progress.

This isn't the correct way to look at it.  The choice isn't all in
userspace or all in kernel space.  For performance, the key idea is to
have all the fast paths in kernel space.  However, login is hardly a
fast path.  It's done once at start of day, then occasionally on
connection reset.

Moving some code to userspace doesn't mean all has to move.

> > The issue is simple:
> > 
> >       * We can put all the auth mechanisms in the kernel, so we need a
> >         userspace upcall anyway
> >       * Since we have to have an upcall, it should be the default path
> >         for everything (so it gets well tested).
> > 
> > Just saying "everything has to be in the kernel because mixed
> > user/kernel code is too complex" doesn't fly because we already have a
> > growing list of counter examples, some of which were cited.
> > 
> 
> I am not saying that everything has to be in the kernel.  I am saying
> that the main iSCSI login state machines that *do* *not* effect
> authentication payloads of the iSCSI login process need to be in kernel
> for a kernel-level iscsi-target stack in order to properly support the
> real-time management of the /sys/kernel/config/target/iscsi/ control
> plane.

So what I hear you say is that the login process has to be in-kernel
because otherwise we can't control it from configfs.

I don't think this to be true: you can still have a configfs based
control plane and just do user space upcalls for the pieces that aren't
in-kernel.  I agree with the goal of single control plane, but if
configfs is causing us to be inflexible, I think configfs, rather than
the design, needs to change.

> Being able to support the proper shutdown of all outstanding I/O across
> N:M mapped iSCSI network portals <-> iSCSI TargetName
> +TargetPortalGroupTag endpoints is already not trivial, and wanting to
> move existing iscsi_target_login_thread() logic to (multi-threaded..?)
> userspace where we now have to sychronize with everything going on in
> the kernel is where there is a serious technical problem with what you
> are suggesting that is now required for an initial iscsi-target merge.

I really don't see this.  The broad abstract state machine looks like


|Target Configuration and initialisation|
   |
   |      +----------------------------- (relogin)
   V      V                            |
|Login (userspace)| ----> |Operation (Kernel)| -> |Termination|

That's nicely separable and doesn't really involve state
synchronisation.  Nothing really says that Termination has to be in
userspace (or kernel space).

James


