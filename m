From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 13/35] hpsa: Acknowledge controller events in ioaccell mode 2
	as well as mode 1
Date: Tue, 18 Feb 2014 13:56:09 -0600
Message-ID: <20140218195609.15787.9960.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43533 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaBRT6B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:58:01 -0500
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id A6F9D61C2D
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:58:00 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |    3 ++-
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b80ba1e..ba51b1e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5482,7 +5482,8 @@ static int hpsa_kickoff_rescan(struct ctlr_info *h)
 	char *event_type;
 
 	/* Ask the controller to clear the events we're handling. */
-	if (h->transMethod & (CFGTBL_Trans_io_accel1) &&
+	if ((h->transMethod & (CFGTBL_Trans_io_accel1
+			| CFGTBL_Trans_io_accel2)) &&
 		(h->events & HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_STATE_CHANGE ||
 		 h->events & HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_CONFIG_CHANGE)) {
 
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 9e00988..6b336e8 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -133,6 +133,7 @@
 #define CFGTBL_Trans_Simple     0x00000002l
 #define CFGTBL_Trans_Performant 0x00000004l
 #define CFGTBL_Trans_io_accel1	0x00000080l
+#define CFGTBL_Trans_io_accel2	0x00000100l
 #define CFGTBL_Trans_use_short_tags 0x20000000l
 #define CFGTBL_Trans_enable_directed_msix (1 << 30)
 

