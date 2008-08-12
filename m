From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 2/2] scsi: scsi_check_sense HARDWARE_ERROR return ADD_TO_MLQUEUE
Date: Tue, 12 Aug 2008 12:11:58 -0700
Message-ID: <1218568318-4065-3-git-send-email-andmike@linux.vnet.ibm.com>
References: <1218568318-4065-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:36920 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYHLTMF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Aug 2008 15:12:05 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7CJC3dS018339
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 15:12:04 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7CJC3g3075414
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 13:12:03 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7CJC23K018455
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 13:12:03 -0600
In-Reply-To: <1218568318-4065-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, Hannes Reinecke <hare@suse.de>

Change scsi_check_sense HARDWARE_ERROR check to return ADD_TO_MLQUEUE
to allow retries to occur without restriction of blk_noretry_request
check.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 880051c..39ce3ab 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -391,7 +391,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 
 	case HARDWARE_ERROR:
 		if (scmd->device->retry_hwerror)
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		else
 			return SUCCESS;
 
-- 
1.5.5.1

