Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D68C4CC77
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 14:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67D7B2224E
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 14:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587221008;
	bh=vU+2AAZL6lc+EETr5u0F7lT9UJ/xX/iksxwZJPHuOmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tdtsGSk0ZYRU4227NGlakFfcEVKYI1fs0fcOnwDzAr3i/4SKZYK9T9+ZZL7QTgC0p
	 uVolFPqFWfGEwiFLvxx1Gb1F+8TvNft752TUwpXpDzsnPUrl00gTDk25zDeN83QY3L
	 t7IyGxy0+J7DWTnRM4QrDtvNaPdPuEoF1VqUhrzM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgDROn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 10:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbgDROn0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 10:43:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B41421D82;
        Sat, 18 Apr 2020 14:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587221005;
        bh=vU+2AAZL6lc+EETr5u0F7lT9UJ/xX/iksxwZJPHuOmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eXVAXJrWGLmu4c2WjBk2sEnnq14va3olocuKk2c49kLDWaids4qGXafi27piWGho
         TDroH9O6uvC3MCmg0WNQxZHMVZMLUT8ThkaCEWzh3e31zNKUhMRIehG9Icw9ywNw7W
         RdMrKWgyKOzqtTgJa0MLzfbB/cGldpWU8h1anREs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Murthy Bhat <Murthy.Bhat@microsemi.com>,
        Scott Benesh <scott.benesh@microsemi.com>,
        Scott Teel <scott.teel@microsemi.com>,
        Kevin Barnett <kevin.barnett@microsemi.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, esc.storagedev@microsemi.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 46/47] scsi: smartpqi: fix call trace in device discovery
Date:   Sat, 18 Apr 2020 10:42:26 -0400
Message-Id: <20200418144227.9802-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144227.9802-1-sashal@kernel.org>
References: <20200418144227.9802-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microsemi.com>

[ Upstream commit b969261134c1b990b96ea98fe5e0fcf8ec937c04 ]

Use sas_phy_delete rather than sas_phy_free which, according to
comments, should not be called for PHYs that have been set up
successfully.

Link: https://lore.kernel.org/r/157048748876.11757.17773443136670011786.stgit@brunhilda
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_sas_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index b209a35e482ef..01dfb97b07786 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -50,9 +50,9 @@ static void pqi_free_sas_phy(struct pqi_sas_phy *pqi_sas_phy)
 	struct sas_phy *phy = pqi_sas_phy->phy;
 
 	sas_port_delete_phy(pqi_sas_phy->parent_port->port, phy);
-	sas_phy_free(phy);
 	if (pqi_sas_phy->added_to_port)
 		list_del(&pqi_sas_phy->phy_list_entry);
+	sas_phy_delete(phy);
 	kfree(pqi_sas_phy);
 }
 
-- 
2.20.1

