From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/24] FCoE VN2VN fixes, part two
Date: Thu, 13 Oct 2016 15:10:36 +0200
Message-ID: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39665 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932234AbcJMNMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:12:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's now the second part of my FCoE VN2VN patchset.
The key points are:
- Configurable R_A_TOV/E_D_TOV
- Rework PRLI handling to fix a longstanding bug
- Correctly handle timed-out xids

Additionally there are some minor fixes to get things to work
when running with FCoE over virtio.

Patches are relative to mkp/4.10/scsi-queue.

As usual, comments and reviews are welcome.

Hannes Reinecke (24):
  libfc: additional debugging messages
  libfc: spurious I/O error under high load
  libfc: use configured lport R_A_TOV
  libfc: use configured rport E_D_TOV
  libfc: sanitize E_D_TOV and R_A_TOV setting
  fcoe: make R_A_TOV and E_D_TOV configurable
  libfc: do not overwrite DID_TIME_OUT status
  libfc: use error code for fc_rport_error()
  libfc: Implement RTV responder
  libfc: Rework PRLI handling
  libfc: Return LS_RJT_BUSY for PRLI in status PLOGI
  libfc: Clarify ramp-down messages
  libfc: safeguard against invalid exchange index
  libfc: quarantine timed out xids
  libfc: don't fail sequence abort for completed exchanges
  libfc: Do not drop out-of-order frames
  libfc: reset timeout on queue full
  libfc: wait for E_D_TOV when out-of-order sequence is received
  libfc: Check xid when looking up REC exchanges
  fcoe: set default TC priority
  fcoe: catch invalid values for the 'enabled' attribute
  fcoe: FIP debugging
  fcoe: correct sending FIP VLAN packets on VLAN 0
  fcoe: filter out frames from invalid vlans

 drivers/scsi/fcoe/fcoe.c       |  23 +++-
 drivers/scsi/fcoe/fcoe_ctlr.c  |  60 +++++++++-
 drivers/scsi/fcoe/fcoe_sysfs.c |  83 +++++++++++++-
 drivers/scsi/libfc/fc_exch.c   | 134 ++++++++++++++++------
 drivers/scsi/libfc/fc_fcp.c    | 196 ++++++++++++++++++++++----------
 drivers/scsi/libfc/fc_lport.c  |   8 +-
 drivers/scsi/libfc/fc_rport.c  | 248 ++++++++++++++++++++++++++++++-----------
 include/scsi/libfc.h           |   9 +-
 8 files changed, 584 insertions(+), 177 deletions(-)

-- 
1.8.5.6

