From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/22] FCoE VN2VN fixes
Date: Wed,  3 Aug 2016 15:13:00 +0200
Message-ID: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbcHCNNb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>

Hi all,

after long and painful debugging session I finally managed to get
FCoE VN2VN running on a point-to-point connection.
There wasn't so much a single issue, but rather an entire slew
of rather annoying problems:
- rport kref handling is bonkers. Taking a kref once and releasing
  it when attempting to free the structure is just not what krefs
  are designed for.
- The FCoE stack reacts allergic to out-of-order frames. While in
  theory this shouldn't happen, it's hard to avoid with modern HW.
  Plus I even had been seeing this when using virtio. And to make
  matters worse, it would occasionally just drop any out of order
  frames, while handling them correctly in other cases.
- Failed FC REC/ABTS will cause an I/O error. There are perfectly
  legit cases where a REC might fail (eg if the exchange was already
  sent and it just got stuck in the RX queue), so it should not
  considered an error. A simple retry will be sufficient.
- FLOGI are handled ... interestingly. If both ends attempt an
  FLOGI the state machine is advanved on the incoming FLOGI
  request, so the stack gets confused when the (original) FLOGI
  ACC is being returned.

Additionally I've added lots of debugging statements and some
general cleanup.

As usual, comments and reviews are welcome.

The entire patchset can be found at
git://git.kernel.org/hare/scsi-devel/h/vn2vn

Hannes Reinecke (22):
  libfc: Revisit kref handling
  libfc: additional debugging messages
  fcoe: FIP debugging
  libfc: spurious I/O error under high load
  libfc: Do not attempt to login if the port is already started
  libfc: Debug PRLI failures
  fcoe: filter out frames from invalid vlans
  fcoe: make R_A_TOV and E_D_TOV configurable
  libfc: use configured lport R_A_TOV when sending exchange
  libfc: use configured e_d_tov for remote port state retries
  fcoe: inhibit writing invalid values into the 'enabled' attribute
  libfc: don't fail sequence abort for completed exchanges
  libfc: do not overwrite DID_TIME_OUT status
  libfc: use error code for fc_rport_error()
  libfc: frame alloc failure messages
  fc: add missing ELS explanation values
  libfc: Send LS_RJT responses on frame allocation failure
  libfc: don't advance state machine for incoming FLOGI
  libfc: Implement RTV responder
  libfc: Do not drop out-of-order frames
  libfc: reset timeout on queue full
  fcoe: set default TC priority

 drivers/scsi/fcoe/fcoe.c       |  21 ++-
 drivers/scsi/fcoe/fcoe_ctlr.c  |  63 +++++++-
 drivers/scsi/fcoe/fcoe_sysfs.c |  83 +++++++++-
 drivers/scsi/libfc/fc_exch.c   |  64 ++++++--
 drivers/scsi/libfc/fc_fcp.c    | 131 ++++++++++++----
 drivers/scsi/libfc/fc_rport.c  | 349 ++++++++++++++++++++++++++++++-----------
 include/scsi/libfc.h           |   8 +-
 include/uapi/scsi/fc/fc_els.h  |  17 +-
 8 files changed, 584 insertions(+), 152 deletions(-)

-- 
1.8.5.6

