Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E95C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 16:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiGFP76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 11:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiGFP7x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 11:59:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F249021810;
        Wed,  6 Jul 2022 08:59:52 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266Fonb8001910;
        Wed, 6 Jul 2022 15:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=BX+n5fBYSAdWzK5Fv6TOs/uw1D1qZthzzBWrUrdtVRg=;
 b=K9n3jKjOA3vqHbidN58bGgSJHvFfMItEDVfALxoMfMKANt801PInv6rxBO38xdLf1IeP
 QpNyXhAJRv0BgW1lmNllgDf3tHReHAVuiAfCA7uv3OdmPHZS3oT4pxptG/ZIvyGxwAHY
 UcnPj7fexrqQnpWEWjbZ6YXW8GTpLwFW66n6MIEfJYVzIRTgvxib8llz6dSCBjh5LPdJ
 s75CayMY6I29Ljih80BWTChQvFnu+2CL4NvbqZBLmQZXiIP1W5K8S1IZtQ0g3CWbmtHj
 bkcU6kJi06/iq01ptz4xbnu3sNWt5V1nAStgD8YHlzpoXHFiLdJfujWyDDB6dcIEs+q9 hA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5dd586jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 15:59:47 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 266FpaOm025969;
        Wed, 6 Jul 2022 15:59:44 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3h4v4jsbay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 15:59:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 266FxfmB16974318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 15:59:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76805A4051;
        Wed,  6 Jul 2022 15:59:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62109A4040;
        Wed,  6 Jul 2022 15:59:41 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.132])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  6 Jul 2022 15:59:41 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.95)
        (envelope-from <bblock@linux.ibm.com>)
        id 1o97RF-005M3t-0z;
        Wed, 06 Jul 2022 17:59:41 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Steffen Maier" <maier@linux.ibm.com>
Cc:     Jiang Jian <jiangjian@cdjrlc.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        "Fedor Loshakov" <loshakov@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 2/2] scsi: zfcp: drop unexpected word "the" in the comments
Date:   Wed,  6 Jul 2022 17:59:40 +0200
Message-Id: <4c02fefa19ab46f0f163990bde3ce10bd9c7caf1.1657122360.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657122360.git.bblock@linux.ibm.com>
References: <cover.1657122360.git.bblock@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung David Faller, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294, https://www.ibm.com/privacy
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ynzrshdZZETZ9AM2dWvWFmUWkrVQxd_5
X-Proofpoint-GUID: ynzrshdZZETZ9AM2dWvWFmUWkrVQxd_5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207060062
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jiang Jian <jiangjian@cdjrlc.com>

there is an unexpected word "the" in the comments that need to be dropped

file: ./drivers/s390/scsi/zfcp_diag.h
line: 5
* Definitions for handling diagnostics in the the zfcp device driver.
changed to
* Definitions for handling diagnostics in the zfcp device driver.

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Link: https://lore.kernel.org/r/20220621114207.106405-1-jiangjian@cdjrlc.com
---
 drivers/s390/scsi/zfcp_diag.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_diag.h b/drivers/s390/scsi/zfcp_diag.h
index da55133da8fe..15c25fefe91a 100644
--- a/drivers/s390/scsi/zfcp_diag.h
+++ b/drivers/s390/scsi/zfcp_diag.h
@@ -2,7 +2,7 @@
 /*
  * zfcp device driver
  *
- * Definitions for handling diagnostics in the the zfcp device driver.
+ * Definitions for handling diagnostics in the zfcp device driver.
  *
  * Copyright IBM Corp. 2018, 2020
  */
-- 
2.36.1

