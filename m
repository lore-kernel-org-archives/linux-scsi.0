Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A400C4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 08:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1768320724
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 08:38:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="iSq9LPsJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgCSIiS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 04:38:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725601AbgCSIiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Mar 2020 04:38:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02J8V4bT008482;
        Thu, 19 Mar 2020 01:38:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=1Z6Ia0UzAKdYBJT6Yh8nDKDd6H2LXGeO33yf+RmJ8FQ=;
 b=iSq9LPsJxMy3lkt05euiV5ohlR/D19SEwSdEwMu4/NqPyuz2CHUfs28GPq+IvtFxcfgS
 IXKICEo2yHJAsgQtRGth/wlFVA0sJ8esUvQr8DCnAGu+gHGOuF1nXfiL2IRxA4e8Reh9
 hz2ol1DsrvJMS1vwgRuyLWjk9Vow5fI+Yvp99B4b3elErKgGm0+4sHqdRIUc/z7uw7nz
 1E4SHn6he1xE4ojnq08mKpsESfh0b3METxWvq6IGxEUwIbRlR+DNBENCOELG+hH/m1Bx
 EhzFlXgtjf8dR5CwKwnIpMdb2mvRAO3Kfzoupx3WQ2j/K9+fw8kWzmkhakptruhUQURg xg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2yu8pqpxyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 01:38:13 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Mar
 2020 01:38:12 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 19 Mar 2020 01:38:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0F6853F7040;
        Thu, 19 Mar 2020 01:38:12 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02J8cBjo019534;
        Thu, 19 Mar 2020 01:38:11 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02J8cBfA019533;
        Thu, 19 Mar 2020 01:38:11 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 0/2] Add MFW recovery and PCI Shutdown handler.
Date:   Thu, 19 Mar 2020 01:38:09 -0700
Message-ID: <20200319083811.19499-1-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_01:2020-03-18,2020-03-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please apply the following patches to the scsi tree at your
earliest convenience.

Manish Rangankar (2):
  qedi: Add MFW error recovery process.
  qedi: Add PCI shutdown handler support.

 drivers/scsi/qedi/qedi.h       |   3 ++
 drivers/scsi/qedi/qedi_gbl.h   |   1 +
 drivers/scsi/qedi/qedi_iscsi.c |  18 +++++++
 drivers/scsi/qedi/qedi_iscsi.h |   1 +
 drivers/scsi/qedi/qedi_main.c  | 104 ++++++++++++++++++++++++++++++++---------
 5 files changed, 104 insertions(+), 23 deletions(-)

-- 
1.8.3.1

