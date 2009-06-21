From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Sun, 21 Jun 2009 21:14:38 GMT
Message-ID: <200906212114.n5LLEcR2011098@demeter.kernel.org>
References: <bug-13594-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44341 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZFUVOf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2009 17:14:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5LLEcZq011099
	for <linux-scsi@vger.kernel.org>; Sun, 21 Jun 2009 21:14:38 GMT
In-Reply-To: <bug-13594-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13594





--- Comment #6 from Steinar H. Gunderson <sgunderson@bigfoot.com>  2009-06-21 21:14:37 ---
On Sun, Jun 21, 2009 at 08:53:37PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> I have just replicated the "ATA pass through information
> available" message report on a similar vintage LSI
> controller and a SATA disk with a recent smartctl
> version.
> 
> There is no need to report this in the kernel error log,
> as the smartmontools ATA pass-through (SCSI) command asked
> for the final state of the ATA registers and the sense
> buffer is the conduit for that information. That ASC/ASCQ
> pair basically means "you asked for them and here they
> are". [reference: sat2r07b.pdf section 12.2.5 table 107
> when CK_COND is 1]

OK, this is basically what we agreed on already. I'm not able to
test the given patch right now, though (the machine is a production
machine).

> As for the hiccup, I have noticed that with SAS (SCSI)
> disks from Seagate there is a curious sound and a pause
> before the response to LOG SENSE SCSI command (the
> type the smartmontools uses on SCSI disks).

FWIW, I've used the same disks on SATA controllers with smartctl
without any problems. I'm not entirely sure how to parse your
message, though -- do you imply that the problem is in smartctl?
The disk?

/* Steinar */

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
