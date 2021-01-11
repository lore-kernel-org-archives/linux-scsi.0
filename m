Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3588C43333
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD93A22CF7
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405531AbhALAZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403850AbhAKXNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 18:13:20 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BN3ZpQ114052;
        Mon, 11 Jan 2021 18:12:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vXRmV53+iMI/kUv8GPmGXRolEiOWwD9WIfb7eRbSsMc=;
 b=kMwbwFepZK83/ZgmxhyqCYGsPRkzX8s0j4EAtBHzU2XhVmc6hNwQS82qmxHd6X/zWsax
 LzR/Ze32oJ874CbxqldEdxgi3U8X70qr/7KVDdw1eO33cpoxNNLOu/Bbm0v4dVNSd/YP
 ZyFzz9UB5RMXith8Mn+ufA7OWQACro+92Ezh5j5uDnOiK0kicMwVcu1lfpeSc3hoY0o8
 MpGqSMVXj0w3ZR2axrqSXN6KQC3c/BjJB1gLW++8Y7yYt341PFwVr4EhCacXyGYLGKwJ
 Rr1rP8TsQuxZCDOUvkkVPOvplmM3cqDSM/xeSK5Zysz0VONa5gNLlvaPfIqzhHl+V4DD UQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360y9ksbtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 18:12:30 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BN77ee004792;
        Mon, 11 Jan 2021 23:12:29 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 35y448syq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 23:12:29 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BNCRQ124707338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 23:12:27 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C89F878064;
        Mon, 11 Jan 2021 23:12:27 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65CFC78066;
        Mon, 11 Jan 2021 23:12:27 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 23:12:27 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v4 00/21] ibmvfc: initial MQ development
Date:   Mon, 11 Jan 2021 17:12:04 -0600
Message-Id: <20210111231225.105347-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Recent updates in pHyp Firmware and VIOS releases provide new infrastructure
towards enabling Subordinate Command Response Queues (Sub-CRQs) such that each
Sub-CRQ is a channel backed by an actual hardware queue in the FC stack on the
partner VIOS. Sub-CRQs are registered with the firmware via hypercalls and then
negotiated with the VIOS via new Management Datagrams (MADs) for channel setup.

This initial implementation adds the necessary Sub-CRQ framework and implements
the new MADs for negotiating and assigning a set of Sub-CRQs to associated VIOS
HW backed channels.

This latest series is completely rebased and reimplemented on top of the recent
("ibmvfc: MQ prepartory locking work") series. [1]

[1] https://lore.kernel.org/linux-scsi/20210106201835.1053593-1-tyreld@linux.ibm.com/

changes in v4:
* Series rebased and reworked on top of previous ibmvfc locking series
* Dropped all previous Reviewed-by tags

changes in v3:
* Patch 4: changed firmware support logging to dev_warn_once
* Patch 6: adjusted locking
* Patch 15: dropped logging verbosity, moved cancel event tracking into subqueue
* Patch 17: removed write permission for migration module parameters
	    drive hard reset after update to num of scsi channels

changes in v2:
* Patch 4: NULL'd scsi_scrq reference after deallocation
* Patch 6: Added switch case to handle XPORT event
* Patch 9: fixed ibmvfc_event leak and double free
* added support for cancel command with MQ
* added parameter toggles for MQ settings

Tyrel Datwyler (21):
  ibmvfc: add vhost fields and defaults for MQ enablement
  ibmvfc: move event pool init/free routines
  ibmvfc: init/free event pool during queue allocation/free
  ibmvfc: add size parameter to ibmvfc_init_event_pool
  ibmvfc: define hcall wrapper for registering a Sub-CRQ
  ibmvfc: add Subordinate CRQ definitions
  ibmvfc: add alloc/dealloc routines for SCSI Sub-CRQ Channels
  ibmvfc: add Sub-CRQ IRQ enable/disable routine
  ibmvfc: add handlers to drain and complete Sub-CRQ responses
  ibmvfc: define Sub-CRQ interrupt handler routine
  ibmvfc: map/request irq and register Sub-CRQ interrupt handler
  ibmvfc: implement channel enquiry and setup commands
  ibmvfc: advertise client support for using hardware channels
  ibmvfc: set and track hw queue in ibmvfc_event struct
  ibmvfc: send commands down HW Sub-CRQ when channelized
  ibmvfc: register Sub-CRQ handles with VIOS during channel setup
  ibmvfc: add cancel mad initialization helper
  ibmvfc: send Cancel MAD down each hw scsi channel
  ibmvfc: purge scsi channels after transport loss/reset
  ibmvfc: enable MQ and set reasonable defaults
  ibmvfc: provide modules parameters for MQ settings

 drivers/scsi/ibmvscsi/ibmvfc.c | 914 ++++++++++++++++++++++++++++-----
 drivers/scsi/ibmvscsi/ibmvfc.h |  38 ++
 2 files changed, 824 insertions(+), 128 deletions(-)

-- 
2.27.0

