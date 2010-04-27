From: akpm@linux-foundation.org
Subject: [patch 13/28] dc395x: decrease iteration for tag_number of max_command in start_scsi()
Date: Tue, 27 Apr 2010 14:22:57 -0700
Message-ID: <201004272122.o3RLMvIF020810@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087Ab0D0V1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:27:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, oliver@neukum.name

From: Roel Kluin <roel.kluin@gmail.com>

The tag_number reaches dcb->max_command + 1 after the loop, but when
the tag_number equals dcb->max_command an error message is already
issued. The last iteration therefore appears obsolete.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Oliver Neukum <oliver@neukum.name>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dc395x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/dc395x.c~dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c~dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi
+++ a/drivers/scsi/dc395x.c
@@ -1597,7 +1597,7 @@ static u8 start_scsi(struct AdapterCtlBl
 		u32 tag_mask = 1;
 		u8 tag_number = 0;
 		while (tag_mask & dcb->tag_mask
-		       && tag_number <= dcb->max_command) {
+		       && tag_number < dcb->max_command) {
 			tag_mask = tag_mask << 1;
 			tag_number++;
 		}
_
