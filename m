Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1C3EE0212
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 00:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjINAbY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 20:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjINAbX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 20:31:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8311724
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 17:31:19 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38E0OI4K014684;
        Thu, 14 Sep 2023 00:31:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=sqWXgA2sw9dWgqPK4DtRjgXCLviqUV7vV6S4xAvEVYQ=;
 b=EGrr9kEf8bb7CaZc1X9j2cwK+Mf39m8V8zB0MYOPIsUGW5Ku5vM8sD8quwK/hntbSAyt
 syVb8nDrB8GWNBfjdT0ikb+sPxazuVvMe0NJKvKmcVeRDifElgmsq7ESzkJKYp0JO6Db
 RNIGStQtNcQyGFLML+GdS6CpdB1yTb4fP7wsLuWCLrrX5tZeEosIMaVirlR66NV2Za8s
 Myi2aWRaMzHhMwK4ukAxN2WphJiZhDK7miwsBaHNVyKf6RqrtW/uVRasnii9cJOt3Y3D
 akLz+pa5c5Uwo+rTFEqhi9uj8SNemT06Z1Z3wnxh8fT6rNQZMGepdx9qv8mGEbQ4oalC bw== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3qkur48e-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Sep 2023 00:31:17 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DKQICH023099;
        Wed, 13 Sep 2023 23:05:00 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t141nxm0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:05:00 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DN4xPC2753056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 23:04:59 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9069558053;
        Wed, 13 Sep 2023 23:04:59 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23C3258043;
        Wed, 13 Sep 2023 23:04:59 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 23:04:59 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 00/11] ibmvfc: fixes and generic prep work for NVMeoF support
Date:   Wed, 13 Sep 2023 18:04:46 -0500
Message-Id: <20230913230457.2575849-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pZeUOzNKpKUsCSezXqz1jGUdHWdK3tHQ
X-Proofpoint-GUID: pZeUOzNKpKUsCSezXqz1jGUdHWdK3tHQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=878 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140003
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series includes a couple minor fixes, generalization of some code that is
not protocol specific, and a reworking of the way event pool buffers are
accounted for by the driver. This is a precursor to a series to follow that
introduces support for NVMeoF protocol with ibmvfc.

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

