Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5889AE7D0B6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjIUWyt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjIUWys (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:54:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6D7F7
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 15:54:42 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMmasM023458;
        Thu, 21 Sep 2023 22:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=RB7rw6nlQUUlWLdjf3n68TJHCNiDe97LdM3CZFQ8EDc=;
 b=X/NuH3iq3U8AQKj3Kqewtdr4hoRzrbyGhkV75mSK6YBoyNZtz8WUHjjY8JjSpKDnXNLb
 8nGMmlpyAz8EXWApKKKZs5OGJHQt8qgT/gTyqjpnMN6xzTwA6K+BvryE2x6m5ELsC9jc
 aSTvtZVjCvBCbDYsewsE6f9fMQWKt3VayMeP4JsdG28x7MCIFCKMlaybS/w4yh9jWStx
 YqFzDDJFzxQtyrmyXs2WKtaCrK/DgfRguNjWCNyCqio1Gkmhd6+bobYRh8m75mmSDEZq
 pbUN5mPlJvRwfSoaTn9kHa4e97SjlVJ4YQ0gSgxprBFsMiLM0JcQD9ftWkvW4hdk9FRx eQ== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t8x1018f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:38 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38LLqutl018872;
        Thu, 21 Sep 2023 22:54:38 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t8tsnm729-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Sep 2023 22:54:38 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38LMsbAB21693142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 22:54:37 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5039C58051;
        Thu, 21 Sep 2023 22:54:37 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18F425805F;
        Thu, 21 Sep 2023 22:54:37 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 21 Sep 2023 22:54:37 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 00/11] ibmvfc: fixes and generic prep work for NVMeoF support
Date:   Thu, 21 Sep 2023 17:54:24 -0500
Message-Id: <20230921225435.3537728-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5lVLDBwAx9sWk8D7cG86O_hZln4RGSCc
X-Proofpoint-GUID: 5lVLDBwAx9sWk8D7cG86O_hZln4RGSCc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_19,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=978
 mlxscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309210196
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series includes a couple minor fixes, generalization of some code that is
not protocol specific, and a reworking of the way event pool buffers are
accounted for by the driver. This is a precursor to a series to follow that
introduces support for NVMeoF protocol with ibmvfc.

v2 Changes:
* Fixed kernel test bot build warnings in patches 1 & 2

Tyrel Datwyler (11):
  ibmvfc: remove BUG_ON in the case of an empty event pool
  ibmvfc: implement channel queue depth and event buffer accounting
  ibmvfc: limit max hw queues by num_online_cpus()
  ibmvfc: fix erroneous use of rtas_busy_delay with hcall return code
  ibmvfc: use a bitfield for boolean flags
  ibmvfc: rename ibmvfc_scsi_channels to ibmvfc_channels
  ibmvfc: track max and desired queue size in ibmvfc_channels
  ibmvfc: make channel allocation generic
  ibmvfc: add protocol field to ibmvfc_channels
  ibmvfc: make discovery buffer per protocol channel group
  ibmvfc: add protocol field to target structure

 drivers/scsi/ibmvscsi/ibmvfc.c | 438 ++++++++++++++++++++++++---------
 drivers/scsi/ibmvscsi/ibmvfc.h |  50 ++--
 2 files changed, 353 insertions(+), 135 deletions(-)

-- 
2.31.1

