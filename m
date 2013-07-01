From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/4] scsi: More detailed I/O errors
Date: Mon,  1 Jul 2013 15:16:22 +0200
Message-ID: <1372684586-41829-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab3GANQd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 09:16:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

As discussed at LSF the SCSI stack already knows about several
error conditions, it's just not well documented.
Also there are some more conditions upper layers might be
interested in.

This patchset improves the documentation of the existing
I/O error codes and adds two more error codes, ENOSPC
for thin provisioning failure and ENODATA for medium error.

Changes since the initial version:
- Correctly document all return codes in
  __scsi_error_from_host_byte()
- Set hostbyte status in scsi_check_sense()

Changes since v2:
- Modify dm-mpath to handle ENOSPC

Hannes Reinecke (4):
  scsi: Document enhanced error codes
  scsi: Set hostbyte status in scsi_check_sense()
  scsi: return ENOSPC on thin provisioning failure
  scsi: Return ENODATA on medium error

 block/blk-core.c          |  6 ++++++
 drivers/md/dm-mpath.c     | 16 +++++++++++++++-
 drivers/scsi/scsi_error.c | 28 +++++++++++++---------------
 drivers/scsi/scsi_lib.c   | 22 ++++++++++++++++++++++
 include/scsi/scsi.h       |  3 ++-
 5 files changed, 58 insertions(+), 17 deletions(-)

-- 
1.7.12.4

