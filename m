From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 05/11] iscsi-target: Refactor RX PDU logic + export
 request PDU handling
Date: Fri, 22 Mar 2013 16:09:33 -0700
Message-ID: <1363993773.30339.48.camel@haakon2.linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
	 <1362707116-31406-6-git-send-email-nab@linux-iscsi.org>
	 <514C939B.9010102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38882 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423404Ab3CVXJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Mar 2013 19:09:36 -0400
In-Reply-To: <514C939B.9010102@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On Fri, 2013-03-22 at 10:23 -0700, Andy Grover wrote:
> On 03/07/2013 05:45 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch refactors existing traditional iscsi RX side PDU handling
> > to use iscsit_transport, and exports the necessary logic for external
> > transport modules.
> >
> > This includes:
> >
> > - Refactor iscsit_handle_scsi_cmd() into PDU setup / processing
> > - Add updated iscsit_handle_scsi_cmd() for tradtional iscsi code
> > - Add iscsit_set_unsoliticed_dataout() wrapper
> > - Refactor iscsit_handle_data_out() into PDU check / processing
> > - Add updated iscsit_handle_data_out() for tradtional iscsi code
> > - Add iscsit_handle_nop_out() + iscsit_handle_task_mgt_cmd() to
> >    accept pre-allocated struct iscsi_cmd
> > - Add iscsit_build_r2ts_for_cmd() RDMAExtentions check to
> >    post ISTATE_SEND_R2T to TX immediate queue to start RDMA READ
> > - Refactor main traditional iscsi iscsi_target_rx_thread() PDU switch
> >    into iscsi_target_rx_opcode() using iscsit_allocate_cmd()
> > - Turn iscsi_target_rx_thread() process context into NOP for
> >    ib_isert side work-queue.
> >
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/iscsi/iscsi_target.c      |  463 +++++++++++++++++++-----------
> >   drivers/target/iscsi/iscsi_target.h      |    1 +
> >   drivers/target/iscsi/iscsi_target_erl1.c |    8 +-
> >   drivers/target/iscsi/iscsi_target_util.c |    1 +
> >   4 files changed, 295 insertions(+), 178 deletions(-)
> >
> > diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> > index 9cd7b7b..fbdc75a 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -703,6 +703,7 @@ int iscsit_add_reject_from_cmd(
> >
> >   	return (!fail_conn) ? 0 : -1;
> >   }
> > +EXPORT_SYMBOL(iscsit_add_reject_from_cmd);
> >
> >   /*
> >    * Map some portion of the allocated scatterlist to an iovec, suitable for
> > @@ -793,12 +794,10 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
> >   	return 0;
> >   }
> >
> > -static int iscsit_handle_scsi_cmd(
> > -	struct iscsi_conn *conn,
> > -	unsigned char *buf)
> > +int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
> > +			  unsigned char *buf)
> >   {
> > -	int data_direction, payload_length, cmdsn_ret = 0, immed_ret;
> > -	struct iscsi_cmd *cmd = NULL;
> > +	int data_direction, payload_length;
> >   	struct iscsi_scsi_req *hdr;
> >   	int iscsi_task_attr;
> >   	int sam_task_attr;
> > @@ -821,8 +820,8 @@ static int iscsit_handle_scsi_cmd(
> >   	    !(hdr->flags & ISCSI_FLAG_CMD_FINAL)) {
> >   		pr_err("ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL"
> >   				" not set. Bad iSCSI Initiator.\n");
> > -		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
> > -				buf, conn);
> > +		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
> > +				1, 1, buf, cmd);
> 
> Add #defines to give more meaning to these "1" parameters?
> 

These should all become bool.  Changing these in this particular patch
is going to be messy, so i'd prefer this done in a separate patch.

<SNIP>

> > @@ -1065,21 +1067,33 @@ attach_cmd:
> >   	 * thread.  They are processed in CmdSN order by
> >   	 * iscsit_check_received_cmdsn() below.
> >   	 */
> > -	if (cmd->sense_reason) {
> > -		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
> > -		goto after_immediate_data;
> > -	}
> > +	if (cmd->sense_reason)
> > +		return 1;
> >   	/*
> >   	 * Call directly into transport_generic_new_cmd() to perform
> >   	 * the backend memory allocation.
> >   	 */
> >   	cmd->sense_reason = transport_generic_new_cmd(&cmd->se_cmd);
> > -	if (cmd->sense_reason) {
> > -		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
> > +	if (cmd->sense_reason)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(iscsit_process_scsi_cmd);
> 
> Unneeded? not used outside iscsi_target.c afact.
> 

It's used by isert_core.c:isert_handle_scsi_cmd() for iscsi_cmd
submission.

<SNIP>

> > +int iscsit_handle_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
> > +			   unsigned char *buf)
> > +{
> > +	struct iscsi_scsi_req *hdr = (struct iscsi_scsi_req *)buf;
> > +	int rc, immed_data;
> > +	bool dump_payload = false;
> > +
> > +	rc = iscsit_setup_scsi_cmd(conn, cmd, buf);
> > +	if (rc < 0)
> > +		return rc;
> > +	/*
> > +	 * Allocation iovecs needed for struct socket operations for
> > +	 * traditional iSCSI block I/O.
> > +	 */
> > +	if (iscsit_allocate_iovecs(cmd) < 0) {
> > +		return iscsit_add_reject_from_cmd(
> > +				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
> > +				1, 0, buf, cmd);
> > +	}
> > +	immed_data = cmd->immediate_data;
> > +
> > +	rc = iscsit_process_scsi_cmd(conn, cmd, hdr);
> > +	if (rc < 0)
> > +		return rc;
> > +	else if (rc > 0)
> > +		dump_payload = true;
> 
> iscsit_process_scsi_cmd() returning 1 is debugging code?
> 

No, this is to signal to when to dump the immediate data payload
(dump_payload = true).

However, dump_payload was not being passed correct to
iscsit_get_immediate_data(), so fixing that now with the following.

Thanks,

--nab

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 4a79a6c..cc0ecba 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1184,7 +1184,7 @@ int iscsit_handle_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
        if (!immed_data)
                return 0;
 
-       return iscsit_get_immediate_data(cmd, hdr, cmd->first_burst_len);
+       return iscsit_get_immediate_data(cmd, hdr, dump_payload);
 }

