Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B86C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 07:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00DC96187E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 07:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhELH1H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 03:27:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26366 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229996AbhELH1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 May 2021 03:27:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14C7KNHg000805
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 00:25:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=JzZ8iaTIMFV2NmcNAvsMqWM/GS0tuuJ7xI/mLgsEAEI=;
 b=WEo4hGaprJlI9/MAfSv61p5rxfqGJ11kJkz9aN/Yv6g5NzlrxZcrsIgonYBVh2AhG0wx
 YaeYmkG4oSHjw3XHaGDEcWjMvmAddgUWqh/kj/JYSLsCvMrMu8lhJzsCu/a04ERyQZ0r
 zAvIYERBl9cDkofGpbLt51yxcp3GQNcxoX2wWA9W1cq8HvPEjr2R++h3s3NZBx03vJZh
 eJ6LtFhuA6ofId6KJEQQj3gkOheu1EL8MPtzkdkSd7fQhxHTZyqIoPxzDY7Hum9hEtls
 le2vxBBtqWbVl6HEHJkF253Vbz0durAJkWKtj9EFLB/KsMvOwia6ZBbJZt4rtdPvfY48 dg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38fw8yat07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 00:25:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 00:25:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 00:25:57 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E6CC83F7043;
        Wed, 12 May 2021 00:25:57 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 14C7PvWX023653;
        Wed, 12 May 2021 00:25:57 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 14C7PvwJ023652;
        Wed, 12 May 2021 00:25:57 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH] qedf: Added NULL pointer checks in qedf_update_link_speed().
Date:   Wed, 12 May 2021 00:25:33 -0700
Message-ID: <20210512072533.23618-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: cfglEMDxxqfYh9bljsTS32gh1X529WUH
X-Proofpoint-ORIG-GUID: cfglEMDxxqfYh9bljsTS32gh1X529WUH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_03:2021-05-11,2021-05-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 Issue :- BUG: unable to handle kernel NULL pointer dereference at 000000000000003c
 On installation of RHEL-8.3.0-20200820.n.0 distro below stack
 was generating on error.

 [   14.042059] Call Trace:
 [   14.042061]  <IRQ>
 [   14.042068]  qedf_link_update+0x144/0x1f0 [qedf]
 [   14.042117]  qed_link_update+0x5c/0x80 [qed]
 [   14.042135]  qed_mcp_handle_link_change+0x2d2/0x410 [qed]
 [   14.042155]  ? qed_set_ptt+0x70/0x80 [qed]
 [   14.042170]  ? qed_set_ptt+0x70/0x80 [qed]
 [   14.042186]  ? qed_rd+0x13/0x40 [qed]
 [   14.042205]  qed_mcp_handle_events+0x437/0x690 [qed]
 [   14.042221]  ? qed_set_ptt+0x70/0x80 [qed]
 [   14.042239]  qed_int_sp_dpc+0x3a6/0x3e0 [qed]
 [   14.042245]  tasklet_action_common.isra.14+0x5a/0x100
 [   14.042250]  __do_softirq+0xe4/0x2f8
 [   14.042253]  irq_exit+0xf7/0x100
 [   14.042255]  do_IRQ+0x7f/0xd0
 [   14.042257]  common_interrupt+0xf/0xf
 [   14.042259]  </IRQ>

 Root cause :- API qedf_link_update() is getting called from QED.
  but by that time shost_data is not initialised. That is leading NULL pointer dereference
  when we try to derefference shost_data while updating supported_speeds.

  fc_host_supported_speeds(lport->host) = lport->link_supported_speeds;

 Expansion of fc_host_supported_speeds.
 #define fc_host_supported_speeds(x)	\
  (((struct fc_host_attrs *)(x)->shost_data)->supported_speeds)

 Fix :- Added NULL pointer check for shost_data.

Signed-off-by: Javed Hasan <jhasan@marvell.com>

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 69f7784233f9..756231151882 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -536,7 +536,9 @@ static void qedf_update_link_speed(struct qedf_ctx *qedf,
 	if (linkmode_intersects(link->supported_caps, sup_caps))
 		lport->link_supported_speeds |= FC_PORTSPEED_20GBIT;
 
-	fc_host_supported_speeds(lport->host) = lport->link_supported_speeds;
+	if (lport->host && lport->host->shost_data)
+		fc_host_supported_speeds(lport->host) =
+			lport->link_supported_speeds;
 }
 
 static void qedf_bw_update(void *dev)
-- 
2.18.2

