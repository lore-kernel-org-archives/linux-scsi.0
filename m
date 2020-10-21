Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4045CC4363A
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 09:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B655521D6C
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 09:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bwb/tqF6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395558AbgJUJ1l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 05:27:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29614 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2395379AbgJUJ1k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Oct 2020 05:27:40 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09L9Omx4006710
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 02:27:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=omub+oHb7p3fZngRFv+6oG24zqHuKc4n/UhuBHuAgWU=;
 b=bwb/tqF6aZ7TbmrxfEu24IUyTNXct9ZNrVk9Elfz4SbagJNb5fXSo6cdUTTjrowPZoSV
 r46BTLtNG22BM1O/Ik/QxdQxzhzb6bmzuvv6QvUmesgB7rMsh8IdvJpWLZQTeLJFINcD
 hiWDNIGOziA1FKCuh9qD9NdflHRXhuwDiAxBr/B5gr5qYA/LHXVxhOZ5SBemVmdCKCCF
 5MCz2E4balMampXatgPQbAfvr96hDieaYq6oXlGnjp5F2U/mSN6fVZULuFoTz1X+SqL6
 tCN2PkONrtefleYvEVsGJd7+arAn+GqEqpabNp82muLTAmmUtduSwUpg5mhX7wdZTwNJ 8g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 347wyqcm5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 02:27:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Oct
 2020 02:27:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Oct 2020 02:27:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 70CE53F703F;
        Wed, 21 Oct 2020 02:27:39 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 09L9Rdkh022704;
        Wed, 21 Oct 2020 02:27:39 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 09L9RdLV022703;
        Wed, 21 Oct 2020 02:27:39 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 0/5] SAN Congestion Management (SCM) statistics
Date:   Wed, 21 Oct 2020 02:27:10 -0700
Message-ID: <20201021092715.22669-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_03:2020-10-20,2020-10-21 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the attached patchset implementing the SAN Congestion
Management (SCM) statistics to the scsi tree at your earliest
convenience.

v2->v3:
Incorporate review comments for patch v2 3/5.
Added Reviewed-by tag for other patches.

v1->v2:
Further break down patches based on functionality.
Remove dependency on LLDs for remote port FPIN statistics.
Optimize fc_find_rport_by_wwpn implementation.
Name changes to multiple variables/structure elements based on review
comments.

Thanks,
Nilesh

Shyam Sundar (5):
  scsi: fc: Update formal FPIN descriptor definitions
  scsi: fc: Add FPIN statistics to fc_host and fc_rport objects
  scsi: fc: Parse FPIN packets and update statistics
  scsi: fc: Add mechanism to update FPIN signal statistics
  scsi: fc: Update documentation of sysfs nodes for FPIN stats

 Documentation/ABI/testing/sysfs-class-fc_host |  23 +
 .../ABI/testing/sysfs-class-fc_remote_ports   |  23 +
 drivers/scsi/scsi_transport_fc.c              | 415 ++++++++++++++++++
 include/scsi/scsi_transport_fc.h              |  36 ++
 include/uapi/scsi/fc/fc_els.h                 | 114 ++++-
 5 files changed, 610 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_host
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_remote_ports


base-commit: 1ef16a407f544408d3559e4de2ed05591df4da75
-- 
2.19.0.rc0

