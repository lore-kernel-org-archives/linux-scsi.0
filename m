Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C915C10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BFCB206F1
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCLRpU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 13:45:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726362AbgCLRpU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 13:45:20 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CHiLVH143119
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:45:19 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yqsrbr0yw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:45:18 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 12 Mar 2020 17:45:17 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 17:45:15 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CHjDhV51576896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:45:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 711C052057;
        Thu, 12 Mar 2020 17:45:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2D2305204E;
        Thu, 12 Mar 2020 17:45:13 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 00/10] zfcp features for v5.7
Date:   Thu, 12 Mar 2020 18:44:55 +0100
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20031217-0028-0000-0000-000003E3C2C3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031217-0029-0000-0000-000024A90B25
Message-Id: <20200312174505.51294-1-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_11:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 mlxscore=0 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120090
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin, James,

one small zfcp fix and 2 features for v5.7.
Patches apply to Martin's 5.7/scsi-queue or James' misc branch.

Patch 1 is a small preventive fix with locking for point-to-point.

Patches 2..4 is a feature to expose fabric_name in fc_host sysfs.

Patches 5..8 is a feature to provide user information on the state of
the otherwise transparent IBM Fibre Channel Endpoint Security.
Patches 9..10 is a feature to add new recovery and corresponding
kernel messages related to IBM Fibre Channel Endpoint Security.
[http://www.redbooks.ibm.com/redpieces/abstracts/sg248455.html?Open]


Jens Remus (6):
  zfcp: auto variables for dereferenced structs in open port handler
  zfcp: report FC Endpoint Security in sysfs
  zfcp: log FC Endpoint Security of connections
  zfcp: trace FC Endpoint Security of FCP devices and connections
  zfcp: enhance handling of FC Endpoint Security errors
  zfcp: log FC Endpoint Security errors

Steffen Maier (4):
  zfcp: fix missing erp_lock in port recovery trigger for point-to-point
  zfcp: expose fabric name as common fc_host sysfs attribute
  zfcp: wire previously driver-specific sysfs attributes also to fc_host
  zfcp: fix fc_host attributes that should be unknown on local link down

 drivers/s390/scsi/zfcp_dbf.c   |  44 ++++-
 drivers/s390/scsi/zfcp_dbf.h   |  32 +++-
 drivers/s390/scsi/zfcp_def.h   |   6 +-
 drivers/s390/scsi/zfcp_erp.c   |   2 +-
 drivers/s390/scsi/zfcp_ext.h   |  12 +-
 drivers/s390/scsi/zfcp_fsf.c   | 290 ++++++++++++++++++++++++++++++---
 drivers/s390/scsi/zfcp_fsf.h   |  23 ++-
 drivers/s390/scsi/zfcp_scsi.c  |   5 +
 drivers/s390/scsi/zfcp_sysfs.c |  70 +++++++-
 9 files changed, 449 insertions(+), 35 deletions(-)

-- 
2.17.1

