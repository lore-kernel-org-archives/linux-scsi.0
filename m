From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 64141] [BISECTED]3w-9xxx times out if MSI disabled during
 enumeration
Date: Tue, 03 Jun 2014 22:58:59 +0000
Message-ID: <bug-64141-11613-fBy74VL2ej@https.bugzilla.kernel.org/>
References: <bug-64141-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40312 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbaFCW7E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2014 18:59:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B6EF020212
	for <linux-scsi@vger.kernel.org>; Tue,  3 Jun 2014 22:59:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D21A12026C
	for <linux-scsi@vger.kernel.org>; Tue,  3 Jun 2014 22:59:00 +0000 (UTC)
In-Reply-To: <bug-64141-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=64141

Bjorn Helgaas <bhelgaas@google.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|PCI                         |Other
           Assignee|drivers_pci@kernel-bugs.osd |scsi_drivers-other@kernel-b
                   |l.org                       |ugs.osdl.org
            Product|Drivers                     |SCSI Drivers

--- Comment #2 from Bjorn Helgaas <bhelgaas@google.com> ---
I think this is a 3w-9xxx driver defect, so I'm reassigning to SCSI.  Here's my
rationale (from the email thread mentioned above):

  ... twa_probe() looks strange to me.  The other drivers I looked at
  do all their PCI initialization before the scsi_host_alloc() /
  scsi_add_host() / scsi_scan_host() stuff.  But twa_probe() has PCI
  stuff scattered around between those three SCSI calls.  In particular,
  it does the MSI setup way down near the end, after scsi_add_host(),
  which seems like just the sort of thing that could explain this problem.

Let me know if this seems like the wrong thing to do.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
