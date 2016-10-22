From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 4/6] [SCSI] ips: don't use custom hex_asc_upper[] table
Date: Sat, 22 Oct 2016 20:32:29 +0300
Message-ID: <20161022173231.170417-5-andriy.shevchenko@linux.intel.com>
References: <20161022173231.170417-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:32630 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964798AbcJVRdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Oct 2016 13:33:06 -0400
In-Reply-To: <20161022173231.170417-1-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>

From: Andy Shevchenko <andy.shevchenko@gmail.com>

We have table of the HEX characters in the kernel. Replace custom by a generic
one.

Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/scsi/ips.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 02cb76f..3419e1b 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2241,9 +2241,6 @@ ips_get_bios_version(ips_ha_t * ha, int intr)
 	uint8_t minor;
 	uint8_t subminor;
 	uint8_t *buffer;
-	char hexDigits[] =
-	    { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C',
-     'D', 'E', 'F' };
 
 	METHOD_TRACE("ips_get_bios_version", 1);
 
@@ -2374,13 +2371,13 @@ ips_get_bios_version(ips_ha_t * ha, int intr)
 		}
 	}
 
-	ha->bios_version[0] = hexDigits[(major & 0xF0) >> 4];
+	ha->bios_version[0] = hex_asc_upper_hi(major);
 	ha->bios_version[1] = '.';
-	ha->bios_version[2] = hexDigits[major & 0x0F];
-	ha->bios_version[3] = hexDigits[subminor];
+	ha->bios_version[2] = hex_asc_upper_lo(major);
+	ha->bios_version[3] = hex_asc_upper_lo(subminor);
 	ha->bios_version[4] = '.';
-	ha->bios_version[5] = hexDigits[(minor & 0xF0) >> 4];
-	ha->bios_version[6] = hexDigits[minor & 0x0F];
+	ha->bios_version[5] = hex_asc_upper_hi(minor);
+	ha->bios_version[6] = hex_asc_upper_lo(minor);
 	ha->bios_version[7] = 0;
 }
 
-- 
2.9.3

