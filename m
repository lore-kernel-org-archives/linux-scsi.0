Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403CCC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351761AbhLXHHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:07:53 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47378 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351747AbhLXHHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:52 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2WGJv008452
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=1QpFASRb5a25jkc47TXQVg3xmPlCukP5TiUEbT/I0Ec=;
 b=eH2IPfz1pjHFd6WQvC0bRth0rqRtNnQI5kG8mHo1ZyipYa/QCTSvSulZhoauJEXRe18n
 ev5/NsjvZLYQ+FMH84UlmcYiLWyK9yqh8WmWIxkJllNYJlFDyKrlXW04+Bb9gJziCiMp
 Gp2p+lu+4aoB60DXsYS44GVir59sybj0JlzJ88Kt1V5TkRzDUP080jY0FEbsxKqQ0eg8
 bHCmjm1X+ruMWx/+PZi/YTHQ4/zUR7hvYW4HWf2vpJJ4dOTnFQSSovgY860OC31LcsaC
 bkq9grjAZIaQbDeMjpyX4f3nYJ6xdmdWjY+Xe374f/gCgSTe8ORp0LRevCgf3TerK1rQ Vw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d4t6kjua2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:51 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 23:07:50 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:48 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EF9A73F7077;
        Thu, 23 Dec 2021 23:07:48 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77mYi017960;
        Thu, 23 Dec 2021 23:07:48 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77mkB017959;
        Thu, 23 Dec 2021 23:07:48 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 03/16] qla2xxx: fix stuck session in gpdb
Date:   Thu, 23 Dec 2021 23:06:59 -0800
Message-ID: <20211224070712.17905-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211224070712.17905-1-njavali@marvell.com>
References: <20211224070712.17905-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: OhQ3BjZf3HhZQp_7NADIo9m7jejuFZlY
X-Proofpoint-ORIG-GUID: OhQ3BjZf3HhZQp_7NADIo9m7jejuFZlY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Fix stuck sessions in get port database. When a thread is in the process
of re-establishing a session, a flag is set to prevent multiple threads /
triggers from doing the same task. This flag was left on, where any attempt to
relogin was locked out. Clear this flag, if the attempt has failed.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 38c11b75f644..0b641a803f7c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1332,9 +1332,9 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT) ||
 	    fcport->loop_id == FC_NO_LOOP_ID) {
 		ql_log(ql_log_warn, vha, 0xffff,
-		    "%s: %8phC - not sending command.\n",
-		    __func__, fcport->port_name);
-		return rval;
+		    "%s: %8phC online %d flags %x - not sending command.\n",
+		    __func__, fcport->port_name, vha->flags.online, fcport->flags);
+		goto done;
 	}
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
-- 
2.23.1

