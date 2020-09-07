Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3D0C2BB84
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 17:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC3221532
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 17:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599498714;
	bh=fMnkgAblkIzmn4NV5qpGYdRfZFLnYfW+R/fXUqvNWzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MHVvARaXGDCTuzUK2bFPSCPF+WCibqt9GnZkfYqUcRHjz8YPXF5KEHSXgntTEnrdK
	 kT9PkPgUak5S+QA+Uf51mS5HyqgqTjIiwvtKMoVxQZPy80KP2fesWqTZDZfsvPdjxq
	 EMB2myM83P53aNNPkUIyJRIApC/DiPW5N7em0uYA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgIGQck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729851AbgIGQch (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Sep 2020 12:32:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC343217A0;
        Mon,  7 Sep 2020 16:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496353;
        bh=fMnkgAblkIzmn4NV5qpGYdRfZFLnYfW+R/fXUqvNWzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZ23v3jzYH6cvhN/VT6/Av0T7inaPKka/VAxsYYFxgU2DYtXukRR5/C7s29T96e6q
         0w/vMtHhdXVXWpCPEGizHdgtVl9tYJa+6qIM4fC6CJW/gWv0sB8CF7e26GHVqU2T3L
         Zqb0fj4pzzzazFKv6Z89vwYSB2dibLdHLfAlfXow=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Saurav Kashyap <skashyap@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 10/53] scsi: qedf: Fix null ptr reference in qedf_stag_change_work
Date:   Mon,  7 Sep 2020 12:31:36 -0400
Message-Id: <20200907163220.1280412-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit f308a35f547cd7c1d8a901c12b3ac508e96df665 ]

Link: https://lore.kernel.org/r/20200824033436.45570-1-yebin10@huawei.com
Acked-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 36b1ca2dadbb5..51cfab9d1afdc 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3843,7 +3843,7 @@ void qedf_stag_change_work(struct work_struct *work)
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
 	if (!qedf) {
-		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		QEDF_ERR(NULL, "qedf is NULL");
 		return;
 	}
 	QEDF_ERR(&qedf->dbg_ctx, "Performing software context reset.\n");
-- 
2.25.1

