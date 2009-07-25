From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Sat, 25 Jul 2009 03:33:52 GMT
Message-ID: <200907250333.n6P3Xqk5020041@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37000 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbZGYDdw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2009 23:33:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6P3XqFU020042
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2009 03:33:52 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783


Tejun Heo <tj@kernel.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tj@kernel.org




--- Comment #12 from Tejun Heo <tj@kernel.org>  2009-07-25 03:33:49 ---
Hmmm... interesting.  Can someone please strace the polling process and see
what's going on?  Attaching strace to the hal-addon-storage should do the
trick, Kay, right?  It could be that TUR result is alternating.  The problem
probably is that windows doesn't use TUR while polling for media presence while
we do.  There are drives which completely check out after being polled for a
while and this bug report looks like another strain of the same problem.  I'll
try to implement media presence polling inside kernel and use only
GET_EVENT_STATUS_NOTIFICATION as windows does.  Please cc anyone with
reproducible problem cases here.

Thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
