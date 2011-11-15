From: akpm@linux-foundation.org
Subject: [patch 2/6] drivers/scsi/megaraid.c: fix sparse warnings
Date: Tue, 15 Nov 2011 14:58:11 -0800
Message-ID: <201111152258.pAFMwBbX007699@wpaz5.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:34924 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1KOXGC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2011 18:06:02 -0500
Received: by mail-ey0-f202.google.com with SMTP id 5so200919eyg.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2011 15:06:01 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, rdunlap@xenotime.net, megaraidlinux@lsi.com, viro@ZenIV.linux.org.uk

From: Randy Dunlap <rdunlap@xenotime.net>
Subject: drivers/scsi/megaraid.c: fix sparse warnings

Fix sparse warnings of right shift bigger than source value size:

drivers/scsi/megaraid.c:311:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:313:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:317:67: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:319:67: warning: right shift by bigger than source value

Patch suggestion from email by Al Viro:

"Since both are claimed to be strings, I really suspect that this >> 8 is
misspelled >> 4 and they have a character followed by pair of two-digit
packed decimals in there..."

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings
+++ a/drivers/scsi/megaraid.c
@@ -310,15 +310,15 @@ mega_query_adapter(adapter_t *adapter)
 	if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
 			 adapter->product_info.fw_version[2],
-			 adapter->product_info.fw_version[1] >> 8,
+			 adapter->product_info.fw_version[1] >> 4,
 			 adapter->product_info.fw_version[1] & 0x0f,
-			 adapter->product_info.fw_version[0] >> 8,
+			 adapter->product_info.fw_version[0] >> 4,
 			 adapter->product_info.fw_version[0] & 0x0f);
 		sprintf (adapter->bios_version, "%c%d%d.%d%d",
 			 adapter->product_info.bios_version[2],
-			 adapter->product_info.bios_version[1] >> 8,
+			 adapter->product_info.bios_version[1] >> 4,
 			 adapter->product_info.bios_version[1] & 0x0f,
-			 adapter->product_info.bios_version[0] >> 8,
+			 adapter->product_info.bios_version[0] >> 4,
 			 adapter->product_info.bios_version[0] & 0x0f);
 	} else {
 		memcpy(adapter->fw_version,
_
