From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 12:26:49 +0900
Message-ID: <20110214122649N.fujita.tomonori@lab.ntt.co.jp>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1297364591.18212.172.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:52748 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1BND0x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Feb 2011 22:26:53 -0500
In-Reply-To: <1297364591.18212.172.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Thu, 10 Feb 2011 11:03:11 -0800
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

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

btw, can we kill the non scatter/gather data path? I think that we
should always use the scatter/gather data transfer.
