From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Wed, 25 Jun 2014 11:48:55 +0300
Message-ID: <53AA8CF7.8050102@dev.mellanox.co.il>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net> <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu> <53A9A702.8050503@dev.mellanox.co.il> <20140624163040.GA11499@infradead.org> <53A9AEB8.4040104@cs.wisc.edu> <53A9B0A0.6000103@cs.wisc.edu> <53AA42E6.3090101@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53AA42E6.3090101@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/25/2014 6:32 AM, Mike Christie wrote:
> On 06/24/2014 12:08 PM, Mike Christie wrote:
>> On 06/24/2014 12:00 PM, Mike Christie wrote:
>>> On 06/24/2014 11:30 AM, Christoph Hellwig wrote:
>>>> On Tue, Jun 24, 2014 at 07:27:46PM +0300, Sagi Grimberg wrote:
>>>>> This condition only matters in the bidi case, which is not
>>>>> relevant for the PI case. I suggested to condition that in
>>>>> libiscsi (posted in the second thread, copy-paste below).
>>>>> Although I do agree that scsi_transfer_length() helper is not
>>>>> really just for PI and not more. I think Mike's way is
>>>>> cleaner.
>>>> But for bidi there are two transfers.  So either
>>>> scsi_transfer_length() needs to take the scsi_data_buffer, or we
>>>>   need to avoid using it.
>>>>
>>>> For 3.16 I'd prefer something like you're patch below.  This
>>>> patch which has been rushed in last minute and not through the
>>>> scsi tree has already causes enough harm.  If you can come up
>>>> with a clean version to transparently handle the bidi case I'd be
>>>> happy to pick that up for 3.17.
>>>>
>>>> In the meantime please provide a version of the patch below with
>>>>   a proper description and signoff.
>>>>
>>> It would be nice to just have one function to call and it just do
>>> the right thing for the drivers. I am fine with Sagi's libiscsi
>>> patch for now though:
>>>
>>> Acked-by: Mike Christie <michaelc@cs.wisc.edu>
>> Actually, let me take this back for a second. I am not sure if that
>> is right.

Hey Mike,

> Sagi's patch was not correct because scsi_in was hardcoded to the transfer
> len when bidi was used.

Right, should have condition that in the direction. something like:

transfer_length = sc->sc_data_direction == DMA_TO_DEVICE ? 
scsi_out(sc)->length : scsi_in(sc)->length;

would probably hit that in testing before sending out a patch.

> I made the patch below which should fix both bidi
> support in iscsi and also WRITE_SAME (and similar commands) support.

I'm a bit confused, for all commands (bidi or not) the iscsi header data_length
should describe the scsi_data_buffer length, bidi information will lie in AHS header.
(in case bidi will ever co-exist with PI, we might need another helper that will look
in req->special + PI, something like scsi_bidi_transfer_length)

So why not keep scsi_transfer_length to work on sdb length (take scsi_bufflen(scmnd) or
scsi_out(scmnd)->length as MKP suggested) and that's it - don't touch libiscsi.

Let me test that.

> There is one issue/question though. Is this working ok with LIO? I left
> scsi_transfer_length() with the same behavior as before assuming LIO was
> ok and only the iscsi initiator had suffered a regression.

I think that if we go with scsi_in/out_transfer_length then 
scsi_transfer_length should be removed
and LIO can be modified to use scsi_in/out_transfer_length.

> ------------------
>
>
> [PATCH] iscsi/scsi: Fix transfer len calculation

I'll comment on the patch as well if we decide to go this way.

