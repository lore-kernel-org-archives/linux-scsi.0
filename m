From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 01:01:12 -0800
Message-ID: <1297674072.7114.46.camel@haakon2.linux-iscsi.org>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1297364591.18212.172.camel@haakon2.linux-iscsi.org>
	 <20110214122649N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51567 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1BNJHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 04:07:43 -0500
In-Reply-To: <20110214122649N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Mon, 2011-02-14 at 12:26 +0900, FUJITA Tomonori wrote:
> On Thu, 10 Feb 2011 11:03:11 -0800
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > > +static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
> > > +{
> > > +	struct ibmvscsis_cmnd *cmd = container_of(se_cmd,
> > > +			struct ibmvscsis_cmnd, se_cmd);
> > > +	struct scsi_cmnd *sc = &cmd->sc;
> > > +	/*
> > > +	 * Check for overflow residual count
> > > +	 */
> > > +	if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
> > > +		scsi_set_resid(sc, se_cmd->residual_count);
> > > +
> > > +	sc->sdb.length = se_cmd->data_length;
> > > +
> > > +	/*
> > > +	 * Setup the struct se_task->task_sg[] chained SG list
> > > +	 */
> > > +	if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
> > > +	    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
> > > +		transport_do_task_sg_chain(se_cmd);
> > > +
> > > +		sc->sdb.table.nents = T_TASK(se_cmd)->t_tasks_sg_chained_no;
> > > +		sc->sdb.table.sgl = T_TASK(se_cmd)->t_tasks_sg_chained;
> > > +	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
> > > +		/*
> > > +		 * Use T_TASK(se_cmd)->t_tasks_sg_bounce for control CDBs
> > > +		 * using a contigious buffer
> > > +		 */
> > > +		sg_init_table(&T_TASK(se_cmd)->t_tasks_sg_bounce, 1);
> > > +		sg_set_buf(&T_TASK(se_cmd)->t_tasks_sg_bounce,
> > > +			T_TASK(se_cmd)->t_task_buf, se_cmd->data_length);
> > > +
> > > +		sc->sdb.table.nents = 1;
> > > +		sc->sdb.table.sgl = &T_TASK(se_cmd)->t_tasks_sg_bounce;
> > > +	}
> > > +	/*
> > > +	 * Perform the SCSI READ data transfer from sc->sdb.table into
> > > +	 * VIO LPAR memory.  This will occur via libsrp in the
> > > +	 * ibmvscsis_rdma() callback
> 
> btw, can we kill the non scatter/gather data path? I think that we
> should always use the scatter/gather data transfer.

Unfortuately it's not that easy.  The main reason why CDB type
SCF_SCSI_CONTROL_NONSG_IO_CDB was originally added (back in 2.2/2.4
days) was because certain LLDs had a problem with basic control CDBs
using SGLs..

Obviously we are way past that point with drivers/scsi today, but the
main reason today why SCF_SCSI_CONTROL_NONSG_IO_CDB still exists is
because of CDB emulation for complex stuff in target_core_cdb.c.  It has
historically proven much easier to code complex CDB emulation using a
contigious buffer, than with walking SGL formatted memory.

Converting over the more complex CDB emulation stuff to SGLs would
somewhat painful, at least without adding an extra location allocation +
copy into SGLs (not a big deal for CONTROL CDB stuff), or something else
to obtain a virtually contigious buffer for building the emulated
response.

--nab


