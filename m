From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
Subject: [PATCH next] scsi: fcoe: fix off by one in eth2fc_speed()
Date: Wed, 21 Sep 2016 22:54:07 +0200
Message-ID: <20160921205407.6304-1-vincent.stehle@laposte.net>
References: <1471613617-21291-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpoutz26.laposte.net ([194.117.213.101]:60662 "EHLO
        smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756216AbcIUVP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2016 17:15:26 -0400
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout014 (Postfix) with ESMTP id BB370121395
        for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2016 22:54:19 +0200 (CEST)
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout014 (Postfix) with ESMTP id AE6FF12139D
        for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2016 22:54:19 +0200 (CEST)
Received: from lpn-prd-vrin004 (lpn-prd-vrin004.laposte [10.128.63.5])
        by lpn-prd-vrout014 (Postfix) with ESMTP id AB4AC121395
        for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2016 22:54:19 +0200 (CEST)
Received: from lpn-prd-vrin004 (localhost [127.0.0.1])
        by lpn-prd-vrin004 (Postfix) with ESMTP id 987E0710208
        for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2016 22:54:19 +0200 (CEST)
In-Reply-To: <1471613617-21291-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

This should be "< ARRAY_SIZE()" instead of "<= ARRAY_SIZE()".

Fixes: 0b924e5505a568e7 ("scsi: fcoe: provide translation table between Ethernet and FC port speeds")
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---

Hi,

I saw that in Linux next-20160921.

Best regards,

Vincent.

 drivers/scsi/fcoe/fcoe_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index c164eec..375c536 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -110,7 +110,7 @@ static inline u32 eth2fc_speed(u32 eth_port_speed)
 {
 	int i;
 
-	for (i = 0; i <= ARRAY_SIZE(fcoe_port_speed_mapping); i++) {
+	for (i = 0; i < ARRAY_SIZE(fcoe_port_speed_mapping); i++) {
 		if (fcoe_port_speed_mapping[i].eth_port_speed == eth_port_speed)
 			return fcoe_port_speed_mapping[i].fc_port_speed;
 	}
-- 
2.9.3

