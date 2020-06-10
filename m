Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C91C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 14:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A72262067B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 14:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="yzMZTPK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgFJOPh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 10:15:37 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65252 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729774AbgFJOPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 10:15:36 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05AE6b14006904
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2020 07:15:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=aWoLAxDt0rKz9JzuXhw2bPMpl7Sbp0RJU2RHLti7qvM=;
 b=yzMZTPK91UuJQK+1Bi/p+XJlb7SUKZRjn2MqCQBRxi8PKodN7JbzsqqOZ+Fyr1852eWL
 EdeZUt4Pq3OnjBKejztFqJtbedZqrLEW1KJY1agzXjuyw6j5VbJg/8sCCcVv8+REAU7O
 6xnKM9QeWqugPqRstRpc4ZKuKHeQEPdpMhY7qaJrAjWedSt93+lLqGC/dHh0XieEHApv
 YE2y2fbUXpI4eSLcJZV5YWViPuotNf4Of0V62IJPfS+2Cc+XgwOAiPWQgamLNJhYvE+7
 /jsqQFPE1hAhze6IXw8q00iKV6K+YSlAQ9dtCqLM+JVo4IxsIst6VTXQWVaavQcRFV9y ZQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31ganne063-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2020 07:15:35 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Jun
 2020 07:15:33 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Jun
 2020 07:15:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Jun 2020 07:15:33 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7DECC3F703F;
        Wed, 10 Jun 2020 07:15:33 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 05AEFXWH010659;
        Wed, 10 Jun 2020 07:15:33 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 05AEFXnC010650;
        Wed, 10 Jun 2020 07:15:33 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 0/2] qla2xxx SAN Congestion Management (SCM) support
Date:   Wed, 10 Jun 2020 07:15:07 -0700
Message-ID: <20200610141509.10616-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-10_08:2020-06-10,2020-06-10 signatures=0
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

v2->v3:
1. Updated Reviewed-by tags

v1->v2:
1. Applied changes to address warnings highlighted by Bart.
2. Removed data structures and functions that should be part of fc
transport, to be send out in a follow-up patchset.
3. Changed the existing code to use definitions from fc transport
headers.

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

