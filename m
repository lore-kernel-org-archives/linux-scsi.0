From: Erik Ekman <erik@kryo.se>
Subject: [PATCH -tip] fusion: fix warning when not using procfs
Date: Mon, 14 Dec 2009 21:21:56 +0100
Message-ID: <20091214212156.7c9f18c2.erik@kryo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57443 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228AbZLNUWB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2009 15:22:01 -0500
Received: by bwz27 with SMTP id 27so2385009bwz.21
        for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2009 12:21:59 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: linux-scsi@vger.kernel.org

fusion: fix warning when not using procfs

Fixes the following warning:
drivers/message/fusion/mptbase.c:129: warning: 'mpt_proc_root_dir' defined but not used
also moves it from public data section since it is static.

Signed-off-by: Erik Ekman <erik@kryo.se>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 85bc6a6..cb2dc59 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -126,8 +126,6 @@ static int mfcounter = 0;
  *  Public data...
  */
 
-static struct proc_dir_entry *mpt_proc_root_dir;
-
 #define WHOINIT_UNKNOWN		0xAA
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -146,6 +144,9 @@ static MPT_EVHANDLER		 MptEvHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 static MPT_RESETHANDLER		 MptResetHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 static struct mpt_pci_driver 	*MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 
+#ifdef CONFIG_PROC_FS
+static struct proc_dir_entry 	*mpt_proc_root_dir;
+#endif
 
 /*
  *  Driver Callback Index's
