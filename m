From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/23] scsi_dh_alua: call alua_rtpg() if stpg fails
Date: Mon,  8 Feb 2016 15:34:27 +0100
Message-ID: <1454942086-128704-5-git-send-email-hare@suse.de>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbcBHOeu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 09:34:50 -0500
In-Reply-To: <1454942086-128704-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

If the call to SET TARGET PORT GROUPS fails we have no idea what
state the array is left in, so we need to issue a call to
REPORT TARGET PORT GROUPS in these cases.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 584e1cf..78cccad 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -676,6 +676,8 @@ static int alua_activate(struct scsi_device *sdev,
 		h->flags |= ALUA_OPTIMIZE_STPG;
 
 	err = alua_stpg(sdev, h);
+	if (err == SCSI_DH_RETRY)
+		err = alua_rtpg(sdev, h, 1);
 out:
 	if (fn)
 		fn(data, err);
-- 
1.8.5.6

