Return-Path: <SRS0=ayNI=WD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EEBC433FF
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Aug 2019 11:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 167CF21BF6
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Aug 2019 11:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbfHGLnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 07:43:02 -0400
Received: from smtp.infotech.no ([82.134.31.41]:45272 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729735AbfHGLm7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Aug 2019 07:42:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id AC102204269;
        Wed,  7 Aug 2019 13:42:54 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3+unJidDQpug; Wed,  7 Aug 2019 13:42:54 +0200 (CEST)
Received: from xtwo70.infotech.no (unknown [82.134.31.183])
        by smtp.infotech.no (Postfix) with ESMTPA id 4C3AE204278;
        Wed,  7 Aug 2019 13:42:54 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v3 20/20] sg: bump version to 4.0.03
Date:   Wed,  7 Aug 2019 13:42:52 +0200
Message-Id: <20190807114252.2565-21-dgilbert@interlog.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190807114252.2565-1-dgilbert@interlog.com>
References: <20190807114252.2565-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that the sg version 4 interface is supported:
  - with ioctl(SG_IO) for synchronous/blocking use
  - with ioctl(SG_IOSUBMIT) and ioctl(SG_IORECEIVE) for
    async/non-blocking use
Plus new ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3)
potentially replace write() and read() for the sg
version 3 interface. Bump major driver version number
from 3 to 4.

The main new feature is the removal of the fixed 16 element
array of requests per file descriptor. It is replaced by
two lists: one for active (inflight) requests and a free
list. Also sg_requests objects are not freed until the
owning file descriptor is closed; rather these objects
are re-used when multiple commands are sent to the same
file descriptor.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 82c4147ba4f1..3ad88e18a5ac 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -12,9 +12,9 @@
  *
  */
 
-static int sg_version_num = 30901;  /* [x]xyyzz where [x] empty when x=0 */
-#define SG_VERSION_STR "3.9.01"		/* [x]x.[y]y.zz */
-static char *sg_version_date = "20190606";
+static int sg_version_num = 40003;  /* [x]xyyzz where [x] empty when x=0 */
+#define SG_VERSION_STR "4.0.03"		/* [x]x.[y]y.zz */
+static char *sg_version_date = "20190612";
 
 #include <linux/module.h>
 
-- 
2.22.0

