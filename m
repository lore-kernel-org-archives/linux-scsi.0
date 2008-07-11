From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Fri, 11 Jul 2008 07:06:05 -0700 (PDT)
Message-ID: <20080711140605.4A5CA108045@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbYGKOG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 10:06:26 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6BE65E1007866
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2008 07:06:06 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045





------- Comment #21 from anonymous@kernel-bugs.osdl.org  2008-07-11 07:06 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Fri, 2008-07-11 at 12:33 +0800, Prakash, Sathya wrote:
> I did a recheck on this, except FC 919X and 929X boards, everything
> else should work fine with MSI. Hence the SPI boards (1030) should
> work with MSI and the problem might be with the motherboard.

Right ... that's why I was asking ... my 1030 works fine with MSI.  If
there's a fault with the FC boards, then certainly they should have MSI
disabled.

The motherboard was my suspicion ... especially as older ones have SPI
and newer ones have SAS (and the older ones are most likely to have MSI
faults).  However, I think you can see from our point of view that if
the problem is the motherboard, disabling MSI in the fusion is the wrong
way to fix it.  If we do it this way, we'll promptly get another slew of
nasty bug reports for the next driver that enables MSI and doesn't work
on this platform

> But we would like to keep the MSI disabled for SPI controllers since
> we have not tested internally with MSI and FC enabled by default for
> them in our recent drivers.
> So I would like to request to pull in the patch to disable MSI for SPI & FC.

Yes, we'll do that ... I'll also see if the PCI maintainer can determine
the information needed to blacklist the motherboards so that we don't
get this all over again with them and a different driver.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
