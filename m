Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D52FC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 10:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1492820717
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 10:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SA9WKide"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgC0K1p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 06:27:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54972 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgC0K1p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 06:27:45 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RAQh55008679;
        Fri, 27 Mar 2020 03:27:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=0e5dnP2BSTJy/jbpWlCfdqjhTEjJqddzZdD3Awisgq8=;
 b=SA9WKide1rzIGUyiPXt5jmk7DT5eTLBfu3iJlmuGXn7I7j4wO4pUBR6WyqDtm1jKj3gM
 sFsHdb3r0ylsJjlAIJo5V4d8eJJt60rrPuaYF1XTx+UhEcgwsHmtZ8djGFjju+Khy6vV
 VoH/qiAvkwfCimlshzuVRVaIK54QvJBkXZ/sqVYPiP0/cAd1DQlK81vsQs1F8d6x0kT2
 HFsy5DZVXaqtWdEg51TltR0l7xWf1+3GYWShzRSAalJWs5h6IwHhScEXwRcmKbezlDJ9
 ttLTBw0LLmTo+K21ve7TrOBfW6FOjYVjHZb6oroehIarcdLlEsfBYEHCj97+WAOTiuC8 RQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9p2b0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Mar 2020 03:27:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 27 Mar
 2020 03:27:41 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 27 Mar
 2020 03:27:40 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 27 Mar 2020 03:27:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7FF1E3F7043;
        Fri, 27 Mar 2020 03:27:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02RAReNG022398;
        Fri, 27 Mar 2020 03:27:40 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02RAReLT022397;
        Fri, 27 Mar 2020 03:27:40 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>, <emilne@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 3/3] qla2xxx: delete all sessions before unregister local nvme port
Date:   Fri, 27 Mar 2020 03:27:30 -0700
Message-ID: <20200327102730.22351-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200327102730.22351-1-njavali@marvell.com>
References: <20200327102730.22351-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_03:2020-03-27,2020-03-27 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Delete all sessions before unregistering local nvme port.  This
allows nvme layer to decrement all active rport count down to zero.
Once the count is down to zero, nvme would call qla to continue with
the npiv port deletion.

PID: 27448  TASK: ffff9e34b777c1c0  CPU: 0   COMMAND: "qaucli"
 0 [ffff9e25e84abbd8] __schedule at ffffffff977858ca
 1 [ffff9e25e84abc68] schedule at ffffffff97785d79
 2 [ffff9e25e84abc78] schedule_timeout at ffffffff97783881
 3 [ffff9e25e84abd28] wait_for_completion at ffffffff9778612d
 4 [ffff9e25e84abd88] qla_nvme_delete at ffffffffc0e3024e [qla2xxx]
 5 [ffff9e25e84abda8] qla24xx_vport_delete at ffffffffc0e024b9 [qla2xxx]
 6 [ffff9e25e84abdf0] fc_vport_terminate at ffffffffc011c247 [scsi_transport_fc]
 7 [ffff9e25e84abe28] store_fc_host_vport_delete at ffffffffc011cd94 [scsi_transport_fc]
 8 [ffff9e25e84abe70] dev_attr_store at ffffffff974b376b
 9 [ffff9e25e84abe80] sysfs_kf_write at ffffffff972d9a92
10 [ffff9e25e84abe90] kernfs_fop_write at ffffffff972d907b
11 [ffff9e25e84abec8] vfs_write at ffffffff9724c790
12 [ffff9e25e84abf08] sys_write at ffffffff9724d55f
13 [ffff9e25e84abf50] system_call_fastpath at ffffffff97792ed2
    RIP: 00007fc0bd81a6fd  RSP: 00007ffff78d9648  RFLAGS: 00010202
    RAX: 0000000000000001  RBX: 0000000000000022  RCX: 00007ffff78d96e0
    RDX: 0000000000000022  RSI: 00007ffff78d94e0  RDI: 0000000000000008
    RBP: 00007ffff78d9440   R8: 0000000000000000   R9: 00007fc0bd48b2cd
    R10: 0000000000000017  R11: 0000000000000293  R12: 0000000000000000
    R13: 00005624e4dac840  R14: 00005624e4da9a10  R15: 0000000000000000
    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3a5f6f27587e..4cfebf34ad7c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3055,11 +3055,11 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
 		msleep(1000);
 
-	qla_nvme_delete(vha);
 
 	qla24xx_disable_vp(vha);
 	qla2x00_wait_for_sess_deletion(vha);
 
+	qla_nvme_delete(vha);
 	vha->flags.delete_progress = 1;
 
 	qlt_remove_target(ha, vha);
-- 
2.19.0.rc0

