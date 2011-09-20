From: akpm@google.com
Subject: [patch 8/8] drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCallbacksName elements
Date: Tue, 20 Sep 2011 14:20:25 -0700
Message-ID: <201109202120.p8KLKQPN018641@hpaq1.eem.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:54878 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1ITVUh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 17:20:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@google.com, wferi@niif.hu, kashyap.desai@lsi.com

From: Ferenc Wagner <wferi@niif.hu>
Subject: drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCallbacksName elements

I just stumbled upon this while pondering over
https://bugzilla.kernel.org/show_bug.cgi?id=26692 and thought this could
be made better.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Cc: Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/message/fusion/mptbase.c |    7 ++++---
 drivers/message/fusion/mptbase.h |    1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements
+++ a/drivers/message/fusion/mptbase.c
@@ -115,7 +115,8 @@ module_param(mpt_fwfault_debug, int, 060
 MODULE_PARM_DESC(mpt_fwfault_debug,
 		 "Enable detection of Firmware fault and halt Firmware on fault - (default=0)");
 
-static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][50];
+static char
+MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][MPT_MAX_CALLBACKNAME_LEN + 1];
 
 #ifdef MFCNT
 static int mfcounter = 0;
@@ -717,8 +718,8 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DR
 			MptDriverClass[cb_idx] = dclass;
 			MptEvHandlers[cb_idx] = NULL;
 			last_drv_idx = cb_idx;
-			memcpy(MptCallbacksName[cb_idx], func_name,
-			    strlen(func_name) > 50 ? 50 : strlen(func_name));
+			strlcpy(MptCallbacksName[cb_idx], func_name,
+				MPT_MAX_CALLBACKNAME_LEN+1);
 			break;
 		}
 	}
diff -puN drivers/message/fusion/mptbase.h~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements
+++ a/drivers/message/fusion/mptbase.h
@@ -89,6 +89,7 @@
  */
 #define MPT_MAX_ADAPTERS		18
 #define MPT_MAX_PROTOCOL_DRIVERS	16
+#define MPT_MAX_CALLBACKNAME_LEN	49
 #define MPT_MAX_BUS			1	/* Do not change */
 #define MPT_MAX_FC_DEVICES		255
 #define MPT_MAX_SCSI_DEVICES		16
_
