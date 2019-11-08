Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5E2FA372C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 264A8207FA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214005;
	bh=KR/XtuCzIOL4dCalrzh143CV+F7Iu36qeYgshnJDqtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TdV4XYwk1sR8YBiXI1kjxmyTlku/bbEwdO0oi1h1GWC4HkTC2PLDSBA871FbOzIQl
	 2Ya0mzO+gxgza993Qk+kgvDJnB+/1tND+uMx/3m8TbjpkOq2n1ps8zDURZS7XqkSHg
	 VJWZN8gmg+DwdUJFhlQRHpzS2DO4EN84iTecnD+4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391430AbfKHLqr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:46:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391424AbfKHLqq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C05F222473;
        Fri,  8 Nov 2019 11:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213605;
        bh=KR/XtuCzIOL4dCalrzh143CV+F7Iu36qeYgshnJDqtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQi8OF/vdkY0ezYNifYSZ8ZVsuFAIfsm/Rz4+5EbfJznVPEr1AuyrTi4GPX37KT0J
         OVBrp2E99b1swg74i+kdkQuBaoUt3yUVMoeZXp9ITAxcc5TaFS3OPW7QAWpVnVG9nc
         fjKZ1TtJactybk0yZmF/SgVJwq6aqxPVd/AkwzGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 43/64] scsi: pm80xx: Corrected dma_unmap_sg() parameter
Date:   Fri,  8 Nov 2019 06:45:24 -0500
Message-Id: <20191108114545.15351-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Deepak Ukey <deepak.ukey@microchip.com>

[ Upstream commit 76cb25b058034d37244be6aca97a2ad52a5fbcad ]

For the function dma_unmap_sg(), the <nents> parameter should be number of
elements in the scatter list prior to the mapping, not after the mapping.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index ce584c31d36e5..d1fcd21f7f7dd 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -466,7 +466,7 @@ static int pm8001_task_exec(struct sas_task *task,
 	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
 	if (!sas_protocol_ata(t->task_proto))
 		if (n_elem)
-			dma_unmap_sg(pm8001_ha->dev, t->scatter, n_elem,
+			dma_unmap_sg(pm8001_ha->dev, t->scatter, t->num_scatter,
 				t->data_dir);
 out_done:
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-- 
2.20.1

