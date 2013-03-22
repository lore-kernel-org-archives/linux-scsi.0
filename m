From: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 05/11] iscsi-target: Refactor RX PDU logic + export request
 PDU handling
Date: Fri, 22 Mar 2013 10:23:39 -0700
Message-ID: <514C939B.9010102@redhat.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org> <1362707116-31406-6-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362707116-31406-6-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexander Nezhinsky <alexandern-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 03/07/2013 05:45 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
>
> This patch refactors existing traditional iscsi RX side PDU handling
> to use iscsit_transport, and exports the necessary logic for external
> transport modules.
>
> This includes:
>
> - Refactor iscsit_handle_scsi_cmd() into PDU setup / processing
> - Add updated iscsit_handle_scsi_cmd() for tradtional iscsi code
> - Add iscsit_set_unsoliticed_dataout() wrapper
> - Refactor iscsit_handle_data_out() into PDU check / processing
> - Add updated iscsit_handle_data_out() for tradtional iscsi code
> - Add iscsit_handle_nop_out() + iscsit_handle_task_mgt_cmd() to
>    accept pre-allocated struct iscsi_cmd
> - Add iscsit_build_r2ts_for_cmd() RDMAExtentions check to
>    post ISTATE_SEND_R2T to TX immediate queue to start RDMA READ
> - Refactor main traditional iscsi iscsi_target_rx_thread() PDU switch
>    into iscsi_target_rx_opcode() using iscsit_allocate_cmd()
> - Turn iscsi_target_rx_thread() process context into NOP for
>    ib_isert side work-queue.
>
> Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> ---
>   drivers/target/iscsi/iscsi_target.c      |  463 +++++++++++++++++++-----------
>   drivers/target/iscsi/iscsi_target.h      |    1 +
>   drivers/target/iscsi/iscsi_target_erl1.c |    8 +-
>   drivers/target/iscsi/iscsi_target_util.c |    1 +
>   4 files changed, 295 insertions(+), 178 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 9cd7b7b..fbdc75a 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -703,6 +703,7 @@ int iscsit_add_reject_from_cmd(
>
>   	return (!fail_conn) ? 0 : -1;
>   }
> +EXPORT_SYMBOL(iscsit_add_reject_from_cmd);
>
>   /*
>    * Map some portion of the allocated scatterlist to an iovec, suitable for
> @@ -793,12 +794,10 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
>   	return 0;
>   }
>
> -static int iscsit_handle_scsi_cmd(
> -	struct iscsi_conn *conn,
> -	unsigned char *buf)
> +int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
> +			  unsigned char *buf)
>   {
> -	int data_direction, payload_length, cmdsn_ret = 0, immed_ret;
> -	struct iscsi_cmd *cmd = NULL;
> +	int data_direction, payload_length;
>   	struct iscsi_scsi_req *hdr;
>   	int iscsi_task_attr;
>   	int sam_task_attr;
> @@ -821,8 +820,8 @@ static int iscsit_handle_scsi_cmd(
>   	    !(hdr->flags & ISCSI_FLAG_CMD_FINAL)) {
>   		pr_err("ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL"
>   				" not set. Bad iSCSI Initiator.\n");
> -		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
> -				buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
> +				1, 1, buf, cmd);

Add #defines to give more meaning to these "1" parameters?

>   	}
>
>   	if (((hdr->flags & ISCSI_FLAG_CMD_READ) ||
> @@ -842,8 +841,8 @@ static int iscsit_handle_scsi_cmd(
>   		pr_err("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
>   			" set when Expected Data Transfer Length is 0 for"
>   			" CDB: 0x%02x. Bad iSCSI Initiator.\n", hdr->cdb[0]);
> -		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
> -				buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
> +				1, 1, buf, cmd);
>   	}
>   done:
>
> @@ -852,29 +851,29 @@ done:
>   		pr_err("ISCSI_FLAG_CMD_READ and/or ISCSI_FLAG_CMD_WRITE"
>   			" MUST be set if Expected Data Transfer Length is not 0."
>   			" Bad iSCSI Initiator\n");
> -		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
> -				buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
> +				1, 1, buf, cmd);
>   	}
>
>   	if ((hdr->flags & ISCSI_FLAG_CMD_READ) &&
>   	    (hdr->flags & ISCSI_FLAG_CMD_WRITE)) {
>   		pr_err("Bidirectional operations not supported!\n");
> -		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
> -				buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
> +				1, 1, buf, cmd);
>   	}
>
>   	if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
>   		pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>   				" Scsi Command PDU.\n");
> -		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
> -				buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
> +				1, 1, buf, cmd);
>   	}
>
>   	if (payload_length && !conn->sess->sess_ops->ImmediateData) {
>   		pr_err("ImmediateData=No but DataSegmentLength=%u,"
>   			" protocol error.\n", payload_length);
> -		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
> -				buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
> +				1, 1, buf, cmd);
>   	}
>
>   	if ((be32_to_cpu(hdr->data_length )== payload_length) &&
> @@ -882,43 +881,38 @@ done:
>   		pr_err("Expected Data Transfer Length and Length of"
>   			" Immediate Data are the same, but ISCSI_FLAG_CMD_FINAL"
>   			" bit is not set protocol error\n");
> -		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
> -				buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
> +				1, 1, buf, cmd);
>   	}
>
>   	if (payload_length > be32_to_cpu(hdr->data_length)) {
>   		pr_err("DataSegmentLength: %u is greater than"
>   			" EDTL: %u, protocol error.\n", payload_length,
>   				hdr->data_length);
> -		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
> -				buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
> +				1, 1, buf, cmd);
>   	}
>
>   	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
>   		pr_err("DataSegmentLength: %u is greater than"
>   			" MaxXmitDataSegmentLength: %u, protocol error.\n",
>   			payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
> -		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
> -				buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
> +				1, 1, buf, cmd);
>   	}
>
>   	if (payload_length > conn->sess->sess_ops->FirstBurstLength) {
>   		pr_err("DataSegmentLength: %u is greater than"
>   			" FirstBurstLength: %u, protocol error.\n",
>   			payload_length, conn->sess->sess_ops->FirstBurstLength);
> -		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
> -					buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
> +				1, 1, buf, cmd);
>   	}
>
>   	data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :
>   			 (hdr->flags & ISCSI_FLAG_CMD_READ) ? DMA_FROM_DEVICE :
>   			  DMA_NONE;
>
> -	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
> -	if (!cmd)
> -		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
> -					 buf, conn);
> -
>   	cmd->data_direction = data_direction;
>   	iscsi_task_attr = hdr->flags & ISCSI_FLAG_CMD_ATTR_MASK;
>   	/*
> @@ -983,7 +977,8 @@ done:
>
>   	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
>   		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
> -		hdr->cmdsn, hdr->data_length, payload_length, conn->cid);
> +		hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
> +		conn->cid);
>
>   	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
>   						     scsilun_to_int(&hdr->lun));
> @@ -1017,12 +1012,24 @@ attach_cmd:
>   	 */
>   	core_alua_check_nonop_delay(&cmd->se_cmd);
>
> -	if (iscsit_allocate_iovecs(cmd) < 0) {
> -		return iscsit_add_reject_from_cmd(
> -				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
> -				1, 0, buf, cmd);
> -	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(iscsit_setup_scsi_cmd);
>
> +void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *cmd)
> +{
> +	iscsit_set_dataout_sequence_values(cmd);
> +
> +	spin_lock_bh(&cmd->dataout_timeout_lock);
> +	iscsit_start_dataout_timer(cmd, cmd->conn);
> +	spin_unlock_bh(&cmd->dataout_timeout_lock);
> +}
> +EXPORT_SYMBOL(iscsit_set_unsoliticed_dataout);
> +
> +int iscsit_process_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
> +			    struct iscsi_scsi_req *hdr)
> +{
> +	int cmdsn_ret = 0;
>   	/*
>   	 * Check the CmdSN against ExpCmdSN/MaxCmdSN here if
>   	 * the Immediate Bit is not set, and no Immediate
> @@ -1040,7 +1047,7 @@ attach_cmd:
>   		else if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
>   			return iscsit_add_reject_from_cmd(
>   				ISCSI_REASON_PROTOCOL_ERROR,
> -				1, 0, buf, cmd);
> +				1, 0, (unsigned char *)hdr, cmd);
>   	}
>
>   	iscsit_ack_from_expstatsn(conn, be32_to_cpu(hdr->exp_statsn));
> @@ -1049,13 +1056,8 @@ attach_cmd:
>   	 * If no Immediate Data is attached, it's OK to return now.
>   	 */
>   	if (!cmd->immediate_data) {
> -		if (!cmd->sense_reason && cmd->unsolicited_data) {
> -			iscsit_set_dataout_sequence_values(cmd);
> -
> -			spin_lock_bh(&cmd->dataout_timeout_lock);
> -			iscsit_start_dataout_timer(cmd, cmd->conn);
> -			spin_unlock_bh(&cmd->dataout_timeout_lock);
> -		}
> +		if (!cmd->sense_reason && cmd->unsolicited_data)
> +			iscsit_set_unsoliticed_dataout(cmd);
>
>   		return 0;
>   	}
> @@ -1065,21 +1067,33 @@ attach_cmd:
>   	 * thread.  They are processed in CmdSN order by
>   	 * iscsit_check_received_cmdsn() below.
>   	 */
> -	if (cmd->sense_reason) {
> -		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
> -		goto after_immediate_data;
> -	}
> +	if (cmd->sense_reason)
> +		return 1;
>   	/*
>   	 * Call directly into transport_generic_new_cmd() to perform
>   	 * the backend memory allocation.
>   	 */
>   	cmd->sense_reason = transport_generic_new_cmd(&cmd->se_cmd);
> -	if (cmd->sense_reason) {
> -		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
> +	if (cmd->sense_reason)
> +		return 1;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(iscsit_process_scsi_cmd);

Unneeded? not used outside iscsi_target.c afact.

> +
> +static int
> +iscsit_get_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
> +			  bool dump_payload)
> +{
> +	int cmdsn_ret = 0, immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
> +	/*
> +	 * Special case for Unsupported SAM WRITE Opcodes and ImmediateData=Yes.
> +	 */
> +	if (dump_payload == true)
>   		goto after_immediate_data;
> -	}
>
> -	immed_ret = iscsit_handle_immediate_data(cmd, buf, payload_length);
> +	immed_ret = iscsit_handle_immediate_data(cmd, hdr,
> +					cmd->first_burst_len);
>   after_immediate_data:
>   	if (immed_ret == IMMEDIATE_DATA_NORMAL_OPERATION) {
>   		/*
> @@ -1087,26 +1101,19 @@ after_immediate_data:
>   		 * DataCRC, check against ExpCmdSN/MaxCmdSN if
>   		 * Immediate Bit is not set.
>   		 */
> -		cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
> -		/*
> -		 * Special case for Unsupported SAM WRITE Opcodes
> -		 * and ImmediateData=Yes.
> -		 */
> +		cmdsn_ret = iscsit_sequence_cmd(cmd->conn, cmd, hdr->cmdsn);
> +
>   		if (cmd->sense_reason) {
> -			if (iscsit_dump_data_payload(conn, payload_length, 1) < 0)
> +			if (iscsit_dump_data_payload(cmd->conn,
> +					cmd->first_burst_len, 1) < 0)
>   				return -1;
> -		} else if (cmd->unsolicited_data) {
> -			iscsit_set_dataout_sequence_values(cmd);
> -
> -			spin_lock_bh(&cmd->dataout_timeout_lock);
> -			iscsit_start_dataout_timer(cmd, cmd->conn);
> -			spin_unlock_bh(&cmd->dataout_timeout_lock);
> -		}
> +		} else if (cmd->unsolicited_data)
> +			iscsit_set_unsoliticed_dataout(cmd);
>
>   		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
>   			return iscsit_add_reject_from_cmd(
>   				ISCSI_REASON_PROTOCOL_ERROR,
> -				1, 0, buf, cmd);
> +				1, 0, (unsigned char *)hdr, cmd);
>
>   	} else if (immed_ret == IMMEDIATE_DATA_ERL1_CRC_FAILURE) {
>   		/*
> @@ -1121,13 +1128,46 @@ after_immediate_data:
>   		 * CmdSN and issue a retry to plug the sequence.
>   		 */
>   		cmd->i_state = ISTATE_REMOVE;
> -		iscsit_add_cmd_to_immediate_queue(cmd, conn, cmd->i_state);
> +		iscsit_add_cmd_to_immediate_queue(cmd, cmd->conn, cmd->i_state);
>   	} else /* immed_ret == IMMEDIATE_DATA_CANNOT_RECOVER */
>   		return -1;
>
>   	return 0;
>   }
>
> +int iscsit_handle_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
> +			   unsigned char *buf)
> +{
> +	struct iscsi_scsi_req *hdr = (struct iscsi_scsi_req *)buf;
> +	int rc, immed_data;
> +	bool dump_payload = false;
> +
> +	rc = iscsit_setup_scsi_cmd(conn, cmd, buf);
> +	if (rc < 0)
> +		return rc;
> +	/*
> +	 * Allocation iovecs needed for struct socket operations for
> +	 * traditional iSCSI block I/O.
> +	 */
> +	if (iscsit_allocate_iovecs(cmd) < 0) {
> +		return iscsit_add_reject_from_cmd(
> +				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
> +				1, 0, buf, cmd);
> +	}
> +	immed_data = cmd->immediate_data;
> +
> +	rc = iscsit_process_scsi_cmd(conn, cmd, hdr);
> +	if (rc < 0)
> +		return rc;
> +	else if (rc > 0)
> +		dump_payload = true;

iscsit_process_scsi_cmd() returning 1 is debugging code?

-- Andy

> +
> +	if (!immed_data)
> +		return 0;
> +
> +	return iscsit_get_immediate_data(cmd, hdr, cmd->first_burst_len);
> +}
> +
>   static u32 iscsit_do_crypto_hash_sg(
>   	struct hash_desc *hash,
>   	struct iscsi_cmd *cmd,
> @@ -1190,20 +1230,16 @@ static void iscsit_do_crypto_hash_buf(
>   	crypto_hash_final(hash, data_crc);
>   }
>
> -static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
> +int
> +iscsit_check_dataout_hdr(struct iscsi_conn *conn, unsigned char *buf,
> +			  struct iscsi_cmd **out_cmd)
>   {
> -	int iov_ret, ooo_cmdsn = 0, ret;
> -	u8 data_crc_failed = 0;
> -	u32 checksum, iov_count = 0, padding = 0, rx_got = 0;
> -	u32 rx_size = 0, payload_length;
> +	struct iscsi_data *hdr = (struct iscsi_data *)buf;
>   	struct iscsi_cmd *cmd = NULL;
>   	struct se_cmd *se_cmd;
> -	struct iscsi_data *hdr;
> -	struct kvec *iov;
>   	unsigned long flags;
> -
> -	hdr			= (struct iscsi_data *) buf;
> -	payload_length		= ntoh24(hdr->dlength);
> +	u32 payload_length = ntoh24(hdr->dlength);
> +	int rc;
>
>   	if (!payload_length) {
>   		pr_err("DataOUT payload is ZERO, protocol error.\n");
> @@ -1236,7 +1272,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
>
>   	pr_debug("Got DataOut ITT: 0x%08x, TTT: 0x%08x,"
>   		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
> -		hdr->itt, hdr->ttt, hdr->datasn, hdr->offset,
> +		hdr->itt, hdr->ttt, hdr->datasn, ntohl(hdr->offset),
>   		payload_length, conn->cid);
>
>   	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
> @@ -1328,12 +1364,26 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
>   	 * Preform DataSN, DataSequenceInOrder, DataPDUInOrder, and
>   	 * within-command recovery checks before receiving the payload.
>   	 */
> -	ret = iscsit_check_pre_dataout(cmd, buf);
> -	if (ret == DATAOUT_WITHIN_COMMAND_RECOVERY)
> +	rc = iscsit_check_pre_dataout(cmd, buf);
> +	if (rc == DATAOUT_WITHIN_COMMAND_RECOVERY)
>   		return 0;
> -	else if (ret == DATAOUT_CANNOT_RECOVER)
> +	else if (rc == DATAOUT_CANNOT_RECOVER)
>   		return -1;
>
> +	*out_cmd = cmd;
> +	return 0;
> +}
> +EXPORT_SYMBOL(iscsit_check_dataout_hdr);
> +
> +static int
> +iscsit_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
> +		   struct iscsi_data *hdr)
> +{
> +	struct kvec *iov;
> +	u32 checksum, iov_count = 0, padding = 0, rx_got = 0, rx_size = 0;
> +	u32 payload_length = ntoh24(hdr->dlength);
> +	int iov_ret, data_crc_failed = 0;
> +
>   	rx_size += payload_length;
>   	iov = &cmd->iov_data[0];
>
> @@ -1386,17 +1436,27 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
>   				payload_length);
>   		}
>   	}
> +
> +	return data_crc_failed;
> +}
> +
> +int
> +iscsit_check_dataout_payload(struct iscsi_cmd *cmd, struct iscsi_data *hdr,
> +			     bool data_crc_failed)
> +{
> +	struct iscsi_conn *conn = cmd->conn;
> +	int rc, ooo_cmdsn;
>   	/*
>   	 * Increment post receive data and CRC values or perform
>   	 * within-command recovery.
>   	 */
> -	ret = iscsit_check_post_dataout(cmd, buf, data_crc_failed);
> -	if ((ret == DATAOUT_NORMAL) || (ret == DATAOUT_WITHIN_COMMAND_RECOVERY))
> +	rc = iscsit_check_post_dataout(cmd, (unsigned char *)hdr, data_crc_failed);
> +	if ((rc == DATAOUT_NORMAL) || (rc == DATAOUT_WITHIN_COMMAND_RECOVERY))
>   		return 0;
> -	else if (ret == DATAOUT_SEND_R2T) {
> +	else if (rc == DATAOUT_SEND_R2T) {
>   		iscsit_set_dataout_sequence_values(cmd);
>   		iscsit_build_r2ts_for_cmd(cmd, conn, false);
> -	} else if (ret == DATAOUT_SEND_TO_TRANSPORT) {
> +	} else if (rc == DATAOUT_SEND_TO_TRANSPORT) {
>   		/*
>   		 * Handle extra special case for out of order
>   		 * Unsolicited Data Out.
> @@ -1417,15 +1477,37 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
>
>   	return 0;
>   }
> +EXPORT_SYMBOL(iscsit_check_dataout_payload);
>
> -static int iscsit_handle_nop_out(
> -	struct iscsi_conn *conn,
> -	unsigned char *buf)
> +static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
> +{
> +	struct iscsi_cmd *cmd;
> +	struct iscsi_data *hdr = (struct iscsi_data *)buf;
> +	int rc;
> +	bool data_crc_failed = false;
> +
> +	rc = iscsit_check_dataout_hdr(conn, buf, &cmd);
> +	if (rc < 0)
> +		return rc;
> +	else if (!cmd)
> +		return 0;
> +
> +	rc = iscsit_get_dataout(conn, cmd, hdr);
> +	if (rc < 0)
> +		return rc;
> +	else if (rc > 0)
> +		data_crc_failed = true;
> +
> +	return iscsit_check_dataout_payload(cmd, hdr, data_crc_failed);
> +}
> +
> +int iscsit_handle_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
> +			unsigned char *buf)
>   {
>   	unsigned char *ping_data = NULL;
>   	int cmdsn_ret, niov = 0, ret = 0, rx_got, rx_size;
>   	u32 checksum, data_crc, padding = 0, payload_length;
> -	struct iscsi_cmd *cmd = NULL;
> +	struct iscsi_cmd *cmd_p = NULL;
>   	struct kvec *iov = NULL;
>   	struct iscsi_nopout *hdr;
>
> @@ -1448,7 +1530,7 @@ static int iscsit_handle_nop_out(
>   					buf, conn);
>   	}
>
> -	pr_debug("Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%09x,"
> +	pr_debug("Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%08x,"
>   		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
>   		hdr->itt == RESERVED_ITT ? "Response" : "Request",
>   		hdr->itt, hdr->ttt, hdr->cmdsn, hdr->exp_statsn,
> @@ -1461,7 +1543,6 @@ static int iscsit_handle_nop_out(
>   	 * can contain ping data.
>   	 */
>   	if (hdr->ttt == cpu_to_be32(0xFFFFFFFF)) {
> -		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
>   		if (!cmd)
>   			return iscsit_add_reject(
>   					ISCSI_REASON_BOOKMARK_NO_RESOURCES,
> @@ -1596,14 +1677,14 @@ static int iscsit_handle_nop_out(
>   		/*
>   		 * This was a response to a unsolicited NOPIN ping.
>   		 */
> -		cmd = iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt));
> -		if (!cmd)
> +		cmd_p = iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt));
> +		if (!cmd_p)
>   			return -1;
>
>   		iscsit_stop_nopin_response_timer(conn);
>
> -		cmd->i_state = ISTATE_REMOVE;
> -		iscsit_add_cmd_to_immediate_queue(cmd, conn, cmd->i_state);
> +		cmd_p->i_state = ISTATE_REMOVE;
> +		iscsit_add_cmd_to_immediate_queue(cmd_p, conn, cmd_p->i_state);
>   		iscsit_start_nopin_timer(conn);
>   	} else {
>   		/*
> @@ -1627,12 +1708,12 @@ ping_out:
>   	kfree(ping_data);
>   	return ret;
>   }
> +EXPORT_SYMBOL(iscsit_handle_nop_out);
>
> -static int iscsit_handle_task_mgt_cmd(
> -	struct iscsi_conn *conn,
> -	unsigned char *buf)
> +int
> +iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
> +			   unsigned char *buf)
>   {
> -	struct iscsi_cmd *cmd;
>   	struct se_tmr_req *se_tmr;
>   	struct iscsi_tmr_req *tmr_req;
>   	struct iscsi_tm *hdr;
> @@ -1661,18 +1742,13 @@ static int iscsit_handle_task_mgt_cmd(
>   		pr_err("Task Management Request TASK_REASSIGN not"
>   			" issued as immediate command, bad iSCSI Initiator"
>   				"implementation\n");
> -		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
> -					buf, conn);
> +		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
> +					1, 1, buf, cmd);
>   	}
>   	if ((function != ISCSI_TM_FUNC_ABORT_TASK) &&
>   	    be32_to_cpu(hdr->refcmdsn) != ISCSI_RESERVED_TAG)
>   		hdr->refcmdsn = cpu_to_be32(ISCSI_RESERVED_TAG);
>
> -	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
> -	if (!cmd)
> -		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
> -					 1, buf, conn);
> -
>   	cmd->data_direction = DMA_NONE;
>
>   	cmd->tmr_req = kzalloc(sizeof(struct iscsi_tmr_req), GFP_KERNEL);
> @@ -1843,6 +1919,7 @@ attach:
>   	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
>   	return 0;
>   }
> +EXPORT_SYMBOL(iscsit_handle_task_mgt_cmd);
>
>   /* #warning FIXME: Support Text Command parameters besides SendTargets */
>   static int iscsit_handle_text_cmd(
> @@ -2105,13 +2182,12 @@ int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *cmd, struct iscsi_conn
>   	return 0;
>   }
>
> -static int iscsit_handle_logout_cmd(
> -	struct iscsi_conn *conn,
> -	unsigned char *buf)
> +int
> +iscsit_handle_logout_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
> +			unsigned char *buf)
>   {
>   	int cmdsn_ret, logout_remove = 0;
>   	u8 reason_code = 0;
> -	struct iscsi_cmd *cmd;
>   	struct iscsi_logout *hdr;
>   	struct iscsi_tiqn *tiqn = iscsit_snmp_get_tiqn(conn);
>
> @@ -2135,14 +2211,10 @@ static int iscsit_handle_logout_cmd(
>   	if (conn->conn_state != TARG_CONN_STATE_LOGGED_IN) {
>   		pr_err("Received logout request on connection that"
>   			" is not in logged in state, ignoring request.\n");
> +		iscsit_release_cmd(cmd);
>   		return 0;
>   	}
>
> -	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
> -	if (!cmd)
> -		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
> -					buf, conn);
> -
>   	cmd->iscsi_opcode       = ISCSI_OP_LOGOUT;
>   	cmd->i_state            = ISTATE_SEND_LOGOUTRSP;
>   	cmd->immediate_cmd      = ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 : 0);
> @@ -2192,6 +2264,7 @@ static int iscsit_handle_logout_cmd(
>
>   	return logout_remove;
>   }
> +EXPORT_SYMBOL(iscsit_handle_logout_cmd);
>
>   static int iscsit_handle_snack(
>   	struct iscsi_conn *conn,
> @@ -2259,7 +2332,7 @@ static void iscsit_rx_thread_wait_for_tcp(struct iscsi_conn *conn)
>
>   static int iscsit_handle_immediate_data(
>   	struct iscsi_cmd *cmd,
> -	unsigned char *buf,
> +	struct iscsi_scsi_req *hdr,
>   	u32 length)
>   {
>   	int iov_ret, rx_got = 0, rx_size = 0;
> @@ -2315,12 +2388,12 @@ static int iscsit_handle_immediate_data(
>   					" in ERL=0.\n");
>   				iscsit_add_reject_from_cmd(
>   						ISCSI_REASON_DATA_DIGEST_ERROR,
> -						1, 0, buf, cmd);
> +						1, 0, (unsigned char *)hdr, cmd);
>   				return IMMEDIATE_DATA_CANNOT_RECOVER;
>   			} else {
>   				iscsit_add_reject_from_cmd(
>   						ISCSI_REASON_DATA_DIGEST_ERROR,
> -						0, 0, buf, cmd);
> +						0, 0, (unsigned char *)hdr, cmd);
>   				return IMMEDIATE_DATA_ERL1_CRC_FAILURE;
>   			}
>   		} else {
> @@ -2962,6 +3035,12 @@ int iscsit_build_r2ts_for_cmd(
>   	int first_r2t = 1;
>   	u32 offset = 0, xfer_len = 0;
>
> +	if (conn->sess->sess_ops->RDMAExtentions) {
> +		iscsit_stop_dataout_timer(cmd);
> +		iscsit_add_cmd_to_immediate_queue(cmd, conn, ISTATE_SEND_R2T);
> +		return 0;
> +	}
> +
>   	spin_lock_bh(&cmd->r2t_lock);
>   	if (cmd->cmd_flags & ICF_SENT_LAST_R2T) {
>   		spin_unlock_bh(&cmd->r2t_lock);
> @@ -3751,6 +3830,83 @@ out:
>   	return 0;
>   }
>
> +static int iscsi_target_rx_opcode(struct iscsi_conn *conn, unsigned char *buf)
> +{
> +	struct iscsi_hdr *hdr = (struct iscsi_hdr *)buf;
> +	struct iscsi_cmd *cmd;
> +	int ret = 0;
> +
> +	switch (hdr->opcode & ISCSI_OPCODE_MASK) {
> +	case ISCSI_OP_SCSI_CMD:
> +		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
> +		if (!cmd)
> +			return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
> +						1, buf, conn);
> +
> +		ret = iscsit_handle_scsi_cmd(conn, cmd, buf);
> +		break;
> +	case ISCSI_OP_SCSI_DATA_OUT:
> +		ret = iscsit_handle_data_out(conn, buf);
> +		break;
> +	case ISCSI_OP_NOOP_OUT:
> +		cmd = NULL;
> +		if (hdr->ttt == cpu_to_be32(0xFFFFFFFF)) {
> +			cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
> +			if (!cmd)
> +				return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
> +						1, buf, conn);
> +		}
> +		ret = iscsit_handle_nop_out(conn, cmd, buf);
> +		break;
> +	case ISCSI_OP_SCSI_TMFUNC:
> +		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
> +		if (!cmd)
> +			return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
> +						1, buf, conn);
> +
> +		ret = iscsit_handle_task_mgt_cmd(conn, cmd, buf);
> +		break;
> +	case ISCSI_OP_TEXT:
> +		ret = iscsit_handle_text_cmd(conn, buf);
> +		break;
> +	case ISCSI_OP_LOGOUT:
> +		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
> +		if (!cmd)
> +			return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
> +						1, buf, conn);
> +
> +		ret = iscsit_handle_logout_cmd(conn, cmd, buf);
> +		if (ret > 0)
> +			wait_for_completion_timeout(&conn->conn_logout_comp,
> +					SECONDS_FOR_LOGOUT_COMP * HZ);
> +		break;
> +	case ISCSI_OP_SNACK:
> +		ret = iscsit_handle_snack(conn, buf);
> +		break;
> +	default:
> +		pr_err("Got unknown iSCSI OpCode: 0x%02x\n", hdr->opcode);
> +		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
> +			pr_err("Cannot recover from unknown"
> +			" opcode while ERL=0, closing iSCSI connection.\n");
> +			return -1;
> +		}
> +		if (!conn->conn_ops->OFMarker) {
> +			pr_err("Unable to recover from unknown"
> +			" opcode while OFMarker=No, closing iSCSI"
> +				" connection.\n");
> +			return -1;
> +		}
> +		if (iscsit_recover_from_unknown_opcode(conn) < 0) {
> +			pr_err("Unable to recover from unknown"
> +				" opcode, closing iSCSI connection.\n");
> +			return -1;
> +		}
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>   int iscsi_target_rx_thread(void *arg)
>   {
>   	int ret;
> @@ -3770,6 +3926,18 @@ restart:
>   	if (!conn)
>   		goto out;
>
> +	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND) {
> +		struct completion comp;
> +		int rc;
> +
> +		init_completion(&comp);
> +		rc = wait_for_completion_interruptible(&comp);
> +		if (rc < 0)
> +			goto transport_err;
> +
> +		goto out;
> +	}
> +
>   	while (!kthread_should_stop()) {
>   		/*
>   		 * Ensure that both TX and RX per connection kthreads
> @@ -3841,62 +4009,9 @@ restart:
>   			goto transport_err;
>   		}
>
> -		switch (opcode) {
> -		case ISCSI_OP_SCSI_CMD:
> -			if (iscsit_handle_scsi_cmd(conn, buffer) < 0)
> -				goto transport_err;
> -			break;
> -		case ISCSI_OP_SCSI_DATA_OUT:
> -			if (iscsit_handle_data_out(conn, buffer) < 0)
> -				goto transport_err;
> -			break;
> -		case ISCSI_OP_NOOP_OUT:
> -			if (iscsit_handle_nop_out(conn, buffer) < 0)
> -				goto transport_err;
> -			break;
> -		case ISCSI_OP_SCSI_TMFUNC:
> -			if (iscsit_handle_task_mgt_cmd(conn, buffer) < 0)
> -				goto transport_err;
> -			break;
> -		case ISCSI_OP_TEXT:
> -			if (iscsit_handle_text_cmd(conn, buffer) < 0)
> -				goto transport_err;
> -			break;
> -		case ISCSI_OP_LOGOUT:
> -			ret = iscsit_handle_logout_cmd(conn, buffer);
> -			if (ret > 0) {
> -				wait_for_completion_timeout(&conn->conn_logout_comp,
> -						SECONDS_FOR_LOGOUT_COMP * HZ);
> -				goto transport_err;
> -			} else if (ret < 0)
> -				goto transport_err;
> -			break;
> -		case ISCSI_OP_SNACK:
> -			if (iscsit_handle_snack(conn, buffer) < 0)
> -				goto transport_err;
> -			break;
> -		default:
> -			pr_err("Got unknown iSCSI OpCode: 0x%02x\n",
> -					opcode);
> -			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
> -				pr_err("Cannot recover from unknown"
> -				" opcode while ERL=0, closing iSCSI connection"
> -				".\n");
> -				goto transport_err;
> -			}
> -			if (!conn->conn_ops->OFMarker) {
> -				pr_err("Unable to recover from unknown"
> -				" opcode while OFMarker=No, closing iSCSI"
> -					" connection.\n");
> -				goto transport_err;
> -			}
> -			if (iscsit_recover_from_unknown_opcode(conn) < 0) {
> -				pr_err("Unable to recover from unknown"
> -					" opcode, closing iSCSI connection.\n");
> -				goto transport_err;
> -			}
> -			break;
> -		}
> +		ret = iscsi_target_rx_opcode(conn, buffer);
> +		if (ret < 0)
> +			goto transport_err;
>   	}
>
>   transport_err:
> diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
> index b1a1e63..97c8c94 100644
> --- a/drivers/target/iscsi/iscsi_target.h
> +++ b/drivers/target/iscsi/iscsi_target.h
> @@ -16,6 +16,7 @@ extern int iscsit_reset_np_thread(struct iscsi_np *, struct iscsi_tpg_np *,
>   				struct iscsi_portal_group *);
>   extern int iscsit_del_np(struct iscsi_np *);
>   extern int iscsit_add_reject_from_cmd(u8, int, int, unsigned char *, struct iscsi_cmd *);
> +extern void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *);
>   extern int iscsit_logout_closesession(struct iscsi_cmd *, struct iscsi_conn *);
>   extern int iscsit_logout_closeconnection(struct iscsi_cmd *, struct iscsi_conn *);
>   extern int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *, struct iscsi_conn *);
> diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
> index 0b52a23..8bf9d6d 100644
> --- a/drivers/target/iscsi/iscsi_target_erl1.c
> +++ b/drivers/target/iscsi/iscsi_target_erl1.c
> @@ -53,6 +53,9 @@ int iscsit_dump_data_payload(
>   	u32 length, padding, offset = 0, size;
>   	struct kvec iov;
>
> +	if (conn->sess->sess_ops->RDMAExtentions)
> +		return 0;
> +
>   	length = (buf_len > OFFLOAD_BUF_SIZE) ? OFFLOAD_BUF_SIZE : buf_len;
>
>   	buf = kzalloc(length, GFP_ATOMIC);
> @@ -999,10 +1002,7 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
>   			if (transport_check_aborted_status(se_cmd, 1) != 0)
>   				return 0;
>
> -			iscsit_set_dataout_sequence_values(cmd);
> -			spin_lock_bh(&cmd->dataout_timeout_lock);
> -			iscsit_start_dataout_timer(cmd, cmd->conn);
> -			spin_unlock_bh(&cmd->dataout_timeout_lock);
> +			iscsit_set_unsoliticed_dataout(cmd);
>   		}
>   		return transport_handle_cdb_direct(&cmd->se_cmd);
>
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 4a86034..e547277 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -316,6 +316,7 @@ int iscsit_sequence_cmd(
>
>   	return ret;
>   }
> +EXPORT_SYMBOL(iscsit_sequence_cmd);
>
>   int iscsit_check_unsolicited_dataout(struct iscsi_cmd *cmd, unsigned char *buf)
>   {
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
