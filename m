From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/7] libfc: sanitize kref and state machine fixes
Date: Fri, 30 Sep 2016 09:04:07 +0200
Message-ID: <1475219054-31241-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55657 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752669AbcI3HE1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 03:04:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here is the first round of patch to fixup libfc and FCoE.
It consists of a rewrite of the libfc rport kref handling
(or, to be precise, is _implements_ rport kref handling)
and updates the 'disc_mutex' handling to match the new
kref usage.
There are also some state machine fixes to handle FLOGI
better and a fix from Chad to harden FCoE login.

As usual, comments and reviews are welcome.

Cheers,

Hannes

Chad Dupuis (2):
  libfc: Do not take rdata->rp_mutex when processing a -FC_EX_CLOSED ELS
    response.
  fcoe: Harden CVL handling when we have not logged into the fabric.

Hannes Reinecke (5):
  libfc: Revisit kref handling
  libfc: Fixup disc_mutex handling
  libfc: Do not drop down to FLOGI for fc_rport_login()
  libfc: Do not login if the port is already started
  libfc: don't advance state machine for incoming FLOGI

 drivers/scsi/fcoe/fcoe_ctlr.c |  72 ++++++++++++---
 drivers/scsi/libfc/fc_disc.c  |  38 +++++---
 drivers/scsi/libfc/fc_lport.c |   9 +-
 drivers/scsi/libfc/fc_rport.c | 197 ++++++++++++++++++++++++++++++++----------
 4 files changed, 245 insertions(+), 71 deletions(-)

-- 
1.8.5.6

