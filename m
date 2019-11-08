Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DACCEC5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A543B22459
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573213687;
	bh=zbwwBlaYHwL+rJY6Xyn+HDacEmixhwy2vSR2zBkAyNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bWJCXzSLLFZ+lRxaeBTMDvCCbcWwMX16NXC6lCsXbK8FmyrdCeS0YfFzaYPFmv2e9
	 zKxN4iwILh9I1Z560cdvvOtFCwljlyZLXI5QFvZcE94bMT2HttWgaLBpckjxE/0Zbs
	 JJBJfsYRS3mB5R/0dO3AJsq3C4ILiiZDX8Hp+Dbc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391707AbfKHLsE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:48:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390811AbfKHLsD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:48:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76AC42246A;
        Fri,  8 Nov 2019 11:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213682;
        bh=zbwwBlaYHwL+rJY6Xyn+HDacEmixhwy2vSR2zBkAyNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zALFeBM/wZIk1j2fBq5nvVgeQF1w48ti51d/+1LYseWW6hpmA7MMr95wFLfNC7b1z
         r+Xd+06QziRUozWoIWNCrvxuyEtaMhik2oWF5vpta6gyZA5JigSrsPrfJiAYkf2osW
         V8TJy7YwoHscSNttZpxf6ladAAf4km4/6DCKSPEM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 30/44] scsi: pm80xx: Corrected dma_unmap_sg() parameter
Date:   Fri,  8 Nov 2019 06:47:06 -0500
Message-Id: <20191108114721.15944-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
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
index 949198c01ced6..ef1687f798cc1 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -463,7 +463,7 @@ static int pm8001_task_exec(struct sas_task *task,
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

