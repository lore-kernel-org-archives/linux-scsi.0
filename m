Return-Path: <SRS0=SSlb=ED=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74E5C388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 21:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EDCD24857
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 21:33:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZjDZYPSx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgJ1VdL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:33:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9768 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgJ1VdK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Oct 2020 17:33:10 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SI22Xs067483;
        Wed, 28 Oct 2020 14:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding : sender;
 s=pp1; bh=qroMZAEeiJASjmAsz/C4AnrRLZKN1U7Iue4g2NJm6AY=;
 b=ZjDZYPSxriOFpuB0cREOrRJzj9/6u8np8q1fqFvNlo4ti9BnX8oAFtJYEEaL/Az5SpuV
 Aw0Vl/fxwRSzUqmf3xH3FKfcPjr+NIYvXEykUe6PiwUyzXHtNfDPXgzLqcoAcIJn65go
 wF5Em/aX8vJTrRIR3xHBZ6vVjNimS+ydD1SYZTlx0kPjjuLEfz/BaDRZCW2aHWDQPy7D
 xpPI+gJkl8NhRkCmov1+BzgPVQpTi3GIM3I42pxapCe/MPWoCjIvVsBFsV9xBcxZQsok
 2i0t75ukAodvEkWTxtXy0JUQKcglFQjBIAucOHZsAuLyUiUBbVuWvbWhe5PL2csp5rTN 8A== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34d97hwtbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 14:30:58 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09SIS27j030355;
        Wed, 28 Oct 2020 18:30:56 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 34f8cr89s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 18:30:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09SIUrMK22806948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 18:30:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E4ED52075;
        Wed, 28 Oct 2020 18:30:53 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.181])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 43C9152073;
        Wed, 28 Oct 2020 18:30:53 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kXqDk-002prt-9n; Wed, 28 Oct 2020 19:30:52 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 0/5] zfcp: cleanups, refactorings and features for 5.11
Date:   Wed, 28 Oct 2020 19:30:47 +0100
Message-Id: <cover.1603908167.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_08:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1011 bulkscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=913
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010280116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James, Martin,

here is a series of changes for our zfcp driver for 5.11.

Other than 2 smaller cleanups and clarifications for maintainability we
have a refactoring of how zfcp uses s390's qdio layer, and we have a
small feature improving our handling of out-of-band version changes to our
adapters (or firmware).

Especially the refactoring ("zfcp: lift Input Queue tasklet from qdio")
would be nice to have, because we have other patches queued internally
that depend on this, and because qdio patches go via the s390 tree, this
creates a dependency for Heiko and Vasily.

As always, feedback and reviews are appreciated :-)

Julian Wiedmann (4):
  zfcp: lift Input Queue tasklet from qdio
  zfcp: clarify & assert the stat_lock locking in zfcp_qdio_send()
  zfcp: process Version Change events
  zfcp: handle event-lost notification for Version Change events

Vasily Gorbik (1):
  zfcp: remove orphaned function declarations

 drivers/s390/scsi/zfcp_aux.c  | 11 ++++++++
 drivers/s390/scsi/zfcp_def.h  |  1 +
 drivers/s390/scsi/zfcp_ext.h  |  2 --
 drivers/s390/scsi/zfcp_fsf.c  | 19 ++++++++++++++
 drivers/s390/scsi/zfcp_fsf.h  | 11 ++++++++
 drivers/s390/scsi/zfcp_qdio.c | 47 +++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_qdio.h |  2 ++
 7 files changed, 91 insertions(+), 2 deletions(-)

-- 
2.26.2

