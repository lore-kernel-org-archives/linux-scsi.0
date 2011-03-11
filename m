From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 10/10] Documentation: Add fc_sysfs document
Date: Fri, 11 Mar 2011 13:55:21 -0800
Message-ID: <20110311215521.18760.49353.stgit@localhost6.localdomain6>
References: <20110311215428.18760.80632.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14911 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab1CKVzW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 16:55:22 -0500
In-Reply-To: <20110311215428.18760.80632.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

Document explaining some of the basics of the
Fibre Channel subsystem. It covers features,
design decisions and implementation details
regarding the libfc/libfcoe/fcoe usage of this
subsystem.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 Documentation/fc/fc_sysfs.txt           |  192 +++++++++++++++++++++++++++++++
 Documentation/fc/libfc_libfcoe_fcoe.txt |   17 +++
 2 files changed, 209 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/fc/fc_sysfs.txt
 create mode 100644 Documentation/fc/libfc_libfcoe_fcoe.txt

diff --git a/Documentation/fc/fc_sysfs.txt b/Documentation/fc/fc_sysfs.txt
new file mode 100644
index 0000000..fff3316
--- /dev/null
+++ b/Documentation/fc/fc_sysfs.txt
@@ -0,0 +1,192 @@
+Fibre Channel sysfs Representation
+
+Summary
+-------------------------------
+
+The Fibre Channel subsystem is designed to represent a
+fabric (or fabric-less) topology in sysfs. It allows FC
+drivers to create the following instances as the driver
+gains awareness of them.
+
+fc_port - The physical port on a CNA/HBA/NIC.
+
+fc_fabric - The switch that the physical port has discovered.
+
+fc_vport - The host's representation of a single fabric login.
+
+fc_rport - The host's representation of a discovered fabric
+	   entity (usually a target).
+
+
+Differences between FC and FCoE
+-------------------------------
+
+FCoE uses a discovery protocol named FIP (FCoE Initialization
+Protocol) to discover which switch/fabric it should login to.
+Traditional FC HBAs connect directly to their switch, so no
+discovery is needed.
+
+FCoE LLDs will first create a fc_port and then as FCFs (FCoE
+switchs) are discovered the LLD will add fc_fabric(s) to the
+system. FC LLDs will simply create a fc_fabric immediately
+after the fc_port is created sicne switch/fabric information
+will immediately be available.
+
+
+Locking
+-------------------------------
+
+Locking is based on the fact that no child devices should
+exist without their parent. For example, you should never
+have a fc_fabric without a fc_port. If the fc_port is deleted
+then all of its children, fc_fabric(s), should have been
+deleted first.
+
+fc_port
+* locking primative: mutex
+* Used to synchronize the addition and deletion of
+  fc_fabrics as well as lookup a fc_fabric within the
+  fc_port's list of fc_fabrics.
+* Used to synchronize the addition and deletion of
+  fc_vports on the fc_fabric as well as lookup a fc_vport
+  within the fc_fabric's list of fc_vports.
+* Used to synchronize the fc_fabric's npiv_vports_inuse field.
+
+fc_fabric
+* locking primative: none 
+* The fc_fabric uses the fc_port's lock (see above).
+
+fc_vport
+* locking primative: spinlock_t
+* Used to protect the fc_vport's 'flags'.
+* Used to synchronize the addition and deletion of
+  fc_rports on the fc_vport as well as lookup a fc_rport
+  within the fc_vport's list of fc_rports, as well as
+  the fc_vport's list of fc_rport bindings.
+
+APIs
+----
+
+fc_port_add: No locking requirement
+fc_port_del: No locking requirement
+fc_port_del_fabrics: fc_port lock held
+fc_fabric_add: fc_port lock held
+fc_fabric_del: fc_port lock held
+fc_vport_alloc: No locking requirement
+fc_vport_free: No locking requirement
+fc_vport_add: fc_port lock held
+fc_rport_add: No locking requirement
+fc_rport_del: No locking requirement
+
+TODO: This is a bit odd that some routines need the
+lock held and others don't, can I remove the locking
+requirements and isolate the locking to drivers/fc/?
+
+
+FC4 Registration/Unregistration
+-------------------------------
+
+Since Fibre Channel is capable of transporting multiple
+protocols (the FC4 layer in FC terms) the FC subsystem
+allows the LLD to register the FC4s it supports with the
+fc_port and it selects the FC4 for use with each fc_vport.
+Currently only SCSI-FCP (Initiator) is supported and is
+implemented in the scsi_transport_fcp.{ch} files.
+
+A bus/driver model is used to represent this architecture.
+The fc_vport and fc_rport instances are each bus devices
+and fcp_init and fcp_targ instances are drivers for these
+busses, respectively.
+
+In the simplist sense when a fc_vport is created a
+fcp_init is also created. When a fc_rport is created
+a fcp_targ is created.
+
+You can think of the FC4 layer as a 'glue' layer that
+ties the FC4 protocol to the FC subsystem. If the LLD
+supports a FC4 protocol it must implement the necessary
+callbacks to initialize any FC4 instances created.
+
+
+SCSI-FCP Devices
+-------------------------------
+
+fcp_init
+* 1:1 with the Scsi_Host and fc_vport
+* Allocated with the Scsi_Host
+* Replaces the fc_host_attrs from the previous FC Transport
+
+fcp_targ
+* 1:1 with scsi_target (assuming the device is a target)
+  and the fc_rport
+* Not a child of the fc_rport in sysfs; its parent is the
+  scsi_target.
+
+
+Device Loss
+-------------------------------
+
+If the link between the HBA/CNA/NIC and the switch is
+broken it may be for a short or long period of time. If
+it is short we simply want to disable the discovered
+devices and then enable them when the link is
+re-established. Both the fc_rports and fc_fabrics use
+device loss timers to determine when they can be removed
+from the system.
+
+
+Memory Allocation
+-------------------------------
+
+The FC subsystem allows LLDs to specify a ammount of
+memory that the LLD can use for private data that will
+be associated with the devices that the FC subsystem
+creates.
+
+The fc_port, fc_fabric, fc_rport and fc_vport all allow
+for LLD private data. In addition the SCSI-FCP layer
+allows for LLD private data on the fcp_init device.
+
+libfc/libfcoe/fcoe
+------------------
+
+fc_port/fcoe_interface
+fc_fabric/fcoe_fcf
+fc_vport/fc_lport/fcoe_port
+fc_rport/fc_rport_libfc_priv
+
+fcp_init/fc_fcp_internal
+
+
+FCoE Attributes / Quirks
+-------------------------------
+
+Attributes
+----------
+
+FCoE attributes are added to FC subsystem devices if
+the LLD chooses to.
+
+The fc_port, fc_fabric and fc_vport devices all have
+FCoE attributes that can be added if desired.
+
+
+Multiple fc_fabrics
+-------------------
+
+Since FCoE discovers FCFs there needs to be a way to
+determine if a discovered FCF was previously discovered
+or not, otherwise the fc_port's list of fc_fabrics could
+contain duplicate entries.
+
+There isn't really any good FC attribute that can be used
+to uniquely identify a fc_fabric. Also, traditional FC HBAs
+will only add one fc_fabric to the system. This means that
+duplicate fc_fabrics is only a problem for FCoE HBA/CNA/NICs.
+
+The solution is for the LLD to provide a fabric_match
+callback that the FC subsystem can use to see if two
+fc_fabrics are really the same instance. This allows each
+LLD to match fc_fabrics however it wants. For FCoE LLDs
+it allows them to check FCoE attributes when looking
+for duplicates.
diff --git a/Documentation/fc/libfc_libfcoe_fcoe.txt b/Documentation/fc/libfc_libfcoe_fcoe.txt
new file mode 100644
index 0000000..a0b9901
--- /dev/null
+++ b/Documentation/fc/libfc_libfcoe_fcoe.txt
@@ -0,0 +1,17 @@
+libfc/libfcoe/fcoe Usage
+-------------------------------
+
+Every FC device created is created and added to the
+system with the same fc.h function: fc_port_add,
+fc_fabric_add, etc... Unfortunately, libfc/libfcoe/fcoe
+needs the fc_lport instance before a fc_fabric is
+discovered. Since the fc_lport is created with the
+fc_vport it needs to be allocated before FCF discovery.
+
+Because of this the fc_vport_add and fc_vport_del
+routines only add and remove an instance from sysfs.
+The fc_vport_alloc and fc_vport_free routines are used
+to simply allocate and free a fc_vport instance. This
+allows libfc/libfcoe/fcoe to allocate a fc_vport/fc_lport
+early and add that fc_vport to the system once it has
+logged into the fabric.

