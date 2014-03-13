From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: fix bad endif placement in RAID 5 mapper code
Date: Thu, 13 Mar 2014 17:12:50 -0500
Message-ID: <20140313221250.32274.59064.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:49713 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaCMWOK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Mar 2014 18:14:10 -0400
Received: from g2t2354.austin.hp.com (g2t2354.austin.hp.com [15.217.128.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id BBB9B60411
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2014 22:13:51 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

It caused the i/o request to always be counted as ineligible for
the accelerated i/o path on 32 bit systems and negatively affected
performance.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a32a510..eb9af2f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3828,8 +3828,8 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 #else
 		first_group = (first_block % stripesize) / r5or6_blocks_per_row;
 		last_group = (last_block % stripesize) / r5or6_blocks_per_row;
-		if (first_group != last_group)
 #endif
+		if (first_group != last_group)
 			return IO_ACCEL_INELIGIBLE;
 
 		/* Verify request is in a single row of RAID 5/6 */

