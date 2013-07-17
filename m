From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH V3 1/2] scsi: ufs: Add support for sending NOP OUT UPIU
Date: Wed, 17 Jul 2013 17:13:40 +0900
Message-ID: <001a01ce82c5$8bd47d50$a37d77f0$%jun@samsung.com>
References: <1373361310-30674-1-git-send-email-sthumma@codeaurora.org>
 <1373361310-30674-2-git-send-email-sthumma@codeaurora.org>
 <002501ce7d71$4c7a8f40$e56fadc0$%jun@samsung.com>
 <51DE7D08.9000306@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13801 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3GQIN4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jul 2013 04:13:56 -0400
In-reply-to: <51DE7D08.9000306@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Sujit Reddy Thumma' <sthumma@codeaurora.org>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 'Dolev Raviv' <draviv@codeaurora.org>

On Thu, July 11, 2013, Sujit Reddy Thumma wrote:
> On 7/10/2013 6:58 PM, Seungwon Jeon wrote:
> > On Tue, July 09, 2013, Sujit Reddy Thumma wrote:
> >> As part of device initialization sequence, sending NOP OUT UPIU and
> >> waiting for NOP IN UPIU response is mandatory. This confirms that the
> >> device UFS Transport (UTP) layer is functional and the host can configure
> >> the device with further commands. Add support for sending NOP OUT UPIU to
> >> check the device connection path and test whether the UTP layer on the
> >> device side is functional during initialization.
> >>
> >> A tag is acquired from the SCSI tag map space in order to send the device
> >> management command. When the tag is acquired by internal command the scsi
> >> command is rejected with host busy flag in order to requeue the request.
> >> To avoid frequent collisions between internal commands and scsi commands
> >> the device management command tag is allocated in the opposite direction
> >> w.r.t block layer tag allocation.
> >>
> >> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> >> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> >> ---
> >>   drivers/scsi/ufs/ufs.h    |   43 +++-
> >>   drivers/scsi/ufs/ufshcd.c |  596 +++++++++++++++++++++++++++++++++++++--------
> >>   drivers/scsi/ufs/ufshcd.h |   29 ++-
> >>   3 files changed, 552 insertions(+), 116 deletions(-)
> >>
> >> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> >> index 139bc06..14c0a4e 100644
> >> --- a/drivers/scsi/ufs/ufs.h
> >> +++ b/drivers/scsi/ufs/ufs.h
> >> @@ -36,10 +36,16 @@
> >>   #ifndef _UFS_H
> >>   #define _UFS_H
> >>
> >> +#include <linux/mutex.h>
> >> +#include <linux/types.h>
> >> +
> >>   #define MAX_CDB_SIZE	16
> >> +#define GENERAL_UPIU_REQUEST_SIZE 32
> >> +#define UPIU_HEADER_DATA_SEGMENT_MAX_SIZE	((ALIGNED_UPIU_SIZE) - \
> >> +					(GENERAL_UPIU_REQUEST_SIZE))
> >>
> >>   #define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
> >> -			((byte3 << 24) | (byte2 << 16) |\
> >> +			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
> >>   			 (byte1 << 8) | (byte0))
> >>
> >>   /*
> >> @@ -73,6 +79,7 @@ enum {
> >>   	UPIU_TRANSACTION_TASK_RSP	= 0x24,
> >>   	UPIU_TRANSACTION_READY_XFER	= 0x31,
> >>   	UPIU_TRANSACTION_QUERY_RSP	= 0x36,
> >> +	UPIU_TRANSACTION_REJECT_UPIU	= 0x3F,
> >>   };
> >>
> >>   /* UPIU Read/Write flags */
> >> @@ -110,6 +117,12 @@ enum {
> >>   	UPIU_COMMAND_SET_TYPE_QUERY	= 0x2,
> >>   };
> >>
> >> +/* UTP Transfer Request Command Offset */
> >> +#define UPIU_COMMAND_TYPE_OFFSET	28
> >> +
> >> +/* Offset of the response code in the UPIU header */
> >> +#define UPIU_RSP_CODE_OFFSET		8
> >> +
> >>   enum {
> >>   	MASK_SCSI_STATUS	= 0xFF,
> >>   	MASK_TASK_RESPONSE	= 0xFF00,
> >> @@ -138,26 +151,32 @@ struct utp_upiu_header {
> >>
> >>   /**
> >>    * struct utp_upiu_cmd - Command UPIU structure
> >> - * @header: UPIU header structure DW-0 to DW-2
> >>    * @data_transfer_len: Data Transfer Length DW-3
> >>    * @cdb: Command Descriptor Block CDB DW-4 to DW-7
> >>    */
> >>   struct utp_upiu_cmd {
> >> -	struct utp_upiu_header header;
> >>   	u32 exp_data_transfer_len;
> >>   	u8 cdb[MAX_CDB_SIZE];
> >>   };
> >>
> >>   /**
> >> - * struct utp_upiu_rsp - Response UPIU structure
> >> - * @header: UPIU header DW-0 to DW-2
> >> + * struct utp_upiu_req - general upiu request structure
> >> + * @header:UPIU header structure DW-0 to DW-2
> >> + * @sc: fields structure for scsi command DW-3 to DW-7
> >> + */
> >> +struct utp_upiu_req {
> >> +	struct utp_upiu_header header;
> >> +	struct utp_upiu_cmd sc;
> >> +};
> >> +
> >> +/**
> >> + * struct utp_cmd_rsp - Response UPIU structure
> >>    * @residual_transfer_count: Residual transfer count DW-3
> >>    * @reserved: Reserved double words DW-4 to DW-7
> >>    * @sense_data_len: Sense data length DW-8 U16
> >>    * @sense_data: Sense data field DW-8 to DW-12
> >>    */
> >> -struct utp_upiu_rsp {
> >> -	struct utp_upiu_header header;
> >> +struct utp_cmd_rsp {
> >>   	u32 residual_transfer_count;
> >>   	u32 reserved[4];
> >>   	u16 sense_data_len;
> >> @@ -165,6 +184,16 @@ struct utp_upiu_rsp {
> >>   };
> >>
> >>   /**
> >> + * struct utp_upiu_rsp - general upiu response structure
> >> + * @header: UPIU header structure DW-0 to DW-2
> >> + * @sr: fields structure for scsi command DW-3 to DW-12
> >> + */
> >> +struct utp_upiu_rsp {
> >> +	struct utp_upiu_header header;
> >> +	struct utp_cmd_rsp sr;
> >> +};
> >> +
> >> +/**
> >>    * struct utp_upiu_task_req - Task request UPIU structure
> >>    * @header - UPIU header structure DW0 to DW-2
> >>    * @input_param1: Input parameter 1 DW-3
> >> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> >> index b743bd6..3f482b6 100644
> >> --- a/drivers/scsi/ufs/ufshcd.c
> >> +++ b/drivers/scsi/ufs/ufshcd.c
> >> @@ -43,6 +43,11 @@
> >>   /* UIC command timeout, unit: ms */
> >>   #define UIC_CMD_TIMEOUT	500
> >>
> >> +/* NOP OUT retries waiting for NOP IN response */
> >> +#define NOP_OUT_RETRIES    10
> >> +/* Timeout after 30 msecs if NOP OUT hangs without response */
> >> +#define NOP_OUT_TIMEOUT    30 /* msecs */
> >> +
> >>   enum {
> >>   	UFSHCD_MAX_CHANNEL	= 0,
> >>   	UFSHCD_MAX_ID		= 1,
> >> @@ -71,6 +76,47 @@ enum {
> >>   	INT_AGGR_CONFIG,
> >>   };
> >>
> >> +/*
> >> + * ufshcd_wait_for_register - wait for register value to change
> >> + * @hba - per-adapter interface
> >> + * @reg - mmio register offset
> >> + * @mask - mask to apply to read register value
> >> + * @val - wait condition
> >> + * @interval_us - polling interval in microsecs
> >> + * @timeout_ms - timeout in millisecs
> >> + *
> >> + * Returns final register value after iteration
> >> + */
> >> +static u32 ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
> >> +		u32 val, unsigned long interval_us, unsigned long timeout_ms)
> > I feel like this function's role is to wait for clearing register (specially, doorbells).
> > If you really don't intend to apply other all register, I think it would better to change the
> function name.
> > ex> ufshcd_wait_for_clear_doorbell or ufshcd_wait_for_clear_reg?
> 
> Although, this API is introduced in this patch and used only for
> clearing the doorbell, I have intentionally made it generic to avoid
> duplication of wait condition code in future (not just clearing but
> also for setting a bit). For example, when we write to HCE.ENABLE we
> wait for it turn to 1.
> 
> 
> > And if you like it, it could be more simple like below
> >
> > static bool ufshcd_wait_for_clear_reg(struct ufs_hba *hba, u32 reg, u32 mask,
> >                                           unsigned long interval_us,
> >                                           unsigned int timeout_ms)
> > {
> >          unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
> 
> Jiffies on 100Hz systems have minimum granularity of 10ms. So we really
> wait for more 10ms even though the timeout_ms < 10ms.
Yes. Real timeout depends on system.
But normally actual wait will be maintained until 'ufshcd_readl' is done.
Timeout is valid for failure case.  If we don't need to apply a strict timeout value, it's not bad.

> 
> >          /* wakeup within 50us of expiry */
> >          const unsigned int expiry = 50;
> >
> >          while (ufshcd_readl(hba, reg) & mask) {
> >                  usleep_range(interval_us, interval_us + expiry);
> >                  if (time_after(jiffies, timeout)) {
> >                          if (ufshcd_readl(hba, reg) & mask)
> >                                  return false;
> 
> I really want the caller to decide on what to do after the timeout.
> This helps in error handling cases where we try to clear off the entire
> door-bell register but only a few of the bits are cleared after timeout.
I don't know what we can do with the report of the partial success on clearing bit.
It's just failure case. Isn't enough with false/true?

> 
> >                          else
> >                                  return true;
> >                  }
> >          }
> >
> >          return true;
> > }
> >> +{
> >> +	u32 tmp;
> >> +	ktime_t start;
> >> +	unsigned long diff;
> >> +
> >> +	tmp = ufshcd_readl(hba, reg);
> >> +
> >> +	if ((val & mask) != val) {
> >> +		dev_err(hba->dev, "%s: Invalid wait condition 0x%x\n",
> >> +				__func__, val);
> >> +		goto out;
> >> +	}
> >> +
> >> +	start = ktime_get();
> >> +	while ((tmp & mask) != val) {
> >> +		/* wakeup within 50us of expiry */
> >> +		usleep_range(interval_us, interval_us + 50);
> >> +		tmp = ufshcd_readl(hba, reg);
> >> +		diff = ktime_to_ms(ktime_sub(ktime_get(), start));
> >> +		if (diff > timeout_ms) {
> >> +			tmp = ufshcd_readl(hba, reg);
> >> +			break;
> >> +		}
> >> +	}
> >> +out:
> >> +	return tmp;
> >> +}
> >> +
> >>   /**
> >>    * ufshcd_get_intr_mask - Get the interrupt bit mask
> >>    * @hba - Pointer to adapter instance
> >> @@ -191,18 +237,13 @@ static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
> >>   }
> >>
> >>   /**
> >> - * ufshcd_is_valid_req_rsp - checks if controller TR response is valid
> >> + * ufshcd_get_req_rsp - returns the TR response transaction type
> >>    * @ucd_rsp_ptr: pointer to response UPIU
> >> - *
> >> - * This function checks the response UPIU for valid transaction type in
> >> - * response field
> >> - * Returns 0 on success, non-zero on failure
> >>    */
> >>   static inline int
> >> -ufshcd_is_valid_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
> >> +ufshcd_get_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
> >>   {
> >> -	return ((be32_to_cpu(ucd_rsp_ptr->header.dword_0) >> 24) ==
> >> -		 UPIU_TRANSACTION_RESPONSE) ? 0 : DID_ERROR << 16;
> >> +	return be32_to_cpu(ucd_rsp_ptr->header.dword_0) >> 24;
> >>   }
> >>
> >>   /**
> >> @@ -299,9 +340,9 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
> >>   {
> >>   	int len;
> >>   	if (lrbp->sense_buffer) {
> >> -		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sense_data_len);
> >> +		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sr.sense_data_len);
> >>   		memcpy(lrbp->sense_buffer,
> >> -			lrbp->ucd_rsp_ptr->sense_data,
> >> +			lrbp->ucd_rsp_ptr->sr.sense_data,
> >>   			min_t(int, len, SCSI_SENSE_BUFFERSIZE));
> >>   	}
> >>   }
> >> @@ -519,76 +560,128 @@ static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
> >>   }
> >>
> >>   /**
> >> + * ufshcd_prepare_req_desc_hdr() - Fills the requests header
> >> + * descriptor according to request
> >> + * @lrbp: pointer to local reference block
> >> + * @upiu_flags: flags required in the header
> >> + * @cmd_dir: requests data direction
> >> + */
> >> +static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
> >> +		u32 *upiu_flags, enum dma_data_direction cmd_dir)
> >> +{
> >> +	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
> >> +	u32 data_direction;
> >> +	u32 dword_0;
> >> +
> >> +	if (cmd_dir == DMA_FROM_DEVICE) {
> >> +		data_direction = UTP_DEVICE_TO_HOST;
> >> +		*upiu_flags = UPIU_CMD_FLAGS_READ;
> >> +	} else if (cmd_dir == DMA_TO_DEVICE) {
> >> +		data_direction = UTP_HOST_TO_DEVICE;
> >> +		*upiu_flags = UPIU_CMD_FLAGS_WRITE;
> >> +	} else {
> >> +		data_direction = UTP_NO_DATA_TRANSFER;
> >> +		*upiu_flags = UPIU_CMD_FLAGS_NONE;
> >> +	}
> >> +
> >> +	dword_0 = data_direction | (lrbp->command_type
> >> +				<< UPIU_COMMAND_TYPE_OFFSET);
> >> +	if (lrbp->intr_cmd)
> >> +		dword_0 |= UTP_REQ_DESC_INT_CMD;
> >> +
> >> +	/* Transfer request descriptor header fields */
> >> +	req_desc->header.dword_0 = cpu_to_le32(dword_0);
> >> +
> >> +	/*
> >> +	 * assigning invalid value for command status. Controller
> >> +	 * updates OCS on command completion, with the command
> >> +	 * status
> >> +	 */
> >> +	req_desc->header.dword_2 =
> >> +		cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
> >> +}
> >> +
> >> +/**
> >> + * ufshcd_prepare_utp_scsi_cmd_upiu() - fills the utp_transfer_req_desc,
> >> + * for scsi commands
> >> + * @lrbp - local reference block pointer
> >> + * @upiu_flags - flags
> >> + */
> >> +static
> >> +void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
> >> +{
> >> +	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
> >> +
> >> +	/* command descriptor fields */
> >> +	ucd_req_ptr->header.dword_0 = UPIU_HEADER_DWORD(
> >> +				UPIU_TRANSACTION_COMMAND, upiu_flags,
> >> +				lrbp->lun, lrbp->task_tag);
> >> +	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
> >> +				UPIU_COMMAND_SET_TYPE_SCSI, 0, 0, 0);
> >> +
> >> +	/* Total EHS length and Data segment length will be zero */
> >> +	ucd_req_ptr->header.dword_2 = 0;
> >> +
> >> +	ucd_req_ptr->sc.exp_data_transfer_len =
> >> +		cpu_to_be32(lrbp->cmd->sdb.length);
> >> +
> >> +	memcpy(ucd_req_ptr->sc.cdb, lrbp->cmd->cmnd,
> >> +		(min_t(unsigned short, lrbp->cmd->cmd_len, MAX_CDB_SIZE)));
> >> +}
> >> +
> >> +static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
> >> +{
> >> +	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
> >> +
> >> +	memset(ucd_req_ptr, 0, sizeof(struct utp_upiu_req));
> >> +
> >> +	/* command descriptor fields */
> >> +	ucd_req_ptr->header.dword_0 =
> >> +		UPIU_HEADER_DWORD(
> >> +			UPIU_TRANSACTION_NOP_OUT, 0, 0, lrbp->task_tag);
> >> +}
> >> +
> >> +/**
> >>    * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
> >> + * @hba - per adapter instance
> >>    * @lrb - pointer to local reference block
> >>    */
> >> -static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
> >> +static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> >>   {
> >> -	struct utp_transfer_req_desc *req_desc;
> >> -	struct utp_upiu_cmd *ucd_cmd_ptr;
> >> -	u32 data_direction;
> >>   	u32 upiu_flags;
> >> -
> >> -	ucd_cmd_ptr = lrbp->ucd_cmd_ptr;
> >> -	req_desc = lrbp->utr_descriptor_ptr;
> >> +	int ret = 0;
> >>
> >>   	switch (lrbp->command_type) {
> >>   	case UTP_CMD_TYPE_SCSI:
> >> -		if (lrbp->cmd->sc_data_direction == DMA_FROM_DEVICE) {
> >> -			data_direction = UTP_DEVICE_TO_HOST;
> >> -			upiu_flags = UPIU_CMD_FLAGS_READ;
> >> -		} else if (lrbp->cmd->sc_data_direction == DMA_TO_DEVICE) {
> >> -			data_direction = UTP_HOST_TO_DEVICE;
> >> -			upiu_flags = UPIU_CMD_FLAGS_WRITE;
> >> +		if (likely(lrbp->cmd)) {
> >> +			ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
> >> +					lrbp->cmd->sc_data_direction);
> >> +			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
> >>   		} else {
> >> -			data_direction = UTP_NO_DATA_TRANSFER;
> >> -			upiu_flags = UPIU_CMD_FLAGS_NONE;
> >> +			ret = -EINVAL;
> >>   		}
> >> -
> >> -		/* Transfer request descriptor header fields */
> >> -		req_desc->header.dword_0 =
> >> -			cpu_to_le32(data_direction | UTP_SCSI_COMMAND);
> >> -
> >> -		/*
> >> -		 * assigning invalid value for command status. Controller
> >> -		 * updates OCS on command completion, with the command
> >> -		 * status
> >> -		 */
> >> -		req_desc->header.dword_2 =
> >> -			cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
> >> -
> >> -		/* command descriptor fields */
> >> -		ucd_cmd_ptr->header.dword_0 =
> >> -			cpu_to_be32(UPIU_HEADER_DWORD(UPIU_TRANSACTION_COMMAND,
> >> -						      upiu_flags,
> >> -						      lrbp->lun,
> >> -						      lrbp->task_tag));
> >> -		ucd_cmd_ptr->header.dword_1 =
> >> -			cpu_to_be32(
> >> -				UPIU_HEADER_DWORD(UPIU_COMMAND_SET_TYPE_SCSI,
> >> -						  0,
> >> -						  0,
> >> -						  0));
> >> -
> >> -		/* Total EHS length and Data segment length will be zero */
> >> -		ucd_cmd_ptr->header.dword_2 = 0;
> >> -
> >> -		ucd_cmd_ptr->exp_data_transfer_len =
> >> -			cpu_to_be32(lrbp->cmd->sdb.length);
> >> -
> >> -		memcpy(ucd_cmd_ptr->cdb,
> >> -		       lrbp->cmd->cmnd,
> >> -		       (min_t(unsigned short,
> >> -			      lrbp->cmd->cmd_len,
> >> -			      MAX_CDB_SIZE)));
> >>   		break;
> >>   	case UTP_CMD_TYPE_DEV_MANAGE:
> >> -		/* For query function implementation */
> >> +		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
> >> +		if (hba->dev_cmd.type == DEV_CMD_TYPE_NOP)
> >> +			ufshcd_prepare_utp_nop_upiu(lrbp);
> >> +		else
> >> +			ret = -EINVAL;
> >>   		break;
> >>   	case UTP_CMD_TYPE_UFS:
> >>   		/* For UFS native command implementation */
> >> +		ret = -ENOTSUPP;
> >> +		dev_err(hba->dev, "%s: UFS native command are not supported\n",
> >> +			__func__);
> >> +		break;
> >> +	default:
> >> +		ret = -ENOTSUPP;
> >> +		dev_err(hba->dev, "%s: unknown command type: 0x%x\n",
> >> +				__func__, lrbp->command_type);
> >>   		break;
> >>   	} /* end of switch */
> >> +
> >> +	return ret;
> >>   }
> >>
> >>   /**
> >> @@ -615,21 +708,37 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
> >>   		goto out;
> >>   	}
> >>
> >> +	/* acquire the tag to make sure device cmds don't use it */
> >> +	if (test_and_set_bit_lock(tag, &hba->lrb_in_use)) {
> >> +		/*
> >> +		 * Dev manage command in progress, requeue the command.
> >> +		 * Requeuing the command helps in cases where the request *may*
> >> +		 * find different tag instead of waiting for dev manage command
> >> +		 * completion.
> >> +		 */
> >> +		err = SCSI_MLQUEUE_HOST_BUSY;
> >> +		goto out;
> >> +	}
> >> +
> >>   	lrbp = &hba->lrb[tag];
> >>
> >> +	WARN_ON(lrbp->cmd);
> >>   	lrbp->cmd = cmd;
> >>   	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
> >>   	lrbp->sense_buffer = cmd->sense_buffer;
> >>   	lrbp->task_tag = tag;
> >>   	lrbp->lun = cmd->device->lun;
> >> -
> >> +	lrbp->intr_cmd = false;
> >>   	lrbp->command_type = UTP_CMD_TYPE_SCSI;
> >>
> >>   	/* form UPIU before issuing the command */
> >> -	ufshcd_compose_upiu(lrbp);
> >> +	ufshcd_compose_upiu(hba, lrbp);
> >>   	err = ufshcd_map_sg(lrbp);
> >> -	if (err)
> >> +	if (err) {
> >> +		lrbp->cmd = NULL;
> >> +		clear_bit_unlock(tag, &hba->lrb_in_use);
> >>   		goto out;
> >> +	}
> >>
> >>   	/* issue command to the controller */
> >>   	spin_lock_irqsave(hba->host->host_lock, flags);
> >> @@ -639,6 +748,198 @@ out:
> >>   	return err;
> >>   }
> >>
> >> +static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
> >> +		struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int tag)
> >> +{
> >> +	lrbp->cmd = NULL;
> >> +	lrbp->sense_bufflen = 0;
> >> +	lrbp->sense_buffer = NULL;
> >> +	lrbp->task_tag = tag;
> >> +	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
> >> +	lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
> >> +	lrbp->intr_cmd = true; /* No interrupt aggregation */
> >> +	hba->dev_cmd.type = cmd_type;
> >> +
> >> +	return ufshcd_compose_upiu(hba, lrbp);
> >> +}
> >> +
> >> +static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
> >> +		struct ufshcd_lrb *lrbp, int max_timeout)
> >> +{
> >> +	int err = 0;
> >> +	unsigned long timeout;
> >> +	unsigned long flags;
> >> +
> >> +	timeout = wait_for_completion_timeout(hba->dev_cmd.complete,
> >> +			msecs_to_jiffies(max_timeout));
> >> +
> >> +	spin_lock_irqsave(hba->host->host_lock, flags);
> >> +	hba->dev_cmd.complete = NULL;
> >> +	if (timeout)
> >> +		err = ufshcd_get_tr_ocs(lrbp);
> >> +	else
> >> +		err = -ETIMEDOUT;
> >> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >> +
> >> +	return err;
> >> +}
> >> +
> >> +static int
> >> +ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
> >> +{
> >> +	int err = 0;
> >> +	unsigned long flags;
> >> +	u32 reg;
> >> +	u32 mask = 1 << tag;
> >> +
> >> +	/* clear outstanding transaction before retry */
> >> +	spin_lock_irqsave(hba->host->host_lock, flags);
> >> +	ufshcd_utrl_clear(hba, tag);
> >> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >> +
> >> +	/*
> >> +	 * wait for for h/w to clear corresponding bit in door-bell.
> >> +	 * max. wait is 1 sec.
> >> +	 */
> >> +	reg = ufshcd_wait_for_register(hba,
> >> +			REG_UTP_TRANSFER_REQ_DOOR_BELL,
> >> +			mask, 0, 1000, 1000);
> > 4th argument should be (~mask) instead of '0', right?
> 
> True, but not really for this implementation. It breaks the check in
> in wait_for_register -
> if ((val & mask) != val)
>             dev_err(...);
Hmm, it seems complicated to use.
Ok. Is right the following about val as 4th argument?
- clear: val  should be '0' regardless corresponding bit.
- set: val should be same with mask.
If the related comment is added, it will be helpful.

> 
> > Actually, mask value involves the corresponding bit to be cleared.
> > So, 4th argument may be unnecessary.
> 
> As I described above, the wait_for_register can also be used to
> check if the value is set or not. In which case, we need 4th argument.
> 
> >
> >> +	if ((reg & mask) == mask)
> >> +		err = -ETIMEDOUT;
> > Also, checking the result can be involved in ufshcd_wait_for_register.
Any comment?

> >
> >> +
> >> +	return err;
> >> +}
> >> +
> >> +/**
> >> + * ufshcd_dev_cmd_completion() - handles device management command responses
> >> + * @hba: per adapter instance
> >> + * @lrbp: pointer to local reference block
> >> + */
> >> +static int
> >> +ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> >> +{
> >> +	int resp;
> >> +	int err = 0;
> >> +
> >> +	resp = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
> >> +
> >> +	switch (resp) {
> >> +	case UPIU_TRANSACTION_NOP_IN:
> >> +		if (hba->dev_cmd.type != DEV_CMD_TYPE_NOP) {
> >> +			err = -EINVAL;
> >> +			dev_err(hba->dev, "%s: unexpected response %x\n",
> >> +					__func__, resp);
> >> +		}
> >> +		break;
> >> +	case UPIU_TRANSACTION_REJECT_UPIU:
> >> +		/* TODO: handle Reject UPIU Response */
> >> +		err = -EPERM;
> >> +		dev_err(hba->dev, "%s: Reject UPIU not fully implemented\n",
> >> +				__func__);
> >> +		break;
> >> +	default:
> >> +		err = -EINVAL;
> >> +		dev_err(hba->dev, "%s: Invalid device management cmd response: %x\n",
> >> +				__func__, resp);
> >> +		break;
> >> +	}
> >> +
> >> +	return err;
> >> +}
> >> +
> >> +/**
> >> + * ufshcd_get_dev_cmd_tag - Get device management command tag
> >> + * @hba: per-adapter instance
> >> + * @tag: pointer to variable with available slot value
> >> + *
> >> + * Get a free slot and lock it until device management command
> >> + * completes.
> >> + *
> >> + * Returns false if free slot is unavailable for locking, else
> >> + * return true with tag value in @tag.
> >> + */
> >> +static bool ufshcd_get_dev_cmd_tag(struct ufs_hba *hba, int *tag_out)
> >> +{
> >> +	int tag;
> >> +	bool ret = false;
> >> +	unsigned long tmp;
> >> +
> >> +	if (!tag_out)
> >> +		goto out;
> >> +
> >> +	do {
> >> +		tmp = ~hba->lrb_in_use;
> >> +		tag = find_last_bit(&tmp, hba->nutrs);
> >> +		if (tag >= hba->nutrs)
> >> +			goto out;
> >> +	} while (test_and_set_bit_lock(tag, &hba->lrb_in_use));
> >> +
> >> +	*tag_out = tag;
> >> +	ret = true;
> >> +out:
> >> +	return ret;
> >> +}
> >> +
> >> +static inline void ufshcd_put_dev_cmd_tag(struct ufs_hba *hba, int tag)
> >> +{
> >> +	clear_bit_unlock(tag, &hba->lrb_in_use);
> >> +}
> >> +
> >> +/**
> >> + * ufshcd_exec_dev_cmd - API for sending device management requests
> >> + * @hba - UFS hba
> >> + * @cmd_type - specifies the type (NOP, Query...)
> >> + * @timeout - time in seconds
> >> + *
> >> + * NOTE: There is only one available tag for device management commands. Thus
> >> + * synchronisation is the responsibilty of the user.
> >> + */
> >> +static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
> >> +		enum dev_cmd_type cmd_type, int timeout)
> >> +{
> >> +	struct ufshcd_lrb *lrbp;
> >> +	int err;
> >> +	int tag;
> >> +	struct completion wait;
> >> +	unsigned long flags;
> >> +
> >> +	/*
> >> +	 * Get free slot, sleep if slots are unavailable.
> >> +	 * Even though we use wait_event() which sleeps indefinitely,
> >> +	 * the maximum wait time is bounded by SCSI request timeout.
> >> +	 */
> >> +	wait_event(hba->dev_cmd.tag_wq, ufshcd_get_dev_cmd_tag(hba, &tag));
> >> +
> >> +	init_completion(&wait);
> >> +	lrbp = &hba->lrb[tag];
> >> +	WARN_ON(lrbp->cmd);
> >> +	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
> >> +	if (unlikely(err))
> >> +		goto out_put_tag;
> >> +
> >> +	hba->dev_cmd.complete = &wait;
> >> +
> >> +	spin_lock_irqsave(hba->host->host_lock, flags);
> >> +	ufshcd_send_command(hba, tag);
> >> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >> +
> >> +	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
> >> +
> > <snip>
> >> +	if (err == -ETIMEDOUT) {
> >> +		if (!ufshcd_clear_cmd(hba, tag))
> >> +			err = -EAGAIN;
> >> +	} else if (!err) {
> >> +		spin_lock_irqsave(hba->host->host_lock, flags);
> >> +		err = ufshcd_dev_cmd_completion(hba, lrbp);
> >> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> >> +	}
> > </snip>
> > I think sniped part can be involved in ufshcd_wait_for_dev_cmd.
> > How do you think about that?
> 
> Yes, it can be moved.
> 
> >
> >> +
> >> +out_put_tag:
> >> +	ufshcd_put_dev_cmd_tag(hba, tag);
> >> +	wake_up(&hba->dev_cmd.tag_wq);
> >> +	return err;
> >> +}
> >> +
> >>   /**
> >>    * ufshcd_memory_alloc - allocate memory for host memory space data structures
> >>    * @hba: per adapter instance
> >> @@ -774,8 +1075,8 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
> >>   				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> >>
> >>   		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
> >> -		hba->lrb[i].ucd_cmd_ptr =
> >> -			(struct utp_upiu_cmd *)(cmd_descp + i);
> >> +		hba->lrb[i].ucd_req_ptr =
> >> +			(struct utp_upiu_req *)(cmd_descp + i);
> >>   		hba->lrb[i].ucd_rsp_ptr =
> >>   			(struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
> >>   		hba->lrb[i].ucd_prdt_ptr =
> >> @@ -961,6 +1262,38 @@ out:
> >>   }
> >>
> >>   /**
> >> + * ufshcd_validate_dev_connection() - Check device connection status
> >> + * @hba: per-adapter instance
> >> + *
> >> + * Send NOP OUT UPIU and wait for NOP IN response to check whether the
> >> + * device Transport Protocol (UTP) layer is ready after a reset.
> >> + * If the UTP layer at the device side is not initialized, it may
> >> + * not respond with NOP IN UPIU within timeout of %NOP_OUT_TIMEOUT
> >> + * and we retry sending NOP OUT for %NOP_OUT_RETRIES iterations.
> >> + */
> >> +static int ufshcd_validate_dev_connection(struct ufs_hba *hba)
> > I think ufshcd_verify_dev_init is close to standard description.
> >
> 
> Okay.
> 
> >> +{
> >> +	int err = 0;
> >> +	int retries;
> >> +
> >> +	mutex_lock(&hba->dev_cmd.lock);
> >> +	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
> >> +		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
> >> +					       NOP_OUT_TIMEOUT);
> >> +
> >> +		if (!err || err == -ETIMEDOUT)
> >> +			break;
> >> +
> >> +		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
> >> +	}
> >> +	mutex_unlock(&hba->dev_cmd.lock);
> >> +
> >> +	if (err)
> >> +		dev_err(hba->dev, "%s: NOP OUT failed %d\n", __func__, err);
> >> +	return err;
> >> +}
> >> +
> >> +/**
> >>    * ufshcd_do_reset - reset the host controller
> >>    * @hba: per adapter instance
> >>    *
> >> @@ -986,13 +1319,20 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
> >>   	for (tag = 0; tag < hba->nutrs; tag++) {
> >>   		if (test_bit(tag, &hba->outstanding_reqs)) {
> >>   			lrbp = &hba->lrb[tag];
> >> -			scsi_dma_unmap(lrbp->cmd);
> >> -			lrbp->cmd->result = DID_RESET << 16;
> >> -			lrbp->cmd->scsi_done(lrbp->cmd);
> >> -			lrbp->cmd = NULL;
> >> +			if (lrbp->cmd) {
> >> +				scsi_dma_unmap(lrbp->cmd);
> >> +				lrbp->cmd->result = DID_RESET << 16;
> >> +				lrbp->cmd->scsi_done(lrbp->cmd);
> >> +				lrbp->cmd = NULL;
> >> +				clear_bit_unlock(tag, &hba->lrb_in_use);
> >> +			}
> > I know above.
> > But there is no relation to this patch.
> > Can be it moved to scsi: ufs: Fix device and host reset methods?
> 
> Yes, but it is basically to avoid NULL pointer derefernce in case
> someone picks this patch but not the other one.
> 
> >
> >>   		}
> >>   	}
> >>
> >> +	/* complete device management command */
> >> +	if (hba->dev_cmd.complete)
> >> +		complete(hba->dev_cmd.complete);
> >> +
> >>   	/* clear outstanding request/task bit maps */
> >>   	hba->outstanding_reqs = 0;
> >>   	hba->outstanding_tasks = 0;
> >> @@ -1199,27 +1539,37 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> >>
> >>   	switch (ocs) {
> >>   	case OCS_SUCCESS:
> >> -
> >>   		/* check if the returned transfer response is valid */
> > As replaced with new function, comment isn't valid.
> > Remove or "get the TR response transaction type" seems proper.
> 
> Okay.
> 
> >
> >> -		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
> >> -		if (result) {
> >> +		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
> >> +
> >> +		switch (result) {
> >> +		case UPIU_TRANSACTION_RESPONSE:
> >> +			/*
> >> +			 * get the response UPIU result to extract
> >> +			 * the SCSI command status
> >> +			 */
> >> +			result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
> >> +
> >> +			/*
> >> +			 * get the result based on SCSI status response
> >> +			 * to notify the SCSI midlayer of the command status
> >> +			 */
> >> +			scsi_status = result & MASK_SCSI_STATUS;
> >> +			result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
> >> +			break;
> >> +		case UPIU_TRANSACTION_REJECT_UPIU:
> >> +			/* TODO: handle Reject UPIU Response */
> >> +			result = DID_ERROR << 16;
> >> +			dev_err(hba->dev,
> >> +				"Reject UPIU not fully implemented\n");
> >> +			break;
> >> +		default:
> >> +			result = DID_ERROR << 16;
> >>   			dev_err(hba->dev,
> >> -				"Invalid response = %x\n", result);
> >> +				"Unexpected request response code = %x\n",
> >> +				result);
> >>   			break;
> >>   		}
> >> -
> >> -		/*
> >> -		 * get the response UPIU result to extract
> >> -		 * the SCSI command status
> >> -		 */
> >> -		result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
> >> -
> >> -		/*
> >> -		 * get the result based on SCSI status response
> >> -		 * to notify the SCSI midlayer of the command status
> >> -		 */
> >> -		scsi_status = result & MASK_SCSI_STATUS;
> >> -		result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
> >>   		break;
> >>   	case OCS_ABORTED:
> >>   		result |= DID_ABORT << 16;
> >> @@ -1259,28 +1609,37 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
> >>    */
> >>   static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
> >>   {
> >> -	struct ufshcd_lrb *lrb;
> >> +	struct ufshcd_lrb *lrbp;
> >> +	struct scsi_cmnd *cmd;
> >>   	unsigned long completed_reqs;
> >>   	u32 tr_doorbell;
> >>   	int result;
> >>   	int index;
> >> +	bool int_aggr_reset = false;
> >>
> >> -	lrb = hba->lrb;
> >>   	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> >>   	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
> >>
> >>   	for (index = 0; index < hba->nutrs; index++) {
> >>   		if (test_bit(index, &completed_reqs)) {
> >> -
> >> -			result = ufshcd_transfer_rsp_status(hba, &lrb[index]);
> >> -
> >> -			if (lrb[index].cmd) {
> >> -				scsi_dma_unmap(lrb[index].cmd);
> >> -				lrb[index].cmd->result = result;
> >> -				lrb[index].cmd->scsi_done(lrb[index].cmd);
> >> -
> >> +			lrbp = &hba->lrb[index];
> >> +			cmd = lrbp->cmd;
> >> +			/* Don't reset counters for interrupt cmd */
> >> +			int_aggr_reset |= !lrbp->intr_cmd;
> >> +
> >> +			if (cmd) {
> >> +				result = ufshcd_transfer_rsp_status(hba, lrbp);
> >> +				scsi_dma_unmap(cmd);
> >> +				cmd->result = result;
> >>   				/* Mark completed command as NULL in LRB */
> >> -				lrb[index].cmd = NULL;
> >> +				lrbp->cmd = NULL;
> >> +				clear_bit_unlock(index, &hba->lrb_in_use);
> >> +				/* Do not touch lrbp after scsi done */
> >> +				cmd->scsi_done(cmd);
> >> +			} else if (lrbp->command_type ==
> >> +					UTP_CMD_TYPE_DEV_MANAGE) {
> >> +				if (hba->dev_cmd.complete)
> >> +					complete(hba->dev_cmd.complete);
> >>   			}
> >>   		} /* end of if */
> >>   	} /* end of for */
> >> @@ -1288,8 +1647,12 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
> >>   	/* clear corresponding bits of completed commands */
> >>   	hba->outstanding_reqs ^= completed_reqs;
> >>
> >> +	/* we might have free'd some tags above */
> >> +	wake_up(&hba->dev_cmd.tag_wq);
> >> +
> >>   	/* Reset interrupt aggregation counters */
> >> -	ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
> >> +	if (int_aggr_reset)
> >> +		ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
> > Do you assume that interrupt command(device management command) is completed alone?
> > Of course, interrupt command is not counted in aggregation unlike regular command.
> > We need to consider that interrupt command comes along with regular command?
> > If right, ufshcd_config_int_aggr should not be skipped.
> 
> True. We are not skipping it. int_aggr_reset will be false only when
> there is single interrupt command completed.
> 
> Check the above part which reads -
> for_all_completed_commands() {
>   int_aggr_reset |= !lrbp->intr_cmd;
> }
> 
> Even if one of the command in the iteration is not interrupt command
> (lrbp->intr_cmd is false) then int_aggr_reset is always true.
Clear!
But I confused it with your comment line. (/* Don't reset counters for interrupt cmd */)
How about changing like below?
'Don't skip to reset counters if a regular command is present'

Thanks,
Seungwon Jeon

