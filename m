From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/64] fcoe: libfcoe: extra semicolon in CHECK_LOGGING macros
	causes compile error
Date: Tue, 25 Aug 2009 13:58:42 -0700
Message-ID: <20090825205842.1553.22006.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20642 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbZHYU6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:58:40 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

If using code like this:
	if (foo)
		FCOE_DBG("foo\n);
	else
		FCOE_DBG("bar\n");

one gets compile errors because FCOE_DBG expands with its own semicolon,
making one too many for the if-statement.

Remove the offending semicolon in fcoe.h and also a similar case
in libfcoe.c.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.h    |    2 +-
 drivers/scsi/fcoe/libfcoe.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 68b9f85..65120e2 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -53,7 +53,7 @@ do {                                                            	\
 		do {							\
 			CMD;						\
 		} while (0);						\
-} while (0);
+} while (0)
 
 #define FCOE_DBG(fmt, args...)						\
 	FCOE_CHECK_LOGGING(FCOE_LOGGING,				\
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 4db719d..d0b5208 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -69,7 +69,7 @@ do {                                                            	\
 		do {							\
 			CMD;						\
 		} while (0);						\
-} while (0);
+} while (0)
 
 #define LIBFCOE_DBG(fmt, args...)					\
 	LIBFCOE_CHECK_LOGGING(LIBFCOE_LOGGING,				\

