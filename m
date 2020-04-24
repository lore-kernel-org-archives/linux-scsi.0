Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDE6C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B245C20728
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="msmy3i7a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgDXMKq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:10:46 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:53536 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbgDXMKq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 08:10:46 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 269A44C086;
        Fri, 24 Apr 2020 12:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:mime-version:x-mailer:content-type
        :content-type:date:date:from:from:subject:subject:message-id
        :received:received:received; s=mta-01; t=1587730241; x=
        1589544642; bh=zFEVcUFTVQXs9NaHYiz2xMC0LWwGGQebVI6oUVykH2Q=; b=m
        smy3i7asXTDHgQhOvhcWFEy3Ch6Drdt51/WJ7XY23auaB3j/V3lwCvoQKGbxw8Tv
        ujVUULbeeT84QSccMwnKKlQ3EBGMN5NbkCo++GvGLYBcd2P8zg3LrPIFuWQ1knD2
        PIQfiQKI70/uuo0e5q5ZUtlg5wTOgmrn66bXG4faR8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id syF8hTol9B8y; Fri, 24 Apr 2020 15:10:41 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C6F574C082;
        Fri, 24 Apr 2020 15:10:41 +0300 (MSK)
Received: from vdubeyko-laptop (10.199.0.202) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 24
 Apr 2020 15:10:42 +0300
Message-ID: <52be1e8a3537f6c5407eae3edd4c8e08a9545ea5.camel@yadro.com>
Subject: [PATCH 3/3] scsi: qla2xxx: Fix issue with fake adapter's stopping
 state
From:   Viacheslav Dubeyko <v.dubeiko@yadro.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <hmadhani@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux@yadro.com>,
        <r.bolshakov@yadro.com>, <slava@dubeyko.com>
Date:   Fri, 24 Apr 2020 15:10:41 +0300
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
Date: Wed, 22 Apr 2020 13:55:52 +0300
Subject: [PATCH 3/3] scsi: qla2xxx: Fix issue with fake adapter's stopping state

The sequence of command reveals the fake adapter's
stopping state:

echo 0x7fffffff > /sys/module/qla2xxx/parameters/logging
modprobe target_core_mod
modprobe tcm_qla2xxx
mkdir /sys/kernel/config/target/qla2xxx
mkdir /sys/kernel/config/target/qla2xxx/<port-name>
mkdir /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1
echo 1 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable
echo 0 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable
echo 1 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable

The goal of this commands sequence is to restart
the adapter. However, it is possible to see that
flag tgt_stop remains indicating that the adapter
is still stopping even after the enabling it.

kernel: PID 1396:qla_target.c:1555 qlt_stop_phase1(): tgt_stop 0x0, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-e803:1: PID 1396:qla_target.c:1567: Stopping target for host 1(c0000000033557e8)
kernel: PID 1396:qla_target.c:1579 qlt_stop_phase1(): tgt_stop 0x1, tgt_stopped 0x0
kernel: PID 1396:qla_target.c:1266 qlt_schedule_sess_for_deletion(): tgt_stop 0x1, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-e801:1: PID 1396:qla_target.c:1316: Scheduling sess c00000002d5cd800 for deletion 21:00:00:24:ff:7f:35:c7
<skipped>
kernel: qla2xxx [0001:00:02.0]-290a:1: PID 340:qla_target.c:1187: qlt_unreg_sess sess c00000002d5cd800 for deletion 21:00:00:24:ff:7f:35:c7
<skipped>
kernel: qla2xxx [0001:00:02.0]-f801:1: PID 340:qla_target.c:1145: Unregistration of sess c00000002d5cd800 21:00:00:24:ff:7f:35:c7 finished fcp_cnt 0
kernel: PID 340:qla_target.c:1155 qlt_free_session_done(): tgt_stop 0x1, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-4807:1: PID 346:qla_os.c:6329: ISP abort scheduled.
<skipped>
kernel: qla2xxx [0001:00:02.0]-28f1:1: PID 346:qla_os.c:3956: Mark all dev lost
kernel: PID 346:qla_target.c:1266 qlt_schedule_sess_for_deletion(): tgt_stop 0x1, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-4808:1: PID 346:qla_os.c:6338: ISP abort end.
<skipped>
kernel: PID 1396:qla_target.c:6812 qlt_enable_vha(): tgt_stop 0x1, tgt_stopped 0x0
<skipped>
kernel: qla2xxx [0001:00:02.0]-4807:1: PID 346:qla_os.c:6329: ISP abort scheduled.
<skipped>
kernel: qla2xxx [0001:00:02.0]-4808:1: PID 346:qla_os.c:6338: ISP abort end.

Finally, qlt_handle_cmd_for_atio() method rejects
the requests to send commands because of treating
the adapter in the stopping state.

kernel: PID 0:qla_target.c:4442 qlt_handle_cmd_for_atio(): tgt_stop 0x1, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-3861:1: PID 0:qla_target.c:4447: New command while device c000000005314600 is shutting down
kernel: qla2xxx [0001:00:02.0]-e85f:1: PID 0:qla_target.c:5728: qla_target: Unable to send command to target

This patch adds the calling as qlt_stop_phase1() as
qlt_stop_phase2() in tcm_qla2xxx_tpg_enable_store() and
tcm_qla2xxx_npiv_tpg_enable_store() methods.
The qlt_stop_phase1() marks adapter as stopping
(tgt_stop == 0x1, tgt_stopped == 0x0) but
qlt_stop_phase2() marks adapter as stopped
(tgt_stop == 0x0, tgt_stopped == 0x1).

Signed-off-by: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 1f0a185b2a95..bf00ae16b487 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -949,6 +949,7 @@ static ssize_t tcm_qla2xxx_tpg_enable_store(struct config_item *item,
 
 		atomic_set(&tpg->lport_tpg_enabled, 0);
 		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
+		qlt_stop_phase2(vha->vha_tgt.qla_tgt);
 	}
 
 	return count;
@@ -1111,6 +1112,7 @@ static ssize_t tcm_qla2xxx_npiv_tpg_enable_store(struct config_item *item,
 
 		atomic_set(&tpg->lport_tpg_enabled, 0);
 		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
+		qlt_stop_phase2(vha->vha_tgt.qla_tgt);
 	}
 
 	return count;
-- 
2.17.1


