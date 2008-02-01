From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] ps3rom: sector size should be 512 bytes
Date: Fri, 1 Feb 2008 17:35:13 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802011734130.28283@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1989583265-1201883713=:28283"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41161 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754678AbYBAQfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 11:35:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Aegis Lin <aegislin@gmail.com>, Geoff Levand <geoffrey.levand@am.sony.com>, linux-scsi@vger.kernel.org, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1989583265-1201883713=:28283
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

From: Aegis Lin <aegislin@gmail.com>

ps3rom: sector size should be 512 bytes

It should be desired that 64 KiB is available for ATAPI transferrring.
(Historically) in SCSI/block layer sector size is defined as 512 during
sector-byte calculation.
Originally in ps3rom.c CD_FRAMESIZE (2048) was used, which limited
/sys/block/sr0/queue/max_sectors_kb to 16 KiB (32 sectors).

Signed-off-by: Aegis Lin <aegislin@gmail.com>
Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/scsi/ps3rom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -35,7 +35,7 @@
 
 #define BOUNCE_SIZE			(64*1024)
 
-#define PS3ROM_MAX_SECTORS		(BOUNCE_SIZE / CD_FRAMESIZE)
+#define PS3ROM_MAX_SECTORS		(BOUNCE_SIZE >> 9)
 
 
 struct ps3rom_private {

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-1989583265-1201883713=:28283--
