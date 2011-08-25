From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [PATCH v2] SCSI: fusion: ensure NUL-termination of MptCallbacksName elements
Date: Thu, 25 Aug 2011 14:44:57 +0200
Message-ID: <de055eaa97e98b8cf9b61215c2f89c1467e0cec8.1321625407.git.wferi@niif.hu>
References: <cd21dfb714e3a89aadd8eda1fda1748dec9ed7aa.1314276422.git.wferi@niif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cd21dfb714e3a89aadd8eda1fda1748dec9ed7aa.1314276422.git.wferi@niif.hu>
	(Ferenc Wagner's message of "Thu, 25 Aug 2011 14:44:57 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kashyap, Desai" <kashyap.desai@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Using strlcpy instead of memcpy makes the strlen() calls superfluous
and also ensures zero-termination of the copied string.
At the same time get rid of the magic constant 50.

Actually, I can't see why copying the callback name is necessary
instead of simply storing a pointer to it (just like to the callback
function itself), but that goes beyond the scope of this fix.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/message/fusion/mptbase.c |    7 ++++---
 drivers/message/fusion/mptbase.h |    1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e9c6a60..a7dc467 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -115,7 +115,8 @@ module_param(mpt_fwfault_debug, int, 0600);
 MODULE_PARM_DESC(mpt_fwfault_debug,
 		 "Enable detection of Firmware fault and halt Firmware on fault - (default=0)");
 
-static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][50];
+static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS]
+				[MPT_MAX_CALLBACKNAME_LEN+1];
 
 #ifdef MFCNT
 static int mfcounter = 0;
@@ -717,8 +718,8 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass, char *func_name)
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
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index b4d24dc..76c05bc 100644
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
