From: Jeremy Linton <jlinton@tributary.com>
Subject: [PATCH] SG_SCSI_RESET ioctl should only perform requested operation
Date: Mon, 4 Feb 2013 14:17:14 -0600
Message-ID: <5110174A.4080808@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:4899 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab3BDURW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2013 15:17:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi <linux-scsi@vger.kernel.org>

>From all the documentation I've found, it is not clear that users of the
SG_SCSI_RESET ioctl may have their requests progress up the hierarchy of reset
operations.

Basically, requests for a SCSI_TRY_RESET_DEVICE may eventually result in a
TARGET, BUS, or HOST reset. The sg_reset utility hints at the error handling,
but actually leads the user to believe that they should reissue the sg_reset
command themselves to enact more aggressive reset functions. It also says:
"Note that a host reset and a bus reset may cause collateral damage."

In the interest of error isolation, I have attached a patch which changes the
behavior. The existing behavior is obviously intentional, but I don't believe
its the best choice.

There are other alternatives to this patch. For one, to avoid the possibility of
breaking an existing application, maybe SG_SCSI_RESET needs some new values like
"SG_SCSI_RESET_DEVICE_ONLY". While leaving the existing operations alone.



Just in case...
Signed-off-by: Jeremy Linton <jlinton@tributary.com>
---
	
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..6f05bc2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1999,19 +1999,13 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
        switch (flag) {
        case SCSI_TRY_RESET_DEVICE:
                rtn = scsi_try_bus_device_reset(scmd);
-               if (rtn == SUCCESS)
-                       break;
-               /* FALLTHROUGH */
+               break;
        case SCSI_TRY_RESET_TARGET:
                rtn = scsi_try_target_reset(scmd);
-               if (rtn == SUCCESS)
-                       break;
-               /* FALLTHROUGH */
+               break;
        case SCSI_TRY_RESET_BUS:
                rtn = scsi_try_bus_reset(scmd);
-               if (rtn == SUCCESS)
-                       break;
-               /* FALLTHROUGH */
+               break;
        case SCSI_TRY_RESET_HOST:
                rtn = scsi_try_host_reset(scmd);
                break;
