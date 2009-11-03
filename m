From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] qlogicpti: add missing parentheses
Date: Wed, 04 Nov 2009 00:38:44 +0100
Message-ID: <4AF0BF04.9030203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:29918 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZKCX1X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 18:27:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

`+' has a higher precedence than `?' so the condition always
evaluates to true and this is preprocessed to `7*((ql) - 1)'

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/qlogicpti.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

This one must be right, I think.

QLOGICPTI_MAX_SG is used here:

drivers/scsi/qlogicpti.c:964:   host->sg_tablesize = QLOGICPTI_MAX_SG(num_free);
drivers/scsi/qlogicpti.c:1288:  .sg_tablesize           = QLOGICPTI_MAX_SG(QLOGICPTI_REQ_QUEUE_LEN),

Thanks, Roel

diff --git a/drivers/scsi/qlogicpti.h b/drivers/scsi/qlogicpti.h
index 9c053bb..e3c74d1 100644
--- a/drivers/scsi/qlogicpti.h
+++ b/drivers/scsi/qlogicpti.h
@@ -43,7 +43,7 @@
  * determined for each queue request anew.
  */
 #define QLOGICPTI_REQ_QUEUE_LEN	255	/* must be power of two - 1 */
-#define QLOGICPTI_MAX_SG(ql)	(4 + ((ql) > 0) ? 7*((ql) - 1) : 0)
+#define QLOGICPTI_MAX_SG(ql)	(4 + (((ql) > 0) ? 7*((ql) - 1) : 0))
 
 /* mailbox command complete status codes */
 #define MBOX_COMMAND_COMPLETE		0x4000
