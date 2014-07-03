From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/5] hpsa: remove online devices from offline device list
Date: Thu, 03 Jul 2014 10:17:58 -0500
Message-ID: <20140703151758.22132.55045.stgit@beardog.cce.hp.com>
References: <20140703151534.22132.49663.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:2338 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbaGCPSu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 11:18:50 -0400
In-Reply-To: <20140703151534.22132.49663.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com, hch@lst.de

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

When devices come on line, they should be removed from the list of
offline devices that are monitored.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Scott Teel <scott.teel@hp.com>
Reviewed-by: Joe Handzik <joseph.t.handzik@hp.com>
---
 drivers/scsi/hpsa.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 31184b3..8cd1a9b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6913,8 +6913,12 @@ static int hpsa_offline_devices_ready(struct ctlr_info *h)
 		d = list_entry(this, struct offline_device_entry,
 				offline_list);
 		spin_unlock_irqrestore(&h->offline_device_lock, flags);
-		if (!hpsa_volume_offline(h, d->scsi3addr))
+		if (!hpsa_volume_offline(h, d->scsi3addr)) {
+			spin_lock_irqsave(&h->offline_device_lock, flags);
+			list_del(&d->offline_list);
+			spin_unlock_irqrestore(&h->offline_device_lock, flags);
 			return 1;
+		}
 		spin_lock_irqsave(&h->offline_device_lock, flags);
 	}
 	spin_unlock_irqrestore(&h->offline_device_lock, flags);

