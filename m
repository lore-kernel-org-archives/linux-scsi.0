Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2FCC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 09:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C374921D7A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 09:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SYro8GUz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgIHJ5b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 05:57:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16784 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728975AbgIHJ5a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 05:57:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0889pkPQ008557;
        Tue, 8 Sep 2020 02:57:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=ebMQI6itMtnMQYPGMDzKDCVOe6lTc/P7XXKQJmlNmV8=;
 b=SYro8GUzIU0/4N1HbJ0FEtcEWyuAA/MJqFL4dJ5g2uheWPGyRbGIWIDX2sKNR7Y0Pmrf
 BAVbxvSTgKXHYU1O5DMOe5OQ+GNYJ3vEvj7GUqjLWbX73eJxoEeYZh8LsnGXL5Vh4r/s
 5yE4ZUSGcM1vPWEAX8prNI0zgBwK0pZpPR/Oy2BCFZsOlKxrJU2NzUBmmV/s9xZ3IEia
 uoyytkaxKTDSX/l3shsCIFxycAarpU3EAQ7mDpwk1wZHJj51nWQmxGy9RqT3+/zbsowb
 75TL2wzgwxZHaH7BzbiLF/yhA6hXceCLhxm73CgxxxCAsK/oqowTZfGDAxDu/3BxzpdI yQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvr1tra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 02:57:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Sep
 2020 02:57:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Sep
 2020 02:57:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Sep 2020 02:57:21 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DB62E3F703F;
        Tue,  8 Sep 2020 02:57:21 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0889vLK3026864;
        Tue, 8 Sep 2020 02:57:21 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0889vLXB026855;
        Tue, 8 Sep 2020 02:57:21 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 0/8] qedi: Misc bug fixes and enhancements
Date:   Tue, 8 Sep 2020 02:56:49 -0700
Message-ID: <20200908095657.26821-1-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_05:2020-09-08,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please apply the qedi miscellaneous bug fixes and enhancement patches
to the scsi tree at your convenience.

v1->v2:
Fix warning reported by kernel test robot

Thanks,
Manish

Manish Rangankar (5):
  qedi: Use qed count from set_fp_int in msix allocation.
  qedi: Skip f/w connection termination for pci shutdown handler.
  qedi: Use snprintf instead of sprintf
  qedi: Add firmware error recovery invocation support.
  qedi: Add support for handling the pcie errors.

Nilesh Javali (3):
  qedi: Fix list_del corruption while removing active IO
  qedi: Protect active command list to avoid list corruption
  qedi: Mark all connections for recovery on link down event

 drivers/scsi/qedi/qedi.h       |   5 ++
 drivers/scsi/qedi/qedi_fw.c    |  30 +++++++--
 drivers/scsi/qedi/qedi_iscsi.c |   7 +++
 drivers/scsi/qedi/qedi_main.c  | 108 +++++++++++++++++++++++++++++++--
 4 files changed, 140 insertions(+), 10 deletions(-)

-- 
2.25.0

