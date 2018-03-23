From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: don't look for NULL devices handlers by name
Date: Fri, 23 Mar 2018 14:37:05 +0100
Message-ID: <20180323133705.14556-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Currently scsi_dh_lookup() doesn't check for NULL as a device
name. This combined with nvme over dm-mapth results in the following
messages emitted by device-mapper:

 device-mapper: multipath: Could not failover device 259:67: Handler scsi_dh_(null) error 14.

Let scsi_dh_lookup() fail fast on NULL names.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_dh.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index b88b5dbbc444..188f30572aa1 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -112,6 +112,9 @@ static struct scsi_device_handler *scsi_dh_lookup(const char *name)
 {
 	struct scsi_device_handler *dh;
 
+	if (!name || strlen(name) == 0)
+		return NULL;
+
 	dh = __scsi_dh_lookup(name);
 	if (!dh) {
 		request_module("scsi_dh_%s", name);
-- 
2.13.6
