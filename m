From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 00/52] [resend] atp870u: Major rework
Date: Tue, 17 Nov 2015 19:23:36 +0100
Message-ID: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56421 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbbKQSYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:24:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

This patch series removes the first level of crap from atp870u - the worst
(in-tree) SCSI driver [1] and then cleans up the code a bit.

First the driver is converted to C from something that looks like a (bad)
assembler code: use of tmport for all I/O accesses and gotos all over the
code.
Then I/O access wrappers are introduced.
Finally, is870, is880 and is885 are unified and two of them removed.

After that, some cleanups are done. There's still a lot of work left to do.

Tested on AEC-6710D (ATP870IU-C).

[1] http://www.spinics.net/lists/linux-scsi/msg81142.html

 atp870u.c | 3707 +++++++++++++++++---------------------------------------------
 atp870u.h |    4
 2 files changed, 1064 insertions(+), 2647 deletions(-)

Reviewed-by: Hannes Reinecke <hare@suse.com>
Acked-by: Christoph Hellwig <hch@lst.de>

