From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/20] libfc callback cleanup
Date: Tue, 18 Oct 2016 10:01:34 +0200
Message-ID: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752374AbcJRIC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

it has been bugging me for a while that libfc has tons of callbacks
in an attempt to abstract things away. But as it turned out
no-one ever used those, rendering them quite pointless.
As I got some time to kill on the train back from Vienna I've decided
to finally kill them and call the functions directly.

As usual, comments and reviews are welcome.

Hannes Reinecke (20):
  libfc: Replace ->seq_els_rsp_send callback with function call
  libfc: Replace ->lport_reset callback with function call
  libfc: Replace ->lport_recv with function call
  libfc: Replace ->exch_seq_send callback with function call
  libfc: Replace ->rport_destroy callback with function call
  libfc: Replace ->rport_lookup callback with function call
  scsi_transport_fc: rename 'fc_rport_create' to 'fc_remote_port_create'
  libfc: Replace ->rport_create callback with function call
  libfc: Replace ->rport_login callback with function call
  libfc: Replace ->rport_logoff callback with function call
  libfc: Replace ->rport_recv_req callback with function call
  libfc: Replace ->rport_flush_queue callback with function call
  libfc: Remove fc_rport_init()
  libfc: Replace ->seq_send callback with function call
  libfc: Replace ->seq_exch_abort callback with function call
  libfc: Replace ->exch_done callback with function call
  libfc: Replace ->seq_start_next callback with function call
  libfc: Replace ->seq_set_resp callback with direct function call
  libfc: Replace ->seq_assign callback with function call
  libfc: Replace ->seq_release callback with function call

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   1 -
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |   3 +-
 drivers/scsi/fcoe/fcoe_ctlr.c     |  35 ++++---
 drivers/scsi/fnic/fnic_scsi.c     |   2 +-
 drivers/scsi/libfc/fc_disc.c      |  33 ++++---
 drivers/scsi/libfc/fc_elsct.c     |   2 +-
 drivers/scsi/libfc/fc_exch.c      | 104 ++++++++++----------
 drivers/scsi/libfc/fc_fcp.c       |  45 ++++-----
 drivers/scsi/libfc/fc_libfc.c     |   2 +-
 drivers/scsi/libfc/fc_lport.c     |  62 ++++++------
 drivers/scsi/libfc/fc_rport.c     | 167 ++++++++++++++------------------
 drivers/scsi/scsi_transport_fc.c  |   8 +-
 drivers/target/tcm_fc/tfc_cmd.c   |  20 ++--
 drivers/target/tcm_fc/tfc_io.c    |   4 +-
 include/scsi/libfc.h              | 195 ++++++--------------------------------
 15 files changed, 254 insertions(+), 429 deletions(-)

-- 
1.8.5.6

