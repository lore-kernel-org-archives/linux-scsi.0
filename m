From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 00/10] FC Transport Extensions (FC sysfs)
Date: Mon, 22 Aug 2011 15:48:22 -0700
Message-ID: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54839 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab1HVWsW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 18:48:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

v2 -

This update adds some attributes to the FC port and
FC fabric devices that the original series defined. The
newly exposed attributes were mostly chosen because they
are members of libfcoe.ko and fcoe.ko's
'struct fcoe_interface' and 'struct fcoe_fcf'. These two
structures are now allocated with the 'struct fc_port'
and 'struct fc_fabric', respectively. I've also put some
FIP controller attributes on the fc_port.

There is a SMHBA FCoE extension proposal that defines more
devices than I have in this series. That proposal defines
ports, phys, fabrics, and controllers. This series defines
only ports and fabrics. I think that the attibutes for the
ports, controllers and the host may be able to be added to
a single device in sysfs. Should that just be the
shost/fc_host? Phy(s) complicate this, but maybe there could
just be a phy count on within 'struct fc_host_attrs'.

Before reading the SMHBA proposal I had the fc_port
representing the fixed characteristics of the port
(i.e. its capabilities) and the host's attributes describing
the runtime properties of an N_Port or VN_Port. In this
v2 series that distinction is not as clear as it was originally
envisioned, mostly because I've added controller attributes
to the fc_port.

====

v1 -

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
This model, although ideal from a FC standpoint, was quite
complicated and impractical as generally only SCSI is
transported over FC in modern adapters. This initial
approach was abandoned following the last LSF conference.

A second approach was taken where there was less of a FC4
plug-in model, but the device tree was still re-arranged.
This model also proved to be problematic mostly due to
moving the Scsi_Host to be a child of a FC device.
Specifically, libfc and fcoe had problems with circular
locking around the Scsi_Host lock when dealing with the
list of NPIV ports that was both maintained by the FC
Transport as well as the N_Port's lport (for link events).
Seeing that moving the Scsi_Host was being a pain I chose
an even more simplified approach.

This series is that simplified approach. It simply adds
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

Robert Love (10):
      fcoe: Do not switch context in vport_delete callback
      fcoe: Don't hold fcoe_config_mutex for fcoe_if_destroy or fcoe_interface_cleanup
      fcoe: Remove reference counting on 'stuct fcoe_interface'
      fcoe: Rename out_nomod label to out_putmod
      FC Transport: Add API for LLDs to add FC port and FC fabric devices
      fcoe: Use the new FC Transport APIs for FC ports and fabrics
      FC Transport: Add Fabric Attributes
      fcoe: Use fabric attributes
      FC Transport: Add FC Port Attributes
      libfcoe, fcoe: Use FC Port Attributes


 drivers/scsi/fcoe/fcoe.c           |  483 +++++++++++++-------
 drivers/scsi/fcoe/fcoe.h           |    6 
 drivers/scsi/fcoe/fcoe_ctlr.c      |  412 ++++++++++++++---
 drivers/scsi/fcoe/fcoe_transport.c |    7 
 drivers/scsi/libfc/fc_lport.c      |    2 
 drivers/scsi/scsi_transport_fc.c   |  871 +++++++++++++++++++++++++++++++++++-
 include/scsi/libfc.h               |    1 
 include/scsi/libfcoe.h             |   50 ++
 include/scsi/scsi_transport_fc.h   |  236 ++++++++++
 9 files changed, 1795 insertions(+), 273 deletions(-)

-- 
Thanks, //Rob
