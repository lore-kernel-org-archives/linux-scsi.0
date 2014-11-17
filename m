From: Terence Eden <terence.eden@gmail.com>
Subject: [PATCH] SCSI Improved spelling and documentation.
Date: Mon, 17 Nov 2014 21:22:43 +0000
Message-ID: <1416259363-11159-1-git-send-email-terence.eden@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: intel-linux-scu@intel.com
Cc: artur.paszkiewicz@intel.com, dave.jiang@intel.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org, Terence Eden <terence.eden@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Terence Eden <terence.eden@gmail.com>

I found the comments to be slightly confusing. Hopefully I've clarified some points.

Signed-off-by: Terence Eden <terence.eden@gmail.com>
---
 drivers/scsi/isci/port_config.c | 158 +++++++++++++++++++++-------------------
 1 file changed, 83 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index ac87974..b203bc9 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -77,11 +77,14 @@ enum SCIC_SDS_APC_ACTIVITY {
  * @address_one: A SAS Address to be compared.
  * @address_two: A SAS Address to be compared.
  *
- * Compare the two SAS Address and if SAS Address One is greater than SAS
- * Address Two then return > 0 else if SAS Address One is less than SAS Address
- * Two return < 0 Otherwise they are the same return 0 A signed value of x > 0
- * > y where x is returned for Address One > Address Two y is returned for
- * Address One < Address Two 0 is returned ofr Address One = Address Two
+ * Compare the two SAS Address: 
+ * if SAS Address One is greater than SAS Address Two then return > 0. 
+ * If SAS Address One is less than SAS Address Two return < 0. 
+ * Otherwise they are the same return 0. 
+ * A signed value of x > 0 > y where:
+ * x is returned for Address One > Address Two.
+ * y is returned for Address One < Address Two.
+ * 0 is returned for Address One = Address Two.
  */
 static s32 sci_sas_address_compare(
 	struct sci_sas_address address_one,
@@ -97,7 +100,7 @@ static s32 sci_sas_address_compare(
 		return -1;
 	}
 
-	/* The two SAS Address must be identical */
+	/* The two SAS Address must be identical. */
 	return 0;
 }
 
@@ -107,9 +110,10 @@ static s32 sci_sas_address_compare(
  * @phy: The phy object to match.
  *
  * This routine will find a matching port for the phy.  This means that the
- * port and phy both have the same broadcast sas address and same received sas
- * address. The port address or the NULL if there is no matching
- * port. port address if the port can be found to match the phy.
+ * port and phy both have the same broadcast SAS Address and same received SAS
+ * Address. 
+ * The port address or the NULL if there is no matching port. 
+ * Port address if the port can be found to match the phy.
  * NULL if there is no matching port for the phy.
  */
 static struct isci_port *sci_port_configuration_agent_find_port(
@@ -123,9 +127,9 @@ static struct isci_port *sci_port_configuration_agent_find_port(
 	struct sci_sas_address phy_attached_device_address;
 
 	/*
-	 * Since this phy can be a member of a wide port check to see if one or
-	 * more phys match the sent and received SAS address as this phy in which
-	 * case it should participate in the same port.
+	 * Since this phy can be a member of a wide port, check to see if one or
+	 * more phys match the sent and received SAS Address as this phy. In which
+	 * case, it should participate in the same port.
 	 */
 	sci_phy_get_sas_address(iphy, &phy_sas_address);
 	sci_phy_get_attached_sas_address(iphy, &phy_attached_device_address);
@@ -146,15 +150,19 @@ static struct isci_port *sci_port_configuration_agent_find_port(
 
 /**
  *
- * @controller: This is the controller object that contains the port agent
+ * @controller: This is the controller object that contains the port agent.
  * @port_agent: This is the port configruation agent for the controller.
  *
  * This routine will validate the port configuration is correct for the SCU
- * hardware.  The SCU hardware allows for port configurations as follows. LP0
- * -> (PE0), (PE0, PE1), (PE0, PE1, PE2, PE3) LP1 -> (PE1) LP2 -> (PE2), (PE2,
- * PE3) LP3 -> (PE3) enum sci_status SCI_SUCCESS the port configuration is valid for
- * this port configuration agent. SCI_FAILURE_UNSUPPORTED_PORT_CONFIGURATION
- * the port configuration is not valid for this port configuration agent.
+ * hardware.  The SCU hardware allows for port configurations as follows:
+ * LP0 -> (PE0), (PE0, PE1), (PE0, PE1, PE2, PE3) 
+ * LP1 -> (PE1) 
+ * LP2 -> (PE2), (PE2, PE3)
+ * LP3 -> (PE3)
+ * enum sci_status SCI_SUCCESS the port configuration is valid for
+ * this port configuration agent. 
+ * SCI_FAILURE_UNSUPPORTED_PORT_CONFIGURATION the port configuration
+ * is not valid for this port configuration agent.
  */
 static enum sci_status sci_port_configuration_agent_validate_ports(
 	struct isci_host *ihost,
@@ -164,8 +172,8 @@ static enum sci_status sci_port_configuration_agent_validate_ports(
 	struct sci_sas_address second_address;
 
 	/*
-	 * Sanity check the max ranges for all the phys the max index
-	 * is always equal to the port range index */
+	 * Sanity check the max ranges for all the phys.
+	 * The max index is always equal to the port range index. */
 	if (port_agent->phy_valid_port_range[0].max_index != 0 ||
 	    port_agent->phy_valid_port_range[1].max_index != 1 ||
 	    port_agent->phy_valid_port_range[2].max_index != 2 ||
@@ -174,7 +182,7 @@ static enum sci_status sci_port_configuration_agent_validate_ports(
 
 	/*
 	 * This is a request to configure a single x4 port or at least attempt
-	 * to make all the phys into a single port */
+	 * to make all the phys into a single port. */
 	if (port_agent->phy_valid_port_range[0].min_index == 0 &&
 	    port_agent->phy_valid_port_range[1].min_index == 0 &&
 	    port_agent->phy_valid_port_range[2].min_index == 0 &&
@@ -183,7 +191,7 @@ static enum sci_status sci_port_configuration_agent_validate_ports(
 
 	/*
 	 * This is a degenerate case where phy 1 and phy 2 are assigned
-	 * to the same port this is explicitly disallowed by the hardware
+	 * to the same port. This is explicitly disallowed by the hardware
 	 * unless they are part of the same x4 port and this condition was
 	 * already checked above. */
 	if (port_agent->phy_valid_port_range[2].min_index == 1) {
@@ -202,7 +210,7 @@ static enum sci_status sci_port_configuration_agent_validate_ports(
 	}
 
 	/*
-	 * PE0 and PE1 are configured into a 2x1 ports make sure that the
+	 * PE0 and PE1 are configured into a 2x1 ports. Make sure that the
 	 * SAS Address for PE0 and PE2 are different since they can not be
 	 * part of the same port. */
 	if (port_agent->phy_valid_port_range[0].min_index == 0 &&
@@ -216,7 +224,7 @@ static enum sci_status sci_port_configuration_agent_validate_ports(
 	}
 
 	/*
-	 * PE2 and PE3 are configured into a 2x1 ports make sure that the
+	 * PE2 and PE3 are configured into a 2x1 ports. Make sure that the
 	 * SAS Address for PE1 and PE3 are different since they can not be
 	 * part of the same port. */
 	if (port_agent->phy_valid_port_range[2].min_index == 2 &&
@@ -234,10 +242,10 @@ static enum sci_status sci_port_configuration_agent_validate_ports(
 
 /*
  * ******************************************************************************
- * Manual port configuration agent routines
+ * Manual port configuration agent routines.
  * ****************************************************************************** */
 
-/* verify all of the phys in the same port are using the same SAS address */
+/* Verify all of the phys in the same port are using the same SAS Address. */
 static enum sci_status
 sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
 					      struct sci_port_configuration_agent *port_agent)
@@ -259,13 +267,13 @@ sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
 		if (!phy_mask)
 			continue;
 		/*
-		 * Make sure that one or more of the phys were not already assinged to
+		 * Make sure that one or more of the phys were not already assigned to
 		 * a different port. */
 		if ((phy_mask & ~assigned_phy_mask) == 0) {
 			return SCI_FAILURE_UNSUPPORTED_PORT_CONFIGURATION;
 		}
 
-		/* Find the starting phy index for this round through the loop */
+		/* Find the starting phy index for this round through the loop. */
 		for (phy_index = 0; phy_index < SCI_MAX_PHYS; phy_index++) {
 			if ((phy_mask & (1 << phy_index)) == 0)
 				continue;
@@ -288,8 +296,8 @@ sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
 
 		/*
 		 * See how many additional phys are being added to this logical port.
-		 * Note: We have not moved the current phy_index so we will actually
-		 *       compare the startting phy with itself.
+		 * Note: We have not moved the current phy_index, so we will actually
+		 *       compare the starting phy with itself.
 		 *       This is expected and required to add the phy to the port. */
 		while (phy_index < SCI_MAX_PHYS) {
 			if ((phy_mask & (1 << phy_index)) == 0)
@@ -300,7 +308,7 @@ sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
 			if (sci_sas_address_compare(sas_address, phy_assigned_address) != 0) {
 				/*
 				 * The phy mask specified that this phy is part of the same port
-				 * as the starting phy and it is not so fail this configuration */
+				 * as the starting phy and it is not, so fail this configuration. */
 				return SCI_FAILURE_UNSUPPORTED_PORT_CONFIGURATION;
 			}
 
@@ -338,7 +346,7 @@ static void mpc_agent_timeout(unsigned long data)
 
 	port_agent->timer_pending = false;
 
-	/* Find the mask of phys that are reported read but as yet unconfigured into a port */
+	/* Find the mask of phys that are reported read but as yet unconfigured into a port. */
 	configure_phy_mask = ~port_agent->phy_configured_mask & port_agent->phy_ready_mask;
 
 	for (index = 0; index < SCI_MAX_PHYS; index++) {
@@ -362,7 +370,7 @@ static void sci_mpc_agent_link_up(struct isci_host *ihost,
 {
 	/* If the port is NULL then the phy was not assigned to a port.
 	 * This is because the phy was not given the same SAS Address as
-	 * the other PHYs in the port.
+	 * the other phys in the port.
 	 */
 	if (!iport)
 		return;
@@ -377,18 +385,18 @@ static void sci_mpc_agent_link_up(struct isci_host *ihost,
  *
  * @controller: This is the controller object that receives the link down
  *    notification.
- * @port: This is the port object associated with the phy.  If the is no
- *    associated port this is an NULL.  The port is an invalid
- *    handle only if the phy was never port of this port.  This happens when
- *    the phy is not broadcasting the same SAS address as the other phys in the
+ * @port: This is the port object associated with the phy.  If there is no
+ *    associated port, this is a NULL.  The port is an invalid
+ *    handle only if the phy was never part of this port.  This happens when
+ *    the phy is not broadcasting the same SAS Address as the other phys in the
  *    assigned port.
  * @phy: This is the phy object which has gone link down.
  *
  * This function handles the manual port configuration link down notifications.
- * Since all ports and phys are associated at initialization time we just turn
- * around and notifiy the port object of the link down event.  If this PHY is
- * not associated with a port there is no action taken. Is it possible to get a
- * link down notification from a phy that has no assocoated port?
+ * Since all ports and phys are associated at initialization time, we just turn
+ * around and notifiy the port object of the link down event.  If this phy is
+ * not associated with a port, there is no action taken. Is it possible to get a
+ * link down notification from a phy that has no associated port?
  */
 static void sci_mpc_agent_link_down(
 	struct isci_host *ihost,
@@ -409,8 +417,8 @@ static void sci_mpc_agent_link_down(
 
 		/*
 		 * Check to see if there are more phys waiting to be
-		 * configured into a port. If there are allow the SCI User
-		 * to tear down this port, if necessary, and then reconstruct
+		 * configured into a port. If there are, allow the SCI User
+		 * to tear down this port if necessary, and then reconstruct
 		 * the port after the timeout.
 		 */
 		if ((port_agent->phy_configured_mask == 0x0000) &&
@@ -426,7 +434,7 @@ static void sci_mpc_agent_link_down(
 	}
 }
 
-/* verify phys are assigned a valid SAS address for automatic port
+/* Verify phys are assigned a valid SAS Address for automatic port
  * configuration mode.
  */
 static enum sci_status
@@ -443,7 +451,7 @@ sci_apc_agent_validate_phy_configuration(struct isci_host *ihost,
 	while (phy_index < SCI_MAX_PHYS) {
 		port_index = phy_index;
 
-		/* Get the assigned SAS Address for the first PHY on the controller. */
+		/* Get the assigned SAS Address for the first phy on the controller. */
 		sci_phy_get_sas_address(&ihost->phys[phy_index],
 					    &sas_address);
 
@@ -451,7 +459,7 @@ sci_apc_agent_validate_phy_configuration(struct isci_host *ihost,
 			sci_phy_get_sas_address(&ihost->phys[phy_index],
 						     &phy_assigned_address);
 
-			/* Verify each of the SAS address are all the same for every PHY */
+			/* Verify each of the SAS Address are all the same for every phy. */
 			if (sci_sas_address_compare(sas_address, phy_assigned_address) == 0) {
 				port_agent->phy_valid_port_range[phy_index].min_index = port_index;
 				port_agent->phy_valid_port_range[phy_index].max_index = phy_index;
@@ -498,8 +506,8 @@ static void sci_apc_agent_configure_ports(struct isci_host *ihost,
 			apc_activity = SCIC_SDS_APC_SKIP_PHY;
 	} else {
 		/*
-		 * There is no matching Port for this PHY so lets search through the
-		 * Ports and see if we can add the PHY to its own port or maybe start
+		 * There is no matching port for this phy, so let's search through the
+		 * ports and see if we can add the phy to its own port or maybe start
 		 * the timer and wait to see if a wider port can be made.
 		 *
 		 * Note the break when we reach the condition of the port id == phy id */
@@ -509,27 +517,27 @@ static void sci_apc_agent_configure_ports(struct isci_host *ihost,
 
 			iport = &ihost->ports[port_index];
 
-			/* First we must make sure that this PHY can be added to this Port. */
+			/* First we must make sure that this phy can be added to this port. */
 			if (sci_port_is_valid_phy_assignment(iport, iphy->phy_index)) {
 				/*
-				 * Port contains a PHY with a greater PHY ID than the current
-				 * PHY that has gone link up.  This phy can not be part of any
-				 * port so skip it and move on. */
+				 * Port contains a phy with a greater phy ID than the current
+				 * phy that has gone link up.  This phy can not be part of any
+				 * port, so skip it and move on. */
 				if (iport->active_phy_mask > (1 << iphy->phy_index)) {
 					apc_activity = SCIC_SDS_APC_SKIP_PHY;
 					break;
 				}
 
 				/*
-				 * We have reached the end of our Port list and have not found
-				 * any reason why we should not either add the PHY to the port
+				 * We have reached the end of our port list and have not found
+				 * any reason why we should not either add the phy to the port
 				 * or wait for more phys to become active. */
 				if (iport->physical_port_index == iphy->phy_index) {
 					/*
-					 * The Port either has no active PHYs.
-					 * Consider that if the port had any active PHYs we would have
-					 * or active PHYs with
-					 * a lower PHY Id than this PHY. */
+					 * The port either has no active phys.
+					 * Consider that if the port had any active phys we would have
+					 * or active phys with
+					 * a lower phy Id than this phy. */
 					if (apc_activity != SCIC_SDS_APC_START_TIMER) {
 						apc_activity = SCIC_SDS_APC_ADD_PHY;
 					}
@@ -538,16 +546,16 @@ static void sci_apc_agent_configure_ports(struct isci_host *ihost,
 				}
 
 				/*
-				 * The current Port has no active PHYs and this PHY could be part
-				 * of this Port.  Since we dont know as yet setup to start the
+				 * The current port has no active phys and this phy could be part
+				 * of this port.  Since we do not know as yet, setup to start the
 				 * timer and see if there is a better configuration. */
 				if (iport->active_phy_mask == 0) {
 					apc_activity = SCIC_SDS_APC_START_TIMER;
 				}
 			} else if (iport->active_phy_mask != 0) {
 				/*
-				 * The Port has an active phy and the current Phy can not
-				 * participate in this port so skip the PHY and see if
+				 * The port has an active phy and the current Phy can not
+				 * participate in this port, so skip the phy and see if
 				 * there is a better configuration. */
 				apc_activity = SCIC_SDS_APC_SKIP_PHY;
 			}
@@ -557,9 +565,9 @@ static void sci_apc_agent_configure_ports(struct isci_host *ihost,
 	/*
 	 * Check to see if the start timer operations should instead map to an
 	 * add phy operation.  This is caused because we have been waiting to
-	 * add a phy to a port but could not becuase the automatic port
+	 * add a phy to a port but could not because the automatic port
 	 * configuration engine had a choice of possible ports for the phy.
-	 * Since we have gone through a timeout we are going to restrict the
+	 * Since we have gone through a timeout, we are going to restrict the
 	 * choice to the smallest possible port. */
 	if (
 		(start_timer == false)
@@ -584,7 +592,7 @@ static void sci_apc_agent_configure_ports(struct isci_host *ihost,
 
 	case SCIC_SDS_APC_SKIP_PHY:
 	default:
-		/* do nothing the PHY can not be made part of a port at this time. */
+		/* Do nothing. The phy can not be made part of a port at this time. */
 		break;
 	}
 }
@@ -593,13 +601,13 @@ static void sci_apc_agent_configure_ports(struct isci_host *ihost,
  * sci_apc_agent_link_up - handle apc link up events
  * @scic: This is the controller object that receives the link up
  *    notification.
- * @sci_port: This is the port object associated with the phy.  If the is no
- *    associated port this is an NULL.
+ * @sci_port: This is the port object associated with the phy.  If there is no
+ *    associated port this is a NULL.
  * @sci_phy: This is the phy object which has gone link up.
  *
  * This method handles the automatic port configuration for link up
  * notifications. Is it possible to get a link down notification from a phy
- * that has no assocoated port?
+ * that has no associated port?
  */
 static void sci_apc_agent_link_up(struct isci_host *ihost,
 				       struct sci_port_configuration_agent *port_agent,
@@ -609,12 +617,12 @@ static void sci_apc_agent_link_up(struct isci_host *ihost,
 	u8 phy_index  = iphy->phy_index;
 
 	if (!iport) {
-		/* the phy is not the part of this port */
+		/* The phy is not part of this port. */
 		port_agent->phy_ready_mask |= 1 << phy_index;
 		sci_apc_agent_start_timer(port_agent,
 					  SCIC_SDS_APC_WAIT_LINK_UP_NOTIFICATION);
 	} else {
-		/* the phy is already the part of the port */
+		/* The phy is already part of the port. */
 		port_agent->phy_ready_mask |= 1 << phy_index;
 		sci_port_link_up(iport, iphy);
 	}
@@ -624,13 +632,13 @@ static void sci_apc_agent_link_up(struct isci_host *ihost,
  *
  * @controller: This is the controller object that receives the link down
  *    notification.
- * @iport: This is the port object associated with the phy.  If the is no
- *    associated port this is an NULL.
+ * @iport: This is the port object associated with the phy.  If there is no
+ *    associated port this is a NULL.
  * @iphy: This is the phy object which has gone link down.
  *
  * This method handles the automatic port configuration link down
- * notifications. not associated with a port there is no action taken. Is it
- * possible to get a link down notification from a phy that has no assocoated
+ * notifications. If it is not associated with a port there is no action taken.
+ * Is it possible to get a link down notification from a phy that has no associated
  * port?
  */
 static void sci_apc_agent_link_down(
@@ -653,7 +661,7 @@ static void sci_apc_agent_link_down(
 	}
 }
 
-/* configure the phys into ports when the timer fires */
+/* Configure the phys into ports when the timer fires. */
 static void apc_agent_timeout(unsigned long data)
 {
 	u32 index;
-- 
1.9.1
