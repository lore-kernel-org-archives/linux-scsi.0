Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69DFC3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B64B420850
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cEXejb6e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388060AbfHWJwr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:52:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28408 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732878AbfHWJwr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:52:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nhVq002712
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:52:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=Wk+k8EloB2LxRGIh7AYvYaDTvNONiy6wh2pBWZeoDVQ=;
 b=cEXejb6epWy9vxu7tqh1qKvNGfg93l4oCh7ntT83vtyeQuOWFH+FhsDcdzx1dEIFiMIs
 yXiGvJTadt2ZPn+ZhrSKq8xTfgPt51a6p8+mxP1noIa9tkGo4g68eEh5jwG9MrwNFW0r
 tgVPLfd9ns0FK7ebdpSvB66zZh1LaPP7Zvst0hl26zlDgpYv5blrtHKqD3RwJc2ApCIv
 aE83mFOvSx81fmQvsnbRcSAm6hAK2djF3y6uFWMxXiIukVPeydRJiWtvfXvUq6jdaODh
 n0QX2wqGpAJoVh6PNjTp1OVksRaM6nwlTV61gdctj5lQowHBNSfwaOI+WLSoWpS57uyP xg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uhad4072c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:52:45 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:52:44 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:52:44 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 908223F703F;
        Fri, 23 Aug 2019 02:52:44 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9qimq007865;
        Fri, 23 Aug 2019 02:52:44 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9qiiF007864;
        Fri, 23 Aug 2019 02:52:44 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 00/14] qedf: Miscellaneous fixes.
Date:   Fri, 23 Aug 2019 02:52:30 -0700
Message-ID: <20190823095244.7830-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This series have bug fixes and improve the log messages for better debugging.

Kindly apply this series to scsi-queue at your earliest convenience.

Thanks,
~Saurav 


Arun Easi (1):
  qedf: Fix crash during sg_reset.

Hannes Reinecke (1):
  qedf: Use discovery list to traverse rports

Nilesh Javali (1):
  qedf: Update module description string.

Saurav Kashyap (11):
  qedf: Print message during bailout conditions.
  qedf: Stop sending fipvlan request on unload.
  qedf: Add shutdown callback handler.
  qedf: Interpret supported caps value correctly.
  qedf: Add support for 20 Gbps speed.
  qedf: Add debug information for unsolicited processing.
  qedf: Initiator fails to re-login to switch after link down.
  qedf: Check for module unloading bit before processing link update
    AEN.
  qedf: Decrease the LL2 MTU size to 2500.
  qedf: Fix race betwen fipvlan request and response path.
  qedf: Update the version to 8.42.3.0.

 drivers/scsi/qedf/qedf.h         |   1 +
 drivers/scsi/qedf/qedf_debugfs.c |  16 ++--
 drivers/scsi/qedf/qedf_els.c     |  38 +++++++--
 drivers/scsi/qedf/qedf_fip.c     |  33 +++++---
 drivers/scsi/qedf/qedf_io.c      |  66 ++++++++++++---
 drivers/scsi/qedf/qedf_main.c    | 178 +++++++++++++++++++++++++--------------
 drivers/scsi/qedf/qedf_version.h |   8 +-
 7 files changed, 232 insertions(+), 108 deletions(-)

-- 
1.8.3.1

