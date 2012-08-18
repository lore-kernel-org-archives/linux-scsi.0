From: jeffm@suse.de (Jeff Mahoney)
Subject: [patch 5/5] [PATCH 5/5] st: raise device limit
Date: Sat, 18 Aug 2012 15:20:41 -0400
Message-ID: <20120818192044.746014978@suse.com>
References: <20120818192036.751334179@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2HRTVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Aug 2012 15:21:50 -0400
Content-Disposition: inline; filename=st-raise-device-limit
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Lee Duncan <lduncan@suse.com>, Rob Evers <revers@redhat.com>

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

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Documentation/scsi/st.txt |    6 ++----
 drivers/scsi/st.h         |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/Documentation/scsi/st.txt
+++ b/Documentation/scsi/st.txt
@@ -112,10 +112,8 @@ attempted).
 
 MINOR NUMBERS
 
-The tape driver currently supports 128 drives by default. This number
-can be increased by editing st.h and recompiling the driver if
-necessary. The upper limit is 2^17 drives if 4 modes for each drive
-are used.
+The tape driver currently supports up to 2^17 drives if 4 modes for
+each drive are used.
 
 The minor numbers consist of the following bit fields:
 
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -78,7 +78,7 @@ struct st_modedef {
 #define ST_MODE_SHIFT (7 - ST_NBR_MODE_BITS)
 #define ST_MODE_MASK ((ST_NBR_MODES - 1) << ST_MODE_SHIFT)
 
-#define ST_MAX_TAPES 128
+#define ST_MAX_TAPES (1 << (20 - (ST_NBR_MODE_BITS + 1)))
 #define ST_MAX_TAPE_ENTRIES  (ST_MAX_TAPES << (ST_NBR_MODE_BITS + 1))
 
 /* The status related to each partition */


