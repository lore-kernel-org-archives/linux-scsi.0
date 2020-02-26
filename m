Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAC3C4BA24
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B38E524672
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="b2g+5FhI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgBZWnJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:43:09 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61704 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgBZWnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:43:09 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMeZXO006185;
        Wed, 26 Feb 2020 14:41:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ZBa2o7VanPiSYTjpBO9TVHMViJwrxEEosZykuMsVV8A=;
 b=b2g+5FhIRuE7UfFwA87nPGbJ34Zt09sFjtrZaSKNsZslmIr+mhvWcB30XoERg9q6OzdN
 fZedHWhu4YZmZR+utiWp8HnutDib41xc6wnpNzxtiLcnuf7BNt26tfzZwkQns5rigmTT
 7HjmzWnYUxm1YRfKvbLMWIM0a/3iAiei+iRGlrQNZUlBjFjXCdbFgHoSV+sE4T6io8o1
 08ZWIv+AcgdIsqU9hhvn/OjcKNSR39SR8ka378blVVBQibYpklNPApHID0OAMm/h5x8C
 e5uywmNf6cc30djE6W91MTHK2stXpaRNwDONSK207R/Sn9GNddF5XQ2Ml6uT1SyqhA3f VQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtd6nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:41:07 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:41:05 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:41:05 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:41:04 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 233173F703F;
        Wed, 26 Feb 2020 14:41:05 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMf4Db024617;
        Wed, 26 Feb 2020 14:41:05 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMf4nq024616;
        Wed, 26 Feb 2020 14:41:04 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 14/18] qla2xxx: Serialize fc_port alloc in N2N
Date:   Wed, 26 Feb 2020 14:40:18 -0800
Message-ID: <20200226224022.24518-15-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200226224022.24518-1-hmadhani@marvell.com>
References: <20200226224022.24518-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For N2N, fc_port struct is created during report id acquistion.
At later time, the loop resync (fabric, n2n, loop) would trigger
the rest of the login using the created fc_port struct.  The loop
resync logic can trigger another fc_port allocation if the 1st
allocation was not able to execute.  This patch prevents the 2nd
allocation trigger.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 +
 drivers/scsi/qla2xxx/qla_os.c   | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 453b47006a59..3815f5321b3b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5148,6 +5148,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		}
+		return QLA_FUNCTION_FAILED;
 	}
 
 	found_devs = 0;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ede4529c4718..80c5c7b16150 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5202,9 +5202,8 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 					fcport->n2n_flag = 1;
 				}
 				fcport->fw_login_state = 0;
-				/*
-				 * wait link init done before sending login
-				 */
+
+				schedule_delayed_work(&vha->scan.scan_work, 5);
 			} else {
 				qla24xx_fcport_handle_login(vha, fcport);
 			}
-- 
2.12.0

