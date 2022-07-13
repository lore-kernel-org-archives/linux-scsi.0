Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC8BC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 05:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiGMFVI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 01:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiGMFU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 01:20:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DD9D4BFE
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D2Lj1U025309
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=2WwdXD4hqZgfU9W/jW1IHzBdt+9Nmj4bPD/Vsm1zG6k=;
 b=KUQG+RjhUGcfYk7VvUSdkwHnZWzYd5uYKah+n1miygMfcZS6nbXvzMl1nYdc4KEVL7ye
 KT1kAYZHW2TmlcVldgi67T7fyzyKWm/8OHP1rmmtfdAg4vid3R/xEY3u/QMTYJgI+UsT
 HWy20L7y662YLRDw2VePJXUy/fznJ+QmJdGYnZVT8tfU6OXREk2FrUGqM2YdTq/PdUqC
 HS+wl4C5I0v+BTgWJ1zs0G2njHGGE1rPjFgsoKW8TaSChUA1G1xtniZVxMxRuz33NfIz
 vaGTyuwU9FWP6PZN9+Thm8dOT8leSd+jt8XDQhfgKyOju23ySgVA1CUUzopXc2zIFKf7 Jw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9n6n0f0h-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jul
 2022 22:20:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jul 2022 22:20:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C06AD3F70AA;
        Tue, 12 Jul 2022 22:20:54 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 03/10] qla2xxx: zero undefined mailbox IN registers
Date:   Tue, 12 Jul 2022 22:20:38 -0700
Message-ID: <20220713052045.10683-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
References: <20220713052045.10683-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: joNHxCgWu8k21fBdgsbHNWOzwJ733FQg
X-Proofpoint-GUID: joNHxCgWu8k21fBdgsbHNWOzwJ733FQg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-12_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

While requesting a new mailbox command, driver does not
write any data to unused registers.
Initialize the unused register value to zero while requesting
a new mailbox command to prevent stale entry access by firmware.

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 643fa0052f5a..9a3f832c49ef 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -238,6 +238,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			ql_dbg(ql_dbg_mbx, vha, 0x1112,
 			    "mbox[%d]<-0x%04x\n", cnt, *iptr);
 			wrt_reg_word(optr, *iptr);
+		} else {
+			wrt_reg_word(optr, 0);
 		}
 
 		mboxes >>= 1;
-- 
2.19.0.rc0

