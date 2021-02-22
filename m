Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26C2C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6916E64E74
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhBVN1f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:27:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:45138 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231620AbhBVNY6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:24:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 71E79AE47;
        Mon, 22 Feb 2021 13:24:15 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
Date:   Mon, 22 Feb 2021 14:23:34 +0100
Message-Id: <20210222132405.91369-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

quite some drivers use internal commands for various purposes, most
commonly sending TMFs or querying the HBA status.
While these commands use the same submission mechanism than normal
I/O commands, they will not be counted as outstanding commands,
requiring those drivers to implement their own mechanism to figure
out outstanding commands.
The block layer already has the concept of 'reserved' tags for
precisely this purpose, namely non-I/O tags which live off a separate
tag pool. That guarantees that these commands can always be sent,
and won't be influenced by tag starvation from the I/O tag pool.
This patchset enables the use of reserved tags for the SCSI midlayer
by allocating a virtual LUN for the HBA itself which just serves
as a resource to allocate valid tags from.
This removes quite some hacks which were required for some
drivers (eg. fnic or snic), and allows the use of tagset
iterators within the drivers.

The entire patchset can be found at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
reserved-tags.v7

As usual, comments and reviews are welcome.

Changes to v6:
- Remove patch to drop gdth
- Rework libsas to use a tag per slow task
- Update hisi_sas, pm8001, and mv_sas

Changes to v5:
- Remove patch for csiostor
- Warn on normal commands in scsi_put_reserved_cmd()
- Fixup aacraid to not only scsi_put_internal_cmd() for
  reserved commands
  - Add 'nr_reserved_cmds' field to host template
  - Reshuffle patches

Changes to v4:
- Fixup kbuild warning
- Include reviews from Bart

Changes to v3:
- Kill gdth
- Only convert fnic, snic, hpsa, and aacraid
- Drop command emulation for pseudo host device
- make 'can_queue' exclude the number or reserved tags
- Drop persistent commands proposal
- Sanitize host device handling

Changes to v2:
- Update patches from John Garry
- Use virtual LUN as suggested by Christoph
- Improve SCSI Host device to present a real SCSI device
- Implement 'persistent' commands for AENs
- Convert Megaraid SAS

Changes to v1:
- Make scsi_{get, put}_reserved_cmd() for Scsi host
- Previously we separate scsi_{get, put}_reserved_cmd() for sdev
  and scsi_host_get_reserved_cmd() for the host
  - Fix how Scsi_Host.can_queue is set in the virtio-scsi change
  - Drop Scsi_Host.use_reserved_cmd_q
  - Drop scsi_is_reserved_cmd()
  - Add support in libsas and associated HBA drivers
  - Allocate reserved command in slow task
  - Switch hisi_sas to use reserved Scsi command
  - Reorder the series a little
  - Some tidying

Hannes Reinecke (29):
  block: add flag for internal commands
  scsi: add scsi_{get,put}_internal_cmd() helper
  fnic: use internal commands
  fnic: use scsi_host_busy_iter() to traverse commands
  fnic: check for started requests in fnic_wq_copy_cleanup_handler()
  scsi: use real inquiry data when initialising devices
  scsi: Use dummy inquiry data for the host device
  scsi: revamp host device handling
  snic: use reserved commands
  snic: use tagset iter for traversing commands
  snic: check for started requests in snic_hba_reset_cmpl_handler()
  scsi: implement reserved command handling
  hpsa: move hpsa_hba_inquiry after scsi_add_host()
  hpsa: use reserved commands
  hpsa: use scsi_host_busy_iter() to traverse outstanding commands
  hpsa: drop refcount field from CommandList
  aacraid: move scsi_add_host()
  aacraid: store target id in host_scribble
  aacraid: use scsi_get_internal_cmd()
  aacraid: use scsi_host_busy_iter() to traverse outstanding commands
  mv_sas: kill mvsas_debug_issue_ssp_tmf()
  pm8001: kill pm8001_issue_ssp_tmf()
  pm8001: kill 'dev' argument from pm8001_exec_internal_task_abort()
  pm8001: use libsas-provided domain devices for SATA
  libsas: add SCSI target pointer to struct domain_device
  libsas: add tag to struct sas_task
  hisi_sas: use task tag to reference the slot
  mv_sas: use reserved tags and drop private tag allocation
  pm8001: use block-layer tags for ccb allocation

John Garry (2):
  scsi: libsas,hisi_sas,mvsas,pm8001: Allocate Scsi_cmd for slow task
  scsi: hisi_sas: Use libsas slow task SCSI command

 block/blk-exec.c                       |   5 +
 drivers/scsi/aacraid/aachba.c          | 137 ++--
 drivers/scsi/aacraid/aacraid.h         |  10 +-
 drivers/scsi/aacraid/commctrl.c        |  25 +-
 drivers/scsi/aacraid/comminit.c        |   2 +-
 drivers/scsi/aacraid/commsup.c         | 109 ++-
 drivers/scsi/aacraid/dpcsup.c          |   2 +-
 drivers/scsi/aacraid/linit.c           | 175 +++--
 drivers/scsi/fnic/fnic_scsi.c          | 944 +++++++++++--------------
 drivers/scsi/hisi_sas/hisi_sas.h       |   1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 137 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |   5 +-
 drivers/scsi/hosts.c                   |   3 +
 drivers/scsi/hpsa.c                    | 368 +++++-----
 drivers/scsi/hpsa.h                    |   3 +-
 drivers/scsi/hpsa_cmd.h                |   1 -
 drivers/scsi/libsas/sas_ata.c          |   4 +
 drivers/scsi/libsas/sas_expander.c     |   7 +-
 drivers/scsi/libsas/sas_init.c         |  63 +-
 drivers/scsi/libsas/sas_scsi_host.c    |   4 +-
 drivers/scsi/mvsas/mv_init.c           |  10 +-
 drivers/scsi/mvsas/mv_sas.c            | 136 +---
 drivers/scsi/mvsas/mv_sas.h            |  13 +-
 drivers/scsi/pm8001/pm8001_hwi.c       | 154 ++--
 drivers/scsi/pm8001/pm8001_init.c      |  24 +-
 drivers/scsi/pm8001/pm8001_sas.c       | 193 +++--
 drivers/scsi/pm8001/pm8001_sas.h       |  14 +-
 drivers/scsi/pm8001/pm80xx_hwi.c       | 143 ++--
 drivers/scsi/scsi_devinfo.c            |   1 +
 drivers/scsi/scsi_lib.c                |  55 +-
 drivers/scsi/scsi_scan.c               |  96 ++-
 drivers/scsi/scsi_sysfs.c              |   3 +-
 drivers/scsi/snic/snic.h               |   4 +-
 drivers/scsi/snic/snic_main.c          |   7 +
 drivers/scsi/snic/snic_scsi.c          | 525 +++++++-------
 include/linux/blk_types.h              |   2 +
 include/linux/blkdev.h                 |   5 +
 include/scsi/libsas.h                  |  11 +-
 include/scsi/scsi_device.h             |   4 +
 include/scsi/scsi_host.h               |  36 +-
 40 files changed, 1647 insertions(+), 1794 deletions(-)

-- 
2.29.2

