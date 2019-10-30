Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D913FCA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B6172173E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572450819;
	bh=H+SBg5nFP1mEIy+aYH89VCOepatSi1ui+bvRd8UdPKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p1zmZlNVZYebL8gQSYD8VXhQ5HNKyxIRzel0PMnKLlOuR4RJm+2rvLy9psMsZ+zyP
	 qSaSTjCUGOE9COYYjob9sCEREoHORH1o3OCuHkZ5IoCV+2p1v8CxoCPiFWuaWP1/sU
	 +baOq8TswWWS/MkaqNOaYk3N+QtWFYTlZoivJMHQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfJ3Pxj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbfJ3Pxi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Oct 2019 11:53:38 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01829208C0;
        Wed, 30 Oct 2019 15:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450817;
        bh=H+SBg5nFP1mEIy+aYH89VCOepatSi1ui+bvRd8UdPKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/oKUNcxVQ/GCb/WvRAsEPt55TFjxTMIm4hz7wrYYg1G8vaLE8LLJ7JblQio2ii3H
         dPd9aqZSizHuxVpmgvnsKQa75S/LfQKkF33PoXPTtkB06d+63NoMePYuWGDHD3Jj5G
         zFbBKx6tcuY+AFcd/BnT2ru0o9Cr0b0Q+Vs9Hxyw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Don Brace <don.brace@microsemi.com>,
        Scott Benesh <scott.benesh@microsemi.com>,
        Kevin Barnett <kevin.barnett@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, esc.storagedev@microsemi.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 58/81] scsi: hpsa: add missing hunks in reset-patch
Date:   Wed, 30 Oct 2019 11:49:04 -0400
Message-Id: <20191030154928.9432-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Don Brace <don.brace@microsemi.com>

[ Upstream commit 134993456c28c2ae14bd953236eb0742fe23d577 ]

Correct returning from reset before outstanding commands are completed
for the device.

Link: https://lore.kernel.org/r/157107623870.17997.11208813089704833029.stgit@brunhilda
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1bb6aada93fab..a4519710b3fcf 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5478,6 +5478,8 @@ static int hpsa_ciss_submit(struct ctlr_info *h,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	c->device = dev;
+
 	enqueue_cmd_and_start_io(h, c);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
 	return 0;
@@ -5549,6 +5551,7 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 		hpsa_cmd_init(h, c->cmdindex, c);
 		c->cmd_type = CMD_SCSI;
 		c->scsi_cmd = cmd;
+		c->device = dev;
 		rc = hpsa_scsi_ioaccel_raid_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -5556,6 +5559,7 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 		hpsa_cmd_init(h, c->cmdindex, c);
 		c->cmd_type = CMD_SCSI;
 		c->scsi_cmd = cmd;
+		c->device = dev;
 		rc = hpsa_scsi_ioaccel_direct_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;
-- 
2.20.1

