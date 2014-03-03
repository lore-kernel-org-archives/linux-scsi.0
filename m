From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH v1 11/13] SCSI/libiscsi: Add check_protection callback
 for transports
Date: Sun, 02 Mar 2014 22:41:35 -0600
Message-ID: <531407FF.1040702@cs.wisc.edu>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com> <1393499589-15633-12-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393499589-15633-12-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 02/27/2014 05:13 AM, Sagi Grimberg wrote:
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 4046241..a58a6bb 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -395,6 +395,10 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>  		if (rc)
>  			return rc;
>  	}
> +
> +	if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
> +		task->protected = true;
> +
>  	if (sc->sc_data_direction == DMA_TO_DEVICE) {
>  		unsigned out_len = scsi_out(sc)->length;
>  		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
> @@ -823,6 +827,33 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  
>  	sc->result = (DID_OK << 16) | rhdr->cmd_status;
>  
> +	if (task->protected) {
> +		sector_t sector;
> +		u8 ascq;
> +
> +		/**
> +		 * Transports that didn't implement check_protection
> +		 * callback but still published T10-PI support to scsi-mid
> +		 * deserve this BUG_ON.
> +		 **/
> +		 BUG_ON(!session->tt->check_protection);

Extra space before BUG_ON.

> +
> +		ascq = session->tt->check_protection(task, &sector);
> +		if (ascq) {
> +			sc->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
> +				     SAM_STAT_CHECK_CONDITION;

I am not sure what the reason for the DID_ABORT is here. I do not think
we want that, because we just want scsi-ml to evaluate the sense error
part of the failure. It works ok today, but the DID_ABORT error can
possibly be evaluated before the sense so you might miss passing that
info to upper layers.


> +			scsi_build_sense_buffer(1, sc->sense_buffer,
> +						ILLEGAL_REQUEST, 0x10, ascq);
> +			sc->sense_buffer[7] = 0xc; /* Additional sense length */
> +			sc->sense_buffer[8] = 0;   /* Information desc type */
> +			sc->sense_buffer[9] = 0xa; /* Additional desc length */
> +			sc->sense_buffer[10] = 0x80; /* Validity bit */
> +
> +			put_unaligned_be64(sector, &sc->sense_buffer[12]);
> +			goto out;
> +		}
> +	}
> +
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
