From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] scsi_dh_hp_sw.c: return DEV_OFFLINED when blk_get_request fails
Date: Thu, 28 Mar 2013 15:32:12 -0400
Message-ID: <x49y5d7xqv7.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab3C1TcQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Mar 2013 15:32:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>

Hi,

If blk_get_requet fails here, it means that the queue is dead.  It seems
better to return a DEV_OFFLINED error code than the misleading
TEMP_UNAVAIL.  Comments?

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 084062b..eec24d3 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -118,7 +118,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 retry:
 	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
 	if (!req)
-		return SCSI_DH_RES_TEMP_UNAVAIL;
+		return SCSI_DH_DEV_OFFLINED;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
