From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/16] scsi_dh_alua updates
Date: Fri, 31 Jan 2014 10:29:44 +0100
Message-ID: <1391160600-19652-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbaAaJaC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jan 2014 04:30:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi James,

here's an update for the ALUA device handler I've been hoarding
for quite some time. The major bit here is the asynchronous
RTPG handling. With the original design we would treat every
LUN independently, despite the fact that several LUNs might
in fact belong to the same target port group. So any
change on one LUN will affect the others, too.
And we now can treat LUNs in 'transitioning' ALUA mode
correctly, as now we'll be blocking any I/O in the prep_fn()
until the controller is in a working state again.

This is the second version of the patchset, containing
suggested changes from Mike Christie to move
GFP_ATOMIC to GFP_KERNEL allocations.

Hannes Reinecke (16):
  scsi_dh_alua: Improve error handling
  scsi_dh_alua: use flag for RTPG extended header
  scsi_dh_alua: Pass buffer as function argument
  scsi_dh_alua: Make stpg synchronous
  scsi_dh_alua: put sense buffer on stack
  scsi_dh_alua: use local buffer for VPD inquiry
  scsi_dh_alua: Use separate alua_port_group structure
  scsi_dh_alua: parse target device id
  scsi_dh_alua: simplify sense code handling
  scsi_dh_alua: Do not attach to management devices
  scsi_dh_alua: multipath failover fails with error 15
  scsi_dh: return individual errors in scsi_dh_activate()
  scsi_dh_alua: Clarify logging message
  scsi_dh: invoke callback if ->activate is not present
  scsi_dh_alua: revert commit a8e5a2d593cbfccf530c3382c2c328d2edaa7b66
  scsi_dh_alua: Use workqueue for RTPG

 drivers/scsi/device_handler/scsi_dh.c      |   18 +-
 drivers/scsi/device_handler/scsi_dh_alua.c | 1045 ++++++++++++++++++++--------
 2 files changed, 750 insertions(+), 313 deletions(-)

-- 
1.7.12.4

