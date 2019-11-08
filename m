Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C745AFC6194
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F54A21848
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214774;
	bh=BsYITncQjbDdzgjbZ7L3lXwyTDl12qrWP9tYAragwzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=L6E4Ayh1tZVGWT6wuc6Q2NBqv73DuJ2uqE+qnHLounp8vBnhHTl4qJBNtgDpwjaCN
	 k6CXIaj1tHgFhycIKHWTclpZcPH7vq7ACXoSi2Ck1kPeSMkOyfJL6HZYDEwv60Fi7K
	 sUxQmNVxWSKvF2oFt2hx18HlC9zsx4VUdJVPzry0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389327AbfKHLlT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732718AbfKHLlS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69EC322473;
        Fri,  8 Nov 2019 11:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213278;
        bh=BsYITncQjbDdzgjbZ7L3lXwyTDl12qrWP9tYAragwzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFYAvhRgntCDCwJ64gEI4rtGeINnZbIHXjxvsajh3EhbECgT1y2dzUh4jMXpQ4gEn
         XgqmJUBnoLB4RAHLqxmowh6yUSnIrz45U55fMKGgod8FgEVkvesrt8BlSpepPKBtuE
         Fx2ZrqawqduLbcUPLhLLdZRbvsduoyII+qPt/NaQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 139/205] scsi: qla2xxx: Defer chip reset until target mode is enabled
Date:   Fri,  8 Nov 2019 06:36:46 -0500
Message-Id: <20191108113752.12502-139-sashal@kernel.org>
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

[ Upstream commit 93eca6135183f7a71e36acd47655a085ed11bcdc ]

For target mode, any chip reset triggered before target mode is enabled will
be held off until user is ready to enable.  This prevents the chip from
starting or running before it is intended.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 60b6019a2fcae..bfbdec61b3c6e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6051,12 +6051,27 @@ qla2x00_do_dpc(void *data)
 		if (test_and_clear_bit
 		    (ISP_ABORT_NEEDED, &base_vha->dpc_flags) &&
 		    !test_bit(UNLOADING, &base_vha->dpc_flags)) {
+			bool do_reset = true;
+
+			switch (ql2x_ini_mode) {
+			case QLA2XXX_INI_MODE_ENABLED:
+				break;
+			case QLA2XXX_INI_MODE_DISABLED:
+				if (!qla_tgt_mode_enabled(base_vha))
+					do_reset = false;
+				break;
+			case QLA2XXX_INI_MODE_DUAL:
+				if (!qla_dual_mode_enabled(base_vha))
+					do_reset = false;
+				break;
+			default:
+				break;
+			}
 
-			ql_dbg(ql_dbg_dpc, base_vha, 0x4007,
-			    "ISP abort scheduled.\n");
-			if (!(test_and_set_bit(ABORT_ISP_ACTIVE,
+			if (do_reset && !(test_and_set_bit(ABORT_ISP_ACTIVE,
 			    &base_vha->dpc_flags))) {
-
+				ql_dbg(ql_dbg_dpc, base_vha, 0x4007,
+				    "ISP abort scheduled.\n");
 				if (ha->isp_ops->abort_isp(base_vha)) {
 					/* failed. retry later */
 					set_bit(ISP_ABORT_NEEDED,
@@ -6064,10 +6079,9 @@ qla2x00_do_dpc(void *data)
 				}
 				clear_bit(ABORT_ISP_ACTIVE,
 						&base_vha->dpc_flags);
+				ql_dbg(ql_dbg_dpc, base_vha, 0x4008,
+				    "ISP abort end.\n");
 			}
-
-			ql_dbg(ql_dbg_dpc, base_vha, 0x4008,
-			    "ISP abort end.\n");
 		}
 
 		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED,
-- 
2.20.1

