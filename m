From: Paul Wagland <paul@kungfoocoder.org>
Subject: megaraid: ABORTING problem
Date: Tue, 13 Apr 2004 16:26:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081866411.2111.11.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out1.xs4all.nl ([194.109.24.11]:26628 "EHLO
	smtp-out1.xs4all.nl") by vger.kernel.org with ESMTP id S263576AbUDMO0z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 10:26:55 -0400
Received: from umlsmtp.wagland.net (kungfucoder.org [80.126.186.202])
	by smtp-out1.xs4all.nl (8.12.10/8.12.10) with ESMTP id i3DEQsjK036381
	for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2004 16:26:54 +0200 (CEST)
Received: from [10.87.98.191] (unknown [10.87.98.191])
	by umlsmtp.wagland.net (Postfix) with ESMTP id C8D1656
	for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2004 16:26:53 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI mailing list <linux-scsi@vger.kernel.org>

Hi all,

In trying to do some performance analysis on my LSI Login SATA-150-6, I
set it off running bonnie against multiple filesystems against multiple
stripe sizes and RAID levels. Well, all was fine for about three days (I
was running a lot of tests ;-) and then I get back to my machine today
to discover that it was locked up, and the following was on the console:

megaraid: ABORTING-188cf36 cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf36[52], fw owner.
megaraid: ABORTING-188cf37 cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf37[51], fw owner.
megaraid: ABORTING-188cf38 cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf38[37], fw owner.
megaraid: ABORTING-188cf39 cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf39[3e], fw owner.
megaraid: ABORTING-188cf3a cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf3a[3], fw owner.
megaraid: ABORTING-188cf3b cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf3b[65], fw owner.
megaraid: ABORTING-188cf3c cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf3c[c], fw owner.
megaraid: ABORTING-188cf3d cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf3d[1e], fw owner.
megaraid: ABORTING-188cf3e cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf3e[57], fw owner.
megaraid: ABORTING-188cf3f cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf3f[b], fw owner.
megaraid: ABORTING-188cf40 cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf40[5d], fw owner.
megaraid: ABORTING-188cf41 cmd=2a <c=0 t=5 l=0>
megaraid: ABORTING-188cf41[5e], fw owner.


Does anyone know what is the cause of this failure?

I can see in the code that this comes out of the
megaraid_abort_and_reset() function, and this is in turn called by
megaraid_abort() and megaraid_reset(). These in turn appear to be called
from the SCSI layer? But why? And why did the machine hang?

Thanks in advance for any help,
Cheers,
Paul

