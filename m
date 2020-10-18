Return-Path: <SRS0=jquQ=DZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA27C4363D
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7064322268
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603050894;
	bh=LIpUrziyljBAN1hf5DHqJwvFPUDd6olNxSS9xgWO450=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p0VROWDF3AW5bImxEzEp/X6lluOh+S54Kq2D/Drjnyq0TiyhZQVcbgV/Vf1vFBUX/
	 3q4UUcgDyBtPwof5rnrAXxRowqs2ZvW8CTbi/XPU2hQeTcIIiNUGXgzu9Cnd8ROJ0L
	 2vpw59T8rymurffFjOTgxKAW25Av4nxAlMA9C3ks=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgJRTUP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbgJRTUO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Oct 2020 15:20:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C04022365;
        Sun, 18 Oct 2020 19:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048814;
        bh=LIpUrziyljBAN1hf5DHqJwvFPUDd6olNxSS9xgWO450=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxfHl7bQWEA36KjsE+p6Ufl+hm3JDlWps/oKZ2e7zf0xYBk/oo1T9pr+bl5mw4L1V
         yO4wV6ux76yEImR7rDaABVGjRn7SRWnD0gBWjLpQSeZeZGI4bscdSXe0DzRZU77zpq
         UGkUFluqstwqZ1g/iR5q7n7y0sJmrps42bc5hqmk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>, Hongwu Su <hongwus@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 104/111] scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()
Date:   Sun, 18 Oct 2020 15:18:00 -0400
Message-Id: <20201018191807.4052726-104-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 89dd87acd40a44de8ff3358138aedf8f73f4efc6 ]

If ufs_qcom_dump_dbg_regs() calls ufs_qcom_testbus_config() from
ufshcd_suspend/resume and/or clk gate/ungate context, pm_runtime_get_sync()
and ufshcd_hold() will cause a race condition. Fix this by removing the
unnecessary calls of pm_runtime_get_sync() and ufshcd_hold().

Link: https://lore.kernel.org/r/1596975355-39813-3-git-send-email-cang@codeaurora.org
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index d0d75527830e9..823eccfdd00af 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1614,9 +1614,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	 */
 	}
 	mask <<= offset;
-
-	pm_runtime_get_sync(host->hba->dev);
-	ufshcd_hold(host->hba, false);
 	ufshcd_rmwl(host->hba, TEST_BUS_SEL,
 		    (u32)host->testbus.select_major << 19,
 		    REG_UFS_CFG1);
@@ -1629,8 +1626,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	 * committed before returning.
 	 */
 	mb();
-	ufshcd_release(host->hba);
-	pm_runtime_put_sync(host->hba->dev);
 
 	return 0;
 }
-- 
2.25.1

