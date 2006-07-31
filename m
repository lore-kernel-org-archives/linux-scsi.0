From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/4] fusion: fibre channel: add additional fc transport attributes
Date: Mon, 31 Jul 2006 12:19:30 -0500
Message-ID: <44CE3BA2.6010806@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010801060900080202010207"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:43457 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030266AbWGaRTc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 13:19:32 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k6VJm59L023204
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2006 12:48:05 -0700
Received: from [128.162.233.78] (hd28.americas.sgi.com [128.162.233.78])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k6VHJV2742997600
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2006 10:19:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010801060900080202010207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Add host_supported_speeds, host_maxframe_size, host_speed, host_fabric_name,
host_port_type, host_port_state, and host_symbolic_name transport attributes
to fusion fibre channel.

Signed-off-by: Michael Reed <mdr@sgi.com>



--------------010801060900080202010207
Content-Type: text/x-patch;
 name="fusion_transport_attributes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fusion_transport_attributes.patch"

--- srfu/drivers/message/fusion/mptfc.c	2006-07-19 11:12:34.000000000 -0500
+++ srf/drivers/message/fusion/mptfc.c	2006-07-28 15:11:24.814634318 -0500
@@ -162,7 +162,13 @@ static struct fc_function_template mptfc
 	.show_starget_port_id = 1,
 	.set_rport_dev_loss_tmo = mptfc_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
-
+	.show_host_supported_speeds = 1,
+	.show_host_maxframe_size = 1,
+	.show_host_speed = 1,
+	.show_host_fabric_name = 1,
+	.show_host_port_type = 1,
+	.show_host_port_state = 1,
+	.show_host_symbolic_name = 1,
 };
 
 static void
