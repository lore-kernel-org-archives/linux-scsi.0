From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [05/27]
Date: Thu, 17 Feb 2005 12:35:49 -0500
Message-ID: <4214D5F5.7000203@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:6289 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262191AbVBQRfy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:35:54 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHZrr30489
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:35:53 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHZqb20903
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:35:52 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is the SAS domain discovery code. Part 3/3.

+
+void
+asd_ConfigureExpanderSM_Finish(struct state_machine_context *sm_contextp,
+			       DISCOVER_RESULTS results)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureExpanderSM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	RETURN_STACK(results);
+}
+
+void asd_ConfigureExpanderSM_Abort(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureExpanderSM_Context *ctx;
+	ASD_DISCOVERY_STATES current_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_CONFIG_EXPANDER_ROUTE:
+		break;
+
+	case ASD_STATE_CONFIG_EXPANDER_ROUTE_LOOP:
+		break;
+
+	default:
+		break;
+	}
+}
+
+/* -------------------------------------------------------------------------- */
+
+struct asd_DiscoverConfigSetSM_Context {
+	struct discover_context *discover_contextp;
+	struct list_head *discover_listp;
+	struct asd_target *currentExpander;
+	struct asd_target *newExpander;
+	unsigned phyIndex;
+	struct list_head *found_listp;
+	struct list_head *old_discover_listp;
+};
+
+DISCOVER_RESULTS
+asd_state_config_set_issue_discover(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverConfigSetSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct Discover *currentDiscover;
+	unsigned conn_rate;
+	unsigned found_expander;
+	struct asd_DiscoverExpanderSM_Arguments args;
+	struct asd_target *target;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	currentDiscover = NULL;
+
+	while (1) {
+		for (; ctx->phyIndex !=
+		     ctx->currentExpander->num_phys; ctx->phyIndex++) {
+
+			/*
+			 * this is just a pointer helper
+			 */
+			currentDiscover = &(ctx->currentExpander->
+					    Phy[ctx->phyIndex].Result);
+
+			if (SAS_ISZERO(currentDiscover->AttachedSASAddress)) {
+				continue;
+			}
+
+			/*
+			 * Vitesse:
+			 */
+			if (((currentDiscover->TargetBits &
+			      SMP_TGT_PORT) != 0) &&
+			    (currentDiscover->AttachedDeviceType ==
+			     END_DEVICE)) {
+
+				printk("%s:%d: expander %llx reports %llx as "
+				       "an END_DEVICE, but SMP_TGT_PORT is "
+				       "set in TargetBits\n",
+				       __FUNCTION__, __LINE__,
+				       *((uint64_t *) ctx->currentExpander->
+					 ddb_profile.sas_addr),
+				       *((uint64_t *) currentDiscover->
+					 AttachedSASAddress));
+
+				printk("%s:%d: Assuming expander\n",
+				       __FUNCTION__, __LINE__);
+
+				currentDiscover->AttachedDeviceType =
+				    EDGE_EXPANDER_DEVICE;
+			}
+
+			/*
+			 * look for phys with edge or fanout devices attached...
+			 */
+			switch (currentDiscover->AttachedDeviceType) {
+			case EDGE_EXPANDER_DEVICE:
+				break;
+
+			case FANOUT_EXPANDER_DEVICE:
+				break;
+
+			case END_DEVICE:
+				conn_rate = ctx->currentExpander->
+				    ddb_profile.conn_rate;
+
+				if (conn_rate > currentDiscover->
+				    NegotiatedPhysicalLinkRate) {
+
+					conn_rate = currentDiscover->
+					    NegotiatedPhysicalLinkRate;
+				}
+
+				results = asd_configure_device(sm_contextp,
+							       ctx->
+							       currentExpander,
+							       currentDiscover,
+							       ctx->
+							       discover_listp,
+							       ctx->found_listp,
+							       ctx->
+							       old_discover_listp,
+							       conn_rate);
+
+				continue;
+
+			case NO_DEVICE:
+			default:
+				continue;
+			}
+
+			if (currentDiscover->RoutingAttribute != TABLE) {
+				continue;
+			}
+
+			/*
+			 * check to see if we already have the address
+			 * information in our expander list
+			 */
+			target = asd_find_target(ctx->discover_listp,
+						 currentDiscover->
+						 AttachedSASAddress);
+
+			if (target != NULL) {
+				continue;
+			}
+
+			args.sas_addr = currentDiscover->AttachedSASAddress;
+			args.upstreamExpander = ctx->currentExpander;
+			args.attachedDeviceType =
+			    currentDiscover->AttachedDeviceType;
+			args.old_discover_listp = ctx->old_discover_listp;
+			args.found_listp = ctx->found_listp;
+			args.conn_rate =
+			    currentDiscover->NegotiatedPhysicalLinkRate;
+
+			/*
+			 * if we did not have the expander in our list, then get
+			 * the information
+			 */
+			results = ASD_PUSH_STATE_MACHINE(sm_contextp,
+							 &asd_DiscoverExpanderSM,
+							 (void *)&args);
+
+			return results;
+		}
+
+		if (ctx->phyIndex == ctx->currentExpander->num_phys) {
+
+			found_expander = 0;
+
+			while (ctx->currentExpander->all_domain_targets.next
+			       != ctx->discover_listp) {
+
+				ctx->currentExpander =
+				    list_entry(ctx->currentExpander->
+					       all_domain_targets.next,
+					       struct asd_target,
+					       all_domain_targets);
+
+				if ((ctx->currentExpander->management_type ==
+				     ASD_DEVICE_EDGE_EXPANDER) ||
+				    (ctx->currentExpander->management_type ==
+				     ASD_DEVICE_FANOUT_EXPANDER)) {
+
+					found_expander = 1;
+
+					break;
+				}
+			}
+
+			if (found_expander == 0) {
+				return DISCOVER_FINISHED;
+			}
+
+			ctx->phyIndex = 0;
+		}
+	}
+}
+
+ASD_DISCOVERY_STATES
+asd_state_config_set_issue_discover_post(struct state_machine_context *
+					 sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverConfigSetSM_Context *ctx;
+	struct asd_target *expander;
+	DISCOVER_RESULTS results;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * The new expander is returned on the stack
+	 */
+	POP_STACK(results);
+	POP_STACK(expander);
+
+	ctx->phyIndex++;
+
+	if (results != DISCOVER_FINISHED) {
+		/*
+		 * For some reason we couldn't talk to this expander
+		 */
+		printk("Discover of expander 0x%0llx failed\n",
+		       *((uint64_t *) expander->ddb_profile.sas_addr));
+
+		return ASD_STATE_CONFIG_SET_ISSUE_DISCOVER;
+	}
+
+	ctx->newExpander = expander;
+
+	/*
+	 * Add the new expander to the tree.
+	 */
+	asd_add_child(discover_contextp->port, ctx->currentExpander,
+		      ctx->newExpander);
+
+	list_add_tail(&ctx->newExpander->all_domain_targets,
+		      ctx->discover_listp);
+
+	return ASD_STATE_CONFIG_SET_CONFIGURE_EXPANDER;
+}
+
+DISCOVER_RESULTS
+asd_state_config_set_configure_expander(struct state_machine_context *
+					sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverConfigSetSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_ConfigureExpanderSM_Arguments args;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	args.discover_listp = ctx->discover_listp;
+	args.newExpander = ctx->newExpander;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp,
+					 &asd_ConfigureExpanderSM,
+					 (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_config_set_configure_expander_post(struct state_machine_context *
+					     sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverConfigSetSM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	POP_STACK(results);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_CONFIG_SET_FAILED;
+	}
+
+	return ASD_STATE_CONFIG_SET_ISSUE_DISCOVER;
+}
+
+DISCOVER_RESULTS
+asd_DiscoverConfigSetSM_Initialize(struct state_machine_context * sm_contextp,
+				   void *init_args)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverConfigSetSM_Context *ctx;
+	struct asd_DiscoverConfigSetSM_Arguments *args;
+
+	NEW_CONTEXT(ctx);
+
+	args = (struct asd_DiscoverConfigSetSM_Arguments *)init_args;
+
+	ctx->currentExpander = args->currentExpander;
+	ctx->discover_listp = args->discover_listp;
+	ctx->found_listp = args->found_listp;
+	ctx->old_discover_listp = args->old_discover_listp;
+	ctx->phyIndex = 0;
+	ctx->newExpander = NULL;
+
+	list_del_init(&ctx->currentExpander->all_domain_targets);
+
+	list_add_tail(&ctx->currentExpander->all_domain_targets,
+		      ctx->discover_listp);
+
+	return DISCOVER_CONTINUE;
+}
+
+DISCOVER_RESULTS
+asd_DiscoverConfigSetSM_StateMachine(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverConfigSetSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	ASD_DISCOVERY_STATES current_state;
+	ASD_DISCOVERY_STATES new_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_CONFIG_SET_START:
+		new_state = ASD_STATE_CONFIG_SET_ISSUE_DISCOVER;
+		break;
+
+	case ASD_STATE_CONFIG_SET_ISSUE_DISCOVER:
+		new_state =
+		    asd_state_config_set_issue_discover_post(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIG_SET_CONFIGURE_EXPANDER:
+		new_state =
+		    asd_state_config_set_configure_expander_post(sm_contextp);
+		break;
+
+	default:
+		new_state = ASD_STATE_CONFIG_SET_FAILED;
+		break;
+	}
+
+	SM_new_state(sm_contextp, new_state);
+
+	switch (new_state) {
+	case ASD_STATE_CONFIG_SET_ISSUE_DISCOVER:
+		results = asd_state_config_set_issue_discover(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIG_SET_FINISHED:
+		results = DISCOVER_FINISHED;
+		break;
+
+	case ASD_STATE_CONFIG_SET_CONFIGURE_EXPANDER:
+		results = asd_state_config_set_configure_expander(sm_contextp);
+		break;
+
+	default:
+		results = DISCOVER_FAILED;
+		break;
+	}
+
+	return results;
+}
+
+void
+asd_DiscoverConfigSetSM_Finish(struct state_machine_context *sm_contextp,
+			       DISCOVER_RESULTS results)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverConfigSetSM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	RETURN_STACK(results);
+
+}
+
+void asd_DiscoverConfigSetSM_Abort(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverConfigSetSM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+}
+
+/* -------------------------------------------------------------------------- */
+
+struct asd_DiscoverFindBoundarySM_Context {
+	struct discover_context *discover_contextp;
+	struct asd_target *expander;
+	uint8_t upstreamSASAddress[SAS_ADDR_LEN];
+	uint8_t attachedPhyIdentifier;
+	uint8_t phyIdentifier;
+	struct asd_target *attachedRootExpander;
+	struct list_head *found_listp;
+	struct list_head *old_discover_listp;
+	unsigned conn_rate;
+};
+
+ASD_DISCOVERY_STATES
+asd_state_find_boundary_start(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverFindBoundarySM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_find_subtractive_phy(sm_contextp, ctx->expander,
+					   ctx->upstreamSASAddress,
+					   &ctx->attachedPhyIdentifier,
+					   &ctx->conn_rate,
+					   &ctx->phyIdentifier);
+
+	if ((results == DISCOVER_FINISHED) ||
+	    SAS_ISZERO(ctx->upstreamSASAddress)) {
+
+		ctx->expander->management_flags |= DEVICE_SET_ROOT;
+
+		return ASD_STATE_FIND_BOUNDARY_FINISHED;
+	}
+
+	return ASD_STATE_FIND_BOUNDARY_LOOP;
+}
+
+DISCOVER_RESULTS
+asd_state_find_boundary_loop(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverFindBoundarySM_Context *ctx;
+	struct asd_DiscoverExpanderSM_Arguments args;
+	DISCOVER_RESULTS results;
+	struct Discover *discover;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	/*
+	 * if we have a subtractive address then go upstream
+	 * to see if it is part of the edge expander device set
+	 */
+
+	discover = &(ctx->expander->Phy[ctx->phyIdentifier].Result);
+
+	args.sas_addr = ctx->upstreamSASAddress;
+	args.upstreamExpander = ctx->expander;
+	args.attachedDeviceType = discover->AttachedDeviceType;
+	args.old_discover_listp = ctx->old_discover_listp;
+	args.found_listp = ctx->found_listp;
+	args.conn_rate = ctx->conn_rate;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp, &asd_DiscoverExpanderSM,
+					 (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_find_boundary_loop_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverFindBoundarySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_target *upstreamExpander;
+	struct Discover *discover;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * The new expander is returned on the stack
+	 */
+	POP_STACK(results);
+	POP_STACK(upstreamExpander);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_FIND_BOUNDARY_FAILED;
+	}
+
+	/*
+	 * Add the new expander to the tree.
+	 */
+	asd_add_child(discover_contextp->port, ctx->expander, upstreamExpander);
+
+	list_add_tail(&upstreamExpander->all_domain_targets, ctx->found_listp);
+
+	results = asd_find_subtractive_phy(sm_contextp, upstreamExpander,
+					   ctx->upstreamSASAddress,
+					   &ctx->attachedPhyIdentifier,
+					   &ctx->conn_rate,
+					   &ctx->phyIdentifier);
+
+	if (results == DISCOVER_FINISHED) {
+
+		ctx->expander = upstreamExpander;
+
+		ctx->expander->management_flags |= DEVICE_SET_ROOT;
+
+		return ASD_STATE_FIND_BOUNDARY_FINISHED;
+	}
+
+	/*
+	 * initialize the subtractive address, a zero value is not valid
+	 */
+	if (results == DISCOVER_FAILED) {
+		/*
+		 * to get here, we had to see more than one subtractive
+		 * phy that connect to different SAS addresses, this is
+		 * a topology error do cleanup on any memory allocated
+		 * if necessary
+		 */
+
+		// TODO: fix this
+		// TODO: what do we want to return here???
+
+		return ASD_STATE_FIND_BOUNDARY_FAILED;
+	}
+
+	/*
+	 * if no error, then decide if we need to go upstream or stop
+	 */
+	if (SAS_ISZERO(ctx->upstreamSASAddress)) {
+
+		ctx->expander = upstreamExpander;
+
+		return ASD_STATE_FIND_BOUNDARY_FINISHED;
+	}
+
+	/*
+	 * this is just a pointer helper
+	 */
+	discover = &(upstreamExpander->Phy[ctx->phyIdentifier].Result);
+
+	/*
+	 * check to see if the upstream expander is connected to the 
+	 * subtractive port of the previous expander, if we are then we 
+	 * have two expander device sets connected together, stop here 
+	 * and save the target pointer of next expander in device set.
+	 */
+	if (SAS_ISEQUAL(discover->AttachedSASAddress,
+			upstreamExpander->parent->ddb_profile.sas_addr)) {
+
+		ctx->attachedRootExpander = upstreamExpander;
+
+		ctx->expander->management_flags |= DEVICE_SET_ROOT;
+		ctx->attachedRootExpander->management_flags |= DEVICE_SET_ROOT;
+
+		return ASD_STATE_FIND_BOUNDARY_FINISHED;
+	}
+
+	/*
+	 * Movin' on up.
+	 */
+	ctx->expander = upstreamExpander;
+
+	return ASD_STATE_FIND_BOUNDARY_LOOP;
+}
+
+DISCOVER_RESULTS
+asd_DiscoverFindBoundarySM_Initialize(struct state_machine_context *
+				      sm_contextp, void *init_args)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverFindBoundarySM_Context *ctx;
+	struct asd_DiscoverFindBoundarySM_Arguments *args;
+
+	NEW_CONTEXT(ctx);
+
+	args = (struct asd_DiscoverFindBoundarySM_Arguments *)init_args;
+
+	ctx->expander = args->expander;
+	ctx->found_listp = args->found_listp;
+	ctx->old_discover_listp = args->old_discover_listp;
+
+	SAS_ZERO(ctx->upstreamSASAddress);
+	ctx->attachedPhyIdentifier = 0;
+	ctx->attachedRootExpander = NULL;
+
+	return DISCOVER_CONTINUE;
+}
+
+DISCOVER_RESULTS
+asd_DiscoverFindBoundarySM_StateMachine(struct state_machine_context *
+					sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverFindBoundarySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	ASD_DISCOVERY_STATES current_state;
+	ASD_DISCOVERY_STATES new_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_FIND_BOUNDARY_START:
+		new_state = asd_state_find_boundary_start(sm_contextp);
+		break;
+
+	case ASD_STATE_FIND_BOUNDARY_LOOP:
+		new_state = asd_state_find_boundary_loop_post(sm_contextp);
+		break;
+
+	default:
+		new_state = ASD_STATE_FIND_BOUNDARY_FAILED;
+		break;
+	}
+
+	SM_new_state(sm_contextp, new_state);
+
+	switch (new_state) {
+	case ASD_STATE_FIND_BOUNDARY_LOOP:
+		results = asd_state_find_boundary_loop(sm_contextp);
+		break;
+
+	case ASD_STATE_FIND_BOUNDARY_FINISHED:
+		results = DISCOVER_FINISHED;
+		break;
+
+	default:
+		results = DISCOVER_FAILED;
+		break;
+	}
+
+	return results;
+}
+
+void
+asd_DiscoverFindBoundarySM_Finish(struct state_machine_context *sm_contextp,
+				  DISCOVER_RESULTS results)
+{
+
+	struct state_information *state_infop;
+	struct asd_DiscoverFindBoundarySM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	RETURN_STACK(ctx->attachedRootExpander);
+	RETURN_STACK(ctx->expander);
+	RETURN_STACK(results);
+}
+
+void asd_DiscoverFindBoundarySM_Abort(struct state_machine_context *sm_contextp)
+{
+
+	struct state_information *state_infop;
+	struct asd_DiscoverFindBoundarySM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+}
+
+/* -------------------------------------------------------------------------- */
+
+struct asd_DiscoverExpanderSM_Context {
+	struct discover_context *discover_contextp;
+	struct asd_target *expander;
+	unsigned phyIndex;
+	uint8_t *sas_addr;
+	unsigned attachedDeviceType;
+	struct list_head *old_discover_listp;
+	struct list_head *found_listp;
+	struct asd_target *upstreamExpander;
+	unsigned conn_rate;
+};
+
+DISCOVER_RESULTS
+asd_state_issue_report_general(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverExpanderSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	unsigned conn_rate;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * Get the connection rate from the upstream expander.  The upstream
+	 * expander is different than the "parent" expander with is based on
+	 * the topology of the device set.
+	 */
+	if (ctx->upstreamExpander == NULL) {
+		conn_rate = discover_contextp->port->conn_rate;
+	} else {
+		conn_rate = ctx->upstreamExpander->ddb_profile.conn_rate;
+	}
+
+	if (conn_rate > ctx->conn_rate) {
+		conn_rate = ctx->conn_rate;
+	}
+
+	results = asd_issue_report_general(sm_contextp,
+					   ctx->sas_addr,
+					   conn_rate, ctx->attachedDeviceType,
+					   ctx->old_discover_listp,
+					   ctx->found_listp, &ctx->expander);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_issue_report_general_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverExpanderSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	results = asd_issue_report_general_post(sm_contextp, ctx->expander);
+
+	if (results != DISCOVER_OK) {
+
+		printk("%s:%d: Report General Failed\n", __FUNCTION__,
+		       __LINE__);
+
+		return ASD_STATE_REPORT_AND_DISCOVER_FAILED;
+	}
+
+	return ASD_STATE_ISSUE_DISCOVER_LOOP;
+}
+
+DISCOVER_RESULTS
+asd_state_issue_discover_loop(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverExpanderSM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_discover_request(sm_contextp,
+					     ctx->expander, ctx->phyIndex);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_issue_discover_loop_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverExpanderSM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_discover_request_post(sm_contextp,
+						  ctx->expander, ctx->phyIndex);
+
+	if (results != DISCOVER_OK) {
+		printk("%s:%d: Discover Request Failed\n", __FUNCTION__,
+		       __LINE__);
+
+		return ASD_STATE_REPORT_AND_DISCOVER_FAILED;
+	}
+
+	ctx->phyIndex++;
+
+	if (ctx->phyIndex == ctx->expander->num_phys) {
+		return ASD_STATE_REPORT_AND_DISCOVER_FINISHED;
+	}
+
+	return ASD_STATE_ISSUE_DISCOVER_LOOP;
+}
+
+DISCOVER_RESULTS
+asd_DiscoverExpanderSM_Initialize(struct state_machine_context * sm_contextp,
+				  void *init_args)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverExpanderSM_Context *ctx;
+	struct asd_DiscoverExpanderSM_Arguments *args;
+
+	NEW_CONTEXT(ctx);
+
+	args = (struct asd_DiscoverExpanderSM_Arguments *)init_args;
+
+	ctx->sas_addr = args->sas_addr;
+	ctx->upstreamExpander = args->upstreamExpander;
+	ctx->attachedDeviceType = args->attachedDeviceType;
+	ctx->old_discover_listp = args->old_discover_listp;
+	ctx->found_listp = args->found_listp;
+	ctx->conn_rate = args->conn_rate;
+	ctx->phyIndex = 0;
+	ctx->expander = NULL;
+
+	return DISCOVER_CONTINUE;
+}
+
+DISCOVER_RESULTS
+asd_DiscoverExpanderSM_StateMachine(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverExpanderSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	ASD_DISCOVERY_STATES current_state;
+	ASD_DISCOVERY_STATES new_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_REPORT_AND_DISCOVER_START:
+		new_state = ASD_STATE_ISSUE_REPORT_GENERAL;
+		break;
+
+	case ASD_STATE_ISSUE_REPORT_GENERAL:
+		new_state = asd_state_issue_report_general_post(sm_contextp);
+		break;
+
+	case ASD_STATE_ISSUE_DISCOVER_LOOP:
+		new_state = asd_state_issue_discover_loop_post(sm_contextp);
+		break;
+
+	default:
+		new_state = ASD_STATE_REPORT_AND_DISCOVER_FAILED;
+		break;
+	}
+
+	SM_new_state(sm_contextp, new_state);
+
+	switch (new_state) {
+	case ASD_STATE_ISSUE_REPORT_GENERAL:
+		results = asd_state_issue_report_general(sm_contextp);
+		break;
+
+	case ASD_STATE_ISSUE_DISCOVER_LOOP:
+		results = asd_state_issue_discover_loop(sm_contextp);
+		break;
+
+	case ASD_STATE_REPORT_AND_DISCOVER_FINISHED:
+		results = DISCOVER_FINISHED;
+		break;
+
+	default:
+		results = DISCOVER_FAILED;
+		break;
+	}
+
+	return results;
+}
+
+void
+asd_DiscoverExpanderSM_Finish(struct state_machine_context *sm_contextp,
+			      DISCOVER_RESULTS results)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverExpanderSM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	RETURN_STACK(ctx->expander);
+	RETURN_STACK(results);
+}
+
+void asd_DiscoverExpanderSM_Abort(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverExpanderSM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+}
+
+/* -------------------------------------------------------------------------- */
+
+struct asd_DiscoverySM_Context {
+	struct discover_context *discover_contextp;
+
+	/*
+	 * The expander that is directly attached to this initiator/port
+	 */
+	struct asd_target *connectedExpander;
+
+	/*
+	 * The expander that is at the root of this device set
+	 */
+	struct asd_target *thisDeviceSet;
+
+	/*
+	 * The expander that is at the root of the attached device set (if any).
+	 * The attached device set is the the device set on the the other side
+	 * of a subtractive-subtractive boundary.
+	 */
+	struct asd_target *attachedDeviceSet;
+
+	/*
+	 * The list that we discovered from thisDeviceSet.
+	 */
+	struct list_head discover_list;
+
+	/*
+	 * The list that we discovered from attachedDeviceSet.
+	 */
+	struct list_head attached_device_list;
+
+	/*
+	 * During the process of discovering expanders, we may find a
+	 * device or expander that we don't know where to put at the moment.
+	 */
+	struct list_head found_list;
+
+	/*
+	 * The list from the previous discovery.  If there is anything left
+	 * on this list at the end of discovery, the device is no longer
+	 * present.
+	 */
+	struct list_head old_discover_list;
+};
+
+ASD_DISCOVERY_STATES
+asd_state_discover_start(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	struct asd_target *target;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * Invalidate all the targets, if any, found so far.  
+	 */
+	asd_invalidate_targets(discover_contextp->asd, discover_contextp->port);
+
+	/*
+	 * Move our list of formerly discovered targets to the "old discover
+	 * list".  We will use this list later to figure out which devices have
+	 * been removed.
+	 */
+	list_move_all(&ctx->old_discover_list,
+		      &discover_contextp->port->targets);
+
+	/*
+	 * MDT. Saving pointers for easy access.
+	 */
+	discover_contextp->asd->old_discover_listp = &ctx->old_discover_list;
+	discover_contextp->asd->discover_listp = &ctx->discover_list;
+
+	if (discover_contextp->port->tree_root == NULL) {
+		return ASD_STATE_FINISHED;
+	}
+
+	/*
+	 * check to see if an expander is attached
+	 */
+	if ((discover_contextp->port->management_type !=
+	     ASD_DEVICE_EDGE_EXPANDER) &&
+	    (discover_contextp->port->management_type !=
+	     ASD_DEVICE_FANOUT_EXPANDER)) {
+
+		target = asd_find_target(&ctx->old_discover_list,
+					 discover_contextp->port->tree_root->
+					 ddb_profile.sas_addr);
+
+		if (target != NULL) {
+			/*
+			 * This target was previously found.
+			 */
+			target->flags |= ASD_TARG_RESEEN;
+
+			/*
+			 * Take this target off of the old discover list.
+			 */
+			list_del_init(&target->all_domain_targets);
+		}
+
+		list_add_tail(&discover_contextp->port->tree_root->
+			      all_domain_targets, &ctx->discover_list);
+
+		/*
+		 * There isn't an expander to discover, so move on to the
+		 * initialization stage of the state machine.
+		 */
+		return ASD_STATE_SATA_SPINHOLD;
+	}
+
+	/*
+	 * walk the list of targets, and re-initialize the tree links.
+	 */
+	list_for_each_entry(target, &ctx->old_discover_list, all_domain_targets) {
+
+		target->parent = NULL;
+		INIT_LIST_HEAD(&target->children);
+		INIT_LIST_HEAD(&target->siblings);
+		INIT_LIST_HEAD(&target->multipath);
+
+		if ((target->management_type != ASD_DEVICE_EDGE_EXPANDER) &&
+		    (target->management_type != ASD_DEVICE_FANOUT_EXPANDER)) {
+
+			continue;
+		}
+
+		if (target->num_route_indexes == 0) {
+			continue;
+		}
+
+		if (target->RouteTable != NULL) {
+			memset(target->RouteTable, 0,
+			       SAS_ADDR_LEN * target->num_phys *
+			       target->num_route_indexes);
+		}
+
+		if (target->route_indexes != NULL) {
+			memset(target->route_indexes, 0,
+			       target->num_route_indexes * sizeof(uint16_t));
+		}
+	}
+
+	/*
+	 * Put our newly discovered, directly attached target in the found
+	 * list.
+	 */
+	list_del_init(&discover_contextp->port->tree_root->all_domain_targets);
+
+	list_add_tail(&discover_contextp->port->tree_root->all_domain_targets,
+		      &ctx->found_list);
+
+	return ASD_STATE_DISCOVER_ATTACHED;
+}
+
+DISCOVER_RESULTS
+asd_state_discover_attached(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_DiscoverExpanderSM_Arguments args;
+	uint8_t device_type;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	switch (discover_contextp->port->management_type) {
+	case ASD_DEVICE_EDGE_EXPANDER:
+		device_type = EDGE_EXPANDER_DEVICE;
+		break;
+
+	case ASD_DEVICE_FANOUT_EXPANDER:
+		device_type = FANOUT_EXPANDER_DEVICE;
+		break;
+
+	default:
+		/*
+		 * If this isn't some kind of expander, then we shouldn't
+		 * be here.
+		 */
+		results = DISCOVER_FAILED;
+		return results;
+	}
+
+	/*
+	 * There is no upstream expander from this expander, because it is
+	 * the closest device to the initiator.
+	 */
+	args.sas_addr = discover_contextp->port->attached_sas_addr;
+	args.upstreamExpander = NULL;
+	args.attachedDeviceType = device_type;
+	args.old_discover_listp = &ctx->old_discover_list;
+	args.found_listp = &ctx->found_list;
+	args.conn_rate = discover_contextp->port->conn_rate;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp, &asd_DiscoverExpanderSM,
+					 (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_discover_attached_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_target *new_expander;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * The new expander is returned on the stack
+	 */
+	POP_STACK(results);
+	POP_STACK(new_expander);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_FAILED;
+	}
+
+	ctx->connectedExpander = new_expander;
+
+	list_add_tail(&new_expander->all_domain_targets, &ctx->found_list);
+
+	return ASD_STATE_FIND_BOUNDARY;
+}
+
+DISCOVER_RESULTS
+asd_state_find_boundary(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_DiscoverFindBoundarySM_Arguments args;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	args.expander = ctx->connectedExpander;
+	args.found_listp = &ctx->found_list;
+	args.old_discover_listp = &ctx->old_discover_list;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp,
+					 &asd_DiscoverFindBoundarySM,
+					 (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_find_boundary_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_target *expander;
+	struct asd_target *attachedRootExpander;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	POP_STACK(results);
+	POP_STACK(expander);
+	POP_STACK(attachedRootExpander);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_FAILED;
+	}
+
+	ctx->thisDeviceSet = expander;
+	ctx->attachedDeviceSet = attachedRootExpander;
+
+	return ASD_STATE_CONFIG_BOUNDARY_SET;
+}
+
+DISCOVER_RESULTS
+asd_state_config_boundary_set(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_DiscoverConfigSetSM_Arguments args;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	args.discover_listp = &ctx->discover_list;
+	args.found_listp = &ctx->found_list;
+	args.old_discover_listp = &ctx->old_discover_list;
+	args.currentExpander = ctx->thisDeviceSet;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp, &asd_DiscoverConfigSetSM,
+					 (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_config_boundary_set_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	POP_STACK(results);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_FAILED;
+	}
+
+	if (ctx->attachedDeviceSet == NULL) {
+		return ASD_STATE_SATA_SPINHOLD;
+	}
+
+	return ASD_STATE_CONFIG_ATTACHED_SET;
+}
+
+DISCOVER_RESULTS
+asd_state_config_attached_set(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_DiscoverConfigSetSM_Arguments args;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	args.discover_listp = &ctx->attached_device_list;
+	args.found_listp = &ctx->found_list;
+	args.old_discover_listp = &ctx->old_discover_list;
+	args.currentExpander = ctx->attachedDeviceSet;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp, &asd_DiscoverConfigSetSM,
+					 (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_config_attached_set_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	POP_STACK(results);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_FAILED;
+	}
+
+	/*
+	 * put the domains together
+	 */
+	list_splice(&ctx->attached_device_list, ctx->discover_list.prev);
+
+	return ASD_STATE_SATA_SPINHOLD;
+}
+
+DISCOVER_RESULTS
+asd_state_sata_spinhold(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_SATA_SpinHoldSM_Arguments args;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	args.discover_listp = &ctx->discover_list;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp, &asd_SATA_SpinHoldSM,
+					 (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_sata_spinhold_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	POP_STACK(results);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_FAILED;
+	}
+
+	return ASD_STATE_INIT_SATA;
+}
+
+DISCOVER_RESULTS asd_state_init_sata(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_InitSATA_SM_Arguments args;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	args.discover_listp = &ctx->discover_list;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp, &asd_InitSATA_SM,
+					 (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_sata_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	POP_STACK(results);
+
+	if (results != DISCOVER_FINISHED) {
+		//TODO: we can't give up, but we need to notify the user
+	}
+
+	return ASD_STATE_INIT_SAS;
+}
+
+DISCOVER_RESULTS asd_state_init_sas(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_InitSAS_SM_Arguments args;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	args.discover_listp = &ctx->discover_list;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp, &asd_InitSAS_SM,
+					 (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_sas_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	POP_STACK(results);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_FAILED;
+	}
+
+	return ASD_STATE_INIT_SMP;
+}
+
+DISCOVER_RESULTS asd_state_init_smp(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_InitSMP_SM_Arguments args;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	args.discover_listp = &ctx->discover_list;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp, &asd_InitSMP_SM,
+					 (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_smp_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	POP_STACK(results);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_FAILED;
+	}
+
+	return ASD_STATE_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_DiscoverySM_Initialize(struct state_machine_context * sm_contextp,
+			   void *init_args)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	struct discover_context *discover_contextp;
+
+	NEW_CONTEXT(ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	ctx->connectedExpander = NULL;
+	ctx->thisDeviceSet = NULL;
+	ctx->attachedDeviceSet = NULL;
+
+	INIT_LIST_HEAD(&ctx->discover_list);
+	INIT_LIST_HEAD(&ctx->attached_device_list);
+	INIT_LIST_HEAD(&ctx->found_list);
+	INIT_LIST_HEAD(&ctx->old_discover_list);
+
+	return DISCOVER_CONTINUE;
+}
+
+DISCOVER_RESULTS
+asd_DiscoverySM_StateMachine(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	DISCOVER_RESULTS results;
+	ASD_DISCOVERY_STATES current_state;
+	ASD_DISCOVERY_STATES new_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_DISCOVER_START:
+		new_state = asd_state_discover_start(sm_contextp);
+		break;
+
+	case ASD_STATE_DISCOVER_ATTACHED:
+		new_state = asd_state_discover_attached_post(sm_contextp);
+		break;
+
+	case ASD_STATE_FIND_BOUNDARY:
+		new_state = asd_state_find_boundary_post(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIG_BOUNDARY_SET:
+		new_state = asd_state_config_boundary_set_post(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIG_ATTACHED_SET:
+		new_state = asd_state_config_attached_set_post(sm_contextp);
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD:
+		new_state = asd_state_sata_spinhold_post(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SATA:
+		new_state = asd_state_init_sata_post(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS:
+		new_state = asd_state_init_sas_post(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SMP:
+		new_state = asd_state_init_smp_post(sm_contextp);
+		break;
+
+	default:
+		new_state = ASD_STATE_FAILED;
+		break;
+	}
+
+	SM_new_state(sm_contextp, new_state);
+
+	switch (new_state) {
+	case ASD_STATE_DISCOVER_ATTACHED:
+		results = asd_state_discover_attached(sm_contextp);
+		break;
+
+	case ASD_STATE_FIND_BOUNDARY:
+		results = asd_state_find_boundary(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIG_BOUNDARY_SET:
+		results = asd_state_config_boundary_set(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIG_ATTACHED_SET:
+		results = asd_state_config_attached_set(sm_contextp);
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD:
+		results = asd_state_sata_spinhold(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SATA:
+		results = asd_state_init_sata(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS:
+		results = asd_state_init_sas(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SMP:
+		results = asd_state_init_smp(sm_contextp);
+		break;
+
+	case ASD_STATE_FINISHED:
+		results = DISCOVER_FINISHED;
+		break;
+
+	default:
+		results = DISCOVER_FAILED;
+		break;
+	}
+
+	return results;
+}
+
+void
+asd_DiscoverySM_Finish(struct state_machine_context *sm_contextp,
+		       DISCOVER_RESULTS results)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+	struct discover_context *discover_contextp;
+	unsigned long flags;
+	struct asd_phy *phy;
+	uint8_t conn_mask;
+	unsigned num_discovery;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	/*
+	 * We don't necessarily update the mask when we start discovery.  Set
+	 * it to the right value.
+	 */
+	conn_mask = 0;
+
+	list_for_each_entry(phy, &discover_contextp->port->phys_attached, links) {
+
+		conn_mask |= (1 << phy->id);
+	};
+
+	discover_contextp->port->conn_mask = conn_mask;
+
+	asd_apply_conn_mask(discover_contextp->asd, &ctx->discover_list);
+
+	if (discover_contextp->asd->platform_data->flags & ASD_DISCOVERY_INIT) {
+
+		// TODO: this is not MP safe, even with the lock.
+
+		asd_lock(discover_contextp->asd, &flags);
+
+		discover_contextp->asd->num_discovery--;
+
+		num_discovery = discover_contextp->asd->num_discovery;
+
+		asd_unlock(discover_contextp->asd, &flags);
+
+		INIT_LIST_HEAD(&discover_contextp->port->targets_to_validate);
+
+		list_move_all(&discover_contextp->port->targets_to_validate,
+			      &ctx->discover_list);
+
+		if (num_discovery == 0) {
+			asd_validate_targets_init(discover_contextp->asd);
+		}
+	} else {
+		/*
+		 * Hot Plug.
+		 */
+		/*
+		 * Validate any new targets that have been hot-plugged or 
+		 * hot-removed.
+		 */
+		asd_validate_targets_hotplug(discover_contextp->asd,
+					     discover_contextp->port, ctx);
+
+		list_move_all(&discover_contextp->port->targets,
+			      &ctx->discover_list);
+	}
+
+	discover_contextp->port->events &= ~ASD_DISCOVERY_PROCESS;
+
+	asd_wakeup_sem(&discover_contextp->asd->platform_data->discovery_sem);
+
+#if DISCOVER_DEBUG
+	//asd_dump_tree(asd, port);
+#endif
+}
+
+void asd_DiscoverySM_Abort(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_DiscoverySM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+}
+
+/* -------------------------------------------------------------------------- */
+
+DISCOVER_RESULTS asd_do_discovery(struct asd_softc *asd, struct asd_port *port)
+{
+	DISCOVER_RESULTS results;
+
+	port->dc.sm_context.state_stack_top = -1;
+
+	port->dc.asd = asd;
+	port->dc.port = port;
+
+	port->dc.sm_context.state_handle = (void *)&port->dc;
+	port->dc.sm_context.wakeup_state_machine =
+	    asd_discover_wakeup_state_machine;
+
+	results =
+	    ASD_PUSH_STATE_MACHINE(&port->dc.sm_context, &asd_DiscoverySM,
+				   NULL);
+
+	if (results == DISCOVER_CONTINUE) {
+		results = asd_run_state_machine(&port->dc.sm_context);
+	}
+
+	return results;
+}
+
+void asd_abort_discovery(struct asd_softc *asd, struct asd_port *port)
+{
+	asd_abort_state_machine(&port->dc.sm_context);
+}
+
+static void asd_invalidate_targets(struct asd_softc *asd, struct asd_port *port)
+{
+	struct asd_target *target;
+
+	list_for_each_entry(target, &port->targets, all_domain_targets) {
+		target->flags &= ~ASD_TARG_ONLINE;
+	}
+}
+
+static void
+asd_apply_conn_mask(struct asd_softc *asd, struct list_head *discover_list)
+{
+	struct asd_target *target;
+
+	if (list_empty(discover_list)) {
+		return;
+	}
+
+	list_for_each_entry(target, discover_list, all_domain_targets) {
+		asd_hwi_build_ddb_site(asd, target);
+	}
+}
+
+int asd_map_multipath(struct asd_softc *asd, struct asd_target *target)
+{
+	int ret;
+	struct asd_target *multipath_target;
+	struct asd_device *dev;
+	unsigned i;
+
+	/*
+	 * Check to make sure that this same device hasn't been exposed to the
+	 * OS on a different port.
+	 */
+	multipath_target = asd_find_multipath(asd, target);
+
+	if (multipath_target != NULL) {
+		list_add_tail(&target->multipath, &multipath_target->multipath);
+
+		return 1;
+	}
+
+	ret = asd_map_target(asd, target);
+
+	if (ret != 0) {
+		return ret;
+	}
+
+	target->flags |= ASD_TARG_MAPPED;
+
+	/*
+	 * At this point in time, we know how many luns this device has,
+	 * create the device structures for each LUN.
+	 */
+	switch (target->command_set_type) {
+	case ASD_COMMAND_SET_SCSI:
+		for (i = 0; i < target->scsi_cmdset.num_luns; i++) {
+			dev = asd_alloc_device(asd, target,
+					       target->src_port->id,
+					       target->target, i);
+
+			memcpy(dev->saslun, &target->scsi_cmdset.luns[i],
+			       SAS_LUN_LEN);
+		}
+		break;
+
+	case ASD_COMMAND_SET_ATA:
+	case ASD_COMMAND_SET_ATAPI:
+		dev = asd_alloc_device(asd, target,
+				       target->src_port->id, target->target, 0);
+
+		memset(dev->saslun, 0, SAS_LUN_LEN);
+		break;
+
+	default:
+		break;
+	}
+
+	return ret;
+
+}
+
+void asd_mark_duplicates(struct asd_softc *asd, struct list_head *discover_list)
+{
+	struct asd_target *target;
+	struct asd_target *tmp_target;
+	struct asd_target *check_target;
+	struct list_head map_list;
+	unsigned found_mapped;
+
+	INIT_LIST_HEAD(&map_list);
+
+	/*
+	 * Walk down the discovery list looking for duplicate devices.  If we
+	 * find a duplicate device, chain it to the mutipath list of the primary
+	 * target.  Put all of the unique devices in a list to mapped.
+	 */
+	while (!list_empty(discover_list)) {
+
+		target = list_entry(discover_list->next,
+				    struct asd_target, all_domain_targets);
+
+		list_del_init(&target->all_domain_targets);
+
+		/*
+		 * We only care about presenting end devices to the OS.
+		 */
+		if (target->management_type != ASD_DEVICE_END) {
+
+			list_add_tail(&target->all_domain_targets, &map_list);
+
+			continue;
+		}
+
+		switch (target->transport_type) {
+		case ASD_TRANSPORT_ATA:
+			list_add_tail(&target->all_domain_targets, &map_list);
+
+			continue;
+
+		case ASD_TRANSPORT_STP:
+		case ASD_TRANSPORT_SSP:
+			break;
+
+		default:
+			list_add_tail(&target->all_domain_targets, &map_list);
+			continue;
+		}
+
+		found_mapped = 0;
+
+		/*
+		 * Walk through the list marking each target that matches this
+		 * target as a duplicate.
+		 */
+		list_for_each_entry_safe(check_target, tmp_target,
+					 discover_list, all_domain_targets) {
+
+			/*
+			 * If they are not the same type of device, then
+			 * they can not be duplicates.
+			 */
+			if (target->transport_type !=
+			    check_target->transport_type) {
+
+				continue;
+			}
+
+			switch (target->transport_type) {
+			case ASD_TRANSPORT_SSP:
+				/*
+				 * If the lengths of the identification values
+				 * don't match, then the values themselves
+				 * can't match.
+				 */
+				if (target->scsi_cmdset.ident_len !=
+				    check_target->scsi_cmdset.ident_len) {
+
+					continue;
+				}
+
+				if (memcmp(target->scsi_cmdset.ident,
+					   check_target->scsi_cmdset.ident,
+					   target->scsi_cmdset.ident_len) !=
+				    0) {
+
+					continue;
+				}
+				break;
+
+			case ASD_TRANSPORT_STP:
+				if (!SAS_ISEQUAL(target->ddb_profile.sas_addr,
+						 check_target->ddb_profile.
+						 sas_addr)) {
+
+					continue;
+				}
+
+				break;
+
+			default:
+				continue;
+			}
+
+			/*
+			 * We have found a duplicate device.
+			 */
+			list_del_init(&check_target->all_domain_targets);
+
+			if (check_target->flags & ASD_TARG_MAPPED) {
+				/*
+				 * This is a device that has not been
+				 * discovered before that matches a device
+				 * that has already been discovered and is
+				 * exposed to the OS.
+				 */
+				list_add_tail(&target->multipath,
+					      &check_target->multipath);
+
+				list_add_tail(&check_target->all_domain_targets,
+					      &map_list);
+
+				found_mapped = 1;
+
+				continue;
+			}
+
+			/*
+			 * This device is a multipath, so we will not map it.
+			 */
+			list_add_tail(&check_target->multipath,
+				      &target->multipath);
+		}
+
+		if (found_mapped == 0) {
+			/*
+			 * We didn't find another matching target, so we
+			 * will add this target to our list of devices to be
+			 * mapped.
+			 */
+			list_add_tail(&target->all_domain_targets, &map_list);
+		}
+	}
+
+	/*
+	 * Walk down the list of targets to be mapped, and map them.
+	 */
+	list_for_each_entry_safe(target, tmp_target, &map_list,
+				 all_domain_targets) {
+
+		/*
+		 * We only care about not presenting end devices to the OS.
+		 */
+		if (target->management_type != ASD_DEVICE_END) {
+			continue;
+		}
+
+		if (target->flags & ASD_TARG_MAPPED) {
+			continue;
+		}
+
+		target->flags |= ASD_TARG_NEEDS_MAP;
+
+	}
+
+	list_move_all(discover_list, &map_list);
+}
+
+void
+asd_remap_device(struct asd_softc *asd,
+		 struct asd_target *target, struct asd_target *multipath_target)
+{
+	unsigned i;
+	struct asd_domain *dm;
+
+	if ((target->flags & ASD_TARG_MAPPED) == 0) {
+		return;
+	}
+
+	multipath_target->flags |= ASD_TARG_MAPPED;
+
+	target->flags &= ~ASD_TARG_MAPPED;
+
+	dm = target->domain;
+
+	for (i = 0; i < ASD_MAX_TARGETS; i++) {
+
+		if (dm->targets[i] != target) {
+			continue;
+		}
+
+		dm->targets[i] = multipath_target;
+
+		multipath_target->target = i;
+
+		break;
+	}
+
+	multipath_target->domain = dm;
+	multipath_target->refcount = target->refcount;
+
+	target->domain = NULL;
+
+	for (i = 0; i < ASD_MAX_LUNS; i++) {
+
+		if (target->devices[i] == NULL) {
+			continue;
+		}
+
+		multipath_target->devices[i] = target->devices[i];
+		multipath_target->devices[i]->target = multipath_target;
+#ifdef MULTIPATH_IO
+		multipath_target->devices[i]->current_target = multipath_target;
+#endif
+	}
+}
+
+/*
+ * At this point, all targets are either on their port->target list or on
+ * the context discover_list.  There can be more than one discovery going on
+ * simulataneously, but each one will call asd_validate_targets when it 
+ * completes.
+ */
+static void asd_validate_targets_init(struct asd_softc *asd)
+{
+	struct asd_target *target;
+	struct asd_target *tmp_target;
+	struct asd_port *port;
+	unsigned port_id;
+	struct list_head map_list;
+#ifdef OCM_REMAP
+	unsigned i;
+	struct asd_phy *phy;
+	struct asd_unit_element_format *punit_elm;
+	struct asd_uid_lu_naa_wwn *punit_id_lun;
+	struct asd_uid_lu_sata_model_num *punit_id_dir_sata;
+#endif
+
+	INIT_LIST_HEAD(&map_list);
+
+	/*
+	 * This code has been turned off in favor of using labels or UUIDS to
+	 * determine drive to filesystem mapping.
+	 */
+#ifdef OCM_REMAP
+	/*
+	 * Do one pass through the OCM structure that was passed by the BIOS.
+	 * The devices will go at the head of the "map_list".  Since these
+	 * devices are going on the list first, they will also be the exported
+	 * targets if we find duplicates later.
+	 */
+	for (i = 0; i < asd->num_unit_elements; i++) {
+
+		punit_elm = &asd->unit_elements[i];
+
+		switch (punit_elm->type) {
+		case UNELEM_LU_SATA_MOD_SERIAL_NUM:
+			punit_id_dir_sata = (struct asd_uid_lu_sata_model_num *)
+			    punit_elm->id;
+
+#if 0
+			printk("%s:%d: UNIT_ELEMENT_DIRECT_ATTACHED_SATA "
+			       "phy ID %d\n", __FUNCTION__, __LINE__,
+			       punit_id_dir_sata->phy_id);
+#endif
+
+			port = NULL;
+			phy = NULL;
+
+			for (port_id = 0; port_id < asd->hw_profile.max_ports;
+			     port_id++) {
+
+				port = asd->port_list[port_id];
+
+				list_for_each_entry(phy,
+						    &port->phys_attached,
+						    links) {
+
+					if (phy->id ==
+					    punit_id_dir_sata->phy_id) {
+						break;
+					}
+				}
+			}
+
+			if (port_id != asd->hw_profile.max_ports) {
+				if (list_empty(&port->targets_to_validate)) {
+					target =
+					    list_entry(port->
+						       targets_to_validate.next,
+						       struct asd_target,
+						       all_domain_targets);
+
+					target->flags |= ASD_TARG_ONLINE;
+
+					list_del_init(&target->
+						      all_domain_targets);
+
+					list_add_tail(&target->
+						      all_domain_targets,
+						      &map_list);
+
+					target->flags |= ASD_TARG_MAP_BOOT;
+				} else {
+					printk("Warning: no devices on target "
+					       "list for phy %d\n", phy->id);
+				}
+			} else {
+				printk("Warning: could not find direct phy ID "
+				       "matching %d\n",
+				       punit_id_dir_sata->phy_id);
+			}
+			break;
+		case UNELEM_LU_NAA_WWN:
+			punit_id_lun = (struct asd_uid_lu_naa_wwn *)
+			    punit_elm->id;
+
+#if 0
+			printk("%s:%d: UNIT_ELEMENT_LOGICAL_UNIT %llx\n",
+			       __FUNCTION__, __LINE__,
+			       asd_be64toh(*((uint64_t *) punit_id_lun->
+					     sas_address)));
+#endif
+
+			target = NULL;
+
+			for (port_id = 0; port_id < asd->hw_profile.max_ports;
+			     port_id++) {
+
+				port = asd->port_list[port_id];
+
+				target =
+				    asd_find_target(&port->targets_to_validate,
+						    punit_id_lun->sas_address);
+
+				if (target != NULL) {
+					break;
+				}
+			}
+
+			if (target != NULL) {
+				target->flags |= ASD_TARG_ONLINE;
+
+				list_del_init(&target->all_domain_targets);
+
+				list_add_tail(&target->all_domain_targets,
+					      &map_list);
+
+				target->flags |= ASD_TARG_MAP_BOOT;
+			} else {
+				printk("Warning: Couldn't find "
+				       "UNIT_ELEMENT_LOGICAL_UNIT %llx\n",
+				       asd_be64toh(*((uint64_t *) punit_id_lun->
+						     sas_address)));
+			}
+
+			break;
+		case UNELEM_VOLUME_SET_DDF_GUID:
+			printk("%s:%d: UNIT_ELEMENT_VOLUME_SET\n",
+			       __FUNCTION__, __LINE__);
+			break;
+
+		case UNELEM_LU_SGPIO:
+			printk("%s:%d: UNELEM_LU_SGPIO\n",
+			       __FUNCTION__, __LINE__);
+			break;
+
+		case UNELEM_LU_SAS_TOPOLOGY:
+			printk("%s:%d: UNELEM_LU_SAS_TOPOLOGY\n",
+			       __FUNCTION__, __LINE__);
+			break;
+		}
+
+	}
+#endif
+
+	/*
+	 * Now go through the devices that are left and put them on our list
+	 * of potential devices to be exported to the OS.
+	 */
+	for (port_id = 0; port_id < asd->hw_profile.max_ports; port_id++) {
+
+		port = asd->port_list[port_id];
+
+		list_for_each_entry_safe(target, tmp_target,
+					 &port->targets_to_validate,
+					 all_domain_targets) {
+
+			target->flags |= ASD_TARG_ONLINE;
+
+			if (target->management_type == ASD_DEVICE_END) {
+				target->flags |= ASD_TARG_NEEDS_MAP;
+			}
+
+			list_del_init(&target->all_domain_targets);
+
+			list_add_tail(&target->all_domain_targets, &map_list);
+		}
+	}
+
+	asd_mark_duplicates(asd, &map_list);
+
+	list_for_each_entry_safe(target, tmp_target,
+				 &map_list, all_domain_targets) {
+
+		list_del_init(&target->all_domain_targets);
+
+		if ((target->flags & ASD_TARG_NEEDS_MAP) != 0) {
+
+			target->flags &= ~ASD_TARG_NEEDS_MAP;
+
+			if (asd_map_multipath(asd, target) != 0) {
+				// TODO: fix potential leak
+
+				continue;
+			}
+		}
+
+		list_add_tail(&target->all_domain_targets,
+			      &target->src_port->targets);
+	}
+
+	return;
+}
+
+static void
+asd_validate_targets_hotplug(struct asd_softc *asd,
+			     struct asd_port *port,
+			     struct asd_DiscoverySM_Context *ctx)
+{
+	struct asd_target *target;
+	struct asd_target *tmp_target;
+	struct asd_target *multipath_target;
+
+	INIT_LIST_HEAD(&port->targets_to_validate);
+
+	/*
+	 * Go through the old discover list and see if any devices that 
+	 * have been removed.  If this is our first time through the discovery
+	 * process, then there will be nothing on the old_discover_list.  The
+	 * old_discover_list has all of the devices that were seen in a
+	 * previous discover, but are no longer present.
+	 */
+	list_for_each_entry_safe(target, tmp_target,
+				 &ctx->old_discover_list, all_domain_targets) {
+
+		list_del_init(&target->all_domain_targets);
+
+		list_add_tail(&target->validate_links,
+			      &port->targets_to_validate);
+
+		/* 
+		 * The target was previously seen and now has gone missing.
+		 */
+		target->flags |= ASD_TARG_HOT_REMOVED;
+
+		multipath_target = asd_find_target_ident(&ctx->discover_list,
+							 target);
+
+		if (multipath_target != NULL) {
+
+			/*
+			 * If there were multiple paths to the same device,
+			 * then don't report this device as removed;
+			 */
+			asd_remap_device(asd, target, multipath_target);
+
+			continue;
+		}
+
+		multipath_target = asd_find_multipath(asd, target);
+
+		if (multipath_target != NULL) {
+
+			/*
+			 * If there were multiple paths to the same device,
+			 * then don't report this device as removed;
+			 */
+			asd_remap_device(asd, target, multipath_target);
+		}
+
+		if (!list_empty(&target->multipath)) {
+			multipath_target = list_entry(target->multipath.next,
+						      struct asd_target,
+						      multipath);
+
+			asd_remap_device(asd, target, multipath_target);
+
+			/*
+			 * This device wasn't in the target list because it
+			 * was a multipath.  Add it to the list.
+			 */
+			list_add_tail(&multipath_target->all_domain_targets,
+				      &multipath_target->src_port->targets);
+
+			target->flags &= ~ASD_TARG_MAPPED;
+		}
+	}
+
+	asd_mark_duplicates(asd, &ctx->discover_list);
+
+	list_for_each_entry_safe(target, tmp_target, &ctx->discover_list,
+				 all_domain_targets) {
+
+		if (((target->flags & ASD_TARG_ONLINE) == 0) &&
+		    (target->flags & ASD_TARG_RESEEN)) {
+
+			/*
+			 * Previously seen target.
+			 * Set target state to ONLINE.
+			 */
+			target->flags &= ~ASD_TARG_RESEEN;
+			target->flags |= ASD_TARG_ONLINE;
+
+			continue;
+		}
+
+		if ((target->flags & ASD_TARG_NEEDS_MAP) == 0) {
+			/*
+			 * If the device is not an end device, then
+			 * ASD_TARG_NEEDS_MAP will never be set.
+			 */
+			continue;
+		}
+
+		target->flags &= ~ASD_TARG_NEEDS_MAP;
+
+		if (asd_map_multipath(asd, target) == 0) {
+			/*
+			 * New target found.
+			 */
+			target->flags |= ASD_TARG_HOT_ADDED;
+
+			list_add_tail(&target->validate_links,
+				      &port->targets_to_validate);
+		} else {
+			/*
+			 * The target was not mapped.  It might have been
+			 * already mapped, so don't include it in our list
+			 * of new targets.
+			 */
+			list_del_init(&target->all_domain_targets);
+		}
+	}
+
+	INIT_LIST_HEAD(&ctx->old_discover_list);
+
+	/*
+	 * Set the flag that targets validation is required.
+	 */
+	port->events |= ASD_VALIDATION_REQ;
+}
+
+/* -------------------------------------------------------------------------- */
+
+#if DISCOVER_DEBUG
+void asd_debug_indent(unsigned indent)
+{
+	unsigned i;
+
+	for (i = 0; i < indent; i++) {
+		kdb_printf("|  ");
+	}
+}
+
+static void
+asd_dump_tree_internal(struct asd_softc *asd,
+		       struct asd_port *port,
+		       struct asd_target *target,
+		       unsigned indent, unsigned phy_num)
+{
+	struct Discover *discover;
+	struct asd_target *child_target;
+	unsigned i;
+
+	asd_debug_indent(indent);
+
+	kdb_printf("+ Phy %d:", phy_num);
+
+	kdb_printf(" Addr: %0llx - ",
+		   asd_be64toh(*((uint64_t *) target->ddb_profile.sas_addr)));
+
+	asd_print_conn_rate(target->ddb_profile.conn_rate, "|");
+
+	switch (target->command_set_type) {
+	case ASD_COMMAND_SET_SCSI:
+		kdb_printf("SCSI|");
+		break;
+	case ASD_COMMAND_SET_ATA:
+		kdb_printf("ATA|");
+		break;
+	case ASD_COMMAND_SET_ATAPI:
+		kdb_printf("ATAPI|");
+		break;
+	case ASD_COMMAND_SET_SMP:
+		kdb_printf("SMP|");
+		break;
+	default:
+		kdb_printf("Unknown (%u)|", (unsigned)target->command_set_type);
+		break;
+	}
+
+	switch (target->device_protocol_type) {
+	case ASD_DEVICE_PROTOCOL_SCSI:
+		kdb_printf("SCSI|");
+		break;
+	case ASD_DEVICE_PROTOCOL_ATA:
+		kdb_printf("ATA|");
+		break;
+	case ASD_DEVICE_PROTOCOL_SMP:
+		kdb_printf("SMP|");
+		break;
+	default:
+		kdb_printf("Unknown (%u)|",
+			   (unsigned)target->device_protocol_type);
+		break;
+	}
+
+	switch (target->transport_type) {
+	case ASD_TRANSPORT_SSP:
+		kdb_printf("SSP|");
+		break;
+	case ASD_TRANSPORT_SMP:
+		kdb_printf("SMP|");
+		break;
+	case ASD_TRANSPORT_STP:
+		kdb_printf("STP|");
+		break;
+	case ASD_TRANSPORT_ATA:
+		kdb_printf("ATA|");
+		break;
+	default:
+		kdb_printf("Unknown (%u)|", (unsigned)target->transport_type);
+		break;
+	}
+
+	switch (target->management_type) {
+	case ASD_DEVICE_END:
+		kdb_printf("END_DEVICE");
+		break;
+	case ASD_DEVICE_FANOUT_EXPANDER:
+		kdb_printf("FANOUT_DEVICE");
+		break;
+	case ASD_DEVICE_EDGE_EXPANDER:
+		kdb_printf("EXPANDER_DEVICE");
+		break;
+	default:
+		kdb_printf("Unknown (%u)", (unsigned)target->management_type);
+		break;
+	}
+
+	kdb_printf("\n");
+
+	if (target->transport_type != ASD_TRANSPORT_SMP) {
+		return;
+	}
+
+	asd_debug_indent(indent);
+
+	kdb_printf("| Number of Phys: %d\n", target->num_phys);
+
+	discover = NULL;
+
+	indent++;
+
+	list_for_each_entry(child_target, &target->children, siblings) {
+
+		for (i = 0; i < target->num_phys; i++) {
+
+			discover = &(target->Phy[i].Result);
+
+			if (SAS_ISEQUAL(child_target->ddb_profile.sas_addr,
+					discover->AttachedSASAddress)) {
+				break;
+			}
+		}
+
+		if (i == target->num_phys) {
+			continue;
+		}
+
+		asd_dump_tree_internal(asd, port, child_target, indent, i);
+	}
+}
+
+static void asd_dump_tree(struct asd_softc *asd, struct asd_port *port)
+{
+	struct asd_target *target;
+	struct state_information *state_infop;
+
+	SETUP_STATE(&port->dc.sm_context);
+
+	kdb_printf("port %p: current_state 0x%x\n", port,
+		   state_infop->current_state);
+
+	if (!list_empty(&port->targets)) {
+
+		target = port->tree_root;
+
+		asd_dump_tree_internal(asd, port, target, 1, 0);
+	}
+}
+#endif
+
+#if KDB_ENABLE
+#if DISCOVER_DEBUG
+extern struct list_head asd_hbas;
+
+void asd_dump_sas_state(void
+    )
+{
+	unsigned i;
+	struct asd_softc *asd;
+
+	printk("%s:%d --\n", __FUNCTION__, __LINE__);
+
+	list_for_each_entry(asd, &asd_hbas, link) {
+		for (i = 0; i < asd->hw_profile.max_ports; i++) {
+			if (asd->port_list[i] != NULL) {
+				asd_dump_tree(asd, asd->port_list[i]);
+			}
+		}
+	}
+}
+
+void asd_kdb_init(void
+    )
+{
+	kdb_register("sas", (void *)asd_dump_sas_state, "",
+		     "Dumps the SAS state", 0);
+}
+
+void asd_kdb_exit(void
+    )
+{
+	kdb_unregister("sas");
+}
+#endif
+#endif



