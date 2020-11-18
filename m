Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F226C56202
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2A692463B
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:12:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mzAQJtmL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgKRBLP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 20:11:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727834AbgKRBLO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 20:11:14 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI11bpF016626;
        Tue, 17 Nov 2020 20:11:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=qqtdFimCAjGS2THNY3F0NZ9EpxY5xgsEj5s0tuyKV9E=;
 b=mzAQJtmL+h/GoJx/BkDT/93z/ZKECUJ0k7ANKewBercuCZrhoqdv91UwjR6fcB3Q1cxw
 rEb8xCe2lVZH1nGnYiwW8heLYxlP1PITqCmqPfnXO4zhtNSsiaVZOe3+Y8kY30uEm07P
 9buE+KTIEnULEnr/F73IhVnjR/ZPG/oOte2+HP0lqPYTB3He4sQEzLrDqrjF4RKP+MFm
 46XbXhkbIgTyUkBnu9FuTmrOkglq0uVaZi0ICpmmMKR7GvBPTnK2oZWYeWkH5vvkVpAQ
 dxb58ub3ECD4ZRJ9YUztswjB8SQhozDBUikkUyViPgDPe6hTNdXtPDQSY344ouS1Y3pz JA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34v9pfxg2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 20:11:08 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AI12RdP021467;
        Wed, 18 Nov 2020 01:11:07 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 34t6v994dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 01:11:07 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AI1B5gl11272836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 01:11:05 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1C2CBE058;
        Wed, 18 Nov 2020 01:11:05 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 441B4BE04F;
        Wed, 18 Nov 2020 01:11:05 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 18 Nov 2020 01:11:05 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v3 0/6] ibmvfc: Protocol definition updates and new targetWWPN Support
Date:   Tue, 17 Nov 2020 19:10:58 -0600
Message-Id: <20201118011104.296999-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_15:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=775
 impostorscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Several Management Datagrams (MADs) have been reversioned to add a targetWWPN
field that is intended to better identify a target over in place of the scsi_id.
This patchset adds the new protocol definitions and implements support for using
the new targetWWPN field and exposing the capability to the VIOS. This
targetWWPN support is a prerequisuite for upcoming channelization/MQ support.

changes in v3:
* addressed field naming consistency in Patches 2 & 5 in response to [brking]
* fixed commit log typos
* fixed bad rebase of Patch 4 such that it now compiles

changes in v2:
* Removed bug fixes to separate patchset
* Fixed up checkpatch warnings

Tyrel Datwyler (6):
  ibmvfc: deduplicate common ibmvfc_cmd init code
  ibmvfc: add new fields for version 2 of several MADs
  ibmvfc: add helper for testing capability flags
  ibmvfc: add FC payload retrieval routines for versioned vfcFrames
  ibmvfc: add support for target_wwpn field in v2 MADs and vfcFrame
  ibmvfc: advertise client support for targetWWPN using v2 commands

 drivers/scsi/ibmvscsi/ibmvfc.c | 185 ++++++++++++++++++++++-----------
 drivers/scsi/ibmvscsi/ibmvfc.h |  28 ++++-
 2 files changed, 147 insertions(+), 66 deletions(-)

--
2.27.0

