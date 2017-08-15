From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] ses: simple subenclosure support
Date: Tue, 15 Aug 2017 10:21:39 +0200
Message-ID: <1502785303-41870-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36871 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750994AbdHOIVs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 04:21:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

some arrays (most notably 3Par) only support simple subenclosures.
Sadly our ses implementation doesn't handle this properly, so we're
greeted with error messages like:

scsi 1:0:0:254: Wrong diagnostic page; asked for 2 got 0
scsi 1:0:0:254: Failed to get diagnostic page 0xffffffea
scsi 1:0:0:254: Failed to bind enclosure -19
ses 1:0:0:254: Attached Enclosure device

This patchset fixes up our ses implementation to work properly
with simple subenclosures.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  scsi: Fixup ses page check
  ses: check return code from ses_recv_diag()
  ses: Fixup error message 'failed to get diagnostic page 0xffffffea'
  ses: make page2 support optional

 drivers/scsi/ses.c | 63 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 11 deletions(-)

-- 
1.8.5.6
