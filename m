Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA3DC433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 20:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083266198C
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 20:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhCSUvR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 16:51:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230264AbhCSUun (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Mar 2021 16:50:43 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JKXJDf147972;
        Fri, 19 Mar 2021 16:50:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=tnFusXzx6sJTpHmQw01cJ2VLMwSVY4vqv2UYSf3JMEc=;
 b=r6b/XBa4tuTwh5AqH72VzgFzWqycrNm+kmsaK06/m/4Bhd4QWxjjaj/IWgpbRO1fwu+7
 47F/u0KhftQNMpYscPeM/xMbD22WPyPGDy8T8RL0EmrW7GO3Dy/X7dLa5P8ZhNLnlJQB
 vihQeoLUXeTp0hcLUnveko4D2wXvagO9wy8GHDzuP12Ikodyb9y0btVE5cpsPDFfACsk
 mp4tXxOXJr31dLKZIjLVvdIVF10+9MAUd6Nu6wnClGmhThXnelPSX9RZiNSfB64PuF3L
 kcRV6uqxLk1vsT8cGqhSNsnPtvm92H/4usE9FrRmnMDgx1GuSytsfik8+fQRY1xpHE38 TQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c10h1qx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 16:50:33 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JKlD8m005150;
        Fri, 19 Mar 2021 20:50:32 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 37a3gdbtu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 20:50:32 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JKoV0019071434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 20:50:31 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 146AC6E04C;
        Fri, 19 Mar 2021 20:50:31 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1E4E6E050;
        Fri, 19 Mar 2021 20:50:30 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 20:50:30 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 0/2] Fix EH race and MQ support
Date:   Fri, 19 Mar 2021 14:50:27 -0600
Message-Id: <20210319205029.312969-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_10:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changes to the locking pattern protecting the event lists and handling of scsi
command completion introduced a race where an ouststanding command that EH is
waiting ifor to complete is no longer identifiable by being on the sent list, but
instead as a command that is not on the free list. This is a result of moving
commands to be completed off the sent list to a private list to be completed
outside the list lock.

Second, during MQ enablement the ibmvfc_wait_for_ops helper used during EH to
ensure commands were properely completed failed to be converted to check for
commands on the sub-queues isntead of the primary CRQ.

Tyrel Datwyler (2):
  ibmvfc: fix potential race in ibmvfc_wait_for_ops
  ibmvfc: make ibmvfc_wait_for_ops MQ aware

 drivers/scsi/ibmvscsi/ibmvfc.c | 67 +++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 13 deletions(-)

-- 
2.27.0