@@ -836,33 +842,95 @@ mptfc_SetFcPortPage1_defaults(MPT_ADAPTE
 static void
 mptfc_init_host_attr(MPT_ADAPTER *ioc,int portnum)
 {
-	unsigned class = 0, cos = 0;
+	unsigned	class = 0;
+	unsigned	cos = 0;
+	unsigned	speed;
+	unsigned	port_type;
+	unsigned	port_state;
+	FCPortPage0_t	*pp0;
+	struct Scsi_Host *sh;
+	char		*sn;
 
 	/* don't know what to do as only one scsi (fc) host was allocated */
 	if (portnum != 0)
 		return;
 
-	class = ioc->fc_port_page0[portnum].SupportedServiceClass;
+	pp0 = &ioc->fc_port_page0[portnum];
+	sh = ioc->sh;
+
+	sn = fc_host_symbolic_name(sh);
+	snprintf(sn, FC_SYMBOLIC_NAME_SIZE, "%s %s%08xh",
+	    ioc->prod_name,
+	    MPT_FW_REV_MAGIC_ID_STRING,
+	    ioc->facts.FWVersion.Word);
+
+	fc_host_tgtid_bind_type(sh) = FC_TGTID_BIND_BY_WWPN;
+
+	fc_host_maxframe_size(sh) = pp0->MaxFrameSize;
+
+	fc_host_node_name(sh) =
+	    	(u64)pp0->WWNN.High << 32 | (u64)pp0->WWNN.Low;
+
+	fc_host_port_name(sh) =
+	    	(u64)pp0->WWPN.High << 32 | (u64)pp0->WWPN.Low;
+
+	fc_host_port_id(sh) = pp0->PortIdentifier;
+
+	class = pp0->SupportedServiceClass;
 	if (class & MPI_FCPORTPAGE0_SUPPORT_CLASS_1)
 		cos |= FC_COS_CLASS1;
 	if (class & MPI_FCPORTPAGE0_SUPPORT_CLASS_2)
 		cos |= FC_COS_CLASS2;
 	if (class & MPI_FCPORTPAGE0_SUPPORT_CLASS_3)
 		cos |= FC_COS_CLASS3;
+	fc_host_supported_classes(sh) = cos;
 
-	fc_host_node_name(ioc->sh) =
-	    	(u64)ioc->fc_port_page0[portnum].WWNN.High << 32
-		    | (u64)ioc->fc_port_page0[portnum].WWNN.Low;
-
-	fc_host_port_name(ioc->sh) =
-	    	(u64)ioc->fc_port_page0[portnum].WWPN.High << 32
-		    | (u64)ioc->fc_port_page0[portnum].WWPN.Low;
-
-	fc_host_port_id(ioc->sh) = ioc->fc_port_page0[portnum].PortIdentifier;
+	if (pp0->CurrentSpeed == MPI_FCPORTPAGE0_CURRENT_SPEED_1GBIT)
+		speed = FC_PORTSPEED_1GBIT;
+	else if (pp0->CurrentSpeed == MPI_FCPORTPAGE0_CURRENT_SPEED_2GBIT)
+		speed = FC_PORTSPEED_2GBIT;
+	else if (pp0->CurrentSpeed == MPI_FCPORTPAGE0_CURRENT_SPEED_4GBIT)
+		speed = FC_PORTSPEED_4GBIT;
+	else if (pp0->CurrentSpeed == MPI_FCPORTPAGE0_CURRENT_SPEED_10GBIT)
+		speed = FC_PORTSPEED_10GBIT;
+	else
+		speed = FC_PORTSPEED_UNKNOWN;
+	fc_host_speed(sh) = speed;
 
-	fc_host_supported_classes(ioc->sh) = cos;
+	speed = 0;
+	if (pp0->SupportedSpeeds & MPI_FCPORTPAGE0_SUPPORT_1GBIT_SPEED)
+		speed |= FC_PORTSPEED_1GBIT;
+	if (pp0->SupportedSpeeds & MPI_FCPORTPAGE0_SUPPORT_2GBIT_SPEED)
+		speed |= FC_PORTSPEED_2GBIT;
+	if (pp0->SupportedSpeeds & MPI_FCPORTPAGE0_SUPPORT_4GBIT_SPEED)
+		speed |= FC_PORTSPEED_4GBIT;
+	if (pp0->SupportedSpeeds & MPI_FCPORTPAGE0_SUPPORT_10GBIT_SPEED)
+		speed |= FC_PORTSPEED_10GBIT;
+	fc_host_supported_speeds(sh) = speed;
+
+	port_state = FC_PORTSTATE_UNKNOWN;
+	if (pp0->PortState == MPI_FCPORTPAGE0_PORTSTATE_ONLINE)
+		port_state = FC_PORTSTATE_ONLINE;
+	else if (pp0->PortState == MPI_FCPORTPAGE0_PORTSTATE_OFFLINE)
+		port_state = FC_PORTSTATE_LINKDOWN;
+	fc_host_port_state(sh) = port_state;
+
+	port_type = FC_PORTTYPE_UNKNOWN;
+	if (pp0->Flags & MPI_FCPORTPAGE0_FLAGS_ATTACH_POINT_TO_POINT)
+		port_type = FC_PORTTYPE_PTP;
+	else if (pp0->Flags & MPI_FCPORTPAGE0_FLAGS_ATTACH_PRIVATE_LOOP)
+		port_type = FC_PORTTYPE_LPORT;
+	else if (pp0->Flags & MPI_FCPORTPAGE0_FLAGS_ATTACH_PUBLIC_LOOP)
+		port_type = FC_PORTTYPE_NLPORT;
+	else if (pp0->Flags & MPI_FCPORTPAGE0_FLAGS_ATTACH_FABRIC_DIRECT)
+		port_type = FC_PORTTYPE_NPORT;
+	fc_host_port_type(sh) = port_type;
+
+	fc_host_fabric_name(sh) =
+	    (pp0->Flags & MPI_FCPORTPAGE0_FLAGS_FABRIC_WWN_VALID) ?
+		(u64) pp0->FabricWWNN.High << 32 | (u64) pp0->FabricWWPN.Low :
+		(u64)pp0->WWNN.High << 32 | (u64)pp0->WWNN.Low;
 
-	fc_host_tgtid_bind_type(ioc->sh) = FC_TGTID_BIND_BY_WWPN;
 }
 
 static void


--------------010801060900080202010207--
