From: Andrey Grafin <Andrey.Grafin@acronis.com>
Subject: [PATCH] fcoe-utils: Fix get_ctlr_num() for large ctlr_* indices
Date: Mon, 18 Sep 2017 17:35:08 +0300
Message-ID: <20170918143508.4659-1-Andrey.Grafin@acronis.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us-edge-1.acronis.com ([69.20.59.99]:38714 "EHLO
        us-edge-1.acronis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755804AbdIROyd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2017 10:54:33 -0400
Received: from 31.nat.acronis.net ([91.195.22.31] helo=ru-exch-1.corp.acronis.com)
        by us-edge-1.acronis.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        (Exim 4.89)
        (envelope-from <Andrey.Grafin@acronis.com>)
        id 1dtx8o-0000TK-KA
        for linux-scsi@vger.kernel.org; Mon, 18 Sep 2017 10:35:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrey Grafin <Andrey.Grafin@acronis.com>

Each creation of a FCoE device increases counter which is used as a suffix
in a FCoE device name in sysfs (i.e. /sys/bus/fcoe/devices/ctlr_1).
Once this counter reaches the value of two digits (10 and larger),
get_ctlr_num() stopped working properly and a command like `fcoeadm -i`
which depends on get_ctlr_num() call doesn't show anything.
This patch solves this problem.

Signed-off-by: Andrey Grafin <Andrey.Grafin@acronis.com>
---
 lib/sysfs_hba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/sysfs_hba.c b/lib/sysfs_hba.c
index 5cb7fd3fa5d..786215440ba 100644
--- a/lib/sysfs_hba.c
+++ b/lib/sysfs_hba.c
@@ -606,7 +606,7 @@ static int get_ctlr_num(const char *netdev)
 		if (!ctlr)
 			continue;
 
-		ctlr_num = atoi(&ctlr[strlen(ctlr) - 1]);
+		ctlr_num = atoi(&ctlr[sizeof("ctlr_") - 1]);
 		break;
 	}
 
-- 
2.11.0
