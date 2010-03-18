From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15565] SCSI Generic queueing completes commands in reverse
 order
Date: Thu, 18 Mar 2010 17:21:10 GMT
Message-ID: <201003181721.o2IHLAFg009271@demeter.kernel.org>
References: <bug-15565-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40262 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab0CRRVM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2010 13:21:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2IHLAJo009272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2010 17:21:10 GMT
In-Reply-To: <bug-15565-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15565





--- Comment #4 from Mike Hayward <mh-linux-kernel@loup.net>  2010-03-18 17:21:05 ---
Hi Boaz,

 > I have fixed that for bsg long ago. There is a flag
 > that you put:
 >     sg.flags = BSG_FLAG_Q_AT_TAIL;
 > Which will do the by order, queue at tail. Zero was kept compatible
 > to sg meaning "queue at head" i.e. jump the line.
 > 
 > It could be added to sg as well if needed

I think that would be a huge improvement for disk drives.

Isn't BSG driven with a blocking ioctl?  Maybe I'm using old docs, but
from the HOWTO's I've read, I was under the impression it would issue
one SCSI command at a time and block until it completed.  Queueing
would effectively only be possible then with multiple threads, right?

Since sg allows multiple (only 16 right now) ios to be queued
nonblocking to a block device from a single threaded process,
an SG_FLAG_Q_AT_TAIL flag would seem particularly relevant.

Nonblocking behavior is the primary reason why I am using sg... it
seems really inefficient and complex to use dozens of threads and ipc
just to try to submit a queue of ios to the kernel and hence a device.

If bsg actually allowed tasks to be queued nonblocking like sg, I'd
switch in a heart beat since having two filesystem names for the same
device introduces locking problems, name translation complexity, and
confusion in general for administrators.

- Mike

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
