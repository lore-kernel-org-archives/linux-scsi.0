From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35282] BUG() in 2.6.38.6
Date: Sat, 21 May 2011 21:40:18 GMT
Message-ID: <201105212140.p4LLeIcj023214@demeter1.kernel.org>
References: <bug-35282-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:35752 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab1EUVkT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 May 2011 17:40:19 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4LLeI3t023216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 21 May 2011 21:40:18 GMT
In-Reply-To: <bug-35282-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35282





--- Comment #4 from Fabio Coatti <fabio.coatti@gmail.com>  2011-05-21 21:40:17 ---
Ok, just tried (I've had to apply the patch manually, as my
include/linux/blkdev.h is slightly different and patch complained a bit, see
below).
Now it works, the kernel is able to boot correctly and I'm writing from
2.6.38.6.

Many thanks for your time!

PS: actual blkdev.h on my machine:

static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
{
        WARN_ON_ONCE(!queue_is_locked(q));
        __clear_bit(flag, &q->queue_flags);
(473)}

#define blk_queue_plugged(q)    test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
#define blk_queue_tagged(q)     test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
#define blk_queue_stopped(q)    \
       (test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags) || \
       test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags))
#define blk_queue_nomerges(q)   test_bit(QUEUE_FLAG_NOMERGES,
&(q)->queue_flags)
#define blk_queue_noxmerges(q)  \

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
