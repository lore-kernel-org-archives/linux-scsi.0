Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FF8C83038
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB11B22201
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 02:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbgLCCJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 21:09:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727835AbgLCCJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 21:09:00 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B326WgZ065377;
        Wed, 2 Dec 2020 21:08:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=byTD4NKmU+qfCqX3DcTp3BJ5vLnURAwlR4Q01sTDRLI=;
 b=GAufvn4ODxhCDr31bhpA7pHo6OIQTOySKP1kHvcYIfMYM4UX2HWMoCMCrQudvzTdDo+M
 H+CcztkOHQZEOgfe13JnVeRGl4HTown53G1lLzbQ926aQ/c26t1I3OUyxk3B/1pTsKPD
 jrY9e/obFMEXhoZ1iQ9ocmSQzm3MTRfPwChvJ7e+KwUM2vH8JgaXmoGuyI0OAZlvo6Ci
 0Ai7LT7Efpes6Iepr+bypHjXjc1vxn09yuUtGkNrRsQ/PEDj5olpM3jCm4qvN1fF2P6z
 ghLPVajJmS2M54wOzv03w7nQy9z9HwGRtQ9xbtf9mAHZ1N3OHCS5NfyES+AoYuZx4d9P bw== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 356jg86ufu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 21:08:11 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B31uL3P013325;
        Thu, 3 Dec 2020 02:08:10 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 355vrfvc75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 02:08:10 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B32821Q36110948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 02:08:02 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D39C78063;
        Thu,  3 Dec 2020 02:08:09 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D13E078060;
        Thu,  3 Dec 2020 02:08:08 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Dec 2020 02:08:08 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v3 00/18] ibmvfc: initial MQ development
Date:   Wed,  2 Dec 2020 20:07:48 -0600
Message-Id: <20201203020806.14747-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_14:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030009
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
HW backed channels. The event pool and locking still leverages the legacy single
queue implementation, and as such lock contention is problematic when increasing
the number of queues. However, this initial work demonstrates a 1.2x factor
increase in IOPs when configured with two HW queues despite lock contention.

changes in v2:
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

Tyrel Datwyler (18):
  ibmvfc: add vhost fields and defaults for MQ enablement
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
  ibmvfc: enable MQ and set reasonable defaults
  ibmvfc: provide modules parameters for MQ settings
  ibmvfc: drop host lock when completing commands in CRQ

 drivers/scsi/ibmvscsi/ibmvfc.c | 721 +++++++++++++++++++++++++++++----
 drivers/scsi/ibmvscsi/ibmvfc.h |  79 +++-
 2 files changed, 711 insertions(+), 89 deletions(-)

-- 
2.27.0

