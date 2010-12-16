From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/2] hpsa: do not consider RAID level to be part of device
	identity
Date: Thu, 16 Dec 2010 13:01:03 -0600
Message-ID: <20101216190103.545.97018.stgit@beardog.cce.hp.com>
References: <20101216185823.545.99641.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:37206 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0LPTBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 14:01:04 -0500
In-Reply-To: <20101216185823.545.99641.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com

From: Stephen M. Cameron <StephenM.Cameron>

Otherwise, after doing a RAID level migration, the disk will be
disruptively removed and re-added as a different disk on rescan.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a2408e5..12deffc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -657,8 +657,6 @@ static inline int device_is_the_same(struct hpsa_scsi_dev_t *dev1,
 		return 0;
 	if (dev1->devtype != dev2->devtype)
 		return 0;
-	if (dev1->raid_level != dev2->raid_level)
-		return 0;
 	if (dev1->bus != dev2->bus)
 		return 0;
 	return 1;

