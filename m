From: Boaz Harrosh <openosd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] libiscsi, iser: Adjust data_length to include
 protection information
Date: Sun, 27 Jul 2014 13:08:43 +0300
Message-ID: <53D4CFAB.3040804@gmail.com>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402477799-24610-3-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 06/11/2014 12:09 PM, Sagi Grimberg wrote:
> In case protection information exists over the wire
> iscsi header data length is required to include it.
> Use protection information aware scsi helpers to set
> the correct transfer length.
> 
> In order to avoid breakage, remove iser transfer length
> checks for each task as they are not always true and
> somewhat redundant anyway.
> 
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
> ---
>  drivers/infiniband/ulp/iser/iser_initiator.c |   34 +++++++------------------
>  drivers/scsi/libiscsi.c                      |   18 +++++++-------
>  2 files changed, 19 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
> index 2e2d903..8d44a40 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -41,11 +41,11 @@
>  #include "iscsi_iser.h"
>  
>  /* Register user buffer memory and initialize passive rdma
> - *  dto descriptor. Total data size is stored in
> - *  iser_task->data[ISER_DIR_IN].data_len
> + *  dto descriptor. Data size is stored in
> + *  task->data[ISER_DIR_IN].data_len, Protection size
> + *  os stored in task->prot[ISER_DIR_IN].data_len
>   */
> -static int iser_prepare_read_cmd(struct iscsi_task *task,
> -				 unsigned int edtl)
> +static int iser_prepare_read_cmd(struct iscsi_task *task)
>  
>  {
>  	struct iscsi_iser_task *iser_task = task->dd_data;
> @@ -73,14 +73,6 @@ static int iser_prepare_read_cmd(struct iscsi_task *task,
>  			return err;
>  	}
>  
> -	if (edtl > iser_task->data[ISER_DIR_IN].data_len) {
> -		iser_err("Total data length: %ld, less than EDTL: "
> -			 "%d, in READ cmd BHS itt: %d, conn: 0x%p\n",
> -			 iser_task->data[ISER_DIR_IN].data_len, edtl,
> -			 task->itt, iser_task->ib_conn);
> -		return -EINVAL;
> -	}
> -
>  	err = device->iser_reg_rdma_mem(iser_task, ISER_DIR_IN);
>  	if (err) {
>  		iser_err("Failed to set up Data-IN RDMA\n");
> @@ -100,8 +92,9 @@ static int iser_prepare_read_cmd(struct iscsi_task *task,
>  }
>  
>  /* Register user buffer memory and initialize passive rdma
> - *  dto descriptor. Total data size is stored in
> - *  task->data[ISER_DIR_OUT].data_len
> + *  dto descriptor. Data size is stored in
> + *  task->data[ISER_DIR_OUT].data_len, Protection size
> + *  is stored at task->prot[ISER_DIR_OUT].data_len
>   */
>  static int
>  iser_prepare_write_cmd(struct iscsi_task *task,
> @@ -135,14 +128,6 @@ iser_prepare_write_cmd(struct iscsi_task *task,
>  			return err;
>  	}
>  
> -	if (edtl > iser_task->data[ISER_DIR_OUT].data_len) {
> -		iser_err("Total data length: %ld, less than EDTL: %d, "
> -			 "in WRITE cmd BHS itt: %d, conn: 0x%p\n",
> -			 iser_task->data[ISER_DIR_OUT].data_len,
> -			 edtl, task->itt, task->conn);
> -		return -EINVAL;
> -	}
> -
>  	err = device->iser_reg_rdma_mem(iser_task, ISER_DIR_OUT);
>  	if (err != 0) {
>  		iser_err("Failed to register write cmd RDMA mem\n");
> @@ -417,11 +402,12 @@ int iser_send_command(struct iscsi_conn *conn,
>  	if (scsi_prot_sg_count(sc)) {
>  		prot_buf->buf  = scsi_prot_sglist(sc);
>  		prot_buf->size = scsi_prot_sg_count(sc);
> -		prot_buf->data_len = sc->prot_sdb->length;
> +		prot_buf->data_len = data_buf->data_len >>
> +				     ilog2(sc->device->sector_size) * 8;
>  	}
>  
>  	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
> -		err = iser_prepare_read_cmd(task, edtl);
> +		err = iser_prepare_read_cmd(task);
>  		if (err)
>  			goto send_command_error;
>  	}
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 26dc005..3f46234 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -338,7 +338,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>  	struct iscsi_session *session = conn->session;
>  	struct scsi_cmnd *sc = task->sc;
>  	struct iscsi_scsi_req *hdr;
> -	unsigned hdrlength, cmd_len;
> +	unsigned hdrlength, cmd_len, transfer_length;

I hate that you introduced this new transfer_length variable. It does
not exist. In BIDI supporting driver there is out_len and in_len just
as original code.

>  	itt_t itt;
>  	int rc;
>  
> @@ -391,11 +391,11 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>  	if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
>  		task->protected = true;
>  
> +	transfer_length = scsi_transfer_length(sc);
> +	hdr->data_length = cpu_to_be32(transfer_length);
>  	if (sc->sc_data_direction == DMA_TO_DEVICE) {
> -		unsigned out_len = scsi_out(sc)->length;

In light of all the comments and the obvious bugs, please just
re do this patch. Do not just later fix this one.

All you need is:
+		unsigned out_len = scsi_transfer_length(sc ,scsi_out(sc));

Also I would love if you left the addition to the user .I.E

		out_len += scsi_proto_length(sc ,scsi_out(sc));

This way we can see that this addition is because of scsi_proto and that
this particular driver puts them together in the same payload. There can be
other DIFF supporting drivers that put the DIFF payload on another stream / another
SG list, like the sata one, right?

Then  scsi_transfer_length() becomes:
static inline unsigned scsi_proto_length(struct scsi_cmnd *scmd, scsi_data_buffer *sdb)
{
	unsigned int prot_op = scsi_get_prot_op(scmd);
	unsigned int sector_size = scmd->device->sector_size;

	switch (prot_op) {
	case SCSI_PROT_NORMAL:
	case SCSI_PROT_WRITE_STRIP:
	case SCSI_PROT_READ_INSERT:
		return 0;
	}

	return (sdb->length >> ilog2(sector_size)) * 8;
}


>  		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
>  
> -		hdr->data_length = cpu_to_be32(out_len);

And this stays as is

>  		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
>  		/*
>  		 * Write counters:
> @@ -414,18 +414,19 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>  		memset(r2t, 0, sizeof(*r2t));
>  
>  		if (session->imm_data_en) {
> -			if (out_len >= session->first_burst)
> +			if (transfer_length >= session->first_burst)

And this stays as is

>  				task->imm_count = min(session->first_burst,
>  							conn->max_xmit_dlength);
>  			else
> -				task->imm_count = min(out_len,
> -							conn->max_xmit_dlength);
> +				task->imm_count = min(transfer_length,
> +						      conn->max_xmit_dlength);

And this stays as is

>  			hton24(hdr->dlength, task->imm_count);
>  		} else
>  			zero_data(hdr->dlength);
>  
>  		if (!session->initial_r2t_en) {
> -			r2t->data_length = min(session->first_burst, out_len) -
> +			r2t->data_length = min(session->first_burst,
> +					       transfer_length) -

And this stays as is

>  					       task->imm_count;
>  			r2t->data_offset = task->imm_count;
>  			r2t->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
> @@ -438,7 +439,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>  	} else {
>  		hdr->flags |= ISCSI_FLAG_CMD_FINAL;
>  		zero_data(hdr->dlength);
> -		hdr->data_length = cpu_to_be32(scsi_in(sc)->length);

And this stays as is

BTW: When reading DIFF devices, don't you have extra bits to read as well?
     How does the DIFF read works? Please get me up to speed. I'm not familiar
     with this protocol? 
     (I'd imagine that if say an app reads X bytes with DIFF info, it wants to
      receive its DIFF checksome for every sector in X, where is this info
      on the iscsi wire?)

>  
>  		if (sc->sc_data_direction == DMA_FROM_DEVICE)
>  			hdr->flags |= ISCSI_FLAG_CMD_READ;
> @@ -466,7 +466,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>  			  scsi_bidi_cmnd(sc) ? "bidirectional" :
>  			  sc->sc_data_direction == DMA_TO_DEVICE ?
>  			  "write" : "read", conn->id, sc, sc->cmnd[0],
> -			  task->itt, scsi_bufflen(sc),
> +			  task->itt, transfer_length,

And this

This print is correct as it covers all cases. If you want to print the adjusted
length then OK, you'd need to store this I guess, but store it as a different
variable like proto_length and print it as an additional variable.
The current print is one-to-one with what the caller requested, FS wrote X bytes.
If any was added for proto I'd like to see both prints.

>  			  scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
>  			  session->cmdsn,
>  			  session->max_cmdsn - session->exp_cmdsn + 1);
> 


Rrrr

I see that this patch is already in mainline. I'd like to see the fixing
patch reverting all these wrong changes to the code and only leaving
the single needed change above.

I'll send a PATCH over linus/master later today.

Thanks
Boaz

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
