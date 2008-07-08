From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Tue,  8 Jul 2008 10:24:03 -0700 (PDT)
Message-ID: <20080708172403.7CA61108038@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602AbYGHRYX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 13:24:23 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m68HO3uS032205
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2008 10:24:04 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045





------- Comment #8 from anonymous@kernel-bugs.osdl.org  2008-07-08 10:24 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2008-07-08 at 10:51 -0600, Bjorn Helgaas wrote:
> On Tuesday 08 July 2008 08:08:46 am James Bottomley wrote:
> > That said, this line:
> > 
> > mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
> > 
> > is absolutely characteristic of a lost interrupt.
> > 
> > With the current LSI driver, we have two possible causes for this.  One
> > is the usual ACPI screw up that we never seem to be able to fix.
> 
> Which ACPI screw up is that?  And what's the usual recipe?

The usual screw up where subtle ACPI breakage from release to release
causes some IRQs to get misrouted.

Usually you start with noacpi and cycle through the pci routing options

> I know about the ancient "pci=routeirq" recipe, but as far as I know,
> there are no current problems that require that.

If you actually read this bug report, you'll see there was a message

ACPI: Resource is not an IRQ entry

Just before the fusion IRQ failed to get delivered, so I think it's a
good indicator that there *are* ACPI problems ...

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
