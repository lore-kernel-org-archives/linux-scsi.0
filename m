Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC93C61DA3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 17:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjBUR46 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 12:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbjBUR4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 12:56:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEA52FCC5;
        Tue, 21 Feb 2023 09:56:24 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LHmKad028668;
        Tue, 21 Feb 2023 17:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding : sender;
 s=pp1; bh=pbAj4NuxsnZ8hrBOllwxXmnxgpHTSEGyBfwq6Th04yY=;
 b=oVY9JLIBECugjuAn0DBj05XHJfnO0XmBl8IQIQtGv5F2lLd8JJCQeBGib46gsDr+OBye
 3NrLUWFa4rd/9br5uBa7SfhIsmJSU+w32S5BBOkt9znZt8fDqPmp/W8u1YCQGd140P7z
 Z0JXXYfiokjzsHEv2dl8lWb0INfemSedZlDdGGpChKwzXzesF1I25NkUoPdjRaSKWCmG
 bq/oUr+qnIVfMWK8yvBBwPByEkSWMO1Q6lgtyjFK90GCldnaX3+VIOLmFNXcC5rbOe82
 OY1Zc0aSkOb9qsMLJP9vz37LECrsTUoN4IBfq4FLoEOCzQv/7pvLvxQxs7Tb7yx/zEty Qg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw11rjtn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:56:07 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31LD5wdB014757;
        Tue, 21 Feb 2023 17:56:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3ntpa639sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:56:05 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31LHu1sU24379756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 17:56:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7347F20043;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 625DE20040;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.246])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 21 Feb 2023 17:56:01 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pUWrw-003akz-3C;
        Tue, 21 Feb 2023 18:56:01 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Steffen Maier" <maier@linux.ibm.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        "Fedor Loshakov" <loshakov@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: zfcp changes for v6.3
Date:   Tue, 21 Feb 2023 18:55:57 +0100
Message-Id: <cover.1677000450.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung David Faller, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294, https://www.ibm.com/privacy
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ngZw5g5V7REd71o_9bDEMSNHyOamN0mg
X-Proofpoint-GUID: ngZw5g5V7REd71o_9bDEMSNHyOamN0mg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_10,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxscore=0 mlxlogscore=922 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302210148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James, Martin,

here is a small set of changes for the zFCP device driver. These are
basically follow-up changes I made after the fix I send in
<979f6e6019d15f91ba56182f1aaf68d61bf37fc6.1668595505.git.bblock@linux.ibm.com>
that refactor some related areas in the driver, and add some additional
tracing if we ever should run into a similar situation somehow.

It would be nice, if you could still include them for v6.3. Not sure if
I'm too late already.


Benjamin Block (3):
  zfcp: make the type for accessing request hashtable buckets size_t
  zfcp: change the type of all fsf request id fields and variables to
    u64
  zfcp: trace when request remove fails after qdio send fails

 drivers/s390/scsi/zfcp_dbf.c     | 46 ++++++++++++++++++++++++++++++--
 drivers/s390/scsi/zfcp_def.h     |  6 ++---
 drivers/s390/scsi/zfcp_ext.h     |  5 +++-
 drivers/s390/scsi/zfcp_fsf.c     | 22 ++++++++-------
 drivers/s390/scsi/zfcp_qdio.h    |  2 +-
 drivers/s390/scsi/zfcp_reqlist.h | 26 +++++++++---------
 drivers/s390/scsi/zfcp_scsi.c    |  2 +-
 7 files changed, 80 insertions(+), 29 deletions(-)

-- 
2.39.2

