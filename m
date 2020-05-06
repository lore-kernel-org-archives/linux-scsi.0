Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D29DC28CBC
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 13:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5774A20752
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 13:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q0yeVLpS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgEFNq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 09:46:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58420 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgEFNq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2020 09:46:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046DhHOU041920;
        Wed, 6 May 2020 13:46:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=w16je4uZi8BbuJLeNe8Q1KxMm+nHUOYgmUvgjev9Xls=;
 b=Q0yeVLpSAzDSd+8yfNukwfHm//XtPjpD4RR0UxYbYDA1TCYTI2ZhjXmVfJo2YP0v+MDT
 bDNaZ+p7vOoNsnUVy8EF3l0o+WS/yUZHzp0r4LwxlgxICX+uVE1JVP2OPV5djtwnZ42h
 uLGa9+gJP1LekAl2L6BcvQVfEo3wKHsDsC7txXEMHfq3Bu/i9BbzzNYYobA1w0rQ3dbH
 4L8QYB5xcWCKwQnOTyyey9cCc45Z+XoSwF1kHuVCNzCECSZaeyRi8hMN+CJxqOpR72Bq
 fBfkIG15A/qkuPXRIVp4cDPLKa0r/APrW6fVScz9nmGD9b3Hcihz7MslmO2VF0+N4+4Z AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30usgq1gwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 13:46:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046Dgcgw041793;
        Wed, 6 May 2020 13:46:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30us7mqxad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 13:46:51 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 046DknCh011603;
        Wed, 6 May 2020 13:46:49 GMT
MIME-Version: 1.0
Message-ID: <df987b76-19b1-472d-8314-5785955ab2e1@default>
Date:   Wed, 6 May 2020 06:46:49 -0700 (PDT)
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     <v.dubeiko@yadro.com>
Cc:     <linux-scsi@vger.kernel.org>, <r.bolshakov@yadro.com>,
        <slava@dubeyko.com>, <linux@yadro.com>, <hmadhani@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] scsi: qla2xxx: Fix failure message in
 qlt_disable_vha()
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1011
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060109
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


----- Original Message -----
From: v.dubeiko@yadro.com
To: linux-scsi@vger.kernel.org
Cc: hmadhani@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com, l=
inux@yadro.com, r.bolshakov@yadro.com, slava@dubeyko.com
Sent: Friday, April 24, 2020 7:10:39 AM GMT -06:00 US/Canada Central
Subject: [PATCH 2/3] scsi: qla2xxx: Fix failure message in qlt_disable_vha(=
)

From: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Date: Wed, 22 Apr 2020 13:51:51 +0300
Subject: [PATCH 2/3] scsi: qla2xxx: Fix failure message in qlt_disable_vha(=
)

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

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_t=
arget.c
index 622e7337affc..f3255aa70dcc 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6661,9 +6661,14 @@ static void qlt_disable_vha(struct scsi_qla_host *vh=
a)
=20
 =09set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 =09qla2xxx_wake_dpc(vha);
+
+=09/*
+=09 * We are expecting the offline state.
+=09 * QLA_FUNCTION_FAILED means that adapter is offline.
+=09 */
 =09if (qla2x00_wait_for_hba_online(vha) !=3D QLA_SUCCESS)
 =09=09ql_dbg(ql_dbg_tgt, vha, 0xe081,
-=09=09       "qla2x00_wait_for_hba_online() failed\n");
+=09=09       "adapter is offline\n");
 }
=20
 /*
--=20
2.17.1

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani
Oracle Linux Engineering
