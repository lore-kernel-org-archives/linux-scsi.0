Return-Path: <SRS0=LfzD=YC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB0EECE58C
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 17:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0377206BB
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 17:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570642112;
	bh=LW+VhAvO5inmcOI9PKMnX5A3MCYkSC9vy+BBhmlKkKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p9kX8L/t4n3Ho6XDoxOmDQA5OhtaZ0NwwALT3IHwWvsDt6cuzelcV9b2DWHW3dB9/
	 MkZCoARFqP5JfWP5NoZzcU3WedEySrD7rAGUDyEu2tYYrejApKhOr9yxLce9REYudk
	 0Der7tCsP9pIxAfhc6E1vzDlaCq51mCxIjZ8bjKY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732382AbfJIR21 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 13:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732284AbfJIRYY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:24 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D9A621920;
        Wed,  9 Oct 2019 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641864;
        bh=LW+VhAvO5inmcOI9PKMnX5A3MCYkSC9vy+BBhmlKkKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6K36boCtDzdPHMH0qXNrFtCyY8muapBHJnze+O4pMVlarS4OSoAut+woG6IDZrp4
         ArMXrcs5hLCV1hc4x4X1kd9jaquHDgiww5t0ncTCQSI2etCvFimPsoDUebwxYNiNx8
         rZ6e110mfpkpGuxPVT7x+btfHUNZldVenv1QHAOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/21] scsi: megaraid: disable device when probe failed after enabled device
Date:   Wed,  9 Oct 2019 13:05:56 -0400
Message-Id: <20191009170615.32750-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170615.32750-1-sashal@kernel.org>
References: <20191009170615.32750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 70054aa39a013fa52eff432f2223b8bd5c0048f8 ]

For pci device, need to disable device when probe failed after enabled
device.

Link: https://lore.kernel.org/r/1567818450-173315-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 9b6f5d024dbae..f5c09bbf93741 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4221,11 +4221,11 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		 */
 		if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ &&
 		    pdev->subsystem_device == 0xC000)
-		   	return -ENODEV;
+			goto out_disable_device;
 		/* Now check the magic signature byte */
 		pci_read_config_word(pdev, PCI_CONF_AMISIG, &magic);
 		if (magic != HBA_SIGNATURE_471 && magic != HBA_SIGNATURE)
-			return -ENODEV;
+			goto out_disable_device;
 		/* Ok it is probably a megaraid */
 	}
 
-- 
2.20.1

