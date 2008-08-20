From: akpm@linux-foundation.org
Subject: [patch 15/18] drivers/scsi: Use DIV_ROUND_UP
Date: Wed, 20 Aug 2008 16:55:34 -0700
Message-ID: <200808202355.m7KNtYIu006225@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758202AbYHUADa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2008 20:03:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/esp_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/esp_scsi.c~drivers-scsi-use-div_round_up drivers/scsi/esp_scsi.c
--- a/drivers/scsi/esp_scsi.c~drivers-scsi-use-div_round_up
+++ a/drivers/scsi/esp_scsi.c
@@ -1464,7 +1464,7 @@ static void esp_msgin_sdtr(struct esp *e
 
 		one_clock = esp->ccycle / 1000;
 		rounded_up = (period << 2);
-		rounded_up = (rounded_up + one_clock - 1) / one_clock;
+		rounded_up = DIV_ROUND_UP(rounded_up, one_clock);
 		stp = rounded_up;
 		if (stp && esp->rev >= FAS236) {
 			if (stp >= 50)
_
