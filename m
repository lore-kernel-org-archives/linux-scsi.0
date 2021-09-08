Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31531C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19E7261157
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352340AbhIHQsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:48:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40602 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352323AbhIHQsu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 12:48:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1889r43t000993;
        Wed, 8 Sep 2021 09:47:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=SbACuii8xwIJU9k4bvUr1T3FLCXqpswz+BXo6LiLUxY=;
 b=Pe1Ri2OPnWEYKCGdP4QHvSla3TXfvVHAMcOjxNp1NqW4qdu9bZo88r0SQDX+5Y3jMNpl
 xCz+AP6DvZCHSGia1fCRPUkwPwzLnunL4acWDAmn8D7ilmVFwCSXNoz2z3+kCSMncbA9
 EaKUC8hYbT/xaMfRSlRGh59asDe6cQRO1UOvSFCKWfOoW1zkmqVxblnc2AiL9Vlm3zxB
 qKbEe3xz6GRCORTxJl9ckyw6I37LLQmG+8RBX/VhuFIw/Tc3eDWvoo13/54+BANGGR5K
 wxL9N5v0ereiT0+oKU8g9KP9BkkWK5wr9L8I9D8FvQ9J2frFW/3589zGP6vWg2cHUiSl AQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3axtxc1kh3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 09:47:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Sep
 2021 09:47:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Sep 2021 09:47:38 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 57D663F709C;
        Wed,  8 Sep 2021 09:47:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 188Glcwo019303;
        Wed, 8 Sep 2021 09:47:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 188GlcfE019302;
        Wed, 8 Sep 2021 09:47:38 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <djeffery@redhat.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 05/10] qla2xxx: edif: Use link event to wake up app
Date:   Wed, 8 Sep 2021 09:46:17 -0700
Message-ID: <20210908164622.19240-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210908164622.19240-1-njavali@marvell.com>
References: <20210908164622.19240-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: hq4OSkfhz5XOhtzwXP-oVo085m49b2sd
X-Proofpoint-GUID: hq4OSkfhz5XOhtzwXP-oVo085m49b2sd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-08_06,2021-09-07_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Authentication application may be running and in the past
tried to probe driver (app_start) but unsuccessful. This
could be due to the bsg layer not ready to service the request.
On successful link up, driver will use the netlink Link Up
event to notify app to retry the app_start call.

In another case, app does not poll for new npiv host. This
link up event would notify app of the presence of a new SCSI Host.

Fixes: 4de067e5df12c ("scsi: qla2xxx: edif: Add N2N support for EDIF”)
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1e4e3e83b5c7..c6b3d0e7489e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5335,15 +5335,14 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 			    "LOOP READY.\n");
 			ha->flags.fw_init_done = 1;
 
+			/*
+			 * use link up to wake up app to get ready for
+			 * authentication.
+			 */
 			if (ha->flags.edif_enabled &&
-			    !(vha->e_dbell.db_flags & EDB_ACTIVE) &&
-			    N2N_TOPO(vha->hw)) {
-				/*
-				 * use port online to wake up app to get ready
-				 * for authentication
-				 */
-				qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE, 0);
-			}
+			    !(vha->e_dbell.db_flags & EDB_ACTIVE))
+				qla2x00_post_aen_work(vha, FCH_EVT_LINKUP,
+						      ha->link_data_rate);
 
 			/*
 			 * Process any ATIO queue entries that came in
-- 
2.19.0.rc0

