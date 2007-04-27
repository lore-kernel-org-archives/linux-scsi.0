From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH][REPOST] FC Transport support for vports based on NPIV
Date: Fri, 27 Apr 2007 12:41:09 -0400
Message-ID: <1177692070.26084.17.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61955 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbXD0PUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2007 11:20:18 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3RFKGsc026476
	for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 08:20:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

uh - with the patch this time... :) 

The repost does not change anything. It simply updates the patch so
it can be applied cleanly after the "make all rports wait dev_loss_tmo"
patch which was just posted.

------

This patch provides support for FC virtual ports based on NPIV.
For information on the interfaces and design, please read the
Documentation/scsi/scsi_fc_transport.txt file enclosed within
the patch.

The RFC was originally posted here:
http://marc.info/?l=linux-scsi&m=117226959918393&w=2

Changes from the initial RFC:
- Bug fix: needed a transport_class_unregister() for the vport class
- Create a symlink to the vport in the shost device if it is not the
    parent of the vport.
- Made symbolic name writable so it can be set after creation
- Made the temporary fc_vport_identifiers struct private to the
transport.
- Deleted the vport_id field from the vport. I couldn't find any good
  use for it (and symname is a good replacement).
- Made the vport_state and vport_last_state "private" attributes.
  Added the fc_vport_set_state() helper function to manage state
  transitions
- Updated vport_create() to allow a vport to be created in a disabled
  state.
- Added INITIALIZING and FAILED vport states
- Added VPCERR_xxx defines for errors to be returned from vport_create()
- Created a Documentation/scsi/scsi_fc_transport.txt file that describes
  the interfaces and expected LLDD behaviors. 

-- james


Signed-off-by: James Smart <James.Smart@emulex.com>




