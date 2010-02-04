From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 23/30] hpsa:  when resetting devices, print out which device
Date: Thu, 04 Feb 2010 08:43:21 -0600
Message-ID: <20100204144321.10406.76657.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27525 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab0BDOkh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2010 09:40:37 -0500
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa:  when resetting devices, print out which device

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f889ec8..db12bc2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2141,14 +2141,14 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	h = sdev_to_hba(scsicmd->device);
 	if (h == NULL) /* paranoia */
 		return FAILED;
-	dev_warn(&h->pdev->dev, "resetting drive\n");
-
 	dev = scsicmd->device->hostdata;
 	if (!dev) {
 		dev_err(&h->pdev->dev, "hpsa_eh_device_reset_handler: "
 			"device lookup failed.\n");
 		return FAILED;
 	}
+	dev_warn(&h->pdev->dev, "resetting device %d:%d:%d:%d\n",
+		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
 	/* send a reset to the SCSI LUN which the command was sent to */
 	rc = hpsa_send_reset(h, dev->scsi3addr);
 	if (rc == 0 && wait_for_device_to_become_ready(h, dev->scsi3addr) == 0)

