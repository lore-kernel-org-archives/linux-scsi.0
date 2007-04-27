From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc_transport: fix sysfs deadlock on vport delete
Date: Fri, 27 Apr 2007 12:52:19 -0400
Message-ID: <1177692740.26526.3.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:62386 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbXD0P0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2007 11:26:05 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3RFQ3wU026900
	for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 08:26:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When the vport attribute "delete" is used to delete the vport, sysfs
deadlocks waiting for the write to complete, which is waiting for the
sysfs teardown to complete. Moved this effort to a work_q element.

Took the opportunity to make some other cosmetic changes:
 - removed tabs in Doc file - replaced with expanded spaces
 - minor copyright text and author text updates
 - removed a bunch of trailing whitespace

-- james s

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/Documentation/scsi/scsi_fc_transport.txt b/Documentation/scsi/scsi_fc_transport.txt
--- a/Documentation/scsi/scsi_fc_transport.txt	2007-04-20 21:47:20.000000000 -0400
+++ b/Documentation/scsi/scsi_fc_transport.txt	2007-04-20 22:26:45.000000000 -0400
@@ -119,67 +119,67 @@ Vport Attributes:
 
   The new fc_vport class object has the following attributes
 
-     node_name:							Read_Only
+     node_name:                                                 Read_Only
        The WWNN of the vport
 
-     port_name:							Read_Only
+     port_name:                                                 Read_Only
        The WWPN of the vport
 
-     roles:							Read_Only
+     roles:                                                     Read_Only
        Indicates the FC4 roles enabled on the vport.
 
-     symbolic_name:						Read_Write
+     symbolic_name:                                             Read_Write
        A string, appended to the driver's symbolic port name string, which
        is registered with the switch to identify the vport. For example,
        a hypervisor could set this string to "Xen Domain 2 VM 5 Vport 2",
        and this set of identifiers can be seen on switch management screens
        to identify the port.
 
-     vport_delete:						Write_Only
+     vport_delete:                                              Write_Only
        When written with a "1", will tear down the vport.
 
-     vport_disable:						Write_Only
+     vport_disable:                                             Write_Only
        When written with a "1", will transition the vport to a disabled.
        state.  The vport will still be instantiated with the Linux kernel,
        but it will not be active on the FC link.
        When written with a "0", will enable the vport.
 
-     vport_last_state:						Read_Only
+     vport_last_state:                                          Read_Only
        Indicates the previous state of the vport.  See the section below on
        "Vport States".
 
-     vport_state:						Read_Only
+     vport_state:                                               Read_Only
        Indicates the state of the vport.  See the section below on
        "Vport States".
 
-     vport_type:						Read_Only
+     vport_type:                                                Read_Only
        Reflects the FC mechanism used to create the virtual port.
        Only NPIV is supported currently.
 
 
   For the fc_host class object, the following attributes are added for vports:
 
-     max_npiv_vports:						Read_Only
+     max_npiv_vports:                                           Read_Only
        Indicates the maximum number of NPIV-based vports that the
        driver/adapter can support on the fc_host.
 
-     npiv_vports_inuse:						Read_Only
+     npiv_vports_inuse:                                         Read_Only
        Indicates how many NPIV-based vports have been instantiated on the
        fc_host.
 
-     vport_create:						Write_Only
+     vport_create:                                              Write_Only
        A "simple" create interface to instantiate a vport on an fc_host.
        A "<WWPN>:<WWNN>" string is written to the attribute. The transport
        then instantiates the vport object and calls the LLDD to create the
        vport with the role of FCP_Initiator.  Each WWN is specified as 16
        hex characters and may *not* contain any prefixes (e.g. 0x, x, etc).
 
-     vport_delete:						Write_Only
+     vport_delete:                                              Write_Only
         A "simple" delete interface to teardown a vport. A "<WWPN>:<WWNN>"
-	string is written to the attribute. The transport will locate the
-	vport on the fc_host with the same WWNs and tear it down.  Each WWN
-	is specified as 16 hex characters and may *not* contain any prefixes
-	(e.g. 0x, x, etc).
+        string is written to the attribute. The transport will locate the
+        vport on the fc_host with the same WWNs and tear it down.  Each WWN
+        is specified as 16 hex characters and may *not* contain any prefixes
+        (e.g. 0x, x, etc).
 
 
 Vport States:
