Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A08C43219
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 00:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 248BB60C40
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 00:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhIJAoN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 20:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234607AbhIJAXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FF2D60FDA;
        Fri, 10 Sep 2021 00:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233359;
        bh=PBpAdgHpvpy7vDTCB6pfGoZCaECYA5p3hIXlzYHsxTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkDeOpdjg3YB93qPqqJs58In8JIbvAmsXgazEVAfm1c0MfMHIwVSoTaJqB7WWTxTt
         ScgMKW7l6ykgj6qk4IpPs2F78B7KdFSA6a6Rv6H5LP7LUd0bdpnEDoi2kPkTMx6wbO
         m0CzxQBV3dbxGtahAckIr++iQYAMO6ALFyLmhm2k3xAzJCR/9i0bTGJsiSQVwUjdkm
         8pU/p1lvWfMbbYVPmdX3jEHv1bgrDX6jGU8+sQzIocWNrT/9uH1/RGRhdad1qV3uox
         7jktIpiIGWp70sPjiK84onufJpjbeQ5CqqFeQOfm+aN+r5hA8hfiqUdad2JhpWiLIl
         1TBqu7tdAzMlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/25] scsi: lpfc: Fix cq_id truncation in rq create
Date:   Thu,  9 Sep 2021 20:22:11 -0400
Message-Id: <20210910002234.176125-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002234.176125-1-sashal@kernel.org>
References: <20210910002234.176125-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit df3d78c3eb4eba13b3ef9740a8c664508ee644ae ]

On the newer hardware, CQ_ID values can be larger than seen on previous
generations. This exposed an issue in the driver where its definition of
cq_id in the RQ Create mailbox cmd was too small, thus the cq_id was
truncated, causing the command to fail.

Revise the RQ_CREATE CQ_ID field to its proper size (16 bits).

Link: https://lore.kernel.org/r/20210722221721.74388-3-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index a9bd12bfc15e..d5619aa290b9 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1493,7 +1493,7 @@ struct rq_context {
 #define lpfc_rq_context_hdr_size_WORD	word1
 	uint32_t word2;
 #define lpfc_rq_context_cq_id_SHIFT	16
-#define lpfc_rq_context_cq_id_MASK	0x000003FF
+#define lpfc_rq_context_cq_id_MASK	0x0000FFFF
 #define lpfc_rq_context_cq_id_WORD	word2
 #define lpfc_rq_context_buf_size_SHIFT	0
 #define lpfc_rq_context_buf_size_MASK	0x0000FFFF
-- 
2.30.2

