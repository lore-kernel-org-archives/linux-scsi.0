From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH] zfcp: convert to use the data buffer accessors
Date: Tue, 31 Jul 2007 12:08:52 +0200
Message-ID: <200707311208.52308.swen@vnet.ibm.com>
References: <20070729164628S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:60732 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbXGaKII (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 06:08:08 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.8/8.13.8) with ESMTP id l6VA86x7171768
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 10:08:06 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6VA7wYP1740994
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 12:08:06 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6VA7gs5012608
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 12:07:42 +0200
In-Reply-To: <20070729164628S.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Replying to the mailing-list as well.

ACK

On Sunday 29 July 2007 09:46, FUJITA Tomonori wrote:
> The patch is only compile tested.
> 
> ---
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] zfcp: convert to use the data buffer accessors
> 
> - remove the unnecessary map_single path.
> 
> - convert to use the new accessors for the sg lists and the
> parameters.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/s390/scsi/zfcp_fsf.c  |    5 +++--
>  drivers/s390/scsi/zfcp_qdio.c |   41 ++++++-----------------------------------
>  2 files changed, 9 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index b240800..9929997 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -4154,8 +4154,9 @@ zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *fsf_req)
>  			      fcp_rsp_iu->fcp_resid,
>  			      (int) zfcp_get_fcp_dl(fcp_cmnd_iu));
> 
> -		scpnt->resid = fcp_rsp_iu->fcp_resid;
> -		if (scpnt->request_bufflen - scpnt->resid < scpnt->underflow)
> +		scsi_set_resid(scpnt, fcp_rsp_iu->fcp_resid);
> +		if (scsi_bufflen(scpnt) - scsi_get_resid(scpnt) <
> +		    scpnt->underflow)
>  			set_host_byte(&scpnt->result, DID_ERROR);
>  	}
> 
> diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
> index c408bad..81daa82 100644
> --- a/drivers/s390/scsi/zfcp_qdio.c
> +++ b/drivers/s390/scsi/zfcp_qdio.c
> @@ -36,8 +36,6 @@ static void zfcp_qdio_sbale_fill
>  	(struct zfcp_fsf_req *, unsigned long, void *, int);
>  static int zfcp_qdio_sbals_from_segment
>  	(struct zfcp_fsf_req *, unsigned long, void *, unsigned long);
> -static int zfcp_qdio_sbals_from_buffer
> -	(struct zfcp_fsf_req *, unsigned long, void *, unsigned long, int);
> 
>  static qdio_handler_t zfcp_qdio_request_handler;
>  static qdio_handler_t zfcp_qdio_response_handler;
> @@ -632,28 +630,6 @@ out:
> 
> 
>  /**
> - * zfcp_qdio_sbals_from_buffer - fill SBALs from buffer
> - * @fsf_req: request to be processed
> - * @sbtype: SBALE flags
> - * @buffer: data buffer
> - * @length: length of buffer
> - * @max_sbals: upper bound for number of SBALs to be used
> - */
> -static int
> -zfcp_qdio_sbals_from_buffer(struct zfcp_fsf_req *fsf_req, unsigned long sbtype,
> -			    void *buffer, unsigned long length, int max_sbals)
> -{
> -	struct scatterlist sg_segment;
> -
> -	zfcp_address_to_sg(buffer, &sg_segment);
> -	sg_segment.length = length;
> -
> -	return zfcp_qdio_sbals_from_sg(fsf_req, sbtype, &sg_segment, 1,
> -                                       max_sbals);
> -}
> -
> -
> -/**
>   * zfcp_qdio_sbals_from_scsicmnd - fill SBALs from scsi command
>   * @fsf_req: request to be processed
>   * @sbtype: SBALE flags
> @@ -664,18 +640,13 @@ int
>  zfcp_qdio_sbals_from_scsicmnd(struct zfcp_fsf_req *fsf_req,
>  			      unsigned long sbtype, struct scsi_cmnd *scsi_cmnd)
>  {
> -	if (scsi_cmnd->use_sg) {
> +	if (scsi_sg_count(scsi_cmnd))
>  		return zfcp_qdio_sbals_from_sg(fsf_req,	sbtype,
> -                                               (struct scatterlist *)
> -                                               scsi_cmnd->request_buffer,
> -                                               scsi_cmnd->use_sg,
> -                                               ZFCP_MAX_SBALS_PER_REQ);
> -	} else {
> -                return zfcp_qdio_sbals_from_buffer(fsf_req, sbtype,
> -                                                   scsi_cmnd->request_buffer,
> -                                                   scsi_cmnd->request_bufflen,
> -                                                   ZFCP_MAX_SBALS_PER_REQ);
> -	}
> +					       scsi_sglist(scsi_cmnd),
> +					       scsi_sg_count(scsi_cmnd),
> +					       ZFCP_MAX_SBALS_PER_REQ);
> +	else
> +		return 0;
>  }
> 
>  /**
