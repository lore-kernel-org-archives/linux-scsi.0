From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [03/27]
Date: Thu, 17 Feb 2005 12:35:36 -0500
Message-ID: <4214D5E8.9000907@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:60048 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262320AbVBQRfl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:35:41 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHZer30363
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:35:40 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHZdb20821
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:35:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is the SAS domain discovery code. Part 1/3.

diff -Nru a/drivers/scsi/adp94xx/adp94xx_discover.c b/drivers/scsi/adp94xx/adp94xx_discover.c
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/drivers/scsi/adp94xx/adp94xx_discover.c	2005-02-16 16:08:12 -05:00
@@ -0,0 +1,2460 @@
+#define NO_VPD_WORKAROUND
+#define SMP_OVERRUN_WORKAROUND
+#define SMP_UNDERRUN_WORKAROUND
+/*
+ * Adaptec ADP94xx SAS HBA device driver for Linux.
+ *
+ * Copyright (c) 2004 Adaptec Inc.
+ * All rights reserved.
+ *
+ * Adapted by : Robert Tarte  <robt@PacificCodeWorks.com>
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ * The source in this file is adapted from: SASDiscoverSimulation.cpp,
+ * from the SAS-1.1 draft, sas1r07.pdf, project T10/1601-D,
+ * ISO/IEC 14776-151:200x.
+ *
+ * This is an implementation of the initiator based expander discovery
+ * and configuration.  Structure names used are equivalent to those
+ * referenced in the SAS document.
+ * Basic assumptions:
+ *
+ * 1. Change primitives will initiate a rediscovery/configuration sequence.
+ * 2. Table locations for SASAddresses are deterministic for a specific
+ * topology only, when the topology changes, the location of a SASAddress
+ * in an ASIC table cannot be assumed.
+ * 3. A complete discovery level occurs before the configuration of the
+ * level begins, multiple passes are required as the levels of expanders
+ * encountered between the initiator and the end devices is increased.
+ * 4. Configuration of a single expander occurs before proceeding to
+ * subsequent expanders attached.
+ * 5. The Attached structure is filled in following OOB and is available
+ * from the initialization routines.
+ *
+ * $Id: //depot/razor/linux/src/adp94xx_discover.c#65 $
+ * 
+ */
+#define KDB_ENABLE	0
+#define DISCOVER_DEBUG	0
+
+#include "adp94xx_osm.h"
+#include "adp94xx_inline.h"
+#include "adp94xx_sata.h"
+#if KDB_ENABLE
+#include "linux/kdb.h"
+#endif
+
+/*
+ * this defines the type of algorithm used for discover
+ */
+#if 0
+int DiscoverAlgorithm = SAS_SIMPLE_LEVEL_DESCENT;
+#else
+int DiscoverAlgorithm = SAS_UNIQUE_LEVEL_DESCENT;
+#endif
+
+#define ROUTE_ENTRY(expander, i, j) \
+	(expander->RouteTable + \
+		((expander->num_phys * (i) * SAS_ADDR_LEN) + \
+		(j) * SAS_ADDR_LEN))
+
+#define DUMP_EXPANDER(s, expander) \
+	asd_dump_expander((uint8_t *)__FUNCTION__, __LINE__, (s), expander)
+
+#define NEW_STATE(new_state)	new_state(sm_contextp, new_state)
+
+struct state_machine asd_DiscoverySM = {
+	asd_DiscoverySM_Initialize,
+	asd_DiscoverySM_StateMachine,
+	asd_DiscoverySM_Finish,
+	asd_DiscoverySM_Abort,
+	ASD_STATE_DISCOVER_START
+};
+
+struct state_machine asd_DiscoverExpanderSM = {
+	asd_DiscoverExpanderSM_Initialize,
+	asd_DiscoverExpanderSM_StateMachine,
+	asd_DiscoverExpanderSM_Finish,
+	asd_DiscoverExpanderSM_Abort,
+	ASD_STATE_REPORT_AND_DISCOVER_START
+};
+
+struct state_machine asd_DiscoverFindBoundarySM = {
+	asd_DiscoverFindBoundarySM_Initialize,
+	asd_DiscoverFindBoundarySM_StateMachine,
+	asd_DiscoverFindBoundarySM_Finish,
+	asd_DiscoverFindBoundarySM_Abort,
+	ASD_STATE_FIND_BOUNDARY_START
+};
+
+struct state_machine asd_DiscoverConfigSetSM = {
+	asd_DiscoverConfigSetSM_Initialize,
+	asd_DiscoverConfigSetSM_StateMachine,
+	asd_DiscoverConfigSetSM_Finish,
+	asd_DiscoverConfigSetSM_Abort,
+	ASD_STATE_CONFIG_SET_START
+};
+
+struct state_machine asd_ConfigureExpanderSM = {
+	asd_ConfigureExpanderSM_Initialize,
+	asd_ConfigureExpanderSM_StateMachine,
+	asd_ConfigureExpanderSM_Finish,
+	asd_ConfigureExpanderSM_Abort,
+	ASD_STATE_CONFIG_EXPANDER_START
+};
+
+struct state_machine asd_ConfigureATA_SM = {
+	asd_ConfigureATA_SM_Initialize,
+	asd_ConfigureATA_SM_StateMachine,
+	asd_ConfigureATA_SM_Finish,
+	asd_ConfigureATA_SM_Abort,
+	ASD_STATE_CONFIGURE_ATA_START
+};
+
+struct state_machine asd_InitSATA_SM = {
+	asd_InitSATA_SM_Initialize,
+	asd_InitSATA_SM_StateMachine,
+	asd_InitSATA_SM_Finish,
+	asd_InitSATA_SM_Abort,
+	ASD_STATE_INIT_SATA_START
+};
+
+struct state_machine asd_SATA_SpinHoldSM = {
+	asd_SATA_SpinHoldSM_Initialize,
+	asd_SATA_SpinHoldSM_StateMachine,
+	asd_SATA_SpinHoldSM_Finish,
+	asd_SATA_SpinHoldSM_Abort,
+	ASD_STATE_SATA_SPINHOLD_START
+};
+
+struct state_machine asd_InitSAS_SM = {
+	asd_InitSAS_SM_Initialize,
+	asd_InitSAS_SM_StateMachine,
+	asd_InitSAS_SM_Finish,
+	asd_InitSAS_SM_Abort,
+	ASD_STATE_INIT_SAS_START
+};
+
+struct state_machine asd_InitSMP_SM = {
+	asd_InitSMP_SM_Initialize,
+	asd_InitSMP_SM_StateMachine,
+	asd_InitSMP_SM_Finish,
+	asd_InitSMP_SM_Abort,
+	ASD_STATE_INIT_SMP_START
+};
+
+extern void
+asd_scb_internal_done(struct asd_softc *asd, struct scb *scb,
+		      struct asd_done_list *dl);
+extern void asd_run_device_queues(struct asd_softc *asd);
+
+struct asd_target *asd_discover_get_target(struct state_machine_context
+					   *sm_contextp,
+					   uint8_t * dest_sas_address,
+					   struct list_head *old_discover_listp,
+					   struct list_head *found_listp,
+					   unsigned conn_rate,
+					   TRANSPORT_TYPE transport_type);
+
+struct asd_DiscoverySM_Context;
+
+static void asd_invalidate_targets(struct asd_softc *asd,
+				   struct asd_port *port);
+static void asd_validate_targets_hotplug(struct asd_softc *asd,
+					 struct asd_port *port,
+					 struct asd_DiscoverySM_Context *ctx);
+static void asd_validate_targets_init(struct asd_softc *asd);
+static void asd_apply_conn_mask(struct asd_softc *asd,
+				struct list_head *discover_list);
+static int asd_discovery_queue_cmd(struct asd_softc *asd,
+				   struct scb *scb, struct asd_target *targ,
+				   struct asd_device *dev);
+
+#if DISCOVER_DEBUG
+static void asd_dump_tree(struct asd_softc *asd, struct asd_port *port);
+#endif
+
+void asd_print_conn_rate(unsigned conn_rate, char *s)
+{
+	switch (conn_rate) {
+	case SAS_RATE_30GBPS:
+		printk(" 3.0-GBPS");
+		break;
+	case SAS_RATE_15GBPS:
+		printk(" 1.5-GBPS");
+		break;
+	default:
+		printk(" \?\?-GBPS");
+		break;
+	}
+	printk("%s", s);
+}
+
+void asd_print_state(unsigned state, char *s)
+{
+	switch (state) {
+	case ASD_STATE_DISCOVER_START:
+		printk("ASD_STATE_DISCOVER_START");
+		break;
+
+	case ASD_STATE_DISCOVER_ATTACHED:
+		printk("ASD_STATE_DISCOVER_ATTACHED");
+		break;
+
+	case ASD_STATE_FIND_BOUNDARY:
+		printk("ASD_STATE_FIND_BOUNDARY");
+		break;
+
+	case ASD_STATE_CONFIG_BOUNDARY_SET:
+		printk("ASD_STATE_CONFIG_BOUNDARY_SET");
+		break;
+
+	case ASD_STATE_CONFIG_ATTACHED_SET:
+		printk("ASD_STATE_CONFIG_ATTACHED_SET");
+		break;
+
+	case ASD_STATE_FINISHED:
+		printk("ASD_STATE_FINISHED");
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD:
+		printk("ASD_STATE_SATA_SPINHOLD");
+		break;
+
+	case ASD_STATE_INIT_SATA:
+		printk("ASD_STATE_INIT_SATA");
+		break;
+
+	case ASD_STATE_INIT_SAS:
+		printk("ASD_STATE_INIT_SAS");
+		break;
+
+	case ASD_STATE_INIT_SMP:
+		printk("ASD_STATE_INIT_SMP");
+		break;
+
+	case ASD_STATE_FAILED:
+		printk("ASD_STATE_FAILED");
+		break;
+
+	case ASD_STATE_REPORT_AND_DISCOVER_START:
+		printk("ASD_STATE_REPORT_AND_DISCOVER_START");
+		break;
+
+	case ASD_STATE_ISSUE_REPORT_GENERAL:
+		printk("ASD_STATE_ISSUE_REPORT_GENERAL");
+		break;
+
+	case ASD_STATE_ISSUE_DISCOVER_LOOP:
+		printk("ASD_STATE_ISSUE_DISCOVER_LOOP");
+		break;
+
+	case ASD_STATE_REPORT_AND_DISCOVER_FINISHED:
+		printk("ASD_STATE_REPORT_AND_DISCOVER_FINISHED");
+		break;
+
+	case ASD_STATE_REPORT_AND_DISCOVER_FAILED:
+		printk("ASD_STATE_REPORT_AND_DISCOVER_FAILED");
+		break;
+
+	case ASD_STATE_FIND_BOUNDARY_START:
+		printk("ASD_STATE_FIND_BOUNDARY_START");
+		break;
+
+	case ASD_STATE_FIND_BOUNDARY_LOOP:
+		printk("ASD_STATE_FIND_BOUNDARY_LOOP");
+		break;
+
+	case ASD_STATE_FIND_BOUNDARY_FINISHED:
+		printk("ASD_STATE_FIND_BOUNDARY_FINISHED");
+		break;
+
+	case ASD_STATE_FIND_BOUNDARY_FAILED:
+		printk("ASD_STATE_FIND_BOUNDARY_FAILED");
+		break;
+
+	case ASD_STATE_CONFIG_SET_START:
+		printk("ASD_STATE_CONFIG_SET_START");
+		break;
+
+	case ASD_STATE_CONFIG_SET_ISSUE_DISCOVER:
+		printk("ASD_STATE_CONFIG_SET_ISSUE_DISCOVER");
+		break;
+
+	case ASD_STATE_CONFIG_SET_CONFIGURE_EXPANDER:
+		printk("ASD_STATE_CONFIG_SET_CONFIGURE_EXPANDER");
+		break;
+
+	case ASD_STATE_CONFIG_SET_FINISHED:
+		printk("ASD_STATE_CONFIG_SET_FINISHED");
+		break;
+
+	case ASD_STATE_CONFIG_SET_FAILED:
+		printk("ASD_STATE_CONFIG_SET_FAILED");
+		break;
+
+	case ASD_STATE_CONFIG_EXPANDER_START:
+		printk("ASD_STATE_CONFIG_EXPANDER_START");
+		break;
+
+	case ASD_STATE_CONFIG_EXPANDER_ROUTE:
+		printk("ASD_STATE_CONFIG_EXPANDER_ROUTE");
+		break;
+
+	case ASD_STATE_CONFIG_EXPANDER_ROUTE_LOOP:
+		printk("ASD_STATE_CONFIG_EXPANDER_ROUTE_LOOP");
+		break;
+
+	case ASD_STATE_CONFIG_EXPANDER_FINISHED:
+		printk("ASD_STATE_CONFIG_EXPANDER_FINISHED");
+		break;
+
+	case ASD_STATE_CONFIG_EXPANDER_FAILED:
+		printk("ASD_STATE_CONFIG_EXPANDER_FAILED");
+		break;
+
+	case ASD_STATE_INIT_SATA_START:
+		printk("ASD_STATE_INIT_SATA_START");
+		break;
+
+	case ASD_STATE_INIT_SATA_REPORT_PHY:
+		printk("ASD_STATE_INIT_SATA_REPORT_PHY");
+		break;
+
+	case ASD_STATE_INIT_SATA_IDENTIFY:
+		printk("ASD_STATE_INIT_SATA_IDENTIFY");
+		break;
+
+	case ASD_STATE_INIT_SATA_CONFIGURE_FEATURES:
+		printk("ASD_STATE_INIT_SATA_CONFIGURE_FEATURES");
+		break;
+
+	case ASD_STATE_INIT_SATA_FINISHED:
+		printk("ASD_STATE_INIT_SATA_FINISHED");
+		break;
+
+	case ASD_STATE_INIT_SATA_FAILED:
+		printk("ASD_STATE_INIT_SATA_FAILED");
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD_START:
+		printk("ASD_STATE_SATA_SPINHOLD_START");
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD_PHY_CONTROL:
+		printk("ASD_STATE_SATA_SPINHOLD_PHY_CONTROL");
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD_DISCOVER:
+		printk("ASD_STATE_SATA_SPINHOLD_DISCOVER");
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD_FINISHED:
+		printk("ASD_STATE_SATA_SPINHOLD_FINISHED");
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD_FAILED:
+		printk("ASD_STATE_SATA_SPINHOLD_FAILED");
+		break;
+
+	case ASD_STATE_INIT_SAS_START:
+		printk("ASD_STATE_INIT_SAS_START");
+		break;
+
+	case ASD_STATE_INIT_SAS_INQUIRY:
+		printk("ASD_STATE_INIT_SAS_INQUIRY");
+		break;
+
+	case ASD_STATE_INIT_SAS_GET_DEVICE_ID:
+		printk("ASD_STATE_INIT_SAS_GET_DEVICE_ID");
+		break;
+
+	case ASD_STATE_INIT_SAS_GET_SERIAL_NUMBER:
+		printk("ASD_STATE_INIT_SAS_GET_SERIAL_NUMBER");
+		break;
+
+	case ASD_STATE_INIT_SAS_ISSUE_REPORT_LUNS:
+		printk("ASD_STATE_INIT_SAS_ISSUE_REPORT_LUNS");
+		break;
+
+	case ASD_STATE_INIT_SAS_GET_PORT_CONTROL:
+		printk("ASD_STATE_INIT_SAS_GET_PORT_CONTROL");
+		break;
+
+	case ASD_STATE_INIT_SAS_FINISHED:
+		printk("ASD_STATE_INIT_SAS_FINISHED");
+		break;
+
+	case ASD_STATE_INIT_SAS_FAILED:
+		printk("ASD_STATE_INIT_SAS_FAILED");
+		break;
+
+	case ASD_STATE_INIT_SMP_START:
+		printk("ASD_STATE_INIT_SMP_START");
+		break;
+
+	case ASD_STATE_INIT_SMP_REPORT_MANUFACTURER_INFO:
+		printk("ASD_STATE_INIT_SMP_REPORT_MANUFACTURER_INFO");
+		break;
+
+	case ASD_STATE_INIT_SMP_FINISHED:
+		printk("ASD_STATE_INIT_SMP_FINISHED");
+		break;
+
+	case ASD_STATE_INIT_SMP_FAILED:
+		printk("ASD_STATE_INIT_SMP_FAILED");
+		break;
+
+	case ASD_STATE_CONFIGURE_ATA_START:
+		printk("ASD_STATE_CONFIGURE_ATA_START");
+		break;
+
+	case ASD_STATE_CONFIGURE_ATA_FEATURES:
+		printk("ASD_STATE_CONFIGURE_ATA_FEATURES");
+		break;
+
+	case ASD_STATE_CONFIGURE_ATA_FINISHED:
+		printk("ASD_STATE_CONFIGURE_ATA_FINISHED");
+		break;
+
+	case ASD_STATE_CONFIGURE_ATA_FAILED:
+		printk("ASD_STATE_CONFIGURE_ATA_FAILED");
+		break;
+
+	default:
+		printk("[0x%04x]", state);
+		break;
+	}
+
+	printk("%s", s);
+}
+
+void SM_new_state(struct state_machine_context *sm_contextp, unsigned new_state)
+{
+	struct state_information *state_infop;
+
+	SETUP_STATE(sm_contextp);
+
+	//printk("[%d]===== ", sm_contextp->state_stack_top);
+	//asd_print_state(state_infop->current_state, " -> ");
+	//asd_print_state(new_state, "\n");
+
+	if ((new_state & state_infop->state_machine_p->first_state) !=
+	    state_infop->state_machine_p->first_state) {
+
+		printk("illegal state 0x%x\n", new_state);
+		printk("[%d]===== ", sm_contextp->state_stack_top);
+		asd_print_state(state_infop->current_state, " -> ");
+		asd_print_state(new_state, "\n");
+	}
+
+	state_infop->current_state = new_state;
+}
+
+DISCOVER_RESULTS
+asd_run_state_machine(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	DISCOVER_RESULTS results;
+
+	SETUP_STATE(sm_contextp);
+
+	results = state_infop->state_machine_p->state_machine(sm_contextp);
+
+	while (results != DISCOVER_OK) {
+
+		state_infop =
+		    &sm_contextp->state_stack[sm_contextp->state_stack_top];
+
+		if (results == DISCOVER_FAILED) {
+			printk("State Machine Failure: ");
+			asd_print_state(state_infop->current_state, "\n");
+		}
+
+		if ((results == DISCOVER_FINISHED) ||
+		    (results == DISCOVER_FAILED)) {
+
+			state_infop->state_machine_p->finish(sm_contextp,
+							     results);
+
+			if (sm_contextp->state_stack_top == 0) {
+
+				//printk("nothing on stack\n");
+
+				return DISCOVER_OK;
+			}
+
+			POP_STATE(sm_contextp);
+		}
+
+		results =
+		    state_infop->state_machine_p->state_machine(sm_contextp);
+	}
+
+	return results;
+}
+
+#define ASD_PUSH_STATE_MACHINE(sm_contextp, state_machine_p, arg)	\
+	asd_push_state_machine(sm_contextp, #state_machine_p,		\
+	state_machine_p, arg)
+
+DISCOVER_RESULTS
+asd_push_state_machine(struct state_machine_context * sm_contextp,
+		       char *s,
+		       struct state_machine * state_machine_p, void *arg)
+{
+	struct state_information *state_infop;
+	DISCOVER_RESULTS results;
+
+#if 0
+	printk("\n\n%s:=====================================================\n",
+	       __FUNCTION__);
+	printk("%s: %s ============================\n", __FUNCTION__, s);
+	printk("%s:=====================================================\n\n\n",
+	       __FUNCTION__);
+#endif
+
+	sm_contextp->state_stack_top++;
+
+	SETUP_STATE(sm_contextp);
+
+	state_infop->current_state = state_machine_p->first_state;
+	state_infop->stack_top = 0;
+	state_infop->state_machine_p = state_machine_p;
+
+	results = state_machine_p->initialize(sm_contextp, arg);
+
+	if (results != DISCOVER_CONTINUE) {
+
+		state_infop->state_machine_p->finish(sm_contextp, results);
+
+		if (sm_contextp->state_stack_top == 0) {
+
+			//printk("nothing on stack\n");
+
+			return results;
+		}
+
+		POP_STATE(sm_contextp);
+	}
+
+	return results;
+}
+
+void asd_abort_state_machine(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+
+	SETUP_STATE(sm_contextp);
+
+	while (sm_contextp->state_stack_top != -1) {
+
+		state_infop =
+		    &sm_contextp->state_stack[sm_contextp->state_stack_top];
+
+		state_infop->state_machine_p->abort(sm_contextp);
+
+		POP_STATE(sm_contextp);
+	}
+}
+
+void
+asd_dump_expander(char *function,
+		  unsigned line, char *string, struct asd_target *expander)
+{
+	unsigned i;
+	struct Discover *discover;
+
+	printk("||||||||||| - %s  - %s:%d:\n", string, function, line);
+	printk("||||||||||| - %0llx - ",
+	       *((uint64_t *) expander->ddb_profile.sas_addr));
+
+	if (expander->management_type == ASD_DEVICE_END) {
+		printk("\n");
+		return;
+	}
+
+	printk("num_phys %d\n", expander->num_phys);
+
+	for (i = 0; i < expander->num_phys; i++) {
+
+		discover = &(expander->Phy[i].Result);
+
+		printk("||||||||||| - phy %d attached to %0llx\n", i,
+		       *((uint64_t *) discover->AttachedSASAddress));
+	}
+}
+
+void asd_dump_expander_list(char *s, struct list_head *discover_listp)
+{
+	struct asd_target *target;
+	struct asd_target *parent;
+
+	printk("----- %s\n", s);
+
+	list_for_each_entry(target, discover_listp, all_domain_targets) {
+
+		DUMP_EXPANDER("target:", target);
+
+		printk(" %0llx", *((uint64_t *) target->ddb_profile.sas_addr));
+
+		asd_print_conn_rate(target->ddb_profile.conn_rate, "\n");
+
+		for (parent = target->parent; parent != NULL;
+		     parent = parent->parent) {
+
+			printk("\t:%0llx\n",
+			       *((uint64_t *) parent->ddb_profile.sas_addr));
+		}
+	}
+
+	printk("-----\n");
+}
+
+void
+asd_discover_wakeup_state_machine(struct state_machine_context *sm_contextp)
+{
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	discover_contextp->port->events |= ASD_DISCOVERY_EVENT;
+
+	asd_wakeup_sem(&discover_contextp->asd->platform_data->discovery_sem);
+}
+
+DISCOVER_RESULTS
+asd_ssp_request(struct state_machine_context *sm_contextp,
+		struct asd_target *target,
+		uint8_t * command,
+		unsigned command_len,
+		dma_addr_t buf_busaddr, unsigned buffer_len, unsigned direction)
+{
+	struct asd_ssp_task_hscb *ssp_hscb;
+	unsigned long flags;
+	struct scb *scb;
+	struct sg_element *sg;
+	int error;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	asd_lock(discover_contextp->asd, &flags);
+
+	/*
+	 * Get an scb to use.
+	 */
+	if ((scb = asd_hwi_get_scb(discover_contextp->asd, 1)) == NULL) {
+		// TODO - fix this
+
+		asd_unlock(discover_contextp->asd, &flags);
+
+		return DISCOVER_FAILED;
+	}
+
+	scb->flags |= SCB_INTERNAL;
+
+	scb->platform_data->targ = target;
+
+	scb->platform_data->dev = NULL;
+
+	list_add_tail(&scb->owner_links,
+		      &discover_contextp->asd->platform_data->pending_os_scbs);
+
+	ssp_hscb = &scb->hscb->ssp_task;
+
+	ssp_hscb->header.opcode = SCB_INITIATE_SSP_TASK;
+
+	asd_build_sas_header(target, ssp_hscb);
+
+	ssp_hscb->protocol_conn_rate |= PROTOCOL_TYPE_SSP;
+
+	ssp_hscb->data_dir_flags |= direction;
+
+	ssp_hscb->xfer_len = asd_htole32(buffer_len);
+
+	memcpy(ssp_hscb->cdb, command, command_len);
+
+	memset(&ssp_hscb->cdb[command_len], 0,
+	       SCB_EMBEDDED_CDB_SIZE - command_len);
+
+	sg = scb->sg_list;
+
+	scb->platform_data->buf_busaddr = buf_busaddr;
+
+	error = asd_sg_setup(sg, buf_busaddr, buffer_len, /*last */ 1);
+
+	if (error != 0) {
+		return DISCOVER_FAILED;
+	}
+
+	memcpy(ssp_hscb->sg_elements, scb->sg_list, sizeof(*sg));
+
+	scb->sg_count = 1;
+
+	asd_push_post_stack(discover_contextp->asd, scb, (void *)sm_contextp,
+			    asd_ssp_request_done);
+
+	scb->flags |= SCB_ACTIVE;
+
+	asd_hwi_post_scb(discover_contextp->asd, scb);
+
+	asd_unlock(discover_contextp->asd, &flags);
+
+	return DISCOVER_OK;
+}
+
+void
+asd_ssp_request_done(struct asd_softc *asd,
+		     struct scb *scb, struct asd_done_list *done_listp)
+{
+	struct state_machine_context *sm_contextp;
+	struct discover_context *discover_contextp;
+
+	sm_contextp = (struct state_machine_context *)scb->io_ctx;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	asd_scb_internal_done(asd, scb, done_listp);
+
+	discover_contextp->resid_len = 0;
+
+	/*
+	 * TODO: need better return value here
+	 */
+	switch (done_listp->opcode) {
+	case TASK_COMP_WO_ERR:
+		discover_contextp->openStatus = OPEN_ACCEPT;
+		break;
+
+	case TASK_COMP_W_UNDERRUN:
+		discover_contextp->openStatus = OPEN_ACCEPT;
+		discover_contextp->resid_len =
+		    asd_le32toh(done_listp->stat_blk.data.res_len);
+		break;
+
+	case TASK_F_W_OPEN_REJECT:
+		printk("%s:%d: reject abandon_open %x reason %x\n",
+		       __FUNCTION__, __LINE__,
+		       done_listp->stat_blk.open_reject.abandon_open,
+		       done_listp->stat_blk.open_reject.reason);
+		break;
+
+	case SSP_TASK_COMP_W_RESP:
+	default:
+#if 0
+		printk("%s:%d opcode=0x%x\n", __FUNCTION__, __LINE__,
+		       done_listp->opcode);
+#endif
+		/*
+		 * TODO: need better return value here
+		 */
+		discover_contextp->openStatus = OPEN_REJECT_BAD_DESTINATION;
+		break;
+	}
+
+	sm_contextp->wakeup_state_machine(sm_contextp);
+}
+
+DISCOVER_RESULTS
+asd_smp_request(struct state_machine_context *sm_contextp,
+		struct asd_target *target,
+		unsigned request_length, unsigned response_length)
+{
+	struct asd_smp_task_hscb *smp_hscb;
+	unsigned long flags;
+	struct scb *scb;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	asd_lock(discover_contextp->asd, &flags);
+
+	/*
+	 * Get an scb to use.
+	 */
+	if ((scb = asd_hwi_get_scb(discover_contextp->asd, 1)) == NULL) {
+		// TODO - fix this
+
+		asd_unlock(discover_contextp->asd, &flags);
+
+		return DISCOVER_FAILED;
+	}
+
+	scb->flags |= SCB_INTERNAL;
+	scb->platform_data->dev = NULL;
+	scb->platform_data->targ = target;
+
+	list_add_tail(&scb->owner_links,
+		      &discover_contextp->asd->platform_data->pending_os_scbs);
+
+	smp_hscb = &scb->hscb->smp_task;
+
+	smp_hscb->header.opcode = SCB_INITIATE_SMP_TASK;
+	smp_hscb->protocol_conn_rate = target->ddb_profile.conn_rate;
+
+	smp_hscb->smp_req_busaddr = discover_contextp->SMPRequestBusAddr;
+	smp_hscb->smp_req_size = request_length;
+
+	smp_hscb->smp_req_ds = 0;
+	smp_hscb->sister_scb = 0xffff;
+	smp_hscb->conn_handle = target->ddb_profile.conn_handle;
+
+	smp_hscb->smp_resp_busaddr = discover_contextp->SMPResponseBusAddr;
+	smp_hscb->smp_resp_size = response_length;
+
+	smp_hscb->smp_resp_ds = 0;
+
+	asd_push_post_stack(discover_contextp->asd, scb, (void *)sm_contextp,
+			    asd_smp_request_done);
+
+	scb->flags |= SCB_ACTIVE;
+
+	asd_hwi_post_scb(discover_contextp->asd, scb);
+
+	asd_unlock(discover_contextp->asd, &flags);
+
+	return DISCOVER_OK;
+}
+
+void
+asd_smp_request_done(struct asd_softc *asd,
+		     struct scb *scb, struct asd_done_list *done_listp)
+{
+	struct state_machine_context *sm_contextp;
+	struct discover_context *discover_contextp;
+
+	sm_contextp = (struct state_machine_context *)scb->io_ctx;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	asd_scb_internal_done(asd, scb, done_listp);
+
+#if 0
+	if (done_listp->opcode != TASK_COMP_WO_ERR) {
+		printk("%s:%d: opcode = 0x%x\n", __FUNCTION__, __LINE__,
+		       done_listp->opcode);
+	}
+#endif
+
+	discover_contextp->resid_len = 0;
+
+	/*
+	 * TODO: need better return value here
+	 */
+	switch (done_listp->opcode) {
+	case TASK_COMP_WO_ERR:
+		discover_contextp->openStatus = OPEN_ACCEPT;
+		break;
+#ifdef SMP_UNDERRUN_WORKAROUND
+	case TASK_COMP_W_UNDERRUN:
+		printk("Ignoring UNDERRUN condition on SMP request\n");
+		discover_contextp->openStatus = OPEN_ACCEPT;
+		discover_contextp->resid_len =
+		    asd_le32toh(done_listp->stat_blk.data.res_len);
+		break;
+#endif
+#ifdef SMP_OVERRUN_WORKAROUND
+	case TASK_COMP_W_OVERRUN:
+		/*
+		 * This wasn't fixed in B0, so it will be investigated more.
+		 */
+		//printk("Ignoring OVERRUN condition on SMP request - ");
+		//printk("should be fixed in B0\n");
+		discover_contextp->openStatus = OPEN_ACCEPT;
+		break;
+#endif
+	case TASK_F_W_SMPRSP_TO:
+	case TASK_F_W_SMP_XMTRCV_ERR:
+		discover_contextp->openStatus = OPEN_REJECT_BAD_DESTINATION;
+		break;
+	case TASK_ABORTED_BY_ITNL_EXP:
+		switch (done_listp->stat_blk.itnl_exp.reason) {
+		case TASK_F_W_PHY_DOWN:
+		case TASK_F_W_BREAK_RCVD:
+		case TASK_F_W_OPEN_TO:
+			discover_contextp->openStatus =
+			    OPEN_REJECT_BAD_DESTINATION;
+			break;
+
+		case TASK_F_W_OPEN_REJECT:
+			discover_contextp->openStatus =
+			    OPEN_REJECT_BAD_DESTINATION;
+#if 0
+			discover_contextp->openStatus =
+			    OPEN_REJECT_RATE_NOT_SUPPORTED;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_NO_DESTINATION;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_PATHWAY_BLOCKED;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_PROTOCOL_NOT_SUPPORTED;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_RESERVE_ABANDON;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_RESERVE_CONTINUE;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_RESERVE_INITIALIZE;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_RESERVE_STOP;
+			discover_contextp->openStatus = OPEN_REJECT_RETRY;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_STP_RESOURCES_BUSY;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_WRONG_DESTINATION;
+#endif
+			break;
+		}
+		break;
+	case TASK_CLEARED:
+		/* Aborted command. Status needs to be changed .... */
+		break;
+	default:
+		discover_contextp->openStatus = OPEN_REJECT_BAD_DESTINATION;
+		break;
+	}
+
+	sm_contextp->wakeup_state_machine(sm_contextp);
+}
+
+DISCOVER_RESULTS
+asd_sata_identify_request(struct state_machine_context *sm_contextp,
+			  struct asd_target *target)
+{
+	unsigned long flags;
+	struct scb *scb;
+	struct discover_context *discover_contextp;
+	struct asd_target *old_target;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	asd_lock(discover_contextp->asd, &flags);
+
+	/*
+	 * Get an scb to use.
+	 */
+	if ((scb = asd_hwi_get_scb(discover_contextp->asd, 1)) == NULL) {
+		// TODO - fix this
+
+		asd_unlock(discover_contextp->asd, &flags);
+
+		return DISCOVER_FAILED;
+	}
+
+	scb->flags |= SCB_INTERNAL;
+	scb->platform_data->dev = NULL;
+
+	asd_push_post_stack(discover_contextp->asd, scb, (void *)sm_contextp,
+			    asd_sata_identify_request_done);
+
+	list_add_tail(&scb->owner_links,
+		      &discover_contextp->asd->platform_data->pending_os_scbs);
+
+	if (asd_sata_identify_build(discover_contextp->asd, target, scb) != 0) {
+
+		asd_hwi_free_scb(discover_contextp->asd, scb);
+
+		asd_unlock(discover_contextp->asd, &flags);
+
+		return DISCOVER_FAILED;
+	}
+
+	scb->flags |= SCB_ACTIVE;
+
+	/*
+	 * We want to use the flow control of the device queue if possible.
+	 * Look through the old/new discover list for this target.
+	 * If target exists, see if device exists.
+	 */
+	old_target = asd_find_target(discover_contextp->asd->old_discover_listp,
+				     target->ddb_profile.sas_addr);
+
+	if (old_target == NULL) {
+		old_target =
+		    asd_find_target(discover_contextp->asd->discover_listp,
+				    target->ddb_profile.sas_addr);
+	}
+
+	/*
+	 * sata devices should have only one lun, check lun 0.
+	 */
+	if (old_target != NULL) {
+
+		if (old_target->devices[0] != NULL) {
+
+			scb->platform_data->dev = target->devices[0];
+
+			asd_unlock(discover_contextp->asd, &flags);
+
+			if ((asd_discovery_queue_cmd(discover_contextp->asd,
+						     scb, old_target,
+						     old_target->devices[0]))) {
+
+				asd_hwi_free_scb(discover_contextp->asd, scb);
+
+				return DISCOVER_FAILED;
+			}
+
+			return DISCOVER_OK;
+		}
+	}
+
+	asd_hwi_post_scb(discover_contextp->asd, scb);
+
+	asd_unlock(discover_contextp->asd, &flags);
+
+	return DISCOVER_OK;
+}
+
+static int
+asd_discovery_queue_cmd(struct asd_softc *asd,
+			struct scb *scb, struct asd_target *targ,
+			struct asd_device *dev)
+{
+	struct scsi_cmnd *cmd;
+	u_long flags;
+
+	if ((cmd = asd_alloc_mem(sizeof(struct scsi_cmnd), GFP_ATOMIC)) == NULL) {
+		return -ENOMEM;
+	}
+
+	/* indicate its discovery SM  generated scsi_cmnd */
+	cmd->sc_magic = ASD_CSMI_COMMAND;
+
+	/* stick SCB into scsi_cmnd */
+	cmd->host_scribble = (unsigned char *)scb;
+
+	asd_lock(asd, &flags);
+	list_add_tail(&((union asd_cmd *)cmd)->acmd_links, &dev->busyq);
+	if ((dev->flags & ASD_DEV_ON_RUN_LIST) == 0) {
+		list_add_tail(&dev->links, &asd->platform_data->device_runq);
+		dev->flags |= ASD_DEV_ON_RUN_LIST;
+
+		asd_run_device_queues(asd);
+	}
+	asd_unlock(asd, &flags);
+
+	return 0;
+}
+
+void
+asd_sata_identify_request_done(struct asd_softc *asd,
+			       struct scb *scb,
+			       struct asd_done_list *done_listp)
+{
+	struct state_machine_context *sm_contextp;
+	struct discover_context *discover_contextp;
+
+	sm_contextp = (struct state_machine_context *)scb->io_ctx;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * If this is not NULL, scb was sent via device queue.
+	 */
+	if (scb->platform_data->dev) {
+		scb->platform_data->dev->active--;
+		scb->platform_data->dev->openings++;
+		scb->platform_data->dev->commands_issued--;
+	}
+
+	asd_scb_internal_done(asd, scb, done_listp);
+
+	discover_contextp->resid_len = 0;
+
+	/*
+	 * TODO: need better return value here
+	 */
+	switch (done_listp->opcode) {
+	case TASK_COMP_WO_ERR:
+		discover_contextp->openStatus = OPEN_ACCEPT;
+		break;
+
+	case TASK_COMP_W_UNDERRUN:
+		discover_contextp->openStatus = OPEN_ACCEPT;
+		discover_contextp->resid_len =
+		    asd_le32toh(done_listp->stat_blk.data.res_len);
+		break;
+
+	case TASK_ABORTED_BY_ITNL_EXP:
+		switch (done_listp->stat_blk.itnl_exp.reason) {
+		case TASK_F_W_PHY_DOWN:
+		case TASK_F_W_BREAK_RCVD:
+		case TASK_F_W_OPEN_TO:
+			discover_contextp->openStatus =
+			    OPEN_REJECT_BAD_DESTINATION;
+			break;
+
+		case TASK_F_W_OPEN_REJECT:
+			discover_contextp->openStatus =
+			    OPEN_REJECT_BAD_DESTINATION;
+#if 0
+			discover_contextp->openStatus =
+			    OPEN_REJECT_RATE_NOT_SUPPORTED;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_NO_DESTINATION;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_PATHWAY_BLOCKED;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_PROTOCOL_NOT_SUPPORTED;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_RESERVE_ABANDON;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_RESERVE_CONTINUE;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_RESERVE_INITIALIZE;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_RESERVE_STOP;
+			discover_contextp->openStatus = OPEN_REJECT_RETRY;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_STP_RESOURCES_BUSY;
+			discover_contextp->openStatus =
+			    OPEN_REJECT_WRONG_DESTINATION;
+#endif
+			break;
+		}
+		break;
+	case TASK_CLEARED:
+		/* Aborted command. Status needs to be changed .... */
+		break;
+	default:
+		discover_contextp->openStatus = OPEN_REJECT_BAD_DESTINATION;
+		break;
+	}
+
+	sm_contextp->wakeup_state_machine(sm_contextp);
+}
+
+DISCOVER_RESULTS
+asd_sata_configure_features(struct state_machine_context *sm_contextp,
+			    struct asd_target *target,
+			    uint8_t feature, uint8_t sector_count)
+{
+	unsigned long flags;
+	struct scb *scb;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	asd_lock(discover_contextp->asd, &flags);
+
+	/*
+	 * Get an scb to use.
+	 */
+	if ((scb = asd_hwi_get_scb(discover_contextp->asd, 1)) == NULL) {
+		// TODO - fix this
+
+		asd_unlock(discover_contextp->asd, &flags);
+
+		return DISCOVER_FAILED;
+	}
+
+	scb->flags |= SCB_INTERNAL;
+	scb->platform_data->dev = NULL;
+	scb->platform_data->targ = target;
+
+	list_add_tail(&scb->owner_links,
+		      &discover_contextp->asd->platform_data->pending_os_scbs);
+
+	if (asd_sata_set_features_build(discover_contextp->asd, target, scb,
+					feature, sector_count) != 0) {
+
+		asd_hwi_free_scb(discover_contextp->asd, scb);
+
+		asd_unlock(discover_contextp->asd, &flags);
+
+		return DISCOVER_FAILED;
+	}
+
+	asd_push_post_stack(discover_contextp->asd, scb, (void *)sm_contextp,
+			    asd_sata_configure_features_done);
+
+	scb->flags |= SCB_ACTIVE;
+
+	asd_hwi_post_scb(discover_contextp->asd, scb);
+
+	asd_unlock(discover_contextp->asd, &flags);
+
+	return DISCOVER_OK;
+}
+
+void
+asd_sata_configure_features_done(struct asd_softc *asd,
+				 struct scb *scb,
+				 struct asd_done_list *done_listp)
+{
+	struct state_machine_context *sm_contextp;
+	struct discover_context *discover_contextp;
+
+	sm_contextp = (struct state_machine_context *)scb->io_ctx;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	asd_scb_internal_done(asd, scb, done_listp);
+
+	discover_contextp->resid_len = 0;
+
+	/*
+	 * TODO: need better return value here
+	 */
+	switch (done_listp->opcode) {
+	case TASK_COMP_WO_ERR:
+		discover_contextp->openStatus = OPEN_ACCEPT;
+		break;
+
+	case TASK_COMP_W_UNDERRUN:
+		discover_contextp->openStatus = OPEN_ACCEPT;
+		discover_contextp->resid_len =
+		    asd_le32toh(done_listp->stat_blk.data.res_len);
+		break;
+
+	case TASK_ABORTED_BY_ITNL_EXP:
+		switch (done_listp->stat_blk.itnl_exp.reason) {
+		case TASK_F_W_PHY_DOWN:
+		case TASK_F_W_BREAK_RCVD:
+		case TASK_F_W_OPEN_TO:
+			discover_contextp->openStatus =
+			    OPEN_REJECT_BAD_DESTINATION;
+			break;
+
+		case TASK_F_W_OPEN_REJECT:
+			discover_contextp->openStatus =
+			    OPEN_REJECT_BAD_DESTINATION;
+			break;
+		}
+		break;
+	default:
+		discover_contextp->openStatus = OPEN_REJECT_BAD_DESTINATION;
+		break;
+	}
+
+	sm_contextp->wakeup_state_machine(sm_contextp);
+}
+
+struct asd_target *asd_discover_get_target(struct state_machine_context
+					   *sm_contextp,
+					   uint8_t * dest_sas_address,
+					   struct list_head *old_discover_listp,
+					   struct list_head *found_listp,
+					   unsigned conn_rate,
+					   TRANSPORT_TYPE transport_type)
+{
+	struct asd_target *target;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	target = asd_find_target(old_discover_listp, dest_sas_address);
+
+	if (target != NULL) {
+		/*
+		 * This target was previously found.
+		 */
+		target->flags |= ASD_TARG_RESEEN;
+
+		target->ddb_profile.conn_rate = conn_rate;
+
+		asd_hwi_build_ddb_site(discover_contextp->asd, target);
+
+		/*
+		 * First, take this target off of the general chain of all
+		 * targets in the domain.
+		 */
+		list_del_init(&target->all_domain_targets);
+
+		return target;
+	}
+
+	/*
+	 * See if we haven't already talked to this device during the current
+	 * discovery process.
+	 */
+	target = asd_find_target(found_listp, dest_sas_address);
+
+	if (target != NULL) {
+		/*
+		 * First, take this target off of the general chain of all
+		 * targets in the domain.
+		 */
+		list_del_init(&target->all_domain_targets);
+
+		return target;
+	}
+
+	target = asd_alloc_target(discover_contextp->asd,
+				  discover_contextp->port);
+
+	/*
+	 * make sure we only do this if the allocation is successful
+	 */
+	if (target == NULL) {
+		return NULL;
+	}
+
+	target->domain =
+	    discover_contextp->asd->platform_data->domains[discover_contextp->
+							   port->id];
+
+	target->ddb_profile.conn_rate = conn_rate;
+
+	target->ddb_profile.itnl_const = ITNL_TIMEOUT_CONST;
+
+	target->parent = NULL;
+
+	/*
+	 * Set to 1 for SSP, STP, and SMP device ports. 0 for all SATA direct
+	 * attached ports.  Every device that is initialized by this routine
+	 * is not a SATA direct attach.
+	 */
+	target->ddb_profile.open_affl = OPEN_AFFILIATION;
+
+	memcpy(target->ddb_profile.sas_addr, dest_sas_address, SAS_ADDR_LEN);
+
+	if (transport_type == ASD_TRANSPORT_STP) {
+		//TODO: get SUPPORTS_AFFILIATION out of SMP request
+		target->ddb_profile.open_affl |=
+		    (STP_AFFILIATION | SUPPORTS_AFFILIATION);
+	}
+
+	asd_hwi_hash(target->ddb_profile.sas_addr,
+		     target->ddb_profile.hashed_sas_addr);
+
+	// TODO: - we need to allocate this from LRU DDB list
+	// (doesn't exist yet)
+	asd_hwi_setup_ddb_site(discover_contextp->asd, target);
+
+	return target;
+}
+
+DISCOVER_RESULTS
+asd_find_subtractive_phy(struct state_machine_context * sm_contextp,
+			 struct asd_target * expander,
+			 uint8_t * subtractiveSASAddress,
+			 uint8_t * attachedPhyIdentifier,
+			 unsigned *conn_rate, uint8_t * phyIdentifier)
+{
+	struct Discover *discover;
+	DISCOVER_RESULTS result;
+	uint8_t phyCount;
+	unsigned foundSubtractive;
+
+	SAS_ZERO(subtractiveSASAddress);
+	*attachedPhyIdentifier = 0;
+
+	foundSubtractive = 0;
+
+	/*
+	 * walk through all the phys of this expander
+	 */
+	for (phyCount = 0; phyCount < expander->num_phys; phyCount++) {
+
+		/*
+		 * this is just a pointer helper
+		 */
+		discover = &(expander->Phy[phyCount].Result);
+
+		/*
+		 * look for phys with edge or fanout devices attached...
+		 */
+		if ((discover->RoutingAttribute != SUBTRACTIVE) ||
+		    ((discover->AttachedDeviceType !=
+		      EDGE_EXPANDER_DEVICE) &&
+		     (discover->AttachedDeviceType !=
+		      FANOUT_EXPANDER_DEVICE))) {
+
+			continue;
+		}
+
+		/*
+		 * make sure all the subtractive phys point to
+		 * the same address when we are connected to an
+		 * expander device
+		 */
+		if (SAS_ISZERO(subtractiveSASAddress)) {
+
+			SASCPY(subtractiveSASAddress,
+			       discover->AttachedSASAddress);
+
+			*attachedPhyIdentifier =
+			    discover->AttachedPhyIdentifier;
+
+			result = DISCOVER_OK;
+
+			*conn_rate = discover->NegotiatedPhysicalLinkRate;
+
+			*phyIdentifier = phyCount;
+
+			foundSubtractive = 1;
+		} else if (!SAS_ISEQUAL(subtractiveSASAddress,
+					discover->AttachedSASAddress)) {
+
+			/*
+			 * the addresses don't match... 
+			 * problem...
+			 */
+			asd_log(ASD_DBG_ERROR, "\n"
+				"topology error, diverging "
+				"subtractive phys"
+				", '%0llx' != '%0llx' \n",
+				*((uint64_t *) subtractiveSASAddress),
+				*((uint64_t *) discover->AttachedSASAddress));
+
+			return DISCOVER_FAILED;
+		}
+	}
+
+	if (foundSubtractive == 0) {
+		return DISCOVER_FINISHED;
+	}
+
+	return DISCOVER_OK;
+}
+
+/*
+ * find the table structure associated with a specific SAS address
+ */
+struct asd_target *asd_find_target(struct list_head *target_list,
+				   uint8_t * SASAddress)
+{
+	struct asd_target *target;
+
+	/*
+	 * walk the list of expanders, when we find the one that matches, stop
+	 */
+	list_for_each_entry(target, target_list, all_domain_targets) {
+		/*
+		 * do the SASAdresses match
+		 */
+		if (SAS_ISEQUAL(target->ddb_profile.sas_addr, SASAddress)) {
+			return target;
+		}
+	}
+
+	return NULL;
+}
+
+/*
+ * find the table structure associated with a specific target identity.
+ */
+struct asd_target *asd_find_target_ident(struct list_head *target_list,
+					 struct asd_target *check_target)
+{
+	struct asd_target *target;
+
+	/*
+	 * walk the list of expanders, when we find the one that matches, stop
+	 */
+	list_for_each_entry(target, target_list, all_domain_targets) {
+
+		/*
+		 * Make sure we don't match ourselves.
+		 */
+		if (check_target == target) {
+			continue;
+		}
+
+		/*
+		 * It can't possibly be a match if the transport types don't
+		 * match.
+		 */
+		if (check_target->transport_type != target->transport_type) {
+			continue;
+		}
+
+		switch (target->transport_type) {
+		case ASD_TRANSPORT_SSP:
+			if (target->scsi_cmdset.ident_len !=
+			    check_target->scsi_cmdset.ident_len) {
+
+				continue;
+			}
+
+			if (memcmp(target->scsi_cmdset.ident,
+				   check_target->scsi_cmdset.ident,
+				   target->scsi_cmdset.ident_len) == 0) {
+
+				return target;
+			}
+			break;
+
+		case ASD_TRANSPORT_STP:
+			if (SAS_ISEQUAL(target->ddb_profile.sas_addr,
+					check_target->ddb_profile.sas_addr)) {
+
+				return target;
+			}
+			break;
+
+		default:
+			continue;
+		}
+
+	}
+
+	return NULL;
+}
+
+struct asd_target *asd_find_multipath(struct asd_softc *asd,
+				      struct asd_target *target)
+{
+	struct asd_port *port;
+	unsigned port_id;
+	struct asd_target *multipath_target;
+
+	/*
+	 * Check to make sure that this same device hasn't been exposed to the
+	 * OS on a different port.
+	 */
+	for (port_id = 0; port_id < asd->hw_profile.max_ports; port_id++) {
+
+		port = asd->port_list[port_id];
+
+		multipath_target = asd_find_target_ident(&port->targets,
+							 target);
+
+		if (multipath_target != NULL) {
+			return multipath_target;
+		}
+	}
+
+	return NULL;
+}
+
+/*
+ *
+ * this routine searches the subtractive phys for the upstream expander address
+ *
+ */
+static int
+asd_upstream_expander(struct asd_target *expander,
+		      uint8_t * SASAddress, uint8_t * PhyIdentifier)
+{
+	struct Discover *discover;
+	uint8_t phyCount;
+	int found;
+
+	found = 0;
+
+	/*
+	 * walk through all the phys of this expander, searching for
+	 * subtractive phys return the SASAddress and PhyIdentifier for the
+	 * first subtractive phy encountered, they should all be the same if
+	 * they have anything attached
+	 */
+	for (phyCount = 0; phyCount < expander->num_phys; phyCount++) {
+		/*
+		 * this is just a pointer helper
+		 */
+		discover = &(expander->Phy[phyCount].Result);
+
+		/*
+		 * look for phys with edge or fanout devices attached...
+		 */
+		if ((discover->RoutingAttribute == SUBTRACTIVE) &&
+		    ((discover->AttachedDeviceType == EDGE_EXPANDER_DEVICE) ||
+		     (discover->AttachedDeviceType ==
+		      FANOUT_EXPANDER_DEVICE))) {
+
+			SASCPY(SASAddress, discover->AttachedSASAddress);
+
+			*PhyIdentifier = discover->AttachedPhyIdentifier;
+
+			found = 1;
+
+			break;
+		}
+	}
+
+	return found;
+}
+
+/*
+ * this routine determines whether a SAS address is directly attached to
+ * an expander
+ */
+static int
+asd_direct_attached(struct asd_target *expander, uint8_t * SASAddress)
+{
+	int direct;
+	uint8_t phyCount;
+
+	direct = 0;
+
+	for (phyCount = 0; phyCount < expander->num_phys; phyCount++) {
+
+		/*
+		 * did we find the address attached locally
+		 */
+		if (*((uint64_t *) SASAddress) ==
+		    *((uint64_t *) expander->Phy[phyCount].
+		      Result.AttachedSASAddress)) {
+
+			direct = 1;
+			break;
+		}
+	}
+
+	return direct;
+}
+
+/*
+ * this routine determines whether the SAS address, can be optimized out
+ * of the route table.
+ *
+ * expander:	the expander whose route table we are configuring.
+ *
+ * discover:	the response to the discovery request for the device attached
+ *		to the phy of the expander that we are trying to configure
+ *		into "expander's" route table.
+ */
+static int
+asd_qualified_address(struct asd_target *expander,
+		      uint8_t PhyIdentifier,
+		      struct Discover *discover, uint8_t * DisableRouteEntry)
+{
+	int qualified;
+	uint16_t routeIndex;
+	uint8_t *sas_address;
+
+	qualified = 1;
+
+	if (DiscoverAlgorithm != SAS_UNIQUE_LEVEL_DESCENT) {
+		return qualified;
+	}
+
+	/*
+	 * leave in any entries that are direct routing attribute,
+	 * assumes that they are slots that will be filled by end
+	 * devices, if it is not direct, then filter out any empty
+	 * connections, connections that match the expander we are
+	 * configuring and connections that are truly direct attached
+	 */
+	if (!SAS_ISZERO(discover->AttachedSASAddress) &&
+	    !SAS_ISEQUAL(discover->AttachedSASAddress,
+			 expander->ddb_profile.sas_addr) &&
+	    (!asd_direct_attached(expander, discover->AttachedSASAddress))) {
+
+		if (discover->RoutingAttribute == DIRECT) {
+			/*
+			 * if this is a phy that is has a direct
+			 * routing attribute then, have it consume an
+			 * entry, it may be filled in at any time
+			 */
+		} else {
+			for (routeIndex = 0; routeIndex <
+			     expander->num_route_indexes; routeIndex++) {
+
+				sas_address = ROUTE_ENTRY(expander,
+							  PhyIdentifier,
+							  routeIndex);
+
+				if (SAS_ISEQUAL(sas_address,
+						discover->AttachedSASAddress)) {
+
+					qualified = 0;
+
+					break;
+				}
+			}
+		}
+	} else if (SAS_ISZERO(discover->AttachedSASAddress)) {
+		/*
+		 * if a 0 address, then assume it is an
+		 * empty slot that can be filled at any time, 
+		 * this keeps things positionally stable for most
+		 * reasonable topologies
+		 */
+		*DisableRouteEntry = DISABLED;
+	} else {
+		qualified = 0;
+	}
+
+	return qualified;
+}
+
+void
+asd_add_child(struct asd_port *port,
+	      struct asd_target *parent, struct asd_target *child)
+{
+	/*
+	 * Check to make sure that this particular target hasn't already been
+	 * put in the tree, or that it isn't the top of the tree.
+	 */
+	if ((port->tree_root == child) || (child->parent != NULL)) {
+		return;
+	}
+
+	child->parent = parent;
+
+	if (child->parent != NULL) {
+		list_add_tail(&child->siblings, &parent->children);
+	}
+}
+
+#define DUMP_LIST(a)		dump_list(__FUNCTION__, __LINE__, #a, a);
+void
+dump_list(char *function, unsigned line, char *s, struct list_head *target_list)
+{
+	struct asd_target *target;
+
+	printk("%s:%d: dumping list %s\n", function, line, s);
+	/*
+	 * walk the list of expanders, when we find the one that matches, stop
+	 */
+	list_for_each_entry(target, target_list, all_domain_targets) {
+		printk("%s:%d: %llx\n", __FUNCTION__, __LINE__,
+		       *((uint64_t *) target->ddb_profile.sas_addr));
+	}
+}
+
+DISCOVER_RESULTS
+asd_configure_device(struct state_machine_context *sm_contextp,
+		     struct asd_target *parentExpander,
+		     struct Discover *discover,
+		     struct list_head *discover_listp,
+		     struct list_head *found_listp,
+		     struct list_head *old_discover_listp, unsigned conn_rate)
+{
+	struct asd_target *target;
+	COMMAND_SET_TYPE command_set_type;
+	DEVICE_PROTOCOL_TYPE device_protocol_type;
+	MANAGEMENT_TYPE management_type;
+	TRANSPORT_TYPE transport_type;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * TODO: right now we are ignoring all virtual phy devices.
+	 */
+	if ((discover->InitiatorBits != 0) || (discover->VirtualPhy == 1)) {
+		return DISCOVER_OK;
+	}
+
+	switch (conn_rate) {
+	case RATE_UNKNOWN:
+	case PHY_DISABLED:
+	case PHY_FAILED:
+		return DISCOVER_FAILED;
+
+	case SPINUP_HOLD_OOB:
+		printk("found SPINUP_HOLD\n");
+		break;
+	case GBPS_1_5:
+	case GBPS_3_0:
+		/*
+		 * Nothing special to do.
+		 */
+		break;
+	}
+
+	/*
+	 * This routine is only called for end devices.
+	 */
+	ASSERT((discover->TargetBits & SMP_TGT_PORT) == 0);
+
+	if (discover->TargetBits & SSP_TGT_PORT) {
+
+		command_set_type = ASD_COMMAND_SET_SCSI;
+		device_protocol_type = ASD_DEVICE_PROTOCOL_SCSI;
+		transport_type = ASD_TRANSPORT_SSP;
+		management_type = ASD_DEVICE_END;
+
+	} else if (discover->TargetBits & STP_TGT_PORT) {
+		/* 
+		 * We don't know the command set yet (could be ATAPI or ATA)
+		 * We won't know until IDENTIFY / PIDENTIFY.
+		 */
+		command_set_type = ASD_COMMAND_SET_UNKNOWN;
+		device_protocol_type = ASD_DEVICE_PROTOCOL_ATA;
+		transport_type = ASD_TRANSPORT_STP;
+		management_type = ASD_DEVICE_END;
+
+	} else if (discover->TargetBits & SATA_TGT_PORT) {
+		/* 
+		 * We don't know the command set yet (could be ATAPI or ATA)
+		 * We won't know until IDENTIFY / PIDENTIFY.
+		 */
+		/* 
+		 * An "attached SATA host" which is "outside of the
+		 * scope of this standard" 
+		 * T10/1562-D Rev 5 - 10.4.3.5 pg. 340 - 7/9/2003
+		 */
+		command_set_type = ASD_COMMAND_SET_UNKNOWN;
+		device_protocol_type = ASD_DEVICE_PROTOCOL_ATA;
+		transport_type = ASD_TRANSPORT_STP;
+		management_type = ASD_DEVICE_END;
+	} else {
+		command_set_type = ASD_COMMAND_SET_UNKNOWN;
+		device_protocol_type = ASD_DEVICE_PROTOCOL_UNKNOWN;
+		transport_type = ASD_TRANSPORT_UNKNOWN;
+		management_type = ASD_DEVICE_UNKNOWN;
+	}
+
+	target = asd_discover_get_target(sm_contextp,
+					 discover->AttachedSASAddress,
+					 old_discover_listp,
+					 found_listp, conn_rate,
+					 transport_type);
+
+	if (target == NULL) {
+
+		printk("couldn't allocate target\n");
+
+		return DISCOVER_FAILED;
+	}
+
+	target->command_set_type = command_set_type;
+	target->device_protocol_type = device_protocol_type;
+	target->management_type = management_type;
+	target->transport_type = transport_type;
+
+	/*
+	 * Add the device to the tree.
+	 */
+	asd_add_child(discover_contextp->port, parentExpander, target);
+
+	list_add_tail(&target->all_domain_targets, discover_listp);
+
+	return DISCOVER_OK;
+}
+
+void
+asd_destroy_discover_list(struct asd_softc *asd,
+			  struct list_head *discover_list)
+{
+	struct asd_target *target;
+	struct asd_target *tmp_target;
+
+	list_for_each_entry_safe(target, tmp_target, discover_list,
+				 all_domain_targets) {
+
+		list_del_init(&target->all_domain_targets);
+
+		asd_free_ddb(asd, target->ddb_profile.conn_handle);
+
+		asd_free_target(asd, target);
+	}
+}
+
+/* -------------------------------------------------------------------------- */
+
+DISCOVER_RESULTS
+asd_issue_discover_request(struct state_machine_context *sm_contextp,
+			   struct asd_target *expander, unsigned phyIndex)
+{
+	DISCOVER_RESULTS results;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	memset(discover_contextp->SMPRequestFrame, 0,
+	       sizeof(struct SMPRequest));
+
+	discover_contextp->SMPRequestFrame->SMPFrameType = SMP_REQUEST_FRAME;
+	discover_contextp->SMPRequestFrame->Function = DISCOVER;
+	discover_contextp->SMPRequestFrame->Request.Discover.PhyIdentifier =
+	    phyIndex;
+
+	/*
+	 * get the discover information for each phy
+	 */
+	results = asd_smp_request(sm_contextp, expander,
+				  sizeof(struct SMPRequestPhyInput),
+				  sizeof(struct SMPResponseDiscover));
+
+	return results;
+}
+
+DISCOVER_RESULTS
+asd_issue_discover_request_post(struct state_machine_context * sm_contextp,
+				struct asd_target * expander, unsigned phyIndex)
+{
+	struct Discover *discover;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	if ((discover_contextp->openStatus != OPEN_ACCEPT) ||
+	    (discover_contextp->SMPResponseFrame->FunctionResult !=
+	     SMP_FUNCTION_ACCEPTED)) {
+
+		/*
+		 * if we had a problem on this  link, then don't 
+		 * bother to  do anything else, production code,
+		 * should be more robust...
+		 */
+		// asd_log(ASD_DBG_ERROR, "\n"
+		printk("discover error, %02Xh at %0llx\n",
+		       discover_contextp->SMPResponseFrame->FunctionResult,
+		       *((uint64_t *) expander->ddb_profile.sas_addr));
+
+		return DISCOVER_FAILED;
+	}
+
+	discover = &(expander->Phy[phyIndex].Result);
+
+	/*
+	 * copy the result into the topology table
+	 */
+	memcpy((void *)&(expander->Phy[phyIndex]),
+	       (void *)&discover_contextp->SMPResponseFrame->Response.Discover,
+	       sizeof(struct SMPResponseDiscover));
+
+#if 0
+	printk("----------\n");
+	printk("PhyIdentifier 0x%x SASAddress 0x%llx\n",
+	       phyIndex, *((uint64_t *) discover->SASAddress));
+	printk("AttachedSASAddress 0x%llx AttachedPhyIdentifier 0x%x\n",
+	       *((uint64_t *) discover->AttachedSASAddress),
+	       discover->AttachedPhyIdentifier);
+	printk("InitiatorBits 0x%x TargetBits 0x%x\n",
+	       discover->InitiatorBits, discover->TargetBits);
+#endif
+
+	return DISCOVER_OK;
+}
+
+/* -------------------------------------------------------------------------- */
+
+/*
+ * this function gets the report general and discover information for
+ * a specific expander.  The discover process should begin at the subtractive
+ * boundary and progress downstream.
+ *
+ * If the dest_sas_address is an expander, the expander structure is returned
+ * in retExpander.
+ */
+DISCOVER_RESULTS
+asd_issue_report_general(struct state_machine_context * sm_contextp,
+			 uint8_t * dest_sas_address,
+			 uint8_t conn_rate,
+			 uint8_t attachedDeviceType,
+			 struct list_head * old_discover_listp,
+			 struct list_head * found_listp,
+			 struct asd_target ** retExpander)
+{
+	struct asd_target *expander;
+	DISCOVER_RESULTS results;
+	COMMAND_SET_TYPE command_set_type;
+	DEVICE_PROTOCOL_TYPE device_protocol_type;
+	TRANSPORT_TYPE transport_type;
+	MANAGEMENT_TYPE management_type;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	expander = NULL;
+
+	memset(discover_contextp->SMPRequestFrame, 0,
+	       sizeof(struct SMPRequest));
+
+	discover_contextp->SMPRequestFrame->SMPFrameType = SMP_REQUEST_FRAME;
+	discover_contextp->SMPRequestFrame->Function = REPORT_GENERAL;
+
+	switch (attachedDeviceType) {
+	case EDGE_EXPANDER_DEVICE:
+		command_set_type = ASD_COMMAND_SET_SMP;
+		device_protocol_type = ASD_DEVICE_PROTOCOL_SMP;
+		transport_type = ASD_TRANSPORT_SMP;
+		management_type = ASD_DEVICE_EDGE_EXPANDER;
+		break;
+
+	case FANOUT_EXPANDER_DEVICE:
+		management_type = ASD_DEVICE_FANOUT_EXPANDER;
+		device_protocol_type = ASD_DEVICE_PROTOCOL_SMP;
+		command_set_type = ASD_COMMAND_SET_SMP;
+		transport_type = ASD_TRANSPORT_SMP;
+		break;
+
+	default:
+		/*
+		 * This should never happen.
+		 */
+		return DISCOVER_FAILED;
+	}
+
+	expander = asd_discover_get_target(sm_contextp, dest_sas_address,
+					   old_discover_listp, found_listp,
+					   conn_rate, transport_type);
+
+	/*
+	 * make sure we only do this if the allocation is successful
+	 */
+	if (expander == NULL) {
+		return DISCOVER_FAILED;
+	}
+
+	expander->command_set_type = command_set_type;
+	expander->device_protocol_type = device_protocol_type;
+	expander->transport_type = transport_type;
+	expander->management_type = management_type;
+
+	/*
+	 * get the report general information for the expander
+	 */
+	results = asd_smp_request(sm_contextp, expander,
+				  sizeof(struct SMPRequestGeneralInput),
+				  sizeof(struct SMPResponseReportGeneral));
+
+	*retExpander = expander;
+
+	return results;
+}
+
+DISCOVER_RESULTS
+asd_issue_report_general_post(struct state_machine_context * sm_contextp,
+			      struct asd_target * expander)
+{
+	uint8_t phyCount;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	phyCount = 0;
+
+	/*
+	 * the assumptions we made were exceeded, need to bump limits...
+	 */
+	if ((discover_contextp->openStatus != OPEN_ACCEPT) ||
+	    (discover_contextp->SMPResponseFrame->FunctionResult !=
+	     SMP_FUNCTION_ACCEPTED)) {
+		/*
+		 * if we had a problem getting report general for this expander,
+		 * something is wrong, can't go any further down this path...
+		 * production code, should be more robust...
+		 */
+		asd_log(ASD_DBG_ERROR, "\n"
+			"report general error, open %02Xh result %02Xh at "
+			"0x%0llx\n",
+			discover_contextp->openStatus,
+			discover_contextp->SMPResponseFrame->FunctionResult,
+			*((uint64_t *) expander->ddb_profile.sas_addr));
+
+		asd_free_ddb(discover_contextp->asd,
+			     expander->ddb_profile.conn_handle);
+
+		asd_free_target(discover_contextp->asd, expander);
+
+		return DISCOVER_FAILED;
+	}
+
+	if (discover_contextp->SMPResponseFrame->Response.
+	    ReportGeneral.NumberOfPhys > MAXIMUM_EXPANDER_PHYS) {
+
+		asd_log(ASD_DBG_ERROR, "\n"
+			"report general error"
+			", NumberOfPhys %d exceeded limit %d on %0llx\n",
+			discover_contextp->SMPResponseFrame->
+			Response.ReportGeneral.NumberOfPhys,
+			MAXIMUM_EXPANDER_PHYS,
+			*((uint64_t *) expander->ddb_profile.sas_addr));
+
+		asd_free_ddb(discover_contextp->asd,
+			     expander->ddb_profile.conn_handle);
+
+		asd_free_target(discover_contextp->asd, expander);
+
+		return DISCOVER_FAILED;
+	}
+
+	expander->num_phys = discover_contextp->SMPResponseFrame->
+	    Response.ReportGeneral.NumberOfPhys;
+
+	expander->num_route_indexes =
+	    asd_be16toh(discover_contextp->SMPResponseFrame->Response.
+			ReportGeneral.ExpanderRouteIndexes);
+
+	if (expander->Phy != NULL) {
+		asd_free_mem(expander->Phy);
+	}
+
+	expander->Phy =
+	    (struct SMPResponseDiscover *)
+	    asd_alloc_mem(sizeof(struct SMPResponseDiscover) *
+			  expander->num_phys, GFP_KERNEL);
+
+	if (expander->Phy == NULL) {
+
+		printk("unable to allocate memory\n");
+
+		asd_free_ddb(discover_contextp->asd,
+			     expander->ddb_profile.conn_handle);
+
+		asd_free_target(discover_contextp->asd, expander);
+
+		return DISCOVER_FAILED;
+	}
+
+	if (expander->num_route_indexes != 0) {
+
+		if (expander->RouteTable != NULL) {
+			asd_free_mem(expander->RouteTable);
+		}
+
+		expander->RouteTable =
+		    (uint8_t *) asd_alloc_mem(SAS_ADDR_LEN *
+					      expander->num_phys *
+					      expander->num_route_indexes,
+					      GFP_KERNEL);
+
+		if (expander->route_indexes != NULL) {
+			asd_free_mem(expander->route_indexes);
+		}
+
+		expander->route_indexes =
+		    asd_alloc_mem(expander->num_route_indexes
+				  * sizeof(uint16_t), GFP_KERNEL);
+
+		memset(expander->route_indexes, 0,
+		       expander->num_route_indexes * sizeof(uint16_t));
+	}
+
+	return DISCOVER_OK;
+}
+
+/* -------------------------------------------------------------------------- */
+
+DISCOVER_RESULTS
+asd_issue_report_manufacturer_info(struct state_machine_context * sm_contextp,
+				   struct asd_target * expander)
+{
+	DISCOVER_RESULTS results;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	memset(discover_contextp->SMPRequestFrame, 0,
+	       sizeof(struct SMPRequest));
+
+	discover_contextp->SMPRequestFrame->SMPFrameType = SMP_REQUEST_FRAME;
+	discover_contextp->SMPRequestFrame->Function =
+	    REPORT_MANUFACTURER_INFORMATION;
+
+	results = asd_smp_request(sm_contextp, expander,
+				  sizeof(struct SMPRequestGeneralInput),
+				  sizeof(struct
+					 SMPResponseReportManufacturerInfo));
+
+	return results;
+}
+
+DISCOVER_RESULTS
+asd_issue_report_manufacturer_info_post(struct state_machine_context *
+					sm_contextp,
+					struct asd_target * expander)
+{
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * the assumptions we made were exceeded, need to bump limits...
+	 */
+	if ((discover_contextp->openStatus != OPEN_ACCEPT) ||
+	    (discover_contextp->SMPResponseFrame->FunctionResult !=
+	     SMP_FUNCTION_ACCEPTED)) {
+		/*
+		 * if we had a problem getting report general for this expander,
+		 * something is wrong, can't go any further down this path...
+		 * production code, should be more robust...
+		 */
+		asd_log(ASD_DBG_ERROR, "\n"
+			"get manufacturer information error, "
+			"open %02Xh result %02Xh at "
+			"0x%0llx\n",
+			discover_contextp->openStatus,
+			discover_contextp->SMPResponseFrame->FunctionResult,
+			*((uint64_t *) expander->ddb_profile.sas_addr));
+
+		asd_free_ddb(discover_contextp->asd,
+			     expander->ddb_profile.conn_handle);
+
+		asd_free_target(discover_contextp->asd, expander);
+
+		return DISCOVER_FAILED;
+	}
+
+	memcpy(&expander->smp_cmdset.manufacturer_info,
+	       &discover_contextp->SMPResponseFrame->
+	       Response.ReportManufacturerInfo,
+	       sizeof(struct SMPResponseReportManufacturerInfo));
+
+#if 0
+	printk("%8.8s|%16.16s|%4.4s\n",
+	       expander->smp_cmdset.manufacturer_info.VendorIdentification,
+	       expander->smp_cmdset.manufacturer_info.ProductIdentification,
+	       expander->smp_cmdset.manufacturer_info.ProductRevisionLevel);
+#endif
+
+	return DISCOVER_OK;
+}
+
+/* -------------------------------------------------------------------------- */
+
+DISCOVER_RESULTS
+asd_issue_route_config(struct state_machine_context * sm_contextp,
+		       struct asd_target * expander,
+		       unsigned phyIndex,
+		       uint8_t disableRouteEntry, uint8_t * attachedSASAddress)
+{
+	uint16_t index;
+	DISCOVER_RESULTS results;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	index = expander->route_indexes[phyIndex];
+
+	memset(discover_contextp->SMPRequestFrame, 0,
+	       sizeof(struct SMPRequest));
+
+	discover_contextp->SMPRequestFrame->SMPFrameType = SMP_REQUEST_FRAME;
+	discover_contextp->SMPRequestFrame->Function =
+	    CONFIGURE_ROUTE_INFORMATION;
+
+	discover_contextp->SMPRequestFrame->Request.
+	    ConfigureRouteInformation.ExpanderRouteIndex = asd_htobe16(index);
+
+	discover_contextp->SMPRequestFrame->Request.
+	    ConfigureRouteInformation.PhyIdentifier = phyIndex;
+
+	discover_contextp->SMPRequestFrame->Request.
+	    ConfigureRouteInformation.Configure.DisableRouteEntry =
+	    disableRouteEntry;
+
+	SASCPY(discover_contextp->SMPRequestFrame->Request.
+	       ConfigureRouteInformation.Configure.RoutedSASAddress,
+	       attachedSASAddress);
+
+	/*
+	 * configure the route indexes for the
+	 * expander with the attached address
+	 * information
+	 */
+	results = asd_smp_request(sm_contextp, expander,
+				  sizeof(struct
+					 SMPRequestConfigureRouteInformation),
+				  sizeof(struct
+					 SMPResponseConfigureRouteInformation));
+
+	return results;
+}
+
+DISCOVER_RESULTS
+asd_issue_route_config_post(struct state_machine_context * sm_contextp,
+			    struct asd_target * expander, unsigned phyIndex)
+{
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * the assumptions we made were exceeded, need to bump limits...
+	 */
+	if ((discover_contextp->openStatus != OPEN_ACCEPT) ||
+	    (discover_contextp->SMPResponseFrame->FunctionResult !=
+	     SMP_FUNCTION_ACCEPTED)) {
+		/*
+		 * if we had a problem getting report general for this expander,
+		 * something is wrong, can't go any further down this path...
+		 * production code, should be more robust...
+		 */
+		asd_log(ASD_DBG_ERROR, "\n"
+			"route config error, open %02Xh result %02Xh at "
+			"0x%0llx\n",
+			discover_contextp->openStatus,
+			discover_contextp->SMPResponseFrame->FunctionResult,
+			*((uint64_t *) expander->ddb_profile.sas_addr));
+
+		return DISCOVER_FAILED;
+	}
+
+	return DISCOVER_OK;
+}
+
+/* -------------------------------------------------------------------------- */
+
+DISCOVER_RESULTS
+asd_issue_report_phy_sata(struct state_machine_context * sm_contextp,
+			  struct asd_target * expander, unsigned phyIndex)
+{
+	DISCOVER_RESULTS results;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	memset(discover_contextp->SMPRequestFrame, 0,
+	       sizeof(struct SMPRequest));
+
+	discover_contextp->SMPRequestFrame->SMPFrameType = SMP_REQUEST_FRAME;
+	discover_contextp->SMPRequestFrame->Function = REPORT_PHY_SATA;
+
+	discover_contextp->SMPRequestFrame->Request.
+	    ReportPhySATA.PhyIdentifier = phyIndex;
+
+	results = asd_smp_request(sm_contextp, expander,
+				  sizeof(struct SMPRequestPhyInput),
+				  sizeof(struct SMPResponseReportPhySATA));
+
+	return results;
+}
+
+DISCOVER_RESULTS
+asd_issue_report_phy_sata_post(struct state_machine_context * sm_contextp,
+			       struct asd_target * expander)
+{
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * the assumptions we made were exceeded, need to bump limits...
+	 */
+	if ((discover_contextp->openStatus != OPEN_ACCEPT) ||
+	    (discover_contextp->SMPResponseFrame->FunctionResult !=
+	     SMP_FUNCTION_ACCEPTED)) {
+		/*
+		 * if we had a problem getting report general for this expander,
+		 * something is wrong, can't go any further down this path...
+		 * production code, should be more robust...
+		 */
+		asd_log(ASD_DBG_ERROR, "\n"
+			"report phy SATA error, open %02Xh result %02Xh at "
+			"0x%0llx\n",
+			discover_contextp->openStatus,
+			discover_contextp->SMPResponseFrame->FunctionResult,
+			*((uint64_t *) expander->ddb_profile.sas_addr));
+
+		return DISCOVER_FAILED;
+	}
+
+	return DISCOVER_OK;
+}
+
+COMMAND_SET_TYPE asd_sata_get_type(struct adp_dev_to_host_fis * fis)
+{
+	if ((fis->sector_count == 1) && (fis->lba0 == 1) &&
+	    (fis->lba1 == 0x14) && (fis->lba2 == 0xeb)) {
+
+		return ASD_COMMAND_SET_ATAPI;
+	}
+
+	return ASD_COMMAND_SET_ATA;
+}
+
+void
+asd_init_sata_direct_attached(struct state_machine_context *sm_contextp,
+			      struct asd_target *target)
+{
+	struct asd_phy *phy;
+	struct adp_dev_to_host_fis *fis;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	phy = list_entry(target->src_port->phys_attached.next,
+			 struct asd_phy, links);
+
+	fis = (struct adp_dev_to_host_fis *)
+	    &phy->bytes_dmaed_rcvd.initial_fis_rcvd.fis[0];
+
+	target->command_set_type = asd_sata_get_type(fis);
+
+	memcpy((void *)&target->device_protocol.
+	       ata_device_protocol.initial_fis[0],
+	       (void *)fis, sizeof(struct adp_dev_to_host_fis));
+
+	target->ddb_profile.sata_status = fis->status;
+
+	asd_hwi_update_sata(discover_contextp->asd, target);
+}
+
+/* -------------------------------------------------------------------------- */
+
+DISCOVER_RESULTS
+asd_issue_phy_control(struct state_machine_context *sm_contextp,
+		      struct asd_target *expander,
+		      unsigned phyIndex, unsigned operation)
+{
+	DISCOVER_RESULTS results;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	memset(discover_contextp->SMPRequestFrame, 0,
+	       sizeof(struct SMPRequest));
+
+	discover_contextp->SMPRequestFrame->SMPFrameType = SMP_REQUEST_FRAME;
+
+	discover_contextp->SMPRequestFrame->Function = PHY_CONTROL;
+
+	discover_contextp->SMPRequestFrame->Request.PhyControl.
+	    PhyIdentifier = phyIndex;
+
+	discover_contextp->SMPRequestFrame->Request.PhyControl.
+	    PhyOperation = operation;
+
+	/*
+	 * get the discover information for each phy
+	 */
+	results = asd_smp_request(sm_contextp, expander,
+				  sizeof(struct SMPRequestPhyControl),
+				  sizeof(struct SMPResponsePhyControl));
+
+	return results;
+}




