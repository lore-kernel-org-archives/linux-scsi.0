Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E51C3567B
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 17:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 310452469F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 17:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgB0RAE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 12:00:04 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47335 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbgB0RAE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Feb 2020 12:00:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 5D9F120416A;
        Thu, 27 Feb 2020 18:00:02 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jRETvg1c65WO; Thu, 27 Feb 2020 18:00:00 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 8DF8320419B;
        Thu, 27 Feb 2020 17:59:53 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v7 38/38] sg: bump version to 4.0.08
Date:   Thu, 27 Feb 2020 11:59:02 -0500
Message-Id: <20200227165902.11861-39-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227165902.11861-1-dgilbert@interlog.com>
References: <20200227165902.11861-1-dgilbert@interlog.com>
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
 drivers/scsi/sg.c      | 8 ++++----
 include/uapi/scsi/sg.h | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 24c4a539eae0..9ab70ec2a9ef 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -8,13 +8,13 @@
  * Original driver (sg.c):
  *        Copyright (C) 1992 Lawrence Foard
  * Version 2, 3 and 4 extensions to driver:
- *        Copyright (C) 1998 - 2019 Douglas Gilbert
+ *        Copyright (C) 1998 - 2020 Douglas Gilbert
  *
  */
 
-static int sg_version_num = 30901;  /* [x]xyyzz where [x] empty when x=0 */
-#define SG_VERSION_STR "3.9.01"		/* [x]x.[y]y.zz */
-static char *sg_version_date = "20190606";
+static int sg_version_num = 40008;  /* [x]xyyzz where [x] empty when x=0 */
+#define SG_VERSION_STR "4.0.08"		/* [x]x.[y]y.zz */
+static char *sg_version_date = "20200227";
 
 #include <linux/module.h>
 
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index cbade2870355..947073ef26dc 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -12,9 +12,9 @@
  *   Copyright (C) 1992 Lawrence Foard
  *
  * Later extensions (versions 2, 3 and 4) to driver:
- *   Copyright (C) 1998 - 2018 Douglas Gilbert
+ *   Copyright (C) 1998 - 2020 Douglas Gilbert
  *
- * Version 4.0.11 (20190502)
+ * Version 4.0.11 (20200124)
  *  This version is for Linux 4 and 5 series kernels.
  *
  * Documentation
-- 
2.25.1

