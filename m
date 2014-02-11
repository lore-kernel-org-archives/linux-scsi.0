From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 0/2] Display EVPD pages in sysfs
Date: Tue, 11 Feb 2014 15:34:52 +0100
Message-ID: <1392129294-55235-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaBKOe4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Feb 2014 09:34:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's now the (hopefully) final version of my patch to display
EVPD pages in sysfs. After some discussion with Kay Sievers I've
found that the whole thing can be made far simpler by using the
'is_visible' callback to the sysfs attribute group.
And we can even simplify existing code here.

The patch itself has been modified to add boundary checks to
handle invalid pages gracefully.

Hannes Reinecke (2):
  scsi_sysfs: Implement 'is_visible' callback
  Add EVPD page 0x83 entries to sysfs

 drivers/scsi/scsi_scan.c   |   3 +
 drivers/scsi/scsi_sysfs.c  | 518 +++++++++++++++++++++++++++++++++++++--------
 include/scsi/scsi.h        |   4 +-
 include/scsi/scsi_device.h |   3 +
 4 files changed, 433 insertions(+), 95 deletions(-)

-- 
1.7.12.4

