From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 30/35] hpsa: only do device rescan for certain events
Date: Tue, 18 Feb 2014 13:57:42 -0600
Message-ID: <20140218195742.15787.72500.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43835 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaBRT7I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:59:08 -0500
Received: from g6t1525.atlanta.hp.com (g6t1525.atlanta.hp.com [15.193.200.68])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 7E04460365
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:59:08 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Do no rescan on every events -- way too many rescans are
triggered if we don't filter the events.  Limit rescans
to be triggered by the following set of events:

 * controller state change
 * enclosure hot plug
 * physical drive state change
 * logical drive state change
 * redundant controller state change
 * accelerated io enabled/disabled
 * accelerated io configuration change

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 drivers/scsi/hpsa.h |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 41766c2..5193fab 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6416,7 +6416,7 @@ static void hpsa_ctlr_needs_rescan(struct ctlr_info *h)
 		return;
 
 	h->events = readl(&(h->cfgtable->event_notify));
-	if (!h->events && !h->drv_req_rescan)
+	if (!(h->events & RESCAN_REQUIRED_EVENT_BITS) && !h->drv_req_rescan)
 		return;
 
 	/*
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index fe813e9..fe8d281 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -181,6 +181,22 @@ struct ctlr_info {
 #define HPSATMF_LOG_QRY_TSET    (1 << 24)
 #define HPSATMF_LOG_QRY_ASYNC   (1 << 25)
 	u32 events;
+#define CTLR_STATE_CHANGE_EVENT				(1 << 0)
+#define CTLR_ENCLOSURE_HOT_PLUG_EVENT			(1 << 1)
+#define CTLR_STATE_CHANGE_EVENT_PHYSICAL_DRV		(1 << 4)
+#define CTLR_STATE_CHANGE_EVENT_LOGICAL_DRV		(1 << 5)
+#define CTLR_STATE_CHANGE_EVENT_REDUNDANT_CNTRL		(1 << 6)
+#define CTLR_STATE_CHANGE_EVENT_AIO_ENABLED_DISABLED	(1 << 30)
+#define CTLR_STATE_CHANGE_EVENT_AIO_CONFIG_CHANGE	(1 << 31)
+
+#define RESCAN_REQUIRED_EVENT_BITS \
+		(CTLR_STATE_CHANGE_EVENT | \
+		CTLR_ENCLOSURE_HOT_PLUG_EVENT | \
+		CTLR_STATE_CHANGE_EVENT_PHYSICAL_DRV | \
+		CTLR_STATE_CHANGE_EVENT_LOGICAL_DRV | \
+		CTLR_STATE_CHANGE_EVENT_REDUNDANT_CNTRL | \
+		CTLR_STATE_CHANGE_EVENT_AIO_ENABLED_DISABLED | \
+		CTLR_STATE_CHANGE_EVENT_AIO_CONFIG_CHANGE)
 	int	acciopath_status;
 	int	drv_req_rescan;	/* flag for driver to request rescan event */
 };

