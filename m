From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch 1/4]  ibmvscsi.c: replace schedule_timeout() with msleep()
Date: Mon, 29 Nov 2004 14:29:25 -0600
Message-ID: <20041129202925.GA31011@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.202]:12949 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S261786AbUK2U31 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 15:29:27 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 38D625C36A
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 14:29:27 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (augustus [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 18856-01-6 for <linux-scsi@vger.kernel.org>;
 Mon, 29 Nov 2004 14:29:25 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id DC5055C353
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 14:29:25 -0600 (CST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Description: Use msleep() instead of schedule_timeout()
to guarantee the task delays as expected.  Originally
submitted to linux-scsi by the janitors, and resubmitted
by boutcher (after testing :-)

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>
---

 linux-2.6.9-max/drivers/scsi/ibmvscsi/ibmvscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~msleep-drivers_scsi_ibmvscsi drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6.9/drivers/scsi/ibmvscsi/ibmvscsi.c~msleep-drivers_scsi_ibmvscsi	2004-10-21 02:41:22.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-10-21 02:41:22.000000000 +0200
@@ -69,6 +69,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/dma-mapping.h>
+#include <linux/delay.h>
 #include <asm/vio.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1327,8 +1328,7 @@ static int ibmvscsi_probe(struct vio_dev
 		     time_before(jiffies, wait_switch) &&
 		     atomic_read(&hostdata->request_limit) < 0;) {
 
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(HZ / 100);
+			msleep(10);
 		}
 
 		/* if we now have a valid request_limit, initiate a scan */
-- 
Dave Boutcher
