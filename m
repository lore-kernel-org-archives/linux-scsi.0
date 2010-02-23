From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15341] Load goes up very high when we traverse the large tree
Date: Tue, 23 Feb 2010 12:38:18 GMT
Message-ID: <201002231238.o1NCcIYb023017@demeter.kernel.org>
References: <bug-15341-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33932 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0BWMiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 07:38:18 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1NCcIYc023018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2010 12:38:18 GMT
In-Reply-To: <bug-15341-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15341





--- Comment #9 from Jens Axboe <axboe@kernel.dk>  2010-02-23 12:38:12 ---
That looks pretty funky, most processes are stuck waiting for IO or waiting for
others to finish their IO (on inode->i_mutex). If you switch to another IO
scheduler, does the problem go away? To do so, do:

# echo deadline > /sys/block/sda/queue/scheduler

(or use sdb, if that is the device in question) and repeat your find/du run.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
