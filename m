From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/3] hpsa: fix bad comparison of signed with unsigned in
	hpsa_update_scsi_devices
Date: Wed, 21 May 2014 11:16:01 -0500
Message-ID: <20140521161600.14409.36072.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:42857 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaEUQRI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 12:17:08 -0400
Received: from g5t1625.atlanta.hp.com (g5t1625.atlanta.hp.com [15.192.137.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 175B721AC
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 15:57:52 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Joe Handzik <joseph.t.handzik@hp.com>

rescan_hba_mode was defined as a u8 so could never be less than zero:

        rescan_hba_mode = hpsa_hba_mode_enabled(h);
        if (rescan_hba_mode < 0)
                goto out;

Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
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

