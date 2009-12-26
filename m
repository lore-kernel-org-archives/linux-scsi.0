From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] dc395x: Decrease iteration for tag_number of max_command
 in start_scsi()
Date: Sat, 26 Dec 2009 19:53:10 +0100
Message-ID: <4B365B96.8050107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:19875 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZLZSu0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Dec 2009 13:50:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

The tag_number reaches dcb->max_command + 1 after the loop, but when
the tag_number equals dcb->max_command an error message is already
issued. The last iteration therefore appears obsolete.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/dc395x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Or maybe we should allow a tag_number of dcb->max_command?

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 6c59c02..f476b52 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1596,7 +1596,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 		u32 tag_mask = 1;
 		u8 tag_number = 0;
 		while (tag_mask & dcb->tag_mask
-		       && tag_number <= dcb->max_command) {
+		       && tag_number < dcb->max_command) {
 			tag_mask = tag_mask << 1;
 			tag_number++;
 		}
