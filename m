Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A57C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1121A246F2
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579196815;
	bh=FyYFts8tn0057p/q55l5LaATDl1O4cx7TvuYkipMPco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wBJb9lgZ/HxgVSn1RpJ1rOcs0ZI2DWdhgzTBW3K/6jrAQ3LP5Jf01cpYStyOSlZjC
	 jfVpxY/X4mP2qp6sUDetojl3JiXqpnpxmTH9A2L0pjABpzjqN2MmKMBlLw/qBcH1S4
	 JP/0Qf8g+DRuRaZHqZZ9cPWH2U1OeBhjCAOs5E28=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406826AbgAPRqy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406823AbgAPRqx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 12:46:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA9C8246DF;
        Thu, 16 Jan 2020 17:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196812;
        bh=FyYFts8tn0057p/q55l5LaATDl1O4cx7TvuYkipMPco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKdFk/zrXPfUBRa4bHCXEKats6QfAGhLmtgsKmJOwbKgQHV9I5Ei6grpi6xXi3vDA
         DIzkzdDCPzQ1GbqC0bny5+HLbeMAUPjU6F2Np32dgth3KaqO6bymDUax0kWB5MJJrk
         IcMjcCEq2ub1xQmWJkFKqWzspHRh5+PHb5DYlX0Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 169/174] scsi: bnx2i: fix potential use after free
Date:   Thu, 16 Jan 2020 12:42:46 -0500
Message-Id: <20200116174251.24326-169-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 29d28f2b8d3736ac61c28ef7e20fda63795b74d9 ]

The member hba->pcidev may be used after its reference is dropped. Move the
put function to where it is never used to avoid potential use after free
issues.

Fixes: a77171806515 ("[SCSI] bnx2i: Removed the reference to the netdev->base_addr")
Link: https://lore.kernel.org/r/1573043541-19126-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 72894378ffcf..81de52943b01 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -915,12 +915,12 @@ void bnx2i_free_hba(struct bnx2i_hba *hba)
 	INIT_LIST_HEAD(&hba->ep_ofld_list);
 	INIT_LIST_HEAD(&hba->ep_active_list);
 	INIT_LIST_HEAD(&hba->ep_destroy_list);
-	pci_dev_put(hba->pcidev);
 
 	if (hba->regview) {
 		pci_iounmap(hba->pcidev, hba->regview);
 		hba->regview = NULL;
 	}
+	pci_dev_put(hba->pcidev);
 	bnx2i_free_mp_bdt(hba);
 	bnx2i_release_free_cid_que(hba);
 	iscsi_host_free(shost);
-- 
2.20.1

