Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D33C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B99E2073B
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="H6LIPN6M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgC0Ocw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 10:32:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65030 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726518AbgC0Ocw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 10:32:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02REUmgl003894
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2020 07:32:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=iNN+tbqz9Wh+7HUgSGo3vlBQYSZ5DnFrOrYElYw9Fr8=;
 b=H6LIPN6MmJ25AM0pDVtDL+YK2qVfzhgnAZc2MJlTMJRScCCj7Jij563xnx+cDFeEtdNH
 rdnd9wYEki1Sg+tDIyT7ij5E2DP687MFIk978FZYpGzvcOYEUbg4qW3sMkRRa7RZQV2C
 UmX6uH6jcwKaCzCCFc+6FikZNsaOzI8G8Za0wGhFwLqouP+T0yei5EVxbrF2TBoAC5jj
 oOa8iF3oP5MXJgJ0+mmZCh3eHVcGOryUPntqLj+87YTNYxUzjKeiEABwZOmjhxWf7Pop
 7W/MwTEw/fq8B+3yFEC4ysLR3KRY+DooR3VK2ND8PCjr3+fX5OyFLkT3MmrwV6mY581t 6g== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9p36c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2020 07:32:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 27 Mar
 2020 07:32:50 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 27 Mar
 2020 07:32:49 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 27 Mar 2020 07:32:49 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 56C9C3F703F;
        Fri, 27 Mar 2020 07:32:49 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02REWnIo027323;
        Fri, 27 Mar 2020 07:32:49 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02REWnpQ027322;
        Fri, 27 Mar 2020 07:32:49 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 0/3] qla2xxx: Updates for the driver
Date:   Fri, 27 Mar 2020 07:32:45 -0700
Message-ID: <20200327143248.27288-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_05:2020-03-27,2020-03-27 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your earliest
convenience.

Thanks,
Nilesh

Arun Easi (2):
  qla2xxx: Fix MPI failure AEN (8200) handling.
  qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV.

Quinn Tran (1):
  qla2xxx: delete all sessions before unregister local nvme port

 drivers/scsi/qla2xxx/qla_attr.c |  32 +++++++--
 drivers/scsi/qla2xxx/qla_def.h  |  13 +++-
 drivers/scsi/qla2xxx/qla_gbl.h  |   3 +
 drivers/scsi/qla2xxx/qla_init.c |   2 +
 drivers/scsi/qla2xxx/qla_isr.c  |  54 ++++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c  |   2 +-
 drivers/scsi/qla2xxx/qla_os.c   |   6 ++
 drivers/scsi/qla2xxx/qla_tmpl.c | 118 ++++++++++++++++++++++++++------
 8 files changed, 187 insertions(+), 43 deletions(-)

-- 
2.19.0.rc0

