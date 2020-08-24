Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C8DC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 16:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87D1422D0B
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 16:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598287122;
	bh=mC8QRiua3TxU8EWz/9lpCvr+KGukWMfPbUNQDuVcy7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vOFGoHABO+cD6CscYaONxS2uyVHtf+l4pRu//aM7FxDOIZsMQCKXnzRd3u7dot+X4
	 fRH6KCSv81zFyWvMNNSnAQfyE5vDY34x39cOypaFoxdabDIerDVPhgnKlsvH/9V1Ux
	 Cri1bKEEkHeM6G/eGcAJ9+LGVZ5qZgNkrfDS+OG0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgHXQih (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 12:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbgHXQiI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68BDF22CBB;
        Mon, 24 Aug 2020 16:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287047;
        bh=mC8QRiua3TxU8EWz/9lpCvr+KGukWMfPbUNQDuVcy7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E96om0bAtWCDxD/cVcEBTGg4f82D8pvEzlx1BH4E1v3V9DFEUeNiW2h5tmvwGgkMX
         aHXN+a6KT0m/LrsXzF8S8RxmViRB9h6ibqEoprt7Fe3CQx+BtaWODUV8IofeieqnAR
         uHoEZBCCYUP/I6gfRtfOXZBxhSLL4jHtTScSRNXk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 38/54] scsi: qla2xxx: Flush I/O on zone disable
Date:   Mon, 24 Aug 2020 12:36:17 -0400
Message-Id: <20200824163634.606093-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit a117579d0205b5a0592a3a98493e2b875e4da236 ]

Perform implicit logout to flush I/O on zone disable.

Link: https://lore.kernel.org/r/20200806111014.28434-3-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index c6b6a3250312e..7074073446701 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3436,7 +3436,6 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 			list_for_each_entry(fcport, &vha->vp_fcports, list) {
 				if ((fcport->flags & FCF_FABRIC_DEVICE) != 0) {
 					fcport->scan_state = QLA_FCPORT_SCAN;
-					fcport->logout_on_delete = 0;
 				}
 			}
 			goto login_logout;
-- 
2.25.1

