From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: sg: fix SG_DXFER_FROM_DEV transfers
Date: Wed,  5 Jul 2017 15:49:34 +0200
Message-ID: <20170705134934.1703-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Chris Clayton <chris2553@googlemail.com>, Johannes Thumshirn <jthumshirn@suse.de>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

SG_DXFER_FROM_DEV transfers do not have a dxferp as we set it to NULL,
but must have a length bigger than 0. This fixes a regression introduced
by commit 28676d869bbb ("scsi: sg: check for valid direction before
starting the request")

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Fixes: 28676d869bbb ("scsi: sg: check for valid direction before starting the request")
Reported-by: Chris Clayton <chris2553@googlemail.com>
Tested-by: Chris Clayton <chris2553@googlemail.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 21225d62b0c1..3c91593260aa 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -758,8 +758,11 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
 		if (hp->dxferp || hp->dxfer_len > 0)
 			return false;
 		return true;
-	case SG_DXFER_TO_DEV:
 	case SG_DXFER_FROM_DEV:
+		if (hp->dxferp || hp->dxfer_len < 0)
+			return false;
+		return true;
+	case SG_DXFER_TO_DEV:
 	case SG_DXFER_TO_FROM_DEV:
 		if (!hp->dxferp || hp->dxfer_len == 0)
 			return false;
-- 
2.12.3