diff -upNr b.devloss/Documentation/scsi/scsi_fc_transport.txt b/Documentation/scsi/scsi_fc_transport.txt
--- b.devloss/Documentation/scsi/scsi_fc_transport.txt	1969-12-31 19:00:00.000000000 -0500
+++ b/Documentation/scsi/scsi_fc_transport.txt	2007-04-20 09:32:38.000000000 -0400
@@ -0,0 +1,450 @@
+                             SCSI FC Tansport
+                 =============================================
+
+Date:  4/12/2007
+Kernel Revisions for features:
+  rports : <<TBS>>
+  vports : 2.6.22 (? TBD)
+
+
+Introduction
+============
+This file documents the features and components of the SCSI FC Transport.
+It also provides documents the API between the transport and FC LLDDs.
+The FC transport can be found at:
+  drivers/scsi/scsi_transport_fc.c
+  include/scsi/scsi_transport_fc.h
+  include/scsi/scsi_netlink_fc.h
+
+This file is found at Documentation/scsi/scsi_fc_transport.txt
+
+
+FC Remote Ports (rports)
+========================================================================
+<< To Be Supplied >>
+
+
+FC Virtual Ports (vports)
+========================================================================
+
+Overview:
+-------------------------------
+
+  New FC standards have defined mechanisms which allows for a single physical
+  port to appear on as multiple communication ports. Using the N_Port Id 
+  Virtualization (NPIV) mechanism, a point-to-point connection to a Fabric
+  can be assigned more than 1 N_Port_ID.  Each N_Port_ID appears as a
+  separate port to other endpoints on the fabric, even though it shares one
+  physical link to the switch for communication. Each N_Port_ID can have a
+  unique view of the fabric based on fabric zoning and array lun-masking
+  (just like a normal non-NPIV adapter).  Using the Virtual Fabric (VF)
+  mechanism, adding a fabric header to each frame allows the port to 
+  interact with the Fabric Port to join multiple fabrics. The port will
+  obtain an N_Port_ID on each fabric it joins. Each fabric will have its
+  own unique view of endpoints and configuration parameters.  NPIV may be
+  used together with VF so that the port can obtain multiple N_Port_IDs
+  on each virtual fabric.
+
+  The FC transport is now recognizing a new object - a vport.  A vport is
+  an entity that has a world-wide unique World Wide Port Name (wwpn) and
+  World Wide Node Name (wwnn). The transport also allows for the FC4's to
+  be specified for the vport, with FCP_Initiator being the primary role
+  expected. Once instantiated by one of the above methods, it will have a
+  distinct N_Port_ID and view of fabric endpoints and storage entities.
+  The fc_host associated with the physical adapter will export the ability
+  to create vports. The transport will create the vport object within the
+  Linux device tree, and instruct the fc_host's driver to instantiate the
+  virtual port. Typically, the driver will create a new scsi_host instance
+  on the vport, resulting in a unique <H,C,T,L> namespace for the vport.
+  Thus, whether a FC port is based on a physical port or on a virtual port,
+  each will appear as a unique scsi_host with its own target and lun space.
+
+  Note: At this time, the transport is written to create only NPIV-based
+    vports. However, consideration was given to VF-based vports and it
+    should be a minor change to add support if needed.  The remaining
+    discussion will concentrate on NPIV.
+
+  Note: World Wide Name assignment (and uniqueness guarantees) are left
+    up to an administrative entity controling the vport. For example,
+    if vports are to be associated with virtual machines, a XEN mgmt
+    utility would be responsible for creating wwpn/wwnn's for the vport,
+    using it's own naming authority and OUI. (Note: it already does this
+    for virtual MAC addresses).
+
+
+Device Trees and Vport Objects:
+-------------------------------
+
+  Today, the device tree typically contains the scsi_host object,
+  with rports and scsi target objects underneath it. Currently the FC
+  transport creates the vport object and places it under the scsi_host
+  object corresponding to the physical adapter.  The LLDD will allocate
+  a new scsi_host for the vport and link it's object under the vport.
+  The remainder of the tree under the vports scsi_host is the same
+  as the non-NPIV case. The transport is written currently to easily
+  allow the parent of the vport to be something other than the scsi_host.
+  This could be used in the future to link the object onto a vm-specific
+  device tree. If the vport's parent is not the physical port's scsi_host,
+  a symbolic link to the vport object will be placed in the physical
+  port's scsi_host.
+
+  Here's what to expect in the device tree :
+   The typical Physical Port's Scsi_Host:
+     /sys/devices/.../host17/
+   and it has the typical decendent tree:
+     /sys/devices/.../host17/rport-17:0-0/target17:0:0/17:0:0:0:
+   and then the vport is created on the Physical Port:
+     /sys/devices/.../host17/vport-17:0-0
+   and the vport's Scsi_Host is then created:
+     /sys/devices/.../host17/vport-17:0-0/host18
+   and then the rest of the tree progresses, such as:
+     /sys/devices/.../host17/vport-17:0-0/host18/rport-18:0-0/target18:0:0/18:0:0:0:
+
+  Here's what to expect in the sysfs tree :
+   scsi_hosts:
+     /sys/class/scsi_host/host17                physical port's scsi_host
+     /sys/class/scsi_host/host18                vport's scsi_host
+   fc_hosts:
+     /sys/class/fc_host/host17                  physical port's fc_host
+     /sys/class/fc_host/host18                  vport's fc_host
+   fc_vports:
+     /sys/class/fc_vports/vport-17:0-0          the vport's fc_vport
+   fc_rports:
+     /sys/class/fc_remote_ports/rport-17:0-0    rport on the physical port
+     /sys/class/fc_remote_ports/rport-18:0-0    rport on the vport
+ 
+
+Vport Attributes:
+-------------------------------
+
+  The new fc_vport class object has the following attributes
+
+     node_name:							Read_Only
+       The WWNN of the vport
+
+     port_name:							Read_Only
+       The WWPN of the vport
+
+     roles:							Read_Only
+       Indicates the FC4 roles enabled on the vport.
+
+     symbolic_name:						Read_Write
+       A string, appended to the driver's symbolic port name string, which
+       is registered with the switch to identify the vport. For example,
+       a hypervisor could set this string to "Xen Domain 2 VM 5 Vport 2",
+       and this set of identifiers can be seen on switch management screens
+       to identify the port.
+
+     vport_delete:						Write_Only
+       When written with a "1", will tear down the vport.
+
+     vport_disable:						Write_Only
+       When written with a "1", will transition the vport to a disabled.
+       state.  The vport will still be instantiated with the Linux kernel,
+       but it will not be active on the FC link.
+       When written with a "0", will enable the vport.
+
+     vport_last_state:						Read_Only
+       Indicates the previous state of the vport.  See the section below on
+       "Vport States".
+
+     vport_state:						Read_Only
+       Indicates the state of the vport.  See the section below on
+       "Vport States".
+
+     vport_type:						Read_Only
+       Reflects the FC mechanism used to create the virtual port.
+       Only NPIV is supported currently.
+
+
+  For the fc_host class object, the following attributes are added for vports:
+
+     max_npiv_vports:						Read_Only
+       Indicates the maximum number of NPIV-based vports that the
+       driver/adapter can support on the fc_host.
+
+     npiv_vports_inuse:						Read_Only
+       Indicates how many NPIV-based vports have been instantiated on the
+       fc_host.
+
+     vport_create:						Write_Only
+       A "simple" create interface to instantiate a vport on an fc_host.
+       A "<WWPN>:<WWNN>" string is written to the attribute. The transport
+       then instantiates the vport object and calls the LLDD to create the
+       vport with the role of FCP_Initiator.  Each WWN is specified as 16
+       hex characters and may *not* contain any prefixes (e.g. 0x, x, etc).
+
+     vport_delete:						Write_Only
+        A "simple" delete interface to teardown a vport. A "<WWPN>:<WWNN>"
+	string is written to the attribute. The transport will locate the
+	vport on the fc_host with the same WWNs and tear it down.  Each WWN
+	is specified as 16 hex characters and may *not* contain any prefixes
+	(e.g. 0x, x, etc).
+
+
+Vport States:
+-------------------------------
+
+  Vport instantiation consists of two parts:
+    - Creation with the kernel and LLDD. This means all transport and
+      driver data structures are built up, and device objects created.
+      This is equivalent to a driver "attach" on an adapter, which is
+      independent of the adapter's link state.
+    - Instantiation of the vport on the FC link via ELS traffic, etc.
+      This is equivalent to a "link up" and successfull link initialization.
+  Futher information can be found in the interfaces section below for
+  Vport Creation.
+
+  Once a vport has been instantiated with the kernel/LLDD, a vport state
+  can be reported via the sysfs attribute. The following states exist:
+
+    FC_VPORT_UNKNOWN		- Unknown
+      An temporary state, typically set only while the vport is being
+      instantiated with the kernel and LLDD.
+
+    FC_VPORT_ACTIVE		- Active
+      The vport has been successfully been created on the FC link.
+      It is fully functional.
+
+    FC_VPORT_DISABLED		- Disabled
+      The vport instantiated, but "disabled". The vport is not instantiated
+      on the FC link. This is equivalent to a physical port with the
+      link "down". 
+
+    FC_VPORT_LINKDOWN		- Linkdown
+      The vport is not operational as the physical link is not operational.
+
+    FC_VPORT_INITIALIZING	- Initializing
+      The vport is in the process of instantiating on the FC link.
+      The LLDD will set this state just prior to starting the ELS traffic
+      to create the vport. This state will persist until the vport is
+      successfully created (state becomes FC_VPORT_ACTIVE) or it fails
+      (state is one of the values below).  As this state is transitory,
+      it will not be preserved in the "vport_last_state".
+
+    FC_VPORT_NO_FABRIC_SUPP	- No Fabric Support
+      The vport is not operational. One of the following conditions were
+      encountered:
+       - The FC topology is not Point-to-Point
+       - The FC port is not connected to an F_Port
+       - The F_Port has indicated that NPIV is not supported.
+
+    FC_VPORT_NO_FABRIC_RSCS	- No Fabric Resources
+      The vport is not operational. The Fabric failed FDISC with a status
+      indicating that it does not have sufficient resources to complete
+      the operation.
+ 
+    FC_VPORT_FABRIC_LOGOUT	- Fabric Logout
+      The vport is not operational. The Fabric has LOGO'd the N_Port_ID
+      associated with the vport.
+
+    FC_VPORT_FABRIC_REJ_WWN	- Fabric Rejected WWN
+      The vport is not operational. The Fabric failed FDISC with a status
+      indicating that the WWN's are not valid.
+
+    FC_VPORT_FAILED		- VPort Failed
+      The vport is not operational. This is a catchall for all other
+      error conditions.
+
+
+  The following state table indicates the different state transitions:
+
+    State              Event				New State
+    --------------------------------------------------------------------
+     n/a  		Initialization			Unknown
+    Unknown:		Link Down			Linkdown
+                        Link Up & Loop			No Fabric Support
+			Link Up & no Fabric		No Fabric Support
+			Link Up & FLOGI response	No Fabric Support
+			  indicates no NPIV support
+      			Link Up & FDISC being sent	Initializing
+			Disable request			Disable
+    Linkdown:		Link Up				Unknown
+    Initializing:	FDISC ACC			Active
+			FDISC LS_RJT w/ no resources	No Fabric Resources
+			FDISC LS_RJT w/ invalid		Fabric Rejected WWN
+			  pname or invalid nport_id
+			FDISC LS_RJT failed for		Vport Failed
+			  other reasons
+      			Link Down			Linkdown
+			Disable request			Disable
+    Disable:		Enable request			Unknown
+    Active:		LOGO received from fabric	Fabric Logout
+    			Link Down			Linkdown
+			Disable request			Disable
+    Fabric Logout:	Link still up			Unknown
+
+         The following 4 error states all have the same transitions:
+    No Fabric Support:
+    No Fabric Resources:
+    Fabric Rejected WWN:
+    Vport Failed:	
+    			Disable request			Disable
+    			Link goes down			Linkdown
+
+
+Transport <-> LLDD Interfaces :
+-------------------------------
+
+Vport support by LLDD:
+
+  The LLDD indicates support for vports by supplying a vport_create()
+  function in the transport template.  The presense of this function will
+  cause the creation of the new attributes on the fc_host.  As part of
+  the physical port completing its initialization relative to the 
+  transport, it should set the max_npiv_vports attribute to indicate the
+  maximum number of vports the driver and/or adapter supports.
+
+
+Vport Creation:
+
+  The LLDD vport_create() syntax is:
+
+      int vport_create(struct fc_vport *vport, bool disable)
+
+    where:
+      vport:	Is the newly allocated vport object
+      disable:	If "true", the vport is to be created in a disabled stated.
+      		If "false", the vport is to be enabled upon creation.
+
+  When a request is made to create a new vport (via sgio/netlink, or the
+  vport_create fc_host attribute), the transport will validate that the LLDD
+  can support another vport (e.g. max_npiv_vports > npiv_vports_inuse).
+  If not, the create request will be failed.  If space remains, the transport
+  will increment the vport count, create the vport object, and then call the
+  LLDD's vport_create() function with the newly allocated vport object.
+
+  As mentioned above, vport creation is divided into two parts:
+    - Creation with the kernel and LLDD. This means all transport and
+      driver data structures are built up, and device objects created.
+      This is equivalent to a driver "attach" on an adapter, which is
+      independent of the adapter's link state.
+    - Instantiation of the vport on the FC link via ELS traffic, etc.
+      This is equivalent to a "link up" and successfull link initialization.
+
+  The LLDD's vport_create() function will not synchronously wait for both
+  parts to be fully completed before returning. It must validate that the
+  infrastructure exists to support NPIV, and complete the first part of
+  vport creation (data structure build up) before returning.  We do not
+  hinge vport_create() on the link-side operation mainly because:
+    - The link may be down. It is not a failure if it is. It simply
+      means the vport is in an inoperable state until the link comes up.
+      This is consistent with the link bouncing post vport creation.
+    - The vport may be created in a disabled state.
+    - This is consistent with a model where:  the vport equates to a
+      FC adapter. The vport_create is synonymous with driver attachment
+      to the adapter, which is independent of link state.
+ 
+    Note: special error codes have been defined to delineate infrastructure
+      failure cases for quicker resolution.
+
+  The expected behavior for the LLDD's vport_create() function is:
+    - Validate Infrastructure:
+        - If the driver or adapter cannot support another vport, whether
+            due to improper firmware, (a lie about) max_npiv, or a lack of
+	    some other resource - return VPCERR_UNSUPPORTED.  
+        - If the driver validates the WWN's against those already active on
+            the adapter and detects an overlap - return VPCERR_BAD_WWN.
+        - If the driver detects the topology is loop, non-fabric, or the
+            FLOGI did not support NPIV - return VPCERR_NO_FABRIC_SUPP.
+    - Allocate data structures. If errors are encountered, such as out
+        of memory conditions, return the respective negative Exxx error code.
+    - If the role is FCP Initiator, the LLDD is to :
+        - Call scsi_host_alloc() to allocate a scsi_host for the vport.
+	- Call scsi_add_host(new_shost, &vport->dev) to start the scsi_host
+	  and bind it as a child of the vport device.
+	- Initializes the fc_host attribute values.
+    - Kick of further vport state transitions based on the disable flag and
+        link state - and return success (zero).
+
+  LLDD Implementers Notes:
+  - It is suggested that there be a different fc_function_templates for
+    the physical port and the virtual port.  The physical port's template
+    would have the vport_create, vport_delete, and vport_disable functions,
+    while the vports would not.
+  - It is suggested that there be different scsi_host_templates
+    for the physical port and virtual port. Likely, there are driver
+    attributes, embedded into the scsi_host_template, that are applicable
+    for the physical port only (link speed, topology setting, etc). This
+    ensures that the attributes are applicable to the respective scsi_host.
+
+
+Vport Disable/Enable:
+
+  The LLDD vport_disable() syntax is:
+
+      int vport_disable(struct fc_vport *vport, bool disable)
+
+    where:
+      vport:	Is vport to to be enabled or disabled
+      disable:	If "true", the vport is to be disabled.
+      		If "false", the vport is to be enabled.
+
+  When a request is made to change the disabled state on a vport, the
+  transport will validate the request against the existing vport state.
+  If the request is to disable and the vport is already disabled, the
+  request will fail. Similarly, if the request is to enable, and the
+  vport is not in a disabled state, the request will fail.  If the request
+  is valid for the vport state, the transport will call the LLDD to
+  change the vport's state.
+
+  Within the LLDD, if a vport is disabled, it remains instantiated with
+  the kernel and LLDD, but it is not active or visible on the FC link in
+  any way. (see Vport Creation and the 2 part instantiation discussion).
+  The vport will remain in this state until it is deleted or re-enabled.
+  When enabling a vport, the LLDD reinstantiates the vport on the FC
+  link - essentially restarting the LLDD statemachine (see Vport States
+  above).
+
+
+Vport Deletion:
+
+  The LLDD vport_delete() syntax is:
+
+      int vport_delete(struct fc_vport *vport)
+
+    where:
+      vport:	Is vport to delete
+
+  When a request is made to delete a vport (via sgio/netlink, or via the
+  fc_host or fc_vport vport_delete attributes), the transport will call
+  the LLDD to terminate the vport on the FC link, and teardown all other
+  datastructures and references.  If the LLDD completes successfully,
+  the transport will teardown the vport objects and complete the vport
+  removal.  If the LLDD delete request fails, the vport object will remain,
+  but will be in an indeterminate state.
+
+  Within the LLDD, the normal code paths for a scsi_host teardown should
+  be followed. E.g. If the vport has a FCP Initiator role, the LLDD
+  will call fc_remove_host() for the vports scsi_host, followed by 
+  scsi_remove_host() and scsi_host_put() for the vports scsi_host.
+
+
+Other:
+  fc_host port_type attribute:
+    There is a new fc_host port_type value - FC_PORTTYPE_NPIV. This value
+    must be set on all vport-based fc_hosts.  Normally, on a physical port,
+    the port_type attribute would be set to NPORT, NLPORT, etc based on the
+    topology type and existence of the fabric. As this is not applicable to
+    a vport, it makes more sense to report the FC mechanism used to create
+    the vport.
+
+  Driver unload:
+    FC drivers are required to call fc_remove_host() prior to calling
+    scsi_remove_host().  This allows the fc_host to tear down all remote
+    ports prior the scsi_host being torn down.  The fc_remove_host() call
+    was updated to remove all vports for the fc_host as well.
+
+
+Credits
+=======
+The following people have contributed to this document:
+
+
+
+
+
+
+James Smart
+james.smart@emulex.com
+
diff -upNr b.devloss/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- b.devloss/drivers/scsi/scsi_transport_fc.c	2007-04-20 08:53:52.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2007-04-20 09:58:05.000000000 -0400
@@ -19,7 +19,7 @@
  *
  *  ========
  *
