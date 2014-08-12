From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH V4 3/4] Introduce XEN scsiback module
Date: Tue, 12 Aug 2014 14:13:42 -0700
Message-ID: <1407878022.27925.33.camel@haakon3.risingtidesystems.com>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>
	 <1407484194-31876-4-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50932 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaHLVNx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Aug 2014 17:13:53 -0400
In-Reply-To: <1407484194-31876-4-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com
Cc: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com, JBeulich@suse.com

Hi Juergen & Co,

Finally had a chance to review this code.  Comments are inline below..

On Fri, 2014-08-08 at 09:49 +0200, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> Introduces the XEN pvSCSI backend. With pvSCSI it is possible for a XEN domU
> to issue SCSI commands to a SCSI LUN assigned to that domU. The SCSI commands
> are passed to the pvSCSI backend in a driver domain (usually Dom0) which is
> owner of the physical device. This allows e.g. to use SCSI tape drives in a
> XEN domU.
> 
> The code is taken from the pvSCSI implementation in XEN done by Fujitsu based
> on Linux kernel 2.6.18.
> 
> Changes from the original version are:
> - port to upstream kernel
> - put all code in just one source file
> - adapt to Linux style guide
> - use target core infrastructure instead doing pure pass-through
> - enable module unloading
> - support SG-list in grant page(s)
> - support task abort
> - remove redundant struct backend
> - allocate resources dynamically
> - correct minor error in scsiback_fast_flush_area
> - free allocated resources in case of error during I/O preparation
> - remove CDB emulation, now handled by target core infrastructure
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> 
> Xen related parts
> Acked-by: David Vrabel <david.vrabel@citrix.com>
> ---

<SNIP>

> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> new file mode 100644
> index 0000000..4a0d6e3
> --- /dev/null
> +++ b/drivers/xen/xen-scsiback.c

<SNIP>

> +struct scsiback_nacl {
> +	/* Binary World Wide unique Port Name for pvscsi Initiator port */
> +	u64 iport_wwpn;
> +	/* ASCII formatted WWPN for Sas Initiator port */
> +	char iport_name[VSCSI_NAMELEN];
> +	/* Returned by scsiback_make_nodeacl() */
> +	struct se_node_acl se_node_acl;
> +};
> +

Given that this code is similar to how loopback + vhost-scsi function,
and uses a (locally) generated nexus for each WWPN endpoint, the
scsiback_nacl and associated code will be unused should be be dropped.

<SNIP>

> +static void scsiback_do_resp_with_sense(char *sense_buffer, int32_t result,
> +			uint32_t resid, struct vscsibk_pend *pending_req)
> +{
> +	struct vscsiif_response *ring_res;
> +	struct vscsibk_info *info = pending_req->info;
> +	int notify;
> +	struct scsi_sense_hdr sshdr;
> +	unsigned long flags;
> +	unsigned len;
> +
> +	spin_lock_irqsave(&info->ring_lock, flags);
> +
> +	ring_res = RING_GET_RESPONSE(&info->ring, info->ring.rsp_prod_pvt);
> +	info->ring.rsp_prod_pvt++;
> +
> +	ring_res->rslt   = result;
> +	ring_res->rqid   = pending_req->rqid;
> +
> +	if (sense_buffer != NULL &&
> +	    scsi_normalize_sense(sense_buffer, VSCSIIF_SENSE_BUFFERSIZE,
> +				 &sshdr)) {
> +		len = min_t(unsigned, 8 + sense_buffer[7],
> +			    VSCSIIF_SENSE_BUFFERSIZE);
> +		memcpy(ring_res->sense_buffer, sense_buffer, len);
> +		ring_res->sense_len = len;
> +	} else {
> +		ring_res->sense_len = 0;
> +	}
> +
> +	ring_res->residual_len = resid;
> +
> +	RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(&info->ring, notify);
> +	spin_unlock_irqrestore(&info->ring_lock, flags);
> +
> +	if (notify)
> +		notify_remote_via_irq(info->irq);
> +
> +	if (pending_req->v2p)
> +		kref_put(&pending_req->v2p->kref,
> +			 scsiback_free_translation_entry);
> +
> +	kmem_cache_free(scsiback_cachep, pending_req);
> +}
> +
> +static void scsiback_cmd_done(struct vscsibk_pend *pending_req)
> +{
> +	struct vscsibk_info *info = pending_req->info;
> +	unsigned char *sense_buffer;
> +	unsigned int resid;
> +	int errors;
> +
> +	sense_buffer = pending_req->sense_buffer;
> +	resid        = pending_req->se_cmd.residual_count;
> +	errors       = pending_req->result;
> +
> +	if (errors && log_print_stat)
> +		scsiback_print_status(sense_buffer, errors, pending_req);
> +
> +	scsiback_fast_flush_area(pending_req);
> +	scsiback_do_resp_with_sense(sense_buffer, errors, resid, pending_req);
> +	scsiback_put(info);
> +
> +	transport_generic_free_cmd(&pending_req->se_cmd, 0);
> +}
> +

