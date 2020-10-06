Return-Path: <SRS0=xWhZ=DN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC29EC41604
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 06:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C5A820796
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 06:16:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Go75bWFO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgJFGQo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 02:16:44 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61164 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgJFGQo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 02:16:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09665HZk003157
        for <linux-scsi@vger.kernel.org>; Mon, 5 Oct 2020 23:16:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=pPbRH8ccoldn8vEMM7QqtHt8WrF3bZN6oj574LEK3l0=;
 b=Go75bWFOWGNlo13cSzLZR9y2QML4U7ShaHKFDEd/tod3QhPj//GFisGkoPOeR7y45myA
 6pqJchjrPRTIRtvNEptaIEdydSEvyeXgT+7TS6fG6IHvGdAE5ROpKfMW5dRWeXwdGslD
 OwafB5ICe6ZQ9T53ygXTBmcSMnmdDEVDmXk1DLoW0kGovfM51iZ3qBiTp9C0Vu76vOLf
 gYFCVl7YbqiutFY1fg+hpQXrd7ae26xwhdJ/K/F0+SJ1xPVMv+go57tUhM1Ex1e+/Ygw
 wEkAlS3Nxg4aKgfRkjghGQNMsG7WeJDrjgKu4SnxyD/9vFbuvql47YouWMxsyIYmeNuG TQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33xrtnfcnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2020 23:16:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 23:16:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 23:16:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 5 Oct 2020 23:16:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 073D03F703F;
        Mon,  5 Oct 2020 23:16:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0966Gdqf028717;
        Mon, 5 Oct 2020 23:16:39 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0966Gd4o028708;
        Mon, 5 Oct 2020 23:16:39 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 0/5] SAN Congestion Management (SCM) statistics
Date:   Mon, 5 Oct 2020 23:16:10 -0700
Message-ID: <20201006061615.28674-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-06_02:2020-10-06,2020-10-06 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the attached patchset implementing the SAN Congestion
Management (SCM) statistics to the scsi tree at your earliest
convenience.

v1->v2:
Further break down patches based on functionality.
Remove dependency on LLDs for remote port FPIN statistics.
Optimize fc_find_rport_by_wwpn implementation.
Name changes to multiple variables/structure elements based on review comments.

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
 drivers/scsi/scsi_transport_fc.c              | 444 ++++++++++++++++++
 include/scsi/scsi_transport_fc.h              |  36 ++
 include/uapi/scsi/fc/fc_els.h                 | 114 ++++-
 5 files changed, 639 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_host
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_remote_ports


base-commit: 718c2fe92b208415fa76550975dc5d7708448f7c
-- 
2.19.0.rc0

