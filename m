From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 11/12] scsi: ufs: add trace event for ufs commands
Date: Tue, 13 Dec 2016 15:22:06 -0500
Message-ID: <20161213152206.79e78435@gandalf.local.home>
References: <1481658740-32292-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481658740-32292-1-git-send-email-subhashj@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Lee Susman <lsusman@codeaurora.org>, Ingo Molnar <mingo@redhat.com>, Sahitya Tummala <stummala@codeaurora.org>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 13 Dec 2016 11:52:16 -0800
Subhash Jadavani <subhashj@codeaurora.org> wrote:

> From: Lee Susman <lsusman@codeaurora.org>
> 
> Use the ftrace infrastructure to conditionally trace ufs command events.
> New trace event is created, which samples the following ufs command data:
> - device name
> - optional identification string
> - task tag
> - doorbell register
> - number of transfer bytes
> - interrupt status register
> - request start LBA
> - command opcode
> 
> Currently we only fully trace read(10) and write(10) commands.
> All other commands which pass through ufshcd_send_command() will be
> printed with "-1" in the lba and transfer_len fields.
> 
> Usage:
> 	echo 1 > /sys/kernel/debug/tracing/events/ufs/enable
> 	cat /sys/kernel/debug/tracing/trace_pipe
> 
> Signed-off-by: Lee Susman <lsusman@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c  | 52 +++++++++++++++++++++++++++++++++++++++++++++-
>  include/trace/events/ufs.h | 38 +++++++++++++++++++++++++++++++++
>  2 files changed, 89 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 33f3947..926d1ef 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -301,6 +301,51 @@ static inline void ufshcd_remove_non_printable(char *val)
>  		*val = ' ';
>  }
>  
> +#ifdef CONFIG_TRACEPOINTS
> +static void ufshcd_add_command_trace(struct ufs_hba *hba,
> +		unsigned int tag, const char *str)

Is this function only to use if you enable the tracepoint? Is there
anything here doing something that wouldn't be enabled if tracing
wasn't configured in?

Also, if this is in a code execution path, it appears that you do this
work regardless if the tracer is running or not.

> +{
> +	sector_t lba = -1;
> +	u8 opcode = 0;
> +	u32 intr, doorbell;
> +	struct ufshcd_lrb *lrbp;
> +	int transfer_len = -1;
> +
> +	lrbp = &hba->lrb[tag];
> +
> +	if (lrbp->cmd) { /* data phase exists */
> +		opcode = (u8)(*lrbp->cmd->cmnd);
> +		if ((opcode == READ_10) || (opcode == WRITE_10)) {
> +			/*
> +			 * Currently we only fully trace read(10) and write(10)
> +			 * commands
> +			 */
> +			if (lrbp->cmd->request && lrbp->cmd->request->bio)
> +				lba =
> +				  lrbp->cmd->request->bio->bi_iter.bi_sector;
> +			transfer_len = be32_to_cpu(
> +				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
> +		}
> +	}
> +
> +	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> +	doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> +	trace_ufshcd_command(dev_name(hba->dev), str, tag,
> +				doorbell, transfer_len, intr, lba, opcode);
> +}
> +
> +static inline void ufshcd_cond_add_cmd_trace(struct ufs_hba *hba,
> +					unsigned int tag, const char *str)
> +{
> +	ufshcd_add_command_trace(hba, tag, str);
> +}
> +#else
> +static inline void ufshcd_cond_add_cmd_trace(struct ufs_hba *hba,
> +					unsigned int tag, const char *str)
> +{
> +}
> +#endif

If my above assumptions are correct, I recommend removing the above
#if, and have it always configured. Then...

> +
>  static void ufshcd_print_host_regs(struct ufs_hba *hba)
>  {
>  	/*
> @@ -1193,6 +1238,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
>  	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>  	/* Make sure that doorbell is committed immediately */
>  	wmb();

Add:

	if (trace_ufshcd_command_enabled())
		ufshcd_cond_add_cmd_trace(hba, task_tag, "send");

For one thing, the function only gets called if the tracepoint
ufshcd_command is enabled.

Now if CONFIG_TRACEPOINTS is not configured in, then the
trace_ufshcd_command_enabled() turns into a "return false;" which one
would hope that gcc will take that as a if (0) and optimized the entire
function out of existence.

This would make the code a bit cleaner and accomplish the same.

-- Steve


>  }
>  
>  /**
> @@ -3982,6 +4028,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>  		lrbp = &hba->lrb[index];
>  		cmd = lrbp->cmd;
>  		if (cmd) {
> +			ufshcd_cond_add_cmd_trace(hba, index, "complete");
>  			result = ufshcd_transfer_rsp_status(hba, lrbp);
>  			scsi_dma_unmap(cmd);
>  			cmd->result = result;
> @@ -3993,8 +4040,11 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>  			__ufshcd_release(hba);
>  		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
>  			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
> -			if (hba->dev_cmd.complete)
> +			if (hba->dev_cmd.complete) {
> +				ufshcd_cond_add_cmd_trace(hba, index,
> +						"dev_complete");
>  				complete(hba->dev_cmd.complete);
> +			}
>  		}
>  	}
>  
> diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
> index 8bce504..d0ed0cf 100644
> --- a/include/trace/events/ufs.h
> +++ b/include/trace/events/ufs.h
> @@ -183,6 +183,44 @@
>  	     TP_PROTO(const char *dev_name, int err, s64 usecs,
>  		      const char *dev_state, const char *link_state),
>  	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
> +
> +TRACE_EVENT(ufshcd_command,
> +	TP_PROTO(const char *dev_name, const char *str, unsigned int tag,
> +			u32 doorbell, int transfer_len, u32 intr, u64 lba,
> +			u8 opcode),
> +
> +	TP_ARGS(dev_name, str, tag, doorbell, transfer_len, intr, lba, opcode),
> +
> +	TP_STRUCT__entry(
> +		__string(dev_name, dev_name)
> +		__string(str, str)
> +		__field(unsigned int, tag)
> +		__field(u32, doorbell)
> +		__field(int, transfer_len)
> +		__field(u32, intr)
> +		__field(u64, lba)
> +		__field(u8, opcode)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev_name, dev_name);
> +		__assign_str(str, str);
> +		__entry->tag = tag;
> +		__entry->doorbell = doorbell;
> +		__entry->transfer_len = transfer_len;
> +		__entry->intr = intr;
> +		__entry->lba = lba;
> +		__entry->opcode = opcode;
> +	),
> +
> +	TP_printk(
> +		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x",
> +		__get_str(str), __get_str(dev_name), __entry->tag,
> +		__entry->doorbell, __entry->transfer_len,
> +		__entry->intr, __entry->lba, (u32)__entry->opcode
> +	)
> +);
> +
>  #endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
>  
>  /* This part must be outside protection */
