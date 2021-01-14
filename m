Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2CDC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF77D23A5E
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbhANUcl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:32:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726007AbhANUck (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 15:32:40 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EK3eFO188422;
        Thu, 14 Jan 2021 15:31:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=yb88OLKBP+AJmj0kV5KKr5DZmvyl7S3yGW+RSF3VqMs=;
 b=WkQFYndShidZxsWtvQCcXJaU4jXDI2k5PGVVmpV3b2R0LY7NvdPdJP4jjRtE4GqXt4eg
 nRmxb4fIydVE8W0iYLgh9TkQBwbnRef2APTqs4APIRrEGXRLS1A2+LXwoUWiM3qDS7gN
 7iVF7eAAS9jMX60zqfxIqoxyFWhqhTDrqLnadqPHRnKS0qOG49d7XJVLCGM/BG1NIN7e
 9sQ/Mq2fdWKirHEObLbGU904u4YLy2jjL8+GcuLbMh6kZUWohqACGqQR5EavLwMTbixH
 YYaINoDTb0ZZf/5QjEOTYJtZk99buWtfNPew5+xa0HGfflX23c4owfoUecHSovn5lKB9 3w== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362vfkgy2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 15:31:52 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EKSBnb015074;
        Thu, 14 Jan 2021 20:31:52 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 35y44a1q2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:31:52 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EKVoN924248648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 20:31:50 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55E486E058;
        Thu, 14 Jan 2021 20:31:50 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09C6D6E04C;
        Thu, 14 Jan 2021 20:31:49 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 20:31:49 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v5 00/21] ibmvfc: initial MQ development/enablement
Date:   Thu, 14 Jan 2021 14:31:27 -0600
Message-Id: <20210114203148.246656-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_07:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101140115
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

changes in v5:
* Addressed comments from brking in following patches:
* Patch 18: Drop queue lock in loop after sending cancel event
	    Remove cancel event from list after completion
	    Return -EIO on unknown failure
* Patch 21: Removed can_queue rebase artifact and range check user supplied
            nr_scsi_hw_queue value

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

 drivers/scsi/ibmvscsi/ibmvfc.c | 917 ++++++++++++++++++++++++++++-----
 drivers/scsi/ibmvscsi/ibmvfc.h |  39 ++
 2 files changed, 828 insertions(+), 128 deletions(-)

-- 
2.27.0

