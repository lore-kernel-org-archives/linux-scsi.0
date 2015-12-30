From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] scsi_transport_fc: remove useless check
Date: Wed, 30 Dec 2015 12:18:44 +0100
Message-ID: <1451474324-15481-3-git-send-email-a.hajda@samsung.com>
References: <1451474324-15481-1-git-send-email-a.hajda@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1451474324-15481-1-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

simple_strtoul returns only non-negative values and *val is unsigned
so there is no possibility that *val is lesser than 0.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2038576

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8a88226..ecf62d9 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -849,7 +849,7 @@ static int fc_str_to_dev_loss(const char *buf, unsigned long *val)
 	char *cp;
 
 	*val = simple_strtoul(buf, &cp, 0);
-	if ((*cp && (*cp != '\n')) || (*val < 0))
+	if (*cp && (*cp != '\n'))
 		return -EINVAL;
 	/*
 	 * Check for overflow; dev_loss_tmo is u32
-- 
1.9.1
