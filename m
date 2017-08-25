From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 04/17] Convert a strncmp() call into a strcmp() call
Date: Fri, 25 Aug 2017 13:46:30 -0700
Message-ID: <20170825204643.25043-5-bart.vanassche@wdc.com>
References: <20170825204643.25043-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:15512 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932929AbdHYUr7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:47:59 -0400
In-Reply-To: <20170825204643.25043-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>

This patch avoids that smatch reports the following warning:

drivers/scsi/scsi_sysfs.c:117: check_set() error: strncmp() '"-"' too small (2 vs 20)

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 41891db20108..5ed473a87589 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -114,7 +114,7 @@ static int check_set(unsigned long long *val, char *src)
 {
 	char *last;
 
-	if (strncmp(src, "-", 20) == 0) {
+	if (strcmp(src, "-") == 0) {
 		*val = SCAN_WILD_CARD;
 	} else {
 		/*
-- 
2.14.1
