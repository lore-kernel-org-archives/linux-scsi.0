From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13499] Write cache: disabled, read cache: enabled, supports DPO
 and FUA? it's  bug???
Date: Wed, 10 Jun 2009 14:14:14 GMT
Message-ID: <200906101414.n5AEEEEZ004285@demeter.kernel.org>
References: <bug-13499-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41252 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZFJOOM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 10:14:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5AEEEm7004286
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 14:14:14 GMT
In-Reply-To: <bug-13499-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13499





--- Comment #2 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-06-10 14:14:13 ---
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2009-06-10 at 14:00 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> why Write cache: disabled??

The SCSI mid layer is merely reporting what your array is telling it.
For arrays without a battery backed cache, write through configuration
(i.e. read cache enabled, write cache disabled) is the usual safe
default.

You can alter your write cache settings using Doug Gilbert's
sg3-utils ... but be warned, enabling the write cache without battery
backing in an array is a dangerous thing to do since most arrays have
huge caches, they either ignore SYNCHRONIZE CACHE (which would leave you
vulnerable to data loss on power failure) or take such a long time, it
would kill performance.

James

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
