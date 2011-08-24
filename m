From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/7] ALUA device handler update
Date: Wed, 24 Aug 2011 10:51:12 +0200
Message-ID: <1314175879-16565-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab1HXIvg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 04:51:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

This is an update to the ALUA device handler. The most important
bit is the implementation of a 'match' callback, which allows for
the implementation of a device_handler specific routine instead of
using a string comparison on vendor and model.

Rationale is that most modern arrays can operate in both modes,
ALUA and the 'legacy' failover mode. However, the vendor and
model will be identical to the legacy mode, so ALUA will never
be enabled per default on these machines.
With these patches the ALUA handler will be enabled whenever the
TPGS state is set in the inquiry data.

In contrast to what we've discussed at LinuxTag I have not tried
to attach the alua device handler directly from scsi_scan.
Reason is that I need to issue SCSI commands during activation,
which means I would have to attach it from near the end of
scsi_add_lun(), at which point the device_handler would be attached
via the current method anyway. So I fail to see the gain here.

Other fixes are:
- Evaluate the TPGS setting from the inquiry data instead of
  issuing our own inquiry
- Fixup kernel-doc comments
- Always update TPGS state on activate
- Errorneous TPG ID check
- Decrease retry interval when array is in state transitioning

Hannes Reinecke (7):
  scsi_dh_alua: Evaluate TPGS setting from inquiry data
  scsi_dh: Fixup kernel-doc comments
  scsi_dh: Implement match callback function
  scsi_dh_alua: always update TPGS status on activate
  scsi_dh: Check for sdev state in store_dh_state()
  Erroneous TPG ID check in SCSI ALUA Handler
  scsi_dh_alua: Decrease retry interval

 drivers/scsi/device_handler/scsi_dh.c      |   61 ++++++++++++++++---
 drivers/scsi/device_handler/scsi_dh_alua.c |   92 +++++----------------------
 include/scsi/scsi_device.h                 |    6 ++
 3 files changed, 75 insertions(+), 84 deletions(-)

