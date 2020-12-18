Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9937C35273
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 23:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3B2B23BA8
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 23:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgLRXUW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 18:20:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46754 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgLRXUP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Dec 2020 18:20:15 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BIN31gR062601;
        Fri, 18 Dec 2020 18:19:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=N58AvYKdRHEbB+vBb/VPYi0X/Mu2loM59j7ca+NgImU=;
 b=ILtItq9GE8w8k1UcV/h+yG+pFNjJmRtGjsWFNOtIirQvLKDt7temhhvSLcxUfLqMrDao
 4fkluiKG3dv7+Gk76BdSoKlpKUoYe6CFJjT54vDXRJihMYmLlY8IKocKF1Vh5btDpI8K
 9VrLLNyJF4DQKnZYicw6GE/LkR2zbIf6Yuo1i9ke7l/4J1B15PJnf0jDgjcNJv0/pYDT
 qE7A4aAgD5oaOXnQSj0NP5JXd151+EKz1ASb+dQzVDrMZeB13gPoxi5IXpWSoLbWbNcP
 /9HBSmegLJLaJZJQZbQaTEF0OjuIWO1sCjSPgH1JiU1bgeJ2wDAaBEVP8RO8feY11TLs 9Q== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35h4k9srgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 18:19:25 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BINI8xo012278;
        Fri, 18 Dec 2020 23:19:25 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 35cnga2q4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 23:19:24 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BINJNRK22413620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 23:19:23 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86AD8136055;
        Fri, 18 Dec 2020 23:19:23 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33A8013604F;
        Fri, 18 Dec 2020 23:19:23 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 18 Dec 2020 23:19:23 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 0/5] ibmvfc: MQ preparatory locking work
Date:   Fri, 18 Dec 2020 17:19:11 -0600
Message-Id: <20201218231916.279833-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_14:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=845 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180156
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ibmvfc driver in its current form relies heavily on the host_lock. This
patchset introduces a genric queue with its own queue lock and sent/free event
list locks. This generic queue allows the driver to decouple the primary queue
and future subordinate queues from the host lock reducing lock contention while
also relaxing locking for submissions and completions to simply the list lock of
the queue in question.

Tyrel Datwyler (5):
  ibmvfc: define generic queue structure for CRQs
  ibmvfc: make command event pool queue specific
  ibmvfc: define per-queue state/list locks
  ibmvfc: complete commands outside the host/queue lock
  ibmvfc: relax locking around ibmvfc_queuecommand

 drivers/scsi/ibmvscsi/ibmvfc.c | 379 ++++++++++++++++++++++-----------
 drivers/scsi/ibmvscsi/ibmvfc.h |  54 +++--
 2 files changed, 286 insertions(+), 147 deletions(-)

-- 
2.27.0

