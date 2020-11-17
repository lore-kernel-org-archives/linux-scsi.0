Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501BAC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 19:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF9E020855
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 19:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i9kLbdKF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgKQTQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 14:16:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728018AbgKQTQt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 14:16:49 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHJ2QWM099825;
        Tue, 17 Nov 2020 14:16:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mzfxdXONFyP+nJ5WN6LW0aUav7QlWg3P/f3RdTXK1ro=;
 b=i9kLbdKFvR7tnxUsGo273bA3drLv04yrihNrxx5tejV7MewwD8WPgQKWS6baLPRiR0Iy
 8qKOU28xrOY46Bzvse6Q6r4VbpnFhtNg6FzUIh0O29uSG2gKVFbOrl4ZnG62R+6ynhO6
 DFeIdJLodY0VxVQVZ0QMObZTVhqGxA1J6ip0UdJTnbMMinVoY9/+pKILLqMNZJ3sc2AD
 BS7QTgFV5y3IJdqPrhQFKHTeUguxiIN8Rzg87qR/2T5sUmfFLOBUoMlwkIxH+fCW9H/w
 Zcpl+SMKYhLwf8HWLjbqFcpXsjU/Y7/vdXAhuZPMJAiF8auwiL0uqpQgT5hE8BWRKvRo 8w== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34v3yfjuj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 14:16:41 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHJ7f6n012700;
        Tue, 17 Nov 2020 19:16:40 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 34t6v9evv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 19:16:40 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHJGU2339125252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 19:16:30 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE9B3C6055;
        Tue, 17 Nov 2020 19:16:38 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FC18C6059;
        Tue, 17 Nov 2020 19:16:38 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 19:16:38 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 0/6] ibmvfc: Protocol definition updates and new targetWWPN Support
Date:   Tue, 17 Nov 2020 13:16:30 -0600
Message-Id: <20201117191636.131127-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_07:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=629
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Several Management Datagrams (MADs) have been reversioned to add a targetWWPN
field that is intended to better identify a target over a scsi_id. Further, a
couple new MADs have been introduced to the protocol to be used for negotiation
of channels/hw queues resources when the VIOS is using SLI-4 capable adapters.

This patchset adds the new protocol definitions and implements support for using
the new targetWWPN field and exposing the capability to the VIOS. This
targetWWPN support is a prerequisuite for upcoming channelization/MQ support.

changes in v2:
	Removed bug fixes to separate patchset
	Fixed up checkpatch warnings

Tyrel Datwyler (6):
  ibmvfc: deduplicate common ibmvfc_cmd init code
  ibmvfc: add new fields for version 2 of several MADs
  ibmvfc: add helper for testing capability flags
  ibmvfc: add FC payload retrieval routines for versioned vfcFrames
  ibmvfc: add support for targetWWPN field in v2 MADs and vfcFrame
  ibmvfc: advertise client support for targetWWPN using v2 commands

 drivers/scsi/ibmvscsi/ibmvfc.c | 183 ++++++++++++++++++++++-----------
 drivers/scsi/ibmvscsi/ibmvfc.h |  28 ++++-
 2 files changed, 145 insertions(+), 66 deletions(-)

-- 
2.27.0

