Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C6CC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 10:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ECF0206FA
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 10:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="u50cYFah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgFVKMi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 06:12:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40112 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726515AbgFVKMh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jun 2020 06:12:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MAAVnq021718
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2020 03:12:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=DKx3rMedAEE8865edtvvLEWgB/ifUlg0YXhKt5RAvkg=;
 b=u50cYFah+203vpJjf+lw+5ernziqz3l6B5h9D/K+3TkOz7kgRWSn9y5zAlV+Ji4k1SGj
 YCaI9bbWMVRgd4yrHKfS1VwDAz4j34PL4UqPszZmsNECLEdnkmlUDagMvIMeb33K9BH9
 D2fx1sqBAA59AQfO+IxouWTaFmclN3YKdiWKD0MuFP8lOEENAJfYzWFX90BqYJjg4ppY
 hOSHDo8oRR8edorcJ+nLVwbHoncGoFzWf6IaXi/3YF5ugk+i7SkT897EfJNuoioC32O9
 IWEmiVWCUy0IMgB/xV4UBa3Qne8abiQjqrtBV5KFcDbIYjg5+rlswo/YALsAWTxmvsRC tQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31sftpfy62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2020 03:12:37 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 03:12:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 03:12:36 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6D5AA3F7040;
        Mon, 22 Jun 2020 03:12:36 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 05MACaXj003965;
        Mon, 22 Jun 2020 03:12:36 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 05MACaAk003956;
        Mon, 22 Jun 2020 03:12:36 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 0/2] libfc: Handling of extra kref.
Date:   Mon, 22 Jun 2020 03:12:10 -0700
Message-ID: <20200622101212.3922-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_03:2020-06-22,2020-06-22 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kindly apply this series to scsi tree at your earliest convenience.

Thanks,
Javed

Javed Hasan (2):
  scsi: libfc: Handling of extra kref.
  scsi: libfc: Skip additional kref updating work event.

 drivers/scsi/libfc/fc_rport.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
1.8.3.1

