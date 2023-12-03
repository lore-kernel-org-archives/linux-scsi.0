Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D598FFF
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:19 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-0005gh-DZ; Sun, 03 Dec 2023 17:06:14 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oyz-00DK9e-ID; Sun, 03 Dec 2023 17:06:13 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oyz-00DPoc-9F; Sun, 03 Dec 2023 17:06:13 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 02/14] scsi: a4000t: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:47 +0100
Message-ID:  <c15ffc57efebc5da3f7e6dd558d69181e129cafe.1701619134.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2006; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=KzSqkQS+P+EAs50HUDLbAV72d+j525CgjL8snTXrU2M=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKdanxP0l9h7zpQ2OK3kJQheNg7pwaiKNxvci hEg/uqVqt2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynWgAKCRCPgPtYfRL+ TrwBB/0RsEXAgHedciw4T23tqItOhKnDusdIzRtyAHIU73fnQWNPaHy2e8L2JZx7ULFm5AdHg9d xmOP9rvuMgepnU/W1W9wj3R1VRLwaNAI55gZHfIyj4iWQZgq4cOuHT+Hi5oqkg0iPEtoiz8PvZn qyQvMk6sCmNvWg41HWGGjX2Mfm9m+Xg+xqmA1JHJzO5IQNUdhG5iUOYVfhgEa3AyNJAPsTUMCEl buSRCEYQsbCjlAe6lWhMBMhLl5ZRDWBwp9MOJJ/bGkCqObPvhBEeQ3vOzOmCDk8juCh5Lu9XPyS 9zMS9hg5qAiA+9cftyQinyKsWhQzUnh3wffyHhKz1hEmYkMa
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
 drivers/scsi/a4000t.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index 5e575afce134..e435fc06a624 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -95,7 +95,7 @@ static int __init amiga_a4000t_scsi_probe(struct platform_device *pdev)
 	return -ENODEV;
 }
 
-static int __exit amiga_a4000t_scsi_remove(struct platform_device *pdev)
+static void __exit amiga_a4000t_scsi_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(pdev);
 	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
@@ -106,11 +106,10 @@ static int __exit amiga_a4000t_scsi_remove(struct platform_device *pdev)
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	release_mem_region(res->start, resource_size(res));
-	return 0;
 }
 
 static struct platform_driver amiga_a4000t_scsi_driver = {
-	.remove = __exit_p(amiga_a4000t_scsi_remove),
+	.remove_new = __exit_p(amiga_a4000t_scsi_remove),
 	.driver   = {
 		.name	= "amiga-a4000t-scsi",
 	},
-- 
2.42.0

