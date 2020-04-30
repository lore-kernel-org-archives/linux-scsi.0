Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06926C8300D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E28082076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgD3NUF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:60562 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgD3NUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BBC56AF0B;
        Thu, 30 Apr 2020 13:20:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 00/41] scsi: enable reserved commands for LLDDs
Date:   Thu, 30 Apr 2020 15:18:23 +0200
Message-Id: <20200430131904.5847-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
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
drivers (eg. fnic or snic).
Conversion of the SAS drivers hisi_sas, pm8001, and mv_sas are
compile tested only; I'd be grateful if someone could give
these patches a spin on that hardware, too.

The entire patchset can be found at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git reserved-tags.v3

As usual, comments and reviews are welcome.

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
	      
Hannes Reinecke (39):
  scsi: add 'nr_reserved_cmds' field to the SCSI host template
  scsi: add scsi_{get,put}_reserved_cmd()
  scsi: Implement scsi_cmd_is_reserved()
  csiostor: use reserved command for LUN reset
  scsi: add scsi_cmd_from_priv()
  virtio_scsi: use reserved commands for TMF
  fnic: use reserved commands
  fnic: use scsi_host_busy_iter() to traverse commands
  scsi: use real inquiry data when initialising devices
  scsi: make host device a first-class citizen
  hpsa: move hpsa_hba_inquiry after scsi_add_host()
  hpsa: use reserved commands
  hpsa: use scsi_host_busy_iter() to traverse outstanding commands
  hpsa: drop refcount field from CommandList
  aacraid: use private commands
  aacraid: use scsi_host_busy_iter() to traverse commands
  megaraid_sas: kill this_id and init_id
  megaraid_sas: use shost_priv()
  megaraid_sas: avoid using megaraid_lookup_instance()
  megaraid_sas: separate out megasas_set_max_sectors()
  megaraid_sas: megaraid_sas: reshuffle SCSI host allocation
  block: implement persistent commands
  scsi: add a 'persistent' argument to scsi_get_reserved_cmd()
  megaraid_sas: separate out megasas_prepare_aen()
  megaraid_sas: use reserved commands
  megaraid_sas_fusion: rearrange mfi and mpt frame pools
  megaraid_sas_fusion: sanitize command lookup
  megaraid_sas: use scsi_host_busy_iter to traverse outstanding commands
  snic: use reserved commands
  snic: use tagset iter for traversing commands
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

 block/blk-mq.c                              |  27 +-
 drivers/scsi/aacraid/aachba.c               |  14 +-
 drivers/scsi/aacraid/aacraid.h              |   9 +-
 drivers/scsi/aacraid/commctrl.c             |  57 +-
 drivers/scsi/aacraid/comminit.c             |  34 +-
 drivers/scsi/aacraid/commsup.c              |  76 +--
 drivers/scsi/aacraid/dpcsup.c               |   2 +-
 drivers/scsi/aacraid/linit.c                | 181 +++---
 drivers/scsi/csiostor/csio_init.c           |   1 +
 drivers/scsi/csiostor/csio_scsi.c           |  48 +-
 drivers/scsi/fnic/fnic_scsi.c               | 943 ++++++++++++----------------
 drivers/scsi/hisi_sas/hisi_sas_main.c       | 116 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |   5 +-
 drivers/scsi/hpsa.c                         | 367 +++++------
 drivers/scsi/hpsa.h                         |   3 +-
 drivers/scsi/hpsa_cmd.h                     |   1 -
 drivers/scsi/libsas/sas_ata.c               |   4 +
 drivers/scsi/libsas/sas_expander.c          |   7 +-
 drivers/scsi/libsas/sas_init.c              |  63 +-
 drivers/scsi/libsas/sas_scsi_host.c         |   4 +-
 drivers/scsi/megaraid/megaraid_sas.h        |  14 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 664 +++++++++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 431 +++++++------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   5 -
 drivers/scsi/mvsas/mv_init.c                |  10 +-
 drivers/scsi/mvsas/mv_sas.c                 | 136 ++--
 drivers/scsi/mvsas/mv_sas.h                 |  13 +-
 drivers/scsi/pm8001/pm8001_hwi.c            | 133 ++--
 drivers/scsi/pm8001/pm8001_init.c           |  30 +-
 drivers/scsi/pm8001/pm8001_sas.c            | 192 +++---
 drivers/scsi/pm8001/pm8001_sas.h            |  13 +-
 drivers/scsi/pm8001/pm80xx_hwi.c            | 131 ++--
 drivers/scsi/scsi_lib.c                     |  73 +++
 drivers/scsi/scsi_scan.c                    |  80 ++-
 drivers/scsi/scsi_sysfs.c                   |   3 +-
 drivers/scsi/snic/snic.h                    |   4 +-
 drivers/scsi/snic/snic_main.c               |   8 +
 drivers/scsi/snic/snic_scsi.c               | 386 ++++++------
 drivers/scsi/virtio_scsi.c                  | 105 ++--
 include/linux/blk-mq.h                      |   3 +
 include/linux/blk_types.h                   |   4 +
 include/scsi/libsas.h                       |  11 +-
 include/scsi/scsi_cmnd.h                    |  23 +
 include/scsi/scsi_device.h                  |   4 +
 include/scsi/scsi_host.h                    |   9 +
 45 files changed, 2190 insertions(+), 2257 deletions(-)

-- 
2.16.4

