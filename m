Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F35B4CCA489
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 02:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243724AbiF1CYZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 22:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243790AbiF1CVy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 22:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9B924F23;
        Mon, 27 Jun 2022 19:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 526C161852;
        Tue, 28 Jun 2022 02:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344D1C34115;
        Tue, 28 Jun 2022 02:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382887;
        bh=eNniy0Kmh5T69pDeELmX4we8oQUPfZo885vIdUET7Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vaw+6C1sw/2irosJXCUUA2nTm6G6e9ohsOq3//ClaNk4gUqwRiK4OwtMdLdo6aevh
         n1Qo72FaWM6NtB9cIpBbXi5KHzLhoOCHAdZgKH1YYPkqIgsuhLv3NUgtfOZmxutmQf
         IhO2K8cI4jA9TQlNdw6o+8rAS3qfEyCC+ubcD+H8qIWwAkIVY7nIgwWNDR/lR9Gry7
         tyg6gOp1nS5bRy3HDmN2iNrEoZtNhT9tPmg2UCN6F34B/64G4oZgNXR/MNYjcSWtEI
         tCLBCoqN9W0MVHcn7SeBcBUmy5qUGUzbuDq9kUhyfPC5kCsk5HUYGk2y46NHaD1FOk
         J3L/rYTJlfxgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, beanhuo@micron.com, avri.altman@wdc.com,
        daejun7.park@samsung.com, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 12/41] scsi: ufs: Simplify ufshcd_clear_cmd()
Date:   Mon, 27 Jun 2022 22:20:31 -0400
Message-Id: <20220628022100.595243-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit da8badd7d3583f447eac2ab65a332f2d773deca1 ]

Remove the local variable 'err'. This patch does not change any
functionality.

Link: https://lore.kernel.org/r/20220613214442.212466-2-bvanassche@acm.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5c9a31f18b7f..311170e63410 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2798,7 +2798,6 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 static int
 ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 {
-	int err = 0;
 	unsigned long flags;
 	u32 mask = 1 << tag;
 
@@ -2811,11 +2810,8 @@ ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 	 * wait for h/w to clear corresponding bit in door-bell.
 	 * max. wait is 1 sec.
 	 */
-	err = ufshcd_wait_for_register(hba,
-			REG_UTP_TRANSFER_REQ_DOOR_BELL,
-			mask, ~mask, 1000, 1000);
-
-	return err;
+	return ufshcd_wait_for_register(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL,
+					mask, ~mask, 1000, 1000);
 }
 
 static int
-- 
2.35.1

