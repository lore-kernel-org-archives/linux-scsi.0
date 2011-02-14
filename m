From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 10:36:24 +0900
Message-ID: <20110214103408I.fujita.tomonori@lab.ntt.co.jp>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1297364591.18212.172.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38157 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab1BNBg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Feb 2011 20:36:29 -0500
In-Reply-To: <1297364591.18212.172.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Thu, 10 Feb 2011 11:03:11 -0800
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> > +#define	INITIAL_SRP_LIMIT	16
> > +#define	DEFAULT_MAX_SECTORS	256
> > +
> 
> Ok, these two hardcoded defs can  be converted into context specific
> fabric dependent configfs attributes (TF_CIT_TMPL(fabric)->tfc_* below)
> using target_core_fabric_configfs.h wrappers..

I think that these values are used when you load the driver. No chance
to configure them via configfs.


> > +static char *ibmvscsis_parse_pr_out_transport_id(struct se_portal_group *se_tpg,
> > +						 const char *buf,
> > +						 u32 *out_tid_len,
> > +						 char **port_nexus_ptr)
> > +{
> > +	return NULL;
> > +}
> > +
> 
> OK, I still need to add generic SCSI_PROTOCOL_SRP handlers for PR
> TransportID processing, and get up and running with TCM_Loop SRP target
> ports.  I will look at getting this resolved in LIO upstream in the near
> future, and make sure this gets converted..

I don't care much.

FYI, ibmvscsis initiators don't share a target device. So PR is
pointless in reality.



> > +static int ibmvscsis_queue_tm_rsp(struct se_cmd *se_cmd)
> > +{
> > +	return 0;
> > +}
> > +
> 
> The TM request/response logic still needs to be hooked up, right..?

Yeah, I'll add soon.


> > +	case 0x08: /* Cache page */
> > +		/* length should be 4 */
> > +#if 0
> > +		if (cmd->cdb[4] != 4
> > +		    && cmd->cdb[4] != 0x20) {
> > +			send_rsp(iue, ILLEGAL_REQUEST, 0x20);
> > +			dma_free_coherent(iue->adapter->dev,
> > +					  MODE_SENSE_BUFFER_SIZE,
> > +					  mode, data_token);
> > +			return FREE_IU;
> > +		}
> > +#endif
> > +
> 
> Can this be dropped..?

Yeah, I had better to add the proper error handling though.


> > +static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
> > +{
> > +	struct ibmvscsis_cmnd *cmd = container_of(se_cmd,
> > +			struct ibmvscsis_cmnd, se_cmd);
> > +	struct scsi_cmnd *sc = &cmd->sc;
> > +	/*
> > +	 * Check for overflow residual count
> > +	 */
> > +	if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
> > +		scsi_set_resid(sc, se_cmd->residual_count);
> > +
> > +	sc->sdb.length = se_cmd->data_length;
> > +
> > +	/*
> > +	 * Setup the struct se_task->task_sg[] chained SG list
> > +	 */
> > +	if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
> > +	    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
> > +		transport_do_task_sg_chain(se_cmd);
> > +
> > +		sc->sdb.table.nents = T_TASK(se_cmd)->t_tasks_sg_chained_no;
> > +		sc->sdb.table.sgl = T_TASK(se_cmd)->t_tasks_sg_chained;
> > +	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
> > +		/*
> > +		 * Use T_TASK(se_cmd)->t_tasks_sg_bounce for control CDBs
> > +		 * using a contigious buffer
> > +		 */
> > +		sg_init_table(&T_TASK(se_cmd)->t_tasks_sg_bounce, 1);
> > +		sg_set_buf(&T_TASK(se_cmd)->t_tasks_sg_bounce,
> > +			T_TASK(se_cmd)->t_task_buf, se_cmd->data_length);
> > +
> > +		sc->sdb.table.nents = 1;
> > +		sc->sdb.table.sgl = &T_TASK(se_cmd)->t_tasks_sg_bounce;
> > +	}
> > +	/*
> > +	 * Perform the SCSI READ data transfer from sc->sdb.table into
> > +	 * VIO LPAR memory.  This will occur via libsrp in the
> > +	 * ibmvscsis_rdma() callback
> > +	 */
> > +#if 0
> > +	ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd,
> > +				ibmvscsis_rdma, 1, 1);
> > +	if (ret) {
> > +		printk(KERN_ERR "srp_transfer_data() failed: %d, returning"
> > +				" DID_ERROR\n", ret);
> > +		sc->result = host_byte(DID_ERROR) | se_cmd->scsi_status;
> > +	} else
> > +		sc->result = host_byte(DID_OK) | se_cmd->scsi_status;
> > +#endif
> 
> Mmmm, is this really supposed to be disabled..?

ibmvscsis_cmd_done calls srp_transfer_data(). I should remove the
above.


> > +	/*
> > +	 * This will call srp_transfer_data() and post the response
> > +	 * to VIO via libsrp.
> > +	 */
> > +	ibmvscsis_cmd_done(sc);
> > +	return 0;
> > +}
> > +


> > +	case REPORT_LUNS:
> > +		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
> > +		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
> > +		sc->sdb.length = ibmvscsis_report_luns(adapter, cmd,
> > +						       page_address(pg));
> > +		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
> > +		ibmvscsis_cmd_done(sc);
> > +		sg_free_table(&sc->sdb.table);
> > +		__free_page(pg);
> > +		kfree(vsc);
> > +		break;
> > +	case MODE_SENSE:
> > +		/* fixme: needs to use tcm */
> > +		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
> > +		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
> > +		sc->sdb.length = ibmvscsis_mode_sense(adapter,
> > +						      cmd, page_address(pg));
> > +		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
> > +		ibmvscsis_cmd_done(sc);
> > +		sg_free_table(&sc->sdb.table);
> > +		__free_page(pg);
> > +		kfree(vsc);
> > +		break;
> 
> Just to verify again, INQUIRY and REPORT_LUNS are the only CDBs that
> have a hard requirement of being intercepted in order for VSCSI to
> function, right..?

tcm MODE_SENSE needed to be modified slightly to handle
ibmvscsis. It's a todo item.

