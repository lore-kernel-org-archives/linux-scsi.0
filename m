Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AF3C77B7E
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 07:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjE2HfW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 03:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjE2HfV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 03:35:21 -0400
Received: from smtp.smtpout.orange.fr (smtp-27.smtpout.orange.fr [80.12.242.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B737AC
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 00:35:20 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id 3XPKqHvCt7PLm3XPKqcUIc; Mon, 29 May 2023 09:35:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1685345713;
        bh=2bdE5rxx0WNW70pykzA3LEgDROeECRTKYNJpXeGJheA=;
        h=From:To:Cc:Subject:Date;
        b=Cd9iq3K/CU8lcBda2pvGwM8YS8As0QUQU9FdZ5ldnukC40VE3f0SzxYU5LOuKwGvx
         hVP5ReGttXo7LC71uSjjMO38DQ6S8N0zcoirt+/GPGacR2L55UAJYZGnuk5GeS3h77
         Z7avrHlEZM8W2qmTeHLY3QqK7p+3atNl1ixZyxJsbUzLDjs2qysoL+ORkAXyeRAwkb
         +GIMo6vGGsKR/MzzlL7LPO2nj+nN7g5+5Mlm9sVNXKmnbS2lFZ97+nreUdSlPno89j
         sCp40vhU8/yCOin6MujsXWCujiGjP5o70epm/YUmfQI0sPSr6yr/CCFKpD0LR7g95Q
         PRifGMxA9exbg==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 29 May 2023 09:35:13 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: virtio_scsi: Remove a useless function call
Date:   Mon, 29 May 2023 09:35:08 +0200
Message-Id: <08740635cdb0f8293e57c557b22e048daae50961.1685345683.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'inq_result' is known to be NULL. There is no point calling kfree().

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/virtio_scsi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 58498da9869a..bd5633667d01 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -338,10 +338,8 @@ static int virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 	int result, inquiry_len, inq_result_len = 256;
 	char *inq_result = kmalloc(inq_result_len, GFP_KERNEL);
 
-	if (!inq_result) {
-		kfree(inq_result);
+	if (!inq_result)
 		return -ENOMEM;
-	}
 
 	shost_for_each_device(sdev, shost) {
 		inquiry_len = sdev->inquiry_len ? sdev->inquiry_len : 36;
-- 
2.34.1

