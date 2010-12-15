From: matthew@wil.cx
Subject: [PATCH 2/5] uas: Use kzalloc instead of kmalloc
Date: Wed, 15 Dec 2010 15:44:03 -0500
Message-ID: <1292445846-12101-2-git-send-email-matthew@wil.cx>
References: <20101215204147.GA1263@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:33935 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752158Ab0LOUyL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2010 15:54:11 -0500
In-Reply-To: <20101215204147.GA1263@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

From: Matthew Wilcox <matthew@wil.cx>

The IUs are not being fully initialised by the driver (due to the reserved
space).  Since we should be zeroing reserved fields, use kzalloc to do
it for us.

Reported-by: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/usb/storage/uas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index ca277c2..981fdef 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -297,7 +297,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	if (!urb)
 		goto out;
 
-	iu = kmalloc(sizeof(*iu), gfp);
+	iu = kzalloc(sizeof(*iu), gfp);
 	if (!iu)
 		goto free;
 
@@ -328,7 +328,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	if (len < 0)
 		len = 0;
 	len = ALIGN(len, 4);
-	iu = kmalloc(sizeof(*iu) + len, gfp);
+	iu = kzalloc(sizeof(*iu) + len, gfp);
 	if (!iu)
 		goto free;
 
-- 
1.7.2.3

