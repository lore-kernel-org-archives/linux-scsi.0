From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Wed, 13 Aug 2008 22:28:07 -0700
Message-ID: <20080814052807.GN61889@plap4-2.local>
References: <andrew.vasquez@qlogic.com> <200808082010.m78KAGJE012193@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:3348 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYHNF2J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 01:28:09 -0400
Content-Disposition: inline
In-Reply-To: <200808082010.m78KAGJE012193@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, stf_xl@wp.pl, vst@vlnb.net

On Fri, 08 Aug 2008, greg@enjellic.com wrote:

> On Aug 5,  6:52am, Andrew Vasquez wrote:
> } Subject: Re: Poisoning of Linux initiators on SCST reboot.
> 
> Hi Andrew, thanks for the follow up.
> 
> > > Any idea on how tough a backport to 2.6.26 or earlier would be?
> > > Running 'head-of-git' from Linus' tree would be somewhat of a stretch
> > > for production applications.... :-)(
> > 
> > We are still looking to finalize a migration path.  As it stands now,
> > the least invasive mechanism looks like backporting:
> > 
> > [SCSI] qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io callback support.
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5f3a9a207f1fccde476dd31b4c63ead2967d934f
> > 
> > [SCSI] qla2xxx: Set an rport's dev_loss_tmo value in a consistent manner.
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=85821c906cf3563a00a3d98fa380a2581a7a5ff1
> > 
> > then adding this patch should suffice.  We'll do some more testing
> > locally.
> 
> I checked out the v2.6.26 tag into a branch and ported the patch
> series.  Everything went in with minimal difficulties, I'm including
> a composite patch below
> 
> The modules seem to build fine but I haven't had time to hitch them up
> to the harness to see whether they explode or not.  Will let everyone
> know what we find.

Ok, we've verified and backported the three changes through to 2.6.24.
The patches in this order:

 [SCSI] qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io callback support.
 http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5f3a9a207f1fccde476dd31b4c63ead2967d934f

 [SCSI] qla2xxx: Set an rport's dev_loss_tmo value in a consistent manner.
 http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=85821c906cf3563a00a3d98fa380a2581a7a5ff1

 [PATCH 2/8] qla2xxx: Correct synchronization of software/firmware fcport states.
 http://article.gmane.org/gmane.linux.scsi/43971

apply cleanly to 2.6.26 (git-am clean), and with minor 'fuzz' (git-am
warns) while applying the first patch against 2.6.25 and 2.6.24.

James B., quick question, from what I recall of the 'stable' process,
I'll need to wait till the 3rd patch hits Linus' tree before I can
submit to stable@kernel.org.  Since I can't 'CC to stable' the first
two patches (they are already in Linus' tree), what's the best way to
accomidate this disjoint submission?

Thanks, av