The usage here of scsiback_do_resp_with_sense() -> kmem_cache_free() for
*pending_req, and then invoking transport_generic_free_cmd() with
&pending_req->se_cmd is an free after use bug..

So the way this should work is similar to how loopback currently does
things:

  - Move the kmem_cache_free() for pending_req from 
    scsiback_do_resp_with_sense() to scsiback_release_cmd()
  - Remove the transport_generic_free_cmd() from scsiback_cmd_done()
  - Copy what tcm_loop_check_stop_free() does into 
    scsiback_check_stop_free(), and remove target_put_sess_cmd()

> +static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
> +{
> +	struct se_cmd *se_cmd = &pending_req->se_cmd;
> +	struct se_session *sess = pending_req->v2p->tpg->tpg_nexus->tvn_se_sess;
> +	int rc;
> +
> +	memset(pending_req->sense_buffer, 0, VSCSIIF_SENSE_BUFFERSIZE);
> +
> +	memset(se_cmd, 0, sizeof(*se_cmd));
> +	se_cmd->prot_pto = true;
> +

No need to set prot_pto = true, as T10_PI support is not enabled..

> +	scsiback_get(pending_req->info);
> +	rc = target_submit_cmd_map_sgls(se_cmd, sess, pending_req->cmnd,
> +			pending_req->sense_buffer, pending_req->v2p->lun,
> +			pending_req->data_len, 0,
> +			pending_req->sc_data_direction, 0,
> +			pending_req->sgl, pending_req->n_sg,
> +			NULL, 0, NULL, 0);
> +	if (rc < 0) {
> +		transport_send_check_condition_and_sense(se_cmd,
> +				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
> +		transport_generic_free_cmd(se_cmd, 0);
> +	}
> +}
> +

<SNIP>

> +
> +static void scsiback_device_action(struct vscsibk_pend *pending_req,
> +	enum tcm_tmreq_table act, int tag)
> +{
> +	int rc, err = FAILED;
> +	struct scsiback_tpg *tpg = pending_req->v2p->tpg;
> +	struct se_cmd *se_cmd = &pending_req->se_cmd;
> +	struct scsiback_tmr *tmr;
> +
> +	tmr = kzalloc(sizeof(struct scsiback_tmr), GFP_KERNEL);
> +	if (!tmr) {
> +		pr_err("xen-pvscsi: %s: kmalloc() error\n", __func__);
> +		goto out;
> +	}
> +	init_waitqueue_head(&tmr->tmr_wait);
> +
> +	transport_init_se_cmd(se_cmd, tpg->se_tpg.se_tpg_tfo,
> +		tpg->tpg_nexus->tvn_se_sess, 0, DMA_NONE, MSG_SIMPLE_TAG,
> +		&pending_req->sense_buffer[0]);
> +
> +	rc = core_tmr_alloc_req(se_cmd, tmr, act, GFP_KERNEL);
> +	if (rc < 0)
> +		goto out;
> +
> +	se_cmd->se_tmr_req->ref_task_tag = tag;
> +
> +	if (transport_lookup_tmr_lun(se_cmd, pending_req->v2p->lun) < 0)
> +		goto out;
> +
> +	transport_generic_handle_tmr(se_cmd);
> +	wait_event(tmr->tmr_wait, atomic_read(&tmr->tmr_complete));
> +
> +	err = (se_cmd->se_tmr_req->response == TMR_FUNCTION_COMPLETE) ?
> +		SUCCESS : FAILED;
> +
> +out:
> +	if (tmr) {
> +		transport_generic_free_cmd(&pending_req->se_cmd, 1);
> +		kfree(tmr);
> +	}
> +
> +	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
> +}

With scsiback_do_resp_with_sense() no longer freeing pending_req
directly, this special case will need a kmem_cache_free()

> +static int _scsiback_do_cmd_fn(struct vscsibk_info *info)
> +{
> +	struct vscsiif_back_ring *ring = &info->ring;
> +	struct vscsiif_request *ring_req;
> +	struct vscsibk_pend *pending_req;
> +	RING_IDX rc, rp;
> +	int err, more_to_do = 0;
> +	uint32_t result;
> +	uint8_t act;
> +
> +	rc = ring->req_cons;
> +	rp = ring->sring->req_prod;
> +	rmb();	/* guest system is accessing ring, too */
> +
> +	if (RING_REQUEST_PROD_OVERFLOW(ring, rp)) {
> +		rc = ring->rsp_prod_pvt;
> +		pr_warn("xen-pvscsi: Dom%d provided bogus ring requests (%#x - %#x = %u). Halting ring processing\n",
> +			   info->domid, rp, rc, rp - rc);
> +		return -EACCES;
> +	}
> +
> +	while ((rc != rp)) {
> +		if (RING_REQUEST_CONS_OVERFLOW(ring, rc))
> +			break;
> +		pending_req = kmem_cache_alloc(scsiback_cachep, GFP_KERNEL);
> +		if (NULL == pending_req) {
> +			more_to_do = 1;
> +			break;
> +		}
> +

Ideally this will end up using percpu_ida descriptor pre-allocation via
se_sess->sess_tag_poll + se_sess->sess_cmd_map in order to avoid the
fast-path memory allocation.

See commit 4824d3bfb909 for an example of how this was done for
vhost-scsi, but should be considered a post-merge optimization..

> +		ring_req = RING_GET_REQUEST(ring, rc);
> +		ring->req_cons = ++rc;
> +
> +		act = ring_req->act;
> +		err = prepare_pending_reqs(info, ring_req, pending_req);
> +		if (err) {
> +			switch (err) {
> +			case -ENODEV:
> +				result = DID_NO_CONNECT;
> +				break;
> +			default:
> +				result = DRIVER_ERROR;
> +				break;
> +			}
> +			scsiback_do_resp_with_sense(NULL, result << 24, 0,
> +						    pending_req);
> +			more_to_do = 1;
> +			break;
> +		}
> +
> +		switch (act) {
> +		case VSCSIIF_ACT_SCSI_CDB:
> +			if (scsiback_gnttab_data_map(ring_req, pending_req)) {
> +				scsiback_fast_flush_area(pending_req);
> +				scsiback_do_resp_with_sense(NULL,
> +					DRIVER_ERROR << 24, 0, pending_req);

Another special case for scsiback_do_resp_with_sense() that with the
recommended changes require a kmem_cache_free() call.

> +			} else {
> +				scsiback_cmd_exec(pending_req);
> +			}
> +			break;
> +		case VSCSIIF_ACT_SCSI_ABORT:
> +			scsiback_device_action(pending_req, TMR_ABORT_TASK,
> +				ring_req->ref_rqid);
> +			break;
> +		case VSCSIIF_ACT_SCSI_RESET:
> +			scsiback_device_action(pending_req, TMR_LUN_RESET, 0);
> +			break;
> +		default:
> +			pr_err_ratelimited("xen-pvscsi: invalid request\n");
> +			scsiback_do_resp_with_sense(NULL, DRIVER_ERROR << 24,
> +						    0, pending_req);

Ditto here.

> +			break;
> +		}
> +
> +		/* Yield point for this unbounded loop. */
> +		cond_resched();
> +	}
> +
> +	if (RING_HAS_UNCONSUMED_REQUESTS(ring))
> +		more_to_do = 1;
> +
> +	return more_to_do;
> +}
> +

<SNIP>

> +static struct se_node_acl *
> +scsiback_alloc_fabric_acl(struct se_portal_group *se_tpg)
> +{
> +	struct scsiback_nacl *nacl;
> +
> +	nacl = kzalloc(sizeof(struct scsiback_nacl), GFP_KERNEL);
> +	if (!nacl) {
> +		pr_err("Unable to allocate struct scsiback_nacl\n");
> +		return NULL;
> +	}
> +
> +	return &nacl->se_node_acl;
> +}
> +
> +static void
> +scsiback_release_fabric_acl(struct se_portal_group *se_tpg,
> +			     struct se_node_acl *se_nacl)
> +{
> +	struct scsiback_nacl *nacl = container_of(se_nacl,
> +			struct scsiback_nacl, se_node_acl);
> +	kfree(nacl);
> +}
> +
> +static u32 scsiback_tpg_get_inst_index(struct se_portal_group *se_tpg)
> +{
> +	return 1;
> +}
> +
> +static struct se_node_acl *
> +scsiback_make_nodeacl(struct se_portal_group *se_tpg,
> +		       struct config_group *group,
> +		       const char *name)
> +{
> +	struct se_node_acl *se_nacl, *se_nacl_new;
> +	struct scsiback_nacl *nacl;
> +	u64 wwpn = 0;
> +	u32 nexus_depth;
> +
> +	se_nacl_new = scsiback_alloc_fabric_acl(se_tpg);
> +	if (!se_nacl_new)
> +		return ERR_PTR(-ENOMEM);
> +
> +	nexus_depth = 1;
> +	/*
> +	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
> +	 * when converting a NodeACL from demo mode -> explict
> +	 */
> +	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
> +				name, nexus_depth);
> +	if (IS_ERR(se_nacl)) {
> +		scsiback_release_fabric_acl(se_tpg, se_nacl_new);
> +		return se_nacl;
> +	}
> +	/*
> +	 * Locate our struct scsiback_nacl and set the FC Nport WWPN
> +	 */
> +	nacl = container_of(se_nacl, struct scsiback_nacl, se_node_acl);
> +	nacl->iport_wwpn = wwpn;
> +
> +	return se_nacl;
> +}
> +
> +static void scsiback_drop_nodeacl(struct se_node_acl *se_acl)
> +{
> +	struct scsiback_nacl *nacl = container_of(se_acl,
> +				struct scsiback_nacl, se_node_acl);
> +	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
> +	kfree(nacl);
> +}
> +

