From: akpm@linux-foundation.org
Subject: [patch 16/17] drivers/scsi/megaraid: Use DIV_ROUND_UP
Date: Mon, 22 Sep 2008 14:56:52 -0700
Message-ID: <200809222156.m8MLuqeK032310@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533AbYIVV5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2008 17:57:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk, Bo.Yang@lsi.com

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
Cc: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~drivers-scsi-megaraid-use-div_round_up drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~drivers-scsi-megaraid-use-div_round_up
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -1718,7 +1718,7 @@ static int megasas_create_frame_pool(str
 	 * Calculated the number of 64byte frames required for SGL
 	 */
 	sgl_sz = sge_sz * instance->max_num_sge;
-	frame_count = (sgl_sz + MEGAMFI_FRAME_SIZE - 1) / MEGAMFI_FRAME_SIZE;
+	frame_count = DIV_ROUND_UP(sgl_sz, MEGAMFI_FRAME_SIZE);
 
 	/*
 	 * We need one extra frame for the MFI command
_
