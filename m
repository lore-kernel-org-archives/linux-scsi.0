From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 22/24] hpsa: fix bad comparison of signed with unsigned in
	hpsa_update_scsi_devices
Date: Thu, 29 May 2014 10:54:15 -0500
Message-ID: <20140529155415.8180.75677.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:37909 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965177AbaE2Pzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:55:47 -0400
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id C9CDD615D9
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:55:46 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Joe Handzik <joseph.t.handzik@hp.com>

rescan_hba_mode was defined as a u8 so could never be less than zero:

        rescan_hba_mode = hpsa_hba_mode_enabled(h);
        if (rescan_hba_mode < 0)
                goto out;

Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 654e341..c5b24e6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3010,7 +3010,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	int reportlunsize = sizeof(*physdev_list) + HPSA_MAX_PHYS_LUN * 24;
 	int i, n_ext_target_devs, ndevs_to_allocate;
 	int raid_ctlr_position;
-	u8 rescan_hba_mode;
+	int rescan_hba_mode;
 	DECLARE_BITMAP(lunzerobits, MAX_EXT_TARGETS);
 
 	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_DEVICES, GFP_KERNEL);

