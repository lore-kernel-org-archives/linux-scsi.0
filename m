From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/5] be2iscsi: Fix processing CQE before connection resources
 are freed
Date: Wed, 27 Aug 2014 15:53:05 +0200
Message-ID: <53FDE2C1.7090801@suse.de>
References: <1407474003-26220-1-git-send-email-jkallickal@emulex.com> <1407474003-26220-4-git-send-email-jkallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbaH0NxH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 09:53:07 -0400
In-Reply-To: <1407474003-26220-4-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jay Kallickal <jayamohank@gmail.com>, jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 08/08/2014 07:00 AM, Jay Kallickal wrote:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>
>   Driver should process the completion queue entries before a connect=
ion
>   resources are freed. While running mixed traffic due to latency, dr=
iver
>   processes the CQE after the connection resources are freed. This fi=
x
>   processes all the completion queue before the connection resources =
are
>   freed.
>
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>   drivers/scsi/be2iscsi/be_iscsi.c | 29 +++++++++++++++++++++++++++++
>   drivers/scsi/be2iscsi/be_main.c  | 15 ++++++++++++++-
>   drivers/scsi/be2iscsi/be_main.h  |  3 +++
>   3 files changed, 46 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi=
/be_iscsi.c
> index e25203e..b7391a3 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -1274,6 +1274,31 @@ int beiscsi_ep_poll(struct iscsi_endpoint *ep,=
 int timeout_ms)
>   }
>
>   /**
> + * beiscsi_flush_cq()- Flush the CQ created.
> + * @phba: ptr device priv structure.
> + *
> + * Before the connection resource are freed flush
> + * all the CQ enteries
> + **/
> +static void beiscsi_flush_cq(struct beiscsi_hba *phba)
> +{
> +	uint16_t i;
> +	struct be_eq_obj *pbe_eq;
> +	struct hwi_controller *phwi_ctrlr;
> +	struct hwi_context_memory *phwi_context;
> +
> +	phwi_ctrlr =3D phba->phwi_ctrlr;
> +	phwi_context =3D phwi_ctrlr->phwi_ctxt;
> +
> +	for (i =3D 0; i < phba->num_cpus; i++) {
> +		pbe_eq =3D &phwi_context->be_eq[i];
> +		blk_iopoll_disable(&pbe_eq->iopoll);
> +		beiscsi_process_cq(pbe_eq);
> +		blk_iopoll_enable(&pbe_eq->iopoll);
> +	}
> +}
> +
> +/**
>    * beiscsi_close_conn - Upload the  connection
>    * @ep: The iscsi endpoint
>    * @flag: The type of connection closure
> @@ -1294,6 +1319,10 @@ static int beiscsi_close_conn(struct  beiscsi_=
endpoint *beiscsi_ep, int flag)
>   	}
>
>   	ret =3D beiscsi_mccq_compl(phba, tag, NULL, NULL);
> +
> +	/* Flush the CQ entries */
> +	beiscsi_flush_cq(phba);
> +
>   	return ret;
>   }
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index 8f9f625..cbc9fc2 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2068,7 +2068,7 @@ static void  beiscsi_process_mcc_isr(struct bei=
scsi_hba *phba)
>    * return
>    *     Number of Completion Entries processed.
>    **/
> -static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
> +unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
>   {
>   	struct be_queue_info *cq;
>   	struct sol_cqe *sol;
> @@ -2110,6 +2110,18 @@ static unsigned int beiscsi_process_cq(struct =
be_eq_obj *pbe_eq)
>
>   		cri_index =3D BE_GET_CRI_FROM_CID(cid);
>   		ep =3D phba->ep_array[cri_index];
> +
> +		if (ep =3D=3D NULL) {
> +			/* connection has already been freed
> +			 * just move on to next one
> +			 */
> +			beiscsi_log(phba, KERN_WARNING,
> +				    BEISCSI_LOG_INIT,
> +				    "BM_%d : proc cqe of disconn ep: cid %d\n",
> +				    cid);
> +			goto proc_next_cqe;
> +		}
> +
>   		beiscsi_ep =3D ep->dd_data;
>   		beiscsi_conn =3D beiscsi_ep->conn;
>
> @@ -2219,6 +2231,7 @@ static unsigned int beiscsi_process_cq(struct b=
e_eq_obj *pbe_eq)
>   			break;
>   		}
>
> +proc_next_cqe:
>   		AMAP_SET_BITS(struct amap_sol_cqe, valid, sol, 0);
>   		queue_tail_inc(cq);
>   		sol =3D queue_tail_node(cq);
> diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/=
be_main.h
> index 1e3428a..5f8b0fc 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -840,6 +840,9 @@ void beiscsi_free_mgmt_task_handles(struct beiscs=
i_conn *beiscsi_conn,
>   void hwi_ring_cq_db(struct beiscsi_hba *phba,
>   		     unsigned int id, unsigned int num_processed,
>   		     unsigned char rearm, unsigned char event);
> +
> +unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq);
> +
>   static inline bool beiscsi_error(struct beiscsi_hba *phba)
>   {
>   	return phba->ue_detected || phba->fw_timeout;
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
