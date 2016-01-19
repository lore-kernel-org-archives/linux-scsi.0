From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 04/23] scsi_dh_alua: call alua_rtpg() if stpg fails
Date: Tue, 19 Jan 2016 09:21:48 +0100
Message-ID: <1453191727-3626-5-git-send-email-hare@suse.de>
References: <1453191727-3626-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbcASIWe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 03:22:34 -0500
In-Reply-To: <1453191727-3626-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

If the call to SET TARGET PORT GROUPS fails we have no idea what
state the array is left in, so we need to issue a call to
REPORT TARGET PORT GROUPS in these cases.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 609691f..ba3d23e 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -678,6 +678,8 @@ static int alua_activate(struct scsi_device *sdev,
 		h->flags |= ALUA_OPTIMIZE_STPG;
 
 	err = alua_stpg(sdev, h);
+	if (err == SCSI_DH_RETRY)
+		err = alua_rtpg(sdev, h, 1);
 out:
 	if (fn)
 		fn(data, err);
-- 
1.8.5.6

