From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 16/19] hpsa: fix event filtering to prevent excessive rescans
	with old firmware
Date: Thu, 08 May 2014 14:28:45 -0500
Message-ID: <20140508192845.13481.98508.stgit@beardog.cce.hp.com>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:31477 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaEHT3g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 15:29:36 -0400
In-Reply-To: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

CTLR_STATE_CHANGE_EVENT and CTLR_STATE_CHANGE_EVENT_REDUNDANT_CNTRL
do not require rescans to be initiated.  Current firmware filters out
these events already, but some out of date firmware doesn't, so the
driver needs to filter them out too.  Without this change and with out
of date firmware you may see the driver spending a lot of time
scanning devices unnecessarily on some Smart Arrays.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
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

