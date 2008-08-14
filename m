From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Thu, 14 Aug 2008 09:14:52 -0700
Message-ID: <20080814161452.GA75223@plap4-2.qlogic.org>
References: <andrew.vasquez@qlogic.com> <200808082010.m78KAGJE012193@wind.enjellic.com> <20080814052807.GN61889@plap4-2.local> <1218722017.3345.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11989 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYHNQOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 12:14:55 -0400
Content-Disposition: inline
In-Reply-To: <1218722017.3345.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: greg@enjellic.com, scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, stf_xl@wp.pl, vst@vlnb.net

On Thu, 14 Aug 2008, James Bottomley wrote:

> On Wed, 2008-08-13 at 22:28 -0700, Andrew Vasquez wrote:
> > Ok, we've verified and backported the three changes through to 2.6.24.
> > The patches in this order:
> > 
> >  [SCSI] qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io callback support.
> >  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5f3a9a207f1fccde476dd31b4c63ead2967d934f
> > 
> >  [SCSI] qla2xxx: Set an rport's dev_loss_tmo value in a consistent manner.
> >  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=85821c906cf3563a00a3d98fa380a2581a7a5ff1
> > 
> >  [PATCH 2/8] qla2xxx: Correct synchronization of software/firmware fcport states.
> >  http://article.gmane.org/gmane.linux.scsi/43971
> > 
> > apply cleanly to 2.6.26 (git-am clean), and with minor 'fuzz' (git-am
> > warns) while applying the first patch against 2.6.25 and 2.6.24.
> > 
> > James B., quick question, from what I recall of the 'stable' process,
> > I'll need to wait till the 3rd patch hits Linus' tree before I can
> > submit to stable@kernel.org.  Since I can't 'CC to stable' the first
> > two patches (they are already in Linus' tree), what's the best way to
> > accomidate this disjoint submission?
> 
> Assuming they're OK to apply individually, you just send the first two
> to stable now quoting the upstream commit id

As I mentioned, the first two do in fact apply cleanly to 2.6.26.
There's a bit of fuzz with .25/24 application of the first patch, so a
basic git-am may fail, whereas a 'patch -p1' works...

> and I'll add the CC: stable
> tag on the third which should cause it to sumbit automatically as soon
> as Linus pulls it.

Ok, thanks.  I'll send the patches over to stable@...
