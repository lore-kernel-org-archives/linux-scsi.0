Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71ECBC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 12:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DCF16120D
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 12:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbhKHMLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 07:11:31 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:18555 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239397AbhKHML1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 07:11:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636373324; x=1667909324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=UgIeZhHhFCvWkz7a2C4s/pc1I+RA/IV4MdJK1v7cpyo=;
  b=CC3BYbznMZVClTnKHFLBgHiWwl3wH2qwNmDQGIfba6Xhh6YW/W+pr0iB
   3To/03IE4Dchce5F0+EL8YghSWe+AXaA015+jFzcOhUq6GTkURvN5dja/
   2Vmi3BkMBAu1aKEtZpK0yKR4zEau2HkW9N0wXRosWoXrpNdR25/UB9h2S
   voWu9kjUpXwc5Y8MNswcAOXk7MaTVOZdcoithHgrhloGimkcw94fqWdek
   6Jn5KW6j/IiwAuyBBgLY3P9lbsHJIJzuUp4QrQ5E0yXyN0l8iuwhiM+gm
   BovB44/2N0xhVKR5QSR6biRJj7K/h8MqHgP2TQJV4AXk/v/DkZsIjg2s/
   g==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="186004981"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2021 20:08:44 +0800
IronPort-SDR: OSnO3e4Di7GTuCxTFQs0R0ZF+aWXP8ZtQgr40N8UbkV+YbLgwPG+mVjfkPTKCkVLR8N2Wv8hBe
 FLzLrhV8eRLVgV/H74V54Df03wevdHe378DgI4hGrRN84ni+qFcCZFTIQwSMsUQe2lpghbIPre
 7uMmuY2HJkFcXjLOAydPQYjgfEQNEH2qjkFxs0etkV8a3NW040NBaKY38Z9rCp8q6VHNk7dpjh
 mY5oZ9rR8ccrzNAaZ6FuSI7Yg7pfCNdaoiutZdcXjVMxqjhwVxrqCFXIWf6InEDUl68YfGJDPS
 K4aYvkfj+1lJt7Y8b+YK/TJY
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 03:43:57 -0800
IronPort-SDR: FMwohQDm909k9GAVDcLncd0NHveJjNrD2kiB7t2wfqC5sYwwGfgQvZj/6o3Ge1jHZqWlguP/Bk
 y8IrVulXrUu6KN2dzTKtgeWYXyq/UpQsn1gRGO3yqLoCHxz+ffS63VR9/CHm5GNCP0SAnn05Wu
 LxtHkgvHY/ex9HpxFmkS0VMOdzqNe9UzGRw7ARyZdc7KiiQ4wJ6RZdZbxnAPHidT1OoJXelFF/
 PuwOT21YDE1MJQm53mvGQyG1YjNtTHNotN2RhDI9k5ODsfIG6NfYE4IzecoFrOZSi/kaAM025X
 Vu0=
WDCIronportException: Internal
Received: from c8jqy33.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.157])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2021 04:08:40 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/2] scsi: ufs: Return a bsg request immediatley if eh-in-progress
Date:   Mon,  8 Nov 2021 14:08:04 +0200
Message-Id: <20211108120804.10405-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211108120804.10405-1-avri.altman@wdc.com>
References: <20211108120804.10405-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufs-bsg is attempting to access the device from user-space, and it is
unaware of the internal driver flows, specifically if error handling is
currently ongoing.

Fixes: 5e0a86eed846 (scsi: ufs: Add API to execute raw upiu commands)

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3869bb57769b..828061c05909 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6830,6 +6830,9 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 	enum utp_ocs ocs_value;
 	u8 tm_f = be32_to_cpu(req_upiu->header.dword_1) >> 16 & MASK_TM_FUNC;
 
+	if (!ufshcd_is_user_access_allowed(hba))
+		return -EBUSY;
+
 	switch (msgcode) {
 	case UPIU_TRANSACTION_NOP_OUT:
 		cmd_type = DEV_CMD_TYPE_NOP;
-- 
2.17.1

