Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC6CC001DF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 14:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjGXOwI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 10:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjGXOwH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 10:52:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2BA10C3;
        Mon, 24 Jul 2023 07:52:06 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36OEenmM028654;
        Mon, 24 Jul 2023 14:52:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=d937RMY7ZZlW43sn+9FAkbTBiABzA3bEQgbYLyhmSlI=;
 b=Th5LJRXFsqdwMK1iupR6x+nwxHVNFDU0gqEoFi5olNoSr6ra+KNohvt+p974Vf90snMl
 Q1Kgecdon3LXHuc+nMVescB8/vCNZRy78CypXMeECvD//AU8OX8FZvGtL1jqfod8/QwE
 OKjvGRHQjGjQHdu3xXJ1dLLyXC9XNMRaiwRTpHlXTwAEZvLyTfpTngVdbj98koWlqVyJ
 VdVdTpQEd4qjFM2a+oOKEitcwnJsNubL6vKobaM95osO6LRontmL3Wjl97/Ip/IVqeMW
 +DkteY1WFaWABklTtIeL1wtlsXzDUki2LjIw7x4v1ZbAyOTjVV9LN4QsghbYon+RXGtt GA== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1thfhhbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 14:52:03 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36OEcVWe002379;
        Mon, 24 Jul 2023 14:52:03 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0unj3g9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 14:52:02 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36OEq0et44695942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 14:52:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E24D820043;
        Mon, 24 Jul 2023 14:51:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8319B20040;
        Mon, 24 Jul 2023 14:51:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jul 2023 14:51:59 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH] zfcp: defer fc_rport blocking until after ADISC response
Date:   Mon, 24 Jul 2023 16:51:56 +0200
Message-Id: <20230724145156.3920244-1-maier@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LuuUUcX18NkGH1jq2s6ALlc8oDAm3Vs3
X-Proofpoint-GUID: LuuUUcX18NkGH1jq2s6ALlc8oDAm3Vs3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_11,2023-07-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 clxscore=1011 phishscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240129
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Storages are free to send RSCNs, e.g. for internal state changes. If this
happens on all connected paths, zfcp risks temporarily losing all paths at
the same time. This has strong requirements on multipath configuration such
as "no_path_retry queue".

Avoid such situations by deferring fc_rport blocking until after the ADISC
response, when any actual state change of the remote port became clear.
The already existing port recovery triggers explicitly block the fc_rport.
The triggers are: on ADISC reject or timeout (typical cable pull case), and
on ADISC indicating that the remote port has changed its WWPN or
the port is meanwhile no longer open.

As a side effect, this also removes a confusing direct function call to
another work item function zfcp_scsi_rport_work() instead of scheduling
that other work item. It was probably done that way to have the rport block
side effect immediate and synchronous to the caller.

Fixes: a2fa0aede07c ("[SCSI] zfcp: Block FC transport rports early on errors")
Cc: <stable@vger.kernel.org> #v2.6.30+
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Fedor Loshakov <loshakov@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index f21307537829..4f0d0e55f0d4 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -534,8 +534,7 @@ static void zfcp_fc_adisc_handler(void *data)
 
 	/* re-init to undo drop from zfcp_fc_adisc() */
 	port->d_id = ntoh24(adisc_resp->adisc_port_id);
-	/* port is good, unblock rport without going through erp */
-	zfcp_scsi_schedule_rport_register(port);
+	/* port is still good, nothing to do */
  out:
 	atomic_andnot(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
 	put_device(&port->dev);
@@ -595,9 +594,6 @@ void zfcp_fc_link_test_work(struct work_struct *work)
 	int retval;
 
 	set_worker_desc("zadisc%16llx", port->wwpn); /* < WORKER_DESC_LEN=24 */
-	get_device(&port->dev);
-	port->rport_task = RPORT_DEL;
-	zfcp_scsi_rport_work(&port->rport_work);
 
 	/* only issue one test command at one time per port */
 	if (atomic_read(&port->status) & ZFCP_STATUS_PORT_LINK_TEST)

base-commit: 010c1e1c5741365dbbf44a5a5bb9f30192875c4c
-- 
2.39.2