- *  Copyright (C) 2004-2005   James Smart, Emulex Corporation
+ *  Copyright (C) 2004-2007   James Smart, Emulex Corporation
  *    Rewrite for host, target, device, and remote port attributes,
  *    statistics, and service functions...
  *
@@ -39,6 +39,33 @@
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
 
 /*
+ * This is a temporary carrier for creating a vport. It will eventually
+ * be replaced  by a real message definition for sgio or netlink.
+ *
+ * fc_vport_identifiers: This set of data contains all elements
+ * to uniquely identify and instantiate a FC virtual port.
+ *
+ * Notes:
+ *   symbolic_name: The driver is to append the symbolic_name string data
+ *      to the symbolic_node_name data that it generates by default.
+ *      the resulting combination should then be registered with the switch.
+ *      It is expected that things like Xen may stuff a VM title into
+ *      this field.
+ */
+struct fc_vport_identifiers {
+	u64 node_name;
+	u64 port_name;
+	u32 roles;
+	bool disable;
+	enum fc_port_type vport_type;	/* only FC_PORTTYPE_NPIV allowed */ 
+	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
+};
+
+static int fc_vport_create(struct Scsi_Host *shost, int channel,
+	struct device *pdev, struct fc_vport_identifiers  *ids,
+	struct fc_vport **vport);
+
+/*
  * Redefine so that we can have same named attributes in the
  * sdev/starget/host objects.
  */
@@ -90,10 +117,14 @@ static struct {
 	{ FC_PORTTYPE_NLPORT,	"NLPort (fabric via loop)" },
 	{ FC_PORTTYPE_LPORT,	"LPort (private loop)" },
 	{ FC_PORTTYPE_PTP,	"Point-To-Point (direct nport connection" },
+	{ FC_PORTTYPE_NPIV,		"NPIV VPORT" },
 };
 fc_enum_name_search(port_type, fc_port_type, fc_port_type_names)
 #define FC_PORTTYPE_MAX_NAMELEN		50
 
