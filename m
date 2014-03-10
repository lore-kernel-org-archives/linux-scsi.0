From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 0/5] Display EVPD pages in sysfs
Date: Mon, 10 Mar 2014 15:28:40 +0100
Message-ID: <1394461725-76203-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbaCJO2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2014 10:28:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Bart van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Here's now v8 of my patch series to display VPD pages
in sysfs.
Changes to v7:
- Modify ses driver to use vpd_pg83 information
- Use get_unaligned_XX where possible
- Split off modifications to scsi_vpd_inquiry()
  into a separate patch.

So with this series all outstanding issues should be resolved.
As noted by Bart van Assche the information in the VPD pages
is _not_ updated when a sense code for LUN Inquiry data changed
was received. This would involved a re-design of the current
scanning infrastructure, which is out of scope for this patch
series.

Hannes Reinecke (5):
  scsi_sysfs: Implement 'is_visible' callback
  scsi: Return VPD page length in scsi_vpd_inquiry()
  Add EVPD page 0x83 to sysfs
  Add EVPD page 0x80 to sysfs
  ses: Use vpd information from scsi_device

 drivers/scsi/scsi.c        | 104 ++++++++++++++++++--
 drivers/scsi/scsi_scan.c   |   3 +
 drivers/scsi/scsi_sysfs.c  | 234 +++++++++++++++++++++++++++------------------
 drivers/scsi/ses.c         |  38 ++------
 include/scsi/scsi_device.h |   5 +
 5 files changed, 257 insertions(+), 127 deletions(-)

-- 
1.7.12.4

