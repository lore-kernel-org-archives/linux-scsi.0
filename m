From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Mon,  1 Jul 2013 08:50:48 +0200
Message-ID: <1372661455-122384-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab3GAGvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 02:51:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, Hannes Reinecke <hare@suse.de>

This patchset implements a new 'eh_deadline' attribute to the
SCSI host. It will limit the overall SCSI EH runtime by a given
timeout. If the timeout is reached all intermediate EH steps
will be skipped and host reset will be scheduled immediately.

For this patch I've re-used the existing 'last_reset' field
of the SCSI host to store the initial time SCSI EH started.
Also the field 'resetting' has been removed as it never has
been used as intended.

As 'last_reset' might be in use by transport-specific EH
implementation I've disallowed eh_deadline setting there.

Changes from the initial version:
- Add list_splice_init() calls to avoid stale commands
- Rename function to scsi_host_eh_past_deadline

Hannes Reinecke (7):
  dpt_i2o: Remove DPTI_STATE_IOCTL
  dpt_i2o: return SCSI_MLQUEUE_HOST_BUSY when in reset
  advansys: Remove 'last_reset' references
  tmscsim: Move 'last_reset' into host structure
  dc395: Move 'last_reset' into internal host structure
  scsi: remove check for 'resetting'
  scsi: Add 'eh_deadline' to limit SCSI EH runtime

 drivers/scsi/advansys.c   |   8 +--
 drivers/scsi/dc395x.c     |  24 +++++----
 drivers/scsi/dpt_i2o.c    |  35 +++++--------
 drivers/scsi/dpti.h       |   1 -
 drivers/scsi/hosts.c      |   7 +++
 drivers/scsi/scsi.c       |  28 ----------
 drivers/scsi/scsi_error.c | 130 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_sysfs.c |  37 +++++++++++++
 drivers/scsi/tmscsim.c    |  14 ++---
 drivers/scsi/tmscsim.h    |   1 +
 include/scsi/scsi_host.h  |   4 +-
 11 files changed, 208 insertions(+), 81 deletions(-)

-- 
1.7.12.4