+/* Reuse fc_port_type enum function for vport_type */
+#define get_fc_vport_type_name get_fc_port_type_name
+
 
 /* Convert fc_host_event_code values to ascii string name */
 static const struct {
@@ -139,6 +170,29 @@ fc_enum_name_search(port_state, fc_port_
 #define FC_PORTSTATE_MAX_NAMELEN	20
 
 
+/* Convert fc_vport_state values to ascii string name */
+static struct {
+	enum fc_vport_state	value;
+	char			*name;
+} fc_vport_state_names[] = {
+	{ FC_VPORT_UNKNOWN,		"Unknown" },
+	{ FC_VPORT_ACTIVE,		"Active" },
+	{ FC_VPORT_DISABLED,		"Disabled" },
+	{ FC_VPORT_LINKDOWN,		"Linkdown" },
+	{ FC_VPORT_INITIALIZING,	"Initializing" },
+	{ FC_VPORT_NO_FABRIC_SUPP,	"No Fabric Support" },
+	{ FC_VPORT_NO_FABRIC_RSCS,	"No Fabric Resources" },
+	{ FC_VPORT_FABRIC_LOGOUT,	"Fabric Logout" },
+	{ FC_VPORT_FABRIC_REJ_WWN,	"Fabric Rejected WWN" },
+	{ FC_VPORT_FAILED,		"VPort Failed" },
+};
+fc_enum_name_search(vport_state, fc_vport_state, fc_vport_state_names)
+#define FC_VPORTSTATE_MAX_NAMELEN	24
+
+/* Reuse fc_vport_state enum function for vport_last_state */
+#define get_fc_vport_last_state_name get_fc_vport_state_name
+
+
 /* Convert fc_tgtid_binding_type values to ascii string name */
 static const struct {
 	enum fc_tgtid_binding_type	value;
@@ -219,16 +273,16 @@ show_fc_fc4s (char *buf, u8 *fc4_list)
 }
 
 
-/* Convert FC_RPORT_ROLE bit values to ascii string name */
+/* Convert FC_PORT_ROLE bit values to ascii string name */
 static const struct {
 	u32 			value;
 	char			*name;
-} fc_remote_port_role_names[] = {
-	{ FC_RPORT_ROLE_FCP_TARGET,	"FCP Target" },
-	{ FC_RPORT_ROLE_FCP_INITIATOR,	"FCP Initiator" },
-	{ FC_RPORT_ROLE_IP_PORT,	"IP Port" },
+} fc_port_role_names[] = {
+	{ FC_PORT_ROLE_FCP_TARGET,	"FCP Target" },
+	{ FC_PORT_ROLE_FCP_INITIATOR,	"FCP Initiator" },
+	{ FC_PORT_ROLE_IP_PORT,		"IP Port" },
 };
-fc_bitfield_name_search(remote_port_roles, fc_remote_port_role_names)
+fc_bitfield_name_search(port_roles, fc_port_role_names)
 
 /*
  * Define roles that are specific to port_id. Values are relative to ROLE_MASK.
@@ -252,7 +306,8 @@ static void fc_scsi_scan_rport(struct wo
  */
 #define FC_STARGET_NUM_ATTRS 	3
 #define FC_RPORT_NUM_ATTRS	10
-#define FC_HOST_NUM_ATTRS	17
+#define FC_VPORT_NUM_ATTRS	9
+#define FC_HOST_NUM_ATTRS	21
 
 struct fc_internal {
 	struct scsi_transport_template t;
@@ -278,6 +333,10 @@ struct fc_internal {
 	struct transport_container rport_attr_cont;
 	struct class_device_attribute private_rport_attrs[FC_RPORT_NUM_ATTRS];
 	struct class_device_attribute *rport_attrs[FC_RPORT_NUM_ATTRS + 1];
+
+	struct transport_container vport_attr_cont;
+	struct class_device_attribute private_vport_attrs[FC_VPORT_NUM_ATTRS];
+	struct class_device_attribute *vport_attrs[FC_VPORT_NUM_ATTRS + 1];
 };
 
 #define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
@@ -331,6 +390,7 @@ static int fc_host_setup(struct transpor
 		sizeof(fc_host->supported_fc4s));
 	fc_host->supported_speeds = FC_PORTSPEED_UNKNOWN;
 	fc_host->maxframe_size = -1;
+	fc_host->max_npiv_vports = 0;
 	memset(fc_host->serial_number, 0,
 		sizeof(fc_host->serial_number));
 
@@ -348,8 +408,11 @@ static int fc_host_setup(struct transpor
 
 	INIT_LIST_HEAD(&fc_host->rports);
 	INIT_LIST_HEAD(&fc_host->rport_bindings);
+	INIT_LIST_HEAD(&fc_host->vports);
 	fc_host->next_rport_number = 0;
 	fc_host->next_target_id = 0;
+	fc_host->next_vport_number = 0;
+	fc_host->npiv_vports_inuse = 0;
 
 	snprintf(fc_host->work_q_name, KOBJ_NAME_LEN, "fc_wq_%d",
 		shost->host_no);
@@ -388,6 +451,16 @@ static DECLARE_TRANSPORT_CLASS(fc_rport_
 			       NULL);
 
 /*
+ * Setup and Remove actions for virtual ports are handled
+ * in the service functions below.
+ */
+static DECLARE_TRANSPORT_CLASS(fc_vport_class,
+			       "fc_vports",
+			       NULL,
+			       NULL,
+			       NULL);
+
+/*
  * Module Parameters
  */
 
@@ -585,6 +658,9 @@ static __init int fc_transport_init(void
 	error = transport_class_register(&fc_host_class);
 	if (error)
 		return error;
+	error = transport_class_register(&fc_vport_class);
+	if (error)
+		return error;
 	error = transport_class_register(&fc_rport_class);
 	if (error)
 		return error;
@@ -596,6 +672,7 @@ static void __exit fc_transport_exit(voi
 	transport_class_unregister(&fc_transport_class);
 	transport_class_unregister(&fc_rport_class);
 	transport_class_unregister(&fc_host_class);
+	transport_class_unregister(&fc_vport_class);
 }
 
 /*
@@ -800,9 +877,9 @@ show_fc_rport_roles (struct class_device
 			return snprintf(buf, 30, "Unknown Fabric Entity\n");
 		}
 	} else {
-		if (rport->roles == FC_RPORT_ROLE_UNKNOWN)
+		if (rport->roles == FC_PORT_ROLE_UNKNOWN)
 			return snprintf(buf, 20, "unknown\n");
-		return get_fc_remote_port_roles_names(rport->roles, buf);
+		return get_fc_port_roles_names(rport->roles, buf);
 	}
 }
 static FC_CLASS_DEVICE_ATTR(rport, roles, S_IRUGO,
@@ -857,7 +934,7 @@ static FC_CLASS_DEVICE_ATTR(rport, fast_
 
 /*
  * Note: in the target show function we recognize when the remote
- *  port is in the hierarchy and do not allow the driver to get
+ *  port is in the heirarchy and do not allow the driver to get
  *  involved in sysfs functions. The driver only gets involved if
  *  it's the "old" style that doesn't use rports.
  */
@@ -912,6 +989,260 @@ fc_starget_rd_attr(port_id, "0x%06x\n", 
 
 
 /*
+ * FC Virtual Port Attribute Management
+ */
+
+#define fc_vport_show_function(field, format_string, sz, cast)		\
+static ssize_t								\
+show_fc_vport_##field (struct class_device *cdev, char *buf)		\
+{									\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	struct Scsi_Host *shost = vport_to_shost(vport);		\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	if ((i->f->get_vport_##field) &&				\
+	    !(vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)))	\
+		i->f->get_vport_##field(vport);				\
+	return snprintf(buf, sz, format_string, cast vport->field); 	\
+}
+
+#define fc_vport_store_function(field)					\
+static ssize_t								\
+store_fc_vport_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	int val;							\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	struct Scsi_Host *shost = vport_to_shost(vport);		\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	char *cp;							\
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))	\
+		return -EBUSY;						\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
+	i->f->set_vport_##field(vport, val);				\
+	return count;							\
+}
+
+#define fc_vport_store_str_function(field, slen)			\
+static ssize_t								\
+store_fc_vport_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	struct Scsi_Host *shost = vport_to_shost(vport);		\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	unsigned int cnt=count;						\
+									\
+	/* count may include a LF at end of string */			\
+	if (buf[cnt-1] == '\n')						\
+		cnt--;							\
+	if (cnt > ((slen) - 1))						\
+		return -EINVAL;						\
+	memcpy(vport->field, buf, cnt);					\
+	i->f->set_vport_##field(vport);					\
+	return count;							\
+}
+
+#define fc_vport_rd_attr(field, format_string, sz)			\
+	fc_vport_show_function(field, format_string, sz, )		\
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO,			\
+			 show_fc_vport_##field, NULL)
+
+#define fc_vport_rd_attr_cast(field, format_string, sz, cast)		\
+	fc_vport_show_function(field, format_string, sz, (cast))	\
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO,			\
+			  show_fc_vport_##field, NULL)
+
+#define fc_vport_rw_attr(field, format_string, sz)			\
+	fc_vport_show_function(field, format_string, sz, )		\
+	fc_vport_store_function(field)					\
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO | S_IWUSR,		\
+			show_fc_vport_##field,				\
+			store_fc_vport_##field)
+
+#define fc_private_vport_show_function(field, format_string, sz, cast)	\
+static ssize_t								\
+show_fc_vport_##field (struct class_device *cdev, char *buf)		\
+{									\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	return snprintf(buf, sz, format_string, cast vport->field); 	\
+}
+
+#define fc_private_vport_store_u32_function(field)			\
+static ssize_t								\
+store_fc_vport_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	u32 val;							\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	char *cp;							\
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))		\
+		return -EBUSY;						\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if (*cp && (*cp != '\n'))					\
+		return -EINVAL;						\
+	vport->field = val;						\
+	return count;							\
+}
+
+
+#define fc_private_vport_rd_attr(field, format_string, sz)		\
+	fc_private_vport_show_function(field, format_string, sz, )	\
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO,			\
+			 show_fc_vport_##field, NULL)
+
+#define fc_private_vport_rd_attr_cast(field, format_string, sz, cast)	\
+	fc_private_vport_show_function(field, format_string, sz, (cast)) \
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO,			\
+			  show_fc_vport_##field, NULL)
+
+#define fc_private_vport_rw_u32_attr(field, format_string, sz)		\
+	fc_private_vport_show_function(field, format_string, sz, )	\
+	fc_private_vport_store_u32_function(field)			\
+static FC_CLASS_DEVICE_ATTR(vport, field, S_IRUGO | S_IWUSR,		\
+			show_fc_vport_##field,				\
+			store_fc_vport_##field)
+
+
+#define fc_private_vport_rd_enum_attr(title, maxlen)			\
+static ssize_t								\
+show_fc_vport_##title (struct class_device *cdev, char *buf)		\
+{									\
+	struct fc_vport *vport = transport_class_to_vport(cdev);	\
+	const char *name;						\
+	name = get_fc_##title##_name(vport->title);			\
+	if (!name)							\
+		return -EINVAL;						\
+	return snprintf(buf, maxlen, "%s\n", name);			\
+}									\
+static FC_CLASS_DEVICE_ATTR(vport, title, S_IRUGO,			\
+			show_fc_vport_##title, NULL)
+
+
+#define SETUP_VPORT_ATTRIBUTE_RD(field)					\
+	i->private_vport_attrs[count] = class_device_attr_vport_##field; \
+	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_vport_attrs[count].store = NULL;			\
+	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	if (i->f->get_##field)						\
+		count++
+	/* NOTE: Above MACRO differs: checks function not show bit */
+
+#define SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(field)				\
+	i->private_vport_attrs[count] = class_device_attr_vport_##field; \
+	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_vport_attrs[count].store = NULL;			\
+	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	count++
+
+#define SETUP_VPORT_ATTRIBUTE_WR(field)					\
+	i->private_vport_attrs[count] = class_device_attr_vport_##field; \
+	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	if (i->f->field)						\
+		count++
+	/* NOTE: Above MACRO differs: checks function */
+
+#define SETUP_VPORT_ATTRIBUTE_RW(field)					\
+	i->private_vport_attrs[count] = class_device_attr_vport_##field; \
+	if (!i->f->set_vport_##field) {					\
+		i->private_vport_attrs[count].attr.mode = S_IRUGO;	\
+		i->private_vport_attrs[count].store = NULL;		\
+	}								\
+	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	count++
+	/* NOTE: Above MACRO differs: does not check show bit */
+
+#define SETUP_PRIVATE_VPORT_ATTRIBUTE_RW(field)				\
+{									\
+	i->private_vport_attrs[count] = class_device_attr_vport_##field; \
+	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
+	count++;							\
+}
+
+
+/* The FC Transport Virtual Port Attributes: */
+
+/* Fixed Virtual Port Attributes */
+
+/* Dynamic Virtual Port Attributes */
+
+/* Private Virtual Port Attributes */
+
+fc_private_vport_rd_enum_attr(vport_state, FC_VPORTSTATE_MAX_NAMELEN);
+fc_private_vport_rd_enum_attr(vport_last_state, FC_VPORTSTATE_MAX_NAMELEN);
+fc_private_vport_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
+fc_private_vport_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
+
+static ssize_t
+show_fc_vport_roles (struct class_device *cdev, char *buf)
+{
+	struct fc_vport *vport = transport_class_to_vport(cdev);
+
+	if (vport->roles == FC_PORT_ROLE_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+	return get_fc_port_roles_names(vport->roles, buf);
+}
+static FC_CLASS_DEVICE_ATTR(vport, roles, S_IRUGO, show_fc_vport_roles, NULL);
+
+fc_private_vport_rd_enum_attr(vport_type, FC_PORTTYPE_MAX_NAMELEN);
+
+fc_private_vport_show_function(symbolic_name, "%s\n",
+		FC_VPORT_SYMBOLIC_NAMELEN + 1, )
+fc_vport_store_str_function(symbolic_name, FC_VPORT_SYMBOLIC_NAMELEN)
+static FC_CLASS_DEVICE_ATTR(vport, symbolic_name, S_IRUGO | S_IWUSR,
+		show_fc_vport_symbolic_name, store_fc_vport_symbolic_name);
+
+static ssize_t
+store_fc_vport_delete(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	struct fc_vport *vport = transport_class_to_vport(cdev);
+	int stat;
+
+	stat = fc_vport_terminate(vport);
+	if (stat)
+		return stat;
+
+	return count;
+}
+static FC_CLASS_DEVICE_ATTR(vport, vport_delete, S_IWUSR,
+			NULL, store_fc_vport_delete);
+
+
+/*
+ * Enable/Disable vport
+ *  Write "1" to disable, write "0" to enable
+ */
+static ssize_t
+store_fc_vport_disable(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	struct fc_vport *vport = transport_class_to_vport(cdev);
+	struct Scsi_Host *shost = vport_to_shost(vport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	int stat;
+
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))
+		return -EBUSY;
+
+	if (*buf == '0') {
+		if (vport->vport_state != FC_VPORT_DISABLED)
+			return -EALREADY;
+	} else if (*buf == '1') {
+		if (vport->vport_state == FC_VPORT_DISABLED)
+			return -EALREADY;
+	} else
+		return -EINVAL;
+
+	stat = i->f->vport_disable(vport, ((*buf == '0') ? false : true));
+	return stat ? stat : count;
+}
+static FC_CLASS_DEVICE_ATTR(vport, vport_disable, S_IWUSR,
+			NULL, store_fc_vport_disable);
+
+
+/*
  * Host Attribute Management
  */
 
@@ -1003,6 +1334,13 @@ static FC_CLASS_DEVICE_ATTR(host, title,
 	if (i->f->show_host_##field)					\
 		count++
 
+#define SETUP_HOST_ATTRIBUTE_RD_NS(field)				\
+	i->private_host_attrs[count] = class_device_attr_host_##field;	\
+	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_host_attrs[count].store = NULL;			\
+	i->host_attrs[count] = &i->private_host_attrs[count];		\
+	count++
+
 #define SETUP_HOST_ATTRIBUTE_RW(field)					\
 	i->private_host_attrs[count] = class_device_attr_host_##field;	\
 	if (!i->f->set_host_##field) {					\
@@ -1090,6 +1428,7 @@ fc_private_host_rd_attr_cast(port_name, 
 fc_private_host_rd_attr_cast(permanent_port_name, "0x%llx\n", 20,
 			     unsigned long long);
 fc_private_host_rd_attr(maxframe_size, "%u bytes\n", 20);
+fc_private_host_rd_attr(max_npiv_vports, "%u\n", 20);
 fc_private_host_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
 
 
@@ -1210,6 +1549,9 @@ store_fc_private_host_issue_lip(struct c
 static FC_CLASS_DEVICE_ATTR(host, issue_lip, S_IWUSR, NULL,
 			store_fc_private_host_issue_lip);
 
+fc_private_host_rd_attr(npiv_vports_inuse, "%u\n", 20);
+
+
 /*
  * Host Statistics Management
  */
@@ -1285,7 +1627,6 @@ fc_reset_statistics(struct class_device 
 static FC_CLASS_DEVICE_ATTR(host, reset_statistics, S_IWUSR, NULL,
 				fc_reset_statistics);
 
-
 static struct attribute *fc_statistics_attrs[] = {
 	&class_device_attr_host_seconds_since_last_reset.attr,
 	&class_device_attr_host_tx_frames.attr,
@@ -1316,6 +1657,142 @@ static struct attribute_group fc_statist
 	.attrs = fc_statistics_attrs,
 };
 
+
+/* Host Vport Attributes */
+
+static int
+fc_parse_wwn(const char *ns, u64 *nm)
+{
+	unsigned int i, j;
+	u8 wwn[8];
+
+	memset(wwn, 0, sizeof(wwn));
+
+	/* Validate and store the new name */
+	for (i=0, j=0; i < 16; i++) {
+		if ((*ns >= 'a') && (*ns <= 'f'))
+			j = ((j << 4) | ((*ns++ -'a') + 10));
+		else if ((*ns >= 'A') && (*ns <= 'F'))
+			j = ((j << 4) | ((*ns++ -'A') + 10));
+		else if ((*ns >= '0') && (*ns <= '9'))
+			j = ((j << 4) | (*ns++ -'0'));
+		else
+			return -EINVAL;
+		if (i % 2) {
+			wwn[i/2] = j & 0xff;
+			j = 0;
+		}
+	}
+
+	*nm = wwn_to_u64(wwn);
+
+	return 0;
+}
+
+
+/*
+ * "Short-cut" sysfs variable to create a new vport on a FC Host.
+ * Input is a string of the form "<WWPN>:<WWNN>". Other attributes
+ * will default to a NPIV-based FCP_Initiator; The WWNs are specified
+ * as hex characters, and may *not* contain any prefixes (e.g. 0x, x, etc)
+ */
+static ssize_t
+store_fc_host_vport_create(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct fc_vport_identifiers vid;
+	struct fc_vport *vport;
+	unsigned int cnt=count;
+	int stat;
+
+	memset(&vid, 0, sizeof(vid));
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16+1+16)) || (buf[16] != ':'))
+		return -EINVAL;
+
+	stat = fc_parse_wwn(&buf[0], &vid.port_name);
+	if (stat)
+		return stat;
+
+	stat = fc_parse_wwn(&buf[17], &vid.node_name);
+	if (stat)
+		return stat;
+
+	vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
+	vid.vport_type = FC_PORTTYPE_NPIV;
+	/* vid.symbolic_name is already zero/NULL's */
+	vid.disable = false;		/* always enabled */
+
+	/* we only allow support on Channel 0 !!! */
+	stat = fc_vport_create(shost, 0, &shost->shost_gendev, &vid, &vport);
+	return stat ? stat : count;
+}
+static FC_CLASS_DEVICE_ATTR(host, vport_create, S_IWUSR, NULL,
+			store_fc_host_vport_create);
+
+
+/*
+ * "Short-cut" sysfs variable to delete a vport on a FC Host.
+ * Vport is identified by a string containing "<WWPN>:<WWNN>".
+ * The WWNs are specified as hex characters, and may *not* contain
+ * any prefixes (e.g. 0x, x, etc)
+ */
+static ssize_t
+store_fc_host_vport_delete(struct class_device *cdev, const char *buf,
+			   size_t count)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_vport *vport;
+	u64 wwpn, wwnn;
+	unsigned long flags;
+	unsigned int cnt=count;
+	int stat, match;
+
+	/* count may include a LF at end of string */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16+1+16)) || (buf[16] != ':'))
+		return -EINVAL;
+
+	stat = fc_parse_wwn(&buf[0], &wwpn);
+	if (stat)
+		return stat;
+
+	stat = fc_parse_wwn(&buf[17], &wwnn);
+	if (stat)
+		return stat;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	match = 0;
+	/* we only allow support on Channel 0 !!! */
+	list_for_each_entry(vport, &fc_host->vports, peers) {
+		if ((vport->channel == 0) &&
+		    (vport->port_name == wwpn) && (vport->node_name == wwnn)) {
+			match = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (!match)
+		return -ENODEV; 
+
+	stat = fc_vport_terminate(vport);
+	return stat ? stat : count;
+}
+static FC_CLASS_DEVICE_ATTR(host, vport_delete, S_IWUSR, NULL,
+			store_fc_host_vport_delete);
+
+
 static int fc_host_match(struct attribute_container *cont,
 			  struct device *dev)
 {
@@ -1387,6 +1864,40 @@ static int fc_rport_match(struct attribu
 }
 
 
+static void fc_vport_dev_release(struct device *dev)
+{
+	struct fc_vport *vport = dev_to_vport(dev);
+	put_device(dev->parent);		/* release kobj parent */
+	kfree(vport);
+}
+
+int scsi_is_fc_vport(const struct device *dev)
+{
+	return dev->release == fc_vport_dev_release;
+}
+EXPORT_SYMBOL(scsi_is_fc_vport);
+
+static int fc_vport_match(struct attribute_container *cont,
+			    struct device *dev)
+{
+	struct fc_vport *vport;
+	struct Scsi_Host *shost;
+	struct fc_internal *i;
+
+	if (!scsi_is_fc_vport(dev))
+		return 0;
+	vport = dev_to_vport(dev);
+
+	shost = vport_to_shost(vport);
+	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
+	    != &fc_host_class.class)
+		return 0;
+
+	i = to_fc_internal(shost->transportt);
+	return &i->vport_attr_cont.ac == cont;
+}
+
+
 /**
  * fc_timed_out - FC Transport I/O timeout intercept handler
  *
@@ -1472,6 +1983,11 @@ fc_attach_transport(struct fc_function_t
 	i->rport_attr_cont.ac.match = fc_rport_match;
 	transport_container_register(&i->rport_attr_cont);
 
+	i->vport_attr_cont.ac.attrs = &i->vport_attrs[0];
+	i->vport_attr_cont.ac.class = &fc_vport_class.class;
+	i->vport_attr_cont.ac.match = fc_vport_match;
+	transport_container_register(&i->vport_attr_cont);
+
 	i->f = ft;
 
 	/* Transport uses the shost workq for scsi scanning */
@@ -1505,6 +2021,10 @@ fc_attach_transport(struct fc_function_t
 	SETUP_HOST_ATTRIBUTE_RD(supported_fc4s);
 	SETUP_HOST_ATTRIBUTE_RD(supported_speeds);
 	SETUP_HOST_ATTRIBUTE_RD(maxframe_size);
+	if (ft->vport_create) {
+		SETUP_HOST_ATTRIBUTE_RD_NS(max_npiv_vports);
+		SETUP_HOST_ATTRIBUTE_RD_NS(npiv_vports_inuse);
+	}
 	SETUP_HOST_ATTRIBUTE_RD(serial_number);
 
 	SETUP_HOST_ATTRIBUTE_RD(port_id);
@@ -1520,6 +2040,10 @@ fc_attach_transport(struct fc_function_t
 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
 	if (ft->issue_fc_host_lip)
 		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
+	if (ft->vport_create)
+		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_create);
+	if (ft->vport_delete)
+		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_delete);
 
 	BUG_ON(count > FC_HOST_NUM_ATTRS);
 
@@ -1545,6 +2069,24 @@ fc_attach_transport(struct fc_function_t
 
 	i->rport_attrs[count] = NULL;
 
+	/*
+	 * Setup Virtual Port Attributes.
+	 */
+	count=0;
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_state);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_last_state);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(node_name);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(port_name);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(roles);
+	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_type);
+	SETUP_VPORT_ATTRIBUTE_RW(symbolic_name);
+	SETUP_VPORT_ATTRIBUTE_WR(vport_delete);
+	SETUP_VPORT_ATTRIBUTE_WR(vport_disable);
+
+	BUG_ON(count > FC_VPORT_NUM_ATTRS);
+
+	i->vport_attrs[count] = NULL;
+
 	return &i->t;
 }
 EXPORT_SYMBOL(fc_attach_transport);
@@ -1556,6 +2098,7 @@ void fc_release_transport(struct scsi_tr
 	transport_container_unregister(&i->t.target_attrs);
 	transport_container_unregister(&i->t.host_attrs);
 	transport_container_unregister(&i->rport_attr_cont);
+	transport_container_unregister(&i->vport_attr_cont);
 
 	kfree(i);
 }
@@ -1667,9 +2210,28 @@ fc_flush_devloss(struct Scsi_Host *shost
 void
 fc_remove_host(struct Scsi_Host *shost)
 {
-	struct fc_rport *rport, *next_rport;
+	struct fc_vport *vport = NULL, *next_vport = NULL;
+	struct fc_rport *rport = NULL, *next_rport = NULL;
 	struct workqueue_struct *work_q;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	unsigned long flags;
+	int stat;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	/* Remove any vports */
+	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		/* this must be called synchronously */
+		stat = fc_vport_terminate(vport);
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (stat)
+			dev_printk(KERN_ERR, vport->dev.parent,
+				"%s: %s could not be deleted created via "
+				"shost%d channel %d\n", __FUNCTION__,
+				vport->dev.bus_id, vport->shost->host_no,
+				vport->channel);
+	}
 
 	/* Remove any remote ports */
 	list_for_each_entry_safe(rport, next_rport,
@@ -1686,6 +2248,8 @@ fc_remove_host(struct Scsi_Host *shost)
 		fc_queue_work(shost, &rport->rport_delete_work);
 	}
 
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	/* flush all scan work items */
 	scsi_flush_work(shost);
 
@@ -1844,7 +2408,7 @@ fc_rport_create(struct Scsi_Host *shost,
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	rport->number = fc_host->next_rport_number++;
-	if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
+	if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
 		rport->scsi_target_id = fc_host->next_target_id++;
 	else
 		rport->scsi_target_id = -1;
@@ -1869,7 +2433,7 @@ fc_rport_create(struct Scsi_Host *shost,
 	transport_add_device(dev);
 	transport_configure_device(dev);
 
-	if (rport->roles & FC_RPORT_ROLE_FCP_TARGET) {
+	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
 		/* initiate a scan of the target */
 		rport->flags |= FC_RPORT_SCAN_PENDING;
 		scsi_queue_work(shost, &rport->scan_work);
@@ -2003,7 +2567,7 @@ fc_remote_port_add(struct Scsi_Host *sho
 
 				/* was a target, not in roles */
 				if ((rport->scsi_target_id != -1) &&
-				    (!(ids->roles & FC_RPORT_ROLE_FCP_TARGET)))
+				    (!(ids->roles & FC_PORT_ROLE_FCP_TARGET)))
 					return rport;
 
 				/*
@@ -2086,7 +2650,7 @@ fc_remote_port_add(struct Scsi_Host *sho
 				memset(rport->dd_data, 0,
 						fci->f->dd_fcrport_size);
 
-			if (rport->roles & FC_RPORT_ROLE_FCP_TARGET) {
+			if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
 				/* initiate a scan of the target */
 				rport->flags |= FC_RPORT_SCAN_PENDING;
 				scsi_queue_work(shost, &rport->scan_work);
@@ -2243,11 +2807,11 @@ fc_remote_port_rolechg(struct fc_rport  
 	int create = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (roles & FC_RPORT_ROLE_FCP_TARGET) {
+	if (roles & FC_PORT_ROLE_FCP_TARGET) {
 		if (rport->scsi_target_id == -1) {
 			rport->scsi_target_id = fc_host->next_target_id++;
 			create = 1;
-		} else if (!(rport->roles & FC_RPORT_ROLE_FCP_TARGET))
+		} else if (!(rport->roles & FC_PORT_ROLE_FCP_TARGET))
 			create = 1;
 	}
 
@@ -2317,7 +2881,7 @@ fc_timeout_deleted_rport(struct work_str
 	 */
 	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
 	    (rport->scsi_target_id != -1) &&
-	    !(rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
+	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
 		dev_printk(KERN_ERR, &rport->dev,
 			"blocked FC remote port time out: no longer"
 			" a FCP target, removing starget\n");
@@ -2367,7 +2931,7 @@ fc_timeout_deleted_rport(struct work_str
 	 */
 	rport->maxframe_size = -1;
 	rport->supported_classes = FC_COS_UNSPECIFIED;
-	rport->roles = FC_RPORT_ROLE_UNKNOWN;
+	rport->roles = FC_PORT_ROLE_UNKNOWN;
 	rport->port_state = FC_PORTSTATE_NOTPRESENT;
 
 	/* remove the identifiers that aren't used in the consisting binding */
@@ -2436,7 +3000,7 @@ fc_scsi_scan_rport(struct work_struct *w
 	unsigned long flags;
 
 	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
-	    (rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
+	    (rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
 		scsi_scan_target(&rport->dev, rport->channel,
 			rport->scsi_target_id, SCAN_WILD_CARD, 1);
 	}
@@ -2447,6 +3011,203 @@ fc_scsi_scan_rport(struct work_struct *w
 }
 
 
+/**
+ * fc_vport_create - allocates and creates a FC virtual port.
+ * @shost:	scsi host the virtual port is connected to.
+ * @channel:	Channel on shost port connected to.
+ * @pdev:	parent device for vport
+ * @ids:	The world wide names, FC4 port roles, etc for
+ *              the virtual port.
+ * @ret_vport:	The pointer to the created vport.
+ *
+ * Allocates and creates the vport structure, calls the parent host
+ * to instantiate the vport, the completes w/ class and sysfs creation.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ **/
+static int
+fc_vport_create(struct Scsi_Host *shost, int channel, struct device *pdev,
+	struct fc_vport_identifiers  *ids, struct fc_vport **ret_vport)
+{
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_internal *fci = to_fc_internal(shost->transportt);
+	struct fc_vport *vport;
+	struct device *dev;
+	unsigned long flags;
+	size_t size;
+	int error;
+
+	*ret_vport = NULL;
+
+	if ( ! fci->f->vport_create)
+		return -ENOENT;
+
+	size = (sizeof(struct fc_vport) + fci->f->dd_fcvport_size);
+	vport = kzalloc(size, GFP_KERNEL);
+	if (unlikely(!vport)) {
+		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		return -ENOMEM;
+	}
+
+	vport->vport_state = FC_VPORT_UNKNOWN;
+	vport->vport_last_state = FC_VPORT_UNKNOWN;
+	vport->node_name = ids->node_name;
+	vport->port_name = ids->port_name;
+	vport->roles = ids->roles;
+	vport->vport_type = ids->vport_type;
+	if (fci->f->dd_fcvport_size)
+		vport->dd_data = &vport[1];
+	vport->shost = shost;
+	vport->channel = channel;
+	vport->flags = FC_VPORT_CREATING;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if (fc_host->npiv_vports_inuse >= fc_host->max_npiv_vports) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		kfree(vport);
+		return -ENOSPC;
+	}
+	fc_host->npiv_vports_inuse++;
+	vport->number = fc_host->next_vport_number++;
+	list_add_tail(&vport->peers, &fc_host->vports);
+	get_device(&shost->shost_gendev);	/* for fc_host->vport list */
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	dev = &vport->dev;
+	device_initialize(dev);			/* takes self reference */
+	dev->parent = get_device(pdev);		/* takes parent reference */
+	dev->release = fc_vport_dev_release;
+	sprintf(dev->bus_id, "vport-%d:%d-%d",
+		shost->host_no, channel, vport->number);
+	transport_setup_device(dev);
+
+	error = device_add(dev);
+	if (error) {
+		printk(KERN_ERR "FC Virtual Port device_add failed\n");
+		goto delete_vport;
+	}
+	transport_add_device(dev);
+	transport_configure_device(dev);
+
+	error = fci->f->vport_create(vport, ids->disable);
+	if (error) {
+		printk(KERN_ERR "FC Virtual Port LLDD Create failed\n");
+		goto delete_vport_all;
+	}
+
+	/*
+	 * if the parent isn't the physical adapter's Scsi_Host, ensure
+	 * the Scsi_Host at least contains ia symlink to the vport.
+	 */
+	if (pdev != &shost->shost_gendev) {
+		error = sysfs_create_link(&shost->shost_gendev.kobj,
+				 &dev->kobj, dev->bus_id);
+		if (error)
+			printk(KERN_ERR
+				"%s: Cannot create vport symlinks for "
+				"%s, err=%d\n",
+	       			__FUNCTION__, dev->bus_id, error);
+	}
+	spin_lock_irqsave(shost->host_lock, flags);
+	vport->flags &= ~FC_VPORT_CREATING;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	dev_printk(KERN_NOTICE, pdev,
+			"%s created via shost%d channel %d\n", dev->bus_id,
+			shost->host_no, channel);
+
+	*ret_vport = vport;
+
+	return 0;
+
+delete_vport_all:
+	transport_remove_device(dev);
+	device_del(dev);
+delete_vport:
+	transport_destroy_device(dev);
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del(&vport->peers);
+	put_device(&shost->shost_gendev);	/* for fc_host->vport list */
+	fc_host->npiv_vports_inuse--;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	put_device(dev->parent);
+	kfree(vport);
+
+	return error;
+}
+
+
+/**
+ * fc_vport_terminate - Admin App or LLDD requests termination of a vport
+ * @vport:	fc_vport to be terminated
+ *
+ * Calls the LLDD vport_delete() function, then deallocates and removes
+ * the vport from the shost and object tree.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ **/
+int
+fc_vport_terminate(struct fc_vport *vport)
+{
+	struct Scsi_Host *shost = vport_to_shost(vport);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct device *dev = &vport->dev;
+	unsigned long flags;
+	int stat;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (vport->flags & FC_VPORT_CREATING) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return -EBUSY;
+	}
+	if (vport->flags & (FC_VPORT_DEL)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return -EALREADY;
+	}
+	vport->flags |= FC_VPORT_DELETING;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (i->f->vport_delete)
+		stat = i->f->vport_delete(vport);
+	else
+		stat = -ENOENT;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	vport->flags &= ~FC_VPORT_DELETING;
+	if (!stat) {
+		vport->flags |= FC_VPORT_DELETED;
+		list_del(&vport->peers);
+		fc_host->npiv_vports_inuse--;
+		put_device(&shost->shost_gendev);  /* for fc_host->vport list */
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (stat)
+		return stat;
+
+	if (dev->parent != &shost->shost_gendev)
+		sysfs_remove_link(&shost->shost_gendev.kobj, dev->bus_id);
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+
+	/*
+	 * Removing our self-reference should mean our
+	 * release function gets called, which will drop the remaining
+	 * parent reference and free the data structure.
+	 */
+	put_device(dev);			/* for self-reference */
+
+	return 0; /* SUCCESS */
+}
+EXPORT_SYMBOL(fc_vport_terminate);
+
+
 MODULE_AUTHOR("Martin Hicks");
 MODULE_DESCRIPTION("FC Transport Attributes");
 MODULE_LICENSE("GPL");
diff -upNr b.devloss/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- b.devloss/include/scsi/scsi_transport_fc.h	2007-03-30 21:14:19.000000000 -0500
+++ b/include/scsi/scsi_transport_fc.h	2007-04-20 09:32:38.000000000 -0400
@@ -19,7 +19,7 @@
  *
  *  ========
  *
- *  Copyright (C) 2004-2005   James Smart, Emulex Corporation
+ *  Copyright (C) 2004-2007   James Smart, Emulex Corporation
  *    Rewrite for host, target, device, and remote port attributes,
  *    statistics, and service functions...
  *
@@ -62,8 +62,10 @@ enum fc_port_type {
 	FC_PORTTYPE_NLPORT,		/* (Public) Loop w/ FLPort */
 	FC_PORTTYPE_LPORT,		/* (Private) Loop w/o FLPort */
 	FC_PORTTYPE_PTP,		/* Point to Point w/ another NPort */
+	FC_PORTTYPE_NPIV,		/* VPORT based on NPIV */
 };
 
+
 /*
  * fc_port_state: If you alter this, you also need to alter scsi_transport_fc.c
  * (for the ascii descriptions).
@@ -83,6 +85,25 @@ enum fc_port_state {
 };
 
 
+/*
+ * fc_vport_state: If you alter this, you also need to alter
+ * scsi_transport_fc.c (for the ascii descriptions).
+ */
+enum fc_vport_state {
+	FC_VPORT_UNKNOWN,
+	FC_VPORT_ACTIVE,
+	FC_VPORT_DISABLED,
+	FC_VPORT_LINKDOWN,
+	FC_VPORT_INITIALIZING,
+	FC_VPORT_NO_FABRIC_SUPP,
+	FC_VPORT_NO_FABRIC_RSCS,
+	FC_VPORT_FABRIC_LOGOUT,
+	FC_VPORT_FABRIC_REJ_WWN,
+	FC_VPORT_FAILED,
+};
+
+
+
 /* 
  * FC Classes of Service
  * Note: values are not enumerated, as they can be "or'd" together
@@ -124,18 +145,115 @@ enum fc_tgtid_binding_type  {
 };
 
 /*
- * FC Remote Port Roles
+ * FC Port Roles
  * Note: values are not enumerated, as they can be "or'd" together
  * for reporting (e.g. report roles). If you alter this list,
  * you also need to alter scsi_transport_fc.c (for the ascii descriptions).
  */
-#define FC_RPORT_ROLE_UNKNOWN			0x00
-#define FC_RPORT_ROLE_FCP_TARGET		0x01
-#define FC_RPORT_ROLE_FCP_INITIATOR		0x02
-#define FC_RPORT_ROLE_IP_PORT			0x04
+#define FC_PORT_ROLE_UNKNOWN			0x00
+#define FC_PORT_ROLE_FCP_TARGET			0x01
+#define FC_PORT_ROLE_FCP_INITIATOR		0x02
+#define FC_PORT_ROLE_IP_PORT			0x04
+
+/* The following are for compatibility */
+#define FC_RPORT_ROLE_UNKNOWN			FC_PORT_ROLE_UNKNOWN
+#define FC_RPORT_ROLE_FCP_TARGET		FC_PORT_ROLE_FCP_TARGET
+#define FC_RPORT_ROLE_FCP_INITIATOR		FC_PORT_ROLE_FCP_INITIATOR
+#define FC_RPORT_ROLE_IP_PORT			FC_PORT_ROLE_IP_PORT
+
+
+/* Macro for use in defining Virtual Port attributes */
+#define FC_VPORT_ATTR(_name,_mode,_show,_store)				\
+struct class_device_attribute class_device_attr_vport_##_name = 	\
+	__ATTR(_name,_mode,_show,_store)
 
 
 /*
+ * FC Virtual Port Attributes
+ *
+ * This structure exists for each FC port is a virtual FC port. Virtual
+ * ports share the physical link with the Physical port. Each virtual
+ * ports has a unique presense on the SAN, and may be instantiated via
+ * NPIV, Virtual Fabrics, or via additional ALPAs. As the vport is a
+ * unique presense, each vport has it's own view of the fabric, 
+ * authentication priviledge, and priorities.
+ *
+ * A virtual port may support 1 or more FC4 roles. Typically it is a
+ * FCP Initiator. It could be a FCP Target, or exist sole for an IP over FC
+ * roles. FC port attributes for the vport will be reported on any
+ * fc_host class object allocated for an FCP Initiator.
+ *
+ * --
+ *
+ * Fixed attributes are not expected to change. The driver is
+ * expected to set these values after receiving the fc_vport structure
+ * via the vport_create() call from the transport.
+ * The transport fully manages all get functions w/o driver interaction.
+ *
+ * Dynamic attributes are expected to change. The driver participates
+ * in all get/set operations via functions provided by the driver.
+ *
+ * Private attributes are transport-managed values. They are fully
+ * managed by the transport w/o driver interaction.
+ */
+
+#define FC_VPORT_SYMBOLIC_NAMELEN		64
+struct fc_vport {
+	/* Fixed Attributes */
+
+	/* Dynamic Attributes */
+
+	/* Private (Transport-managed) Attributes */
+	enum fc_vport_state vport_state;
+	enum fc_vport_state vport_last_state;
+	u64 node_name;
+	u64 port_name;
+	u32 roles;
+	u32 vport_id;		/* Admin Identifier for the vport */
+	enum fc_port_type vport_type;
+	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
+
+	/* exported data */
+	void *dd_data;			/* Used for driver-specific storage */
+
+	/* internal data */
+	struct Scsi_Host *shost;	/* Physical Port Parent */
+	unsigned int channel;
+	u32 number;
+	u8 flags;
+	struct list_head peers;
+	struct device dev;
+} __attribute__((aligned(sizeof(unsigned long))));
+
+/* bit field values for struct fc_vport "flags" field: */
+#define FC_VPORT_CREATING		0x01
+#define FC_VPORT_DELETING		0x02
+#define FC_VPORT_DELETED		0x04
+#define FC_VPORT_DEL			0x06	/* Any DELETE state */
+
+#define	dev_to_vport(d)				\
+	container_of(d, struct fc_vport, dev)
+#define transport_class_to_vport(classdev)	\
+	dev_to_vport(classdev->dev)
+#define vport_to_shost(v)			\
+	(v->shost)
+#define vport_to_shost_channel(v)		\
+	(v->channel)
+#define vport_to_parent(v)			\
+	(v->dev.parent)
+
+
+/* Error return codes for vport_create() callback */
+#define VPCERR_UNSUPPORTED		-ENOSYS		/* no driver/adapter
+							   support */
+#define VPCERR_BAD_WWN			-ENOTUNIQ	/* driver validation
+							   of WWNs failed */
+#define VPCERR_NO_FABRIC_SUPP		-EOPNOTSUPP	/* Fabric connection
+							   is loop or the
+							   Fabric Port does
+							   not support NPIV */
+
+/*
  * fc_rport_identifiers: This set of data contains all elements
  * to uniquely identify a remote FC port. The driver uses this data
  * to report the existence of a remote FC port in the topology. Internally,
@@ -149,6 +267,7 @@ struct fc_rport_identifiers {
 	u32 roles;
 };
 
+
 /* Macro for use in defining Remote Port attributes */
 #define FC_RPORT_ATTR(_name,_mode,_show,_store)				\
 struct class_device_attribute class_device_attr_rport_##_name = 	\
@@ -343,6 +462,7 @@ struct fc_host_attrs {
 	u8  supported_fc4s[FC_FC4_LIST_SIZE];
 	u32 supported_speeds;
 	u32 maxframe_size;
+	u16 max_npiv_vports;
 	char serial_number[FC_SERIAL_NUMBER_SIZE];
 
 	/* Dynamic Attributes */
@@ -361,8 +481,11 @@ struct fc_host_attrs {
 	/* internal data */
 	struct list_head rports;
 	struct list_head rport_bindings;
+	struct list_head vports;
 	u32 next_rport_number;
 	u32 next_target_id;
+	u32 next_vport_number;
+	u16 npiv_vports_inuse;
 
 	/* work queues for rport state manipulation */
 	char work_q_name[KOBJ_NAME_LEN];
@@ -388,6 +511,8 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->supported_speeds)
 #define fc_host_maxframe_size(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->maxframe_size)
+#define fc_host_max_npiv_vports(x)	\
+	(((struct fc_host_attrs *)(x)->shost_data)->max_npiv_vports)
 #define fc_host_serial_number(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->serial_number)
 #define fc_host_port_id(x)	\
@@ -412,10 +537,16 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->rports)
 #define fc_host_rport_bindings(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->rport_bindings)
+#define fc_host_vports(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->vports)
 #define fc_host_next_rport_number(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->next_rport_number)
 #define fc_host_next_target_id(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->next_target_id)
+#define fc_host_next_vport_number(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->next_vport_number)
+#define fc_host_npiv_vports_inuse(x)	\
+	(((struct fc_host_attrs *)(x)->shost_data)->npiv_vports_inuse)
 #define fc_host_work_q_name(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->work_q_name)
 #define fc_host_work_q(x) \
@@ -452,8 +583,14 @@ struct fc_function_template {
 	void    (*dev_loss_tmo_callbk)(struct fc_rport *);
 	void	(*terminate_rport_io)(struct fc_rport *);
 
+	void	(*set_vport_symbolic_name)(struct fc_vport *);
+    	int  	(*vport_create)(struct fc_vport *, bool);
+	int	(*vport_disable)(struct fc_vport *, bool);
+	int  	(*vport_delete)(struct fc_vport *);
+
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
+	u32	 			dd_fcvport_size;
 
 	/* 
 	 * The driver sets these to tell the transport class it
@@ -512,7 +649,7 @@ fc_remote_port_chkready(struct fc_rport 
 
 	switch (rport->port_state) {
 	case FC_PORTSTATE_ONLINE:
-		if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
+		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
 			result = 0;
 		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
 			result = DID_IMM_RETRY << 16;
@@ -549,6 +686,27 @@ static inline void u64_to_wwn(u64 inm, u
 	wwn[7] = inm & 0xff;
 }
 
+/**
+ * fc_vport_set_state() - called to set a vport's state. Saves the old state,
+ *   excepting the transitory states of initializing and sending the ELS
+ *   traffic to instantiate the vport on the link.
+ *
+ * Assumes the driver has surrounded this with the proper locking to ensure
+ * a coherent state change.
+ *
+ * @vport:	virtual port whose state is changing
+ * @new_state:  new state
+ **/
+static inline void
+fc_vport_set_state(struct fc_vport *vport, enum fc_vport_state new_state)
+{
+	if ((new_state != FC_VPORT_UNKNOWN) &&
+	    (new_state != FC_VPORT_INITIALIZING))
+		vport->vport_last_state = vport->vport_state;
+	vport->vport_state = new_state;
+}
+
+
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
@@ -567,5 +725,6 @@ void fc_host_post_vendor_event(struct Sc
 	 *   be sure to read the Vendor Type and ID formatting requirements
 	 *   specified in scsi_netlink.h
 	 */
+int fc_vport_terminate(struct fc_vport *vport);
 
 #endif /* SCSI_TRANSPORT_FC_H */


