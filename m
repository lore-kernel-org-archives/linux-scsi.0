From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] lib: fix string_get_size compile warning
Date: Mon, 8 Sep 2008 02:07:11 +0900
Message-ID: <20080908020551K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:35092 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbYIGRHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Sep 2008 13:07:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

lib/string_helpers.c: In function 'string_get_size':
lib/string_helpers.c:54: warning: format '%03lld' expects type 'long long int', but argument 4 has type 'u64'

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/string_helpers.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 35a1e53..8347925 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -51,7 +51,8 @@ int string_get_size(u64 size, const enum string_size_units units,
 	if (j) {
 		remainder *= 1000;
 		do_div(remainder, divisor[units]);
-		snprintf(tmp, sizeof(tmp), ".%03lld", remainder);
+		snprintf(tmp, sizeof(tmp), ".%03lld",
+			 (unsigned long long)remainder);
 		tmp[j+1] = '\0';
 	}
 
-- 
1.5.4.2

