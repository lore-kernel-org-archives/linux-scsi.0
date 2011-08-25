From: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH] [SCSI] fusion: ensure NUL-termination of MptCallbacksName elements
Date: Thu, 25 Aug 2011 14:44:57 +0200
Message-ID: <cd21dfb714e3a89aadd8eda1fda1748dec9ed7aa.1314276422.git.wferi@niif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:35033 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1HYN3I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2011 09:29:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap@tac.ki.iif.hu, Desai <kashyap.desai@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/message/fusion/mptbase.c |    5 ++---
 drivers/message/fusion/mptbase.h |    1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 7956a10..eb906e2 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -113,7 +113,7 @@ module_param(mpt_fwfault_debug, int, 0600);
 MODULE_PARM_DESC(mpt_fwfault_debug,
 		 "Enable detection of Firmware fault and halt Firmware on fault - (default=0)");
 
-static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][50];
+static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][MPT_MAX_CALLBACKNAME_LEN+1];
 
 #ifdef MFCNT
 static int mfcounter = 0;
@@ -656,8 +656,7 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass, char *func_name)
 			MptDriverClass[cb_idx] = dclass;
 			MptEvHandlers[cb_idx] = NULL;
 			last_drv_idx = cb_idx;
-			memcpy(MptCallbacksName[cb_idx], func_name,
-			    strlen(func_name) > 50 ? 50 : strlen(func_name));
+			strlcpy(MptCallbacksName[cb_idx], func_name, MPT_MAX_CALLBACKNAME_LEN+1);
 			break;
 		}
 	}
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index fe90233..c10416d 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -89,6 +89,7 @@
  */
 #define MPT_MAX_ADAPTERS		18
 #define MPT_MAX_PROTOCOL_DRIVERS	16
+#define MPT_MAX_CALLBACKNAME_LEN	49
 #define MPT_MAX_BUS			1	/* Do not change */
 #define MPT_MAX_FC_DEVICES		255
 #define MPT_MAX_SCSI_DEVICES		16
-- 
1.6.5

