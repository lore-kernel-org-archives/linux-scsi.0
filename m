From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 00/52] atp870u: Major rework
Date: Sun, 26 Jul 2015 22:24:07 +0200
Message-ID: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56647 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbbGZU4O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2015 16:56:14 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1ZJSTt-0003IN-Ah
	for linux-scsi@vger.kernel.org; Sun, 26 Jul 2015 22:25:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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

Partially (up to patch 34) Acked-by: Christoph Hellwig <hch@lst.de>

-- 
Ondrej Zary

