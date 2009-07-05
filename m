From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13716] The AIC-7892P controller does not work any more
Date: Sun, 5 Jul 2009 19:51:29 GMT
Message-ID: <200907051951.n65JpTia022623@demeter.kernel.org>
References: <bug-13716-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43358 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbZGETv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2009 15:51:26 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n65JpTOU022624
	for <linux-scsi@vger.kernel.org>; Sun, 5 Jul 2009 19:51:29 GMT
In-Reply-To: <bug-13716-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13716





--- Comment #1 from Matthew Wilcox <matthew@wil.cx>  2009-07-05 19:51:29 ---
On Sun, Jul 05, 2009 at 07:23:18PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13716
> 
> The usual probe fails with an error message saying that no IRQ could be
> assigned to the controller, possibly due to a corrupt MP table.
> 
> The controller works fine with 2.6.30.1 and below.
> 
> This is how the adapter is normally initialized (messages from 2.6.29.6):
>     aic7xxx 0000:01:03.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
>     scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>     <Adaptec aic7892 Ultra160 SCSI adapter>
>     aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> 
> With 2.6.31-rc1, the kernel freezes with an error message and tries to restart
> the controller periodically, which always fails.

That sounds like you have an interrupt routing problem, not a problem
with the AIC driver.  Can you bisect this down to a particular commit?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
