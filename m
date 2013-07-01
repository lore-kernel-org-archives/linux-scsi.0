From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/5] scsi: More detailed I/O errors
Date: Mon,  1 Jul 2013 10:12:06 +0200
Message-ID: <1372666331-66996-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab3GAIMS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 04:12:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

As discussed at LSF the SCSI stack already knows about several
error conditions, it's just not well documented.
Also there are some more conditions upper layers might be
interested in.

This patchset improves the documentation of the existing
I/O error codes and adds three more error codes, ENOSPC
for thin provisioning failure, ENODATA for medium error,
and ENXIO for an invalid or removed device.

Changes since the initial version:
- Correctly document all return codes in
  __scsi_error_from_host_byte()
- Set hostbyte status in scsi_check_sense()
- Return ENXIO on invalid or removed device

Hannes Reinecke (5):
  scsi: Document enhanced error codes
  scsi: Set hostbyte status in scsi_check_sense()
  scsi: return ENOSPC on thin provisioning failure
  scsi: Return ENODATA on medium error
  scsi: Return ENXIO on invalid device

 block/blk-core.c          |  9 +++++++++
 drivers/scsi/scsi_error.c | 28 +++++++++++++---------------
 drivers/scsi/scsi_lib.c   | 29 ++++++++++++++++++++++++++++-
 include/scsi/scsi.h       |  3 ++-
 4 files changed, 52 insertions(+), 17 deletions(-)

-- 
1.7.12.4

