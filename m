From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 0/7] FC Transport Extensions (FC sysfs)
Date: Fri, 29 Jul 2011 16:38:23 -0700
Message-ID: <20110729233823.12794.94487.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10675 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1G2XiX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 19:38:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, giridhar.malavali@qlogic.com, james.smart@emulex.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: neerav.parikh@intel.com

This is a functional series of patches that adds new API
calls to the FC Transport to allow a LLD to create FC Port
and FC Fabric devices. This series also has a patch to add
the usage of these new APIs to libfc, libfcoe and fcoe.

This series originally started as a much larger effort.
The original try created a FC subsystem that could link
with SCSI as only one FC4 type. It allowed for other FC4s
to register with the FC subsystem in the future. This
model also created more devices than just the FC Port
and FC Fabric. It made the vports we currently use more
flexible and reordered the existing device tree to attach
the Scsi_Host as a child of a FC vport device. It placed
the vports and rports on fabrics and fabrics on ports.
This model, although idealfrom a FC standpoint, was quite
complicated and impractical as generally only SCSI is
transported over FC in modern adapters. This initial
aproach was abandoned following the last LSF conference.

A second aproach was taken where there was less of a FC4
plugin model, but the device tree was still re-arranged.
This model also proved to be problematic mostly due to
moving the Scsi_Host to be a child of a FC device.
Specifically, libfc and fcoe had problems with circular
locking around the Scsi_Host lock when dealing with the
list of NPIV ports that was both maintained by the FC
Transport as well as the N_Port's lport (for link events).
Seeing that moving the Scsi_Host was being a pain I chose
an even more simplified aproach.

This series is that simplified aproach. It simply adds
the following APIs.

fc_port_add -   Adds a FC Port Device to represent the
	        FC characteristics of a physical port
	        capable of FC or FCoE.
fc_port_del -   Deletes a created FC Port.
fc_fabric_add - Adds a FC Fabric device to represent
	        the FC characteristics of a discovered
		FC switch, FCF or underlying fabric.
fc_fabric_del - Deletes a created FC Fabric.

These APIs are extensions and should not impact any
implementations using the current FC Transport interface.

I focused on functionality over attributes in this series.
These patches work, under developer testing, and adding
attributes shouldn't be too difficult. I have an idea of
what attributes I'd like to add and there is a proposal to
extend the HBA API that maps well to these two new devices
that this series adds.

I opted to allow libfcoe to continue to manage FCF selection,
but that logic could move to the transport.

I need to do some testing in both P2P (VN2VN) and target
modes, but I believe that running this code as a SW FCoE
initiator in a switched fabric environment is functional,
including NPIV support.

The first 5 patches are pre-work patches for this series
and may be able to be merged without the FC Transport
additions (they still need official validation).

I'd be happy to share those (rough) patch series upon
request.

---

Robert Love (7):
      fcoe: Fix deadlock between fip's recv_work and rtnl
      fcoe: Do not switch context in vport_delete callback
      fcoe: Don't hold fcoe_config_mutex for fcoe_if_destroy or fcoe_interface_cleanup
      fcoe: Remove reference counting on 'stuct fcoe_interface'
      fcoe: Rename out_nomod label to out_putmod
      FC Transport: Add API for LLDs to add FC port and FC fabric devices
      fcoe: Use the new FC Transport APIs for FC ports and fabrics


 drivers/scsi/fcoe/fcoe.c           |  418 +++++++++++++++-----------
 drivers/scsi/fcoe/fcoe.h           |    6 
 drivers/scsi/fcoe/fcoe_ctlr.c      |  310 +++++++++++++++----
 drivers/scsi/fcoe/fcoe_transport.c |    7 
 drivers/scsi/libfc/fc_lport.c      |    1 
 drivers/scsi/scsi_transport_fc.c   |  578 ++++++++++++++++++++++++++++++++++++
 include/scsi/libfcoe.h             |   34 ++
 include/scsi/scsi_transport_fc.h   |  150 +++++++++
 8 files changed, 1250 insertions(+), 254 deletions(-)

-- 
Thanks, //Rob
