From: Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH] scsi: IPS, IBMMCA: Use hex_asc_hi and hex_asc_lo
Date: Fri, 13 Aug 2010 14:57:03 +0200
Message-ID: <AANLkTik_yRPzJoOgY_ze8aFG6G1CXZ4D4XMNL6d66W2C@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55662 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934273Ab0HMM5E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2010 08:57:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Trivial substitution for private implementations, compile tested on i386.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>

diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 9a4b69d..c152eca 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1002,12 +1002,11 @@ static char *ti_p(int dev)
 /* interpreter for logical device numbers (ldn) */
 static char *ti_l(int val)
 {
-	const char hex[16] = "0123456789abcdef";
 	static char answer[2];

 	answer[1] = (char) (0x0);
 	if (val <= MAX_LOG_DEV)
-		answer[0] = hex[val];
+		answer[0] = hex_asc_lo(val);
 	else
 		answer[0] = '-';
 	return (char *) &answer;
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index f83a116..3c25573 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2315,9 +2315,6 @@ ips_get_bios_version(ips_ha_t * ha, int intr)
 	uint8_t minor;
 	uint8_t subminor;
 	uint8_t *buffer;
-	char hexDigits[] =
-	    { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C',
-     'D', 'E', 'F' };

 	METHOD_TRACE("ips_get_bios_version", 1);

@@ -2448,13 +2445,13 @@ ips_get_bios_version(ips_ha_t * ha, int intr)
 		}
 	}

-	ha->bios_version[0] = hexDigits[(major & 0xF0) >> 4];
+	ha->bios_version[0] = hex_asc_hi(major);
 	ha->bios_version[1] = '.';
-	ha->bios_version[2] = hexDigits[major & 0x0F];
-	ha->bios_version[3] = hexDigits[subminor];
+	ha->bios_version[2] = hex_asc_lo(major);
+	ha->bios_version[3] = hex_asc_lo(subminor);
 	ha->bios_version[4] = '.';
-	ha->bios_version[5] = hexDigits[(minor & 0xF0) >> 4];
-	ha->bios_version[6] = hexDigits[minor & 0x0F];
+	ha->bios_version[5] = hex_asc_hi(minor);
+	ha->bios_version[6] = hex_asc_lo(minor);
 	ha->bios_version[7] = 0;
 }
