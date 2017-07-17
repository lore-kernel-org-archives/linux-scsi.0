From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: sg: fix static checker warning in sg_is_valid_dxfer
Date: Mon, 17 Jul 2017 15:11:42 +0200
Message-ID: <20170717131142.14069-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Colin Ian King <colin.king@canonical.com>, Dan Carpenter <dan.carpenter@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

dxfer_len is an unsigned int and we always assign a value > 0 to it, so it
doesn't make any sense to check if it is < 0. We can't really check dxferp as
well as we have both NULL and not NULL cases in the possible call paths.

So just return true for SG_DXFER_FROM_DEV transfer in sg_is_valid_dxfer().

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reported-by: Colin Ian King <colin.king@canonical.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 1e82d4128a84..4fe606b000b4 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -759,8 +759,11 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
 			return false;
 		return true;
 	case SG_DXFER_FROM_DEV:
-		if (hp->dxfer_len < 0)
-			return false;
+		/*
+		 * for SG_DXFER_FROM_DEV we always set dxfer_len to > 0. dxferp
+		 * can either be NULL or != NULL so there's no point in checking
+		 * it either. So just return true.
+		 */
 		return true;
 	case SG_DXFER_TO_DEV:
 	case SG_DXFER_TO_FROM_DEV:
-- 
2.12.3
