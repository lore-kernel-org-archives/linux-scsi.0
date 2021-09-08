Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9DBC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C59FA610FF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352207AbhIHQsT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:48:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29860 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352332AbhIHQsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 12:48:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1889r43o000993;
        Wed, 8 Sep 2021 09:47:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=6BTeWXRrdMCTX1pTPkhNgFlrC43/uqjrh9Q+xGwGtAY=;
 b=Q7wQUMXVZugSzK2Dkgo1+SqACLvnq/aHTgIf/2JaWayy0e4Lc2wZoAduyteylFF1iis6
 Zv0AhUT/C7NuvSS1DSvgmLBAtz4FdKRgUBbWrQzgAKmSKF1KANXVflc9A1gZ26e5YLSk
 W00H2k6LPv3tb0X9FdeoChNmB785gTe3AmhmQYQI4b5V8n2AsHE42ShUHjtLVljZ1OBl
 7Ia+aO98ObY0IeRhfsddh7Gm/RxaFxkQ1/r+IvhZwZB8swLRclSbfrjexi7U+sZxAQ49
 8DjY/aVTdmtA/5LxePI/EuLEwzk1E0ho82wHL4mAouJScbqQNutXfWhZyfshg8GHCzlU /g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3axtxc1keh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 09:47:04 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Sep
 2021 09:47:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Sep 2021 09:47:02 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9CD1C3F7091;
        Wed,  8 Sep 2021 09:47:02 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 188GklYQ019275;
        Wed, 8 Sep 2021 09:46:52 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 188GkMCd019274;
        Wed, 8 Sep 2021 09:46:22 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <djeffery@redhat.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 00/10] qla2xxx driver bug fixes
Date:   Wed, 8 Sep 2021 09:46:12 -0700
Message-ID: <20210908164622.19240-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ihLCIRSv9hPhh3PCCxCqNQX5IxsvBF4P
X-Proofpoint-GUID: ihLCIRSv9hPhh3PCCxCqNQX5IxsvBF4P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-08_06,2021-09-07_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver bug fixes to the scsi tree at your
earliest convenience.

v2:
- Added Fixes and Cc tags for few fixes
- Replace hb with heartbeat to make more readable
- Added Reviewed-by tag

Thanks,
Nilesh

Arun Easi (2):
  qla2xxx: Fix crash in NVME abort path
  qla2xxx: Fix kernel crash when accessing port_speed sysfs file

Bikash Hazarika (1):
  qla2xxx: Add support for mailbox passthru

Manish Rangankar (1):
  qla2xxx: Move heart beat handling from dpc thread to workqueue

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.07.100-k

Quinn Tran (2):
  qla2xxx: edif: Use link event to wake up app
  qla2xxx: Fix use after free in eh_abort path

Saurav Kashyap (2):
  qla2xxx: Display 16G only as supported speeds for 3830c card
  qla2xxx: Check for firmware capability before creating QPair

Shreyas Deodhar (1):
  qla2xxx: Call process_response_queue() in Tx path

 drivers/scsi/qla2xxx/qla_attr.c    | 24 +++++++-
 drivers/scsi/qla2xxx/qla_bsg.c     | 48 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h     |  7 +++
 drivers/scsi/qla2xxx/qla_def.h     |  4 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |  4 ++
 drivers/scsi/qla2xxx/qla_gs.c      |  3 +-
 drivers/scsi/qla2xxx/qla_init.c    | 17 +++---
 drivers/scsi/qla2xxx/qla_mbx.c     | 33 +++++++++++
 drivers/scsi/qla2xxx/qla_nvme.c    | 20 ++++++-
 drivers/scsi/qla2xxx/qla_os.c      | 90 +++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_version.h |  6 +-
 11 files changed, 193 insertions(+), 63 deletions(-)


base-commit: 9b5ac8ab4e8bf5636d1d425aee68ddf45af12057
-- 
2.19.0.rc0

