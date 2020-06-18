Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CE6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B72EA20885
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592445973;
	bh=x6Jt4u/AbNqqCP3lAECzhXP1uii5dlx4/WV6Cw+sor0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mUNmmBamLmHzBLeIh0Lkns+KIFPoLflOWTPP104AJrFkgeXuQrsf4JT22cg6nycnG
	 LNYeaUmcfNxsFDRiv4zqmfmPZjIJYP6/E/IR8zKIfKIy2O8L/0RSaCFCkyM8oLYn6H
	 8Xei/hLiBIHCSuGi7ndem5j86MpOErsRvSWw3isc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgFRBWg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730775AbgFRBWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88F7F20776;
        Thu, 18 Jun 2020 01:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443355;
        bh=x6Jt4u/AbNqqCP3lAECzhXP1uii5dlx4/WV6Cw+sor0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nxhdy7FJuYZl64B+l/YwWojeOcjlEtBugJNT3AOU9m7Or+Ux5/hslHm/M/PsL9ZD
         vpdp+YApJEzQHfMl0Rpb/+GBW+YnNEoHAtDj+qInYTP3HPfIXFe6CX4v99Bl4jijsO
         nfrdYAOrDgrAahG3Ko7F7Kccz9zoDGovuaX9Q0YE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 013/172] scsi: qedi: Check for buffer overflow in qedi_set_path()
Date:   Wed, 17 Jun 2020 21:19:39 -0400
Message-Id: <20200618012218.607130-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4a4c0cfb4be74e216dd4446b254594707455bfc6 ]

Smatch complains that the "path_data->handle" variable is user controlled.
It comes from iscsi_set_path() so that seems possible.  It's harmless to
add a limit check.

The qedi->ep_tbl[] array has qedi->max_active_conns elements (which is
always ISCSI_MAX_SESS_PER_HBA (4096) elements).  The array is allocated in
the qedi_cm_alloc_mem() function.

Link: https://lore.kernel.org/r/20200428131939.GA696531@mwanda
Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_iscsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 1b7049dce169..d59473d1679f 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1217,6 +1217,10 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 	}
 
 	iscsi_cid = (u32)path_data->handle;
+	if (iscsi_cid >= qedi->max_active_conns) {
+		ret = -EINVAL;
+		goto set_path_exit;
+	}
 	qedi_ep = qedi->ep_tbl[iscsi_cid];
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 		  "iscsi_cid=0x%x, qedi_ep=%p\n", iscsi_cid, qedi_ep);
-- 
2.25.1

