From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] mount -w of dvd+rw etc. in vanilla 2.6
Date: 10 Sep 2003 14:08:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063224520.3669.115.camel@patehci2>
References: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
	 <1063217791.3669.43.camel@patehci2>  <1063219776.3669.72.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:21134 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265616AbTIJUHh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 16:07:37 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 07E4214C1
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2003 14:07:37 -0600 (MDT)
In-Reply-To: <1063219776.3669.72.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Seemingly linux disagrees with itself over how writable profiles are:

# /sbin/blockdev --setro /dev/scd1
# /sbin/blockdev --getro /dev/scd1
1
# dd of=/dev/scd1 if=/dev/zero bs=2K count=1
dd: opening `/dev/scd1': Read-only file system
#

So far so good, but then:

# /sbin/blockdev --setrw /dev/scd1
# /sbin/blockdev --getro /dev/scd1
0
# dd of=/dev/scd1 if=/dev/zero bs=2K count=1
dd: opening `/dev/scd1': Read-only file system
#

That is, no matter if --getro is 0 or 1, still we do not write.  The
default I see here is 0, but still I cannot write.

Pat LaVarre



