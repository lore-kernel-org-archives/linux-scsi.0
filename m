From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue,  4 Nov 2008 17:32:05 -0800 (PST)
Message-ID: <20081105013205.816CA108057@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753730AbYKEBci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 20:32:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA51W5mv005065
	for <linux-scsi@vger.kernel.org>; Tue, 4 Nov 2008 17:32:06 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #9 from alex.shi@intel.com  2008-11-04 17:32 -------
I did bisect for this bug and find the following commit cause this problem.

commit f0c0a376d0fcd4c5579ecf5e95f88387cba85211
Author: Mike Christie <michaelc@cs.wisc.edu>
Date:   Sun Aug 17 15:24:38 2008 -0500

    [SCSI] Add helper code so transport classes/driver can control queueing
(v3)

    SCSI-ml manages the queueing limits for the device and host, but
    does not do so at the target level. However something something similar
    can come in userful when a driver is transitioning a transport object to
    the the blocked state, becuase at that time we do not want to queue
    io and we do not want the queuecommand to be called again.


Alex 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
