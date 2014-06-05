From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] scanning fixes
Date: Thu,  5 Jun 2014 09:26:41 +0200
Message-ID: <1401953203-103015-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaFEH0r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2014 03:26:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Robert Elliot <elliot@hp.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here are two fixes for the scanning logic which resolve two long-standing
issues:

1) We need to send a 'TEST UNIT READY' to the LUN before scanning.
The INQUIRY command does _not_ clear any unit attentions,
so if there are any outstanding unit attention conditions they'll
be attached to the first command after INQUIRY.
Which typically wouldn't be too bad, as most of the commands
are now equipped with at least rudimentary error checking.
However, the problem arises when we're sending a REPORT LUN command
to that LUN. As per spec the REPORT LUN command will _always_
return something, but the list might not be fully populated if
the firmware is still starting up (see SPC for details here).
This will cause us to miss some devices during startup.
Added to that we're not handling the unit attention
'REPORT LUN DATA HAS CHANGED', so the kernel will never be
able to rescan all disks.
To fix this we should be issuing a TEST UNIT READY after
INQUIRY, and wait until any pending unit attention goes away.

2) Power-on/Reset handling
While we're not sending out uevents for various unit attention
conditions, we fail to observe the status precedence as per SAM.
This might cause any 29/XX sense code to effectively overwrite
any preceding unit attentions, causing us to miss those events.
Hence as a minimal fix we need to report the power-on reset
event via uevents, too.

Hannes Reinecke (2):
  scsi_scan: Send TEST UNIT READY to the LUN before scanning
  scsi: Handle power-on reset unit attention

 drivers/scsi/scsi_error.c  |  6 ++++
 drivers/scsi/scsi_lib.c    |  4 +++
 drivers/scsi/scsi_scan.c   | 86 +++++++++++++++++++++++++++++++++++++++-------
 include/scsi/scsi_device.h |  3 +-
 4 files changed, 85 insertions(+), 14 deletions(-)

-- 
1.7.12.4

