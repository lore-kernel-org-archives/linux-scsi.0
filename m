From: michaelc@cs.wisc.edu
Subject: [PATCH 4/6] be2iscsi: fix lun test in device reset callout
Date: Fri,  7 Feb 2014 00:41:40 -0600
Message-ID: <1391755302-57206-5-git-send-email-michaelc@cs.wisc.edu>
References: <1391755302-57206-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40278 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaBGGl5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Feb 2014 01:41:57 -0500
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s176fqta015126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 7 Feb 2014 00:41:56 -0600
In-Reply-To: <1391755302-57206-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

We want to be checking the scsi_cmnd's lun against
the possible tasks in the driver. Current check tests
task against itself which was useless.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 8d82f2c..bc77a6f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -325,7 +325,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		if (!abrt_task->sc || abrt_task->state == ISCSI_TASK_FREE)
 			continue;
 
-		if (abrt_task->sc->device->lun != abrt_task->sc->device->lun)
+		if (sc->device->lun != abrt_task->sc->device->lun)
 			continue;
 
 		/* Invalidate WRB Posted for this Task */
-- 
1.7.1

