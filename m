From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/17] lpfc: Fix external loopback failure.
Date: Thu, 17 Dec 2015 09:33:36 +0100
Message-ID: <56727360.4080906@suse.de>
References: <5671efc4.p0ZuEBo3q81E+gY3%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbbLQIdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:33:37 -0500
In-Reply-To: <5671efc4.p0ZuEBo3q81E+gY3%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:12 AM, James Smart wrote:
>
> Fix external loopback failure.
>
> Rx sequence reassembly was incorrect.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sl=
i.c
> index e504d51..b4bff35 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -14849,10 +14849,12 @@ lpfc_fc_frame_add(struct lpfc_vport *vport,=
 struct hbq_dmabuf *dmabuf)
>   	struct lpfc_dmabuf *h_buf;
>   	struct hbq_dmabuf *seq_dmabuf =3D NULL;
>   	struct hbq_dmabuf *temp_dmabuf =3D NULL;
> +	uint8_t	found =3D 0;
>
>   	INIT_LIST_HEAD(&dmabuf->dbuf.list);
>   	dmabuf->time_stamp =3D jiffies;
>   	new_hdr =3D (struct fc_frame_header *)dmabuf->hbuf.virt;
> +
>   	/* Use the hdr_buf to find the sequence that this frame belongs to=
 */
>   	list_for_each_entry(h_buf, &vport->rcv_buffer_list, list) {
>   		temp_hdr =3D (struct fc_frame_header *)h_buf->virt;
> @@ -14892,7 +14894,8 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, s=
truct hbq_dmabuf *dmabuf)
>   		return seq_dmabuf;
>   	}
>   	/* find the correct place in the sequence to insert this frame */
> -	list_for_each_entry_reverse(d_buf, &seq_dmabuf->dbuf.list, list) {
> +	d_buf =3D list_entry(seq_dmabuf->dbuf.list.prev, typeof(*d_buf), li=
st);
> +	while (!found) {
>   		temp_dmabuf =3D container_of(d_buf, struct hbq_dmabuf, dbuf);
>   		temp_hdr =3D (struct fc_frame_header *)temp_dmabuf->hbuf.virt;
>   		/*
> @@ -14902,9 +14905,17 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, =
struct hbq_dmabuf *dmabuf)
>   		if (be16_to_cpu(new_hdr->fh_seq_cnt) >
>   			be16_to_cpu(temp_hdr->fh_seq_cnt)) {
>   			list_add(&dmabuf->dbuf.list, &temp_dmabuf->dbuf.list);
> -			return seq_dmabuf;
> +			found =3D 1;
> +			break;
>   		}
> +
> +		if (&d_buf->list =3D=3D &seq_dmabuf->dbuf.list)
> +			break;
> +		d_buf =3D list_entry(d_buf->list.prev, typeof(*d_buf), list);
>   	}
> +
> +	if (found)
> +		return seq_dmabuf;
>   	return NULL;
>   }
>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
