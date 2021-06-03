Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDAEC47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E986613C9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFCMSe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:18:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229927AbhFCMSe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 08:18:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153CANON011022
        for <linux-scsi@vger.kernel.org>; Thu, 3 Jun 2021 05:16:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=XkB4PX5lIEoGqCLtr9Fq+1SziSIVe35o9eEkpc7U8Mg=;
 b=boETqiRrn2JgNvKIhhTDhNjV6j7pu2zpwzs7s7Cpq0mMDalyPmqAxNhfhe+PXzRDX4LA
 70rwzehU0HWcwgi0C2UCNFuCoaSGA8AIRWf4gOkpVxtW5lTi0YCq2KuKuFv3T9MGLBG4
 WonUAGfw2nfYXIfvFfvPqJvVpeFSYA+55XvbWBFuePPuvBrRZyyntnJaIM7Q3DQpRQTw
 x2Uuf+AxmjZWsDXUpBKxp2uKTBZAsSa9gvJ+g72G0I+dsj5HmxurVfYxftrqOHeTpPDm
 26Bo3Bm33HEnBrSvH6rwYs8iyb+x7Hg4nnXLUyOLf+hLbkrICRIIFch+sW0HAuH1PL5H Rg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38xe7xuhas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jun 2021 05:16:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 05:16:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 05:16:47 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E389C3F7044;
        Thu,  3 Jun 2021 05:16:47 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 153CGlPB010119;
        Thu, 3 Jun 2021 05:16:47 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 153CGlIe010118;
        Thu, 3 Jun 2021 05:16:47 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 0/5] scsi: FDMI enhancement
Date:   Thu, 3 Jun 2021 05:16:18 -0700
Message-ID: <20210603121623.10084-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: k61kx1N9rWLixy2BLcGboFCyNPMX2KkC
X-Proofpoint-GUID: k61kx1N9rWLixy2BLcGboFCyNPMX2KkC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_08:2021-06-02,2021-06-03 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series has FDMI enhancement code.
FDMI V2 attributes added for RHBA and RPA.
If registration get failed with FDMI V1 attributes,
than fall back to the registration with FDMI V2 attributes.

Kindly apply this series to scsi-queue at your earliest convenience.

Javed Hasan (5):
  libfc: initialisation of RHBA and RPA attributes
  qedf: Added vendor identifier attribute
  libfc: Added FDMI-2 attributes
  libfc: FDMI enhancement.
  fc: FDMI enhancement

 drivers/scsi/libfc/fc_encode.h   | 248 ++++++++++++++++++++++++++++++-
 drivers/scsi/libfc/fc_lport.c    |  88 ++++++++++-
 drivers/scsi/qedf/qedf_main.c    |   3 +
 include/scsi/fc/fc_ms.h          |  55 ++++++-
 include/scsi/scsi_transport_fc.h |  25 +++-
 5 files changed, 401 insertions(+), 18 deletions(-)

-- 
2.26.2

