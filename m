From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 0/3] New EH command timeout handler
Date: Thu, 31 Oct 2013 14:02:50 +0100
Message-ID: <1383224573-113346-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab3JaNC5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Oct 2013 09:02:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Hannes Reinecke <hare@suse.de>

Hi all,

this patchset implements a new SCSI EH command timeout handler
which will be sending command aborts inline without actually
engaging SCSI EH.
SCSI EH will only be invoked if command abort fails.

In addition the commands will be returned directly
if the command abort succeeded, cutting down recovery
times dramatically.

With the original SCSI EH I got:
# time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
4096+0 records in
4096+0 records out
16777216 bytes (17 MB) copied, 142.652 s, 118 kB/s

real	2m22.657s
user	0m0.013s
sys	0m0.145s

With this patchset I got:
# time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
4096+0 records in
4096+0 records out
16777216 bytes (17 MB) copied, 52.1579 s, 322 kB/s

real	0m52.163s
user	0m0.012s
sys	0m0.145s

Test was to disable RSCN on the target port, disable the
target port, and then start the 'dd' command as indicated.

Changes to the original version:
- Use a private list in scsi_eh_abort_handler to avoid
  list starvation (pointed out by Joern Engel)
- Terminate command aborts when the first abort fails
- Do not attempt command aborts if the host is already in recovery
  or if the device is removed.
- Flush abort workqueue if the device is removed.

Changes to v2:
- Removed eh_entry initialisation
- Convert to per-command workqueue

Changes to v3:
- Use delayed_work
- Enable new eh timeout handler for virtio, SAS, and FC
- Modify logging messages to include scmd pointer

Changes to v4:
- Remove stubs when enabling new eh timeout handler
  for other drivers

Changes to v5:
- Enable new eh timeout handler per default
- Update documentation

Changes to v6:
- Include changes from James Bottomley for erratic device
  offline patch
- Rearrange patches
- Update SCSI midlayer documentation

Changes to v7:
- Merge obsolete patch

Hannes Reinecke (2):
  scsi: improved eh timeout handler
  scsi: Update documentation

James Bottomley (1):
  scsi: Fix erratic device offline during EH

 Documentation/scsi/scsi_eh.txt          |  69 +++++++------
 Documentation/scsi/scsi_mid_low_api.txt |   9 +-
 drivers/scsi/scsi.c                     |   9 +-
 drivers/scsi/scsi_error.c               | 178 ++++++++++++++++++++++++++++----
 drivers/scsi/scsi_priv.h                |   2 +
 drivers/scsi/sd.c                       |  26 +++--
 include/scsi/scsi_cmnd.h                |   2 +
 include/scsi/scsi_driver.h              |   2 +-
 include/scsi/scsi_host.h                |   5 +
 9 files changed, 229 insertions(+), 73 deletions(-)

-- 
1.8.1.4

