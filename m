From: akpm@linux-foundation.org
Subject: [patch 6/6] drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCallbacksName elements
Date: Tue, 15 Nov 2011 14:58:19 -0800
Message-ID: <201111152258.pAFMwKDF008017@wpaz5.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:57403 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1KOW6X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2011 17:58:23 -0500
Received: by eyg5 with SMTP id 5so200807eyg.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2011 14:58:22 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, wferi@niif.hu, kashyap.desai@lsi.com

From: Ferenc Wagner <wferi@niif.hu>
Subject: drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCallbacksName elements

I just stumbled upon this while pondering over
https://bugzilla.kernel.org/show_bug.cgi?id=26692 and thought this could
be made better.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Cc: Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
