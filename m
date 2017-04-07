From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 0/6] sanitize sg
Date: Fri,  7 Apr 2017 09:34:11 +0200
Message-ID: <1491550457-78302-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54209 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753336AbdDGHeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 03:34:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <"james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, DougGilberdgilbert"@interlog.com>, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>

Hi all,

the infamous syzkaller incovered some more issues in the sg driver.
This patchset fixes those two issues (and adds a fix for yet another
potential issue; checking for a NULL dxferp when dxfer_len is not 0).
It also removes handling of the SET_FORCE_LOW_DMA ioctl, which never
worked since the initial git checkin. And does some code cleanup by
removing the private list implementation, using standard lists instead.

As usual, comments and reviews are welcome.

Changes to v1:
- Include reviews from Christoph
- Add patch to close race condition in sg_remove_sfp_usercontext()
- Remove stale variable 'save_scat_len'

Changes to v2:
- Move misplaced hunk
- Add Reviewed-by: and Tested-by: tags

Changes to v3:
- Review locking in 'sg: protect accesses ...'
- Reshuffle hunks to keep kbuild robot happy

Hannes Reinecke (5):
  sg: disable SET_FORCE_LOW_DMA
  sg: remove 'save_scat_len'
  sg: protect accesses to 'reserved' page array
  sg: use standard lists for sg_requests
  sg: close race condition in sg_remove_sfp_usercontext()

Johannes Thumshirn (1):
  sg: check for valid direction before starting the request

 drivers/scsi/sg.c | 282 +++++++++++++++++++++++++++---------------------------
 include/scsi/sg.h |   1 -
 2 files changed, 139 insertions(+), 144 deletions(-)

-- 
1.8.5.6
