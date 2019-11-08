Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29427FA372C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00267215EA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214745;
	bh=ij0fpTMs+VIPq+Mtv/Rltj5I1qlhRyELJ2VMzh8RZxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XQBbdl5PfvOk9tiTii6ti2YNfp8FsJDViYmcVJ3ODRD1K7yw+sqgoFtxBVzqaLvei
	 b3WXgknjbQbp5wS85Fk3DER7t3uJZC/YdD5xfXZDLd3whuDvZZTx/rAWXBK9mGL64I
	 43kx7l3Fd0kTBChKpztrgC4t/BOcgdwz0vvbxKtA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732763AbfKHLlZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389416AbfKHLlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D4922245A;
        Fri,  8 Nov 2019 11:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213283;
        bh=ij0fpTMs+VIPq+Mtv/Rltj5I1qlhRyELJ2VMzh8RZxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gjku4gr6gd7QjHLvfcWCSLUZa+vwcVXii/7oZj2TBCggBD6S1LIRTj8ZNe4sdnnZD
         IedGMBUxsXVCaXyRj/om1GoUsx2rBF/xk7HeGgMrohx4izpJUyWOuAmi/929EqD68j
         D22tG//GnzhochFtcknHkwBgIRnQTKzcTLA9ArkU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 144/205] scsi: qla2xxx: Fix port speed display on chip reset
Date:   Fri,  8 Nov 2019 06:36:51 -0500
Message-Id: <20191108113752.12502-144-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit 5d74c87a20adcc77b19753c315ad9c320b2288be ]

Clear port speed value on chip reset.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8f502505aa796..653d535e3052f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6502,6 +6502,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	if (!(IS_P3P_TYPE(ha)))
 		ha->isp_ops->reset_chip(vha);
 
+	ha->link_data_rate = PORT_SPEED_UNKNOWN;
 	SAVE_TOPO(ha);
 	ha->flags.rida_fmt2 = 0;
 	ha->flags.n2n_ae = 0;
-- 
2.20.1

