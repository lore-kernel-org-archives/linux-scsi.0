Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E6BC4360C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0CF761177
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhDNRIm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 13:08:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233470AbhDNRIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 13:08:35 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EH4QuH163430;
        Wed, 14 Apr 2021 13:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=klApNa0Kv1+Zp7hTqxbG3LHgP4atKbpz9N5lkG+so/o=;
 b=lB469wrpfBwBYcmo++jAbXTCMPO5K3tJ0Yt9+UdCDDu24r6SDwjJUOJV4CgFxgG4J0H1
 lFTUILZgWAZMw5dMo4aIb5jV1AWPci89s1TExSG9+/hrAe5YS1rRbLmU5uCTV2Io5BCq
 dMY1QuubIiQXYt0fLudFnDqkGMkfoNmFDRcJX5hWtIintYmp9c/78lCFJy5tWULezXGX
 4k+Nr/AdcK+OBEYWVD3bxOW4dpjEjoIIzKL6zWw+bqWx9wLQVsGpG+gO+2Dw5p2p7Koe
 05VfQFYYyXsybj0w3WtoMgtFcM0pNsfV4GqF61Vpo620Md51g9M/VgmiZDf5vcTfKJJG sQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x4dk0669-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 13:08:10 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13EH2gQR021835;
        Wed, 14 Apr 2021 17:08:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 37u3n89u74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 17:08:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13EH7gCq36766168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 17:07:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D26DB4D620;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6E314D623;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.18.252])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lWizk-002b2p-9e; Wed, 14 Apr 2021 19:08:04 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Sumangala Bannur Subraya <bsuma@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 1/6] zfcp: remove unneeded INIT_LIST_HEAD() for FSF requests
Date:   Wed, 14 Apr 2021 19:07:59 +0200
Message-Id: <254dc0ae28dccc43ab0b1079ef2c8dcb5fe1d2e4.1618417667.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618417667.git.bblock@linux.ibm.com>
References: <cover.1618417667.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ahOYjf0fKWYpwvPuo3tlXecJpqEzT5Np
X-Proofpoint-ORIG-GUID: ahOYjf0fKWYpwvPuo3tlXecJpqEzT5Np
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_10:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

INIT_LIST_HEAD() is only needed for actual list heads, while req->list
is used as a list entry.

Note that when the error path in zfcp_fsf_req_send() removes the request
from the adapter's list of pending requests, it actually looks up the
request from the zfcp_reqlist - rather than just calling list_del().
So there's no risk of us calling list_del() on a request that hasn't
been added to any list yet.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 485028324eae..2e4804ef2fb9 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -846,7 +846,6 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_qdio *qdio,
 	if (adapter->req_no == 0)
 		adapter->req_no++;
 
-	INIT_LIST_HEAD(&req->list);
 	timer_setup(&req->timer, NULL, 0);
 	init_completion(&req->completion);
 
-- 
2.30.2

