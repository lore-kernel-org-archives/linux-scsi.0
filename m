Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 690B0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 04:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31F6D60FBF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 04:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244715AbhIQExY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 00:53:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229524AbhIQExW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 00:53:22 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18H4RES3028235;
        Fri, 17 Sep 2021 00:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=YDdDWuS4gEUmYH95pLfp7IAuAzXZHyH1/s7htloovyI=;
 b=Uvvznt0z166ntF9krzpNAKvWaHZPcWfYnRjPthUjLkmZLXMZXdAbQqGXrVC8YwoZ7AKB
 lVj4bRhZGkMLSxESc4QQszVDUXkrBeVT4ihJNWNcfUYvmeVdy9eWPh6ZfuL/MfPyjzHp
 vNR7qRmwiw2/IHcYzeqXUnzcTDMAgR2OMWOEIpY5inveaS+F0kVphRBDWQ5DfYCQ4HS6
 VtJYcLva23EmAh2Fu2I3RigNRhf2F6N9wksW3VPzBCHWmWshPQ5ZxT3dxJl/l9BDq58h
 V1yOIYXtHQJ65iD6RyehSYWeZVBQcUvnusxj5CM6tWc2f/Mm2BxOLKZxLBtujnn9XHuY ig== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4g673vrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 00:51:59 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18H4kuQH031172;
        Fri, 17 Sep 2021 04:51:59 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3b0m3dfmdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 04:51:59 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18H4pvIs16777976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 04:51:57 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 052426E059;
        Fri, 17 Sep 2021 04:51:57 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A7836E054;
        Fri, 17 Sep 2021 04:51:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.40.195.89])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 04:51:56 +0000 (GMT)
From:   wenxiong@linux.ibm.com
To:     jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        martin.petersen@oracle.com, wenxiong@us.ibm.com,
        Wen Xiong <wenxiong@linux.ibm.com>
Subject: [PATCH RESEND V4 0/1] Saw "Failed to get diagnostic page 0x1"
Date:   Thu, 16 Sep 2021 22:24:20 -0500
Message-Id: <1631849061-10210-1-git-send-email-wenxiong@linux.ibm.com>
X-Mailer: git-send-email 1.6.0.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7aGKblvnsTz9RMV3OHhkDrwLJKGpAw2i
X-Proofpoint-GUID: 7aGKblvnsTz9RMV3OHhkDrwLJKGpAw2i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_02,2021-09-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 mlxlogscore=822 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wen Xiong <wenxiong@linux.ibm.com>

v4:
Add checking return value before calling scsi_sense_valid()
v3:
checked to retry on NOT_READY and UNIT_ATTENTION
v2:
checked to retry on UNIT_ATTENTION in ses_recv_diag();
v1:
called scsi_test_unit_ready() to eat UA in ses_recv_diag()

Wen Xiong (1):
  scsi/ses: Saw "Failed to get diagnostic page 0x1"

 drivers/scsi/ses.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

-- 
2.27.0