@@ -198,23 +198,23 @@ Vport States:
   Once a vport has been instantiated with the kernel/LLDD, a vport state
   can be reported via the sysfs attribute. The following states exist:
 
-    FC_VPORT_UNKNOWN		- Unknown
+    FC_VPORT_UNKNOWN            - Unknown
       An temporary state, typically set only while the vport is being
       instantiated with the kernel and LLDD.
 
-    FC_VPORT_ACTIVE		- Active
+    FC_VPORT_ACTIVE             - Active
       The vport has been successfully been created on the FC link.
       It is fully functional.
 
-    FC_VPORT_DISABLED		- Disabled
+    FC_VPORT_DISABLED           - Disabled
       The vport instantiated, but "disabled". The vport is not instantiated
       on the FC link. This is equivalent to a physical port with the
       link "down". 
 
-    FC_VPORT_LINKDOWN		- Linkdown
+    FC_VPORT_LINKDOWN           - Linkdown
       The vport is not operational as the physical link is not operational.
 
-    FC_VPORT_INITIALIZING	- Initializing
+    FC_VPORT_INITIALIZING       - Initializing
       The vport is in the process of instantiating on the FC link.
       The LLDD will set this state just prior to starting the ELS traffic
       to create the vport. This state will persist until the vport is
@@ -222,65 +222,65 @@ Vport States:
       (state is one of the values below).  As this state is transitory,
       it will not be preserved in the "vport_last_state".
 
-    FC_VPORT_NO_FABRIC_SUPP	- No Fabric Support
+    FC_VPORT_NO_FABRIC_SUPP     - No Fabric Support
       The vport is not operational. One of the following conditions were
       encountered:
        - The FC topology is not Point-to-Point
        - The FC port is not connected to an F_Port
        - The F_Port has indicated that NPIV is not supported.
 
-    FC_VPORT_NO_FABRIC_RSCS	- No Fabric Resources
+    FC_VPORT_NO_FABRIC_RSCS     - No Fabric Resources
       The vport is not operational. The Fabric failed FDISC with a status
       indicating that it does not have sufficient resources to complete
       the operation.
  
-    FC_VPORT_FABRIC_LOGOUT	- Fabric Logout
+    FC_VPORT_FABRIC_LOGOUT      - Fabric Logout
       The vport is not operational. The Fabric has LOGO'd the N_Port_ID
       associated with the vport.
 
-    FC_VPORT_FABRIC_REJ_WWN	- Fabric Rejected WWN
+    FC_VPORT_FABRIC_REJ_WWN     - Fabric Rejected WWN
       The vport is not operational. The Fabric failed FDISC with a status
       indicating that the WWN's are not valid.
 
-    FC_VPORT_FAILED		- VPort Failed
+    FC_VPORT_FAILED             - VPort Failed
       The vport is not operational. This is a catchall for all other
       error conditions.
 
 
   The following state table indicates the different state transitions:
 
-    State              Event				New State
+    State              Event                            New State
     --------------------------------------------------------------------
-     n/a  		Initialization			Unknown
-    Unknown:		Link Down			Linkdown
-                        Link Up & Loop			No Fabric Support
-			Link Up & no Fabric		No Fabric Support
-			Link Up & FLOGI response	No Fabric Support
-			  indicates no NPIV support
-      			Link Up & FDISC being sent	Initializing
-			Disable request			Disable
-    Linkdown:		Link Up				Unknown
-    Initializing:	FDISC ACC			Active
-			FDISC LS_RJT w/ no resources	No Fabric Resources
-			FDISC LS_RJT w/ invalid		Fabric Rejected WWN
-			  pname or invalid nport_id
-			FDISC LS_RJT failed for		Vport Failed
-			  other reasons
-      			Link Down			Linkdown
-			Disable request			Disable
-    Disable:		Enable request			Unknown
-    Active:		LOGO received from fabric	Fabric Logout
-    			Link Down			Linkdown
-			Disable request			Disable
-    Fabric Logout:	Link still up			Unknown
+     n/a                Initialization                  Unknown
+    Unknown:            Link Down                       Linkdown
+                        Link Up & Loop                  No Fabric Support
+                        Link Up & no Fabric             No Fabric Support
+                        Link Up & FLOGI response        No Fabric Support
+                          indicates no NPIV support
+                        Link Up & FDISC being sent      Initializing
+                        Disable request                 Disable
+    Linkdown:           Link Up                         Unknown
+    Initializing:       FDISC ACC                       Active
+                        FDISC LS_RJT w/ no resources    No Fabric Resources
+                        FDISC LS_RJT w/ invalid         Fabric Rejected WWN
+                          pname or invalid nport_id
+                        FDISC LS_RJT failed for         Vport Failed
+                          other reasons
+                        Link Down                       Linkdown
+                        Disable request                 Disable
+    Disable:            Enable request                  Unknown
+    Active:             LOGO received from fabric       Fabric Logout
+                        Link Down                       Linkdown
+                        Disable request                 Disable
+    Fabric Logout:      Link still up                   Unknown
 
          The following 4 error states all have the same transitions:
     No Fabric Support:
     No Fabric Resources:
     Fabric Rejected WWN:
