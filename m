From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15288] kernel 2.6.31 loading goes in loop on IBM xSeries 330
Date: Fri, 12 Feb 2010 21:15:50 GMT
Message-ID: <201002122115.o1CLFof8005337@demeter.kernel.org>
References: <bug-15288-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42266 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0BLVPu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 16:15:50 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1CLFoeH005341
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 12 Feb 2010 21:15:50 GMT
In-Reply-To: <bug-15288-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15288





--- Comment #4 from Matthew Wilcox <matthew@wil.cx>  2010-02-12 21:15:42 ---
On Fri, Feb 12, 2010 at 08:28:24PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> --- Comment #3 from Andrew Morton <akpm@linux-foundation.org>  2010-02-12 20:28:19 ---
> I'll reassign this regression to scsi.
> 
> I reattached the most interesting jpg screenshot: scsi_async_scan got stuck.

This probably isn't anything to do with the scsi async scan (boot with
scsi_mod.scan=sync to eliminate the possibility).  It's probably a driver
failing to finish the scan.  Probably the reason for that is broken
interrupt routing.  But that's a lot of probables, so some investigation
with scsi_mod.scan=sync should be used to confirm the first hypothesis
before assigning the blame elsewhere.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
