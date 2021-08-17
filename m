Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22FAC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 21:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA1F86102A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 21:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhHQVYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 17:24:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13322 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235082AbhHQVYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 17:24:47 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HL3TM6103570
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 17:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=yA0c2xcDdgJqczjpJbyEpXf7+X8Pw2KSkfLTexqbUA8=;
 b=Zrd46VTEGeTqAp1d4XsegXBqYEFNmfK2IKgW4s7zAJoxgzBvzyGGv3PLhtqZb6vakRiU
 OHqW7yWtoAXxYwpFMTzDCmRYHZEMMMUo1inIEdNJ8a6RinETCWNA5ZSeoiM6L+jPT2s+
 i/SabSgKHBFEq51jdgahNvvlsMJWbNut33CBYrrSxetOAJP60nYYLU0xOzrLzipSGxzb
 VnRRYx70Ox7eUstHmRvAbg0xXSuXA4f+SMES9TlploL6x3nduwKu051iGikvlFklZATc
 OQH2fTTRVGExysd30pyiuj/FYFhiV20Tflh+sDy/cDc8iMYwPweDn56DaiHHVM09jQnm Ag== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcww8fnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 17:24:13 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17HL98eT017554
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 21:24:13 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 3ae5fcp4uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 21:24:13 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17HLOBtx42729792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 21:24:11 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 523926A063;
        Tue, 17 Aug 2021 21:24:11 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08B8B6A057;
        Tue, 17 Aug 2021 21:24:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.40.195.89])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 Aug 2021 21:24:10 +0000 (GMT)
From:   wenxiong@linux.vnet.ibm.com
To:     jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking1@linux.vnet.ibm.com,
        wenxiong@us.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>
Subject: [PATCH 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1" during
Date:   Tue, 17 Aug 2021 14:57:35 -0500
Message-Id: <1629230255-11616-1-git-send-email-wenxiong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fsIcYIxGZdVxPJgfK3Plz_FkmXi4LWLh
X-Proofpoint-ORIG-GUID: fsIcYIxGZdVxPJgfK3Plz_FkmXi4LWLh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_08:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108170132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

We saw two errors with Slider drawer:
- Failed to get diagnostic page 0x1 during booting up
- /sys/class/enclosure are empty with ipr adapter + Slider drawer

From scsi logging level with error=3, looks ses_recv_diag not try on a UA.
Added scsi_test_unit_ready() which retried with UA. The patch fixes
both of above errors.

Signed-Off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ses.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..5811639a0747 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -633,6 +633,8 @@ static int ses_intf_add(struct device *cdev,
 	int num_enclosures;
 	struct enclosure_device *edev;
 	struct ses_component *scomp = NULL;
+	struct scsi_sense_hdr sshdr;
+	int ret;
 
 	if (!scsi_device_enclosure(sdev)) {
 		/* not an enclosure, but might be in one */
@@ -654,6 +656,10 @@ static int ses_intf_add(struct device *cdev,
 	if (!hdr_buf || !ses_dev)
 		goto err_init_free;
 
+	ret = scsi_test_unit_ready(sdev, SES_TIMEOUT, SES_RETRIES, &sshdr);
+	if (!scsi_status_is_good(ret))
+		goto err_init_free;
+
 	page = 1;
 	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
-- 
2.27.0