As mentioned above, the NodeACL use is unnecessary for this driver so
you can safely drop scsiback_make_node_acl() +
scsiback_alloc_fabric_acl() + scsiback_drop_nodeacl() +
scsiback_release_fabric_acl().

> +static int scsiback_check_stop_free(struct se_cmd *se_cmd)
> +{
> +	return target_put_sess_cmd(se_cmd->se_sess, se_cmd);
> +}
> +

As mentioned above, scsiback_check_stop_free() should follow what
tcm_loop_check_stop_free() does here..

> +static void scsiback_release_cmd(struct se_cmd *se_cmd)
> +{
> +}
> +

Move the kmem_cache_free() for pending_req here..

> +static int scsiback_shutdown_session(struct se_session *se_sess)
> +{
> +	return 0;
> +}
> +
> +static void scsiback_close_session(struct se_session *se_sess)
> +{
> +}
> +
> +static u32 scsiback_sess_get_index(struct se_session *se_sess)
> +{
> +	return 0;
> +}
> +
> +static int scsiback_write_pending(struct se_cmd *se_cmd)
> +{
> +	/* Go ahead and process the write immediately */
> +	target_execute_cmd(se_cmd);
> +
> +	return 0;
> +}
> +
> +static int scsiback_write_pending_status(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +
> +static void scsiback_set_default_node_attrs(struct se_node_acl *nacl)
> +{
> +}
> +

Safe to drop this no-op too.

> +static u32 scsiback_get_task_tag(struct se_cmd *se_cmd)
> +{
> +	struct vscsibk_pend *pending_req = container_of(se_cmd,
> +				struct vscsibk_pend, se_cmd);
> +
> +	return pending_req->rqid;
> +}
> +
> +static int scsiback_get_cmd_state(struct se_cmd *se_cmd)
> +{
> +	return 0;
> +}
> +
> +static int scsiback_queue_data_in(struct se_cmd *se_cmd)
> +{
> +	struct vscsibk_pend *pending_req = container_of(se_cmd,
> +				struct vscsibk_pend, se_cmd);
> +
> +	pending_req->result = SAM_STAT_GOOD;
> +	scsiback_cmd_done(pending_req);
> +	return 0;
> +}
> +
> +static int scsiback_queue_status(struct se_cmd *se_cmd)
> +{
> +	struct vscsibk_pend *pending_req = container_of(se_cmd,
> +				struct vscsibk_pend, se_cmd);
> +
> +	if (se_cmd->sense_buffer &&
> +	    ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
> +	     (se_cmd->se_cmd_flags & SCF_EMULATED_TASK_SENSE)))
> +		pending_req->result = (DRIVER_SENSE << 24) |
> +				      SAM_STAT_CHECK_CONDITION;
> +	else
> +		pending_req->result = se_cmd->scsi_status;
> +
> +	scsiback_cmd_done(pending_req);
> +	return 0;
> +}
> +
> +static void scsiback_queue_tm_rsp(struct se_cmd *se_cmd)
> +{
> +	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
> +	struct scsiback_tmr *tmr = se_tmr->fabric_tmr_ptr;
> +
> +	atomic_set(&tmr->tmr_complete, 1);
> +	wake_up(&tmr->tmr_wait);
> +}
> +
> +static void scsiback_aborted_task(struct se_cmd *se_cmd)
> +{
> +	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
> +	struct scsiback_tmr *tmr = se_tmr->fabric_tmr_ptr;
> +
> +	atomic_set(&tmr->tmr_complete, 1);
> +	wake_up(&tmr->tmr_wait);
> +}
> +

