Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68419C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D8302177B
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="UnT0fsVn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgHGLNm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 07:13:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61812 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726073AbgHGLHX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 07:07:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077ApcZ2021192
        for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2020 04:07:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=5azXv7jRCoKYSmXWDjvSu7Gt0T12qiDAMBp3qw8Gjww=;
 b=UnT0fsVnkZIN+aT6cCEYMo8hPvzem6rlo5yJw5E6+7O/ReMJECMv9FctVFlq8ZzcwG/w
 vYWn6lJ4LFG4mL7dQwAfvW6EVp5vutHxjYzwBzkfAhriQJSR1VV3PxorUzS7XTfyqTMv
 5q2YF12+QVlLtCmHtvjF9IKMhu0wbO12VebhjLeEtEtILRdwHgG8YpM33wtBSw3MmBAJ
 FeD52nKq/K77vFzsr95WcFXCinHbfaiWAt2qSYKd9NCCX8TuE+d6ToBs30DTBcy4AK8V
 9vnjJUZB9GDdST/Kw6AaoSn1oRtPGGNAmwKzziQrAA9I83x0QKc4njzcDUUhOSe6rvzj Hg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32n6ch1ew6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2020 04:07:21 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 Aug
 2020 04:07:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 7 Aug 2020 04:07:21 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A32603F703F;
        Fri,  7 Aug 2020 04:07:20 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 077B7Kk2020000;
        Fri, 7 Aug 2020 04:07:20 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 077B7Kun019999;
        Fri, 7 Aug 2020 04:07:20 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 0/7] qedf: Misc fixes for the driver.
Date:   Fri, 7 Aug 2020 04:06:49 -0700
Message-ID: <20200807110656.19965-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_06:2020-08-06,2020-08-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series has misc bug fixes and code enhancements.

Kindly apply this series to scsi-queue at your earliest convenience.

Thanks,
~Javed

Saurav Kashyap (7):
  qedf: Check for port type and role before processing an event.
  qedf: check the validity of rjt frame before processing.
  qedf: Do not kill timeout work for original IO on RRQ completion.
  qedf: Send cleanup even for RRQ on timeout.
  qedf: Initiate cleanup for ELS commands as well.
  qedf: Don't process ELS completion if its flushed or cleaned up.
  qedf: Fix race between els completion and flushing els request.

 drivers/scsi/qedf/qedf_els.c  | 32 ++++++++++++++++++++++++++++----
 drivers/scsi/qedf/qedf_io.c   | 11 ++++++++++-
 drivers/scsi/qedf/qedf_main.c | 11 +++++++++++
 3 files changed, 49 insertions(+), 5 deletions(-)

-- 
1.8.3.1

