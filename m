Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D08C19F2C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbiHCQ3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbiHCQ3Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:16 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE58BB7F1;
        Wed,  3 Aug 2022 09:29:14 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9E4FC412C6;
        Wed,  3 Aug 2022 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1659544151; x=
        1661358552; bh=8pWeqIH9O0jzE6GI1+2yf5ofl1uVATv1tECEk9Hthzc=; b=Y
        1NJN/+u7BCqIRpHaVvuV80lhH+uY4TRzFJv2zDgC85J+vfqfPHxtKiQ2wwVWqkXH
        9NWBPif8Kz8INjfOa7FUTjLuQKFfx1zZUFiwXbpJp1NRbxP4lIXQU53GmxSQ0Fo+
        iU8GGoFsNcdIbSWJeDS8x/JhyAWY7FB7zHfEgEw1KQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dmcSB2kBh9-h; Wed,  3 Aug 2022 19:29:11 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B2A8C41239;
        Wed,  3 Aug 2022 19:29:10 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:10 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:10 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 00/48] Target cluster implementation over DLM
Date:   Wed, 3 Aug 2022 19:04:50 +0300
Message-ID: <20220803162857.27770-1-d.bogdanov@yadro.com>
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

Hi linux target comminity.

Let's me present RFC of an implementation of cluster features for Target
Core that needs for backstore devices shared through cluster nodes.

The patchset is big and of several subsets, but it contains some arguable
things and it would take too much time to discsuss them separatelly.

Patches 1-9:
Make RTPI be part of se_tpg instead of se_lun. That is a must because
there is no possibility to assign RTPI on a LUN.
That data model is different from SCST and current in LIO but still does
not contradict with SAM and even is more according to SAM - a whole TCM
is a SCSI Device, and all its ports are SCSI Ports with unique RTPIs.
 + unique identification of TPG through the cluster.
 + possibility of assignment of RPTI.
 - number of all TPGs will be limited to 65535.
This patchset was published first time 2 years ago [1]. In previous
version the peers RTPIs were put in <device>/alua/... folder. In this
version the peers RTPIs are part of TPGs on the remote fabric (patch 35).

Patches 10-29:
Fixes some bugs and deviations from the standard in PR code.
Undepend pr_reg from se_nacl and se_tpg to be just a registration holder.
Make APTPL registrations (not linked to se_dev_entry) be full-fledged
registrations.

Patches 30-34:
DLM_CKV module that uses DLM and provides:
 * Cluster Lock service (pure wrapper over DLM).
 * Cluster Key-Value service in memory storage.
 * Cluster Notification service with a blocking acknowledge.
 * Cluster membership callbacks.
This module is supposed to be used by TCM and nvmet to implement cluster
operations.

Patch 35:
New 'remote' (in fact dummy) fabric module. Configuration on this fabric will
provide to TCM a view of TPG/LUN/ACL configuration on a peer nodes.

Patche 36:
Introduce cluster ops and functions to register a cluster ops
implementation modules. There could be a several different modules.
The device attrib cluster_impl regulates which implementation to use
for that device. 'single' is for default (no cluster) implementation.

Patches 37-48:
TCM Cluster over DLM module implementation inspired by SCST.
 * Use DLM_CKV Lock service to serialize order of PR OUT commands
 * Use DLM_CKV Key-Value storage service to store PR cluster data.
Sync it after successful execution of PR OUT command.
 * Use DLM_CKV Notification service to notify (in blocking manner) other
nodes to fetch PR cluster data. The handling of PR OUT command is
blocked until other nodes read the cluster PR data.

It provides:
 * Cluster lock per LBA for Compare And Write.
 * Full support of SCSI-3 Persistent Reservations including
   PREEMPT AND ABORT and REGISTER AND MOVE.
 * Normal PR APTPL imlementation (persistanse over power loss)
 * Shared LUN RESET
 * Shared SCSI-2 Reservations.
 * Unit Attentions for all TPGs in cluster




How to test

1. Setup DLM over worked corosync & pacemaker cluster
 $ zypper install libdlm libdlm3
 $ crm configure primitive dlm ocf:pacemaker:controld args="-q0 -f0" allow_stonith_disabled=true  op monitor interval="60" timeout="60"
 $ crm configure clone clone-dlm dlm meta interleave=true target-role=Started
2. setup TCM cluster configuration
You can use my script [2] that I used to use while developing the patchset.
3. Test what you want.
For example, my test report [3].

[1] https://lore.kernel.org/all/20200429094443.43937-1-r.bolshakov@yadro.com/
[2] https://pastebin.com/HgCfjywh
[3] https://pastebin.com/AgLSgnWn


