From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 33/33] Remove Compatibility mode hack from scsi_cmnd
Date: Thu, 18 Oct 2007 09:44:39 +0200
Message-ID: <47170EE7.1030600@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:19905 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761408AbXJRHpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 03:45:20 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Jeff Garzik <jeff@garzik.org>, Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


  - So we can separate the move to scsi_data_buffer
    into several patches, we have introduced a compatibility
    hack in the very first patch, that let the patchset be
    completely bisectable. Now that the entire tree is converted
    We can finally remove OLD I/O members from scsi_cmnd.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 include/scsi/scsi_cmnd.h |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 047ffe6..8b8759c 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -113,21 +113,7 @@ struct scsi_cmnd {
 
 	unsigned char tag;	/* SCSI-II queued command tag */
 
-	union {
-		struct scsi_data_buffer sdb;
-		/*
-		 * FIXME: Here for compatibility with unconverted drivers.
-		 *        Must be kept in sync with exact type and order
-		 *        of struct scsi_data_buffer members.
-		 */
-		struct {
-			unsigned __deprecated request_bufflen;
-			int __deprecated resid;
-			unsigned short __deprecated use_sg;
-			unsigned short __deprecated place_holder_sg_alloc;
-			void __deprecated *request_buffer;
-		};
-	};
+	struct scsi_data_buffer sdb;
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
-- 
1.5.3.1

