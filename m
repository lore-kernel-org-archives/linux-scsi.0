Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D9BC43465
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E35623119
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600397969;
	bh=4HjaApKhhtTar4fxqvXTEJ36CBbwBcNfAnhgHrUQsuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=L89yTQf/oL9yzTx2EeOlidu52+h7copwirY7mmldTPUgeAOB6BZP0j/HLJ/O7/oZG
	 BO8hDLlJUlnz0RX99SNyTcqxbx4KWksVHQAYwYd4HCqYqx6YHhHkHYC+nA6Eih4JRq
	 WCCnlZJRrT/QBA5d4lUa9eqN8rSx5dinbsBCS/ew=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgIRCF7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbgIRCF6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 845552376F;
        Fri, 18 Sep 2020 02:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394758;
        bh=4HjaApKhhtTar4fxqvXTEJ36CBbwBcNfAnhgHrUQsuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2Xku6JNNaH3PS7Sg5D15p88NHJPfUzU8+rbJlEQpaq8VIWztA1Mdvs6qalnJp8iR
         STdGzOdUJt/ORGVW7Z2g2/fPP6bbHu5YuMxxZKxM9tD7DbEZetJP4ruCTblDKOpmQq
         6iVGKd33jg65iUA83qjd7RiymAXYZB8CuAOkoQZQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>, Lee Duncan <lduncan@suse.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 235/330] scsi: qedi: Fix termination timeouts in session logout
Date:   Thu, 17 Sep 2020 21:59:35 -0400
Message-Id: <20200918020110.2063155-235-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit b9b97e6903032ec56e6dcbe137a9819b74a17fea ]

The destroy connection ramrod timed out during session logout.  Fix the
wait delay for graceful vs abortive termination as per the FW requirements.

Link: https://lore.kernel.org/r/20200408064332.19377-7-mrangankar@marvell.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_iscsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 0f57c80734061..0f2622a48311c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1062,6 +1062,9 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 		break;
 	}
 
+	if (!abrt_conn)
+		wait_delay += qedi->pf_params.iscsi_pf_params.two_msl_timer;
+
 	qedi_ep->state = EP_STATE_DISCONN_START;
 	ret = qedi_ops->destroy_conn(qedi->cdev, qedi_ep->handle, abrt_conn);
 	if (ret) {
-- 
2.25.1

