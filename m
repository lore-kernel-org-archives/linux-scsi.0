From: michaelc@cs.wisc.edu
Subject: [PATCH 4/6] be2iscsi: fix lun test in device reset callout
Date: Fri, 20 Dec 2013 12:53:45 -0600
Message-ID: <1387565627-5218-5-git-send-email-michaelc@cs.wisc.edu>
References: <1387565627-5218-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33115 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3LTSyA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 13:54:00 -0500
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id rBKIrs2a010889
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2013 12:53:59 -0600
In-Reply-To: <1387565627-5218-1-git-send-email-michaelc@cs.wisc.edu>
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
index 1fb16b1..3ffe8ca 100644
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

