Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81025C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 18:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjCMSL3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 14:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCMSLZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 14:11:25 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2393865464;
        Mon, 13 Mar 2023 11:11:19 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 37C8334214B;
        Mon, 13 Mar 2023 21:11:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:message-id:mime-version:reply-to:subject:subject:to
        :to; s=mta-01; bh=5nK6tnEmiFWwVjdDzb3Shsy5ep4+AD/CaQtHojU9ZEg=; b=
        N3zb1culj+r4zCV1J/ftjhzp+4UDqsgE90ZpRh6kBbiuNcwCjJkUi/uoq+gJfT+D
        r642bkS1pf5Z7RjyzwsFnTL7SM8oKRbTKyT2JKDUCUeNV/CfiPzRy4Sclgv1hj5s
        3fvWweDTpznyx7P+40rr9Ijn3CE8hQ+M6NonYdMfu2k=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 2C76E342145;
        Mon, 13 Mar 2023 21:11:17 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 13 Mar 2023 21:11:16 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v3 00/12] add virtual remote fabric
Date:   Mon, 13 Mar 2023 21:10:58 +0300
Message-ID: <20230313181110.20566-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patchset is based on 6.4/scsi-staging branch.

The first 11 patches are just a refactoring to reduce code duplication
in fabric drivers.
They make several callouts be optional in fabric ops.
Make a default implementation of the optional ops and remove such
implementations in the fabric drivers.

The last patch is a new virtual remote fabric driver.
It have a valueble sence with patchset "scsi: target: make RTPI an TPG identifier"
to configure RPTI on remote/tpgt_x same as on tpgt_y on other nodes in
a storage cluster. That allows to report the same ports in RTPG from
each node and to have a clusterwide tpg/acl/lun view in kernel.

On its own it can be used as a dummy fabric driver for test purposes
or whatever.

Changelog:
 v3:
    usb:gadjet to usb: gadget
    fix identation in patch 12
    simplify init function for remote fabric

 v2:
    add default implementation for optional fabric ops
    code style cleanup


Dmitry Bogdanov (12):
  scsi: target: add default fabric ops callaouts
  infiniband: srpt: remove default fabric ops callouts
  scsi: ibmvscsit: remove default fabric ops callouts
  scsi: target: loop: remove default fabric ops callouts
  scsi: target: sbp: remove default fabric ops callouts
  scsi: target: fcoe: remove default fabric ops callouts
  usb: gadget: f_tcm: remove default fabric ops callouts
  vhost-scsi: remove default fabric ops callouts
  xen-scsiback: remove default fabric ops callouts
  scsi: qla2xxx: remove default fabric ops callouts
  scsi: efct: remove default fabric ops callouts
  target: add virtual remote target

 drivers/infiniband/ulp/srpt/ib_srpt.c    |  33 ---
 drivers/scsi/elx/efct/efct_lio.c         |  20 --
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  30 ---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       |  14 --
 drivers/target/Kconfig                   |   1 +
 drivers/target/Makefile                  |   1 +
 drivers/target/loopback/tcm_loop.c       |  41 ----
 drivers/target/sbp/sbp_target.c          |  31 ---
 drivers/target/target_core_configfs.c    |  94 +++++---
 drivers/target/tcm_fc/tcm_fc.h           |   1 -
 drivers/target/tcm_fc/tfc_cmd.c          |   5 -
 drivers/target/tcm_fc/tfc_conf.c         |  15 --
 drivers/target/tcm_remote/Kconfig        |   8 +
 drivers/target/tcm_remote/Makefile       |   2 +
 drivers/target/tcm_remote/tcm_remote.c   | 268 +++++++++++++++++++++++
 drivers/target/tcm_remote/tcm_remote.h   |  20 ++
 drivers/usb/gadget/function/f_tcm.c      |  31 ---
 drivers/vhost/scsi.c                     |  31 ---
 drivers/xen/xen-scsiback.c               |  30 ---
 19 files changed, 361 insertions(+), 315 deletions(-)
 create mode 100644 drivers/target/tcm_remote/Kconfig
 create mode 100644 drivers/target/tcm_remote/Makefile
 create mode 100644 drivers/target/tcm_remote/tcm_remote.c
 create mode 100644 drivers/target/tcm_remote/tcm_remote.h

-- 
2.25.1


