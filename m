From: FUJITA Tomonori <tomof@acm.org>
Subject: aic79xx: fix sense_buffer access bug
Date: Sun, 27 Jan 2008 12:41:09 +0900
Message-ID: <20080127124023L.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:39744 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYA0DlX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2008 22:41:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Ah, I overlooked more LLDs...

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] aic79xx: fix sense_buffer access bug

The commit de25deb18016f66dcdede165d07654559bb332bc changed
scsi_cmnd.sense_buffer from a static array to a dynamically allocated
buffer. We can't access to sense_buffer in '&cmd->sense_buffer' way.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 0e4708f..3c4efa4 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1922,7 +1922,7 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 				struct scsi_sense_data *sense;
 				
 				sense = (struct scsi_sense_data *)
-					&cmd->sense_buffer;
+					cmd->sense_buffer;
 				if (sense->extra_len >= 5 &&
 				    (sense->add_sense_code == 0x47
 				     || sense->add_sense_code == 0x48))
-- 
1.5.3.4

