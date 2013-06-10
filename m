From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/7] Limit overall SCSI EH runtime
Date: Mon, 10 Jun 2013 13:11:46 +0200
Message-ID: <1370862713-41323-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab3FJLME (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 07:12:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

This patchset implements a new 'eh_deadline' attribute to the
SCSI host. It will limit the overall SCSI EH runtime by a given
timeout. If the timeout expires all intermediate steps will
be skipped and host reset will be scheduled immediately.

For this patch I've re-used the existing 'last_reset' field
of the SCSI host to store the initial time SCSI EH started.
Also the field 'resetting' has been removed as it never has
been used as intended.

As 'last_reset' might be in use by transport-specific EH
implementation I've disallowed eh_deadline setting there.

Patchset is incremental to my earlier patchset
'scsi: improved eh timeout handler'.

As usual, comments etc are welcome.

Hannes Reinecke (7):
  dpt_i2o: Remove DPTI_STATE_IOCTL
  dpt_i2o: return SCSI_MLQUEUE_HOST_BUSY when in reset
  advansys: Remove 'last_reset' references
  tmscsim: Move 'last_reset' into host structure
  dc395: Move 'last_reset' into internal host structure
  scsi: remove check for 'resetting'
  scsi: Add 'eh_deadline' to limit SCSI EH runtime

 drivers/scsi/advansys.c   |   8 +--
 drivers/scsi/dc395x.c     |  24 ++++----
 drivers/scsi/dpt_i2o.c    |  35 +++++-------
 drivers/scsi/dpti.h       |   1 -
 drivers/scsi/hosts.c      |   7 +++
 drivers/scsi/scsi.c       |  28 ---------
 drivers/scsi/scsi_error.c | 142 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_sysfs.c |  37 ++++++++++++
 drivers/scsi/tmscsim.c    |  14 ++---
 drivers/scsi/tmscsim.h    |   1 +
 include/scsi/scsi_host.h  |   2 +-
 11 files changed, 218 insertions(+), 81 deletions(-)

-- 
1.7.12.4

