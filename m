From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Tue, 5 Aug 2008 06:52:30 -0700
Message-ID: <20080805135230.GB27577@plap4-2.local>
References: <andrew.vasquez@qlogic.com> <200808012022.m71KMNDX004852@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:19949 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150AbYHENwf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 09:52:35 -0400
Content-Disposition: inline
In-Reply-To: <200808012022.m71KMNDX004852@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, stf_xl@wp.pl, vst@vlnb.net

On Fri, 01 Aug 2008, greg@enjellic.com wrote:

> On Jul 29, 11:19am, Andrew Vasquez wrote:
> } Subject: Re: Poisoning of Linux initiators on SCST reboot.
> 
> Good afternoon to everyone, hope the week is ending well.
> 
> > Ok, here's a patch against Linus' latest git tree which corrects the
> > issue locally.  Could you try it out on your test configuration?
> > We'd like to perform some additional sanity-testing locally before
> > we submit the fix formally for upstream consumption.
> 
> The patch worked perfectly on our test configuration.  After the SCST
> target reboot the client initiator picked up on the presence of the
> storage and properly discovered it.
> 
> Evidently the qla2xxx driver has changed significantly from where
> Linus' tree was at when you sent the patch.  My local git clone is up
> to date with Linus' git tree which has
> 94ad374a0751f40d25e22e036c37f7263569d24c at its head and the patch
> didn't apply.
> 
> The kernel I tested against was from my local git clone of Linus' tree
> which has 94ad374a0751f40d25e22e036c37f7263569d24c at its head.  The
> qla2xxx driver has evidently changed significantly since the patch
> didn't apply cleanly against this tree.  It was trivial, however, to
> update the patch.

Thank you for the update.  The patch is already in our patch-queue for
our next -rcX submission.

> > Sidenote: we'll also need to backport some form of this fix to
> > stable, but qla2xxx in kernels upto 2.6.26 didn't utilize the
> > terminate-rport-io infrastructure:
> 
> That would seem to be the case.  It doesn't appear 2.6.26 even has the
> necessary infra-structure to support the patch.
> 
> Any idea on how tough a backport to 2.6.26 or earlier would be?
> Running 'head-of-git' from Linus' tree would be somewhat of a stretch
> for production applications.... :-)(

We are still looking to finalize a migration path.  As it stands now,
the least invasive mechanism looks like backporting:

[SCSI] qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io callback support.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5f3a9a207f1fccde476dd31b4c63ead2967d934f

[SCSI] qla2xxx: Set an rport's dev_loss_tmo value in a consistent manner.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=85821c906cf3563a00a3d98fa380a2581a7a5ff1

then adding this patch should suffice.  We'll do some more testing
locally.

Regards,
Andrew Vasquez
