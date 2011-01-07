From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] [SCSI] scsi_dh_rdac: avoid possible deadlock in queue_mode_select
Date: Fri,  7 Jan 2011 14:51:18 -0500
Message-ID: <1294429878-5999-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab1AGTvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2011 14:51:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Babu Moger <babu.moger@lsi.com>, Mike Snitzer <snitzer@redhat.com>

From: Babu Moger <babu.moger@lsi.com>

Use GFP_NOIO when allocating memory during activation of a new path to
avoid possiblility of triggering recursive writeback to a failed path.

A failed IO could cause the path to go down, then we would call
queue_mode_select() to active a new path.  Allocating memory using
GFP_KERNEL is bad to use here because completing the allocation may
require the system to write out pages to the same disk that just had
the failed path.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

v2: just refreshed and tweaked the patch header
    - v1 is available here: https://patchwork.kernel.org/patch/71073/

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 5be3ae1..566effd 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -625,7 +625,7 @@ static int queue_mode_select(struct scsi_device *sdev,
 	struct rdac_queue_data *qdata;
 	struct rdac_controller *ctlr;
 
-	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
+	qdata = kzalloc(sizeof(*qdata), GFP_NOIO);
 	if (!qdata)
 		return SCSI_DH_RETRY;
 
