From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [patch -next] csiostor: off by one error
Date: Mon, 25 Mar 2013 17:30:04 +0530
Message-ID: <51503C44.9070904@chelsio.com>
References: <20130316100755.GB10825@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:7055 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3CYMAT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Mar 2013 08:00:19 -0400
In-Reply-To: <20130316100755.GB10825@longonot.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "David S. Miller" <davem@davemloft.net>, Arvind Bhushan <arvindb@chelsio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kbuild@01.org" <kbuild@01.org>

On 3/16/2013 3:37 PM, Dan Carpenter wrote:
> We need to store PROTO_ERR_IMPL_LOGO (26) things here, but the
> first element isn't used so the array should have 27 elements.
> This matches fwevt_to_rnevt[] which has 27 elements.
> 
> The patch solves a Smatch static checker warning on my system:
> drivers/scsi/csiostor/csio_rnode.c:880 csio_rnode_fwevt_handler()
> 	error: buffer overflow '(rn)->stats.n_evt_fw' 26 <= 26
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This goes on top of d69630e8a4222 "csiostor: Header file
> modifications for chip support and bug fixes." That patch is in
> linux-next but I don't know which tree it came from.  It's not
> the scsi for-next tree.
> 
> diff --git a/drivers/scsi/csiostor/csio_rnode.h b/drivers/scsi/csiostor/csio_rnode.h
> index 6594009..4334342 100644
> --- a/drivers/scsi/csiostor/csio_rnode.h
> +++ b/drivers/scsi/csiostor/csio_rnode.h
> @@ -63,7 +63,7 @@ struct csio_rnode_stats {
>  	uint32_t	n_err_nomem;	/* error nomem */
>  	uint32_t	n_evt_unexp;	/* unexpected event */
>  	uint32_t	n_evt_drop;	/* unexpected event */
> -	uint32_t	n_evt_fw[PROTO_ERR_IMPL_LOGO];	/* fw events */
> +	uint32_t	n_evt_fw[PROTO_ERR_IMPL_LOGO + 1];	/* fw events */
>  	enum csio_rn_ev	n_evt_sm[CSIO_RNFE_MAX_EVENT];	/* State m/c events */
>  	uint32_t	n_lun_rst;	/* Number of resets of
>  					 * of LUNs under this
> diff --git a/drivers/scsi/csiostor/csio_lnode.h b/drivers/scsi/csiostor/csio_lnode.h
> index 0f9c041..372a67d 100644
> --- a/drivers/scsi/csiostor/csio_lnode.h
> +++ b/drivers/scsi/csiostor/csio_lnode.h
> @@ -114,7 +114,7 @@ struct csio_lnode_stats {
>  	uint32_t	n_rnode_match;  /* matched rnode */
>  	uint32_t	n_dev_loss_tmo; /* Device loss timeout */
>  	uint32_t	n_fdmi_err;	/* fdmi err */
> -	uint32_t	n_evt_fw[PROTO_ERR_IMPL_LOGO];	/* fw events */
> +	uint32_t	n_evt_fw[PROTO_ERR_IMPL_LOGO + 1];	/* fw events */
>  	enum csio_ln_ev	n_evt_sm[CSIO_LNE_MAX_EVENT];	/* State m/c events */
>  	uint32_t	n_rnode_alloc;	/* rnode allocated */
>  	uint32_t	n_rnode_free;	/* rnode freed */
> 

Acked-by: Naresh Kumar Inna <naresh@chelsio.com>

Thanks,
Naresh.
