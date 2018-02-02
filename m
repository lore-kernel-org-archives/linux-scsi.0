From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/6] scsi: fc_encode: work around strncpy size warnings
Date: Fri,  2 Feb 2018 14:12:15 +0100
Message-ID: <20180202131225.1658853-2-arnd@arndb.de>
References: <20180202131225.1658853-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:52581 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbeBBNMx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2018 08:12:53 -0500
In-Reply-To: <20180202131225.1658853-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Johannes Thumshirn <jth@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org

struct fc_fdmi_attr_entry contains a variable-length string at
the end, which is encoded as a one-byte array.  gcc-8 notices that
we copy strings into it that obviously go beyond that one byte:

In function 'fc_ct_ms_fill',
    inlined from 'fc_elsct_send' at include/scsi/fc_encode.h:518:8:
include/scsi/fc_encode.h:275:3: error: 'strncpy' writing 64 bytes into a region of size 1 overflows the destination [-Werror=stringop-overflow=]
   strncpy((char *)&entry->value,
   ^
include/scsi/fc_encode.h:287:3: error: 'strncpy' writing 64 bytes into a region of size 1 overflows the destination [-Werror=stringop-overflow=]
   strncpy((char *)&entry->value,
   ^

No idea what the right fix is.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/scsi/fc/fc_ms.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
index f52b921b5c70..c5614e725a0e 100644
--- a/include/scsi/fc/fc_ms.h
+++ b/include/scsi/fc/fc_ms.h
@@ -128,7 +128,7 @@ struct fc_fdmi_port_name {
 struct fc_fdmi_attr_entry {
 	__be16		type;
 	__be16		len;
-	__u8		value[1];
+	__u8		value[];
 } __attribute__((__packed__));
 
 /*
-- 
2.9.0
