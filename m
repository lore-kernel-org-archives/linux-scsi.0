From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Wed,  9 Jul 2008 01:19:29 -0700 (PDT)
Message-ID: <20080709081929.58B0D11D109@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbYGIITc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 04:19:32 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m698JT3x018045
	for <linux-scsi@vger.kernel.org>; Wed, 9 Jul 2008 01:19:30 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045





------- Comment #12 from anonymous@kernel-bugs.osdl.org  2008-07-09 01:19 -------
Reply-To: sathya.prakash@lsi.com

This may  be a problem due to enabling MSI for SPI controllers. I have posted
another message in the list providing the correction patch which is already in
scsi-misc tree. 
If the problem is gone with changing the module parameter mpt_msi_enable=0 or
by applying the patch http://marc.info/?l=linux-scsi&m=121131228827682&w=4 then
it might be due to MSI enabling.


On Tue, Jul 08, 2008 at 05:57:35PM -0400, James Bottomley wrote:
> On Tue, 2008-07-08 at 14:47 -0700, Andrew Morton wrote:
> > On Tue, 8 Jul 2008 14:56:53 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >
> > > On Tuesday 08 July 2008 11:23:33 am James Bottomley wrote:
> > > > On Tue, 2008-07-08 at 10:51 -0600, Bjorn Helgaas wrote:
> > > > > Which ACPI screw up is that?  And what's the usual recipe?
> > > >
> > > > The usual screw up where subtle ACPI breakage from release to release
> > > > causes some IRQs to get misrouted.
> > > >
> > > > Usually you start with noacpi and cycle through the pci routing options
> > >
> > > Don't worry, I wasn't trying to talk you out of an ACPI bug report;
> > > I just wanted to get enough specifics so I could see whether it was
> > > something I could fix.
> > >
> > > > If you actually read this bug report, you'll see there was a message
> > > >
> > > > ACPI: Resource is not an IRQ entry
> > > >
> > > > Just before the fusion IRQ failed to get delivered, so I think it's a
> > > > good indicator that there *are* ACPI problems ...
> > >
> > > These messages also happen with 2.6.25, where the MPT Fusion driver
> > > worked, so Kurk opened a separate bugzilla,
> > >   http://bugzilla.kernel.org/show_bug.cgi?id=11049
> > > for them.
> > >
> > > Yakui Zhao thinks the messages are harmless because they're
> > > related to interrupt link devices that we don't use in IOAPIC mode,
> > > and given that the driver works in 2.6.25, that seems plausible
> > > to me.
> > >
> > > Regardless, the messages are alarming and annoying.  I'd like
> > > to understand them better, but I'll pursue that in the 11049
> > > bugzilla.
> > >
> >
> > Let us not forget the other part of this report:
> >
> > BUG: unable to handle kernel NULL pointer dereference at 0000034c
> > IP: [<f885cc5e>] :mptspi:mptspi_dv_renegotiate_work+0xa/0x9f
> > Oops: 0000 [#1] SMP
> 
> That's fixed in the scsi-rc-fixes tree ... but it's a symptom, not a
> cause.  If essential storage is on this adapter, the system will still
> be unbootable.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
