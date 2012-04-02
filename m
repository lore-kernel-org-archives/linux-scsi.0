From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] 'default' hardware handler for multipath
Date: Mon,  2 Apr 2012 18:43:53 +0200
Message-ID: <1333385035-6663-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab2DBQoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Apr 2012 12:44:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>

This patchset introduces a 'default' hardware handler for
dm-multipath.
Modern storage arrays typically support two failover methods,
the original proprietary and the modern ALUA-based one.
The device_handler implementation will currently select the
ALUA handler, and falling back to the proprietary one if
ALUA isn't supported.
However, in the built-in hardware table for multipath one
can specify only one hardware handler, causing the original
hardware handler to be overwritten.
By specifying a 'default' hardware handler multipath will not
try to attach a specific hardware handler, but rather using
the currently attached on.

Hannes Reinecke (2):
  scsi_dh: Allow NULL hardware handler name in scsi_dh_attach()
  dm-mpath: Allow 'default' hardware handler

 drivers/md/dm-mpath.c                 |    8 ++++++--
 drivers/scsi/device_handler/scsi_dh.c |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

-- 
1.7.7

