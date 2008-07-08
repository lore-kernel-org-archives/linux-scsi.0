From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Tue,  8 Jul 2008 09:52:32 -0700 (PDT)
Message-ID: <20080708165232.8D5F9108035@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbYGHQxD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 12:53:03 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m68GqWsY025952
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2008 09:52:33 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045





------- Comment #7 from bjorn.helgaas@hp.com  2008-07-08 09:52 -------
On Tuesday 08 July 2008 08:08:46 am James Bottomley wrote:
> That said, this line:
> 
> mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
> 
> is absolutely characteristic of a lost interrupt.
> 
> With the current LSI driver, we have two possible causes for this.  One
> is the usual ACPI screw up that we never seem to be able to fix.

Which ACPI screw up is that?  And what's the usual recipe?

I know about the ancient "pci=routeirq" recipe, but as far as I know,
there are no current problems that require that.

> The 
> other is that the driver recently enabled MSI (commit
> 23a274c8a5adafc74a66f16988776fc7dd6f6e51 in v2.6.26-rc1).  For the
> former, just follow the usual ACPI screw up recipe.  For the latter, you
> should see this message in the boot up:
> 
> mptbase: ioc0: PCI-MSI enabled
> 
> MSI can be turned off again by using the module parameter
> mpt_msi_enable=0.
> 
> Unfortunately, the true fix is to find out if the motherboard really has
> a global MSI problem (and I know MSI works with the LSI because I have a
> 1030 in an ia64 system here working just fine) and add it to the PCI
> quirks file as unable to use MSI.
> 
> James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
