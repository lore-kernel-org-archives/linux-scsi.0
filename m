Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E04C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE9220776
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:10:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="D+ac2d0N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgDXMKg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:10:36 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:53510 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbgDXMKg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 08:10:36 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id ACEA94C080;
        Fri, 24 Apr 2020 12:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:mime-version:x-mailer:content-type
        :content-type:date:date:from:from:subject:subject:message-id
        :received:received:received; s=mta-01; t=1587730232; x=
        1589544633; bh=tY3lVVSBFxmdtqN2XPsxXKhjGPbInM015sC5HoSW1II=; b=D
        +ac2d0NXEfaE1EWGGOQEwIMu4ogfBPArKuC7FVmiF+AbKN6Kjn3Z4hdrKnVA3NnP
        PkSaOkZhXXlK5bdnN2kSK3PWXcnqL55vdkE46s27wsI7z3rwUhjHTZROXFcbuqVz
        Rx5+C60bbvmMTmE/Y7ZcRc87GxlNVzthpnG+rNuWXQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IPH8LbhzOBME; Fri, 24 Apr 2020 15:10:32 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7C9034C082;
        Fri, 24 Apr 2020 15:10:32 +0300 (MSK)
Received: from vdubeyko-laptop (10.199.0.202) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 24
 Apr 2020 15:10:33 +0300
Message-ID: <3cd0bbf3599c53b0c2a7184582d705d8b8052c8b.camel@yadro.com>
Subject: [PATCH 2/3] scsi: qla2xxx: Fix failure message in qlt_disable_vha()
From:   Viacheslav Dubeyko <v.dubeiko@yadro.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <hmadhani@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux@yadro.com>,
        <r.bolshakov@yadro.com>, <slava@dubeyko.com>
Date:   Fri, 24 Apr 2020 15:10:32 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.199.0.202]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Date: Wed, 22 Apr 2020 13:51:51 +0300
Subject: [PATCH 2/3] scsi: qla2xxx: Fix failure message in qlt_disable_vha()

The sequence of commands is able to reveal the incorrect
failure message:

echo 0x7fffffff > /sys/module/qla2xxx/parameters/logging
modprobe target_core_mod
modprobe tcm_qla2xxx
mkdir /sys/kernel/config/target/qla2xxx
mkdir /sys/kernel/config/target/qla2xxx/<port-name>
mkdir /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1
echo 1 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable
echo 0 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable

qla2xxx [0001:00:02.0]-e881:1: qla2x00_wait_for_hba_online() failed

The reason of this message is the QLA_FUNCTION_FAILED code
that qla2x00_wait_for_hba_online() returns. However,
qlt_disable_vha() expects that adapter is offlined and
QLA_FUNCTION_FAILED informs namely about the offline
state of the adapter.

The qla2x00_abort_isp() function finishes the execution
at the point of checking the adapter's mode (for example,
qla_tgt_mode_enabled()) because of the qlt_disable_vha()
calls qlt_clear_mode() method. It means that qla2x00_abort_isp()
keeps vha->flags.online is equal to zero. Finally,
qla2x00_wait_for_hba_online() checks the state of this flag
and returns QLA_FUNCTION_FAILED error code.

This patch change the failure message on the message
that informs about adapter's offline state.

Signed-off-by: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 622e7337affc..f3255aa70dcc 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6661,9 +6661,14 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 
 	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	qla2xxx_wake_dpc(vha);
+
+	/*
+	 * We are expecting the offline state.
+	 * QLA_FUNCTION_FAILED means that adapter is offline.
+	 */
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
 		ql_dbg(ql_dbg_tgt, vha, 0xe081,
-		       "qla2x00_wait_for_hba_online() failed\n");
+		       "adapter is offline\n");
 }
 
 /*
-- 
2.17.1


