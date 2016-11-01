From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/3] scsi_dh: switch to scsi_execute_req_flags()
Date: Tue,  1 Nov 2016 22:49:35 +0100
Message-ID: <1478036978-30583-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60309 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754563AbcKAVtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 17:49:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's a patchset to switch to scsi_execute_req_flags() for
all SCSI device handlers. Originally we would be using
blk_execute_rq_nowait to allow the 'activate' function
to run asynchronously.
However, as we're now calling the 'activate' function
synchronously there's no point in using the blk_execute_rq()
interface and we should be using scsi_execute_req_flags()
instead.

As usual, comments and reviews are welcome.

Changes to v1:
- Integrate reviews from hch

Hannes Reinecke (3):
  scsi_dh_rdac: switch to scsi_execute_req_flags()
  scsi_dh_emc: switch to scsi_execute_req_flags()
  scsi_dh_hp_sw: switch to scsi_execute_req_flags()

 drivers/scsi/device_handler/scsi_dh_emc.c   | 245 ++++++----------------------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 218 +++++++------------------
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 172 ++++++-------------
 3 files changed, 164 insertions(+), 471 deletions(-)

-- 
2.6.6

