Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03554C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 06:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC7F920656
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 06:11:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="odvx/sXg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgG3GLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 02:11:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37616 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726261AbgG3GLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Jul 2020 02:11:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06U66C5b002028
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 23:11:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=TPlRPrA8zS8yFpS46VW0DVx4lJSx+HTskeuQDXFcak4=;
 b=odvx/sXgt8j6lvdL/Sk/JMKWPX48QQ31gsS+49PtlFCbGWsXoPZ71VEpDXQxDKDq/ASp
 DFtVGyH68thNva7BpYFs22qzoaCzgScc0oIRD03GwqcWZgRFUZ99RcxhsXN5n2ipQHrs
 ZfKJuQGn6P7BPdepz7NS8AZDDa+5tkHWM9EH6EJweB8qc5cwbSQ+PIBKDbb/IMXhxdBK
 jEnHivid9dJgFMPtjB1OeyTTlsjV6FH/ugTaVDbcgWV8mQXA4QPZXKjhoT4ytlqlpofb
 YWnwdWFOySv7cDE72S6ADNiUWIaaX6TEw5SN5yBhIkp/0Kz2ACTtwMjehvw/qLOw8RfB ZA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3r4k85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 23:11:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 23:11:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 23:11:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 23:11:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8DB423F703F;
        Wed, 29 Jul 2020 23:11:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 06U6BeqU020154;
        Wed, 29 Jul 2020 23:11:40 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 06U6BeEJ020145;
        Wed, 29 Jul 2020 23:11:40 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 0/2] SAN Congestion Management (SCM) statistics
Date:   Wed, 29 Jul 2020 23:11:14 -0700
Message-ID: <20200730061116.20111-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_04:2020-07-29,2020-07-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the attached patchset implementing the SAN Congestion
Management (SCM) statistics to the scsi tree at your earliest convenience.

Thanks,
Nilesh

Shyam Sundar (2):
  scsi: fc: Update statistics for host and rport on FPIN reception.
  scsi: fc: Update documentation of sysfs nodes for FPIN stats

 Documentation/ABI/testing/sysfs-class-fc_host |  23 +
 .../ABI/testing/sysfs-class-fc_remote_ports   |  23 +
 drivers/scsi/lpfc/lpfc_attr.c                 |   2 +
 drivers/scsi/qla2xxx/qla_attr.c               |   2 +
 drivers/scsi/scsi_transport_fc.c              | 411 +++++++++++++++++-
 include/scsi/scsi_transport_fc.h              |  34 +-
 include/uapi/scsi/fc/fc_els.h                 | 114 +++++
 7 files changed, 606 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_host
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_remote_ports


base-commit: 3c330f187ea84b13a0c66311115c8fd449dd25a1
-- 
2.19.0.rc0