-    Vport Failed:	
-    			Disable request			Disable
-    			Link goes down			Linkdown
+    Vport Failed:       
+                        Disable request                 Disable
+                        Link goes down                  Linkdown
 
 
 Transport <-> LLDD Interfaces :
@@ -303,9 +303,9 @@ Vport Creation:
       int vport_create(struct fc_vport *vport, bool disable)
 
     where:
-      vport:	Is the newly allocated vport object
-      disable:	If "true", the vport is to be created in a disabled stated.
-      		If "false", the vport is to be enabled upon creation.
+      vport:    Is the newly allocated vport object
+      disable:  If "true", the vport is to be created in a disabled stated.
+                If "false", the vport is to be enabled upon creation.
 
   When a request is made to create a new vport (via sgio/netlink, or the
   vport_create fc_host attribute), the transport will validate that the LLDD
@@ -342,7 +342,7 @@ Vport Creation:
     - Validate Infrastructure:
         - If the driver or adapter cannot support another vport, whether
             due to improper firmware, (a lie about) max_npiv, or a lack of
-	    some other resource - return VPCERR_UNSUPPORTED.  
+            some other resource - return VPCERR_UNSUPPORTED.  
         - If the driver validates the WWN's against those already active on
             the adapter and detects an overlap - return VPCERR_BAD_WWN.
         - If the driver detects the topology is loop, non-fabric, or the
@@ -351,9 +351,9 @@ Vport Creation:
         of memory conditions, return the respective negative Exxx error code.
     - If the role is FCP Initiator, the LLDD is to :
         - Call scsi_host_alloc() to allocate a scsi_host for the vport.
-	- Call scsi_add_host(new_shost, &vport->dev) to start the scsi_host
-	  and bind it as a child of the vport device.
-	- Initializes the fc_host attribute values.
+        - Call scsi_add_host(new_shost, &vport->dev) to start the scsi_host
+          and bind it as a child of the vport device.
+        - Initializes the fc_host attribute values.
     - Kick of further vport state transitions based on the disable flag and
         link state - and return success (zero).
 
@@ -376,9 +376,9 @@ Vport Disable/Enable:
       int vport_disable(struct fc_vport *vport, bool disable)
 
     where:
-      vport:	Is vport to to be enabled or disabled
-      disable:	If "true", the vport is to be disabled.
-      		If "false", the vport is to be enabled.
+      vport:    Is vport to to be enabled or disabled
+      disable:  If "true", the vport is to be disabled.
+                If "false", the vport is to be enabled.
 
   When a request is made to change the disabled state on a vport, the
   transport will validate the request against the existing vport state.
@@ -404,7 +404,7 @@ Vport Deletion:
       int vport_delete(struct fc_vport *vport)
 
     where:
-      vport:	Is vport to delete
+      vport:    Is vport to delete
 
   When a request is made to delete a vport (via sgio/netlink, or via the
   fc_host or fc_vport vport_delete attributes), the transport will call
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2007-04-20 21:47:20.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2007-04-20 22:27:34.000000000 -0400
@@ -1,4 +1,4 @@
-/* 
+/*
  *  FiberChannel transport specific attributes exported to sysfs.
  *
  *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
@@ -22,6 +22,7 @@
  *  Copyright (C) 2004-2007   James Smart, Emulex Corporation
  *    Rewrite for host, target, device, and remote port attributes,
  *    statistics, and service functions...
+ *    Add vports, etc
  *
  */
 #include <linux/module.h>
