Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D135C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB57A20842
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="DpPVFeLJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgHEEob (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 00:44:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63796 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726055AbgHEEob (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 00:44:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0754ZZxg023966
        for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2020 21:44:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=d7FQTQART1g/Davy5MflprT3MvE3SAbbxHXargCl6C4=;
 b=DpPVFeLJh+ZCId/ppI7FdcqSArXtNZ2VZIUWc4xGgqZ4m7P/xs7k+Colan1Jtmeewmd5
 o5943RhTjzTInTHgFrZ6Ra39pLHrYtNQSRUDg56fcSLAeK1T8zMExh9aDhns0dikm5i+
 g2vmH8aXc6g8NXey5NaytsM2IWVAoUNTpCpAgMsE8h+cTaReMl3FsPO783a1+0V32A6P
 uiDq4b9GulZ51ZojDe5wCkdxnhiM29tuvUHUj4UxikFEIriC0B2htc1qVT0wKlZjCFls
 L1kz8r3x8CkEL7OgFuDxSd0MDH5wfAZ4pImVFzeN2sJxIFzbyqrga7WN9IgLqlPmHEzO LA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8fex8ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 21:44:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:44:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:44:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 4 Aug 2020 21:44:27 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 33D933F7040;
        Tue,  4 Aug 2020 21:44:27 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0754iR2f030579;
        Tue, 4 Aug 2020 21:44:27 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0754iQAX030577;
        Tue, 4 Aug 2020 21:44:26 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 00/10] qla2xxx driver bug fixes
Date:   Tue, 4 Aug 2020 21:43:52 -0700
Message-ID: <20200805044402.30543-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_03:2020-08-03,2020-08-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the attached miscellaneous qla2xxx bug fixes to the
scsi tree at your earliest convenience.

Thanks,
Nilesh

Arun Easi (2):
  qla2xxx: Allow ql2xextended_error_logging special value 1 to be set
    anytime
  qla2xxx: Fix WARN_ON in qla_nvme_register_hba

Nilesh Javali (1):
  Revert "scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"

Quinn Tran (6):
  qla2xxx: flush all sessions on zone disable
  qla2xxx: flush IO on zone disable
  qla2xxx: Indicate correct supported speeds for Mezz card
  qla2xxx: fix login timeout
  qla2xxx: reduce noisy debug message
  qla2xxx: fix null pointer access while connections disconnect from
    subsystem

Saurav Kashyap (1):
  qla2xxx: Check if FW supports MQ before enabling

 drivers/scsi/qla2xxx/qla_dbg.h    |  3 ++
 drivers/scsi/qla2xxx/qla_def.h    |  1 +
 drivers/scsi/qla2xxx/qla_gs.c     | 49 +++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c    |  4 +--
 drivers/scsi/qla2xxx/qla_mbx.c    |  8 -----
 drivers/scsi/qla2xxx/qla_nvme.c   | 15 +++++++++-
 drivers/scsi/qla2xxx/qla_os.c     |  5 ++++
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 8 files changed, 66 insertions(+), 21 deletions(-)


base-commit: b12149f2698ce25621ed0413cbb4fc26dd8ab3c1
-- 
2.19.0.rc0

