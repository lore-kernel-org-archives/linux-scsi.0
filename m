From: matthew@wil.cx
Subject: [PATCH 1/5] uas: Fix up the Sense IU
Date: Wed, 15 Dec 2010 15:44:02 -0500
Message-ID: <1292445846-12101-1-git-send-email-matthew@wil.cx>
References: <20101215204147.GA1263@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:25445 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755424Ab0LOUyT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2010 15:54:19 -0500
In-Reply-To: <20101215204147.GA1263@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

From: Matthew Wilcox <matthew@wil.cx>

Add a comment to the Sense IU data structure that it's also used for Read
Ready and Write Ready.  Remove the 'service response' element since it's
gone from the current draft (04).

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/usb/storage/uas.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 339fac3..ca277c2 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -49,14 +49,17 @@ struct command_iu {
 	__u8 cdb[16];	/* XXX: Overflow-checking tools may misunderstand */
 };
 
+/*
+ * Also used for the Read Ready and Write Ready IUs since they have the
+ * same first four bytes
+ */
 struct sense_iu {
 	__u8 iu_id;
 	__u8 rsvd1;
 	__be16 tag;
 	__be16 status_qual;
 	__u8 status;
-	__u8 service_response;
-	__u8 rsvd8[6];
+	__u8 rsvd7[7];
 	__be16 len;
 	__u8 sense[SCSI_SENSE_BUFFERSIZE];
 };
-- 
1.7.2.3

