Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E40C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 10:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiKOK1C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 05:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiKOK1B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 05:27:01 -0500
X-Greylist: delayed 427 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Nov 2022 02:26:57 PST
Received: from forward107j.mail.yandex.net (forward107j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1922011C36;
        Tue, 15 Nov 2022 02:26:56 -0800 (PST)
Received: from myt6-bd59def10a3e.qloud-c.yandex.net (myt6-bd59def10a3e.qloud-c.yandex.net [IPv6:2a02:6b8:c12:2487:0:640:bd59:def1])
        by forward107j.mail.yandex.net (Yandex) with ESMTP id 0FF6E884C30;
        Tue, 15 Nov 2022 13:19:48 +0300 (MSK)
Received: by myt6-bd59def10a3e.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id AlCOAl4E1M-JkV4efNG;
        Tue, 15 Nov 2022 13:19:47 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1668507587;
        bh=WyR9RdzF47Mc2cwew/z92Lbra+oLzJgiwxbIVABBUCQ=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=DM5vR0OJd6y0MFkLA4eLT5yI2IqOgaTdtcHbbiJchDEYyjkQ38RxEOpHaX4Rsu+MA
         r2zpz6eSmqCGpzM3ZnOEIaIsPCwPdOOkxO6l8XaqgOMYO6jgz5oGHPGlb+RsshYAF9
         HxeI+jRCdvd5w24tpHckc/rm5WhvY8cGmRBpNoXo=
Authentication-Results: myt6-bd59def10a3e.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     Don Brace <don.brace@microchip.com>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] scsi: hpsa: check retval of hpsa_scsi_do_simple_cmd_with_retry()
Date:   Tue, 15 Nov 2022 13:19:42 +0300
Message-Id: <20221115101942.161971-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The only place where retval of hpsa_scsi_do_simple_cmd_with_retry()
is not checked.

Add check for retval.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
---
 drivers/scsi/hpsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f8e832b1bc46..21c3e33bffde 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3424,8 +3424,10 @@ static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
 	c->Request.CDB[2] = bmic_device_index & 0xff;
 	c->Request.CDB[9] = (bmic_device_index >> 8) & 0xff;
 
-	hpsa_scsi_do_simple_cmd_with_retry(h, c, DMA_FROM_DEVICE,
+	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c, DMA_FROM_DEVICE,
 						NO_TIMEOUT);
+	if (rc)
+		goto out;
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		hpsa_scsi_interpret_error(h, c);
-- 
2.38.1

