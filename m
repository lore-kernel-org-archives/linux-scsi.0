Return-Path: <SRS0=LfzD=YC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B68ECE58C
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 17:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64E77206BB
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 17:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570642267;
	bh=7thJGh8wgTLrA4H1iy8iuAhzw2uXgJIQcuahMt884cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JLnrekpd7jVcOHRW6JkvRcvFP31HJ2QXj1ckDpWijG4TzMJ/XOnxBEf4BbZiyD+1G
	 z6JaLltdVm8Dh90rDq8ZyoynBb5d1dRTiM+KfgNaZL99InI95XgFAus/gqK2ZOPGSt
	 9lW8AHg4dT/pY4nerf2sNnIjS6I2uzvyP0QTqcp8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732665AbfJIRbG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 13:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732099AbfJIRYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:04 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ED5321D56;
        Wed,  9 Oct 2019 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641844;
        bh=7thJGh8wgTLrA4H1iy8iuAhzw2uXgJIQcuahMt884cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dwcc1q+WUP01Tjxg3bQb9aM80WxTBvtiXz0mwALwEnBgXYHYniuGelO83uU12skh9
         XpB6W82e3MqUsbDO92nYWm+we57sSKI3fqBWcRMtrufql4XkS/KWLSiWpHcy7+d6es
         a3UBol6gBu+EB+bW6BwS8UBS+/LWKmxSC5UDxeAU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/26] scsi: ufs: skip shutdown if hba is not powered
Date:   Wed,  9 Oct 2019 13:05:35 -0400
Message-Id: <20191009170558.32517-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit f51913eef23f74c3bd07899dc7f1ed6df9e521d8 ]

In some cases, hba may go through shutdown flow without successful
initialization and then make system hang.

For example, if ufshcd_change_power_mode() gets error and leads to
ufshcd_hba_exit() to release resources of the host, future shutdown flow
may hang the system since the host register will be accessed in unpowered
state.

To solve this issue, simply add checking to skip shutdown for above kind of
situation.

Link: https://lore.kernel.org/r/1568780438-28753-1-git-send-email-stanley.chu@mediatek.com
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Acked-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b8b59cfeacd1f..4aaba3e030554 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7874,6 +7874,9 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 {
 	int ret = 0;
 
+	if (!hba->is_powered)
+		goto out;
+
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
 		goto out;
 
-- 
2.20.1