@@ -37,6 +38,7 @@
 #include "scsi_priv.h"
 
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
+static void fc_vport_sched_delete(struct work_struct *work);
 
 /*
  * This is a temporary carrier for creating a vport. It will eventually
@@ -57,7 +59,7 @@ struct fc_vport_identifiers {
 	u64 port_name;
 	u32 roles;
 	bool disable;
-	enum fc_port_type vport_type;	/* only FC_PORTTYPE_NPIV allowed */ 
+	enum fc_port_type vport_type;	/* only FC_PORTTYPE_NPIV allowed */
 	char symbolic_name[FC_VPORT_SYMBOLIC_NAMELEN];
 };
 
@@ -377,7 +379,7 @@ static int fc_host_setup(struct transpor
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 
-	/* 
+	/*
 	 * Set default values easily detected by the midlayer as
 	 * failure cases.  The scsi lldd is responsible for initializing
 	 * all transport attributes to valid values per host.
@@ -1198,12 +1200,9 @@ store_fc_vport_delete(struct class_devic
 			   size_t count)
 {
 	struct fc_vport *vport = transport_class_to_vport(cdev);
-	int stat;
-
-	stat = fc_vport_terminate(vport);
-	if (stat)
-		return stat;
+	struct Scsi_Host *shost = vport_to_shost(vport);
 
+	fc_queue_work(shost, &vport->vport_delete_work);
 	return count;
 }
 static FC_CLASS_DEVICE_ATTR(vport, vport_delete, S_IWUSR,
@@ -1784,7 +1783,7 @@ store_fc_host_vport_delete(struct class_
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (!match)
-		return -ENODEV; 
+		return -ENODEV;
 
 	stat = fc_vport_terminate(vport);
 	return stat ? stat : count;
@@ -1996,7 +1995,7 @@ fc_attach_transport(struct fc_function_t
 	i->t.eh_timed_out = fc_timed_out;
 
 	i->t.user_scan = fc_user_scan;
-	
+
 	/*
 	 * Setup SCSI Target Attributes.
 	 */
@@ -2215,23 +2214,12 @@ fc_remove_host(struct Scsi_Host *shost)
 	struct workqueue_struct *work_q;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	unsigned long flags;
-	int stat;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	/* Remove any vports */
-	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		/* this must be called synchronously */
-		stat = fc_vport_terminate(vport);
-		spin_lock_irqsave(shost->host_lock, flags);
-		if (stat)
-			dev_printk(KERN_ERR, vport->dev.parent,
-				"%s: %s could not be deleted created via "
-				"shost%d channel %d\n", __FUNCTION__,
-				vport->dev.bus_id, vport->shost->host_no,
-				vport->channel);
-	}
+	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers)
+		fc_queue_work(shost, &vport->vport_delete_work);
 
 	/* Remove any remote ports */
 	list_for_each_entry_safe(rport, next_rport,
@@ -2308,7 +2296,7 @@ fc_rport_final_delete(struct work_struct
 	unsigned long flags;
 
 	/*
-	 * if a scan is pending, flush the SCSI Host work_q so that 
+	 * if a scan is pending, flush the SCSI Host work_q so that
 	 * that we can reclaim the rport scan work element.
 	 */
 	if (rport->flags & FC_RPORT_SCAN_PENDING)
@@ -2747,7 +2735,7 @@ fc_remote_port_delete(struct fc_rport  *
 	}
 
 	/*
-	 * In the past, we if this was not an FCP-Target, we would 
+	 * In the past, we if this was not an FCP-Target, we would
 	 * unconditionally just jump to deleting the rport.
 	 * However, rports can be used as node containers by the LLDD,
 	 * and its not appropriate to just terminate the rport at the
@@ -2755,7 +2743,7 @@ fc_remote_port_delete(struct fc_rport  *
 	 * send ELS traffic to re-validate the login. If the rport is
 	 * immediately deleted, it makes it inappropriate for a node
 	 * container.
-	 * So... we now unconditionally wait dev_loss_tmo before 
+	 * So... we now unconditionally wait dev_loss_tmo before
 	 * destroying an rport.
 	 */
 
@@ -2858,7 +2846,7 @@ EXPORT_SYMBOL(fc_remote_port_rolechg);
  * fc_timeout_deleted_rport - Timeout handler for a deleted remote port,
  * 			which we blocked, and has now failed to return
  * 			in the allotted time.
- * 
+ *
  * @work:	rport target that failed to reappear in the allotted time.
  **/
 static void
@@ -3061,6 +3049,7 @@ fc_vport_create(struct Scsi_Host *shost,
 	vport->shost = shost;
 	vport->channel = channel;
 	vport->flags = FC_VPORT_CREATING;
+	INIT_WORK(&vport->vport_delete_work, fc_vport_sched_delete);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
@@ -3207,8 +3196,30 @@ fc_vport_terminate(struct fc_vport *vpor
 }
 EXPORT_SYMBOL(fc_vport_terminate);
 
+/**
+ * fc_vport_sched_delete - workq-based delete request for a vport
+ *
+ * @work:	vport to be deleted.
+ **/
+static void
+fc_vport_sched_delete(struct work_struct *work)
+{
+	struct fc_vport *vport =
+		container_of(work, struct fc_vport, vport_delete_work);
+	int stat;
+
+	stat = fc_vport_terminate(vport);
+	if (stat)
+		dev_printk(KERN_ERR, vport->dev.parent,
+			"%s: %s could not be deleted created via "
+			"shost%d channel %d - error %d\n", __FUNCTION__,
+			vport->dev.bus_id, vport->shost->host_no,
+			vport->channel, stat);
+}
+
 
-MODULE_AUTHOR("Martin Hicks");
+/* Original Author:  Martin Hicks */
+MODULE_AUTHOR("James Smart");
 MODULE_DESCRIPTION("FC Transport Attributes");
 MODULE_LICENSE("GPL");
 
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2007-04-20 21:47:20.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2007-04-20 22:31:41.000000000 -0400
@@ -1,4 +1,4 @@
-/* 
+/*
  *  FiberChannel transport specific attributes exported to sysfs.
  *
  *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
@@ -104,7 +104,7 @@ enum fc_vport_state {
 
 
 
-/* 
+/*
  * FC Classes of Service
  * Note: values are not enumerated, as they can be "or'd" together
  * for reporting (e.g. report supported_classes). If you alter this list,
@@ -117,7 +117,7 @@ enum fc_vport_state {
 #define FC_COS_CLASS4			0x10
 #define FC_COS_CLASS6			0x40
 
-/* 
+/*
  * FC Port Speeds
  * Note: values are not enumerated, as they can be "or'd" together
  * for reporting (e.g. report supported_speeds). If you alter this list,
@@ -175,7 +175,7 @@ struct class_device_attribute class_devi
  * ports share the physical link with the Physical port. Each virtual
  * ports has a unique presense on the SAN, and may be instantiated via
  * NPIV, Virtual Fabrics, or via additional ALPAs. As the vport is a
- * unique presense, each vport has it's own view of the fabric, 
+ * unique presense, each vport has it's own view of the fabric,
  * authentication priviledge, and priorities.
  *
  * A virtual port may support 1 or more FC4 roles. Typically it is a
@@ -223,6 +223,7 @@ struct fc_vport {
 	u8 flags;
 	struct list_head peers;
 	struct device dev;
+	struct work_struct vport_delete_work;
 } __attribute__((aligned(sizeof(unsigned long))));
 
 /* bit field values for struct fc_vport "flags" field: */
@@ -397,7 +398,7 @@ struct fc_host_statistics {
 	u64 prim_seq_protocol_err_count;
 	u64 invalid_tx_word_count;
 	u64 invalid_crc_count;
-	
+
 	/* fc4 statistics  (only FCP supported currently) */
 	u64 fcp_input_requests;
 	u64 fcp_output_requests;
@@ -592,11 +593,11 @@ struct fc_function_template {
 	u32	 			dd_fcrport_size;
 	u32	 			dd_fcvport_size;
 
-	/* 
+	/*
 	 * The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
 	 * is not set, the attribute will be private to the transport
-	 * class 
+	 * class
 	 */
 
 	/* remote port fixed attributes */


