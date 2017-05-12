From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 4/4] scsi_dh_alua: take sdev reference in alua_bus_attach
Date: Fri, 12 May 2017 15:15:08 +0200
Message-ID: <20170512131508.3231-5-mwilck@suse.com>
References: <20170512131508.3231-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:35796 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755736AbdELNPr (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 12 May 2017 09:15:47 -0400
In-Reply-To: <20170512131508.3231-1-mwilck@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Modification of the access_state field in struct scsi_device
in alua_rtpg() may race with alua_bus_detach(). Avoid
the scsi_device struct to be freed while it's being processed
in the alua code by taking a reference.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a59783020c66..4b33e076d4f7 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1108,6 +1108,10 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
+	if (scsi_device_get(sdev)) {
+		ret = -ENXIO;
+		goto failed;
+	}
 	spin_lock_init(&h->pg_lock);
 	rcu_assign_pointer(h->pg, NULL);
 	h->init_error = SCSI_DH_OK;
@@ -1119,10 +1123,13 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	if (err == SCSI_DH_NOMEM)
 		ret = -ENOMEM;
 	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
-		goto failed;
+		goto failed_put;
 
 	sdev->handler_data = h;
 	return 0;
+
+failed_put:
+	scsi_device_put(sdev);
 failed:
 	kfree(h);
 	return ret;
@@ -1140,6 +1147,7 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	spin_lock(&h->pg_lock);
 	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
 	rcu_assign_pointer(h->pg, NULL);
+	scsi_device_put(h->sdev);
 	h->sdev = NULL;
 	spin_unlock(&h->pg_lock);
 	if (pg) {
-- 
2.12.2
