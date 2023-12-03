Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A57CA
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:19 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-0005gj-DZ; Sun, 03 Dec 2023 17:06:14 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oyz-00DK9k-VG; Sun, 03 Dec 2023 17:06:13 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oyz-00DPok-MH; Sun, 03 Dec 2023 17:06:13 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 04/14] scsi: bvme6000: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:49 +0100
Message-ID:  <63294479a4e745210c078859afa88904fa0b3be8.1701619134.git.u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <cover.1701619134.git.u.kleine-koenig@pengutronix.de>
References: <cover.1701619134.git.u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1939; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=VV4C+G6hMx/6FssRYN2AFgESyXZ/RflBMYdYp3IpIzk=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKddQcpjmukbav+hG9LU2IZI5omLEd3RQ/YZR eGo7haRNXWJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynXQAKCRCPgPtYfRL+ TgnrB/9m9dLxzcW1PCX7QJTvKYUhzZmd7/ApihvYoZXA+oznRS6f4WGsQUr5eU/Gh+gzxy2cQoO D/yZFQ+1sCUUNkppL2aBD9v5/GM5nvLtcfvcT6X4a+p9GCKKw9zJW3vvl9mhKRorgfrOC/87cjD Itu2xuDA6bCJ63oz9xiog1QJFp1HwrJeDvQLb8YP6q5VXlce0d5YdA1QFaVwpl+tt0b8BAOqSWw GwoVSg/wstNwnOx7J2QoWkU0wufoWupdeGPLzmcEzeuyodVEt5TQd6ZeD2TdQ+MM10x69k/TvHg e6aspn0smq0XTnMWyJ11wnB1vvJmXso+Ab68rVXg0GuGd+DE
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-scsi@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

In the error path emit an error message replacing the (less useful)
message by the core. Apart from the improved error message there is no
change in behaviour.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/scsi/bvme6000_scsi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
index 8d72b25535c5..f893e9779e9d 100644
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -89,7 +89,7 @@ bvme6000_probe(struct platform_device *dev)
 	return -ENODEV;
 }
 
-static int
+static void
 bvme6000_device_remove(struct platform_device *dev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(dev);
@@ -99,8 +99,6 @@ bvme6000_device_remove(struct platform_device *dev)
 	NCR_700_release(host);
 	kfree(hostdata);
 	free_irq(host->irq, host);
-
-	return 0;
 }
 
 static struct platform_driver bvme6000_scsi_driver = {
@@ -108,7 +106,7 @@ static struct platform_driver bvme6000_scsi_driver = {
 		.name		= "bvme6000-scsi",
 	},
 	.probe		= bvme6000_probe,
-	.remove		= bvme6000_device_remove,
+	.remove_new	= bvme6000_device_remove,
 };
 
 static int __init bvme6000_scsi_init(void)
-- 
2.42.0

