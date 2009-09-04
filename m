From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] sr: consider the last written sector when determining media
 size
Date: Fri, 04 Sep 2009 11:38:02 +0900
Message-ID: <4AA07D8A.6090004@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:41443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbZIDCiV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 22:38:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Milan Kocian <milan.kocian@wq.c>

On certain cases, UDF disc doesn't report capacity correctly via
READ_CAPACITY but TOC or trackinfo contains valid information which
can be obtained using cdrom_get_last_written().  ide-cd considers both
values and uses the larger one.  Do the same in sr.  This fixes
bko#9668.

 http://bugzilla.kernel.org/show_bug.cgi?id=9668

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Milan Kocian <milan.kocian@wq.cz>
Cc: Jan Kara <jack@suse.cz>
---
 drivers/scsi/sr.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index cce0fe4..76bdcfc 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -684,14 +684,20 @@ static void get_sectorsize(struct scsi_cd *cd)
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
 	} else {
-#if 0
-		if (cdrom_get_last_written(&cd->cdi,
-					   &cd->capacity))
-#endif
-			cd->capacity = 1 + ((buffer[0] << 24) |
-						    (buffer[1] << 16) |
-						    (buffer[2] << 8) |
-						    buffer[3]);
+		long last_written;
+
+		cd->capacity = 1 + ((buffer[0] << 24) | (buffer[1] << 16) |
+				    (buffer[2] << 8) | buffer[3]);
+		/*
+		 * READ_CAPACITY doesn't return the correct size on
+		 * certain UDF media.  If last_written is larger, use
+		 * it instead.
+		 *
+		 * http://bugzilla.kernel.org/show_bug.cgi?id=9668
+		 */
+		if (!cdrom_get_last_written(&cd->cdi, &last_written))
+			cd->capacity = max_t(long, cd->capacity, last_written);
+
 		sector_size = (buffer[4] << 24) |
 		    (buffer[5] << 16) | (buffer[6] << 8) | buffer[7];
 		switch (sector_size) {
