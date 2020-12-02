Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E87C83019
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 00:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70CFD2076C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 00:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgLBAyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 19:54:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29440 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727322AbgLBAy2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 19:54:28 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B20VlYH139504;
        Tue, 1 Dec 2020 19:53:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wZtfzhTGf6lypwIhsyh78rkduG2ZkFIINRwCdTyIVro=;
 b=FpYgRNyf0jsLMzfthX/PsX6LHmQMRrkPOrba+QC7zkaNhaQit7WgQQVn6ikFxHwWCs4T
 usSCF7CpTEPtwlJE0/ZptLi8lklCtH1dS827ydtj3o5XoXV3p+MA01Vt1HRb/dPjSu4w
 1aGDJMvtdRwSEJMy3NtqRdutRWOJN30iqHVUuaO+TjdkOVxeLBsCve0FqWF/oHnOOWGI
 A127elTLssQX+UAy09l2fNCSjBeYGK34D4qkWrCs42GSNgawFHD7WAYkMpmY7PI+2pe/
 OWiz4tLIow8ElCqYN087OxXBi6jZnCSBLodm8zAw6GK30BPexk6nXhMZy77NKSQNlS+n Mw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355d9duy20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:53:39 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B20bMt0003583;
        Wed, 2 Dec 2020 00:53:38 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 354ysudaea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 00:53:38 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B20rbvF18743772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Dec 2020 00:53:37 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A3C17805F;
        Wed,  2 Dec 2020 00:53:37 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04A8B7805E;
        Wed,  2 Dec 2020 00:53:37 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  2 Dec 2020 00:53:36 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH v2 12/17] ibmvfc: send commands down HW Sub-CRQ when channelized
Date:   Tue,  1 Dec 2020 18:53:24 -0600
Message-Id: <20201202005329.4538-13-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201202005329.4538-1-tyreld@linux.ibm.com>
References: <20201202005329.4538-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_12:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012010142
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the client has negotiated the use of channels all vfcFrames are
required to go down a Sub-CRQ channel or it is a protocoal violation. If
the adapter state is channelized submit vfcFrames to the appropriate
Sub-CRQ via the h_send_sub_crq() helper.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 4555775ea74b..3bb20bfdaf4b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -701,6 +701,15 @@ static int ibmvfc_send_crq(struct ibmvfc_host *vhost, u64 word1, u64 word2)
 	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
 }
 
+static int ibmvfc_send_sub_crq(struct ibmvfc_host *vhost, u64 cookie, u64 word1,
+			       u64 word2, u64 word3, u64 word4)
+{
+	struct vio_dev *vdev = to_vio_dev(vhost->dev);
+
+	return plpar_hcall_norets(H_SEND_SUB_CRQ, vdev->unit_address, cookie,
+				  word1, word2, word3, word4);
+}
+
 /**
  * ibmvfc_send_crq_init - Send a CRQ init message
  * @vhost:	ibmvfc host struct
@@ -1513,15 +1522,19 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 			     struct ibmvfc_host *vhost, unsigned long timeout)
 {
 	__be64 *crq_as_u64 = (__be64 *) &evt->crq;
+	int channel_cmd = 0;
 	int rc;
 
 	/* Copy the IU into the transfer area */
 	*evt->xfer_iu = evt->iu;
-	if (evt->crq.format == IBMVFC_CMD_FORMAT)
+	if (evt->crq.format == IBMVFC_CMD_FORMAT) {
 		evt->xfer_iu->cmd.tag = cpu_to_be64((u64)evt);
-	else if (evt->crq.format == IBMVFC_MAD_FORMAT)
+		channel_cmd = 1;
+	} else if (evt->crq.format == IBMVFC_MAD_FORMAT) {
 		evt->xfer_iu->mad_common.tag = cpu_to_be64((u64)evt);
-	else
+		if (evt->xfer_iu->mad_common.opcode == IBMVFC_TMF_MAD)
+			channel_cmd = 1;
+	} else
 		BUG();
 
 	list_add_tail(&evt->queue, &vhost->sent);
@@ -1534,8 +1547,17 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 
 	mb();
 
-	if ((rc = ibmvfc_send_crq(vhost, be64_to_cpu(crq_as_u64[0]),
-				  be64_to_cpu(crq_as_u64[1])))) {
+	if (vhost->using_channels && channel_cmd)
+		rc = ibmvfc_send_sub_crq(vhost,
+					 vhost->scsi_scrqs.scrqs[evt->hwq].vios_cookie,
+					 be64_to_cpu(crq_as_u64[0]),
+					 be64_to_cpu(crq_as_u64[1]),
+					 0, 0);
+	else
+		rc = ibmvfc_send_crq(vhost, be64_to_cpu(crq_as_u64[0]),
+				     be64_to_cpu(crq_as_u64[1]));
+
+	if (rc) {
 		list_del(&evt->queue);
 		del_timer(&evt->timer);
 
-- 
2.27.0

