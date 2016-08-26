From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/30] FCoE VN2VN fixes
Date: Fri, 26 Aug 2016 14:01:23 +0200
Message-ID: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35120 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752089AbcHZMCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>

Hi all,

here's a patchset to get VN2VN running on non-DCB fabrics.
With it it's possible to run FCoE VN2VN over virtio, allowing
for a fully virtualized FC testbed. Which would make it ideal
to integrate into Mike's mptest test suite.
It also irons out some generic issues with the libfc stack,
like another round for kref handling updates and handling PRLI correctly.
(The PRLI problems even have a workaround in iPXE, so it's time to do
something about it ...)

As usual, comments and reviews are welcome.

Hannes Reinecke (29):
  libfc: Revisit kref handling
  libfc: additional debugging messages
  libfc: spurious I/O error under high load
  libfc: Do not login if the port is already started
  libfc: use configured lport R_A_TOV when sending
  libfc: use configured e_d_tov for remote port state
  libfc: do not overwrite DID_TIME_OUT status
  libfc: use error code for fc_rport_error()
  libfc: Send LS_RJT responses on frame allocation
  libfc: don't advance state machine for incoming FLOGI
  libfc: Fixup disc_mutex handling
  libfc: Do not drop down to FLOGI for fc_rport_login()
  libfc: Implement RTV responder
  libfc: Rework PRLI handling
  libfc: Return LS_RJT_BUSY for PRLI in status PLOGI
  libfc: Clarify ramp-down messages
  libfc: sanitize E_D_TOV and R_A_TOV setting
  libfc: safeguard against invalid exchange index
  libfc: quarantine timed out xids
  libfc: don't fail sequence abort for completed
  libfc: Do not drop out-of-order frames
  libfc: reset timeout on queue full
  libfc: wait for E_D_TOV when out-of-order sequence is received
  fcoe: set default TC priority
  fcoe: inhibit writing invalid values into the 'enabled'
  fcoe: correct sending FIP VLAN packets on VLAN 0
  fcoe: FIP debugging
  fcoe: filter out frames from invalid vlans
  fcoe: make R_A_TOV and E_D_TOV configurable

Wei Yongjun (1):
  fcoe: Use kfree_skb() instead of kfree()

 drivers/scsi/fcoe/fcoe.c       |  23 ++-
 drivers/scsi/fcoe/fcoe_ctlr.c  |  93 +++++++--
 drivers/scsi/fcoe/fcoe_sysfs.c |  83 +++++++-
 drivers/scsi/libfc/fc_disc.c   |  30 +--
 drivers/scsi/libfc/fc_exch.c   | 118 +++++++----
 drivers/scsi/libfc/fc_fcp.c    | 195 ++++++++++++------
 drivers/scsi/libfc/fc_lport.c  |   8 +-
 drivers/scsi/libfc/fc_rport.c  | 436 ++++++++++++++++++++++++++++++-----------
 include/scsi/libfc.h           |   9 +-
 9 files changed, 760 insertions(+), 235 deletions(-)

-- 
1.8.5.6

