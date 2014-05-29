From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 16/24] hpsa: fix event filtering to prevent excessive
	rescans with old firmware
Date: Thu, 29 May 2014 10:53:44 -0500
Message-ID: <20140529155344.8180.51125.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:19881 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353AbaE2PzK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:55:10 -0400
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 9D8F9E99
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:35:53 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

CTLR_STATE_CHANGE_EVENT and CTLR_STATE_CHANGE_EVENT_REDUNDANT_CNTRL
do not require rescans to be initiated.  Current firmware filters out
these events already, but some out of date firmware doesn't, so the
driver needs to filter them out too.  Without this change and with out
of date firmware you may see the driver spending a lot of time
scanning devices unnecessarily on some Smart Arrays.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Justin Lindley <justin.lindley@hp.com>
---
 drivers/scsi/hpsa.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 1855469..18f5093 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -228,11 +228,9 @@ struct ctlr_info {
 #define CTLR_STATE_CHANGE_EVENT_AIO_CONFIG_CHANGE	(1 << 31)
 
 #define RESCAN_REQUIRED_EVENT_BITS \
-		(CTLR_STATE_CHANGE_EVENT | \
-		CTLR_ENCLOSURE_HOT_PLUG_EVENT | \
+		(CTLR_ENCLOSURE_HOT_PLUG_EVENT | \
 		CTLR_STATE_CHANGE_EVENT_PHYSICAL_DRV | \
 		CTLR_STATE_CHANGE_EVENT_LOGICAL_DRV | \
-		CTLR_STATE_CHANGE_EVENT_REDUNDANT_CNTRL | \
 		CTLR_STATE_CHANGE_EVENT_AIO_ENABLED_DISABLED | \
 		CTLR_STATE_CHANGE_EVENT_AIO_CONFIG_CHANGE)
 	spinlock_t offline_device_lock;

