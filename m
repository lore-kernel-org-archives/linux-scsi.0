Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A69D4C47088
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 12:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiLBMMH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 07:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbiLBMME (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 07:12:04 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CE1D2D8D;
        Fri,  2 Dec 2022 04:11:58 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0515941207;
        Fri,  2 Dec 2022 12:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1669983115; x=
        1671797516; bh=LvOacjOBkfqk+aDT0pJIwXBlozs+ILLOC1yKowC2PLQ=; b=v
        iqh9MYnwUFS4jzOD4wLHY45MAciMnNiH6BiQxn8N91bSJBL76lJBOu5rvLobgKSW
        eShIKz7vFBO4vaEyBA4l78cpjPdpCnnPQzBrn1asdvEn86HMXnMaQDxDMFYpPv3X
        rQYG6fF8XUj6ZBv8BkQV0zHbZwsh7fh0ETDCIqppOg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TF6Uakxfl_rv; Fri,  2 Dec 2022 15:11:55 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 42C2240889;
        Fri,  2 Dec 2022 15:11:54 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 2 Dec 2022 15:11:54 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Fri, 2 Dec 2022 15:11:53 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v3 0/5] scsi: target: make RTPI an TPG identifier
Date:   Fri, 2 Dec 2022 15:11:34 +0300
Message-ID: <20221202121139.28180-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SAM-5 4.6.5.2 (Relative Port Identifier attribute) defines the attribute
as unique across SCSI target ports:
 The Relative Port Identifier attribute identifies a SCSI target port or
 a SCSI initiator port relative to other SCSI ports in a SCSI target
 device and any SCSI initiator devices contained within that SCSI target
 device. A SCSI target device may assign relative port identifiers to
 its SCSI target ports and any SCSI initiator ports. If relative port
 identifiers are assigned, the SCSI target device shall assign each of
 its SCSI target ports and any SCSI initiator ports a unique relative
 port identifier from 1 to 65 535. SCSI target ports and SCSI initiator
 ports share the same number space.

In the current TCM implementation, auto-incremented lun_rtpi weakly
follows the model outlined by SAM-5 and SPC-4. In case of multiple SCSI
target ports (se_portal_group's), which is common to scenario with
multiple HBAs or multiple iSCSI/FC targets, it's possible to have two
backstores (se_device's) with different values of lun_rtpi on the same
SCSI target port.

Similar issue happens during re-export. If a LUN of a backstore is
removed from a target port and added again to the same target port, RTPI
is incremented again and will be different from the first time.

The two issues happen because each se_device increments RTPI for its own
LUNs independently.

The behaviour means that a SCSI application client can't reliably make any
sense of RTPI values reported by a LUN as it's not really related to SCSI
target ports. A conforming target implementation must ensure that RTPI field is
unique per port. The patchset resolves the issue.

Make RTPI be part of se_tpg instead of se_lun. Make it configurable.

Changelog:
  v3:
    make variable static
    change core_ prefix to target_
    split to tpg_enable/tpg_disable functions

  v2:
    use XArray for tracking RTPI instead of linked list
    do not allow to change RTPI on enabled target port
    drop not needed patches

Dmitry Bogdanov (2):
  scsi: target: core: Add RTPI field to target port
  scsi: target: core: Add RTPI attribute for target port

Roman Bolshakov (3):
  scsi: target: core: Use RTPI from target port
  scsi: target: core: Drop device-based RTPI
  scsi: target: core: Add common port attributes

 drivers/target/target_core_alua.c            |   4 +-
 drivers/target/target_core_configfs.c        |   9 +-
 drivers/target/target_core_device.c          |  43 +-------
 drivers/target/target_core_fabric_configfs.c |  48 ++++++--
 drivers/target/target_core_internal.h        |   3 +-
 drivers/target/target_core_pr.c              |   8 +-
 drivers/target/target_core_spc.c             |   2 +-
 drivers/target/target_core_stat.c            |   6 +-
 drivers/target/target_core_tpg.c             | 110 +++++++++++++++++--
 include/target/target_core_base.h            |   7 +-
 10 files changed, 168 insertions(+), 72 deletions(-)

-- 
2.25.1

