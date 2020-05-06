Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E402CC47256
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 13:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF97920870
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 13:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F6iy4dBg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgEFNtU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 09:49:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60742 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728299AbgEFNtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2020 09:49:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046DnGfp047583;
        Wed, 6 May 2020 13:49:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=j+bMZdazg7LnozagtjwtD6Cs1j8Ir/WeEcg2A8523Zg=;
 b=F6iy4dBgmkvNkrxQmlmfFAy3ZNjVuovi5rrX9LaFqiwRX4CxuZIie4PDi60BMF+pn6Uj
 gCZCBmErBP8JSC2c1Mb9FweL/FPujFyiba9b0anm1UZeyU9chEQTZM/0A6c12lHeYaIF
 42cLIjZCxmTLU7SnBAvL1gGTXW3rljsurWjKkmdzbb3KaL3F3qsoH4iCLC9ZBY3vmjM0
 Jc5L1MLsJMB9IuQwSVHA5GnH93CBi8FeEs9vOsKnFM5BZhJdZCHAH0vQXHcjerUfE9XI
 JPYjludXkXwEm/OHMD12qZBprRf7SSvwsDQz4EHzpbwVfaBameNCOYYfktegLKGMHsPi VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30usgq1hdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 13:49:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046DlRmO071967;
        Wed, 6 May 2020 13:49:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30sjnjg8uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 13:49:15 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 046DnFB3013078;
        Wed, 6 May 2020 13:49:15 GMT
MIME-Version: 1.0
Message-ID: <fea24526-8bbd-4f07-a06a-97c0c2775252@default>
Date:   Wed, 6 May 2020 06:49:14 -0700 (PDT)
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     <v.dubeiko@yadro.com>
Cc:     <linux-scsi@vger.kernel.org>, <r.bolshakov@yadro.com>,
        <slava@dubeyko.com>, <linux@yadro.com>, <hmadhani@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi: qla2xxx: Fix issue with fake adapter's stopping
 state
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060110
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


----- Original Message -----
From: v.dubeiko@yadro.com
To: linux-scsi@vger.kernel.org
Cc: hmadhani@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com, l=
inux@yadro.com, r.bolshakov@yadro.com, slava@dubeyko.com
Sent: Friday, April 24, 2020 7:10:49 AM GMT -06:00 US/Canada Central
Subject: [PATCH 3/3] scsi: qla2xxx: Fix issue with fake adapter's stopping =
state

From: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Date: Wed, 22 Apr 2020 13:55:52 +0300
Subject: [PATCH 3/3] scsi: qla2xxx: Fix issue with fake adapter's stopping =
state

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

kernel: PID 1396:qla_target.c:1555 qlt_stop_phase1(): tgt_stop 0x0, tgt_sto=
pped 0x0
kernel: qla2xxx [0001:00:02.0]-e803:1: PID 1396:qla_target.c:1567: Stopping=
 target for host 1(c0000000033557e8)
kernel: PID 1396:qla_target.c:1579 qlt_stop_phase1(): tgt_stop 0x1, tgt_sto=
pped 0x0
kernel: PID 1396:qla_target.c:1266 qlt_schedule_sess_for_deletion(): tgt_st=
op 0x1, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-e801:1: PID 1396:qla_target.c:1316: Scheduli=
ng sess c00000002d5cd800 for deletion 21:00:00:24:ff:7f:35:c7
<skipped>
kernel: qla2xxx [0001:00:02.0]-290a:1: PID 340:qla_target.c:1187: qlt_unreg=
_sess sess c00000002d5cd800 for deletion 21:00:00:24:ff:7f:35:c7
<skipped>
kernel: qla2xxx [0001:00:02.0]-f801:1: PID 340:qla_target.c:1145: Unregistr=
ation of sess c00000002d5cd800 21:00:00:24:ff:7f:35:c7 finished fcp_cnt 0
kernel: PID 340:qla_target.c:1155 qlt_free_session_done(): tgt_stop 0x1, tg=
t_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-4807:1: PID 346:qla_os.c:6329: ISP abort sch=
eduled.
<skipped>
kernel: qla2xxx [0001:00:02.0]-28f1:1: PID 346:qla_os.c:3956: Mark all dev =
lost
kernel: PID 346:qla_target.c:1266 qlt_schedule_sess_for_deletion(): tgt_sto=
p 0x1, tgt_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-4808:1: PID 346:qla_os.c:6338: ISP abort end=
.
<skipped>
kernel: PID 1396:qla_target.c:6812 qlt_enable_vha(): tgt_stop 0x1, tgt_stop=
ped 0x0
<skipped>
kernel: qla2xxx [0001:00:02.0]-4807:1: PID 346:qla_os.c:6329: ISP abort sch=
eduled.
<skipped>
kernel: qla2xxx [0001:00:02.0]-4808:1: PID 346:qla_os.c:6338: ISP abort end=
.

Finally, qlt_handle_cmd_for_atio() method rejects
the requests to send commands because of treating
the adapter in the stopping state.

kernel: PID 0:qla_target.c:4442 qlt_handle_cmd_for_atio(): tgt_stop 0x1, tg=
t_stopped 0x0
kernel: qla2xxx [0001:00:02.0]-3861:1: PID 0:qla_target.c:4447: New command=
 while device c000000005314600 is shutting down
kernel: qla2xxx [0001:00:02.0]-e85f:1: PID 0:qla_target.c:5728: qla_target:=
 Unable to send command to target

This patch adds the calling as qlt_stop_phase1() as
qlt_stop_phase2() in tcm_qla2xxx_tpg_enable_store() and
tcm_qla2xxx_npiv_tpg_enable_store() methods.
The qlt_stop_phase1() marks adapter as stopping
(tgt_stop =3D=3D 0x1, tgt_stopped =3D=3D 0x0) but
qlt_stop_phase2() marks adapter as stopped
(tgt_stop =3D=3D 0x0, tgt_stopped =3D=3D 0x1).

Signed-off-by: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_=
qla2xxx.c
index 1f0a185b2a95..bf00ae16b487 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -949,6 +949,7 @@ static ssize_t tcm_qla2xxx_tpg_enable_store(struct conf=
ig_item *item,
=20
 =09=09atomic_set(&tpg->lport_tpg_enabled, 0);
 =09=09qlt_stop_phase1(vha->vha_tgt.qla_tgt);
+=09=09qlt_stop_phase2(vha->vha_tgt.qla_tgt);
 =09}
=20
 =09return count;
@@ -1111,6 +1112,7 @@ static ssize_t tcm_qla2xxx_npiv_tpg_enable_store(stru=
ct config_item *item,
=20
 =09=09atomic_set(&tpg->lport_tpg_enabled, 0);
 =09=09qlt_stop_phase1(vha->vha_tgt.qla_tgt);
+=09=09qlt_stop_phase2(vha->vha_tgt.qla_tgt);
 =09}
=20
 =09return count;
--=20
2.17.1

Looks good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani
Oracle Linux Engineering
