From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 2/3] ses: use scsi_is_sas_rphy instead of is_sas_attached
Date: Mon, 15 Aug 2016 17:12:23 +0200
Message-ID: <2cd0c62d68d9b0ea6e977c315e8b39ed0aa76416.1471273623.git.jthumshirn@suse.de>
References: <cover.1471273623.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1471273623.git.jthumshirn@suse.de>
In-Reply-To: <cover.1471273623.git.jthumshirn@suse.de>
References: <cover.1471273623.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org, #@suse.de, v4.5+@suse.de
List-Id: linux-scsi@vger.kernel.org

Use scsi_is_sas_rphy() instead of is_sas_attached() to decide whether
we should obtain the SAS address from a scsi device or not. This will
prevent us from tripping on the BUG_ON() in sas_sdev_to_rdev() if the
rphy isn't attached to the SAS transport class, like it is with hpsa's
logical devices.

Fixes: 3f8d6f2a0 ('ses: fix discovery of SATA devices in SAS enclosures')
Cc: stable@vger.kernel.org # v4.5+
Suggested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/ses.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 53ef1cb6..1d82053 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -587,7 +587,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 
 	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
 
-	if (is_sas_attached(sdev))
+	if (scsi_is_sas_rphy(&sdev->sdev_gendev))
 		efd.addr = sas_get_address(sdev);
 
 	if (efd.addr) {
-- 
1.8.5.6
