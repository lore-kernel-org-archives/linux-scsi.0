From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/3] scsi_dh: switch to scsi_execute_req_flags()
Date: Thu,  3 Nov 2016 14:20:20 +0100
Message-ID: <1478179223-87935-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754725AbcKCNU3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Nov 2016 09:20:29 -0400
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
And while we're at it we can convert them to use
scsi_get_vpd_page(), thus simplifying the code
by quite a bit.

As usual, comments and reviews are welcome.

Changes to v1:
- Integrate reviews from hch

Changes to v2:
- Integrate further reviews from hch

Hannes Reinecke (3):
  scsi_dh_rdac: switch to scsi_execute_req_flags()
  scsi_dh_emc: switch to scsi_execute_req_flags()
  scsi_dh_hp_sw: switch to scsi_execute_req_flags()

 drivers/scsi/device_handler/scsi_dh_emc.c   | 247 +++++++---------------------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 222 ++++++++-----------------
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 174 ++++++--------------
 3 files changed, 172 insertions(+), 471 deletions(-)

-- 
2.6.6

