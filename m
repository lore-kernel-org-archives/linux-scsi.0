Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD21C433B4
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA4D611C9
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhECPEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 11:04:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:40790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhECPEj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 May 2021 11:04:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 59691AEEB;
        Mon,  3 May 2021 15:03:44 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 00/18] scsi: enabled reserved commands for LLDDs
Date:   Mon,  3 May 2021 17:03:15 +0200
Message-Id: <20210503150333.130310-1-hare@suse.de>
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

Command allocation currently ignores the hardware queues, as none
of the modified drivers is mq-capable.

The entire patchset can be found at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
reserved-tags.v8

This patchset also includes the busy_iter patches for fnic, which
were also sent as a separate patchset. So if they are applied
separately they can be dropped from this patchset.

As usual, comments and reviews are welcome.

Changes to v7:
- Drop changes to hisi_sas, pm8001, and mv_sas
- Drop patch to introduce REQ_INTERNAL flag
- Include reviews from John Garry

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


Hannes Reinecke (18):
  fnic: kill 'exclude_id' argument to fnic_cleanup_io()
  fnic: use scsi_host_busy_iter() to traverse commands
  scsi: add scsi_{get,put}_internal_cmd() helper
  fnic: use internal commands
  scsi: use real inquiry data when initialising devices
  scsi: Use dummy inquiry data for the host device
  scsi: revamp host device handling
  snic: use reserved commands
  snic: use tagset iter for traversing commands
  scsi: implement reserved command handling
  hpsa: move hpsa_hba_inquiry after scsi_add_host()
  hpsa: use reserved commands
  hpsa: use scsi_host_busy_iter() to traverse outstanding commands
  hpsa: drop refcount field from CommandList
  aacraid: move scsi_add_host()
  aacraid: store target id in host_scribble
  aacraid: use scsi_get_internal_cmd()
  aacraid: use scsi_host_busy_iter() to traverse outstanding commands

 drivers/scsi/aacraid/aachba.c   | 137 ++---
 drivers/scsi/aacraid/aacraid.h  |  10 +-
 drivers/scsi/aacraid/commctrl.c |  25 +-
 drivers/scsi/aacraid/comminit.c |   2 +-
 drivers/scsi/aacraid/commsup.c  | 118 ++--
 drivers/scsi/aacraid/dpcsup.c   |   2 +-
 drivers/scsi/aacraid/linit.c    | 175 +++---
 drivers/scsi/fnic/fnic_scsi.c   | 927 +++++++++++++++-----------------
 drivers/scsi/hosts.c            |   3 +
 drivers/scsi/hpsa.c             | 365 ++++++-------
 drivers/scsi/hpsa.h             |   3 +-
 drivers/scsi/hpsa_cmd.h         |  10 -
 drivers/scsi/scsi_devinfo.c     |   1 +
 drivers/scsi/scsi_lib.c         |  48 +-
 drivers/scsi/scsi_scan.c        |  96 ++--
 drivers/scsi/scsi_sysfs.c       |   5 +-
 drivers/scsi/snic/snic.h        |   4 +-
 drivers/scsi/snic/snic_main.c   |   7 +
 drivers/scsi/snic/snic_scsi.c   | 524 +++++++++---------
 include/scsi/scsi_device.h      |   3 +
 include/scsi/scsi_host.h        |  36 +-
 21 files changed, 1234 insertions(+), 1267 deletions(-)

-- 
2.29.2

