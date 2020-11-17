Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C70C64E75
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 19:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 477DC2225E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 19:17:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KRpsbxw9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgKQTQv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 14:16:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727967AbgKQTQu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 14:16:50 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHJ1s38102454;
        Tue, 17 Nov 2020 14:16:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kZcCssClMXjy8GLiSfEkjuGbeDo2rfIlZZxOvMfHqYA=;
 b=KRpsbxw9lgmIMOk4aEO6q5v6c7RbQtyqP/A+uEvuoJpD+Fn4vxNNNvlWBPpAnnHY+gmR
 RWDmKko/jlYihmYfRBN8YusOsorN08cgXHLR8oYCz0EJ4Wt0kxEPTC1oUDuSUlUyfX4H
 mxCqNTRYwq8wT9CmrQlRoTLadEnDb2bgXGP9k/DP88gSz67D0zNTNbaxqrXZQgFmTCex
 E9xoQK2bR8uq+gKzo+YniouJouhF8l8KAwRs3z7tdFd1DJJeSr0IMwvgwjGN9tdl+obP
 GSk+9oZV/jOepMNeq5N3LLEkm5OUEO5RDH5p5AIElWPmQGrXfDO3Ax7hwlGSYaGygIWy 1g== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vexst7jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 14:16:44 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHJ7m74013151;
        Tue, 17 Nov 2020 19:16:42 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 34t6v9evv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 19:16:42 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHJGeOm26018048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 19:16:40 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8961CC6057;
        Tue, 17 Nov 2020 19:16:40 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25C8EC6055;
        Tue, 17 Nov 2020 19:16:40 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 19:16:40 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 3/6] ibmvfc: add helper for testing capability flags
Date:   Tue, 17 Nov 2020 13:16:33 -0600
Message-Id: <20201117191636.131127-4-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117191636.131127-1-tyreld@linux.ibm.com>
References: <20201117191636.131127-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_07:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Testing the NPIV Login response capabilities is a long winded process of
dereferencing the vhost->login_buf->resp.capabilities field byte
swapping that value to host endian and performing the bitwise test.
Currently we only ever check this in ibmvfc_cancel_all(), but follow-up
patches will need to regularly check for targetWWPN and channelization
support.

Add a helper to simplify checking various VIOS capabilities.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index d33b24668367..a68602cd1255 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -138,6 +138,13 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
 
 static const char *unknown_error = "unknown error";
 
+static int ibmvfc_check_caps(struct ibmvfc_host *vhost, unsigned long cap_flags)
+{
+	u64 host_caps = be64_to_cpu(vhost->login_buf->resp.capabilities);
+
+	return (host_caps & cap_flags) ? 1 : 0;
+}
+
 #ifdef CONFIG_SCSI_IBMVFC_TRACE
 /**
  * ibmvfc_trc_start - Log a start trace entry
@@ -2240,7 +2247,7 @@ static int ibmvfc_cancel_all(struct scsi_device *sdev, int type)
 		tmf->common.length = cpu_to_be16(sizeof(*tmf));
 		tmf->scsi_id = cpu_to_be64(rport->port_id);
 		int_to_scsilun(sdev->lun, &tmf->lun);
-		if (!(be64_to_cpu(vhost->login_buf->resp.capabilities) & IBMVFC_CAN_SUPPRESS_ABTS))
+		if (!ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPRESS_ABTS))
 			type &= ~IBMVFC_TMF_SUPPRESS_ABTS;
 		if (vhost->state == IBMVFC_ACTIVE)
 			tmf->flags = cpu_to_be32((type | IBMVFC_TMF_LUA_VALID));
-- 
2.27.0