scsiback_aborted_task() should just return here, instead of the
atomic_set + wake_up().  Eg: ABORT_TASK is already calling ->
queue_tm_rsp(), and the ->aborted_task() callback is specifically for
cleaning up any fabric specific descriptor resources, before
->release_cmd() gets called.

> +static ssize_t scsiback_tpg_param_show_alias(struct se_portal_group *se_tpg,
> +					     char *page)
> +{
> +	struct scsiback_tpg *tpg = container_of(se_tpg, struct scsiback_tpg,
> +						se_tpg);
> +	ssize_t rb;
> +
> +	mutex_lock(&tpg->tv_tpg_mutex);
> +	rb = snprintf(page, PAGE_SIZE, "%s\n", tpg->param_alias);
> +	mutex_unlock(&tpg->tv_tpg_mutex);
> +
> +	return rb;
> +}
> +
> +static ssize_t scsiback_tpg_param_store_alias(struct se_portal_group *se_tpg,
> +					      const char *page, size_t count)
> +{
> +	struct scsiback_tpg *tpg = container_of(se_tpg, struct scsiback_tpg,
> +						se_tpg);
> +	int len;
> +
> +	if (strlen(page) >= VSCSI_NAMELEN) {
> +		pr_err("param alias: %s, exceeds max: %d\n", page,
> +			VSCSI_NAMELEN);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&tpg->tv_tpg_mutex);
> +	len = snprintf(tpg->param_alias, VSCSI_NAMELEN, "%s", page);
> +	if (tpg->param_alias[len - 1] == '\n')
> +		tpg->param_alias[len - 1] = '\0';
> +	mutex_unlock(&tpg->tv_tpg_mutex);
> +
> +	return count;
> +}
> +
> +TF_TPG_PARAM_ATTR(scsiback, alias, S_IRUGO | S_IWUSR);
> +
> +static struct configfs_attribute *scsiback_param_attrs[] = {
> +	&scsiback_tpg_param_alias.attr,
> +	NULL,
> +};
> +
> +static int scsiback_make_nexus(struct scsiback_tpg *tpg,
> +				const char *name)
> +{
> +	struct se_portal_group *se_tpg;
> +	struct se_session *se_sess;
> +	struct scsiback_nexus *tv_nexus;
> +
> +	mutex_lock(&tpg->tv_tpg_mutex);
> +	if (tpg->tpg_nexus) {
> +		mutex_unlock(&tpg->tv_tpg_mutex);
> +		pr_debug("tpg->tpg_nexus already exists\n");
> +		return -EEXIST;
> +	}
> +	se_tpg = &tpg->se_tpg;
> +
> +	tv_nexus = kzalloc(sizeof(struct scsiback_nexus), GFP_KERNEL);
> +	if (!tv_nexus) {
> +		mutex_unlock(&tpg->tv_tpg_mutex);
> +		pr_err("Unable to allocate struct scsiback_nexus\n");
> +		return -ENOMEM;
> +	}
> +	/*
> +	 *  Initialize the struct se_session pointer
> +	 */
> +	tv_nexus->tvn_se_sess = transport_init_session(TARGET_PROT_DIN_PASS |
> +						       TARGET_PROT_DOUT_PASS);

TARGET_PROT_D*_PASS incorrectly declares T10 PI support here, which
should be TARGET_PROT_NORMAL instead.

> +	if (IS_ERR(tv_nexus->tvn_se_sess)) {
> +		mutex_unlock(&tpg->tv_tpg_mutex);
> +		kfree(tv_nexus);
> +		return -ENOMEM;
> +	}
> +	se_sess = tv_nexus->tvn_se_sess;
> +	/*
> +	 * Since we are running in 'demo mode' this call with generate a
> +	 * struct se_node_acl for the scsiback struct se_portal_group with
> +	 * the SCSI Initiator port name of the passed configfs group 'name'.
> +	 */
> +	tv_nexus->tvn_se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
> +				se_tpg, (unsigned char *)name);
> +	if (!tv_nexus->tvn_se_sess->se_node_acl) {
> +		mutex_unlock(&tpg->tv_tpg_mutex);
> +		pr_debug("core_tpg_check_initiator_node_acl() failed for %s\n",
> +			 name);
> +		goto out;
> +	}
> +	/*
> +	 * Now register the TCM pvscsi virtual I_T Nexus as active with the
> +	 * call to __transport_register_session()
> +	 */
> +	__transport_register_session(se_tpg, tv_nexus->tvn_se_sess->se_node_acl,
> +			tv_nexus->tvn_se_sess, tv_nexus);
> +	tpg->tpg_nexus = tv_nexus;
> +
> +	mutex_unlock(&tpg->tv_tpg_mutex);
> +	return 0;
> +
> +out:
> +	transport_free_session(se_sess);
> +	kfree(tv_nexus);
> +	return -ENOMEM;
> +}
> +

