Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D5CEC38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 14:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224342073A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 14:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588862050;
	bh=7MP8dOvGoboeGuCIoqthEgIp6BxobZuNk6QpcuAufpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FScDfnhNApNGfgP0+73UXKFpzDQ54uVn/pLVKkqlNFV9/tmStpoEfX8L03Sj7Bjee
	 MoZuotMUoTzN/pOAjwmMRwbl9ysI/tfftiEhunWyW6t73PUravDeIT3Sne9MhDeNNr
	 pHxuddeVku+iJLtTBEoDgy7zUH1BewrW3ggWPZlI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgEGOeE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 10:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgEGO3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 10:29:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75AFA20936;
        Thu,  7 May 2020 14:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861764;
        bh=7MP8dOvGoboeGuCIoqthEgIp6BxobZuNk6QpcuAufpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxfIYwoRpt25BT2XWH3BnFCeVgD3MHPxOMom0WR6NUXvMUDaOlM/BXuJbA+6SZf75
         ZX7T+QiQeNgn7FHFsMmiuP4EGmbCRHXz1l+drjXzJhighiqhUpO7k9FslZCeyOgx4r
         B+uQlX8YF+cy+ks7s/VCHtn0LRwySl2aws3TIfg0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/20] scsi: qla2xxx: check UNLOADING before posting async work
Date:   Thu,  7 May 2020 10:29:01 -0400
Message-Id: <20200507142917.26612-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142917.26612-1-sashal@kernel.org>
References: <20200507142917.26612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 5a263892d7d0b4fe351363f8d1a14c6a75955475 ]

qlt_free_session_done() tries to post async PRLO / LOGO, and waits for the
completion of these async commands. If UNLOADING is set, this is doomed to
timeout, because the async logout command will never complete.

The only way to avoid waiting pointlessly is to fail posting these commands
in the first place if the driver is in UNLOADING state.  In general,
posting any command should be avoided when the driver is UNLOADING.

With this patch, "rmmod qla2xxx" completes without noticeable delay.

Link: https://lore.kernel.org/r/20200421204621.19228-3-mwilck@suse.com
Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
Acked-by: Arun Easi <aeasi@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fff20a3707677..d08635203c8a4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4647,6 +4647,9 @@ qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
 	struct qla_work_evt *e;
 	uint8_t bail;
 
+	if (test_bit(UNLOADING, &vha->dpc_flags))
+		return NULL;
+
 	QLA_VHA_MARK_BUSY(vha, bail);
 	if (bail)
 		return NULL;
-- 
2.20.1

