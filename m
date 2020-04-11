Return-Path: <SRS0=XSNP=53=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3FEAC2BBFD
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5A12206E9
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648582;
	bh=ORdiuhU2dCCpWV3CRgYE5CPAYMKh4bXPE412c+Clh64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ijD7l9wWMfK70CVpDN8kGhIdtxeyD1LJ2dQR8mBDEh/vIxxcJQqI5qlGFYJWVLVbg
	 87kRsX2VIcFrEDWHaQFYZR2cSFYzLmvTfK85io6eBVM1lSJkMgnCR/kGoEmf9adCCg
	 m+2g2ojgULNBiwssV1wU2UW+IaLES60ISlBwcNEs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgDKXG3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbgDKXG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4135218AC;
        Sat, 11 Apr 2020 23:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646388;
        bh=ORdiuhU2dCCpWV3CRgYE5CPAYMKh4bXPE412c+Clh64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZ7PgdRb36P/EBh4VWP3cIhQboxhu1BIxZzeb7VoT4AvuSe8WupaWZRu0YHwRIY6Y
         NpAQsWRRw45DZNVj8P3JqRHXp9bDn5pDL5cHiEi2ouiom9QPKeJyZpNL9CAh6rB8QR
         1pQTl+oS3LcSxSfnucb75tVHmdIonEkFe7GQiBHk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Carnuccio <joe.carnuccio@cavium.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 128/149] scsi: qla2xxx: Fix qla2x00_echo_test() based on ISP type
Date:   Sat, 11 Apr 2020 19:03:25 -0400
Message-Id: <20200411230347.22371-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

[ Upstream commit 83cfd3dc002fc730387a1ec5fa0d4097cc31ee9f ]

Ths patch fixes MBX in-direction for setting right bits for
qla2x00_echo_test()

Link: https://lore.kernel.org/r/20200212214436.25532-19-hmadhani@marvell.com
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f0846ce0c4da4..0e8426e1e1149 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5173,10 +5173,11 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 		mcp->out_mb |= MBX_2;
 
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
-	    IS_CNA_CAPABLE(ha) || IS_QLA2031(ha))
+	if (IS_CNA_CAPABLE(ha) || IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
+	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
 		mcp->in_mb |= MBX_1;
-	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha))
+	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
+	    IS_QLA28XX(ha))
 		mcp->in_mb |= MBX_3;
 
 	mcp->tov = MBX_TOV_SECONDS;
-- 
2.20.1

