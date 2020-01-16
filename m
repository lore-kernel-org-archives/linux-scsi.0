Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830B5C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 18:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 547B8217F4
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 18:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579197646;
	bh=KANMXqY2ympshQ9I2mDY5g00urWBmk6k715DSTjsi58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FIdD/P76K2QeOW6yeXqj5Oc4F/o4rCm8JCLsNS+bkjrswS+K5gz6z0bUbJlRA/HtO
	 xXJs4OAbwN3HeB98dh2xyJy4OXvv4R2DhhBt/3xPw39dT0s13WzCJo4J4p34gd+gaJ
	 VZoBjTIJ5bPHBOX/AGrQ2MwvZhwwSjMoAy08xPwk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394677AbgAPSAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 13:00:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391606AbgAPRlm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 12:41:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB412246A4;
        Thu, 16 Jan 2020 17:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196501;
        bh=KANMXqY2ympshQ9I2mDY5g00urWBmk6k715DSTjsi58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxgph0ETulLmkEZJ3vFHaJtOVLwYL47vEEDIFoQI4JZ+o5LkHPNHfESB42kK9fZvZ
         ofckfshlNyd+/tLawRh6SxdZxa2va9876W0/B3oPyCO48bNm5tKHqkej1aIQy026b9
         3N0LlfGAs/sQ0sS8LYsehItkNsk3SjD+I7WuBN/4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 243/251] scsi: qla4xxx: fix double free bug
Date:   Thu, 16 Jan 2020 12:36:32 -0500
Message-Id: <20200116173641.22137-203-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 3fe3d2428b62822b7b030577cd612790bdd8c941 ]

The variable init_fw_cb is released twice, resulting in a double free
bug. The call to the function dma_free_coherent() before goto is removed to
get rid of potential double free.

Fixes: 2a49a78ed3c8 ("[SCSI] qla4xxx: added IPv6 support.")
Link: https://lore.kernel.org/r/1572945927-27796-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index c291fdff1b33..ea3b77ba12a2 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -641,9 +641,6 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 
 	if (qla4xxx_get_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma) !=
 	    QLA_SUCCESS) {
-		dma_free_coherent(&ha->pdev->dev,
-				  sizeof(struct addr_ctrl_blk),
-				  init_fw_cb, init_fw_cb_dma);
 		goto exit_init_fw_cb;
 	}
 
-- 
2.20.1

