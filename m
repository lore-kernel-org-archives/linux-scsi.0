From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 18/19] scsi_debug: Remove a set-but-not-used variable
Date: Wed, 23 Aug 2017 14:40:08 -0700
Message-ID: <20170823214009.15015-19-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45883 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdHWVny (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:43:54 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

This patch avoids that gcc reports the following warning when
building with W=1:

drivers/scsi/scsi_debug.c:2264:15: warning: variable ?pcontrol? set but not used [-Wunused-but-set-variable]

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_debug.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3be980d47268..77a0335eb757 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2261,7 +2261,7 @@ static int resp_ie_l_pg(unsigned char * arr)
 static int resp_log_sense(struct scsi_cmnd * scp,
                           struct sdebug_dev_info * devip)
 {
-	int ppc, sp, pcontrol, pcode, subpcode, alloc_len, len, n;
+	int ppc, sp, pcode, subpcode, alloc_len, len, n;
 	unsigned char arr[SDEBUG_MAX_LSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
 
@@ -2272,7 +2272,6 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, ppc ? 1 : 0);
 		return check_condition_result;
 	}
-	pcontrol = (cmd[2] & 0xc0) >> 6;
 	pcode = cmd[2] & 0x3f;
 	subpcode = cmd[3] & 0xff;
 	alloc_len = get_unaligned_be16(cmd + 7);
-- 
2.14.0