Dmitry Bogdanov (39):
  target: core: check RTPI uniquity for enabled TPG
  target: core: fix preempt and abort for allreg res
  target: core: fix memory leak in preempt_and_abort
  target: core: abort all preempted regs if requested
  target: core: new key must be used for moved PR
  target: core: remove unused variable in se_dev_entry
  target: core: undepend PR registrant of nacl
  target: core: make some functions public
  target: core: proper clear reservation on LUN RESET
  target: core: remove superfluous checks
  target: core: proper check of SCSI-2 reservation
  target: core: checks against peer node SCSI2 reservation
  target: core: UA on all luns after reset
  target: core: refactor LUN_RESET code
  target: core: pr: use RTPI in APTPL
  target: core: pr: have Transport ID stored
  target: core: pr: remove se_tpg from pr_reg
  target: core: fix parsing PR OUT TID
  target: core: add function to compare TransportID
  target: core: store proto_id in APTPL
  target: core: rethink APTPL registrations
  dlm_ckv: introduce DLM cluster key-value storage
  dlm_ckv: add notification service
  dlm_ckv: add key-value storage service
  dlm_ckv: add KV get/set async API
  target: add virtual remote target
  target: cluster: introduce cluster ops
  target: cluster: introduce dlm cluster
  target: cluster: store PR data in DLM cluster
  target: cluster: read PR data from cluster
  target: cluster: sync PR for dynamic acls
  target: cluster: sync-up PR data on cluster join
  target: cluster: sync SPC-2 reservations
  target: cluster: allocate UAs on PR sync
  target: cluster: support PR OUT preempt and abort
  target: cluster: add reset cluster function
  target: cluster: implement LUN reset in DLM cluster
  target: cluster: split cluster sync function
  target: cluster: request data on initial sync

Konstantin Shelekhin (1):
  scsi: target/core: Unlock PR generation bump

Roman Bolshakov (8):
  scsi: target/core: Add a way to hide a port group
  scsi: target/core: Set MULTIP bit for se_device with multiple ports
  scsi: target/core: Add cleanup sequence in core_tpg_register()
  scsi: target/core: Add RTPI field to target port
  scsi: target/core: Use RTPI from target port
  scsi: target/core: Drop device-based RTPI
  scsi: target/core: Add common port attributes
  scsi: target/core: Add RTPI attribute for target port

 drivers/target/Kconfig                       |    7 +
 drivers/target/Makefile                      |    4 +
 drivers/target/dlm_ckv.c                     |  757 +++++++++++++
 drivers/target/dlm_ckv.h                     |   44 +
 drivers/target/target_cluster_dlm.c          | 1012 ++++++++++++++++++
 drivers/target/target_core_alua.c            |   12 +-
 drivers/target/target_core_configfs.c        |  191 +++-
 drivers/target/target_core_device.c          |  244 ++++-
 drivers/target/target_core_fabric_configfs.c |   68 +-
 drivers/target/target_core_fabric_lib.c      |  262 +++--
 drivers/target/target_core_internal.h        |   29 +-
 drivers/target/target_core_pr.c              |  613 +++++------
 drivers/target/target_core_pr.h              |   33 +-
 drivers/target/target_core_sbc.c             |   12 +-
 drivers/target/target_core_spc.c             |   19 +-
 drivers/target/target_core_stat.c            |    6 +-
 drivers/target/target_core_tmr.c             |   38 +-
 drivers/target/target_core_tpg.c             |  193 +++-
 drivers/target/target_core_transport.c       |    9 +-
 drivers/target/target_core_ua.c              |    1 +
 drivers/target/tcm_remote/Kconfig            |    8 +
 drivers/target/tcm_remote/Makefile           |    2 +
 drivers/target/tcm_remote/tcm_remote.c       |  405 +++++++
 drivers/target/tcm_remote/tcm_remote.h       |   29 +
 include/target/target_core_base.h            |   56 +-
 25 files changed, 3436 insertions(+), 618 deletions(-)
 create mode 100644 drivers/target/dlm_ckv.c
 create mode 100644 drivers/target/dlm_ckv.h
 create mode 100644 drivers/target/target_cluster_dlm.c
 create mode 100644 drivers/target/tcm_remote/Kconfig
 create mode 100644 drivers/target/tcm_remote/Makefile
 create mode 100644 drivers/target/tcm_remote/tcm_remote.c
 create mode 100644 drivers/target/tcm_remote/tcm_remote.h

-- 
2.25.1

