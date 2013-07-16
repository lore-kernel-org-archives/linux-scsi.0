From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: mpt2sas,mpt3sas watchdog device removal
Date: Tue, 16 Jul 2013 11:21:31 -0400
Message-ID: <20130716112131.03d019ab@jlaw-desktop.mno.stratus.com>
References: <20130515132401.6a8ff7fb@jlaw-desktop.mno.stratus.com>
	<20130515132948.7dc4c551@jlaw-desktop.mno.stratus.com>
	<DCD177647606E9419ED923E0C8C4AA723006C4AFF2@inbmail02.lsi.com>
	<1373976218.2148.49.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub4.stratus.com ([134.111.1.17]:37778 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab3GPPVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jul 2013 11:21:35 -0400
In-Reply-To: <1373976218.2148.49.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 16 Jul 2013 16:03:38 +0400
James Bottomley <James.Bottomley@hansenpartnership.com> wrote:

> On Tue, 2013-07-16 at 17:30 +0530, Reddy, Sreekanth wrote:
> > James,
> > 
> > This patch seem to be fine. Please consider this patch.
> 
> Where's the new version?  The one that has all of this fixed:
> 
> > Off list, Sreekanth from LSI tested and noticed a few issues with this
> > patch:
> > 
> >  - mpt2sas_base_stop_watchdog is called twice: The call from
> >    mpt2sas_base_detach is safe, but now unnecessary (as a call was
> >    added earlier up in the PCI driver callbacks to ensure that the
> >    watchdog was out of the way.) This second invocation can be
> > removed.
> > 
> >  - If the watchdog detects a bad IOC, the watchdog remains running:
> >    The watchdog workqueue isn't cleaned up until
> >    mpt2sas_base_stop_watchdog is called, so in the case that the
> >    watchdog removes the device from SCSI topo, the workqueue will
> >    remain unused until PCI .remove/.shutdown cleans it up. Perhaps a
> >    single watchdog that iterates over all adapters would be simpler?
> > 
> > Finally, if SCSI topo detachment is all that is interesting here,
> > would
> > it make more sense to move the watchdog into the MPT "scsi" code?  I
> > haven't looked at the code yet, but this might make an MPT fusion
> > patch
> > easier (due to dependencies between its "scsi" and "base" modules).

This patch fizzled out in May as other work took priority.  If LSI is
still interested in these changes, I can dust off my notes and
test/rebase for the 3.11 series.

A few of the issues quoted above are easily fixed, however I remember
having an outstanding question of how to best clean up the driver's
per device watchdog workqueue:

The way the MPT drivers are working right now is that the watchdog
workqueue function _base_fault_reset_work() initiates a PCI device
removal via kthread.  The PCI callback kthread context then tears down
the device and cancel/flush/destroys the watchdog workqueue.

This patch eliminated the kthread and its call into PCI API, simply
detaching from the SCSI midlayer.  In my opinion, the kthread
complicated device removal and introduced potential races if the
watchdog tried removing the device at the same time an ordinary device
removal request occurred. 

At the time, the best solution I had was to leave the unused workqueue
around until its PCI device was removed.

Regards,

-- Joe
