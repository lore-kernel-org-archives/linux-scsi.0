From: Brian King <brking@us.ibm.com>
Subject: [PATCH] ipr operational timeout oops
Date: Thu, 27 May 2004 21:55:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B6AA1C.4080603@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070800050703000409090404"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:23998 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262101AbUE1Cz0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 22:55:26 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070800050703000409090404
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James,

Here's one more. Please apply.

Thanks

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------070800050703000409090404
Content-Type: text/plain;
 name="ipr_ioa_reset_timeout_oops2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_ioa_reset_timeout_oops2.patch"


This patch fixes an oops that can occur if an adapter times
out coming operational.


---

 linux-2.6.7-rc1-bjking1/drivers/scsi/ipr.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_ioa_reset_timeout_oops2 drivers/scsi/ipr.c
--- linux-2.6.7-rc1/drivers/scsi/ipr.c~ipr_ioa_reset_timeout_oops2	2004-05-26 17:22:17.000000000 -0500
+++ linux-2.6.7-rc1-bjking1/drivers/scsi/ipr.c	2004-05-26 17:22:36.000000000 -0500
@@ -4818,6 +4818,7 @@ static int ipr_reset_enable_ioa(struct i
 	ipr_cmd->timer.data = (unsigned long) ipr_cmd;
 	ipr_cmd->timer.expires = jiffies + IPR_OPERATIONAL_TIMEOUT;
 	ipr_cmd->timer.function = (void (*)(unsigned long))ipr_timeout;
+	ipr_cmd->done = ipr_reset_ioa_job;
 	add_timer(&ipr_cmd->timer);
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->pending_q);
 

_

--------------070800050703000409090404
Content-Type: text/plain;
 name="ipr_driver_version_2_0_9.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_driver_version_2_0_9.patch"


Bump driver version


---

 linux-2.6.7-rc1-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_0_9 drivers/scsi/ipr.h
--- linux-2.6.7-rc1/drivers/scsi/ipr.h~ipr_driver_version_2_0_9	2004-05-26 22:29:56.000000000 -0500
+++ linux-2.6.7-rc1-bjking1/drivers/scsi/ipr.h	2004-05-26 22:30:13.000000000 -0500
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.0.8"
-#define IPR_DRIVER_DATE "(May 23, 2004)"
+#define IPR_DRIVER_VERSION "2.0.9"
+#define IPR_DRIVER_DATE "(May 26, 2004)"
 
 /*
  * IPR_DBG_TRACE: Setting this to 1 will turn on some general function tracing

_

--------------070800050703000409090404--

