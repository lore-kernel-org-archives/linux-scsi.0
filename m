From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv9 0/6] Display EVPD pages in sysfs
Date: Sat, 15 Mar 2014 09:51:46 +0100
Message-ID: <1394873512-102073-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaCOIvz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2014 04:51:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Here's now v9 of my patch series to display VPD pages
in sysfs.
Changes to v8:
- Fixed 'vpg' spelling error
- Moved to binary attributes
- Implement VPD page refreshing by either calling 'rescan'
  or due to a SCSI sense event.

So with this series all outstanding issues should be resolved.
And even Bart should be happy now as the vpd information can
be refreshed at any time.

Note, that with the move to binary sysfs attributes we lost
the functionality to hide the vpd page attributes if those
pages aren't supported.
I deliberately used the grouping functionality for the binary
attribute here, otherwise it would introduce a race window
during which the uevent was sent but no vpd page attribute
was present.
If that turns out to be a problem we should be fixing the
sysfs core to allow an 'is_visible' callback for binary
attributes, too.

Hannes Reinecke (6):
  scsi_sysfs: Implement 'is_visible' callback
  scsi: Return VPD page length in scsi_vpd_inquiry()
  Add EVPD page 0x83 to sysfs
  Add EVPD page 0x80 to sysfs
  ses: Use vpd information from scsi_device
  Invalidate VPD page data

 drivers/scsi/scsi.c        | 149 ++++++++++++++++++++++++++++--
 drivers/scsi/scsi_error.c  |   1 +
 drivers/scsi/scsi_scan.c   |  10 ++-
 drivers/scsi/scsi_sysfs.c  | 220 ++++++++++++++++++++++++++-------------------
 drivers/scsi/ses.c         |  38 +++-----
 include/scsi/scsi_device.h |   7 ++
 6 files changed, 297 insertions(+), 128 deletions(-)

-- 
1.7.12.4

