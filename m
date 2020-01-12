Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794D7C33CA9
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595C520724
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbgALX6o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 18:58:44 -0500
Received: from smtp.infotech.no ([82.134.31.41]:52107 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387583AbgALX6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jan 2020 18:58:43 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B476120415B;
        Mon, 13 Jan 2020 00:58:42 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ok8khGidAoYZ; Mon, 13 Jan 2020 00:58:41 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [213.52.86.138])
        by smtp.infotech.no (Postfix) with ESMTPA id 4D7CC2042B4;
        Mon, 13 Jan 2020 00:58:02 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v6 37/37] sg: bump version to 4.0.08
Date:   Mon, 13 Jan 2020 00:57:55 +0100
Message-Id: <20200112235755.14197-38-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200112235755.14197-1-dgilbert@interlog.com>
References: <20200112235755.14197-1-dgilbert@interlog.com>
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
a xarray (eXtensible array) in their parent which is a
sg_fd object (i.e. a file descriptor). The sg_request
objects are not freed until the owning file descriptor is
closed; instead these objects are re-used when multiple
commands are sent to the same file descriptor.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5b0de8dab05d..9599caa1a05d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -12,9 +12,9 @@
  *
  */
 
-static int sg_version_num = 30901;  /* [x]xyyzz where [x] empty when x=0 */
-#define SG_VERSION_STR "3.9.01"		/* [x]x.[y]y.zz */
-static char *sg_version_date = "20190606";
+static int sg_version_num = 40008;  /* [x]xyyzz where [x] empty when x=0 */
+#define SG_VERSION_STR "4.0.08"		/* [x]x.[y]y.zz */
+static char *sg_version_date = "20200101";
 
 #include <linux/module.h>
 
-- 
2.24.1

