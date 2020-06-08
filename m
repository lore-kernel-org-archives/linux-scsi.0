Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6383C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 18:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B212063A
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 18:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="sAUDCGBT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgFHSq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 14:46:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63410 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725280AbgFHSq6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 14:46:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058IdX4d008458
        for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2020 11:46:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=fVX/JUOJg9XfJzniPC2RIKiISBvqQzpqItXBVkHlmOA=;
 b=sAUDCGBTwjEwaWe5ybM/KeZ0yMKKO3COHrzqoF5HdQ0T7ynVvqv+Aa4QAm250qObZyJ5
 1jg60WL6DdZd1FlxNYpM0NSk/nyKhPN0AMz3reSpzKLZU7N9qiTYZp4R+bh4dtt/+751
 UXSqclFYcaMgQC+da2X04KzWko/hGWdyg7fH6nScszk/zRcEL76rD91oiVs72D5dBI6e
 bOe/I7gUxY07ptBcUekwoYqyQvTgyfXrlYdqXgOxrHk+huekcNIbhIREbEvbgqCVdtgu
 HBfDOX77QBMQe5WwwGZtqmEbWiIfOq6Dfousdv6gu6CowQ4GB4yclublNYvdScpj3egI 0w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 31gann69kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2020 11:46:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Jun
 2020 11:46:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 8 Jun 2020 11:46:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 47D683F703F;
        Mon,  8 Jun 2020 11:46:55 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 058IktVe031617;
        Mon, 8 Jun 2020 11:46:55 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 058Iksr1031608;
        Mon, 8 Jun 2020 11:46:54 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 0/2] qla2xxx SAN Congestion Management (SCM) support
Date:   Mon, 8 Jun 2020 11:46:28 -0700
Message-ID: <20200608184630.31574-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_17:2020-06-08,2020-06-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the updated qla2xxx patch series implementing SAN
Congestion Management (SCM) support to the scsi tree at your
earliest convenience.

We will follow this up with another patchset to add SCM statistics to
the scsi transport fc, as recommended by James.

v1->v2:
1. Applied changes to address warnings highlighted by Bart.
2. Removed data structures and functions that should be part of fc transport,
to be send out in a follow-up patchset.
3. Changed the existing code to use definitions from fc transport headers.

Thanks,
Nilesh

Shyam Sundar (2):
  qla2xxx: Change in PUREX to handle FPIN ELS requests.
  qla2xxx: SAN congestion management(SCM) implementation.

 drivers/scsi/qla2xxx/qla_dbg.c  |  13 +-
 drivers/scsi/qla2xxx/qla_def.h  |  71 +++++++-
 drivers/scsi/qla2xxx/qla_fw.h   |   6 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |   4 +-
 drivers/scsi/qla2xxx/qla_init.c |   9 +-
 drivers/scsi/qla2xxx/qla_isr.c  | 291 +++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c  |  64 ++++++-
 drivers/scsi/qla2xxx/qla_os.c   |  37 +++-
 include/uapi/scsi/fc/fc_els.h   |   1 +
 9 files changed, 428 insertions(+), 68 deletions(-)


base-commit: 47742bde281b2920aae8bb82ed2d61d890aa4f56
-- 
2.19.0.rc0

