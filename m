Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F7AC33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC7BE24695
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579197139;
	bh=wCWvTwy7+lNxDWwzm1AyIA6v/IHLDstadwUxirEZ5fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ed3vUTK0od3ILkW1DsYAEvzWppGHyspiCOMwgZHkJXsiQoZrZn1Vv+cvpaafxcDwJ
	 nCX1Tsp6IbISHfhi9yVEeEJRpH3UJ6JYj6PZaaUt+QL7ApJdNfxDz/VZrsaSXV0EBZ
	 exquQQq3rz5sm2RT/CanWqoCGVNZ3A9fdVMlNEuk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406206AbgAPRwQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:52:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406188AbgAPRpZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 12:45:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E0D52477A;
        Thu, 16 Jan 2020 17:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196725;
        bh=wCWvTwy7+lNxDWwzm1AyIA6v/IHLDstadwUxirEZ5fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/GkB627mg3mQCVZdGKdVykEToC+L/1bVuYfGwkd+YaonmtauH0SnbfZNeNWw5Fwb
         +bKcwrrKEGHxmYN3cs/G7UQExjml+f3puRTb/sfhEsDcKk/mmi5N6Lz2fjytgZL3or
         SotGM6KDvPJtzr1L1rsXIAbPdTrJ0lJgAZJ6zryA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 110/174] scsi: libfc: fix null pointer dereference on a null lport
Date:   Thu, 16 Jan 2020 12:41:47 -0500
Message-Id: <20200116174251.24326-110-sashal@kernel.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 41a6bf6529edd10a6def42e3b2c34a7474bcc2f5 ]

Currently if lport is null then the null lport pointer is dereference when
printing out debug via the FC_LPORT_DB macro. Fix this by using the more
generic FC_LIBFC_DBG debug macro instead that does not use lport.

Addresses-Coverity: ("Dereference after null check")
Fixes: 7414705ea4ae ("libfc: Add runtime debugging with debug_logging module parameter")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_exch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 30f9ef0c0d4f..b20c575564e4 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2499,7 +2499,7 @@ void fc_exch_recv(struct fc_lport *lport, struct fc_frame *fp)
 
 	/* lport lock ? */
 	if (!lport || lport->state == LPORT_ST_DISABLED) {
-		FC_LPORT_DBG(lport, "Receiving frames for an lport that "
+		FC_LIBFC_DBG("Receiving frames for an lport that "
 			     "has not been initialized correctly\n");
 		fc_frame_free(fp);
 		return;
-- 
2.20.1

