Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A79FC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 14:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCF8920829
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600094483;
	bh=smosWQJtzf9OCK707eZ7sXNL7LuRiSRCMkBZM9vIZlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=o3ziqbP2uv+Kyem2lqttl9ppXcBquRFi6U3OwszKasb4z1K3h5qa3CIbbV0vm/O3U
	 A2NcoM1tiuSBpp0BhwmRog0MyVzfaufcoUzMiVU7HAxAfanXLJ1jUUcwxH77skHXUY
	 ewPqF2Zfjgqxgk87IX7v1bX/dQK2E5Rw6W62hbjE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgINOks (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 10:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgINNFm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67E6621D24;
        Mon, 14 Sep 2020 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088707;
        bh=smosWQJtzf9OCK707eZ7sXNL7LuRiSRCMkBZM9vIZlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7SLrCr/kOGIRzajxuUWvk0B7LISGausgGrZxcit9km+b5cQwCRQK7oGNqUBpxWmP
         1ebWwIXg89ixmqjBjVR39iLO/yJjc70Svwbf1BUnWADjNuZtpB3iLG4G/RNZSROHWL
         bA9qVYHtkwt4Y2VN6novhmcRR6mGPmWSwVHf1cx4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/19] scsi: libfc: Fix for double free()
Date:   Mon, 14 Sep 2020 09:04:46 -0400
Message-Id: <20200914130502.1804708-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130502.1804708-1-sashal@kernel.org>
References: <20200914130502.1804708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 5a5b80f98534416b3b253859897e2ba1dc241e70 ]

Fix for '&fp->skb' double free.

Link:
https://lore.kernel.org/r/20200825093940.19612-1-jhasan@marvell.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_disc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 78cf5b32bca67..0b3f4538c1d4d 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -646,8 +646,6 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	fc_frame_free(fp);
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
-	if (!IS_ERR(fp))
-		fc_frame_free(fp);
 }
 
 /**
-- 
2.25.1