<SNIP>

> +
> +static int scsiback_port_link(struct se_portal_group *se_tpg,
> +			       struct se_lun *lun)
> +{
> +	struct scsiback_tpg *tpg = container_of(se_tpg,
> +				struct scsiback_tpg, se_tpg);
> +
> +	mutex_lock(&scsiback_mutex);
> +
> +	mutex_lock(&tpg->tv_tpg_mutex);
> +	tpg->tv_tpg_port_count++;
> +	mutex_unlock(&tpg->tv_tpg_mutex);
> +
> +	mutex_unlock(&scsiback_mutex);
> +
> +	return 0;
> +}
> +

AFAICT, no need to hold scsiback_mutex while incrementing
tpg->tv_tpg_port_count.

> +static void scsiback_port_unlink(struct se_portal_group *se_tpg,
> +				  struct se_lun *lun)
> +{
> +	struct scsiback_tpg *tpg = container_of(se_tpg,
> +				struct scsiback_tpg, se_tpg);
> +
> +	mutex_lock(&scsiback_mutex);
> +
> +	mutex_lock(&tpg->tv_tpg_mutex);
> +	tpg->tv_tpg_port_count--;
> +	mutex_unlock(&tpg->tv_tpg_mutex);
> +
> +	mutex_unlock(&scsiback_mutex);
> +}
> +

Ditto here.

