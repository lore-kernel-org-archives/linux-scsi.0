From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 4/6] mpt fusion: Creation of mptsas.h header file
Date: Tue, 14 Aug 2007 16:15:38 +0530
Message-ID: <20070814104537.GD9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39550 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758273AbXHNKtG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2007 06:49:06 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l7EAlYlC024791
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2007 03:47:34 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

The data structure definitions from mptsas.c are moved to a new header file mptsas.h

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index ffbf0e5..5951fe0 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -61,6 +61,7 @@
 
 #include "mptbase.h"
 #include "mptscsih.h"
+#include "mptsas.h"
 
 
 #define my_NAME		"Fusion MPT SAS Host driver"
@@ -96,111 +97,6 @@ static u8	mptsasMgmtCtx = MPT_MAX_PROTOCOL_DRIVERS;
 
 static void mptsas_hotplug_work(struct work_struct *work);
 
-struct mptsas_target_reset_event {
-	struct list_head 	list;
-	EVENT_DATA_SAS_DEVICE_STATUS_CHANGE sas_event_data;
-	u8	target_reset_issued;
-};
-
-enum mptsas_hotplug_action {
-	MPTSAS_ADD_DEVICE,
-	MPTSAS_DEL_DEVICE,
-	MPTSAS_ADD_RAID,
-	MPTSAS_DEL_RAID,
-	MPTSAS_ADD_INACTIVE_VOLUME,
-	MPTSAS_IGNORE_EVENT,
-};
-
-struct mptsas_hotplug_event {
-	struct work_struct	work;
-	MPT_ADAPTER		*ioc;
-	enum mptsas_hotplug_action event_type;
-	u64			sas_address;
-	u8			channel;
-	u8			id;
-	u32			device_info;
-	u16			handle;
-	u16			parent_handle;
-	u8			phy_id;
-	u8			phys_disk_num_valid;	/* hrc (hidden raid component) */
-	u8			phys_disk_num;		/* hrc - unique index*/
-	u8			hidden_raid_component;	/* hrc - don't expose*/
-};
-
-struct mptsas_discovery_event {
-	struct work_struct	work;
-	MPT_ADAPTER		*ioc;
-};
-
-/*
- * SAS topology structures
- *
- * The MPT Fusion firmware interface spreads information about the
- * SAS topology over many manufacture pages, thus we need some data
- * structure to collect it and process it for the SAS transport class.
- */
-
-struct mptsas_devinfo {
-	u16	handle;		/* unique id to address this device */
-	u16	handle_parent;	/* unique id to address parent device */
-	u16	handle_enclosure; /* enclosure identifier of the enclosure */
-	u16	slot;		/* physical slot in enclosure */
-	u8	phy_id;		/* phy number of parent device */
-	u8	port_id;	/* sas physical port this device
-				   is assoc'd with */
-	u8	id;		/* logical target id of this device */
-	u32	phys_disk_num;	/* phys disk id, for csmi-ioctls */
-	u8	channel;	/* logical bus number of this device */
-	u64	sas_address;    /* WWN of this device,
-				   SATA is assigned by HBA,expander */
-	u32	device_info;	/* bitfield detailed info about this device */
-};
-
-/*
- * Specific details on ports, wide/narrow
- */
-struct mptsas_portinfo_details{
-	u16	num_phys;	/* number of phys belong to this port */
-	u64	phy_bitmask; 	/* TODO, extend support for 255 phys */
-	struct sas_rphy *rphy;	/* transport layer rphy object */
-	struct sas_port *port;	/* transport layer port object */
-	struct scsi_target *starget;
-	struct mptsas_portinfo *port_info;
-};
-
-struct mptsas_phyinfo {
-	u16	handle;			/* unique id to address this */
-	u8	phy_id; 		/* phy index */
-	u8	port_id; 		/* firmware port identifier */
-	u8	negotiated_link_rate;	/* nego'd link rate for this phy */
-	u8	hw_link_rate; 		/* hardware max/min phys link rate */
-	u8	programmed_link_rate;	/* programmed max/min phy link rate */
-	u8	sas_port_add_phy;	/* flag to request sas_port_add_phy*/
-	struct mptsas_devinfo identify;	/* point to phy device info */
-	struct mptsas_devinfo attached;	/* point to attached device info */
-	struct sas_phy *phy;		/* transport layer phy object */
-	struct mptsas_portinfo *portinfo;
-	struct mptsas_portinfo_details * port_details;
-};
-
-struct mptsas_portinfo {
-	struct list_head list;
-	u16		num_phys;	/* number of phys */
-	struct mptsas_phyinfo *phy_info;
-};
-
-struct mptsas_enclosure {
-	u64	enclosure_logical_id;	/* The WWN for the enclosure */
-	u16	enclosure_handle;	/* unique id to address this */
-	u16	flags;			/* details enclosure management */
-	u16	num_slot;		/* num slots */
-	u16	start_slot;		/* first slot */
-	u8	start_id;		/* starting logical target id */
-	u8	start_channel;		/* starting logical channel id */
-	u8	sep_id;			/* SEP device logical target id */
-	u8	sep_channel;		/* SEP channel logical channel id */
-};
-
 static void mptsas_print_phy_data(MPT_ADAPTER *ioc,
 					MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
 {
diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsas.h
new file mode 100644
index 0000000..7c150f5
--- /dev/null
+++ b/drivers/message/fusion/mptsas.h
@@ -0,0 +1,158 @@
+/*
+ *  linux/drivers/message/fusion/mptsas.h
+ *      High performance SCSI + LAN / Fibre Channel device drivers.
+ *      For use with PCI chip/adapter(s):
+ *          LSIFC9xx/LSI409xx Fibre Channel
+ *      running LSI MPT (Message Passing Technology) firmware.
+ *
+ *  Copyright (c) 1999-2007 LSI Corporation
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
+ *
+ */
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; version 2 of the License.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    NO WARRANTY
+    THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+    CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+    LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+    solely responsible for determining the appropriateness of using and
+    distributing the Program and assumes all risks associated with its
+    exercise of rights under this Agreement, including but not limited to
+    the risks and costs of program errors, damage to or loss of data,
+    programs or equipment, and unavailability or interruption of operations.
+
+    DISCLAIMER OF LIABILITY
+    NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+    DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+    USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+    HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+#ifndef MPTSAS_H_INCLUDED
+#define MPTSAS_H_INCLUDED
+/*{-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+
+struct mptsas_target_reset_event {
+	struct list_head 	list;
+	EVENT_DATA_SAS_DEVICE_STATUS_CHANGE sas_event_data;
+	u8	target_reset_issued;
+};
+
+enum mptsas_hotplug_action {
+	MPTSAS_ADD_DEVICE,
+	MPTSAS_DEL_DEVICE,
+	MPTSAS_ADD_RAID,
+	MPTSAS_DEL_RAID,
+	MPTSAS_ADD_INACTIVE_VOLUME,
+	MPTSAS_IGNORE_EVENT,
+};
+
+struct mptsas_hotplug_event {
+	struct work_struct	work;
+	MPT_ADAPTER		*ioc;
+	enum mptsas_hotplug_action event_type;
+	u64			sas_address;
+	u8			channel;
+	u8			id;
+	u32			device_info;
+	u16			handle;
+	u16			parent_handle;
+	u8			phy_id;
+	u8			phys_disk_num_valid;	/* hrc (hidden raid component) */
+	u8			phys_disk_num;		/* hrc - unique index*/
+	u8			hidden_raid_component;	/* hrc - don't expose*/
+};
+
+struct mptsas_discovery_event {
+	struct work_struct	work;
+	MPT_ADAPTER		*ioc;
+};
+
+/*
+ * SAS topology structures
+ *
+ * The MPT Fusion firmware interface spreads information about the
+ * SAS topology over many manufacture pages, thus we need some data
+ * structure to collect it and process it for the SAS transport class.
+ */
+
+struct mptsas_devinfo {
+	u16	handle;		/* unique id to address this device */
+	u16	handle_parent;	/* unique id to address parent device */
+	u16	handle_enclosure; /* enclosure identifier of the enclosure */
+	u16	slot;		/* physical slot in enclosure */
+	u8	phy_id;		/* phy number of parent device */
+	u8	port_id;	/* sas physical port this device
+				   is assoc'd with */
+	u8	id;		/* logical target id of this device */
+	u32	phys_disk_num;	/* phys disk id, for csmi-ioctls */
+	u8	channel;	/* logical bus number of this device */
+	u64	sas_address;    /* WWN of this device,
+				   SATA is assigned by HBA,expander */
+	u32	device_info;	/* bitfield detailed info about this device */
+};
+
+/*
+ * Specific details on ports, wide/narrow
+ */
+struct mptsas_portinfo_details{
+	u16	num_phys;	/* number of phys belong to this port */
+	u64	phy_bitmask; 	/* TODO, extend support for 255 phys */
+	struct sas_rphy *rphy;	/* transport layer rphy object */
+	struct sas_port *port;	/* transport layer port object */
+	struct scsi_target *starget;
+	struct mptsas_portinfo *port_info;
+};
+
+struct mptsas_phyinfo {
+	u16	handle;			/* unique id to address this */
+	u8	phy_id; 		/* phy index */
+	u8	port_id; 		/* firmware port identifier */
+	u8	negotiated_link_rate;	/* nego'd link rate for this phy */
+	u8	hw_link_rate; 		/* hardware max/min phys link rate */
+	u8	programmed_link_rate;	/* programmed max/min phy link rate */
+	u8	sas_port_add_phy;	/* flag to request sas_port_add_phy*/
+	struct mptsas_devinfo identify;	/* point to phy device info */
+	struct mptsas_devinfo attached;	/* point to attached device info */
+	struct sas_phy *phy;		/* transport layer phy object */
+	struct mptsas_portinfo *portinfo;
+	struct mptsas_portinfo_details * port_details;
+};
+
+struct mptsas_portinfo {
+	struct list_head list;
+	u16		num_phys;	/* number of phys */
+	struct mptsas_phyinfo *phy_info;
+};
+
+struct mptsas_enclosure {
+	u64	enclosure_logical_id;	/* The WWN for the enclosure */
+	u16	enclosure_handle;	/* unique id to address this */
+	u16	flags;			/* details enclosure management */
+	u16	num_slot;		/* num slots */
+	u16	start_slot;		/* first slot */
+	u8	start_id;		/* starting logical target id */
+	u8	start_channel;		/* starting logical channel id */
+	u8	sep_id;			/* SEP device logical target id */
+	u8	sep_channel;		/* SEP channel logical channel id */
+};
+
+/*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+#endif
