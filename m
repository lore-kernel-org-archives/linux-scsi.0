From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 12/22] scsi_dh_alua: remove 'rel_port' from alua_dh_data structure
Date: Tue, 12 Jan 2016 16:40:48 +0100
Message-ID: <1452613258-94084-13-git-send-email-hare@suse.de>
References: <1452613258-94084-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761842AbcALPlF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 10:41:05 -0500
In-Reply-To: <1452613258-94084-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The 'relative port' field is not used, and might get stale when
the port group changes. So remove the field altogether.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 7bd5108..c9d028c 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -87,7 +87,6 @@ struct alua_port_group {
 struct alua_dh_data {
 	struct alua_port_group	*pg;
 	int			group_id;
-	int			rel_port;
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
 	void			*callback_data;
@@ -323,12 +322,10 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 			return SCSI_DH_NOMEM;
 		return SCSI_DH_DEV_UNSUPP;
 	}
-	h->rel_port = rel_port;
-
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: device %s port group %02x rel port %02x\n",
 		    ALUA_DH_NAME, h->pg->device_id_str,
-		    h->group_id, h->rel_port);
+		    h->group_id, rel_port);
 
 	return alua_rtpg(sdev, h->pg);
 }
@@ -764,7 +761,6 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	if (!h)
 		return -ENOMEM;
 	h->pg = NULL;
-	h->rel_port = -1;
 	h->sdev = sdev;
 
 	err = alua_initialize(sdev, h);
-- 
1.8.5.6

