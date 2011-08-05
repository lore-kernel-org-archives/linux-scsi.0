From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26692] Fusion MPT SPI bringup takes 80 seconds when the kernel
 is quiet
Date: Fri, 5 Aug 2011 20:55:55 GMT
Message-ID: <201108052055.p75Ktt9E001015@demeter2.kernel.org>
References: <bug-26692-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:36138 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab1HEUzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2011 16:55:55 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p75Ktt2F001068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 5 Aug 2011 20:55:55 GMT
In-Reply-To: <bug-26692-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=26692


Jonathan Nieder <jrnieder@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jrnieder@gmail.com




--- Comment #2 from Jonathan Nieder <jrnieder@gmail.com>  2011-08-05 20:55:52 ---
If I am reading the first log at <http://bugs.debian.org/607906> correctly, the
oops happened in the READ32 of

        /* Read doorbell and check for active bit */
        if (!(CHIPREG_READ32(&ioc->chip->Doorbell) & MPI_DOORBELL_ACTIVE))
                return -5;

But that's only from a quick look, and it doesn't make sense in light of your
later observations.

Would it be possible to sprinkle the code with printk calls to figure out
what's causing trouble (and for example where time is being spent in the
current version)?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
