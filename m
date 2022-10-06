Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22ABC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 10:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiJFKvQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 06:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiJFKvO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 06:51:14 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D4F75481;
        Thu,  6 Oct 2022 03:51:10 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B331341226;
        Thu,  6 Oct 2022 10:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1665053467; x=
        1666867868; bh=kYQfCnEQJDkqcoh2Mg1e02PjIiJU0zn6OjHD4WF63WY=; b=g
        VJDt3INqG63S1/HaBBV91jRkLF0ZhO8/Tyre1otQ+R2u0/s6PG/kruEOHmeRtCZU
        IZN3R3AjNpkfzbYoEWlNCyuUBy1Ay0xTBtG2qfiUq7O5TSE3oK7lOQpAd7sWpQ6A
        c4WwHz5HJciMsQtDYvM2zL1gbDvc5zChvc5XLK5Gls=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id E8Nky8i4SFeY; Thu,  6 Oct 2022 13:51:07 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9F35141221;
        Thu,  6 Oct 2022 13:51:06 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 6 Oct 2022 13:51:06 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Thu, 6 Oct 2022 13:51:05 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 0/5] scsi: target: make RTPI an TPG identifier
Date:   Thu, 6 Oct 2022 13:50:52 +0300
Message-ID: <20221006105057.30184-1-d.bogdanov@yadro.com>
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

 drivers/target/target_core_alua.c            |  4 +-
 drivers/target/target_core_configfs.c        |  9 +-
 drivers/target/target_core_device.c          | 43 +--------
 drivers/target/target_core_fabric_configfs.c | 44 +++++++--
 drivers/target/target_core_internal.h        |  3 +-
 drivers/target/target_core_pr.c              |  8 +-
 drivers/target/target_core_spc.c             |  2 +-
 drivers/target/target_core_stat.c            |  6 +-
 drivers/target/target_core_tpg.c             | 98 ++++++++++++++++++--
 include/target/target_core_base.h            |  6 +-

-- 
2.25.1

