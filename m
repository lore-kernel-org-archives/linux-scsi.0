From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11990] Kernel hang in spin_unlock_irq from scsi_request_fn from do_IRQ
Date: Sun,  9 Nov 2008 01:57:51 -0800 (PST)
Message-ID: <20081109095751.F3CB0108043@picon.linux-foundation.org>
References: <bug-11990-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017AbYKIJ5y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 04:57:54 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA99vqi4014896
	for <linux-scsi@vger.kernel.org>; Sun, 9 Nov 2008 01:57:53 -0800
In-Reply-To: <bug-11990-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11990





------- Comment #1 from vandrove@vc.cvut.cz  2008-11-09 01:57 -------
Apparently my lower bound test kernel did not had Jens's patch to use tagged
queuing from SCSI layer applied.  I've discovered reliable test case (write 4GB
of data concurrently to every attached disk), and found that reverting all 4
SATA tagged queueing related checkins gets rid of the problem:

43a49cbdf31e812c0d8f553d433b09b421f5d52c
3070f69b66b7ab2f02d8a2500edae07039c38508
e013e13bf605b9e6b702adffbe2853cfc60e7806
2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
