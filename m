From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH v2 5/5] st: raise device limit
Date: Thu, 17 May 2012 14:22:12 -0700
Message-ID: <4FB56C04.9040708@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat.nue.novell.com ([195.135.221.2]:28350 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760151Ab2EQVWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 17:22:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kai.makisara@kolumbus.fi, jeffm@suse.com

From: Jeff Mahoney <jeffm@suse.com>

The device limit of 128 tape drives was established in 2003 as a
significant increase from the 8 tape drives allowed previously.

We're seeing customer sites that between a large number of drives
and multipath are discovering more than 128 devices and running
into problems.

Now that we're not stuck having to store a pointer in array
and aren't limited by kmalloc failing on higher order allocs we can
lift the limit to fill the entire minor range based on the number
of modes.

Based on the current code, that's 2^17 devices.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/st.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 4456735..2092f93 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -77,7 +77,7 @@ struct st_modedef {
 #define ST_MODE_SHIFT (7 - ST_NBR_MODE_BITS)
 #define ST_MODE_MASK ((ST_NBR_MODES - 1) << ST_MODE_SHIFT)
 
-#define ST_MAX_TAPES 128
+#define ST_MAX_TAPES (1 << (20 - (ST_NBR_MODE_BITS + 1)))
 #define ST_MAX_TAPE_ENTRIES  (ST_MAX_TAPES << (ST_NBR_MODE_BITS + 1))
 
 /* The status related to each partition */
-- 
1.7.9.2

