From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 8/10] drivers/scsi: Use DIV_ROUND_UP
Date: Sat, 2 Aug 2008 17:15:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808021715060.20095@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:49412 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933AbYHBPPa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Aug 2008 11:15:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

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

---
 drivers/scsi/esp_scsi.c              |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -1464,7 +1464,7 @@ static void esp_msgin_sdtr(struct esp *e
 
 		one_clock = esp->ccycle / 1000;
 		rounded_up = (period << 2);
-		rounded_up = (rounded_up + one_clock - 1) / one_clock;
+		rounded_up = DIV_ROUND_UP(rounded_up, one_clock);
 		stp = rounded_up;
 		if (stp && esp->rev >= FAS236) {
 			if (stp >= 50)
