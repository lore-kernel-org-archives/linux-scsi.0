From: Adrian Bunk <bunk@kernel.org>
Subject: [14/17] drivers/scsi/sr_vendor.c: use bcd2bin
Date: Fri, 8 Aug 2008 19:34:57 +0300
Message-ID: <20080808163457.GU14495@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48033 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984AbYHHQgb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, David Brownell <david-b@pacbell.net>

This patch changes sr_vendor.c to use the new bcd2bin function instead 
of the obsolete BCD2BIN macro.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/sr_vendor.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

95517eee3647bbde1864a6a2ce7e6cab2770e202 
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index 4eb3da9..4ad3e01 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -223,9 +223,9 @@ int sr_cd_check(struct cdrom_device_info *cdi)
 				no_multi = 1;
 				break;
 			}
-			min = BCD2BIN(buffer[15]);
-			sec = BCD2BIN(buffer[16]);
-			frame = BCD2BIN(buffer[17]);
+			min = bcd2bin(buffer[15]);
+			sec = bcd2bin(buffer[16]);
+			frame = bcd2bin(buffer[17]);
 			sector = min * CD_SECS * CD_FRAMES + sec * CD_FRAMES + frame;
 			break;
 		}
@@ -252,9 +252,9 @@ int sr_cd_check(struct cdrom_device_info *cdi)
 			}
 			if (rc != 0)
 				break;
-			min = BCD2BIN(buffer[1]);
-			sec = BCD2BIN(buffer[2]);
-			frame = BCD2BIN(buffer[3]);
+			min = bcd2bin(buffer[1]);
+			sec = bcd2bin(buffer[2]);
+			frame = bcd2bin(buffer[3]);
 			sector = min * CD_SECS * CD_FRAMES + sec * CD_FRAMES + frame;
 			if (sector)
 				sector -= CD_MSF_OFFSET;

