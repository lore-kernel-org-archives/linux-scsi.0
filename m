From: akpm@linux-foundation.org
Subject: [patch 07/17] drivers/scsi: Use DIV_ROUND_UP
Date: Wed, 29 Oct 2008 14:24:40 -0700
Message-ID: <200810292124.m9TLOeF6021232@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755230AbYJ2VYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 17:24:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk, willy@linux.intel.com

From: Julia Lawall <julia@diku.dk>

Use the macro DIV_ROUND_UP and eliminate the variable rounded_up, as
suggested by Matthew Wilcox.

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/esp_scsi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/esp_scsi.c~drivers-scsi-use-div_round_up drivers/scsi/esp_scsi.c
--- a/drivers/scsi/esp_scsi.c~drivers-scsi-use-div_round_up
+++ a/drivers/scsi/esp_scsi.c
@@ -1453,7 +1453,7 @@ static void esp_msgin_sdtr(struct esp *e
 		offset = 0;
 
 	if (offset) {
-		int rounded_up, one_clock;
+		int one_clock;
 
 		if (period > esp->max_period) {
 			period = offset = 0;
@@ -1463,9 +1463,7 @@ static void esp_msgin_sdtr(struct esp *e
 			goto do_reject;
 
 		one_clock = esp->ccycle / 1000;
-		rounded_up = (period << 2);
-		rounded_up = (rounded_up + one_clock - 1) / one_clock;
-		stp = rounded_up;
+		stp = DIV_ROUND_UP(period << 2, one_clock);
 		if (stp && esp->rev >= FAS236) {
 			if (stp >= 50)
 				stp--;
_
