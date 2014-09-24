From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 10/35] qla2xxx: Fix potential return count bug in qla2xxx_get_vpd_field().
Date: Wed, 24 Sep 2014 03:08:13 -0400
Message-ID: <1411542518-2477-11-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:2227 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991AbaIXHmo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:44 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Call scnprintf() instead of snprintf() since the latter may return
an incorrect count in cases where the write is truncated to fit.

scnprintf() returns the count of what was actually written;
snprintf() returns the count of what would have been written.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 04b3701..4788ecd0 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -3163,7 +3163,7 @@ qla2xxx_get_vpd_field(scsi_qla_host_t *vha, char *key, char *str, size_t size)
 	}
 
 	if (pos < end - len && *pos != 0x78)
-		return snprintf(str, size, "%.*s", len, pos + 3);
+		return scnprintf(str, size, "%.*s", len, pos + 3);
 
 	return 0;
 }
-- 
1.7.7

