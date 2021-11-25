Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0E8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355971AbhKYPQQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:16:16 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47086 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353289AbhKYPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:14:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 11E511FD3D;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dA7Dmc4olRP0G4ydFs7HGuiiT5FgmeXvV+AOkou6stw=;
        b=LF6Jz52+PDJ17/hSFmm7fmSQDfj/DOahO8bSOdd43VLMA+hTN8WVAMXbK5oRWspsL1a4cY
        ixw177oow8jzt7NHHZUHgnjtIF7Alos8CE2hws6NWbSEt9n5o6qvHMl0/AaCYrBlY82uJy
        MupB/h9hz9nbVG+GV/QToR4OVaeqKy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dA7Dmc4olRP0G4ydFs7HGuiiT5FgmeXvV+AOkou6stw=;
        b=c1Zg8FDWe+31Z7abjnt9WiOYQBZ4oGDP7yhd/1II09WiGSzu7AUdUIQYns9UVwOEbehFlU
        cfQ7WdAfNzI++eAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9DEEEA3B85;
        Thu, 25 Nov 2021 15:11:01 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8F53551919EC; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCHv9 00/15] scsi: enabled reserved commands for LLDDs
Date:   Thu, 25 Nov 2021 16:10:33 +0100
Message-Id: <20211125151048.103910-1-hare@suse.de>
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

Command allocation currently ignores the hardware queues, as none
of the modified drivers is mq-capable.

This patchset is being sent out as a base for the current discussion
for enabling reserved commands for the UFS driver; idea is to
base those patches on top of this one if we are agree that this
is the way forward.

The entire patchset can be found at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
reserved-tags.v9

As usual, comments and reviews are welcome.

Changes to v8:
- Drop changes to fnic and snic
- Rebase after scsi_get_host_dev() removal
- Rework aacraid to store callback pointer in host_scribble

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

Hannes Reinecke (15):
  scsi: allocate host device
  scsi: add scsi_{get,put}_internal_cmd() helper
  scsi: implement reserved command handling
  hpsa: move hpsa_hba_inquiry after scsi_add_host()
  hpsa: use reserved commands
  hpsa: use scsi_host_busy_iter() to traverse outstanding commands
  hpsa: drop refcount field from CommandList
  aacraid: return valid status from aac_scsi_cmd()
  aacraid: don't bother with setting SCp.Status
  aacraid: move scsi_add_host()
  aacraid: move container ID into struct fib
  aacraid: fsa_dev pointer is always valid
  aacraid: store callback in scsi_cmnd.host_scribble
  aacraid: use scsi_get_internal_cmd()
  aacraid: use scsi_host_busy_iter() to traverse outstanding commands

 drivers/scsi/aacraid/aachba.c   | 208 +++++++++---------
 drivers/scsi/aacraid/aacraid.h  |  15 +-
 drivers/scsi/aacraid/commctrl.c |  25 ++-
 drivers/scsi/aacraid/comminit.c |   2 +-
 drivers/scsi/aacraid/commsup.c  | 115 +++++-----
 drivers/scsi/aacraid/dpcsup.c   |   2 +-
 drivers/scsi/aacraid/linit.c    | 170 +++++++--------
 drivers/scsi/hosts.c            |  11 +
 drivers/scsi/hpsa.c             | 364 ++++++++++++++------------------
 drivers/scsi/hpsa.h             |   1 -
 drivers/scsi/hpsa_cmd.h         |  10 -
 drivers/scsi/scsi_lib.c         |  53 ++++-
 drivers/scsi/scsi_scan.c        |  67 +++++-
 drivers/scsi/scsi_sysfs.c       |   3 +-
 include/scsi/scsi_device.h      |   5 +-
 include/scsi/scsi_host.h        |  43 +++-
 16 files changed, 595 insertions(+), 499 deletions(-)

-- 
2.29.2