> This patch fixes the following regressions added in commit
> d77e65350f2d82dfa0557707d505711f5a43c8fd
>
> 1. The iscsi header data length is supposed to be the amount of
> data being transferred and not the total length of the operation
> like is given with blk_rq_bytes.
>
> 2. scsi_transfer_length is used in generic iscsi code paths, but
> did not take into account bidi commands.
>
> To fix both issues, this patch adds 2 new helpers that use the
> scsi_out/in(cmnd)->length values instead of blk_rq_bytes.
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 3d1bc67..ee79cdf 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -338,7 +338,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>   	struct iscsi_session *session = conn->session;
>   	struct scsi_cmnd *sc = task->sc;
>   	struct iscsi_scsi_req *hdr;
> -	unsigned hdrlength, cmd_len, transfer_length;
> +	unsigned hdrlength, cmd_len;
>   	itt_t itt;
>   	int rc;
>   
> @@ -391,11 +391,11 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>   	if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
>   		task->protected = true;
>   
> -	transfer_length = scsi_transfer_length(sc);
> -	hdr->data_length = cpu_to_be32(transfer_length);
>   	if (sc->sc_data_direction == DMA_TO_DEVICE) {
> +		unsigned out_len = scsi_out_transfer_length(sc);
>   		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
>   
> +		hdr->data_length = cpu_to_be32(out_len);
>   		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
>   		/*
>   		 * Write counters:
> @@ -414,19 +414,18 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>   		memset(r2t, 0, sizeof(*r2t));
>   
>   		if (session->imm_data_en) {
> -			if (transfer_length >= session->first_burst)
> +			if (out_len >= session->first_burst)
>   				task->imm_count = min(session->first_burst,
>   							conn->max_xmit_dlength);
>   			else
> -				task->imm_count = min(transfer_length,
> +				task->imm_count = min(out_len,
>   						      conn->max_xmit_dlength);
>   			hton24(hdr->dlength, task->imm_count);
>   		} else
>   			zero_data(hdr->dlength);
>   
>   		if (!session->initial_r2t_en) {
> -			r2t->data_length = min(session->first_burst,
> -					       transfer_length) -
> +			r2t->data_length = min(session->first_burst, out_len) -
>   					       task->imm_count;
>   			r2t->data_offset = task->imm_count;
>   			r2t->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
> @@ -439,6 +438,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>   	} else {
>   		hdr->flags |= ISCSI_FLAG_CMD_FINAL;
>   		zero_data(hdr->dlength);
> +		hdr->data_length = cpu_to_be32(scsi_in_transfer_length(sc));

In light of last comment from Vlad where bidi and PI may co-exist, 
shouldn't
scsi_in_transfer_length(sc) be used also in iscsi_prep_bidi_ahs()? and 
also in the print below?

>   
>   		if (sc->sc_data_direction == DMA_FROM_DEVICE)
>   			hdr->flags |= ISCSI_FLAG_CMD_READ;
> @@ -466,7 +466,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>   			  scsi_bidi_cmnd(sc) ? "bidirectional" :
>   			  sc->sc_data_direction == DMA_TO_DEVICE ?
>   			  "write" : "read", conn->id, sc, sc->cmnd[0],
> -			  task->itt, transfer_length,
> +			  task->itt, scsi_bufflen(sc),

In the DIF case length print would be wrong (doesn't include PI).

>   			  scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
>   			  session->cmdsn,
>   			  session->max_cmdsn - session->exp_cmdsn + 1);
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 42ed789..b04812d 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -316,9 +316,9 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
>   	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
>   }
>   
> -static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
> +static inline unsigned __scsi_calculate_transfer_length(struct scsi_cmnd *scmd,
> +							unsigned int xfer_len)
>   {
> -	unsigned int xfer_len = blk_rq_bytes(scmd->request);
>   	unsigned int prot_op = scsi_get_prot_op(scmd);
>   	unsigned int sector_size = scmd->device->sector_size;
>   
> @@ -332,4 +332,20 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
>   	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
>   }
>   
> +static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
> +{
> +	return __scsi_calculate_transfer_length(scmd,
> +						blk_rq_bytes(scmd->request));
> +}
> +
> +static inline unsigned scsi_in_transfer_length(struct scsi_cmnd *scmd)
> +{
> +	return __scsi_calculate_transfer_length(scmd, scsi_in(scmd)->length);
> +}
> +
> +static inline unsigned scsi_out_transfer_length(struct scsi_cmnd *scmd)
> +{
> +	return __scsi_calculate_transfer_length(scmd, scsi_out(scmd)->length);
> +}
> +
>   #endif /* _SCSI_SCSI_CMND_H */
>
>
